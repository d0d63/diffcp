#include <assert.h>
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <string.h>
#include <strings.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define WHY strerror(errno)
// #define BLOCKSIZE 1048576
#define BLOCKSIZE BUFSIZ

struct f_info_s
{
	char	*filename;
	char	buf[BLOCKSIZE];
	int	fd;
	size_t	offset,
		bytes_read,
		bytes_written,
		total_bytes_read,
		total_bytes_written;
	struct stat sb;
};

int
main (int argc, char **argv)
{
	int retval = 0;
	struct f_info_s src,
			dst;

	bzero(&src, sizeof(src));
	bzero(&dst, sizeof(dst));

	if (argc != 3)
	{
		fprintf(stderr, "Need two arguments\n");
		return 1;
	}

	src.filename = argv[1];
	dst.filename = argv[2];

	retval = stat(src.filename, &src.sb);
	if (retval != 0)
	{
		fprintf(stderr, "Can't stat src %s: %s\n", src.filename, WHY);
		return 1;
	}

	src.fd = open(src.filename, O_RDONLY);
	if (src.fd == -1)
	{
		fprintf(stderr, "Can't open src %s: %s\n", src.filename, WHY);
		return 1;
	}

	/* Need to have at least one open/close before going into the loop
	 * in case the source is zero bytes and the destination is more
	 * than that. Yay testing! \o/
	 */
	dst.fd = open(dst.filename, O_RDWR|O_CREAT, 0666);
	if (dst.fd == -1)
	{
		fprintf(stderr, "Can't open dst %s: %s\n", dst.filename, WHY);
		return 1;
	}

	retval = fstat(dst.fd, &dst.sb);
	if (retval != 0)
	{
		fprintf(stderr, "Can't stat dst %s: %s\n", dst.filename, WHY);
		return 1;
	}

	if (src.sb.st_size != dst.sb.st_size)
	{
		retval = ftruncate(dst.fd, src.sb.st_size);
		if (retval != 0)
		{
			fprintf(stderr, "Can't ftruncate dst %s: %s\n", dst.filename, WHY);
			return 1;
		}
	}
	close(dst.fd);

	for ( src.offset = 0; src.offset < src.sb.st_size; src.offset += BLOCKSIZE)
	{

		dst.fd = open(dst.filename, O_RDWR|O_CREAT, 0666);
		if (dst.fd == -1)
		{
			fprintf(stderr, "Can't open dst %s: %s\n", dst.filename, WHY);
			return 1;
		}

		retval = fstat(dst.fd, &dst.sb);
		if (retval != 0)
		{
			fprintf(stderr, "Can't stat dst %s: %s\n", dst.filename, WHY);
			return 1;
		}

		if (src.sb.st_size != dst.sb.st_size)
		{
			retval = ftruncate(dst.fd, src.sb.st_size);
			if (retval != 0)
			{
				fprintf(stderr, "Can't ftruncate dst %s: %s\n", dst.filename, WHY);
				return 1;
			}
		}

		src.bytes_read = read(src.fd, src.buf, BLOCKSIZE);
		if (src.bytes_read == -1)
		{
			fprintf(stderr, "Can't read from src %s: %s\n", src.filename, WHY);
			return 1;
		}
		src.total_bytes_read += src.bytes_read;

		dst.bytes_read = read(dst.fd, dst.buf, BLOCKSIZE);
		if (dst.bytes_read == -1)
		{
			fprintf(stderr, "Can't read from dst %s: %s\n", dst.filename, WHY);
			return 1;
		}

		retval = memcmp(src.buf, dst.buf, BLOCKSIZE);
		if (retval == 0)
		{
			/* They're the same, move on */
			dst.total_bytes_read += dst.bytes_read;
			printf("Same at offset %lld\n", (long long)src.offset);
			continue;
		}

		/* They're different, go back and write the src's data to
		 * the dst
		 */

		printf("Different at offset %lld\n", (long long)src.offset);

		retval = lseek(dst.fd, src.offset, SEEK_SET);
		if (retval == -1)
		{
			fprintf(stderr, "Can't lseek in dst %s: %s\n", dst.filename, WHY);
			return 1;
		}

		dst.bytes_written = write(dst.fd, src.buf, src.bytes_read);
		assert(dst.bytes_written == src.bytes_read);
		dst.total_bytes_written += dst.bytes_written;

		close(dst.fd);

	}

	close(dst.fd);
	close(src.fd);

	printf("Read %lld bytes, wrote %lld bytes, verified %lld bytes\n", (long long)src.total_bytes_read, (long long)dst.total_bytes_written, (long long)dst.total_bytes_read);

	return 0;
}

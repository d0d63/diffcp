# diffcp

Using rsync over CIFS to a moosefs server doesn't work well. I haven't
figured out which stage of the process is doing it, but the asynchronous
writes eventually timeout.

For every block in a file (default 8192 bytes), diffcp opens the
destination, seek(2)s to the end of the last offset, reads what's there, and
rewrites the block if it doesn't match the source. Then it closes the file
again, forcing a sync event. 

This is dumb. Nobody should need to do this. But here we are.

Only built and tested using Ubuntu 20.04 and ancient OpenBSD, but there are
extensive test cases. Build using `make`, and test using `make test`.


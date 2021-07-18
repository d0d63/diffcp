CFLAGS = -ggdb -Wall -Werror
SMALL_SMALLER = 8
SMALL_SAME = 16
SMALL_BIGGER = 32
LARGE_SMALLER = 524288
LARGE_SAME = 1048576
LARGE_BIGGER = 2091752

all: diffcp

diffcp:

clean:
	rm -f diffcp test-*

# tests:
#
# test dimensions:
#   - doesn't exist
#   - 0 bytes
#   - < 1 block
#   - > 1 block
#   - contents differ
#   - contents the same
#

# test		src		dst size,relative,content	expected
# test-00	np		np				failure
# test-01	np		0				failure
# test-02	np		small				failure
# test-03	np		large				failure
#
# test-04	0		np				success
# test-05	0		0				success
# test-06	0		small				success
# test-07	0		large				success
#
# test-08	small		np				success
# test-09	small		0				success
# test-10	small		small,smaller,different		success
# test-11	small		small,smaller,same		success
# test-12	small		small,same,different		success
# test-13	small		small,same,same			success
# test-14	small		small,bigger,different		success
# test-15	small		small,bigger,same		success
# test-16	small		large				success
#
# test-17	large		np				success
# test-18	large		0				success
# test-19	large		small				success
# test-20	large		large,smaller,different		success
# test-21	large		large,smaller,same		success
# test-22	large		large,same,different		success
# test-23	large		large,same,same			success
# test-24	large		large,bigger,different		success
# test-25	large		large,bigger,same		success


TESTS = test-00 test-01 test-02 test-03 test-04 test-05 test-06 test-07 test-08 test-09 \
	test-10 test-11 test-12 test-13 test-14 test-15 test-16 test-17 test-18 test-19 \
	test-20 test-21 test-22 test-23 test-24 test-25

test: diffcp $(TESTS)
	date

.PHONY: all clean test $$(TESTS)

############################################################################
# test		src		dst size,relative,content	expected
# test-00	np		np				failure
#
test-00: diffcp
	./diffcp test-00-src test-00-dst || true
	[ ! -e test-00-src ]
	[ ! -e test-00-dst ]
	echo "done $@"


############################################################################
# test		src		dst size,relative,content	expected
# test-01	np		0				failure

test-01-dst:
	touch $@

test-01: diffcp test-01-dst
	cp $@-dst $@-dst-bak
	./diffcp $@-src $@-dst || true
	[ ! -e $@-src ]
	[ -e $@-dst ]
	diff -q $@-dst $@-dst-bak
	echo "done $@"


############################################################################
# test		src		dst size,relative,content	expected
# test-02	np		small				failure

test-02-dst:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-02: diffcp test-02-dst
	cp $@-dst $@-dst-bak
	./diffcp $@-src $@-dst || true
	[ ! -e $@-src ]
	[ -e $@-dst ]
	diff -q $@-dst $@-dst-bak
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-03	np		large				failure

test-03-dst:
	dd if=/dev/urandom of=$@ bs=$(LARGE_SAME) count=1

test-03: diffcp test-03-dst
	cp test-03-dst test-03-dst-bak
	./diffcp test-03-src test-03-dst || true
	[ ! -e test-03-src ]
	[ -e test-03-dst ]
	diff -q test-03-dst test-03-dst-bak
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-04	0		np				success

test-04-src:
	touch $@

test-04: diffcp test-04-src
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-05	0		0				success

test-05-src:
	touch $@

test-05-dst:
	touch $@

test-05: diffcp test-05-src test-05-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-06	0		small				success

test-06-src:
	touch $@

test-06-dst:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-06: diffcp test-06-src test-06-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-07	0		large				success

test-07-src:
	touch $@

test-07-dst:
	dd if=/dev/urandom of=$@ bs=$(LARGE_SAME) count=1

test-07: diffcp test-07-src test-07-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-08	small		np				success

test-08-src:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-08: diffcp test-08-src
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-09	small		0				success

test-09-src:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-09-dst:
	touch $@

test-09: diffcp test-09-src test-09-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-10	small		small,smaller,different		success

test-10-src:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-10-dst:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SMALLER) count=1

test-10: diffcp test-10-src test-10-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-11	small		small,smaller,same		success

test-11-src:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-11-dst: test-11-src
	dd if=test-11-src of=$@ bs=$(SMALL_SMALLER) count=1

test-11: diffcp test-11-src test-11-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-12	small		small,same,different		success

test-12-src:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-12-dst: test-12-src
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-12: diffcp test-12-src test-12-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-13	small		small,same,same			success

test-13-src:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-13-dst: test-13-src
	dd if=test-13-src of=$@ bs=$(SMALL_SAME) count=1

test-13: diffcp test-13-src test-13-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-14	small		small,bigger,different		success

test-14-src:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-14-dst: test-14-src
	dd if=/dev/urandom of=$@ bs=$(SMALL_BIGGER) count=1

test-14: diffcp test-14-src test-14-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-15	small		small,bigger,same		success

test-15-src:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-15-dst: test-15-src
	cat test-15-src test-15-src > $@

test-15: diffcp test-15-src test-15-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-16	small		large				success

test-16-src:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-16-dst: test-16-src
	dd if=/dev/urandom of=$@ bs=$(LARGE_SAME) count=1

test-16: diffcp test-16-src test-16-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-17	large		np				success

test-17-src:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-17: diffcp test-17-src
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"


############################################################################
# test		src		dst size,relative,content	expected
# test-18	large		0				success

test-18-src:
	dd if=/dev/urandom of=$@ bs=$(LARGE_SAME) count=1

test-18-dst:
	touch $@

test-18: diffcp test-18-src test-18-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-19	large		small				success

test-19-src:
	dd if=/dev/urandom of=$@ bs=$(LARGE_SAME) count=1

test-19-dst:
	dd if=/dev/urandom of=$@ bs=$(SMALL_SAME) count=1

test-19: diffcp test-19-src test-19-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-20	large		large,smaller,different		success

test-20-src:
	dd if=/dev/urandom of=$@ bs=$(LARGE_SAME) count=1

test-20-dst:
	dd if=/dev/urandom of=$@ bs=$(LARGE_SMALLER) count=1

test-20: diffcp test-20-src test-20-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-21	large		large,smaller,same		success

test-21-src:
	dd if=/dev/urandom of=$@ bs=$(LARGE_SAME) count=1

test-21-dst:
	dd if=test-21-src of=$@ bs=$(LARGE_SMALLER) count=1

test-21: diffcp test-21-src test-21-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-22	large		large,same,different		success

test-22-src:
	dd if=/dev/urandom of=$@ bs=$(LARGE_SAME) count=1

test-22-dst:
	dd if=/dev/urandom of=$@ bs=$(LARGE_SAME) count=1

test-22: diffcp test-22-src test-22-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-23	large		large,same,same			success

test-23-src:
	dd if=/dev/urandom of=$@ bs=$(LARGE_SAME) count=1

test-23-dst: test-23-src
	dd if=test-23-src of=$@ bs=$(LARGE_SAME) count=1

test-23: diffcp test-23-src test-23-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-24	large		large,bigger,different		success

test-24-src:
	dd if=/dev/urandom of=$@ bs=$(LARGE_SAME) count=1

test-24-dst: test-24-src
	dd if=/dev/urandom of=$@ bs=$(LARGE_BIGGER) count=1

test-24: diffcp test-24-src test-24-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"

############################################################################
# test		src		dst size,relative,content	expected
# test-25	large		large,bigger,same		success

test-25-src:
	dd if=/dev/urandom of=$@ bs=$(LARGE_SAME) count=1

test-25-dst: test-25-src
	cat test-25-src test-25-src > $@

test-25: diffcp test-25-src test-25-dst
	cp $@-src $@-src-bak
	diff -q $@-src $@-src-bak
	./diffcp $@-src $@-dst
	diff -q $@-src $@-src-bak
	diff -q $@-src $@-dst
	echo "done $@"


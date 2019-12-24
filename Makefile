all: 
	dart bin/main.dart	

test:
	dart test/lsif_dart_test.dart

.PHONY: all test

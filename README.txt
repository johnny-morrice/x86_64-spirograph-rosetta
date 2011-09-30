x86_64 NASM OpenGL Rosetta Spirograph by John Morrice
All source code is available under the terms of the WTFPL (see LICENSE.txt)

This package presents a simple C graphics program, and a port of that code into
x86_64 NASM assembly.

My motivation for publishing this, is that I found it difficult to learn 64 bit assembly, due
to a shortage of code examples online.

x86 programmers should note that x86_64 assembly uses the AMD64 ABI calling
convention where parameters are passed in registers, rather than on the stack.

If you cannot work out how to write a spirograph in x86_64 assembler, then this
package is for you.  If you would find it easy, then I apologise for burning
your eyes with my naive assembly code.  It runs slower than the C version.

Ingredients:

gcc (I use 4.6.1 20110819)
nasm (I use 2.09.10)
rake (from ruby)
linux

To test that the c version is working, from package root:

cd c
rake test

To produce a benchmark program in c use:
cd c
rake bench
# time ./bench

The benchmark computes a vertex array of points on the spiral.

To build an optimized version in c:

cd c
rake build
# ./cspiro 0.2 0.3 0.4

The first parameter is the radius of the inner, moving circle.
The second is the radius of the outer circle.
The third is the offset of the pencil from the centre of the inner circle.

To test the assembler version is working, from package root:

cd asm
rake test

To assembly an optimized version in assembly:

cd asm
rake build
# ./asmspiro 0.1 0.7 0.4

Parameters are as for the C version

Likewise for benchmarking:

cd asm
rake bench
# time ./bench

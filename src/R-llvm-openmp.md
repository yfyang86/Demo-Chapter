#llvm-openmp

The story begins with sweat and tears.

My friend [Han](https://github.com/zhangh12) continued to maintain [ARTP2](https://github.com/zhangh12/ARTP2) and strugled with R v.s. llvm-tool-chain for OPENMP.

There is an old saying `People mountain people sea` in China. We did find tons of material talking
about this. There are even long blogs discussing using openmp in R, for example [this](http://www.r-bloggers.com/openmp-tutorial-with-r-interface/) one. But all of them are

1. on Linux;
2. on Mac/Windows with >= GCC-4.7.2 tool chain;

Non talks about a Mac-llvm method. Fairly enough, most Mac people around me even don't know there is a terminal or Mac is a kind of BSD. We spend a whole afternoon on compiling this LLVM-OPENMP-R tool chain. Here are some remarks.

0. Install X-code/X-code command line tools.
1. Follows this [Git](https://clang-omp.github.io/) page to install clang-omp.

 ```bash
 mkdir ~/LLVM
 cd ~/LLVM
 svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
 cd llvm/tools
 svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
 cd ../..
 cd llvm/tools/clang/tools
 svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
 cd ../../../..
 cd llvm/projects
 svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
 cd ../..
 mkdir build
 cd build
 cmake -G "Unix Makefiles" ../llvm
 make -j 2
 sudo make install
 cd ~/LLVM
 ehco "http://openmp.llvm.org/"
 svn co http://llvm.org/svn/llvm-project/openmp/trunk openmp
 cd openmp/runtime
 make compiler=clang
 find . -name "*.dylib"
 ```
 
Then copy the dylib and `export/common/include/*.h` to `/usr/local/lib` and `/usr/local/include` correspondingly(use `sudo cp`). Notice, `make compiler=gcc` will not work on Mac:

| OS             |   icc/icl     |    gcc      |   clang     |
|--------------|---------------|------------|----------------|
| Linux* OS   |   Yes(1,5)    |  Yes(2,4)   | Yes(4,6,7)   |
| FreeBSD*    |   No          |  No         | Yes(4,6,7,8) |
| OS X*       |   Yes(1,3,4)  |  No         | Yes(4,6,7)   |
| Windows* OS |   Yes(1,4)    |  No         | No           |

  
2. Now you may test a simple `t1.cpp` code:
 
 ```cpp
 #include <omp.h>
 #include <stdio.h>
 int main() {
 #pragma omp parallel
 printf("Hello from thread %d, nthreads %d\n", omp_get_thread_num(), omp_get_num_threads());
 }
 ```
 
 with `/usr/local/bin/clang++ -fopenmp -o t1 t1.cpp`. It should works without any problem.

3. But if you test any STD STL code, you may find it encounter as series problem, for example `can't find <iostream>`. DON'T PANIC. Let find where these header files are:
 
 ```bash
 find /usr/include -name "iostream"
 ```
 
 You may see its path, saying `/usr/include/c/include/x.y.z/iostream`. Now Let's prepare the R `Makevars`:
 
 ```bash
 nano ~/.R/Makevars
 ```
 modify CC and CXX to
 
 ```bash
 CC=/usr/loca/bin/clang -I/usr/include/c/include/x.y.z
 GCC=/usr/loca/bin/clang -I/usr/include/c/include/x.y.z
 ```
 
 Here `CC=/usr/loca/bin/clang -I/usr/include/c/include/x.y.z` is the path (exclude the iostream part) we locates just now. By doing this, `CC` and `GCC` won't disturb the system variables.
 
4. Now move on to your pacakge's `src` folder. Modified the Makevars like this:
 
 ```bash
 PKG_CXXFLAGS=-stdlib=libstdc++ -fopenmp
 PKG_CFLAGS=-fopenmp
 ```
 
 Notice, on most platforms, you should avoid use `-fopenmp`. But
 a. Clang++ needs this option: `-stdlib=libstdc++`;
 b. Tranditional variable `**LIB_OPENMP**` used on Win/Linux is a NULL value on Mac's pre-build R.
 
 
 

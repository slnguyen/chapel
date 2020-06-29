use cuBLAS;
use BLAS;
use Time;

require "cblas.h";
proc main() {


  /*
  type t = real(32);
  const D = {0..2};
  var X: [D] t = [1: t, 2: t, 3: t],
      Y: [D] t = [3: t, 2: t, 1: t];

  var a = 2: t;

  const Yin = Y;
  cu_axpy(X, Y, a);

  for i in 0..2 do
    writeln(Y[i]);
 */

  var timer: Timer;
  type t = real(32);
  var arrSizes = [2**1, 2**5, 2**10, 2**15, 2**20, 2**25, 2**30];
  //var arrSizes = [2, 4, 8, 16];
  var a = 2: t;

  for ind in 0..arrSizes.size-1 {
    //writeln(arrSizes[ind]);
    var X: [0..arrSizes[ind]-1] t = [i in [0..arrSizes[ind]-1]] 3: t;
    var Y: [0..arrSizes[ind]-1] t = [i in [0..arrSizes[ind]-1]] 4: t;

    timer.start();
    cu_axpy(X, Y, a);
    writeln("cu_axpy, N=", arrSizes[ind], " : ", timer.elapsed());
    timer.stop();
    timer.clear();

    timer.start();
    axpy(X, Y, a);
    writeln("axpy, N=", arrSizes[ind], " : ", timer.elapsed());
    timer.stop();
    timer.clear();

    //for i in 0..arrSizes[ind]-1 do
    //  writeln(Y[i]);

    //writeln("X = ", X, "\n");
    //writeln("Y = ", Y, "\n");
  }


}


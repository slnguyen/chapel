use cuBLAS;
use BLAS;
use Time;
use IO;

proc main() {

/*
  var X: [0..arrSizes[ind]-1] t = [i in [0..arrSizes[ind]-1]] 3: t;
  var Y: [0..arrSizes[ind]-1] t = [i in [0..arrSizes[ind]-1]] 4: t;

  timer.start();
  axpy(X, Y, a);
  timer.stop();

  var e = timer.elapsed()*1000;
  writeln("axpy, N=", arrSizes[ind], " : ", e);
  writingChannel.write(e, " ");
  timer.clear();
*/

  type t = real(32);
  var a = 2: t;

 // var X: [0..7] t = [i in [0..7]] 3: t;
 // var Y: [0..7] t = [i in [0..7]] 4: t;


  var X = cu_array(10:size_t);
  var Y = cu_array(10:size_t);

  var cublas_handle = cublas_create_handle();

//  cublas_destroy_handle(cublas_handle);

//  extern proc cublas_create(): c_void_ptr;
//  extern proc cublas_destroy(handle: c_void_ptr);

//  X = [i in [0..7]] 3: t;
//  Y = [i in [0..7]] 4: t;

  for i in 0..9 {
    X[i] = 3.0;
    Y[i] = 5.0;
  }

  writeln(X.type:string);
  writeln(X);

  writeln(Y.type:string);
  writeln(Y);

  writeln("-----");
  writeln(X[0]);
  writeln(X[1]);
  writeln(Y[0]);
  writeln(Y[1]);


  //X[0] = 1;
  //X = [i in [0..7]] 3: t;
  //Y = [i in [0..7]] 4: t;

  cu_axpy(cublas_handle, X, Y, a);
  
  cublas_destroy_handle(cublas_handle);
//  writeln(x);

//   var X = cu_array(10:size_t);

//  var X: [0..7] t;
//  var Y: [0..7] t;

//  var x1 = c_ptrTo(X[0]);
//  var y1 = c_ptrTo(Y[0]);

//  x1 = cu_array(X.size:size_t);
//  y1 = cu_array(Y.szie:size_t);
//  cu_array(x1, X.size:size_t);
//  cu_array(y1, Y.size:size_t);

//  X = [i in [0..7]] 3: t;
//  Y = [i in [0..7]] 4: t;

//  cu_axpy(X, Y, a);


  for i in 0..9 do
    writeln(Y[i]);
}

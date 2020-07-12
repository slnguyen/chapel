use cuBLAS;
use BLAS;
use Time;
use IO;

proc main() {

  type t = real(32);
  var a = 2: t;

  //allocate arrays
  var X = cu_array(10:size_t);
  var Y = cu_array(10:size_t);

  //create cublas handle
  var cublas_handle = cublas_create_handle();

  //put values in array
  for i in 0..9 {
    X[i] = 3.0;
    Y[i] = 5.0;
  }

  //use cublas saxpy
  cu_axpy(cublas_handle, X, Y, a);
  
  //destroy cublas handle
  cublas_destroy_handle(cublas_handle);

  //print result
  for i in 0..9 do
    writeln(Y[i]);

}

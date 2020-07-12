module cuBLAS {

  use C_CUBLAS;
  public use SysCTypes;

  //proc cu_array(X: c_ptr(?eltType), size: size_t){
  //proc cu_array(X: [?D]?eltType, size: size_t){
  proc cu_array(size: size_t){
     require "c_cublas.h", "c_cublas.o";
     //var X: [1..size] real;
     var x;
      //var z = 10;
     x = cublas_array(size);
     return x;
     //cublas_array(X, size);
  }

//  proc cu_axpy(X: c_ptr(c_float), Y: c_ptr(c_float), ref alpha: eltType, incX: c_int = 1, incY: c_int = 1)
//  proc cu_axpy(X: [?D]?eltType, Y: [D]eltType, ref alpha: eltType, incX: c_int = 1, incY: c_int = 1)
//  proc cu_axpy(X: c_ptr(c_float), Y: c_ptr(c_float), ref alpha: eltType, incX: c_int = 1, incY: c_int = 1)

  proc cu_axpy(X: c_ptr(c_float), Y: c_ptr(c_float), ref alpha: c_float, incX: c_int = 1, incY: c_int = 1)
    //where D.rank == 1
  {
    require "c_cublas.h", "c_cublas.o";

    const N = 10:int(32);
    cublas_saxpy(N, alpha, X, incX, Y, incY);
    /*
    const N = D.size: c_int;
    select eltType {
      when real(32) do{
        cublas_saxpy (N, alpha, X, incX, Y, incY);
      }
    }
    */
  }

  module C_CUBLAS {
    use SysCTypes;
    //extern proc cublas_array(devPtr: []c_float, size: size_t);
    //extern proc cublas_array(X: c_ptr(c_float), size: size_t);
    //extern proc cublas_array(size: size_t): c_void_ptr;
    extern proc cublas_array(size: size_t): c_ptr(c_float);
    //extern proc cublas_array(size: size_t): c_ptr(c_float, size);
    //extern proc cublas_saxpy(N: c_int, alpha: c_float, X: []c_float, incX: c_int, Y: []c_float, incY: c_int);
    extern proc cublas_saxpy(N: c_int, alpha: c_float, X: c_ptr(c_float), incX: c_int, Y: c_ptr(c_float), incY: c_int);

  }

}

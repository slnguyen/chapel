#include <cuda_runtime.h>
#include  "cublas_v2.h"

//extern proc cublas_saxpy(N: c_int, alpha: c_float, X: []c_float, incX: c_int, Y: []c_float, incY: c_int);
int cublas_saxpy(int N, float alpha, float *x, int incX, float *y, int incY){

    cublasHandle_t handle;
    float *d_x, *d_y;

    cublasCreate(&handle);
    cudaMalloc((void**)&d_x, N*sizeof(float));
    cudaMalloc((void**)&d_y, N*sizeof(float));

    cublasSetVector(N, sizeof(x[0]), x, 1, d_x, 1);
    cublasSetVector(N, sizeof(y[0]), y, 1, d_y, 1);

    // Perform SAXPY on 1M elements
    cublasSaxpy(handle, N, &alpha, d_x, 1, d_y, 1);

    cublasGetVector(N, sizeof(y[0]), d_y, 1, y, 1);
    cudaMemcpy(y, d_y, N*sizeof(float), cudaMemcpyDeviceToHost);

    cublasDestroy(handle);
    return 0;
}

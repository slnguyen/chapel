//https://developer.nvidia.com/blog/six-ways-saxpy/

#include <stdlib.h>
#include <stdio.h>
#include <cuda_runtime.h>
#include  "cublas_v2.h"

int main(void){
    cublasHandle_t handle;
    int N = 1<<20;
    const float alpha = 2.0f;

    float *x, *y, *d_x, *d_y;
    x = (float*)malloc(N*sizeof(float));
    y = (float*)malloc(N*sizeof(float));

    cudaMalloc((void**)&d_x, N*sizeof(float));
    cudaMalloc((void**)&d_y, N*sizeof(float));

    for (int i = 0; i < N; i++){
        x[i] = 1.0f;
        y[i] = 2.0f;
    }

    cublasCreate(&handle);
    cublasSetVector(N, sizeof(x[0]), x, 1, d_x, 1);
    cublasSetVector(N, sizeof(y[0]), y, 1, d_y, 1);

    // Perform SAXPY on 1M elements
    cublasSaxpy(handle, N, &alpha, d_x, 1, d_y, 1);

    cublasGetVector(N, sizeof(y[0]), d_y, 1, y, 1);
    cublasDestroy(handle);

    //cudaMemcpy(y, d_y, N*sizeof(float), cudaMemcpyDeviceToHost);

    float maxError = 0.0f;
    for (int i = 0; i < N; i++)
        maxError = fmax(maxError, abs(y[i]-4.0f));
    printf("Max error: %f\n", maxError);


    return 0;
}

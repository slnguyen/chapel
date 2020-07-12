#include <cuda_runtime.h>
#include <stdio.h>
#include  "cublas_v2.h"


/*
int cublas_create(cublasHandle_t **handle){
    *handle = (cublasHandle_t*)malloc(sizeof(cublasHandle_t));
    return cublasCreate(*handle);
}

void cublas_destroy(cublasHandle_t *handle){
    cublasDestroy(*handle);
}

void *operator new(size_t len){
    void *ptr;
    cudaMallocManaged(&ptr, len);
    cudaDeviceSynchronize();
    return ptr;
}

void operator delete(void *ptr){
    cudaDeviceSynchronize();
    cudaFree(ptr);
}

*/


float* cublas_array(size_t size){
    //cudaMallocManaged((void**)&x, size*sizeof(float), 0);
    //int *a;
    //int N = 512;
    //cudaError_t err = cudaMallocManaged(&a,N*sizeof(int), cudaMemAttachGlobal);
    //cudaError_t err = cudaMallocManaged((void**)&x, size, 0);
    float *ptr;
    cudaError_t err = cudaMallocManaged(&ptr, size*sizeof(float), cudaMemAttachGlobal);
    printf("CUDA Error: %s\n", cudaGetErrorString(err));
    cudaDeviceSynchronize();
    return ptr;
    //return ptr;
    //for (int i = 0; i < size; i++)
    //  x[i] = 10;
    //cudaDeviceSynchronize();
}

int cublas_saxpy(int N, float alpha, float *x, int incX, float *y, int incY){

    cublasHandle_t handle;

    //float *d_x, *d_y;

    cublasCreate(&handle);

    //cudaMalloc((void**)&d_x, N*sizeof(float));
    //cudaMalloc((void**)&d_y, N*sizeof(float));

    //cublasSetVector(N, sizeof(x[0]), x, 1, d_x, 1);
    //cublasSetVector(N, sizeof(y[0]), y, 1, d_y, 1);

    // Perform SAXPY on 1M elements
    //cublasSaxpy(handle, N, &alpha, d_x, 1, d_y, 1);
    cublasSaxpy(handle, N, &alpha, x, 1, y, 1);
    cudaDeviceSynchronize();
    //cublasGetVector(N, sizeof(y[0]), d_y, 1, y, 1);

    //cudaFree(d_x);
    //cudaFree(d_y);

    cublasDestroy(handle);
    return 0;
}

#include <stdio.h>
#include <string>
#include <cstdlib>
#include <cmath>

__global__
void saxpy(int n, float a, float* x, float* y)
{
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < n) y[i] = a*x[i] + y[i];
}

__global__
void saxpy1(int n, float a, float* x, float* y, float* z, float* x1, float* y1)
{
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < n) y[i] = a*x[i] + y[i] + z[i] + x1[i] + y1[i];
}


int main(int argc, char *argv[]){

  int N = std::pow(2, std::stof(argv[1]));//1 << std::stoi(argv[1]);
  printf("N: %d\n", N);
  float *hx, *hy, *hz, *x1, *y1;
 // float *dx, *dy;

  //hx = (float*)malloc(N*sizeof(float));
  //hy = (float*)malloc(N*sizeof(float));

  //try different flag like cudaHostAllocDefault
  auto err1 = cudaMallocManaged((void**)&hx, N*sizeof(float));
  auto err2 = cudaMallocManaged((void**)&hy, N*sizeof(float));
  auto err3 = cudaMallocManaged((void**)&hz, N*sizeof(float));
  auto err4 = cudaMallocManaged((void**)&x1, N*sizeof(float));
  auto err5 = cudaMallocManaged((void**)&y1, N*sizeof(float));

  printf("%d\n", (int)err1);
  printf("%d\n", (int)err2);
  printf("%d\n", (int)err3);
  printf("%d\n", (int)err4);
  printf("%d\n", (int)err5);
  //printf("%d\n", (int)err3);
  //cudaMalloc(&d_x, N*sizeof(float));
  //cudaMalloc(&d_y, N*sizeof(float));

  for (int i = 0; i < N; i++) {
    hx[i] = rand();
    hy[i] = rand();
    hz[i] = rand();
    x1[i] = rand();
    y1[i] = rand();
   // hz[i] = 2.0f;
  }

  //cudaMemcpy(d_x, x, N*sizeof(float), cudaMemcpyHostToDevice);
  //cudaMemcpy(d_y, y, N*sizeof(float), cudaMemcpyHostToDevice);

  // Perform SAXPY on 1M elements
  //cudaHostGetDevicePointer(&dx, hx, 0);
  //cudaHostGetDevicePointer(&dy, hy, 0);
  //saxpy<<<(N+255)/256, 256>>>(N, 2.0f, dx, dy);
  saxpy1<<<(N+255)/256, 256>>>(N, 2.0f, hx, hy, hz, x1, y1);
  //saxpy1<<<(N+255)/256, 256>>>(N, 2.0f, hx, hy, hz);
  cudaDeviceSynchronize();//needs to be called after kernel is finished
  //cudaMemcpy(y, d_y, N*sizeof(float), cudaMemcpyDeviceToHost);

  //float maxError = 0.0f;
  //for (int i = 0; i < N; i++)
  //  maxError = max(maxError, abs(hy[i]-7.0f));
  //printf("Max error: %f\n", maxError);

  cudaFree(hx);
  cudaFree(hy);
  cudaFree(hz);
  cudaFree(x1);
  cudaFree(y1);
  //cudaFree(hz);
  //cudaFree(d_x);
  //cudaFree(d_y);
  //free(x);
  //free(y);

}

#include <stdio.h>
#include <string>

__global__
void saxpy(int n, float a, float* x, float* y)
{
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < n) y[i] = a*x[i] + y[i];
}

__global__
void saxpy1(int n, float a, float* x, float* y, float* z)
{
  int i = blockIdx.x*blockDim.x + threadIdx.x;
  if (i < n) y[i] = a*x[i] + y[i] + z[i];
}


int main(int argc, char *argv[]){

  //int N = 1 << std::stoi(argv[1]);
  int N = std::pow(2, std::stof(argv[1]));
  printf("N: %d\n", N);
  float *hx, *hy;
 // float *dx, *dy;

  //hx = (float*)malloc(N*sizeof(float));
  //hy = (float*)malloc(N*sizeof(float));

  //try different flag like cudaHostAllocDefault
  auto err1 = cudaHostAlloc((void**)&hx, N*sizeof(float), cudaHostAllocMapped);
  auto err2 = cudaHostAlloc((void**)&hy, N*sizeof(float), cudaHostAllocMapped);
  //auto err3 = cudaHostAlloc((void**)&hz, N*sizeof(float), cudaHostAllocMapped);

  printf("%d\n", (int)err1);
  printf("%d\n", (int)err2);
  //printf("%d\n", (int)err3);
  //cudaMalloc(&d_x, N*sizeof(float));
  //cudaMalloc(&d_y, N*sizeof(float));

  for (int i = 0; i < N; i++) {
    hx[i] = 1.0f;
    hy[i] = 3.0f;
    //hz[i] = 2.0f;
  }

  //cudaMemcpy(d_x, x, N*sizeof(float), cudaMemcpyHostToDevice);
  //cudaMemcpy(d_y, y, N*sizeof(float), cudaMemcpyHostToDevice);

  // Perform SAXPY on 1M elements
  //cudaHostGetDevicePointer(&dx, hx, 0);
  //cudaHostGetDevicePointer(&dy, hy, 0);
  //saxpy<<<(N+255)/256, 256>>>(N, 2.0f, dx, dy);
  saxpy<<<(N+255)/256, 256>>>(N, 2.0f, hx, hy);
  //saxpy1<<<(N+255)/256, 256>>>(N, 2.0f, hx, hy, hz);
  cudaDeviceSynchronize();//needs to be called after kernel is finished
  //cudaMemcpy(y, d_y, N*sizeof(float), cudaMemcpyDeviceToHost);

  float maxError = 0.0f;
  for (int i = 0; i < N; i++)
    maxError = max(maxError, abs(hy[i]-7.0f));
  printf("Max error: %f\n", maxError);

  cudaFree(hx);
  cudaFree(hy);
  //cudaFree(hz);
  //cudaFree(d_x);
  //cudaFree(d_y);
  //free(x);
  //free(y);

}

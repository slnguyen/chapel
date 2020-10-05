#include <cuda_runtime.h>
#include <iostream>

#define THREADS_PER_BLOCK 256


__global__
void reduce2(float *g_idata, float *g_odata) {

  extern __shared__ float sdata[];
  // load shared mem
  unsigned int tid = threadIdx.x;
  unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;

  sdata[tid] = g_idata[i];

  __syncthreads();

  // do reduction in shared mem
  for (unsigned int s = blockDim.x / 2; s > 0; s >>= 1) {
    if (tid < s) {
      sdata[tid] += sdata[tid + s];
    }

    __syncthreads();
  }

  // write result for this block to global mem
  if (tid == 0) g_odata[blockIdx.x] = sdata[0];

}

__global__
void add(int n, float *x, float *y)
{
  for (int i = 0; i < n; i++)
      y[i] = x[i] + y[i];
}

int main(){

int N = 1<<20;
float *x, *y, *d_x, *d_y;

x = (float*)malloc(N*sizeof(float));
y = (float*)malloc(N*sizeof(float));

cudaMalloc(&d_x, N*sizeof(float));
cudaMalloc(&d_y, N*sizeof(float));

for (int i = 0; i < N; i++) {
  x[i] = 1.0f;
  //y[i] = 2.0f;
}

cudaMemcpy(d_x, x, N*sizeof(float), cudaMemcpyHostToDevice);
cudaMemcpy(d_y, y, N*sizeof(float), cudaMemcpyHostToDevice);

//<<<numBlocks, numThreads, smemSize>>
//reduce2<<<1,32, N*sizeof(float)>>>(d_x, d_y);
reduce2<<<(N+255)/256, 256, 256*sizeof(float)>>>(d_x, d_y);
//add<<<1, 1>>>(N, d_x, d_y);

cudaMemcpy(y, d_y, N*sizeof(float), cudaMemcpyDeviceToHost);

float total_sum = 0.0f;

//reduction for each block
for(int i = 0; i < (N / 256); i++){
  total_sum += y[i];
}

std::cout << total_sum <<std::endl;

cudaFree(d_x);
cudaFree(d_y);
free(x);
free(y);

}

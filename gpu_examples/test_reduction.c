#include <cuda_runtime.h>

#define THREADS_PER_BLOCK 256

int main(){

int N = 1<<20;
float *x, *y, *d_x, *d_y;

x = (int*)malloc(N*sizeof(int));
y = (int*)malloc(N*sizeof(int));

cudaMalloc(&d_x, N*sizeof(int));
cudaMalloc(&d_y, N*sizeof(int));

for (int i = 0; i < N; i++) {
  x[i] = 1.0f;
}

cudaMemcpy(d_x,  N*sizeof(int), cudaMemcpyHostToDevice);
cudaMemcpy(d_y, N*sizeof(int), cudaMemcpyHostToDevice);

reduce2<<<(N+255)/256, 256>>>(d_x, d_y);

cudaMemcpy(y, d_y, N*sizeof(float), cudaMemcpyDeviceToHost);
cudaFree(d_x);
cudaFree(d_y);
free(x);
free(y);

}

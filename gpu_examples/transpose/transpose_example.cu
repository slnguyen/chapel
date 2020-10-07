#include <stdio.h>

const int TILE_DIM = 32;
const int BLOCK_ROWS = 8;

//check errors
void postprocess(const float *ref, const float *res, int n)
{
  bool passed = true;
  for (int i = 0; i < n; i++)
    if (res[i] != ref[i]) {
      printf("%d %f %f\n", i, res[i], ref[i]);
      printf("%25s\n", "*** FAILED ***");
      passed = false;
      break;
    }
  if(passed){
    printf("test passed");
  }
}

__global__ void transposeCoalesced(float *odata, const float *idata)
{
  __shared__ float tile[TILE_DIM][TILE_DIM];

  int x = blockIdx.x * TILE_DIM + threadIdx.x;
  int y = blockIdx.y * TILE_DIM + threadIdx.y;
  int width = gridDim.x * TILE_DIM;

  for (int j = 0; j < TILE_DIM; j += BLOCK_ROWS)
     tile[threadIdx.y+j][threadIdx.x] = idata[(y+j)*width + x];

  __syncthreads();

  x = blockIdx.y * TILE_DIM + threadIdx.x;  // transpose block offset
  y = blockIdx.x * TILE_DIM + threadIdx.y;

  for (int j = 0; j < TILE_DIM; j += BLOCK_ROWS)
     odata[(y+j)*width + x] = tile[threadIdx.x][threadIdx.y + j];
}

int main(){

  const int nx = 1024;
  const int ny = 1024;
  const int mem_size = nx*ny*sizeof(float);

  dim3 dimGrid(nx/TILE_DIM, ny/TILE_DIM, 1);
  dim3 dimBlock(TILE_DIM, BLOCK_ROWS, 1);

  float *h_idata = (float*)malloc(mem_size);
  float *h_tdata = (float*)malloc(mem_size);
  float *gold    = (float*)malloc(mem_size);

  float *d_idata, *d_tdata;
  cudaMalloc(&d_idata, mem_size);
  cudaMalloc(&d_tdata, mem_size);

  // host
  for (int j = 0; j < ny; j++)
    for (int i = 0; i < nx; i++)
      h_idata[j*nx + i] = j*nx + i;


  // correct result for error checking
  for (int j = 0; j < ny; j++)
    for (int i = 0; i < nx; i++)
      gold[j*nx + i] = h_idata[i*nx + j];

  cudaMemcpy(d_idata, h_idata, mem_size, cudaMemcpyHostToDevice);

  cudaMemset(d_tdata, 0, mem_size); 
  transposeCoalesced<<<dimGrid, dimBlock>>>(d_tdata, d_idata);
  cudaMemcpy(h_tdata, d_tdata, mem_size, cudaMemcpyDeviceToHost);
  postprocess(gold, h_tdata, nx * ny);

  cudaFree(d_tdata);
  cudaFree(d_idata);
  free(h_idata);
  free(h_tdata);
  free(gold);


}


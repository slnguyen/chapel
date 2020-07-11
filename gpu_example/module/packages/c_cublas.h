//int cublas_array(float *x, size_t size);
//void *cublas_array(size_t size);
void *cublas_array(size_t size);
int cublas_saxpy(int N, float alpha, float *x, int incX, float *y, int incY);

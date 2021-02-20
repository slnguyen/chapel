extern {
  #include <cuda.h>
  #include <stdio.h>
  #include <stdlib.h>
  #include <assert.h>

  #define FATBIN_FILE "tmp/chpl__gpu.fatbin"

  struct kernel {
      uint32_t v0;
      uint32_t v1;
      uint32_t v2;
      uint64_t v3;
      uint32_t v4;
      uint32_t v5;
      uint32_t v6;
      uint32_t v7;
      uint32_t v8;
      void *module;
      uint32_t size;
      uint32_t v9;
      void *p1;   
  };

  struct dummy1 {
    void *p0;
    void *p1;
    uint64_t v0;
    uint64_t v1;
    void *p2;
  };

  struct CUfunc_st {
      uint32_t v0;
      uint32_t v1;
      char *name;
      uint32_t v2;
      uint32_t v3;
      uint32_t v4;
      uint32_t v5;
      struct kernel *kernel;
      void *p1;
      void *p2;
      uint32_t v6;
      uint32_t v7;
      uint32_t v8;
      uint32_t v9;
      uint32_t v10;
      uint32_t v11;
      uint32_t v12;
      uint32_t v13;
      uint32_t v14;
      uint32_t v15;
      uint32_t v16;
      uint32_t v17;
      uint32_t v18;
      uint32_t v19;
      uint32_t v20;
      uint32_t v21;
      uint32_t v22;
      uint32_t v23;
      struct dummy1 *p3;
  };

  static void checkCudaErrors(CUresult err) {
    assert(err == CUDA_SUCCESS);
  }

  static CUfunc_st* createFunction(){
    CUdevice    device;
    CUmodule    cudaModule;
    CUcontext   context;
    CUfunction  function;
    int         devCount;

    // CUDA initialization
    checkCudaErrors(cuInit(0));
    checkCudaErrors(cuDeviceGetCount(&devCount));
    checkCudaErrors(cuDeviceGet(&device, 0));

    char name[128];
    checkCudaErrors(cuDeviceGetName(name, 128, device));
    printf("Using CUDA Device %s\n", name);
    //std::cout << "Using CUDA Device [0]: " << name << "\n";


    // Create driver context
    checkCudaErrors(cuCtxCreate(&context, 0, device));

    //read in fatbin and store in buffer
    char * buffer = 0;
    long length;
    FILE * f = fopen (FATBIN_FILE, "rb");

    if (f)
    {
      fseek (f, 0, SEEK_END);
      length = ftell (f);
      fseek (f, 0, SEEK_SET);
      buffer = (char* )malloc (length);
      if (buffer)
      {
        fread (buffer, 1, length, f);
      }
      fclose (f);
    }


    // Create module for object
    printf("creating module\n");
    auto err1 = cuModuleLoadData(&cudaModule, buffer);


    // Get kernel function
    printf("creating kernel\n");
    auto err = cuModuleGetFunction(&function, cudaModule, "add_nums");

    struct CUfunc_st *pFunc=(struct CUfunc_st *)function;
    return pFunc;
  }

  CUdeviceptr getDeviceBufferPointer(){

    double X;
    CUdeviceptr devBufferX;

    printf("allocating memory\n");
    checkCudaErrors(cuMemAlloc(&devBufferX, sizeof(double)));

    //get value of X

    printf("input num: ");
    scanf("%lf", &X);
    printf("number: %lf\n", X);


    printf("cuMemcpyHtoD\n");
    checkCudaErrors(cuMemcpyHtoD(devBufferX, &X, sizeof(double)));

    return devBufferX;

  }


  //void *getKernelParams(CUfunc_st *function_arg, CUdeviceptr devBufferX){
  void **getKernelParams(CUdeviceptr *devBufferX){
    static void* kernelParams[1];
    kernelParams[0] = devBufferX;
    return kernelParams;
  }


  double getDataFromDevice(CUdeviceptr devBufferX){
    double X;
    auto err = cuMemcpyDtoH(&X, devBufferX, sizeof(double));
    return X;
  }

}

pragma "codegen for GPU"
pragma "always resolve function"
export proc add_nums(dst_ptr: c_ptr(real(64))){
  dst_ptr[0] = dst_ptr[0]+5;
}


proc main() {
var output: real(64);
var funcPtr: c_ptr(CUfunc_st) = createFunction();
var deviceBuffer = getDeviceBufferPointer();
var ptr: c_ptr(uint(64)) = c_ptrTo(deviceBuffer);
var kernelParams = getKernelParams(ptr);

 __primitive("gpu kernel launch", funcPtr, 1, 1, 1, 1, 1, 1, 0, 0, kernelParams, 0);
output = getDataFromDevice(deviceBuffer);

writeln(output);

}


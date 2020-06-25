compile `saxpy_cublas.c` and create .o file
```
nvcc -c saxpy_cublas.c -lcublas
```

compile `saxpy.chpl`
```
chpl saxpy.chpl -L/usr/local/cuda-10.2/lib64 -lcudart -lcublas
```

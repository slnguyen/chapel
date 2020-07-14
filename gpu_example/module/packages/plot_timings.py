import matplotlib.pyplot as plt
import numpy as np

with open("timing.txt") as fp:
    cublas_saxpy_time = fp.readline().split(" ");
    blas_saxpy_time = fp.readline().split(" ");

x = [i for i in range (0, 31)]
print(cublas_saxpy_time)
print(blas_saxpy_time)

cublas_saxpy_time = cublas_saxpy_time[:-1]
blas_saxpy_time = blas_saxpy_time[:-1]
cublas_saxpy_time = [np.log2(float(i)) for i in cublas_saxpy_time]
blas_saxpy_time = [np.log2(float(i)) for i in blas_saxpy_time]

plt.plot(x, cublas_saxpy_time, "-o", label="chpl+cublas")
plt.plot(x, blas_saxpy_time, "-o", label="chpl+blas")
plt.legend(loc="upper left")
plt.title('saxpy')
plt.xlabel('problem size (2^x)')
plt.ylabel('log2(time (ms))')
plt.show()


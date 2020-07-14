import matplotlib.pyplot as plt
import numpy as np

#with open("timing.txt") as fp:
#    cublas_saxpy_time = fp.readline().split(" ");
#    blas_saxpy_time = fp.readline().split(" ");

f = open("c_cublas_times.log", "r")
cublas_saxpy_time = f.readlines()

f = open("cublas_chpl_wrapper.log", "r")
chpl_cublas_saxpy_time = f.readlines()

x = [i for i in range (1, 31)]
print(cublas_saxpy_time)
print(chpl_cublas_saxpy_time)

cublas_saxpy_time = [float(i.rstrip()) for i in cublas_saxpy_time]
chpl_cublas_saxpy_time = [float(i.rstrip()) for i in chpl_cublas_saxpy_time]

plt.plot(x, cublas_saxpy_time, "--o", label="c+cublas")
plt.plot(x, chpl_cublas_saxpy_time, "--x", label="chpl+cublas")
plt.legend(loc="upper left")
plt.title('saxpy')
plt.xlabel('problem size (2^x)')
plt.ylabel('time (ms)')
plt.show()


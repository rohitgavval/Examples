'''
=====================================================
A 4x4 matrix is operated on using a grid containing 1
block having threads in 4x4 dimensions
=====================================================
'''
# Import necessary libraries

import pycuda.driver as drv
import pycuda.autoinit
from pycuda.compiler import SourceModule

import numpy as np

# Define kernel
mod = SourceModule('''
	#include <stdio.h>
	__global__ void doublify(int *d_array)
	{
		int idx = threadIdx.x*blockDim.y + threadIdx.y;
		d_array[idx] = d_array[idx] * 2;
	}
	''')

# Host array
h_array = np.arange(16)
h_array = h_array.reshape(4,4)
h_array = h_array

# Device array
d_array = drv.mem_alloc(h_array.nbytes)

# Copy host array to device array
drv.memcpy_htod(d_array, h_array)

# Invoke kernel
func = mod.get_function("doublify")
func(d_array, block=(4,4,1))

# Copy device array to host array
drv.memcpy_dtoh(h_array, d_array)

print h_array

/*
 * Copyright 1993-2014 NVIDIA Corporation.  All rights reserved.
 *
 * Please refer to the NVIDIA end user license agreement (EULA) associated
 * with this source code for terms and conditions that govern your use of
 * this software. Any use, reproduction, disclosure, or distribution of
 * this software and related documentation outside the terms of the EULA
 * is strictly prohibited.
 *
 */

__global__ void Copy(TColor *dst, int imageW, int imageH,int *array,int size) {
	const int ix = blockDim.x * blockIdx.x + threadIdx.x;
	const int iy = blockDim.y * blockIdx.y + threadIdx.y;
	//Add half of a texel to always address exact texel centers
/*
	__shared__ int *array;


	__syncthreads();
	*/
	const float x = (float) ix + 0.5f;
	const float y = (float) iy + 0.5f;

	//calculate electric field from superposition principle
	double r1 = sqrt(
			(array[0] - (double) ix) * (array[0] - (double) ix)
					+ (array[1] - (double) iy) * (array[1] - (double) iy));
	double r2 = sqrt(
			(array[3] - (double) ix) * (array[3] - (double) ix)
					+ (array[4] - (double) iy) * (array[4] - (double) iy));

	double k = (1 / (4 * 3.14 * 8.854));
	int E = k * ((array[2] / r1) + (array[5] / r2));
	//if(E!=0)

	//printf("ix = %d\t iy = %f\tr1 = %f\t r2 = %d\tE = %d\n", ix, iy, r1, r2,E);
	uchar4 color;
	if (E) {

		/*
		 R = ((curPixel >> 16) & 0x000000FF);
		 G = ((curPixel >> 8) & 0x000000FF);
		 B = ((curPixel >> 0) & 0x000000FF);
		 */

		color.x = char((E >> 16) & 0x000000FF);
		color.y = char((E >> 8) & 0x000000FF);
		color.z = char((E >> 0) & 0x000000FF);
	} else {
		color.x = 0;
		color.y = 0;
		color.z = 0;
	}

	if (ix < imageW && iy < imageH) {
		float4 fresult = tex2D(texImage, x, y);
		dst[imageW * iy + ix] = make_color(color.x, color.y, color.z, 0);
	}
	free(array);
}

 void cuda_Copy(TColor *d_dst, int imageW, int imageH, int *array,int size) {
	dim3 threads(BLOCKDIM_X, BLOCKDIM_Y);
	dim3 grid(iDivUp(imageW, BLOCKDIM_X), iDivUp(imageH, BLOCKDIM_Y));

	Copy<<<grid, threads>>>(d_dst, imageW, imageH, array,size);
}

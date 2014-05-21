//#include <curand_kernel.h>

__global__ void sim(TColor *dst, float* array, int imageW, int imageH,
		int num_of_charges) {
	const int ix = blockDim.x * blockIdx.x + threadIdx.x;
	const int iy = blockDim.y * blockIdx.y + threadIdx.y;

	float E, r1;
	int temp;
	extern __shared__ float points[];

	if (blockDim.x*blockDim.y < num_of_charges) {
		temp = num_of_charges / (blockDim.x*blockDim.y);
	}
	for (int i = 0; i < temp; i++) {
		//int index = threadIdx.x * temp + i;
		int index = (threadIdx.y*blockDim.x+ threadIdx.x) * i;
		points[index] = array[index];
		points[index + 1] = array[index + 1];
		points[index + 2] = array[index + 2];
	}
	__syncthreads();
	for (int i = 0; i < num_of_charges; i++) {
		r1 = sqrt(
				(array[i * 3] - ix) * (array[i * 3] - ix)
						+ (array[i * 3 + 1] - iy) * (array[i * 3 + 1] - iy));

		if (r1 < 0.001)
			continue;

		E += ((array[i * 3 + 2] / r1));
	}
	if (E > 100000) {
		E = 1;
	} else {
		E = E / 100000;
	}
	__syncthreads();
	if (ix < imageW && iy < imageH) {
		dst[imageW * iy + ix] = make_color(0, E, E, 0);
	}
	__syncthreads();

}

__global__ void sim_hardcoded(TColor *dst, int imageW, int imageH) {
	const int ix = blockDim.x * blockIdx.x + threadIdx.x;
	const int iy = blockDim.y * blockIdx.y + threadIdx.y;

	extern __shared__ float points[];
	points[0] = 342;
	points[1] = 384;
	points[2] = 10000;
	points[3] = 684;
	points[4] = 384;
	points[5] = 10000;

	float E, r1;
	for (int i = 0; i < 2; i++) {
		r1 = sqrt(
				(points[i * 3] - ix) * (points[i * 3] - ix)
						+ (points[i * 3 + 1] - iy) * (points[i * 3 + 1] - iy));
		if (r1 < 0.01)
			continue;
		E += ((points[i * 3 + 2] / r1));
	}
	if (E > 1000) {
		E = 1;
	} else {
		E = E / 1000;
	}
	if (ix < imageW && iy < imageH) {
		dst[imageW * iy + ix] = make_color(E, E, 0, 0);
	}
}

extern "C" void cuda_sim(TColor *d_dst, float* array, int imageW, int imageH,
		int num_of_charges, int sh_size) {
	dim3 threads(BLOCKDIM_X, BLOCKDIM_Y);
	dim3 grid(iDivUp(imageW, BLOCKDIM_X), iDivUp(imageH, BLOCKDIM_Y));

	sim<<<grid, threads, sh_size>>>(d_dst, array, imageW, imageH,
			num_of_charges);
}
extern "C" void cuda_sim_hardcoded(TColor *d_dst, int imageW, int imageH,
		int sh_size) {
	dim3 threads(BLOCKDIM_X, BLOCKDIM_Y);
	dim3 grid(iDivUp(imageW, BLOCKDIM_X), iDivUp(imageH, BLOCKDIM_Y));

	sim_hardcoded<<<grid, threads, sh_size>>>(d_dst, imageW, imageH);
}

#ifndef RAYCASTING_H
#define RAYCASTING_H

typedef unsigned int TColor;

#define BLOCKDIM_X 8
#define BLOCKDIM_Y 8

#ifndef MAX
#define MAX(a,b) ((a < b) ? b : a)
#endif
#ifndef MIN
#define MIN(a,b) ((a < b) ? a : b)
#endif

// CUDA wrapper functions for allocation/freeing texture arrays
extern "C" cudaError_t CUDA_Bind2TextureArray();
extern "C" cudaError_t CUDA_UnbindTexture();
extern "C" cudaError_t CUDA_MallocArray(uchar4 **h_Src, int imageW, int imageH);
extern "C" cudaError_t CUDA_FreeArray();

// CUDA kernel functions
extern "C" void cuda_sim(TColor *d_dst,float* array, int imageW, int imageH,int num_of_charges,int sh_size);
extern "C" void cuda_sim_hardcoded(TColor *d_dst, int imageW, int imageH, int sh_size);
#endif

################################################################################
# Automatically-generated file. Do not edit!
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
CPP_SRCS += \
../src/bmploader.cpp \
../src/imageDenoisingGL.cpp 

CU_SRCS += \
../src/imageDenoising.cu 

CU_DEPS += \
./src/imageDenoising.d 

OBJS += \
./src/bmploader.o \
./src/imageDenoising.o \
./src/imageDenoisingGL.o 

CPP_DEPS += \
./src/bmploader.d \
./src/imageDenoisingGL.d 


# Each subdirectory must supply rules for building sources it contributes
src/%.o: ../src/%.cpp
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/opt/cuda/bin/nvcc -I"/opt/cuda/samples/3_Imaging" -I"/opt/cuda/samples/common/inc" -I"/home/mozg/cuda-workspace/proba" -G -g -O0 -gencode arch=compute_20,code=sm_20 -gencode arch=compute_20,code=sm_21  -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	/opt/cuda/bin/nvcc -I"/opt/cuda/samples/3_Imaging" -I"/opt/cuda/samples/common/inc" -I"/home/mozg/cuda-workspace/proba" -G -g -O0 --compile  -x c++ -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '

src/%.o: ../src/%.cu
	@echo 'Building file: $<'
	@echo 'Invoking: NVCC Compiler'
	/opt/cuda/bin/nvcc -I"/opt/cuda/samples/3_Imaging" -I"/opt/cuda/samples/common/inc" -I"/home/mozg/cuda-workspace/proba" -G -g -O0 -gencode arch=compute_20,code=sm_20 -gencode arch=compute_20,code=sm_21  -odir "src" -M -o "$(@:%.o=%.d)" "$<"
	/opt/cuda/bin/nvcc --compile -G -I"/opt/cuda/samples/3_Imaging" -I"/opt/cuda/samples/common/inc" -I"/home/mozg/cuda-workspace/proba" -O0 -g -gencode arch=compute_20,code=compute_20 -gencode arch=compute_20,code=sm_21  -x cu -o  "$@" "$<"
	@echo 'Finished building: $<'
	@echo ' '



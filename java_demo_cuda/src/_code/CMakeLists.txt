add_compile_options(-fPIC)
AUX_SOURCE_DIRECTORY(file DIR_TEST1_SRCS)
CUDA_ADD_LIBRARY( Test1 SHARED ${DIR_TEST1_SRCS})
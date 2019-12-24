#include <add_cuda.h>
namespace zjx{
__global__ void addwithcuda(int* x, int* y,int *z){
    *z = *x + *y;
    }
int add_ceshi(int m, int n){
    int *x=0;
    int *y=0;
    int *z=0;
    cudaMalloc((void**)&x,sizeof(int));
    cudaMalloc((void**)&y,sizeof(int));
    cudaMalloc((void**)&z,sizeof(int));
    cudaMemcpy(x, &m, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(y, &n, sizeof(int), cudaMemcpyHostToDevice);
    addwithcuda<<<1, 1>>>(x,y,z);
    int *result=(int* )malloc(sizeof(int));
    cudaMemcpy(result, z, sizeof(int), cudaMemcpyDeviceToHost);
    cudaFree(x);
    cudaFree(y);
    cudaFree(z);
    return *result;
    
}
}
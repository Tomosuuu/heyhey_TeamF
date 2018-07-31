//参考サイト
/*http://d.hatena.ne.jp/interleave/20091103/1257259065*/

#include <stdlib.h>
#include <stdio.h>
#include <algorithm>
#include <cstdio>
#include <ctime>
#include <stdint.h>

//#define WIDTH 500
#define BLOCK 1

float h_a[WIDTH*WIDTH];
float h_b[WIDTH*WIDTH];
float h_c[WIDTH*WIDTH];

//static inline void
//print_msec(const char * s,clock_t t)
//{
//double msec = (static_cast<double>(t) / CLOCKS_PER_SEC) * 10000;
//printf("%s : %f\n",s,msec);
//}

__global__ void Kernel1(float *A, float *B, float *C)
{
// G P U で の 行 列 乗 算 （ グ ロ ー バ ル メ モ リ の み 使 用 ）
int x=blockIdx.x*blockDim.x + threadIdx.x;
int y=blockIdx.y*blockDim.y + threadIdx.y;

//printf("x:\n",x);
//printf("y:\n",y);

float tmp =0.0;
  for(int k=0; k<WIDTH; k++){
    int row=k+y*WIDTH;
    int col=x+k*WIDTH;
    tmp += A[row]*B[col];
  }
  C[x+y*WIDTH]= tmp;
}

int main(){
  int i;
  srand(0);
  cudaSetDevice(0);
  //時間を図るためにt1~t4を宣言
  clock_t t1,t2,t3,t4,t5,t6,t7,t8,t9,t10;
  float *d_a, *d_b, *d_c;

  cudaDeviceSynchronize();
  //t9 = clock();

  cudaDeviceSynchronize();
  //t1 = clock();
  cudaMalloc((void**)&d_a,sizeof(float)*WIDTH*WIDTH);
  cudaMalloc((void**)&d_b,sizeof(float)*WIDTH*WIDTH);
  cudaMalloc((void**)&d_c,sizeof(float)*WIDTH*WIDTH);
  cudaDeviceSynchronize();
  //t2 = clock();

cudaMemset(d_c,0,sizeof(float)*WIDTH*WIDTH);

  //printf("a to b\n");
  for(i=0; i<WIDTH*WIDTH; i++){
    h_a[i] = (float)(rand()%10)/1.0f;
    h_b[i] = (float)(rand()%10)/1.0f;
    //printf("%f\n",h_a[i]);
    //printf("%f\n",h_b[i]);
  }

  cudaDeviceSynchronize();
  //t3 = clock();
  cudaMemcpy(d_a,h_a,sizeof(float)*WIDTH*WIDTH,cudaMemcpyHostToDevice);
  cudaMemcpy(d_b,h_b,sizeof(float)*WIDTH*WIDTH,cudaMemcpyHostToDevice);
  cudaDeviceSynchronize();
  //t4 = clock();
  dim3 grid(WIDTH/BLOCK,WIDTH/BLOCK,1);
  dim3 threads(BLOCK,BLOCK,1);
  cudaDeviceSynchronize();
  //t5 = clock();
  Kernel1<<< grid, threads >>>(d_a, d_b, d_c);
  cudaDeviceSynchronize();
  //t6 = clock();
  cudaDeviceSynchronize();
  //t7 = clock();
  cudaMemcpy(h_c,d_c,sizeof(float)*WIDTH*WIDTH,cudaMemcpyDeviceToHost);
  cudaDeviceSynchronize();
  //t8 =clock();
  printf(" G P U計算結果 = %f\n",h_c[WIDTH*WIDTH-1]);

  //for(i=0; i<WIDTH*WIDTH; i++){
    //printf("%f\n",h_c[i]);
  //}

  cudaFree(d_a);
  cudaFree(d_b);
  cudaFree(d_c);

  cudaDeviceSynchronize();
  //t10 = clock();

  //GPUで行列a,b,cのデータを転送
  //print_msec("time1:\n",t2-t1);
  //GPUへのデータ転送
  //print_msec("time2:\n",t4-t3);
  //カーネル関数実行
  //print_msec("time3:\n",t6-t5);
  //行列cのデータ転送
  //print_msec("time4:\n",t8-t7);
  //main関数全体
  //print_msec("time5:\n",t10-t9);
}
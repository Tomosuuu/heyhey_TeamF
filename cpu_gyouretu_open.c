/**
 * 行列演算の例：動的配列を使う (1)
 */
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
//#define N 5000/* 行列のサイズ */

double *matrix_mul(double *, double *, int) ;
void print_matrix(double *, int) ;

int main(int argc, char **argv)
{
  clock_t t1,t2,t3,t4;

  //t1 = clock();
  
  double *a, *b, *c ;
  int i, j, n = N ;

  a = (double *)malloc(sizeof(double)*n*n) ;
  b = (double *)malloc(sizeof(double)*n*n) ;
  for(i=0;i<n;i++) {
    for(j=0;j<n;j++) {
      //i*nすることでn=1000だとしたら0~999が１列め,1000~1999までが２列目　千を千列作る
      a[i*n+j] = (double)(rand()%10);
      b[i*n+j] = (double)(rand()%10);
    }
  }
  //t3 = clock();
  c = matrix_mul(a, b, n) ;
  //t4 = clock();
  /*
  print_matrix(a, n) ; 
  printf("\n") ;
  print_matrix(b, n) ; 
  printf("\n") ;
  print_matrix(c, n) ;
  */
  //t2 = clock();

  //printf("行列計算のtime = %f[s]\n",(double)(t4-t3)/CLOCKS_PER_SEC);
  //printf("main関数全体でのtime = %f[s]\n",(double)(t2-t1)/CLOCKS_PER_SEC);
  return 0 ;
}

/**
 * c = a b を計算する
 */
double *matrix_mul(double *a, double *b, int n) 
{
  int i, j, k ;
  double *c ;
  
  c = (double *)malloc(sizeof(double)*n*n) ;
   
 #ifdef _OPENMP
    #endif
    #pragma omp parallel for
  for(i=0;i<n;i++) {
    for(j=0;j<n;j++) {
      c[i*n+j] = 0.0 ;
      for(k=0;k<n;k++) c[i*n+j] += a[i*n+k]*b[k*n+j] ;
    }
  }
  return c ;
}


void print_matrix(double *a, int n)
{
  int i, j ;

  for(i=0;i<n;i++) {
    for(j=0;j<n;j++) printf("%f ", a[i*n+j]) ; 
    printf("\n") ;
  }
  return ;
}

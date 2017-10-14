#include <stdio.h>
#include <stdlib.h>
#define ROWS 4
#define COLUMNS 5

typedef struct mystruct
{
	int a[ROWS];
	int **data;
}mystruct;

__global__ void printKernel(mystruct *d_var)
{
	int i, j;
	for(i = 0; i < ROWS; i++)
	{
		for(j = 0; j < COLUMNS; j++)
		{
			printf("%d\t", d_var->data[i][j]);
		}
		printf("\n");
	}
}

int main()
{
	int i, j, k=1;
	mystruct *var, *d_var;

/* Allocate and initialize a dynamic 2D array on CPU */
	var->data = (int**)malloc(ROWS*sizeof(int*));
	for (i = 0; i < ROWS; i++)
		var->data[i] = (int*)malloc(COLUMNS*sizeof(int));

	for(i = 0; i < ROWS; i++)
	{
		var->a[i] = 2;
		for(j = 0; j < COLUMNS; j++)
		{
			var->data[i][j] = k++;
		}		
	}

/* Allocate memory for struct on GPU*/
	cudaMalloc((void**)&d_var, sizeof(mystruct));	
/*Allocate memory explicitly for the 2D array*/
	cudaMalloc((void**)&d_var->data, ROWS*sizeof(int*));
	for(i = 0; i < ROWS; i++)
		cudaMalloc((void**)&d_var->data[i], COLUMNS*sizeof(int));
/*Copy the host struct to device*/
	cudaMemcpy(d_var, var, (sizeof(mystruct)+ROWS*COLUMNS*sizeof(int)), cudaMemcpyHostToDevice);
	printKernel<<<1,1>>>(d_var);
	free(var);
	cudaFree(d_var);
	return 0;
}

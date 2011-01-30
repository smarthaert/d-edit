#include "stdafx.h"
#include "Random.h"

int *T=NULL;
int TCount=0;
int TGet=0;

int Random(int i, int j)
{
	return (rand() % (j-i+1))+i;
}

void DeInitRandomQuery()
{
	free(T);
	TCount=0;
	TGet=0;
}

void InitRandomQuery(int Tops)
{
	TCount = Tops;
	TGet=0;
	srand((unsigned)time(NULL));
	if (!T) free(T);
	T = (int*)malloc(sizeof(int)*Tops);
	for (int i=0; i<Tops; i++) T[i] = i+1;
	for (i=0; i<Tops; i++)
	{
		int j=Random(0,Tops-1);
		int a=T[i];
		T[i] = T[j];
		T[j] = a;
	}
}

int GetRandom()
{
	int j=Random(0,TCount-1);
	int Ret=T[j];
	while (Ret == -1)
	{
		j++;
		if (j>=TCount) j = j % TCount;
		Ret = T[j];
	}
	T[j] = -1;
	TGet++;
	return Ret;
}

int R(int i)
{
	return T[i];
}
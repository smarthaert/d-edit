#include "stdafx.h"
#include "Random.h"
#include "Stack.h"

CStack* Stack=NULL;
int Random(int i, int j)
{
	return (rand() % (j-i+1))+i;
}

void DeInitRandomQuery()
{
	if (Stack) delete Stack;
	Stack=NULL;
}

void InitRandomQuery(int Tops)
{
	srand((unsigned)time(NULL));
	DeInitRandomQuery();
	Stack=new CStack;
	int* T=new int[Tops];
	for (int i=0; i<Tops; i++) T[i]=i+1;
	for (i=0; i<Tops; i++)
	{
		int j=Random(0,Tops-1);
		int a=T[i];
		T[i] = T[j];
		T[j] = a;
	}
	for (i=0; i<Tops; i++) Stack->Push(T[i]);
	delete []T;
}

int GetRandom()
{
	return Stack->Pop();
}


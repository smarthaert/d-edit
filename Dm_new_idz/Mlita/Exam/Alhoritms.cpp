#include "stdafx.h"
#include "Alhoritms.h"

struct CEdge
{
	int i;
	int j;
	int Price;
};

void Search_Into_Deep(CGraph* Graph, CQuery* PathQuery, int* X,int Source)
{
	int Tops=Graph->GetTops();
	for (int k=0; k<Tops; k++) X[k] = 0;
	X[Source-1]=1;
	k=Source;
	CStack* Stack=new CStack;
	Stack->Push(Source);
	if (PathQuery) PathQuery->Push(Source);
	while (!Stack->IsEmpty())
	{
		int f=0;
		for (int l=1; l<=Graph->GetTops(); l++)
		{
			if (!X[l-1] && Graph->IsLinked(k,l))
			{
				X[l-1]=1;
				if (PathQuery) PathQuery->Push(l);
				Stack->Push(l);
				f=l;
			}
		}
		if (!f) k=Stack->Pop();	else k=f;
	}
	delete Stack;
}

void Search_Into_Width(CGraph* Graph,CQuery* PathQuery,int* X, int Source)
{
	int Tops=Graph->GetTops();
	for (int k=0; k<Tops; k++) X[k] = 0;
	X[Source-1]=1;
	CQuery* Query=new CQuery;
	Query->Push(Source);
	if (PathQuery) Query->Push(Source);
	while (!Query->IsEmpty())
	{
		k=Query->Pop();
		for (int l=1; l<=Graph->GetTops(); l++)
		{
			if (!X[l-1] && Graph->IsLinked(k,l))
			{
				X[l-1]=1;
				if (PathQuery) PathQuery->Push(l);
				Query->Push(l);
			}
		}
	}
	delete Query;
}

void Dejikstra(CGraph* Graph, CStack* PathStack, int* X, int* H, int* T, int Source, int Destination, int& Price)
{
  int Tops = Graph->GetTops();
  for (int v=1; v<=Tops; v++)
  {
    T[v-1] = LARGE;
    X[v-1] = 0;
  }
  H[Source-1] = 0;
  T[Source-1] = 0;
  X[Source-1] = 1;
  v = Source;
  m:
  for (int u=1; u<=Tops; u++)
  {
    if (!X[u-1] && T[u-1] > T[v-1] + Graph->GetPrice(v,u) )
    {
      T[u-1] = T[v-1] + Graph->GetPrice(v,u);
      H[u-1] = v;
    }
  }
  int r=LARGE;
  v=0;
  for (u=1; u<=Tops; u++)
  {
    if (!X[u-1] && T[u-1]<r)
    {
      v=u;
      r=T[u-1];
    }
  }                                     // t min
  if (v==0)
  {
	  Price=-1;
      return;
	}
	if (v==Destination)
	{
		Price=r;
		PathStack->Push(v);
		while (v!=Source)
		{
			PathStack->Push(H[v-1]);
			v=H[v-1];
		}
		return;
  }
  X[v-1] =1;
  goto m;
}

void Floyd(CGraph* Graph, CQuery* PathQuery,int* T, int* H,int Source,int Destination,int& Price)
{
	int Tops=Graph->GetTops();
	for (int i=1; i<=Tops; i++)
	{
		for (int j=1; j<=Tops; j++)
		{
			T[(i-1)*Tops+j-1] = Graph->GetPrice(i,j);
			if (Graph->GetPrice(i,j) == LARGE) H[(i-1)*Tops+j-1] = 0; else H[(i-1)*Tops+j-1]=j;
		}
	}
	for (i=1; i<=Tops; i++)
	{
		for (int j=1; j<=Tops; j++)
		{
			for (int k=1; k<=Tops; k++)
			{
				if (i!=j && T[(j-1)*Tops+i-1] != LARGE && i!=k && T[(i-1)*Tops+k-1] != LARGE && (T[(j-1)*Tops+k-1] == LARGE || T[(j-1)*Tops+k-1] > T[(j-1)*Tops+i-1] + T[(i-1)*Tops+k-1]))
				{
					H[(j-1)*Tops+k-1] = H[(j-1)*Tops+i-1];  // h j k  h j i
					T[(j-1)*Tops+k-1] = T[(j-1)*Tops+i-1] + T[(i-1)*Tops+k-1];
				}
			}
		}
	}
	if (H[(Source-1)*Tops+Destination-1] == LARGE) 
	{
		Price=-1;
		return;
	}
	int v=Source;
	PathQuery->Push(Source);
	while (v!=Destination)
	{
		v=H[(v-1)*Tops+Destination-1];
		PathQuery->Push(v);
	}
	Price=T[(Source-1)*Tops+Destination-1];
}

BOOL Cycle(CEdge* T, int TCount, int a, int b)
{
	int f=0;
	int g=0;
	for (int i=0; i<TCount; i++)
	{
		if (T[i].i == a || T[i].j == a) f=1;
		if (T[i].i == b || T[i].j == b) g=1;
		if (g && f) return TRUE;
	}
	return FALSE;
}

void Kraskal(CGraph* Graph, CStack* Stack)
{
	CEdge* E = new CEdge[Graph->GetEdges()];
	CEdge* T = new CEdge[Graph->GetEdges()];
	int ECount=0,TCount=0;

	int Tops=Graph->GetTops();
	for (int i=1; i<=Tops; i++)
	{
		for (int j=i+1; j<=Tops; j++)
		{
			if (Graph->IsLinked(i,j))
			{
				E[ECount].i = i;
				E[ECount].j = j;
				E[ECount].Price = Graph->GetPrice(i,j);
				ECount++;
			}
		}
	}
	CEdge Temp;
	for (i=0; i<ECount-1; i++)
	{
		for (int j=i+1; j<=ECount-1; j++)
		{
			if (E[i].Price > E[j].Price)
			{
				Temp=E[i];
				E[i] = E[j];
				E[j] = Temp;
			}
		}
	}
	int k=0;
	for (i=1; i<=Tops-1; i++)
	{
		while (Cycle(T,TCount,E[k].i,E[k].j)) k++;
		T[TCount].i=E[k].i;
		T[TCount].j=E[k].j;
		k++;
		TCount++;
	}
	int v=T[0].i;
	Stack->Push(v);
	for (i=1; i<TCount; i++)
	{
		if (T[i].i == v) v=T[i].j; else v=T[i].i;
		Stack->Push(v);
	}
	delete []T;
	delete []E;
}
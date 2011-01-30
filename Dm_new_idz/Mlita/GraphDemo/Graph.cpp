// Graph.cpp: implementation of the CGraph class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"

#include "Graph.h"
#include "Random.h"
#include <stdlib.h>
#include "Stack.h"
#include <iostream.h>


#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CGraph::CGraph()
{
	// no default constructor because no uninitiliazed graph.
}

CGraph::~CGraph()
{
//	free(m_Adjective);
//	free(m_Cost);
}

CGraph::CGraph(int Tops, int Edges, int Style)
{
	m_error = FALSE;
	m_Edges=0;
	m_Adjective = (int*)malloc(sizeof(int)*Tops*Tops);
	m_Cost = (int*)malloc(sizeof(int)*Tops*Tops);
	for (int i=0; i<Tops; i++)
		for(int j=0; j<Tops; j++)
		{
			m_Adjective[i*Tops+j] = 0;
			m_Cost[i*Tops+j] = LARGECOST;
		}
	m_Tops = Tops;
	m_Style = Style;
	if (Style & Gr_Linked) 
	{
		int* Been = (int*)malloc(sizeof(int)*Tops);
		int c=0,a,b;
		InitRandomQuery(Tops);
		Been[c++]=GetRandom();
		for (int i=0; i<Tops-1; i++)
		{
			a=Random(0,c-1);   
			b=GetRandom();
			Been[c++]=b;
			SetEdge(Been[a],b);
		}
		free(Been);
		DeInitRandomQuery();
	}
	while (Edges != m_Edges)
	{
		int a,b;
		a=Random(1,m_Tops);
		b=Random(1,m_Tops);
		while (a==b || IsLinked(a,b) || (IsPathPresent(a,b) && !(Style & Gr_Cycled)))
		{ 
			a=Random(1,m_Tops);
			b=Random(1,m_Tops); 
		} 
		if (Style & Gr_Cycled)
		{
			SetEdge(a,b);
		}
		else
		{
			SetEdge(a,b);
			ShowAdjectiveMatrix();
		}
	}
}	

int CGraph::GetEdges()
{
	return m_Edges;
}

int CGraph::GetTops()
{
	return m_Tops;
}

int CGraph::GetStyle()
{
	return m_Style;
}

void CGraph::SetEdge(int i, int j)
{
	ASSERT(i!=j);
	ASSERT(!IsLinked(i,j));
	i--;
	j--;
	m_Edges++;
	if (m_Style & Gr_Oriented)
	{
		if (m_Style & Gr_Price)
		{
			if (m_Style & Gr_Positive)
			{
				m_Cost[i*m_Tops+j] = Random(1,1000);
				m_Adjective[i*m_Tops+j] = 1;
			}
			else
			{
				m_Cost[i*m_Tops+j] = Random(-500,500);
				m_Adjective[i*m_Tops+j] = 1;
			}
		}
		else
		{
			m_Cost[i*m_Tops+j] = 1;
			m_Adjective[i*m_Tops+j] = 1;
		}
	}
	else
	{
		if (m_Style & Gr_Price)
		{
			if (m_Style & Gr_Positive)
			{
				m_Cost[i*m_Tops+j] = Random(1,1000);
				m_Cost[j*m_Tops+i] = Random(1,1000);
				m_Adjective[i*m_Tops+j] = 1;
				m_Adjective[j*m_Tops+1] = 1;
			}
			else
			{
				m_Cost[i*m_Tops+j] = Random(-500,500);
				m_Cost[j*m_Tops+i] = Random(-500,500);
				m_Adjective[i*m_Tops+j] = 1;
				m_Adjective[j*m_Tops+1] = 1;
			}
		}
		else
		{
			m_Adjective[i*m_Tops+j] = 1;
			m_Adjective[j*m_Tops+i] = 1;
			m_Cost[i*m_Tops+j] = 1;
			m_Cost[j*m_Tops+i] = 1;
		}
	}
}

void CGraph::ShowAdjectiveMatrix()
{
	cout << endl;
	for (int i=0; i<m_Tops; i++)
	{
		for (int j=0; j<m_Tops; j++)
		{
			cout << m_Adjective[i*m_Tops+j] << "  ";
		}
		cout << endl;
	}
}

void CGraph::ShowCostMatrix()
{
	cout << endl;
	for (int i=0; i<m_Tops; i++)
	{
		for (int j=0; j<m_Tops; j++)
		{
			cout << m_Cost[i*m_Tops+j] << "  ";
		}
		cout << endl;
	}

}

bool CGraph::IsLinked(int i, int j)
{
	i--;j--;
//	ShowAdjectiveMatrix();
	return m_Adjective[i*m_Tops+j] !=0;
}

BOOL CGraph::IsPathPresent(int i, int j)
{
	CStack* Stack=new CStack;
	int* X=new int[m_Tops+1];
	for (int k=1; k<=m_Tops; k++) X[k] = 0;
	X[i]=1;
	k=i;
	Stack->Push(i);
	while (!Stack->IsEmpty())
	{
		int f=0;
		for (int l=1; l<=m_Tops; l++)
		{
			if (!X[l] && IsLinked(k,l))
			{
				X[l]=1;
				Stack->Push(l);
				f=l;
			}
		}
		if (!f)
		{
			Stack->Pop();
		}
		else 
		{
			k=f;
		}
	}
	delete Stack;
	BOOL Ret=X[j] == TRUE;
	delete []X;
	return Ret;
}

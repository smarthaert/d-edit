// Graph.cpp: implementation of the CGraph class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"

#include "Graph.h"
#include "Random.h"
#include <stdlib.h>

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
		if (Edges < Tops) 
		{
			// this graph cant be linkeed!!!!
			AfxMessageBox("Error edges count!",MB_OK,0);
			return;
		}
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
	cout << i << " - " << j << endl;
	i--;
	j--;
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

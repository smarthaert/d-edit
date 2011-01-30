// Graph.cpp: implementation of the CGraph class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
//#include "Exam.h"
#include "Graph.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
int Random(int n)
{
	return rand() % n +1;
}

CGraph::CGraph()
{
	m_V = 0;
	m_E = 0;
	m_Style = 0;
}

CGraph::CGraph(int Tops,int Edges, int Style )
{
	m_V = Tops;
	m_E = 0;
	m_Style = Style;
	Init();
	Generate(Tops,Edges);
}

CGraph::~CGraph()
{
//	DestroyGraph();
}

//DEL void CGraph::DestroyGraph()
//DEL {
//DEL }


int CGraph::Generate(int VC, int EC)
{  // Graph must be initialized!!! no checking!
	if (m_Style & Gr_Bounds) // связанный
	{
		int r,d;
		bool been[MaxTops];
		for (int i=0; i<MaxTops; i++) been[i] = false;
		int Start=r=Random(VC);
		for (i=0; i<VC-1; i++)
		{
			do 
			{
				d=Random(VC);
			}
			while ( d==Start || been[d]);
			been[d] = true;
			AddEdge(r,d);
			r=d;
		}
		AddEdge(d,Start);
	}
	while (m_E != EC)
	{
		int r=Random(VC);
		int s=Random(VC);
		if (!(m_Style & Gr_HasCycles) && !IsCycleForm(r,s)) if (!IsLinked(r,s) && r!=s) AddEdge(r,s);
	}

	return 0;
}

void CGraph::Init()
{
//	DeInit();
	for (int i=0; i<=m_V*m_V; i++) 
		for (int j=0; j<=m_V; j++) M[i][j]=C[i][j]=0;
}

//DEL void CGraph::DeInit()
//DEL {
//DEL //	if (C) free(C);
//DEL //	if (H) free(H);
//DEL //	if (M) free(M);
//DEL }

bool CGraph::IsLinked(int i, int j)
{
	if (i==j) return 1;
	if (m_Style & Gr_Oriented) 
		return M[i][j];
	else
		return M[i][j]||M[j][i];
}

int CGraph::AddEdge(int i, int j)
{
	int Ret = 0;
	Ret = M[i][j]+M[j][i];
	E[m_E].i=i;
	E[m_E].j=j;
	M[i][j] = 1;
	if (m_Style & Gr_Oriented) ; else M[j][i] = 1;
	if (m_Style & Gr_Fluidized)
	{
		C[i][j] = Random(MAXCOST);
		if (!(m_Style & Gr_Positive)) C[i][j] =C[i][j] - MAXCOST /2;
		if (m_Style & Gr_Oriented) C[j][i] = LARGECOST; else C[j][i] = C[i][j];
	}

	if (!Ret) m_E++;

	
	return Ret;
	
}

Edge CGraph::GetEdge(int i)
{
	return E[i];
}

bool CGraph::IsCycleForm(int r, int s)
{
	return false;
}

// Graph.h: interface for the CGraph class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_GRAPH_H__D4420E91_2B6E_4BED_810B_2F9AAAF8785F__INCLUDED_)
#define AFX_GRAPH_H__D4420E91_2B6E_4BED_810B_2F9AAAF8785F__INCLUDED_

#if _MSC_VER > MaxTops0
#pragma once
#endif // _MSC_VER > MaxTops0
#define Gr_Oriented   0x0000000000000001
#define Gr_HasCycles  0x0000000000000010
#define Gr_Positive   0x0000000000000100
#define Gr_Fluidized  0x0000000000001000
#define Gr_Bounds     0x0000000000010000
#define MaxTops 10
#define MAXCOST 500
#define LARGECOST 32000

int Random(int n, int j);
struct Edge
{
	int i,j;
};

class CGraph  
{
public:
	bool IsCycleForm(int r, int s);
	Edge GetEdge(int i);
	int AddEdge(int i, int j);
	bool IsLinked(int i, int j);
	CGraph(int Tops, int Edged, int Style);
	int Generate(int VC, int VE);
	virtual ~CGraph();
	int GetEdgesCount() {return m_E;}
	int GetTopsCount()  {return m_V;}
private:
	void Init();
// private variables
	int m_Style;
	int m_V;			// число вершин
	int m_E;			// число ребер
	int C[MaxTops][MaxTops];				// матрица вес
	int H[MaxTops][MaxTops];             // матрица инциденций
	int M[MaxTops][MaxTops];             // матрица смежности
	Edge E[(MaxTops-1)*MaxTops/2];				// массив ребер
// private functions
	CGraph();
};

#endif // !defined(AFX_GRAPH_H__D4420E91_2B6E_4BED_810B_2F9AAAF8785F__INCLUDED_)

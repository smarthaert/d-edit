// Graph.h: interface for the CGraph class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_GRAPH_H__AAD44AE0_5BE7_404A_A5D7_51F0E7602E72__INCLUDED_)
#define AFX_GRAPH_H__AAD44AE0_5BE7_404A_A5D7_51F0E7602E72__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#define Gr_Oriented		0x0000000000000001
#define Gr_Price		0x0000000000000010
#define Gr_Linked	    0x0000000000000100
#define Gr_Positive		0x0000000000001000
#define Gr_Cycled       0x0000000000010000
#define LARGECOST       32000
#define MAXCOST         100



class CGraph  
{
public:
	int GetPrice(int i, int j);
	BOOL IsPathPresent(int i, int j);
	BOOL m_error;
	bool IsLinked(int i, int j);
	int* m_Adjective;
	void ShowCostMatrix();
	void ShowAdjectiveMatrix();
	int* m_Cost;
	int GetStyle();
	CGraph(int Tops, int Edges, int Style);
	int GetEdges();
	int GetTops();
	virtual ~CGraph();

private:
	void SetEdge(int i, int j);
	int m_Style;
	int m_Tops;
	int m_Edges;
	CGraph();
};

#endif // !defined(AFX_GRAPH_H__AAD44AE0_5BE7_404A_A5D7_51F0E7602E72__INCLUDED_)

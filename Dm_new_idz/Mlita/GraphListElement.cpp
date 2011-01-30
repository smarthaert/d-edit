// GraphListElement.cpp: implementation of the CGraphListElement class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "Mlita.h"
#include "GraphListElement.h"
//#include "Graph.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CGraphListElement::CGraphListElement(int V, int E, int Style)
{
	Next = NULL;
	m_Graph = new CGraph(V,E,Style);
}

CGraphListElement::~CGraphListElement()
{
	delete m_Graph;
	Next = NULL;
}

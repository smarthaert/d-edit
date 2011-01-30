// GraphListElement.h: interface for the CGraphListElement class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_GRAPHLISTELEMENT_H__BA89215B_E5BC_4968_9B57_D841870AC3D1__INCLUDED_)
#define AFX_GRAPHLISTELEMENT_H__BA89215B_E5BC_4968_9B57_D841870AC3D1__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
#include "Graph.h"
//class CGraph;

class CGraphListElement  
{
public:
	CGraph* m_Graph;
	CGraphListElement* Next;
	CGraphListElement(int V, int E, int Style);
	virtual ~CGraphListElement();

};

#endif // !defined(AFX_GRAPHLISTELEMENT_H__BA89215B_E5BC_4968_9B57_D841870AC3D1__INCLUDED_)

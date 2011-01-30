// GraphList.cpp: implementation of the CGraphList class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "Mlita.h"
#include "GraphList.h"
#include "GraphListElement.h"
#include "Graph.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CGraphList::CGraphList()
{
	Top=NULL;
	Last=NULL;
	m_GraphCount = 0;
}

CGraphList::~CGraphList()
{
	DestroyList();
}

void CGraphList::DestroyList()
{
	CGraphListElement* Current=Top,*Next=NULL;
	while (Current)
	{
		Next = Current->Next;
		delete Current;
		Current = Next;
	}
	Top=NULL;
	Last = NULL;
	m_GraphCount = 0;
}

CGraph* CGraphList::Add(int V, int E, int Style)
{
	CGraphListElement* New = new CGraphListElement(V, E, Style);
	if (Last) Last->Next = New; else 
	{
		Top = New;
		Last = New;
	}
	m_GraphCount++;
	return New->m_Graph;
}

CGraph* CGraphList::GetByID(int nIndex)
{
	CGraphListElement* Current=Top;
	int i=0;
	while (Current && i!=nIndex)
	{
		Current = Current->Next;
	}
	if (Current) return Current->m_Graph; else return NULL;
	return NULL;
}

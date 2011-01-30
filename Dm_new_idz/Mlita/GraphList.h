// GraphList.h: interface for the CGraphList class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_GRAPHLIST_H__78D43287_2B4E_4CE6_93EA_6A756503C5D6__INCLUDED_)
#define AFX_GRAPHLIST_H__78D43287_2B4E_4CE6_93EA_6A756503C5D6__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
class CGraphListElement;
class CGraph;

class CGraphList  
{
public:
	CGraph* GetByID(int nIndex);
	int m_GraphCount;
	CGraphListElement* Last;
	CGraph* Add(int V, int E, int Style);
	CGraphListElement* Top;
	void DestroyList();
	CGraphList();
	virtual ~CGraphList();

};

#endif // !defined(AFX_GRAPHLIST_H__78D43287_2B4E_4CE6_93EA_6A756503C5D6__INCLUDED_)

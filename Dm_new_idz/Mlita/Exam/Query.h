// Query.h: interface for the CQuery class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_QUERY_H__8212A288_BE62_4F26_B679_75E998F2A3FE__INCLUDED_)
#define AFX_QUERY_H__8212A288_BE62_4F26_B679_75E998F2A3FE__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
class CQueryElement;

class CQuery  
{
public:
	BOOL IsEmpty();
	int Pop();
	void Push(int V);
	CQueryElement* Last;
	CQueryElement* Top;
	void FreeMemory();
	CQuery();
	virtual ~CQuery();

};

#endif // !defined(AFX_QUERY_H__8212A288_BE62_4F26_B679_75E998F2A3FE__INCLUDED_)

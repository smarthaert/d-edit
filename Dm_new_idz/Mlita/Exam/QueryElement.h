// QueryElement.h: interface for the CQueryElement class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_QUERYELEMENT_H__A2EAEBF9_D7B9_4E35_8E74_C878E73D4A34__INCLUDED_)
#define AFX_QUERYELEMENT_H__A2EAEBF9_D7B9_4E35_8E74_C878E73D4A34__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class CQueryElement  
{
public:
	CQueryElement* Prev;
	CQueryElement* Next;
	int V;
	CQueryElement();
	virtual ~CQueryElement();

};

#endif // !defined(AFX_QUERYELEMENT_H__A2EAEBF9_D7B9_4E35_8E74_C878E73D4A34__INCLUDED_)

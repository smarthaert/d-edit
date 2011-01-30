// StackElement.h: interface for the CStackElement class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_STACKELEMENT_H__F3F05BE5_5EEA_435E_8BA9_15DD3BE137B7__INCLUDED_)
#define AFX_STACKELEMENT_H__F3F05BE5_5EEA_435E_8BA9_15DD3BE137B7__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

class CStackElement  
{
public:
	CStackElement* Prev;
	int V;
	CStackElement();
	virtual ~CStackElement();

};

#endif // !defined(AFX_STACKELEMENT_H__F3F05BE5_5EEA_435E_8BA9_15DD3BE137B7__INCLUDED_)

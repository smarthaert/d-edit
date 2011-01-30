// Stack.h: interface for the CStack class.
//
//////////////////////////////////////////////////////////////////////

#if !defined(AFX_STACK_H__5B030EE2_9F61_4494_B020_CA71DC52E99D__INCLUDED_)
#define AFX_STACK_H__5B030EE2_9F61_4494_B020_CA71DC52E99D__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000
class CStackElement;

class CStack  
{
public:
	BOOL IsEmpty();
	int Pop();
	void FreeMemory();
	CStackElement* Top;
	void Push(int V);
	CStack();
	virtual ~CStack();

};

#endif // !defined(AFX_STACK_H__5B030EE2_9F61_4494_B020_CA71DC52E99D__INCLUDED_)

// Stack.cpp: implementation of the CStack class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "Stack.h"
#include "StackElement.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CStack::CStack()
{
	Top = NULL;
}

CStack::~CStack()
{
	FreeMemory();
}

void CStack::Push(int V)
{
	CStackElement* New=new CStackElement;
	New->Prev=Top;
	New->V = V;
	Top = New;
}

void CStack::FreeMemory()
{
	CStackElement* Current=Top, *Prev=NULL;
	while (Current)
	{
		Prev = Current->Prev;
		delete Current;
		Current = Prev;
	}
	Top=NULL;
}

int CStack::Pop()
{
	if (!IsEmpty())
	{
		int Ret=Top->V;
		CStackElement* Prev=Top->Prev;
		delete Top;
		Top=Prev;
		return Ret;
	}
	else
		return -1;
}

BOOL CStack::IsEmpty()
{
	return Top==NULL;
}

// Query.cpp: implementation of the CQuery class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "Exam.h"
#include "Query.h"
#include "QueryElement.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CQuery::CQuery()
{
	Top=NULL;
	Last=NULL;
}

CQuery::~CQuery()
{
	FreeMemory();
}

void CQuery::FreeMemory()
{
	CQueryElement* Current=Top,*Next=NULL;
	while (Current)
	{
		Next=Current->Next;
		delete Current;
		Current = Next;
	}
	Last=NULL;
	Top=NULL;
}

void CQuery::Push(int V)
{
	CQueryElement* New=new CQueryElement;
	if (!Last)
	{
		Last=New;
	}
	New->V = V;
	New->Next = Top;
	New->Prev = NULL;
	if (Top) Top->Prev = New;
	Top = New;
}

int CQuery::Pop()
{
	CQueryElement* Next=Top->Next,*Prev=Last->Prev;
	int Ret=Last->V;
	delete Last;
	if (Prev) 
	{
		Prev->Next=NULL;
	}
	else Top=NULL;
	Last=Prev;
	return Ret;
}

BOOL CQuery::IsEmpty()
{
	if (!Top) return TRUE; else return FALSE;
}

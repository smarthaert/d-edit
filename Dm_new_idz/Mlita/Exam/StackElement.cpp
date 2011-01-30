// StackElement.cpp: implementation of the CStackElement class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "Exam.h"
#include "StackElement.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CStackElement::CStackElement()
{
	Prev = NULL;
	V=0;
}

CStackElement::~CStackElement()
{

}

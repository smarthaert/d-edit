// QueryElement.cpp: implementation of the CQueryElement class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "Exam.h"
#include "QueryElement.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

CQueryElement::CQueryElement()
{
	V=0;
	Next=NULL;
	Prev=NULL;
}

CQueryElement::~CQueryElement()
{

}

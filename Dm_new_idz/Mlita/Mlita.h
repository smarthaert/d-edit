// Mlita.h : main header file for the MLITA application
//

#if !defined(AFX_MLITA_H__B0928C05_FB2D_4D52_8E61_072355CCD719__INCLUDED_)
#define AFX_MLITA_H__B0928C05_FB2D_4D52_8E61_072355CCD719__INCLUDED_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000

#ifndef __AFXWIN_H__
	#error include 'stdafx.h' before including this file for PCH
#endif

#include "resource.h"		// main symbols

/////////////////////////////////////////////////////////////////////////////
// CMlitaApp:
// See Mlita.cpp for the implementation of this class
//

class CMlitaApp : public CWinApp
{
public:
	CMlitaApp();

// Overrides
	// ClassWizard generated virtual function overrides
	//{{AFX_VIRTUAL(CMlitaApp)
	public:
	virtual BOOL InitInstance();
	//}}AFX_VIRTUAL

// Implementation

	//{{AFX_MSG(CMlitaApp)
		// NOTE - the ClassWizard will add and remove member functions here.
		//    DO NOT EDIT what you see in these blocks of generated code !
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
};


/////////////////////////////////////////////////////////////////////////////

//{{AFX_INSERT_LOCATION}}
// Microsoft Visual C++ will insert additional declarations immediately before the previous line.

#endif // !defined(AFX_MLITA_H__B0928C05_FB2D_4D52_8E61_072355CCD719__INCLUDED_)

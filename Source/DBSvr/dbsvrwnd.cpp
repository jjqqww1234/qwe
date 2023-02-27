
#include "tablesdefine.h"
#include "dbsvrwnd.h"
#include <registry.h>


CDBSvrWnd::CDBSvrWnd()
{
	m_pTitle = "Legend Of Mir2 V20040901- DB Server";
	memset( &m_conf, 0, sizeof( m_conf ) );
}


CDBSvrWnd::~CDBSvrWnd()
{
}


bool CDBSvrWnd::OnInit()
{
	CRegistry reg;
	reg.OpenKey( "LegendOfMir\\DatabaseSvr" );

	if ( !reg.GetString( "NAME", m_conf.szName, DLG_MAXSTR )		||
		 !reg.GetString( "ODBC_DSN", m_conf.szOdbcDSN, DLG_MAXSTR )	||
		 !reg.GetString( "ODBC_ID", m_conf.szOdbcID, DLG_MAXSTR )	||
		 !reg.GetString( "ODBC_PW", m_conf.szOdbcPW, DLG_MAXSTR )	||
		 !reg.GetString( "LS_ADDR", m_conf.szLSAddr, DLG_MAXSTR )	||
		 !reg.GetString( "MF_FILEPATH", m_conf.szMFFilePath, DLG_MAXSTR )	||
		 !reg.GetInteger( "LS_CPORT", &m_conf.nLScPort )			||
		 !reg.GetInteger( "GS_BPORT", &m_conf.nGSbPort )			||
		 !reg.GetInteger( "RG_BPORT", &m_conf.nRGbPort )			||
		 !reg.GetString( "ODBC_DSN2", m_conf.szOdbcDSN2, DLG_MAXSTR ) ||
		 !reg.GetString( "ODBC_ID2", m_conf.szOdbcID2, DLG_MAXSTR ) ||
		 !reg.GetString( "ODBC_PW2", m_conf.szOdbcPW2, DLG_MAXSTR ) )
	{		
		PostMessage( m_hWnd, WM_COMMAND, IDM_CONFIGURATION, 0 );
	}

	reg.CloseKey();	

	return true;
}


void CDBSvrWnd::OnUninit()
{
	m_dbServer.Cleanup();
}


void CDBSvrWnd::OnStartService()
{
	char	szTitle[128];

	sprintf(szTitle, "%s - DB Server [%s]",m_pTitle,GetCfg()->szName);
	SetWindowText(m_hWnd, szTitle);

	if ( !m_dbServer.Startup() )
	{
		m_dbServer.Cleanup();
		return;
	}

	EnableCtrl( false );
}


void CDBSvrWnd::OnStopService()
{
	m_dbServer.Cleanup();

	EnableCtrl( true );
}


void CDBSvrWnd::OnConfiguration()
{
	CDlgConfig dlg;

	if ( dlg.DoModal( m_hInstance, m_hWnd ) == IDOK )
		m_conf = dlg.m_conf;
}


long CDBSvrWnd::OnTimer( int nTimerID )
{
	m_dbServer.OnTimer( nTimerID );
	return 0;
}


static CDBSvrWnd *g_pWnd;


CMir2Wnd * OnCreateInstance()
{
	return g_pWnd = new CDBSvrWnd;
}


void OnDestroyInstance( CMir2Wnd *pWnd )
{
	if ( pWnd )
	{
		delete pWnd;
		pWnd = NULL;
	}
}


CDBSvrWnd * GetApp()
{
	return g_pWnd;
}


SCFG * GetCfg()
{
	return &g_pWnd->m_conf;
}


CDBServer * GetDBServer()
{
	return &g_pWnd->m_dbServer;
}


CDBSvrOdbcPool * GetOdbcPool()
{
	return &g_pWnd->m_dbServer.m_dbPool;
}

CDBSvrOdbcPool * GetAcntOdbcPool()
{
	return &g_pWnd->m_dbServer.m_AcntDBPool;
}

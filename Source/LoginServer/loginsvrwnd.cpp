

#include "loginsvrwnd.h"
#include "database.h"
#include <registry.h>
#include <stdio.h>
#include <stdlib.h>


CLoginSvrWnd::CLoginSvrWnd()
{
	m_pTitle = "Legend of Mir 2 - Login Server V20050524";
	memset( &m_conf, 0, sizeof( m_conf ) );
}


CLoginSvrWnd::~CLoginSvrWnd()
{
}


bool CLoginSvrWnd::OnInit()
{	
	CRegistry reg;
	reg.OpenKey( "LegendOfMir\\LoginSvr" );

	if ( !reg.GetString( "ODBC_DSN", m_conf.szOdbcDSN, DLG_MAXSTR )	||
		 !reg.GetString( "ODBC_ID", m_conf.szOdbcID, DLG_MAXSTR )	||
		 !reg.GetString( "ODBC_PW", m_conf.szOdbcPW, DLG_MAXSTR )	||
		 !reg.GetString( "ODBC_DSN_PC", m_conf.szOdbcDSN_PC, DLG_MAXSTR )	||
		 !reg.GetString( "ODBC_ID_PC", m_conf.szOdbcID_PC, DLG_MAXSTR )	||
		 !reg.GetString( "ODBC_PW_PC", m_conf.szOdbcPW_PC, DLG_MAXSTR )	||
		 !reg.GetInteger( "CS_BPORT", &m_conf.nCSbPort )			||
		 !reg.GetInteger( "GS_BPORT", &m_conf.nGSbPort )			||
		 !reg.GetInteger( "LG_BPORT", &m_conf.nLGbPort ) )
	{		
		PostMessage( m_hWnd, WM_COMMAND, IDM_CONFIGURATION, 0 );
	}

	reg.CloseKey();	

	return true;
}


void CLoginSvrWnd::OnUninit()
{
	m_loginSvr.Cleanup();
}


void CLoginSvrWnd::OnStartService()
{
	if ( !m_loginSvr.Startup() )
	{
		m_loginSvr.Cleanup();
		return;
	}

	EnableCtrl( false );
}

void CLoginSvrWnd::OnReload()
{
	//각종 세팅 다시 읽기
	GetLoginServer()->LoadDBTables();

}


void CLoginSvrWnd::OnStopService()
{
	m_loginSvr.Cleanup();

	EnableCtrl( true );
}


void CLoginSvrWnd::OnConfiguration()
{
	CDlgConfig dlg;

	if ( dlg.DoModal( m_hInstance, m_hWnd ) == IDOK )
		m_conf = dlg.m_conf;
}

void CLoginSvrWnd::OnInitDB()
{
	// 2003/01/22...미구현
	// 1. Delete TBL_USINGIP where FLD_GAMETYPE='MIR2'
	// 2. Update TBL_DUPIP Set FLD_ISOK='1' where FLD_GAMETYPE='MIR2'
	// 3. Update MR3_PCRoomStatusTable Set PCRoomStatus_UsingIPCount = 0

	CConnection *pConnPC = GetLoginServer()->m_dbPoolPC.Alloc();
	CRecordset  *pRec = NULL;
	int  nPCRoomIndex = 0;
	char szQuery[1024];

	if ( !pConnPC )
		return;

	// 1. Delete TBL_USINGIP where FLD_GAMETYPE='MIR2'
	sprintf( szQuery, "DELETE TBL_USINGIP WHERE FLD_GAMETYPE='%s'", GetLoginServer()->m_szGameType );
#ifdef _DEBUG
	GetApp()->SetLog( 0, "[SQL QUERY] %s", szQuery);
#endif
	pRec = pConnPC->CreateRecordset();
	if(pRec)
		pRec->Execute( szQuery );
	pConnPC->DestroyRecordset( pRec );

	// 2. Update TBL_DUPIP Set FLD_ISOK='1' where FLD_GAMETYPE='MIR2'
	sprintf( szQuery, "UPDATE TBL_DUPIP SET FLD_ISOK='1' WHERE FLD_GAMETYPE='%s'", GetLoginServer()->m_szGameType );
#ifdef _DEBUG
	GetApp()->SetLog( 0, "[SQL QUERY] %s", szQuery);
#endif
	pRec = pConnPC->CreateRecordset();
	if(pRec)
		pRec->Execute( szQuery );
	pConnPC->DestroyRecordset( pRec );

	// 3. Update MR3_PCRoomStatusTable Set PCRoomStatus_UsingIPCount = 0
	sprintf( szQuery, "UPDATE MR3_PCRoomStatusTable SET PCRoomStatus_UsingIPCount = 0" );
#ifdef _DEBUG
	GetApp()->SetLog( 0, "[SQL QUERY] %s", szQuery);
#endif
	pRec = pConnPC->CreateRecordset();
	if(pRec)
		pRec->Execute( szQuery );
	pConnPC->DestroyRecordset( pRec );

	GetLoginServer()->m_dbPoolPC.Free( pConnPC );
}

void CLoginSvrWnd::OnNotInService()
{
	char szCaption[100];
	strcpy(szCaption, m_pTitle);
	
	GetLoginServer()->m_IsNotInServiceMode = !(GetLoginServer()->m_IsNotInServiceMode);
	if(GetLoginServer()->m_IsNotInServiceMode)
	{
		strcat(szCaption, "(NOT IN SERVICE MODE)");
		SetWindowText(m_hWnd,szCaption);
		GetApp()->SetLog( 0, "LoginServer is not In Service Mode");
	}
	else
	{
		strcat(szCaption, "(SERVICE MODE)");
		SetWindowText(m_hWnd,szCaption);
		GetApp()->SetLog( 0, "LoginServer is  In Service Mode");
	}
}

long CLoginSvrWnd::OnTimer( int nTimerID )
{
	m_loginSvr.OnTimer( nTimerID );
	return 0;
}

static CLoginSvrWnd *g_pWnd;


CMir2Wnd * OnCreateInstance()
{
	return g_pWnd = new CLoginSvrWnd;
}


void OnDestroyInstance( CMir2Wnd *pWnd )
{
	if ( pWnd )
	{
		delete pWnd;
		pWnd = NULL;
	}
}


CLoginSvrWnd * GetApp()
{
	return g_pWnd;
}


SCFG * GetCfg()
{
	return &g_pWnd->m_conf;
}

CLoginSvr * GetLoginServer()
{
	return &g_pWnd->m_loginSvr;
}


CDBSvrOdbcPool * GetOdbcPool()
{
	return &g_pWnd->m_loginSvr.m_dbPool;
}

CDBSvrOdbcPool * GetOdbcPoolPC()
{
	return &g_pWnd->m_loginSvr.m_dbPoolPC;
}

int GetTimeInfo(char* buf)
{
	char yyyy[10], mm[10], dd[10];
	char hour[10], min[10], sec[10], msec[10];
	struct tm *temp;

	sscanf( buf, "%[^-]-%[^-]-%s %[^:]:%[^:]:%[^.].%s", yyyy, mm, dd, hour, min, sec, msec );


	temp = (tm*)malloc(sizeof(tm));	



	temp->tm_year = atoi(yyyy);
	temp->tm_mon = atoi(mm);
	temp->tm_mday = atoi(dd);
	temp->tm_hour = atoi(hour);
	temp->tm_min = atoi(min);
	temp->tm_sec = atoi(sec);

	if(strlen(buf)==0)
		return 0;

	return GetDay(temp->tm_year, temp->tm_mon, temp->tm_mday);
}


int GetDay (int iYear, int iMonth, int iDay)
{
    /*
    1. 1년은 평년 (365)
    2. 4년 마다 윤년 (366)
    3. 100년 단위는 평년.
    4. 400년 단위는 윤년.
    */
    int i=0;
    int iTotalDay=0;
    int iTemp=0;
    bool bYun;
    for (i=1; i<iYear; i++)
    {
        if (i%400 == 0)
            iTemp=366;
        else if (i%100 == 0)
            iTemp=365;
        else if (i%4 == 0)
            iTemp=366;
        else
            iTemp=365;
        iTotalDay += iTemp;
    }
    if (iYear%400 == 0)
        bYun=true;
    else if (iYear%100 == 0)
        bYun=false;
    else if (iYear%4 == 0)
        bYun=true;
    else
        bYun=false;

    for (i=1; i<iMonth; i++)
    {
        if (i==2 && bYun == true)
            iTotalDay += 29;    //--- 윤년
        else if (i==2 && bYun == false)
            iTotalDay += 28;    //--- 평년
        else if (i%2==0)
            iTotalDay += 30;
        else
            iTotalDay += 31;
    }
    iTotalDay += iDay;
    return iTotalDay;
}

bool isCorrectSsn(char * szSsn)
{
	int i;
	//13개 자리인지 체크
	if(strlen(szSsn) !=13)
		return false;

	//숫자인지체크
	for(i=0; i <=12; i++)
	{
		if((szSsn[i] < '0')||(szSsn[i] >'9'))
		{
			return false;
		}

	}

	//주민등록번호규칙에 맞는지 체크
	int iSum = 0;
	char szTemp[2];
	
	for( i=0 ; i<=11; i++)
	{
		strncpy(szTemp, szSsn+i,1);
		szTemp[1] = NULL;
		iSum = iSum + (i % 8+2)*atoi(szTemp);
	}

	iSum =  11 - (iSum % 11);
	iSum = iSum % 10;
	if(iSum != atoi(szSsn+12))
	{
		return false;
	}

	return true;
}

bool isOlderthen15(char *szSsn)
{
	SYSTEMTIME st;
    GetSystemTime(&st); 
	int nCurrentTime = GetDay(st.wYear, st.wMonth, st.wDay);
	
	char szTemp[7];
	strncpy(szTemp, szSsn, 6);
	szTemp[6] = NULL;
	
	int iYear, iMonth, iDay ;
	char szYear[3], szMonth[3], szDay[3];

	strncpy(szYear, szSsn,2);
	strncpy(szMonth, szSsn+2,2);
	strncpy(szDay, szSsn+4,2);

	szYear[3] = NULL;
	szMonth[3] = NULL;
	szDay[3] = NULL;

	iYear = atoi(szYear);
	iMonth = atoi(szMonth);
	iDay = atoi(szDay);

	if(iYear > 10)
	{
		iYear = iYear + 1900;
	}
	else
	{
		iYear = iYear + 2000;
	}
	
	
	int nUserDay = GetDay(iYear, iMonth, iDay);

	if((nCurrentTime - nUserDay) >= 365*15)
	{
		return true;
	}
	else
	{
		return false;
	}
}

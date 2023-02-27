/*


	FLD_SECEDE 가  Y 이면 탈퇴
*/
#include "netlogingate.h"
#include "loginsvrwnd.h"
#include "../common/mir2packet.h"
#include <stringex.h>
#include <stdlib.h>
#include <stdio.h>
#include <time.h>

// Update Log...2003/01/08 COPark
// ClientVersion Check를 위해 버젼 번호 삽입
#define VERSION_NUMBER	20030729
// Italya company ip is 217.65.66.10 test 때문에 11 로 바꿈
#define COMPANY_IP		"217.65.65.71" 
const int AllowIDCount = 9;
const char AllowID[AllowIDCount][30] = {
	"armdri",
	"jjanggu",
	"wemade",
	"blackrice",
	"ipheader",
	"salyro",
	"t13agha9",
	"hardlife",
	"levipsy"
	"courtyard"
};
static struct sLoginGateCmdList
{
	int  nPacketID;
	bool (CLoginGate:: *pfn)( sGateUser *pUser, char *pBody, _TDEFAULTMESSAGE msg  );
} g_GateCmdList[] = 
{
	CM_IDPASSWORD,		&CLoginGate::OnIdPassword,
	CM_SELECTSERVER,	&CLoginGate::OnSelectServer,
	CM_PROTOCOL,        &CLoginGate::OnProtocol,
};


static const int g_nGateCmdCnt = sizeof( g_GateCmdList ) / sizeof( g_GateCmdList[0] );


CLoginGate::CLoginGate( SOCKET sdClient, sTblPubIP *pGateInfo )
{
	SetClassId( CLASSID );
	SetAcceptedSocket( sdClient );
	
	m_dbInfo			= *pGateInfo;	
	m_nCntInvalidPacket	= 0;

	m_listUser.InitHashTable( MAX_GATEUSER_HASHSIZE, IHT_ROUNDUP );
	m_listUser.SetGetKeyFunction( __cbGetUserKey );
}


CLoginGate::~CLoginGate()
{
	m_listUser.UninitHashTable();
}


bool CLoginGate::SendKickUser( sGateUser *pUser )
{
	CMir2Packet *pPacket = new CMir2Packet;
	pPacket->Attach( "%+-" );
	pPacket->Attach( pUser->szUserHandle );
	pPacket->Attach( "$" );

	Lock();
	bool bRet = Send( pPacket );
	Unlock();

	return bRet;
}


bool CLoginGate::SendResponse( sGateUser *pUser,
							   int nPacketID, 
							   int nRecog, int nParam, int nTag, int nSeries, char *pData )
{
	_TDEFAULTMESSAGE defMsg;
	fnMakeDefMessage( &defMsg, nPacketID, nRecog, nParam, nTag, nSeries );

	CMir2Packet *pPacket = new  CMir2Packet;
	pPacket->Attach( "%" );
	pPacket->Attach( pUser->szUserHandle );
	pPacket->Attach( "/#" );
	pPacket->AttachWithEncoding( (char *) &defMsg, sizeof( defMsg ) );

	if ( pData )
		pPacket->AttachWithEncoding( pData, strlen( pData ) );

	pPacket->Attach( "!$" );

#ifdef _DEBUG
	GetApp()->SetLog( 0, "[LoginGate/Send] %s", pPacket->m_pPacket);
#endif
	
	Lock();
	bool bRet = Send( pPacket );
	Unlock();

	return bRet;
}

bool CLoginGate::AllowIDCheck( char *UserID )
{
	if ( UserID == NULL ) return false;

	for ( int i = 0 ; i < AllowIDCount ; i++)
	{
		if ( strcmp( UserID , &AllowID[i][0] ) == 0 ) return true;
	}
	return false;
}
/*
	CM_IDPASSWORD
*/
bool CLoginGate::OnIdPassword( sGateUser *pUser, char *pBody, _TDEFAULTMESSAGE msg )
{
	bstr szID, szPW;
	_pickstring( pBody, '/', 0, &szID );
	_pickstring( pBody, '/', 1, &szPW );

	strcpy( pUser->szID, szID );
	pUser->nClientVersion = msg.nRecog;

	bool idcheck = false;
	for ( int i = 0 ; i < strlen(pUser->szID) -1 ; i++)
	{
		switch ( pUser->szID[i] )
		{
		case '/':
		case '-':
		case ';':	idcheck = true;
		}
	}

	if( idcheck == true )
	{
		GetApp()->SetLog( 0, "ID WRONG:%s , IP:%s",pUser->szID , pUser->szAddr);
	    SendResponse( pUser, SM_PASSWD_FAIL, -6, 0, 0, 0 );
		return true;
	}

	// 2003/02/18 추가된부분//211.214.89.250 -> 211.78.137.114 (Taiwan)
	if(GetLoginServer()->m_IsNotInServiceMode /*&& (strcmp( pUser->szAddr , COMPANY_IP )!=0)*/ )	 // 218.144.171.253"
	{
		if ( (pUser->szAddr != NULL) && (strncmp(pUser->szAddr, COMPANY_IP, 10) == 0) )
		{
				GetApp()->SetLog( 0, "USER:%s , IP:%s",pUser->szID , pUser->szAddr);
		}
		else
		{
			if ( !AllowIDCheck(pUser->szID) )
			{	
				SendResponse( pUser, SM_NOT_IN_SERVICE, 0, 0, 0, 0 );
				return false;
			}
			else
			{
				GetApp()->SetLog( 0, "USER:%s , IP:%s",pUser->szID , pUser->szAddr);
			}
		}
	}

	CConnection *pConn = GetLoginServer()->m_dbPool.Alloc();
	if ( !pConn )
	{
		SendResponse( pUser, SM_NOT_IN_SERVICE, 0, 0, 0, 0 );
		return false;
	}
	CConnection *pConnPC = GetLoginServer()->m_dbPoolPC.Alloc();
	if ( !pConnPC )
	{
		SendResponse( pUser, SM_NOT_IN_SERVICE, 0, 0, 0, 0 );
		return false;
	}

	/*
		nPacketRecog

		 0	정상
		-1	패스워드 틀림
		-2	패스워드를 5회 실패 후 10분이 지나지 않았음
		-3	같은 아이디가 있음
		-4
		-5	아이디 정지증
		-6	아이디 없음
		-7  미르2아이디.
		-8  허용 아이피 갯수 초과
		-9	주민등록번호 오류
	*/
	int  nPacketRecog = 0;
	bool bNeedUpdate = false;
	bool bAvailableSsn = false;    //올바르고 15세이상인지 저장하는 변수
	char szQuery[1024];

	SYSTEMTIME st;
    GetSystemTime(&st); 
	unsigned int nCurrentTime = GetDay(st.wYear, st.wMonth, st.wDay);

//	sprintf( szQuery, "SELECT * FROM TBL_USER A, TBL_USERDETAIL B WHERE A.FLD_USERID=N'%s' AND A.FLD_USERID = B.FLD_USERID ", pUser->szID );
//	sprintf( szQuery, "SELECT FLD_ENDDATE,FLD_CURRENTPOINT,FLD_PASSWORD FROM TBL_USER A, TBL_USERDETAIL B WHERE A.FLD_USERID=N'%s' AND A.FLD_USERID = B.FLD_USERID ", pUser->szID );
//    sprintf( szQuery, "SELECT REMAINED_DAYS,IS_OK,PAY_CODE,PASSWORD FROM USER_ACCOUNT_TBL A, USER_TBL B WHERE A.LOG_ID='%s' AND A.LOG_ID = B.LOGINID ", pUser->szID );
    sprintf( szQuery, "EXECUTE SP_LOG_USER '%s'", pUser->szID );
					
	#ifdef _DEBUG
		GetApp()->SetLog( 0, "[SQL QUERY] %s", szQuery);
	#endif

	pUser->dwMValidFrom		= 0;
	pUser->dwMValidUntil	= 0;
	pUser->dwMSeconds		= 0;
	pUser->dwMStopUntil	    = 0;
	pUser->dwValidFrom		= 0;
	pUser->dwValidUntil		= 0;
	pUser->dwSeconds		= 0;
	pUser->dwStopUntil		= 0;
	pUser->dwIpValidFrom	= 0;
	pUser->dwIpValidUntil	= 0;
	pUser->dwIpSeconds		= 0;	//TWN -200000;
	pUser->dwIpMValidFrom	= 0;
	pUser->dwIpMValidUntil	= 0;
	pUser->dwIpMSeconds		= 0;
	pUser->nPayCode			= 0;	// ItalyAdd
	pUser->nIsOK			= 0;	// ItalyAdd

	
	//로그인 아이디 체크
	CRecordset *pRec = pConn->CreateRecordset();
	if ( !pRec->Execute( szQuery ) || !pRec->Fetch() )
	{
		nPacketRecog = -6;
		pConn->DestroyRecordset( pRec );
		SendResponse( pUser, SM_PASSWD_FAIL, nPacketRecog, 0, 0, 0 );

		#ifdef _DEBUG
			GetApp()->SetLog( 0, "[LoginGate/ Send] SM_PASSWD_FAIL : %d",nPacketRecog);
		#endif

	}
	else
	{
		pUser->nPassFailCount	= 0;	//TWN atoi( pRec->Get( "FLD_PASSFAILCOUNT" ) );
		pUser->nPassFailTime	= 0;	//TWN atoi( pRec->Get( "FLD_PASSFAILTIME" ) );
		pUser->dwValidFrom		= 0;	//TWN GetTimeInfo(pRec->Get("FLD_VALIDFROM"));
		//pUser->dwValidUntil		= GetTimeInfo(pRec->Get("FLD_ENDDATE"));
		pUser->dwSeconds		= 0; //atoi(pRec->Get("FLD_CURRENTPOINT"));
		pUser->dwStopUntil		= 0;	//TWN GetTimeInfo( pRec->Get( "FLD_STOPUNTIL" ) );
		
		// 이탈리아에서 계정등록 일자 알아내는 방법 
		pUser->dwValidUntil		= nCurrentTime + atoi(pRec->Get("REMAINED_DAYS"));
		pUser->nIsOK			= atoi (pRec->Get("IS_OK")); 
		pUser->nPayCode			= atoi (pRec->Get("PAY_CODE")); 
		pUser->dwMakeTime		= 0;	//TWN GetTimeInfo( pRec->Get( "FLD_MAKETIME" ) );
		int nVersion            = 0;	//TWN atoi( pRec->Get("FLD_VER"));
		bstr szDBPW				= pRec->Get( "PASSWORD" );
		_trim( szDBPW );

		pConn->DestroyRecordset( pRec );

		if( 1 != pUser->nIsOK )
		{
			// 패스워드가 3번 틀리면 
			if ( pUser->nPayCode == 200 )
			{
				nPacketRecog = -2;
			}
			else
			{
				nPacketRecog = -5;
			}
		}
		
		// 회사 IP 확인
		if(strcmp( pUser->szAddr , COMPANY_IP )==0)	// 218.144.171.253
		{
			pUser->dwStopUntil		= 0;
			pUser->dwMStopUntil		= 0;
		}

		// Check Password...
		if ( nPacketRecog == 0 )
		{
			pRec = pConn->CreateRecordset();
			if ( szPW != szDBPW )
			{
				nPacketRecog = -1;
//				sprintf( szQuery, "EXECUTE SP_LOG_FAIL '%s'", pUser->szID );
			}
			else
			{
//				sprintf( szQuery, "EXECUTE SP_LOG_SUCCESS '%s'", pUser->szID );
			}

			pRec->Execute( szQuery );
			pConn->DestroyRecordset( pRec );
		}
		
		// 중복접속 여부
		if ( nPacketRecog == 0 )
		{
			GetLoginServer()->m_csListCert.Lock();
			sCertUser *psCertUser = GetLoginServer()->m_listCert.SearchKey( pUser->szID );

			if (psCertUser)
			{
				nPacketRecog = -3;

				GetLoginServer()->SendCancelAdmissionUser( psCertUser );
				psCertUser->bClosing = true;
				if (!psCertUser->bClosing)
					psCertUser->nOpenTime = GetTickCount();
			}
			GetLoginServer()->m_csListCert.Unlock();
		}

		// 피씨방
		if ( nPacketRecog == 0 )
		{
			pUser->bSelServerOK		= false;
			pUser->nCertification	= GetCertification();
			pUser->nPayMode = 0;
			
			//nPaymode => 0 : 체험판, 1 : 유료, 2 : 무료(만든지 기간)
			// 게임 마스타 인 경우는 pay_code = 16
			if ( 16 == pUser->nPayCode )
			{
				pUser->dwValidUntil = nCurrentTime + 10;
			}
			//통합정액인지 체크 
			//해당정액
			//정량
			// TWN 
			if( (nCurrentTime < pUser->dwValidUntil )) 		//개인		통합	정액에 해당하는경우.
				 
//			    (nCurrentTime <= pUser->dwIpValidUntil ) ||		//게임방	통합	정액에 해당하는 경우
//				(pUser->dwSeconds > 0) ||						//개인		통합	정량에 해당하는 경우
//				(pUser->dwIpSeconds > 0))						//게임방 0시간 보정	
			{
				pUser->nPayMode = 1;

				long RemainDays		= 0;
				long RemainIpDays	= 0;
				long RemainHours	= 0;
				long RemainIpHours	= 0;

				RemainDays    = pUser->dwValidUntil - nCurrentTime;
				RemainIpDays  = pUser->dwIpValidUntil - nCurrentTime;
				RemainHours   =	pUser->dwSeconds;	// TWN (pUser->dwSeconds + 1) / 3600;
				RemainIpHours = (pUser->dwIpSeconds + 1) / 3600;

				if(RemainDays < 0)    RemainDays    = 0;
				if(RemainIpDays < 0)  RemainIpDays  = 0;
				if(RemainHours < 0)   RemainHours   = 0;
				if(RemainIpHours < 0) RemainIpHours = 0;



				SendResponse( pUser, SM_PASSOK_SELECTSERVER, 
							  MAKELONG((WORD)(RemainDays), (WORD)(RemainHours)), 
							  RemainIpDays,
							  RemainIpHours,
							  0);

			}
			else
			{
				pUser->nPayMode = 0;
				SendResponse( pUser, SM_PASSOK_SELECTSERVER, 0, 0, 0, 0 );
			}


#ifdef _DEBUG
			GetApp()->SetLog(0,"[LoginGate/Send] SM_PASSOK_SELECTSERVER : %s", pUser->szID );
#endif	

			GetLoginServer()->AddCertUser( pUser );
			// 2003-06-26 대만 부하때문에 삭제함
			//			GetLoginServer()->WriteConLog(pUser->szID , pUser->szAddr);
		}
		else{
			SendResponse( pUser, SM_PASSWD_FAIL, nPacketRecog, 0, 0, 0 );
#ifdef _DEBUG
			GetApp()->SetLog(0,"[LoginGate/Send] SM_PASSWD_FAIL : %d", nPacketRecog);
#endif	
		}
	}
	
	GetLoginServer()->m_dbPoolPC.Free( pConnPC );
	GetLoginServer()->m_dbPool.Free( pConn );
	return true;
}


/*
	CM_SELECTSERVER
*/

bool CLoginGate::OnSelectServer( sGateUser *pUser, char *pBody, _TDEFAULTMESSAGE msg )
{
	if ( strlen( pUser->szID ) == 0 )
	{
		SendKickUser( pUser );
		return false;
	}

	pUser->bSelServerOK = true;
	
	char szServerName[32] = {0,};
	strcpy(szServerName, pBody);
	//fnDecode6BitBuf( pBody, szServerName, sizeof( szServerName ) );
	
	pUser->bFreeMode = false;
	

	SYSTEMTIME st;
    GetSystemTime(&st); 
	int nCurrentTime = GetDay(st.wYear, st.wMonth, st.wDay);

/*
	if ( nCurrentTime - pUser->dwMakeTime < GetLoginServer()->m_nFreePeriods * 60 * 60 * 24 )
	{
		pUser->nPayMode = 2;
		pUser->bFreeMode = true;
	}
*/	
	//
	// 선택한 서버 seek
	//
	CGameServer *pGameServer = NULL;
	CGameServerInfo *pSelectServerInfo = NULL;
	sTblSelectGateIP	*pSelectGate = NULL;
	
	CListNode<CGameServerInfo> *pServerNode = GetLoginServer()->m_listServerInfo.GetHead();
	for(; pServerNode;pServerNode = pServerNode->GetNext())
	{
		CGameServerInfo *pServerInfo = pServerNode->GetData();
		if(strcmp(pServerInfo->szName, szServerName) == 0)
		{
			pSelectServerInfo = pServerInfo;
			pSelectGate = pServerInfo->GetSelectGate();
			if(pServerInfo->nFreemode == 0)
				pUser->bFreeMode = true;
			break;
		}
	}
	
	if (!pSelectGate||
		(pSelectServerInfo->nMaxUserCount < GetLoginServer()->RecalUserCount(szServerName)))
	{
		GetLoginServer()->DelCertUser( pUser );
		SendResponse( pUser, SM_STARTFAIL, 0, 0, 0, 0 );
		
		return false;
	}
	
	
	GetLoginServer()->m_csListCert.Lock();
	sCertUser *pCert = GetLoginServer()->m_listCert.SearchKey( pUser->szID );
	if ( pCert )
	{
		strcpy( pCert->szServerName, szServerName );
		pCert->bFreeMode = pUser->bFreeMode;
	}
	GetLoginServer()->m_csListCert.Unlock();
	
	CListNode< CGameServer > *pNode;

	GetLoginServer()->m_listGameServer.Lock();

	// EXLOG
	int __CNT1 = 0;
	int __CNT2 = 0;

	pNode = GetLoginServer()->m_listGameServer.GetHead();
	for (pNode = GetLoginServer()->m_listGameServer.GetHead(); pNode; pNode = pNode->GetNext() )
	{
		CGameServer *pObj = pNode->GetData();

		if(pObj){
			if(stricmp(pObj->m_dbInfo.szName , szServerName)==0)
			{
				if(!pObj->SendPasswordSuccess( pUser ))
				{
#ifdef _DEBUG
					GetApp()->SetLog(0,"[SendPasswordFail]");
#endif
					__CNT2++;
				}

				__CNT1++;
			}

		}
		
	}	
	GetLoginServer()->m_listGameServer.Unlock();

/*	FILE *fp = fopen( ".\\Admission.txt", "ab" );
	fprintf( fp, "==> Result: %d %d\r\n\r\n", __CNT1, __CNT2 );
	fclose( fp );*/

	//
	// 성공 메시지 send
	//
	char szText[1024];
	sprintf( szText, 
			 "%s/%d/%d", 
			 pSelectGate->szIP, pSelectGate->nPort, pUser->nCertification );
	SendResponse( pUser, SM_SELECTSERVER_OK, pUser->nCertification, 0, 0, 0, szText );

	return true;
}


/*
	KeepAlive

	%--$
*/
bool CLoginGate::OnKeepAlive()
{
	CMir2Packet *pPacket = new CMir2Packet;
	pPacket->Attach( "%++$" );
	Lock();
	bool bRet = Send( pPacket );
	Unlock();

	return bRet;
}


/*
	User Data

	%A[HANDLE]/#?[DefMsg][Data]!$
*/
bool CLoginGate::OnUserData( char *pBody )
{
	char *pData = strchr( pBody, '/' );
	if ( !pData )
	{
		m_nCntInvalidPacket++;
		return false;
	}
	*pData++ = NULL;

	sGateUser *pUser = m_listUser.SearchKey( pBody );
	if ( !pUser )
	{
		m_nCntInvalidPacket++;
		return false;
	}

	//
	// Relay 패킷 유효성 검사
	//
	int nDataLen = strlen( pData );
	if ( pData[0] != '#' || pData[nDataLen - 1] != '!' )
	{
		m_nCntInvalidPacket++;
		return true;
	}	
	pData[nDataLen - 1] = NULL;
	pData += 2;

	//
	// Default Message 디코딩
	//
	_TDEFAULTMESSAGE msg;
	fnDecodeMessage( &msg, pData );
	
	pData +=  _DEFBLOCKSIZE;

	CDecodedString *pdData = fnDecodeString(pData);

	//-----------------------------------------------------------.
	//end 20040715 입력창을 통한 쿼리 실행 제거.
	char *pDataNull = strchr( pdData->m_pData, ' ' );

	if ( pDataNull != NULL )
		return false;
	//-----------------------------------------------------------.

	//
	// 해당 프로토콜 함수를 호출한다.
	//
	for ( int i = 0; i < g_nGateCmdCnt; i++ )
	{
		if ( msg.wIdent == g_GateCmdList[i].nPacketID )
		{
			if ( !(this->*g_GateCmdList[i].pfn)( pUser, *pdData, msg ) )
			{
#ifdef _EX_DEBUG
				GetApp()->SetLog( CDBG, "에러! 로그인게이트 패킷 함수 실행 실패!! %s %d", __FILE__, __LINE__ );
#endif
			}
			delete pdData;
			return true;
		}
	}

	delete pdData;

	m_nCntInvalidPacket++;
	return false;
}


/*
	User Open

	%O[HANDLE]/[ADDR]$
*/
bool CLoginGate::OnUserOpen( char *pBody )
{
	bstr szHandle, szAddr;
	_pickstring( pBody, '/', 0, &szHandle );
	_pickstring( pBody, '/', 1, &szAddr );

	//
	// 중복 Open 처리
	//
	sGateUser *pUser = m_listUser.SearchKey( szHandle );
	if ( pUser )
		return true;

	pUser = new sGateUser;
	memset( pUser, 0, sizeof( sGateUser ) );

	pUser->nGateSocket = m_sdHost;
	strcpy( pUser->szUserHandle, szHandle );
	strcpy( pUser->szAddr, szAddr );
	
	bool bRet = m_listUser.Insert( pUser );
	
#ifdef _DEBUG
	GetApp()->SetLog( CDBG, "OPEN GATE_USER: %d", m_listUser.GetCount() );
#endif

	return bRet; 
}


/*
	User Close

	%X[HANDLE]$
*/
bool CLoginGate::OnUserClose( char *pBody )
{
	char *pHandle = pBody;

	sGateUser *pUser = m_listUser.SearchKey( pHandle );
	if ( !pUser )
		return true;

	if ( !pUser->bSelServerOK )
		GetLoginServer()->DelCertUser( pUser );

	delete m_listUser.Remove( pUser );

#ifdef _DEBUG
	GetApp()->SetLog( CDBG, "CLOSE GATE_USER: %d", m_listUser.GetCount() );
#endif

	return true;
}


void CLoginGate::OnError( int nErrCode )
{
	GetApp()->SetErr( nErrCode );
}


void CLoginGate::OnSend( int nTransferred )
{
#ifdef _DEBUG
//	if(nTransferred > 10)
//	GetApp()->SetLog( CSEND, "[LoginGate/%d] TO (%s)",nTransferred,this->m_dbInfo.szIP );
#endif
}


bool CLoginGate::OnRecv( char *pPacket, int nPacketLen )
{
#ifdef _DEBUG
	char __szPacket[256] = {0,};
	memcpy( __szPacket, pPacket, 
		nPacketLen >= sizeof( __szPacket ) ? sizeof( __szPacket ) - 1 : nPacketLen );
//?	if(nPacketLen >10)
//	GetApp()->SetLog( CRECV, "[LoginGate/%d] %s FROM (%s)", nPacketLen, __szPacket,this->m_dbInfo.szIP );
//	GetApp()->SetLog( CRECV, "[LoginGate] m_nCntInvalidPacket (%d)", m_nCntInvalidPacket);
#endif

	//
	// 패킷 유효성 검사
	//
	if ( pPacket[0] != '%' || pPacket[nPacketLen - 1] != '$' )
	{
		m_nCntInvalidPacket++;
		return true;
	}
	
	pPacket[nPacketLen - 1] = NULL;

	switch ( pPacket[1] ) 
	{
	case '-':
		OnKeepAlive();
		return true;

	case 'A':
		OnUserData( &pPacket[2] );
		return true;

	case 'O':
		OnUserOpen( &pPacket[2] );
		return true;
	
	case 'X':
		OnUserClose( &pPacket[2] );
		return true;
	}

	m_nCntInvalidPacket++;
#ifdef _EX_DEBUG
	GetApp()->SetLog( CDBG, "에러! LOGIN 게이트 잘못된 패킷 수신됨!! %s %d\n", __FILE__, __LINE__ );
#endif
	return false;
}


bool CLoginGate::OnExtractPacket( char *pPacket, int *pPacketLen )
{
	char *pEnd = (char *) memchr( m_olRecv.szBuf, '$', m_olRecv.nBufLen );
	if ( !pEnd )
		return false;

	*pPacketLen = ++pEnd - m_olRecv.szBuf;
	memcpy( pPacket, m_olRecv.szBuf, *pPacketLen );

	return true;
}



int CLoginGate::GetCertification()
{
	static long s_nCert = 30;

	InterlockedIncrement( &s_nCert );

	if ( s_nCert >= 0x7FFFFFFF ) 
		InterlockedExchange( &s_nCert, 30 );
	
	return s_nCert;
}



char * CLoginGate::__cbGetUserKey( sGateUser *pUser )
{
	return pUser->szUserHandle;
}

// Update Log...2003/01/08 COPark
// ClientVersion Check를 위해 OnProtocol 함수 추가
bool CLoginGate::OnProtocol( sGateUser *pUser, char *pBody, _TDEFAULTMESSAGE msg )
{
	if ( strlen( pUser->szID ) == 0 )
	{
		SendKickUser( pUser );
		return false;
	}

	if(msg.nRecog < VERSION_NUMBER) 
	{
		SendResponse(pUser, SM_VERSION_FAIL, 0, 0, 0, 0);
		return false;
	}
	else 
	{
		SendResponse(pUser, SM_VERSION_AVAILABLE, 0, 0, 0, 0);
		pUser->nClientVersion = msg.nRecog;	
		pUser->bVersionAccept = true;
		return true;
	}
}	

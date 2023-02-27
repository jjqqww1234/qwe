

#include "netgameserver.h"
#include "loginsvrwnd.h"
#include <stringex.h>
#include <stdlib.h>
#include <stdio.h>
#include <TIME.H>
#include "../common/mir2packet.h"


static struct sGameServerCmdList
{
	int  nPacketID;
	bool (CGameServer:: *pfn)( char *pBody );
} g_GameCmdList[] = 
{
	ISM_USERCLOSED,	&CGameServer::OnUserClosed,
	ISM_USERCOUNT,	&CGameServer::OnUserCount,
	ISM_GAMETIMEOFTIMECARDUSER, &CGameServer::OnGameTimeOfTimeUser,
};


static const int g_nGameCmdCnt = sizeof( g_GameCmdList ) / sizeof( g_GameCmdList[0] );


CGameServer::CGameServer( SOCKET sdClient, char *szIP )
{
	SetClassId( CLASSID );
	SetAcceptedSocket( sdClient );


	strcpy(m_dbInfo.szIP, szIP);
	m_dbInfo.nID = 0;
	strcpy(m_dbInfo.szName , "");
	m_nCurUserCnt		= 0;
	m_nMaxUserCnt		= 0;
	m_nCntInvalidPacket	= 0;
	m_nLastTick			= GetTickCount();
}


CGameServer::~CGameServer()
{
}


bool CGameServer::SendCancelAdmissionCert( sCertUser *pUser )
{
	CMir2Packet *pPacket = new CMir2Packet;
	pPacket->Attach( '(' );
	pPacket->Attach( ISM_CANCELADMISSION );
	pPacket->Attach( '/' );
	pPacket->Attach( pUser->szLoginID );
	pPacket->Attach( '/' );
	pPacket->Attach( pUser->nCertification );
	pPacket->Attach( ')' );
#ifdef _DEBUG
	GetApp()->SetLog(0,"[GameServer/Send] ISM_CANCELADMISSION : %s TO (%s)", pUser->szLoginID , this->m_dbInfo.szIP);
#endif	
	Lock();
	bool bRet = Send( pPacket );
	Unlock();

/*	FILE *fp = fopen( ".\\Admission.txt", "ab" );
	fprintf( fp, "[%s] [%s:%d] %s\r\n", pUser->szLoginID, IP(), Port(), pPacket->m_pPacket );
	fclose( fp );*/

	return bRet;
}

bool CGameServer::SendAccountExpire( sCertUser *pUser)
{
	CMir2Packet *pPacket = new CMir2Packet;
	pPacket->Attach( '(' );
	pPacket->Attach( ISM_ACCOUNTEXPIRED );
	pPacket->Attach( '/' );
	pPacket->Attach(pUser->szLoginID );
	pPacket->Attach( '/' );
	pPacket->Attach( pUser->nCertification );
	pPacket->Attach( ')' );
#ifdef _DEBUG
			GetApp()->SetLog(0,"[GameServer/Send] ISM_ACCOUNTEXPIRED :%s TO (%s)",pUser->szLoginID, this->m_dbInfo.szIP );
#endif	
	Lock();
	bool bRet = Send( pPacket );
	Unlock();

	return bRet;
}


bool CGameServer::SendTotalUserCount(int nTotalUserCount)
{
	char szCount[10];
	CMir2Packet *pPacket = new CMir2Packet;
	pPacket->Attach( '(' );
	pPacket->Attach( ISM_TOTALUSERCOUNT );
	pPacket->Attach( '/' );
	pPacket->Attach( itoa(nTotalUserCount, szCount, 10 ));
	pPacket->Attach( ')' );

	Lock();
	bool bRet = Send( pPacket );
	Unlock();

	return bRet;

}

bool CGameServer::SendPasswordSuccess( sGateUser *pUser )
{

	SYSTEMTIME st;
    GetSystemTime(&st); 
	DWORD nCurrentTime = GetDay(st.wYear, st.wMonth, st.wDay);

/*
	pUser->nAvailableType = 5;

	if ( pUser->dwSeconds + pUser->dwMSeconds  > 0 ) pUser->nAvailableType = 2;
	if ( pUser->dwIpSeconds + pUser->dwIpMSeconds > 0 ) pUser->nAvailableType = 4;
	if (((nCurrentTime > pUser->dwValidFrom )&&(nCurrentTime < pUser->dwValidUntil)) ||((nCurrentTime > pUser->dwMValidFrom ) && (nCurrentTime < pUser->dwMValidUntil)))
		pUser->nAvailableType = 1;	
	if (((nCurrentTime > pUser->dwIpMValidFrom ) && (nCurrentTime < pUser->dwIpMValidUntil))||
		((nCurrentTime > pUser->dwIpValidFrom ) && (nCurrentTime < pUser->dwIpValidUntil)))
		pUser->nAvailableType = 3;
*/

	CMir2Packet *pPacket = new CMir2Packet;
	char Deli = 0x0a;

	pPacket->Attach( '(' );
	pPacket->Attach( ISM_PASSWDSUCCESS );
	pPacket->Attach( '/' );
	pPacket->Attach( pUser->szID );
	pPacket->Attach( &Deli, 1 );
//	pPacket->Attach( '/' );
	pPacket->Attach( pUser->nCertification );
	pPacket->Attach( &Deli, 1 );
//	pPacket->Attach( '/' );
	pPacket->Attach( pUser->nPayMode );
	pPacket->Attach( &Deli, 1 );
//	pPacket->Attach( '/' );
	pPacket->Attach( pUser->nAvailableType );
	pPacket->Attach( &Deli, 1 );
//	pPacket->Attach( '/' );
	pPacket->Attach( pUser->szAddr );
	pPacket->Attach( &Deli, 1 );
	pPacket->Attach( pUser->nClientVersion );
	pPacket->Attach( ')' );

	Lock();
	bool bRet = Send( pPacket );
	Unlock();

/*	FILE *fp = fopen( ".\\Admission.txt", "ab" );
	fprintf( fp, "[%s] [%s:%d] %s\r\n", pUser->szID, IP(), Port(), pPacket->m_pPacket );
	fclose( fp );*/

	return bRet;
}


bool CGameServer::OnUserClosed( char *pBody )
{
	bstr szID, szCert;	
	_pickstring( pBody, '/', 0, &szID );
	_pickstring( pBody, '/', 1, &szCert );
	char szIPAddr[40];
	

	GetLoginServer()->m_csListCert.Lock();
	sCertUser *pUser = GetLoginServer()->m_listCert.SearchKey( szID );
	if ( !pUser )
	{
		GetLoginServer()->m_csListCert.Unlock();
		return true;
	}

/*	FILE *fp = fopen( ".\\Admission.txt", "ab" );
	fprintf( fp, "CGameServer::OnUserClosed\r\n" );
	fclose( fp );*/

	strcpy(szIPAddr, pUser->szUserAddr);
	GetLoginServer()->SendCancelAdmissionUser( pUser );
#ifdef _DEBUG
	GetApp()->SetLog( 0, "[GameServer] %s was disconnected", pUser->szLoginID);	
#endif
	delete GetLoginServer()->m_listCert.Remove( pUser );

	GetLoginServer()->m_csListCert.Unlock();

	/* 2003/02/03 중복 아이피 체크
	CConnection *pConnPC = GetLoginServer()->m_dbPoolPC.Alloc();
	CRecordset  *pRec = NULL;
	int  nPCRoomIndex = 0;
	char szQuery[1024];

	if ( !pConnPC )
		return false;

	// 사용중인 IP가 피씨방인지 확인
	sprintf( szQuery, "SELECT * FROM TBL_USINGIP WHERE FLD_USINGIP='%s' AND FLD_GAMETYPE='%s'", szIPAddr, GetLoginServer()->m_szGameType );
#ifdef _DEBUG
	GetApp()->SetLog( 0, "[SQL QUERY] %s", szQuery);
#endif
	pRec = pConnPC->CreateRecordset();
	if(pRec && pRec->Execute( szQuery ) && pRec->Fetch())
	{
		nPCRoomIndex = atoi( pRec->Get("FLD_PCBANG") );
	}
	pConnPC->DestroyRecordset( pRec );

	if(nPCRoomIndex)
	{
		// 사용중인 IP리스트 삭제
		sprintf( szQuery, "DELETE FROM TBL_USINGIP WHERE FLD_USINGIP='%s' AND FLD_GAMETYPE='%s'", szIPAddr, GetLoginServer()->m_szGameType );
	#ifdef _DEBUG
		GetApp()->SetLog( 0, "[SQL QUERY] %s", szQuery);
	#endif
		pRec = pConnPC->CreateRecordset();
		if(pRec)
			pRec->Execute( szQuery );
		pConnPC->DestroyRecordset( pRec );

		// 사용중인 중복 IP삭제
		sprintf( szQuery, "UPDATE TBL_DUPIP SET FLD_ISOK='1', FLD_KICK = GetDate() FROM TBL_DUPIP WHERE FLD_IP='%s' AND FLD_GAMETYPE='%s' AND FLD_ISOK='0'", szIPAddr, GetLoginServer()->m_szGameType );
	#ifdef _DEBUG
		GetApp()->SetLog( 0, "[SQL QUERY] %s", szQuery);
	#endif
		pRec = pConnPC->CreateRecordset();
		if(pRec)
			pRec->Execute( szQuery );
		pConnPC->DestroyRecordset( pRec );

		// 사용중인 IP갯수 감소
		sprintf( szQuery, "UPDATE MR3_PCRoomStatusTable SET PCRoomStatus_UsingIPCount = PCRoomStatus_UsingIPCount-1 WHERE PCRoomStatus_PCRoomIndex=%d AND PCRoomStatus_UsingIPCount > 0", nPCRoomIndex);
	#ifdef _DEBUG
		GetApp()->SetLog( 0, "[SQL QUERY] %s", szQuery);
	#endif
		pRec = pConnPC->CreateRecordset();
		if(pRec)
			pRec->Execute( szQuery );
		pConnPC->DestroyRecordset( pRec );
	}
	GetLoginServer()->m_dbPoolPC.Free( pConnPC );
*/
	return true;
}


bool CGameServer::OnUserCount( char *pBody )
{
	//// 203/이벤트/0/124

	bstr szHandle, szName, szIndex, szCount;
	//_pickstring(pBody, '/',0,&szHandle);
	_pickstring(pBody, '/',0,&szName);
	_pickstring(pBody, '/',1,&szIndex);
	_pickstring(pBody, '/',2,&szCount);

#ifdef _DEBUG
//	GetApp()->SetLog( 0, "[OnUserCount] %s(%s)=%s", szName, szIndex, szCount );	
#endif

	m_dbInfo.nID = atoi(szIndex);
	strcpy(m_dbInfo.szName , szName);

	m_nCheckTime = GetTickCount();
	m_nCurUserCnt = atoi(szCount);
	
	if(m_nCurUserCnt > m_nMaxUserCnt)
		m_nMaxUserCnt = m_nCurUserCnt;

	int nTotalUserCount = GetLoginServer()->GetTotalUserCount();

	if(nTotalUserCount > GetLoginServer()->m_nMaxTotalUserCount)
		GetLoginServer()->m_nMaxTotalUserCount = nTotalUserCount;
	
	CListNode< CGameServer > *pNode;
	GetLoginServer()->m_listGameServer.Lock();
	pNode = GetLoginServer()->m_listGameServer.GetHead();
	for ( ; pNode; pNode = pNode->GetNext() )
	{
		CGameServer *pObj = pNode->GetData();
		if(pObj)
			pObj->SendTotalUserCount(nTotalUserCount);
	}	
	GetLoginServer()->m_listGameServer.Unlock();

	return true;
}

bool CGameServer::OnGameTimeOfTimeUser( char *pBody )
{
	return true;
}


bool CGameServer::SaveServerUserCount()
{
	char szQuery[256];
	
	CConnection *pConn = GetLoginServer()->m_dbPool.Alloc();
	if ( !pConn )
		return false;
	
	sprintf(szQuery, "INSERT INTO TBL_USERCOUNT (FLD_NAME, FLD_INDEX, FLD_TIME,"
					" FLD_COUNT, FLD_MAXCOUNT,FLD_GAMETYPE) VALUES( '%s', %d, GetDate(),%d,%d,'%s')" 
					, m_dbInfo.szName, m_dbInfo.nID, m_nCurUserCnt, m_nMaxUserCnt,GetLoginServer()->m_szGameType  );

#ifdef _DEBUG
	GetApp()->SetLog( 0, "[SQL QUERY] %s", szQuery);
#endif

	CRecordset *pRec = pConn->CreateRecordset();
	pRec->Execute(szQuery);
	pConn->DestroyRecordset(pRec );
	m_nMaxUserCnt = 0;
	GetLoginServer()->m_dbPool.Free( pConn );
	return true;
}



void CGameServer::OnError( int nErrCode )
{
	GetApp()->SetErr( nErrCode );
}


void CGameServer::OnSend( int nTransferred )
{
#ifdef _DEBUG
//	if(nTransferred > 10)
//	GetApp()->SetLog( CSEND, "[GameServer/Send %d]  TO (%s)", nTransferred,this->m_dbInfo.szIP   );
#endif
}


bool CGameServer::OnRecv( char *pPacket, int nPacketLen )
{
#ifdef _DEBUG
	char __szPacket[256] = {0,};
	memcpy( __szPacket, pPacket, 
		nPacketLen >= sizeof( __szPacket ) ? sizeof( __szPacket ) - 1 : nPacketLen );
//	if(nPacketLen> 15)
//	GetApp()->SetLog( CRECV, "[GameServer/Recv %d] %s FROM (%s)", nPacketLen , __szPacket ,this->m_dbInfo.szIP);
#endif

	m_nLastTick = GetTickCount();
	
	//
	// 패킷 유효성 검사
	//
	if ( pPacket[0] != '(' || pPacket[nPacketLen - 1] != ')' )
	{
		m_nCntInvalidPacket++;
		return true;
	}

	pPacket[nPacketLen - 1] = NULL;

	//
	// 첫번째 엔트리가 패킷 ID이다.
	//
	bstr szPacketID;
	_pickstring( &pPacket[1], '/', 0, &szPacketID );

	char *pBody = pPacket + strlen( szPacketID ) + 2;

	//
	// 해당 프로토콜 함수를 호출한다.
	//
	for ( int i = 0; i < g_nGameCmdCnt; i++ )
	{
		if ( atoi( szPacketID ) == g_GameCmdList[i].nPacketID )
		{
			(this->*g_GameCmdList[i].pfn)( pBody );
			return true;
		}
	}
	GetApp()->SetLog( 0, "[Invalid Packet] %s", pPacket);
	m_nCntInvalidPacket++;
	return false;
}


bool CGameServer::OnExtractPacket( char *pPacket, int *pPacketLen )
{
	char *pEnd = (char *) memchr( m_olRecv.szBuf, ')', m_olRecv.nBufLen );
	if ( !pEnd )
		return false;

	*pPacketLen = ++pEnd - m_olRecv.szBuf;
	memcpy( pPacket, m_olRecv.szBuf, *pPacketLen );
	
	return true;
}



#ifndef __ORZ_MIR2_LOGIN_SERVER__
#define __ORZ_MIR2_LOGIN_SERVER__


#pragma comment( lib, "ws2_32.lib" )


#include "../_Oranze Library/database.h"
#include "../_Oranze Library/netiocp.h"
#include <indexmap.h>
#include "dbtable.h"
#include "mir2dbhandler.h"
#include "protocol.h"
#include "netcheckserver.h"
#include "netgameserver.h"
#include "netlogingate.h"
#include <datelog.h>


#define MAX_HASHSIZE		1000


struct sCertUser
{
	char	szLoginID[21];
	char	szUserAddr[16];
	char	szServerName[20];
	bool	bFreeMode;
	int		nCertification;
	DWORD	nOpenTime;
	DWORD	nAccountCheckTime;
	bool	bClosing;

	BYTE	nAvailableType;
	int		nIDDay;
	int		nIDHour;
	int		nIPDay;
	int		nIPHour;	
};

class CGameServerInfo
{
public:
	char szName[21];
	int		nMaxUserCount;
	int		nFreemode;
	int		nGateCount;
	int		nCurrentIndex;	

	CSList<sTblSelectGateIP>	m_listSelectGate;

public:
	CGameServerInfo();

	sTblSelectGateIP* GetSelectGate();
};


class CLoginSvr : public CIocpHandler
{
public:
	CDBSvrOdbcPool			m_dbPool;
	CDBSvrOdbcPool			m_dbPoolPC;
	CList< sTblSvrIP >		m_listServerIP;
	CList< sTblPubIP >		m_listGateIP;
	CList< CGameServerInfo>  m_listServerInfo;

	CSList< CCheckServer >	m_listCheckServer;
	CIocpAcceptor			m_csAcceptor;
	CSList< CGameServer >	m_listGameServer;
	CIocpAcceptor			m_gsAcceptor;
	CSList< CLoginGate >	m_listLoginGate;
	CIocpAcceptor			m_lgAcceptor;

	CIndexMap< sCertUser >	m_listCert;
	CIntLock				m_csListCert;

	int			m_nTotalCount;
	int			m_nMaxTotalUserCount;
	CHAR		m_szGameType[10];		
	int			m_nFreePeriods;
	bool		m_IsNotInServiceMode;

	CDateLog	m_log;

public:
	CLoginSvr();
	virtual ~CLoginSvr();

	bool Startup();
	void Cleanup();

	//
	// CIocpHandler 가상함수 구현
	//
	void			OnError( int nErrCode );
	CIocpObject *	OnAccept( CIocpAcceptor *pAcceptor, SOCKET sdClient );
	void			OnAcceptError( CIocpAcceptor *pAcceptor, int nErrCode );
	void			OnClose( CIocpObject *pObject );

	//
	// 윈도우 타이머
	//
	void OnTimer( int nTimerID );

	//
	// 기능 구현
	//
	bool LoadDBTables();
	sTblSvrIP * FindServerInfo( SOCKET sdPeer );
	sTblPubIP * FindGateInfo( SOCKET sdPeer );

	bool AddCertUser( sGateUser *pUser );
	void DelCertUser( sGateUser *pUser );

	bool SaveCountLog();
	bool WriteConLog(char *pszLoginid, char *pszIP);
	int	 GetTotalUserCount();
	int  RecalUserCount(char *pszServerName);
	void CheckCertListTimeOuts();
	void CheckAccountExpire();
	void CheckDupIPs();
	bool SendCancelAdmissionUser( sCertUser *pCert );
	bool SendAccountExpireUser( sCertUser *pCert );


protected:
	static void	__cbDBMsg( char *pState, int nErrCode, char *pDesc );
	static int	__cbCmpCheckServer( void *pArg, CCheckServer *pFirst, CCheckServer *pSecond );
	static int	__cbCmpGameServer( void *pArg, CGameServer *pFirst, CGameServer *pSecond );
	static int	__cbCmpLoginGate( void *pArg, CLoginGate *pFirst, CLoginGate *pSecond );
	static char * __cbGetCertKey( sCertUser *pObj );
};


#endif
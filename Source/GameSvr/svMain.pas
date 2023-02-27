unit svMain;

interface


uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ScktComp, RunSock, syncobjs, StdCtrls, ExtCtrls, FrnEngn, UsrEngn,
  Envir, IniFiles, itmunit, Magic, NoticeM, Guild, MudUtil, Event,
  Grobal2, FSrvValue, InterServerMsg, InterMsgClient, HUtil32, Buttons,
  Sockets, M2Share, Castle, MfdbDef, ObjNpc, UserMgrEngn, DragonSystem,
  SQLEngn, DBSQL, EDCode,
  IdBaseComponent, IdComponent, IdUDPBase, IdUDPClient, Menus;

const
  ENGLISHVERSION    = False;
  PHILIPPINEVERSION = True;
  CHINAVERSION      = False;
  TAIWANVERSION     = False;
  KOREANVERSION     = False;

  SENDBLOCK: integer = 1024; //2048;  //����Ʈ�� ����ϱ� ������ ���� ũ��.
  SENDCHECKBLOCK: integer = 4096; //2048;      //ĳũ ��ȣ�� ������.
  SENDAVAILABLEBLOCK: integer = 8192; //4096;  //ĳũ ��ȣ�� ��� �������� ������.
  GATELOAD: integer = 10; //10KB
  LINENOTICEFILE    = 'Notice\LineNotice.txt';
  LINEHELPFILE      = 'LineHelp.txt';

  BUILDGUILDFEE: integer = 1000000;


type
  TFrmMain = class(TForm)
    Memo1:      TMemo;
    Panel1:     TPanel;
    LbRunTime:  TLabel;
    LbUserCount: TLabel;
    Label1:     TLabel;
    Label2:     TLabel;
    Label3:     TLabel;
    Label4:     TLabel;
    LbTimeCount: TLabel;
    Label5:     TLabel;
    GateSocket: TServerSocket;
    DBSocket:   TClientSocket;
    ConnectTimer: TTimer;
    Timer1:     TTimer;
    RunTimer:   TTimer;
    TCloseTimer: TTimer;
    StartTimer: TTimer;
    SaveVariableTimer: TTimer;
    IdUDPClient: TIdUDPClient;
    MainMenu: TMainMenu;
    Service1: TMenuItem;
    Help1: TMenuItem;
    Exit1: TMenuItem;
    Initialize1: TMenuItem;
    N1: TMenuItem;
    Reload1: TMenuItem;
    AdminList1: TMenuItem;
    ChatLogList1: TMenuItem;
    procedure GateSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GateSocketClientDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure GateSocketClientError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure GateSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure RunTimerTimer(Sender: TObject);
    procedure ConnectTimerTimer(Sender: TObject);
    procedure DBSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
    procedure DBSocketError(Sender: TObject; Socket: TCustomWinSocket;
      ErrorEvent: TErrorEvent; var ErrorCode: integer);
    procedure DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure StartTimerTimer(Sender: TObject);
    procedure SaveVariableTimerTimer(Sender: TObject);
    procedure TCloseTimerTimer(Sender: TObject);
    procedure Panel1DblClick(Sender: TObject);
    procedure Exit1Click(Sender: TObject);
    procedure Initialize1Click(Sender: TObject);
    procedure AdminList1Click(Sender: TObject);
    procedure ChatLogList1Click(Sender: TObject);
  private
    procedure MakeStoneMines;
    procedure StartServer;
    procedure OnProgramException(Sender: TObject; E: Exception);
    function LoadClientFileCheckSum: boolean;
  public
    procedure SaveItemNumber;
    procedure RefreshForm;
  end;


procedure MainOutMessage(str: string);
procedure AddUserLog(str: string);  //�÷��̾��� �ൿ�� ���
procedure AddConLog(str: string);   //���� ����� �α׷� ����
procedure AddChatLog(str: string);  //ä�� ����� �α׷� ����
function GetCertifyNumber: integer;
function GetItemServerIndex: integer;
function DBConnected: boolean;
procedure LoadMultiServerTables;
function GetMultiServerAddrPort(servernum: byte; var addr: string;
  var port: integer): boolean;
function GetUnbindItemName(shape: integer): string;
function LoadLineNotice(flname: string): boolean;
function LoadLineHelp(flname: string): boolean;


var
  FrmMain:      TFrmMain;
  RunSocket:    TRunSocket;
  FrontEngine:  TFrontEngine;
  UserEngine:   TUserEngine;
  UserMgrEngine: TUserMgrEngine;
  GrobalEnvir:  TEnvirList;
  ItemMan:      TItemUnit;
  MagicMan:     TMagicManager;
  NoticeMan:    TNoticeManager;
  GuildMan:     TGuildManager;
  GuildAgitMan: TGuildAgitManager;  //�������(sonmg)
  GuildAgitBoardMan: TGuildAgitBoardManager;  //����Խ���(sonmg)
  GuildAgitStartNumber: integer;    //������� ���۹�ȣ(MapInfo���� �о��).
  GuildAgitMaxNumber: integer;      //������� �ִ밳��(MapInfo���� �о��).
  EventMan:     TEventManager;
  UserCastle:   TUserCastle;
  boUserCastleInitialized: boolean;
  gFireDragon:  TDragonSystem;

  DecoItemList:    TStringList;    //����ٹ̱�
  MakeItemList:    TStringList;    // list of TStringList;
  MakeItemIndexList: TStringList;  // ���� ������ ���� Index ����Ʈ.
  StartPoints:     TList;
  SafePoints:      TList;
  MultiServerList: TList;
  ShutUpList:      TQuickList; //ä�ñ��� ����Ʈ
  MiniMapList:     TStringList;
  UnbindItemList:  TStringList;
  LineNoticeList:  TStringList;
  LineHelpList:    TStringList;
  QuestDiaryList:  TList;  //list of TList of TList(PTQDDinfo)
  //TQDDinfo // [n] index or unit index
  // TStringList
  StartupQuestNpc: TMerchant;


  EventItemList:     TStringList;   //����ũ ������ �̺�Ʈ�� ���� ����Ʈ
  EventItemGifeBaseNumber: integer;
  GrobalQuestParams: array[0..9] of integer;

  ErrorLogFile: string;
  MirDayTime:   integer;  //�̸��� �ð�... ���� �ð��� 2�� ����
  ServerIndex:  integer;
  ServerName:   string;
  ServerNumber: integer;

  BoVentureServer: boolean;
  BoTestServer:  boolean;
  BoClientTest:  boolean;
  TestLevel:     integer;
  TestGold:      integer;
  TestServerMaxUser: integer;
  BoServiceMode: boolean;
  BoNonPKServer: boolean;
  BoViewHackCode: boolean;
  BoViewAdmissionfail: boolean;
  BoGetGetNeedNotice: boolean;
  GetGetNoticeTime: longword;

  UserFullCount:   integer;
  ZenFastStep:     integer;
  BoSysHasMission: boolean;    //�̺�Ʈ��, �̼��� �ִ���
  SysMission_Map:  string;
  SysMission_X:    integer;
  SysMission_Y:    integer;
  TotalUserCount:  integer;  //�������� ������ ����ڼ�

  csMsgLock:   TCriticalSection;
  csTimerLock: TCriticalSection;
  csObjMsgLock: TCriticalSection;
  csSendMsgLock: TCriticalSection;
  csShare:     TCriticalSection;  //����ȭ �ð��� �F�� ���������� ����ؾ� ��.
  csDelShare:  TCriticalSection;  //����ȭ �ð��� �F�� ���������� ����ؾ� ��.
  csSocLock:   TCriticalSection;
  usLock:      TCriticalSection;   //user engine thread
  usIMLock:    TCriticalSection;   //user engine thread
  ruLock:      TCriticalSection;   // run sock
  ruSendLock:  TCriticalSection;   // run sock
  ruCloseLock: TCriticalSection;   // run sock
  socstrLock:  TCriticalSection;
  fuLock:      TCriticalSection;   //front engine thread
  fuOpenLock:  TCriticalSection;   //front engine thread
  fuCloseLock: TCriticalSection;   //front engine thread
  humanLock:   TCriticalSection;   // human sendbufer
  umLock:      TCriticalSection;   //User Manager engine thread
  SQLock:      TCriticalSection;   // SQL Engine Thread

  MainMsg:      TStringList;
  UserLogs:     TStringList;  //�÷��̾��� �ൿ �α�
  UserConLogs:  TStringList;  //���� �α�
  UserChatLog:  TStringList;  //ä�� �α�
  DiscountForNightTime: boolean;
  HalfFeeStart: integer;   //���νð� ����
  HalfFeeEnd:   integer;   //���νð� ��

  ServerReady:    boolean;       //������ ����ڸ� ���� �غ� �Ǿ��°�?
  ServerClosing:  boolean;
  FCertify, FItemNumber: integer;
  RDBSocData:     string;
  ReadyDBReceive: boolean;
  RunFailCount:   integer;
  MirUserLoadCount: integer;
  MirUserSaveCount: integer;
  CurrentDBloadingTime: longword;
  BoEnableAbusiveFilter: boolean;
  LottoSuccess, LottoFail: integer;
  Lotto1, Lotto2, Lotto3, Lotto4, Lotto5, Lotto6: integer;

  MsgServerAddress: string;
  MsgServerPort:    integer;
  LogServerAddress: string;
  LogServerPort:    integer;
  DBServerAddress: string;
  DBServerPort:    integer;
  ShareBaseDir:     string;
  ShareBaseDirCopy: string;
  ShareVentureDir:  string;
  ShareFileNameNum: integer;
  ConLogBaseDir:    string;  //���� �ð� �α�
  ChatLogBaseDir:   string;  //���� �ð� �α�

  DefHomeMap: string;  //�� �������� �� �־�� �ϴ� ��
  DefHomeX: integer;
  DefHomeY: integer;
  GuildDir: string;
  GuildFile: string;
  GuildBaseDir: string;
  GuildAgitFile: string;
  CastleDir: string;
  EnvirDir: string;
  MapDir: string;

  CurrentMonthlyCard: integer;    //������ ����� ��
  TotalTimeCardUsage: integer;    //�ð��� ī�� ������� ��� �� �ð� //�ð�
  LastMonthTotalTimeCardUsage: integer;   //�ð�
  GrossTimeCardUsage: integer;    //�ð�
  GrossResetCount:    integer;

  serverruntime: longword;
  runstart:    longword;
  rcount:      integer;
  minruncount: integer;
  curruncount: integer;
  maxsoctime:  integer;
  cursoctime:  integer;
  maxusrtime:  integer;
  curusrcount: integer;
  curhumtime:  integer;
  maxhumtime:  integer;
  curmontime:  integer;
  maxmontime:  integer;
  humrotatetime: longword;
  curhumrotatetime: integer;
  maxhumrotatetime: integer;
  humrotatecount: integer;
  LatestGenStr: string[30];
  LatestMonStr: string[30];

  HumLimitTime: longword;
  MonLimitTime: longword;
  ZenLimitTime: longword;
  NpcLimitTime: longword;
  SocLimitTime: longword;
  DecLimitTime: longword;

  //�̸���
  __GiveItemWarMan: string;
  __GiveItemWarWoman: string;
  __GiveItemWizMan: string;
  __GiveItemWizWoman: string;
  __GiveItemTaoMan: string;
  __GiveItemTaoWoman: string;
  __GiveItemKillMan: string;
  __GiveItemKillWoman: string;
  {__ClothsForMan: string;
  __ClothsForWoman: string;
  __WoodenSword: string;
  __Candle:    string;
  __BasicDrug: string;}

  __GoldStone:   string;
  __SilverStone: string;
  __SteelStone:  string;
  __CopperStone: string;
  __BlackStone:  string;
  __Gem1Stone:   string;
  __Gem2Stone:   string;
  __Gem3Stone:   string;
  __Gem4Stone:   string;

  __ZumaMonster1: string;
  __ZumaMonster2: string;
  __ZumaMonster3: string;
  __ZumaMonster4: string;

  __Bee:      string;
  __Spider:   string;
  __WhiteSkeleton: string;
  __ShinSu:   string;
  __ShinSu1:  string;
  __AngelMob: string;
  __CloneMob: string;
  __WomaHorn: string;
  __ZumaPiece: string;

  __GoldenImugi: string;
  __WhiteSnake:  string;


  ClientFileName1:      string;
  ClientFileName2:      string;
  ClientFileName3:      string;
  ClientCheckSumValue1: integer;
  ClientCheckSumValue2: integer;
  ClientCheckSumValue3: integer;

  //����� ����
  gErrorCount: integer;
  //���� �������� Merchant Index
  CurrentMerchantIndex: integer;

implementation

{$R *.DFM}

uses
  LocalDB, IdSrvClient;

function IntTo_Str(val: integer): string;
begin
  if val < 10 then
    Result := '0' + IntToStr(val)
  else
    Result := IntToStr(val);
end;

function LoadSettings: Boolean;
var
  fname: string;
  ini: TIniFile;
begin
  Result := False;
  fname := '.\!setup.txt';
  if FileExists(fname) then begin
    ini := TIniFile.Create(fname);
    if ini <> nil then begin
      ServerIndex := ini.ReadInteger('Server', 'ServerIndex', 0);
      ServerName := ini.ReadString('Server', 'ServerName', '');
      ServerNumber := ini.ReadInteger('Server', 'ServerNumber', 0);
      BoVentureServer := ini.ReadBool('Server', 'VentureServer', FALSE);

      BoTestServer := ini.ReadBool('Server', 'TestServer', FALSE);
      //Ŭ���̾�Ʈ �׽�Ʈ��
      BoClientTest := ini.ReadBool('Server', 'ClientTest', FALSE);

      TestLevel := ini.ReadInteger('Server', 'TestLevel', 1);
      TestGold  := ini.ReadInteger('Server', 'TestGold', 0);
      TestServerMaxUser := ini.ReadInteger('Server', 'TestServerUserLimit', 5000);

      BoServiceMode := ini.ReadBool('Server', 'ServiceMode', FALSE);
      BoNonPKServer := ini.ReadBool('Server', 'NonPKServer', FALSE);
      BoViewHackCode := ini.ReadBool('Server', 'ViewHackMessage', TRUE);
      BoViewAdmissionfail := ini.ReadBool('Server', 'ViewAdmissionFailure', FALSE);

      DefHomeMap := ini.ReadString('Server', 'HomeMap', '0');
      DefHomeX   := ini.ReadInteger('Server', 'HomeX', 289);
      DefHomeY   := ini.ReadInteger('Server', 'HomeY', 618);

      DBServerAddress := ini.ReadString('Server', 'DBAddr', '210.121.143.205');
      DBServerPort    := ini.ReadInteger('Server', 'DBPort', 6000);

      FItemNumber := ini.ReadInteger('Setup', 'ItemNumber', 0);

      HumLimitTime := ini.ReadInteger('Server', 'HumLimit', HumLimitTime);
      MonLimitTime := ini.ReadInteger('Server', 'MonLimit', MonLimitTime);
      ZenLimitTime := ini.ReadInteger('Server', 'ZenLimit', ZenLimitTime);
      NpcLimitTime := ini.ReadInteger('Server', 'NpcLimit', NpcLimitTime);
      SocLimitTime := ini.ReadInteger('Server', 'SocLimit', SocLimitTime);
      DecLimitTime := ini.ReadInteger('Server', 'DecLimit', DecLimitTime);

      SENDBLOCK := ini.ReadInteger('Server', 'SendBlock', SENDBLOCK);
      SENDCHECKBLOCK := ini.ReadInteger('Server', 'CheckBlock', SENDCHECKBLOCK);
      SENDAVAILABLEBLOCK :=
        ini.ReadInteger('Server', 'AvailableBlock', SENDAVAILABLEBLOCK);
      GATELOAD := ini.ReadInteger('Server', 'GateLoad', GATELOAD);

      UserFullCount := ini.ReadInteger('Server', 'UserFull', 500);
      ZenFastStep   := ini.ReadInteger('Server', 'ZenFastStep', 300);

      MsgServerAddress := ini.ReadString('Server', 'MsgSrvAddr', '210.121.143.205');
      MsgServerPort    := ini.ReadInteger('Server', 'MsgSrvPort', 4900);

      LogServerAddress := ini.ReadString('Server', 'LogServerAddr', '192.168.0.152');
      LogServerPort    := ini.ReadInteger('Server', 'LogServerPort', 10000);

      DiscountForNightTime := ini.ReadBool('Server', 'DiscountForNightTime', False);
      HalfFeeStart := ini.ReadInteger('Server', 'HalfFeeStart', 2);  //2��
      HalfFeeEnd   := ini.ReadInteger('Server', 'HalfFeeEnd', 10);   //10��

      ShareBaseDir     := ini.ReadString('Share', 'BaseDir', 'D:\');
      ShareBaseDirCopy := ShareBaseDir;

      ShareFileNameNum := 1;
      GuildDir      := ini.ReadString('Share', 'GuildDir', 'D:\');
      GuildFile     := ini.ReadString('Share', 'GuildFile', 'D:\');
      // ��� ��� ����.
      GuildBaseDir  := ExtractFileDir(GuildFile) + '\';
      //������ GuildFile�� ���� ���(sonmg)
      GuildAgitFile := GuildBaseDir + 'GuildAgitList.txt';
      //�����̸� �ϵ��ڵ�(sonmg)

      ShareVentureDir := ini.ReadString('Share', 'VentureDir', 'D:\');
      ConLogBaseDir := ini.ReadString('Share', 'ConLogDir', 'D:\');
      ChatLogBaseDir := ini.ReadString('Share', 'ChatLogDir', 'D:\');
      CastleDir := ini.ReadString('Share', 'CastleDir', 'D:\');
      EnvirDir  := ini.ReadString('Share', 'EnvirDir', '.\Envir\');
      MapDir    := ini.ReadString('Share', 'MapDir', '.\Map\');

      ClientFileName1 := ini.ReadString('Setup', 'ClientFile1', '');
      ClientFileName2 := ini.ReadString('Setup', 'ClientFile2', '');
      ClientFileName3 := ini.ReadString('Setup', 'ClientFile3', '');

      __GiveItemWarMan := ini.ReadString('Names', 'GiveItemWarMan', '');
      __GiveItemWarWoman := ini.ReadString('Names', 'GiveItemWarMan', '');
      __GiveItemWizMan := ini.ReadString('Names', 'GiveItemWizMan', '');
      __GiveItemWizWoman := ini.ReadString('Names', 'GiveItemWizMan', '');
      __GiveItemTaoMan := ini.ReadString('Names', 'GiveItemTaoMan', '');
      __GiveItemTaoWoman := ini.ReadString('Names', 'GiveItemTaoMan', '');
      __GiveItemKillMan := ini.ReadString('Names', 'GiveItemKillMan', '');
      __GiveItemKillWoman := ini.ReadString('Names', 'GiveItemKillMan', '');

//      __ClothsForMan := ini.ReadString('Names', 'ClothsMan', '');
//      __ClothsForWoman := ini.ReadString('Names', 'ClothsWoman', '');
//      __WoodenSword := ini.ReadString('Names', 'WoodenSword', '');
//      __Candle    := ini.ReadString('Names', 'Candle', '');
//      __BasicDrug := ini.ReadString('Names', 'BasicDrug', '');

      __GoldStone   := ini.ReadString('Names', 'GoldStone', '');
      __SilverStone := ini.ReadString('Names', 'SilverStone', '');
      __SteelStone  := ini.ReadString('Names', 'SteelStone', '');
      __CopperStone := ini.ReadString('Names', 'CopperStone', '');
      __BlackStone  := ini.ReadString('Names', 'BlackStone', '');
      __Gem1Stone   := ini.ReadString('Names', 'Gem1Stone', '');
      __Gem2Stone   := ini.ReadString('Names', 'Gem2Stone', '');
      __Gem3Stone   := ini.ReadString('Names', 'Gem3Stone', '');
      __Gem4Stone   := ini.ReadString('Names', 'Gem4Stone', '');

      __ZumaMonster1 := ini.ReadString('Names', 'Zuma1', '');
      __ZumaMonster2 := ini.ReadString('Names', 'Zuma2', '');
      __ZumaMonster3 := ini.ReadString('Names', 'Zuma3', '');
      __ZumaMonster4 := ini.ReadString('Names', 'Zuma4', '');

      __Bee      := ini.ReadString('Names', 'Bee', '');
      __Spider   := ini.ReadString('Names', 'Spider', '');
      __WhiteSkeleton := ini.ReadString('Names', 'Skeleton', '');
      __ShinSu   := ini.ReadString('Names', 'Dragon', '');
      __ShinSu1  := ini.ReadString('Names', 'Dragon1', '');
      __AngelMob := ini.ReadString('Names', 'Angel', '');
      __CloneMob := ini.ReadString('Names', 'Clone', '');

      __WomaHorn    := ini.ReadString('Names', 'WomaHorn', '');
      BUILDGUILDFEE := ini.ReadInteger('Names', 'BuildGuildFee', BUILDGUILDFEE);
      __ZumaPiece   := ini.ReadString('Names', 'ZumaPiece', '');

      __GoldenImugi := ini.ReadString('Names', 'GoldenImugi', '');
      __WhiteSnake  := ini.ReadString('Names', 'WhiteSnake', '');

      ini.Free;

      Result := True;
    end;
  end;
end;


procedure TFrmMain.RefreshForm;
begin
  Application.ProcessMessages;
end;

procedure TFrmMain.FormCreate(Sender: TObject);
var
  ayear, amon, aday, ahour, amin, asec, amsec: word;
  fhandle: TextFile;
  d: TDefaultMessage;
begin
  gErrorCount := 0;
  Randomize;
  ServerIndex := 0;

  RunSocket    := TRunSocket.Create;
  MainMsg      := TStringList.Create;
  UserLogs     := TStringList.Create;
  UserConLogs  := TStringList.Create;
  UserChatLog  := TStringList.Create;
  GrobalEnvir  := TEnvirList.Create;
  ItemMan      := TItemUnit.Create;
  MagicMan     := TMagicManager.Create;
  NoticeMan    := TNoticeManager.Create;
  GuildMan     := TGuildManager.Create;
  GuildAgitMan := TGuildAgitManager.Create; //�������(sonmg)
  GuildAgitBoardMan := TGuildAgitBoardManager.Create;  //����Խ���(sonmg)
  EventMan     := TEventManager.Create;
  UserCastle   := TUserCastle.Create;
  boUserCastleInitialized := False;
  //����� �ý���
  gFireDragon  := TDragonSystem.Create;

  FrontEngine   := TFrontEngine.Create;
  UserEngine    := TUserEngine.Create;
  // ģ�� ���� �ý���
  UserMgrEngine := TUserMgrEngine.Create;

  // DBSQL
  g_DBSQL   := TDBSQL.Create;
  SQLEngine := TSQLEngine.Create;


  DecoItemList    := TStringList.Create;
  MakeItemList    := TStringList.Create;
  MakeItemIndexList := TStringList.Create;
  StartPoints     := TList.Create;
  SafePoints      := TList.Create;
  MultiServerList := TList.Create;
  ShutUpList      := TQuickList.Create;
  MiniMapList     := TStringList.Create;
  UnbindItemList  := TStringList.Create;
  LineNoticeList  := TStringList.Create;
  LineHelpList    := TStringList.Create;
  QuestDiaryList  := TList.Create;
  StartupQuestNpc := nil;

  EventItemList := TStringList.Create;
  EventItemGifeBaseNumber := 0;

  csMsgLock   := TCriticalSection.Create;
  csTimerLock := TCriticalSection.Create;
  csObjMsgLock := TCriticalSection.Create;
  csSendMsgLock := TCriticalSection.Create;
  csShare     := TCriticalSection.Create;
  csDelShare  := TCriticalSection.Create;
  csSocLock   := TCriticalSection.Create;
  usLock      := TCriticalSection.Create;
  usIMLock    := TCriticalSection.Create;
  ruLock      := TCriticalSection.Create;
  ruSendLock  := TCriticalSection.Create;
  ruCloseLock := TCriticalSection.Create;
  socstrLock  := TCriticalSection.Create;
  fuLock      := TCriticalSection.Create;
  fuOpenLock  := TCriticalSection.Create;
  fuCloseLock := TCriticalSection.Create;
  HumanLock   := TCriticalSection.Create; // �����͵��� �� ���� ���ұ�...
  umLock      := TCriticalSection.Create;
  SQLock      := TCriticalSection.Create;

  RDBSocData     := '';
  ReadyDBReceive := False;
  RunFailCount   := 0;
  MirUserLoadCount := 0;
  MirUserSaveCount := 0;
  BoGetGetNeedNotice := False;

  FCertify := 0;
  FItemNumber := 0;
  ServerReady := False;
  ServerClosing := False;
  BoEnableAbusiveFilter := True;
  LottoSuccess := 0;
  LottoFail := 0;
  Lotto1 := 0;
  Lotto2 := 0;
  Lotto3 := 0;
  Lotto4 := 0;
  Lotto5 := 0;
  Lotto6 := 0;

  CurrentMerchantIndex := 0;

  FillChar(GrobalQuestParams, sizeof(GrobalQuestParams), #0);

  DecodeDate(Date, ayear, amon, aday);
  DecodeTime(Time, ahour, amin, asec, amsec);
  ErrorLogFile := '.\Log\' + IntToStr(ayear) + '-' + IntToStr(amon) +
    '-' + IntTo_Str(aday) + '.' + IntTo_Str(ahour) + '-' + IntTo_Str(amin) + '.log';
  AssignFile(fhandle, ErrorLogFile);
  Rewrite(fhandle);
  CloseFile(fhandle);

  minruncount    := 99999;
  maxsoctime     := 0;
  maxusrtime     := 0;
  maxhumtime     := 0;
  maxmontime     := 0;
  curhumrotatetime := 0;
  maxhumrotatetime := 0;
  humrotatecount := 0;


  HumLimitTime := 30;
  MonLimitTime := 30;
  ZenLimitTime := 5;
  NpcLimitTime := 5;
  SocLimitTime := 10;
  DecLimitTime := 20;

  Memo1.Lines.Add('ready to load ini file..');
  if LoadSettings then begin
    with DBSocket do begin
      Address := DBServerAddress;
      Port := DBServerPort;
      Active  := True;
    end;
    Memo1.Lines.Add('!setup.txt loaded..');
  end else
    ShowMessage('File not found... <!setup.txt>');

  if (__GoldStone = '') or (__SilverStone = '') or (__SteelStone = '') or (__CopperStone = '') or
    (__BlackStone = '') or (__Gem1Stone = '') or (__Gem2Stone = '') or
    (__Gem3Stone = '') or (__Gem4Stone = '') or (__ZumaMonster1 = '') or
    (__ZumaMonster2 = '') or (__ZumaMonster3 = '') or (__ZumaMonster4 = '') or
    (__Bee = '') or (__Spider = '') or (__WhiteSkeleton = '') or
    (__ShinSu = '') or (__ShinSu1 = '') or (__AngelMob = '') or
    (__CloneMob = '') or (__WomaHorn = '') or (__ZumaPiece = '') or
    (__GoldenImugi = '') or (__WhiteSnake = '') then
    ShowMessage('Check your !setup.txt file. [Names] -> __GoldStone ...');


{$IFDEF MIR2EI}
   Caption := '[ei] ' + ServerName + ' ' + DateToStr(Date) + ' ' + TimeToStr(Time);
   Panel1.Color := clLime;
{$ELSE}
  // 2003/04/01 ���� ��ȣ ǥ��
  Caption := ServerName + ' ' + DateToStr(Date) + ' ' + TimeToStr(Time) +
    ' V' + IntToStr(VERSION_NUMBER);
{$ENDIF}

  LoadMultiServerTables;

  IdUDPClient.Active    := False;
  IdUDPClient.Host      := LogServerAddress;
  IdUDPClient.Port      := LogServerPort;
  IdUDPClient.Active    := True;

  ConnectTimer.Enabled    := True;
  Application.OnException := OnProgramException;

  CurrentDBloadingTime := GetTickCount;
  serverruntime := GetTickCount;

  StartTimer.Enabled := True;
  Timer1.Enabled     := True;
end;

procedure TFrmMain.OnProgramException(Sender: TObject; E: Exception);
begin
  if gErrorCount > 20000 then begin
    gErrorCount := 0;
    //   if Sender <> nil then
    //       MainOutMessage (Sender.ClassName +':'+E.Message + formatdatetime('hh:nn:ss',now))
    //   else
    MainOutMessage(E.Message + formatdatetime('hh:nn:ss', now));
  end;
  gErrorCount := gErrorCount + 1;
end;

procedure TFrmMain.FormDestroy(Sender: TObject);
var
  i: Integer;
begin
  SaveItemNumber;
  //���� ���������� ��ϼ� ������ �ʱ�ȭ�Ǵ� ���� �������� �ڵ�(sonmg 2004/08/13)
  if boUserCastleInitialized then
    UserCastle.SaveAll;

  FrontEngine.Terminate;
  //FrontEngine.Suspend;
  FrontEngine.Free;

  UserEngine.Free;

  //ģ�� ���� �ý���
  UserMgrEngine.Terminate;
  //UserMgrEngine.Suspend;
  UserMgrEngine.Free;

  //DBSQL
  SQLEngine.Terminate;
  //SQLEngine.Suspend;

  g_DBSQL.Free;
  SQLEngine.Free;

  RunSocket.Free;
  MainMsg.Free;
  UserLogs.Free;
  UserConLogs.Free;
  UserChatLog.Free;
  GrobalEnvir.Free;
  ItemMan.Free;
  MagicMan.Free;
  NoticeMan.Free;
  GuildMan.Free;
  GuildAgitMan.Free;      //�������(sonmg)
  GuildAgitBoardMan.Free; //����Խ���(sonmg)
  EventMan.Free;
  UserCastle.Free;
  gFireDragon.Free;

  DecoItemList.Free;

  for i := 0 to MakeItemList.Count - 1 do
    TStringList(MakeItemList.Objects[i]).Free;
  MakeItemList.Free;
  MakeItemIndexList.Free;

  for i := 0 to StartPoints.Count - 1 do
    Dispose(PTMapPoint(StartPoints[i]));
  StartPoints.Free;

  for i := 0 to SafePoints.Count - 1 do
    Dispose(PTMapPoint(SafePoints[i]));
  SafePoints.Free;

  for i := 0 to MultiServerList.Count - 1 do
    TStringList(MultiServerList[i]).Free;
  MultiServerList.Free;

  ShutUpList.Free;
  MiniMapList.Free;
  UnbindItemList.Free;
  LineNoticeList.Free;
  LineHelpList.Free;

  FrmDB.ClearQuestDiary;
  QuestDiaryList.Free;

  EventItemList.Free;

  csMsgLock.Free;
  csTimerLock.Free;
  csObjMsgLock.Free;
  csSendMsgLock.Free;
  csShare.Free;
  csDelShare.Free;
  csSocLock.Free;
  usLock.Free;
  usIMLock.Free;
  ruLock.Free;
  ruSendLock.Free;
  ruCloseLock.Free;
  socstrLock.Free;
  fuLock.Free;
  fuOpenLock.Free;
  fuCloseLock.Free;
  HumanLock.Free;
  umLock.Free;
  SQLock.Free;
end;

procedure TFrmMain.SaveItemNumber;
var
  fname: string;
  ini:   TIniFile;
begin
  fname := '.\!setup.txt';
  ini   := TIniFile.Create(fname);
  if ini <> nil then begin
    ini.WriteInteger('Setup', 'ItemNumber', FItemNumber);
    ini.Free;
  end;
end;

function GetCertifyNumber: integer;
begin
  Inc(FCertify);
  if FCertify > $7FFE then
    FCertify := 1;
  Result := FCertify;
end;

function GetItemServerIndex: integer;
begin
  Inc(FItemNumber);
  if FItemNumber > $7FFFFFFE then
    FItemNumber := 1;
  Result := FItemNumber;
end;

procedure LoadMultiServerTables;
var
  i, k: integer;
  str, snum, saddr, sport: string;
  strlist, slist: TStringList;
begin
  for i := 0 to MultiServerList.Count - 1 do
    TStringList(MultiServerList[i]).Free;
  MultiServerList.Clear;

  if FileExists('!servertable.txt') then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile('!servertable.txt');
    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str <> '' then begin
        if str[1] = ';' then
          continue;
        str := GetValidStr3(str, snum, [' ', #9]);
        if str <> '' then begin
          slist := TStringList.Create;
          for k := 0 to 30 do begin
            if str = '' then
              break;
            str := GetValidStr3(str, saddr, [' ', #9]);
            str := GetValidStr3(str, sport, [' ', #9]);
            if (saddr <> '') and (sport <> '') then begin
              slist.AddObject(saddr, TObject(Str_ToInt(sport, 0)));
            end;
          end;
          MultiServerList.Add(slist);
        end;
      end;
    end;
    strlist.Free;
  end else
    ShowMessage('File not found... <!servertable.txt>');
end;

function LoadLineNotice(flname: string): boolean;
begin
  Result := False;
  if FileExists(flname) then begin
    LineNoticeList.LoadFromFile(flname);
    CheckListValid(LineNoticeList);
    Result := True;
  end;
end;

function LoadLineHelp(flname: string): boolean;
begin
  Result := False;
  if FileExists(flname) then begin
    LineHelpList.LoadFromFile(flname);
    CheckListValid(LineHelpList);
    Result := True;
  end;
end;

function GetMultiServerAddrPort(servernum: byte; var addr: string;
  var port: integer): boolean;
var
  n:     integer;
  slist: TStringList;
begin
  Result := False;
  if servernum < MultiServerList.Count then begin
    slist  := TStringList(MultiServerList[servernum]);
    n      := Random(slist.Count);
    addr   := slist[n];
    port   := integer(slist.Objects[n]);
    Result := True;
  end else
    MainOutMessage('GetMultiServerAddrPort Fail..:' + IntToStr(servernum));
end;

function GetUnbindItemName(shape: integer): string;
var
  i: integer;
begin
  Result := '';
  for i := 0 to UnbindItemList.Count - 1 do begin
    if integer(UnbindItemList.Objects[i]) = shape then begin
      Result := UnbindItemList[i];
      break;
    end;
  end;
end;


procedure MainOutMessage(str: string);
begin
  try
    csMsgLock.Enter;
    MainMsg.Add(str);
  finally
    csMsgLock.Leave;
  end;
end;

procedure AddUserLog(str: string);
begin
  try
    csMsgLock.Enter;
    UserLogs.Add(str);
  finally
    csMsgLock.Leave;
  end;
end;

procedure AddConLog(str: string);
begin
  try
    csMsgLock.Enter;
    UserConLogs.Add(str);
  finally
    csMsgLock.Leave;
  end;
end;

procedure AddChatLog(str: string);
begin
  try
    csMsgLock.Enter;
    UserChatLog.Add(str);
  finally
    csMsgLock.Leave;
  end;
end;

procedure WriteConLogs(slist: TStringList);
var
  ayear, amon, aday, ahour, amin, asec, amsec: word;
  dirname, flname: string;
  f:      TextFile;
  i:      integer;
begin
  if slist.Count = 0 then
    exit;

  DecodeDate(Date, ayear, amon, aday);
  DecodeTime(Time, ahour, amin, asec, amsec);
  dirname := ConLogBaseDir + IntToStr(ayear) + '-' + IntTo_Str(amon) +
    '-' + IntTo_Str(aday);
  if not DirectoryExists(dirname) then begin
    if not CreateDir(dirname) then Exit;
  end;
  flname := dirname + '\C-' + IntToStr(ServerIndex) + '-' +
    IntTo_Str(ahour) + 'H' + IntTo_Str(amin div 10 * 10) + 'M.txt';

  AssignFile(f, flname);
  if not FileExists(flname) then
    Rewrite(f)
  else
    Append(f);

  for i := 0 to slist.Count - 1 do begin
    WriteLn(f, '1'#9 + slist[i] + ''#9 + '0');
  end;

  CloseFile(f);
end;

procedure WriteChatLogs(slist: TStringList);
var
  ayear, amon, aday, ahour, amin, asec, amsec: word;
  dirname, flname: string;
  f:      TextFile;
  i:      integer;
begin
  if slist.Count = 0 then
    exit;

  DecodeDate(Date, ayear, amon, aday);
  DecodeTime(Time, ahour, amin, asec, amsec);
  dirname := ChatLogBaseDir + IntToStr(ayear) + '-' + IntTo_Str(amon) +
    '-' + IntTo_Str(aday);
  if not DirectoryExists(dirname) then begin
    if not CreateDir(dirname) then Exit;
  end;
  flname := dirname + '\C-' + {IntToStr(ServerIndex) + '-' +} IntTo_Str(ahour) +
    'H' + {IntTo_Str(amin div 10 * 10) +} 'M.txt';

  AssignFile(f, flname);
  if not FileExists(flname) then
    Rewrite(f)
  else
    Append(f);

  for i := 0 to slist.Count - 1 do begin
    WriteLn(f, IntToStr(ServerIndex) + ''#9 + slist[i] + ''#9 + '0');
  end;

  CloseFile(f);
end;

function TFrmMain.LoadClientFileCheckSum: boolean;
begin
  Memo1.Lines.Add('loading client version information..');
  if ClientFileName1 <> '' then
    ClientCheckSumValue1 := CalcFileCheckSum(ClientFileName1);
  if ClientFileName2 <> '' then
    ClientCheckSumValue2 := CalcFileCheckSum(ClientFileName2);
  if ClientFileName3 <> '' then
    ClientCheckSumValue3 := CalcFileCheckSum(ClientFileName3);
  if (clientchecksumvalue1 = 0) and (clientchecksumvalue2 = 0) and
    (clientchecksumvalue3 = 0) then begin
    Memo1.Lines.Add(
      'Loading client version information failed. check !setup.txt -> [setup] -> clientfile1,..');
    Result := False;
  end else begin
    Memo1.Lines.Add('Ok.');
    Result := True;
  end;
end;

// ----------------------------------------------------------------


procedure TFrmMain.StartTimerTimer(Sender: TObject);
var
  i, error, checkvalue: integer;
  IsSuccess: boolean;
  handle, FileDate: integer;
  DateTime:  TDateTime;
begin
  StartTimer.Enabled := False;

  try
    //������ �˻�
{$ifdef MIR2EI}
    checkvalue := SIZEOFEIFDB;
{$else}
    checkvalue := SIZEOFFDB;
{$endif}

    if sizeof(FDBRecord) <> checkvalue then begin
      ShowMessage('sizeof(THuman) <> SIZEOFTHUMAN');
      Close;
      exit;
    end;

    if not LoadClientFileCheckSum then begin
      Close;
      exit;
    end;

    Memo1.Lines.Add('loading StdItem.DB...');

    //�⺻ ����Ÿ�� �ε� �Ѵ�.
    error := FrmDB.LoadStdItems;
    if error < 0 then begin
      ShowMessage('StdItems.DB' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('StdItem.DB loaded.');

    Memo1.Lines.Add('loading MiniMap.txt...');
    error := FrmDB.LoadMiniMapInfos;
    if error < 0 then begin
      ShowMessage('MiniMap.txt' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('MiniMap information loaded.');

    // ����� �ý��� �ε�
    Memo1.Lines.Add('Loading DragonSystem...');
    Memo1.Lines.Add(gFireDragon.Initialize(EnvirDir + DRAGONITEMFILE, IsSuccess));
    if (not IsSuccess) then
      Memo1.Lines.Add(DRAGONITEMFILE + '�� �дµ��߿����� �߻��Ͽ���');


    Memo1.Lines.Add('loading MapFiles...');
    error := FrmDB.LoadMapFiles;
    if error < 0 then begin
      ShowMessage(' : Failure was occurred while reading this map file. code=' +
        IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('Mapfile loaded.');

    Memo1.Lines.Add('loading Monster.DB...');
    error := FrmDB.LoadMonsters;
    if error <= 0 then begin
      ShowMessage('Monster.DB' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('Monster.DB loaded.');

    Memo1.Lines.Add('loading Magic.DB...');
    error := FrmDB.LoadMagic;
    if error <= 0 then begin
      ShowMessage('Magic.DB' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('Magic.DB loaded.');

    Memo1.Lines.Add('loading MonGen.txt...');
    error := FrmDB.LoadZenLists;
    if error <= 0 then begin
      ShowMessage('MonGen.txt' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('MonGen.txt loaded.');

    // 2003/06/20 �̺�Ʈ�� �� �޼��� ���
    Memo1.Lines.Add('loading GenMsg.txt...');
    error := FrmDB.LoadGenMsgLists;
    if error <= 0 then begin
      ShowMessage('GenMsg.txt' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('GenMsg.txt loaded.');

    Memo1.Lines.Add('loading UnbindList.txt...');
    error := FrmDB.LoadUnbindItemLists;
    if error < 0 then begin
      ShowMessage('UnbindList.txt' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('UnbindList information loaded.');

    Memo1.Lines.Add('loading MapQuest.txt...');
    error := FrmDB.LoadMapQuestInfos;
    if error < 0 then begin
      ShowMessage('MapQuest.txt' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('MapQuest information loaded.');

      Memo1.Lines.Add ('loading StartupQuest.txt...');
      error := FrmDB.LoadStartupQuest;
      if error < 0 then begin
         ShowMessage ('StartupQuest.txt' + ' : Failure was occurred while reading this file. code=' + IntToStr(error));
         close;
         exit;
      end else
         Memo1.Lines.Add ('StartupQuest information loaded..');

    Memo1.Lines.Add('loading QuestDiary\*.txt...');
    error := FrmDB.LoadQuestDiary;
    if error < 0 then begin
      ShowMessage('QuestDiary\*.txt' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('QuestDiary information loaded.');

    if LoadAbusiveList('!Abuse.txt') then
      Memo1.Lines.Add('!Abuse.txt' + ' loaded..');

    if LoadLineNotice(LINENOTICEFILE) then
      Memo1.Lines.Add(LINENOTICEFILE + ' loaded..')
    else
      Memo1.Lines.Add(LINENOTICEFILE + ' loading failure !!!!!!!!!');

    if LoadLineHelp(LINEHELPFILE) then
      Memo1.Lines.Add(LINEHELPFILE + ' loaded..')
    else
      Memo1.Lines.Add(LINEHELPFILE + ' loading failure !!!!!!!!!');

    if FrmDB.LoadAdminFiles > 0 then
      Memo1.Lines.Add('AdminList loaded..')
    else
      Memo1.Lines.Add('AdminList loading failure !!!!!!!!!');
    // 2003/08/28
    FrmDB.LoadChatLogFiles;
    Memo1.Lines.Add('Chatting Log List loaded..');

    GuildMan.LoadGuildList;
    Memo1.Lines.Add('GuildList loaded..');

    GuildAgitMan.LoadGuildAgitList;
    Memo1.Lines.Add('GuildAgitList loaded..');

    //����Խ���
    GuildAgitBoardMan.LoadAllGaBoardList('');
    Memo1.Lines.Add('GuildAgitBoardList loaded..');

    UserCastle.Initialize;  //���������� �̹� �о��� �Ŀ� �ҷ�������
    boUserCastleInitialized := True;
    Memo1.Lines.Add('Castle initialized..');

    if ServerIndex = 0 then begin //0�� ������ �����Ͱ� �ȴ�.
      FrmSrvMsg.Initialize;
    end else begin
      FrmMsgClient.Initialize;
    end;

    // DBSQL ���� ------------------------------------------------------------
    if g_DBSQL.Connect(ServerName, '.\!DBSQL.TXT') then
      Memo1.Lines.Add('DBSQL Connection Success')
    else
      Memo1.Lines.Add('DBSQL Connection Fail [ ERROR!] ');
    //------------------------------------------------------------------------
    //���� ǥ��...
    DateTime := 0;

    if FileExists(Application.ExeName) then begin
      handle := FileOpen(Application.ExeName, fmOpenRead or fmShareDenyNone);
      if handle > 0 then begin
        FileDate := FileGetDate(handle);
        DateTime := FileDateToDateTime(FileDate);
        MainOutMessage('FileDateVersion : ' + DateTimeToStr(DateTime));
        FileClose(handle);
      end;
    end;
    //------------------------------------------------------------------------

    StartServer;

    ServerReady := True;

    Sleep(500);
    ConnectTimer.Enabled := True;

    runstart := GetTickCount;
    rcount   := 0;
    humrotatetime := GetTickCount;
    RunTimer.Enabled := True;


  except
    MainOutMessage('starttimer exception...');
  end;
end;

procedure TFrmMain.Timer1Timer(Sender: TObject);
var
  i, runsec: integer;
  fhandle: TextFile;
  fail:  boolean;
  r:     real;
  ahour, amin, asec: word;
  checkstr, str, sendb: string;
  pgate: PTRunGateInfo;
  down:  integer;
begin
  down := 1;
  try
    csTimerLock.Enter;
    if Memo1.Lines.Count > 500 then
      Memo1.Lines.Clear;
    fail := True;
    if MainMsg.Count > 0 then begin
      try
        if not FileExists(ErrorLogFile) then begin
          AssignFile(fhandle, ErrorLogFile);
          Rewrite(fhandle);
          fail := False;
        end else begin
          AssignFile(fhandle, ErrorLogFile);
          Append(fhandle);
          fail := False;
        end;
      except
        Memo1.Lines.Add('Error on writing ErrorLog.');
      end;
    end;
    for i := 0 to MainMsg.Count - 1 do begin
      Memo1.Lines.Add(MainMsg[i]);
      if not fail then
        WriteLn(fhandle, MainMsg[i]);
    end;
    MainMsg.Clear;
    if not fail then
      CloseFile(fhandle);

    //�÷��̾��� ���� �α׸� UDP������ ���ؼ� �α׼��������� ����
    for i := 0 to UserLogs.Count - 1 do begin
      str := '1'#9 + IntToStr(ServerNumber) + ''#9 + IntToStr(ServerIndex) +
        ''#9 + UserLogs[i];
      IdUDPClient.Send(str);
    end;
    UserLogs.Clear;

    //�÷��̾��� ���� �α׸� �����Ѵ�.
    if UserConLogs.Count > 0 then begin
      try
        WriteConLogs(UserConLogs);
      except
        MainOutMessage('ERROR_CONLOG_FAIL');
      end;
      UserConLogs.Clear;
    end;

    //�÷��̾��� ä�� �α׸� �����Ѵ�.
    if UserChatLog.Count > 0 then begin
      try
        WriteChatLogs(UserChatLog);
      except
        MainOutMessage('ERROR_CHATLOG_FAIL');
      end;
      UserChatLog.Clear;
    end;

  finally
    csTimerLock.Leave;
  end;

  try
    down := 2;

    if ServerIndex = 0 then
      checkstr := '[M]'
    else if FrmMsgClient.MsgClient.Socket.Connected then
      checkstr := '[S]'
    else
      checkstr := '[ ]';

    checkStr := checkStr + IntToStr(gErrorCount);
{$IFDEF DEBUG} //sonmg
   checkstr := checkstr + ' DEBUG';
{$ENDIF}

    down := 3;

    runsec := (GetTickCount - serverruntime) div 1000;
    ahour  := runsec div 3600;
    amin   := (runsec mod 3600) div 60;
    asec   := runsec mod 60;
    LbRunTime.Caption := IntToStr(ahour) + ':' + IntToStr(amin) +
      ':' + IntToStr(asec) + ' ' + checkstr;
    down   := 4;
    LbUserCount.Caption :=
      '(' + //IntToStr(UserEngine.MonRunCount) + '/' +
      IntToStr(UserEngine.MonCount) + ')   ' +
      IntToStr(UserEngine.GetRealUserCount) + '/' +
      IntToStr(UserEngine.GetUserCount) + '/' + IntToStr(UserEngine.FreeUserCount);
    Label1.Caption := 'Run' + IntToStr(curruncount) + '/' +
      IntToStr(minruncount) + ' ' + 'Soc' + IntToStr(cursoctime) +
      '/' + IntToStr(maxsoctime) + ' ' + 'Usr' + IntToStr(curusrcount) +
      '/' + IntToStr(maxusrtime);
    Label2.Caption := 'Hum' + IntToStr(curhumtime) + '/' + IntToStr(maxhumtime) +
      ' ' + 'Mon' + IntToStr(curmontime) + '/' + IntToStr(maxmontime) +
      ' ' + 'UsrRot' + IntToStr(curhumrotatetime) + '/' +
      IntToStr(maxhumrotatetime) + '(' + IntToStr(humrotatecount) + ')';

    Label5.Caption := LatestGenStr + ' - ' + LatestMonStr + '    ';

    down := 5;
    r    := GetTickCount / (1000 * 60 * 60 * 24);
    if r >= 36 then
      LbTimeCount.Font.Color := clRed;
    LbTimeCount.Caption := FloatToString(r) + 'Day';

    down := 6;
    str  := '';
    with RunSocket do begin  //��Ƽ ����Ʈ�� �������� ��� ����ȭ ����
      for i := 0 to MAXGATE - 1 do begin
        pgate := PTRunGateInfo(@GateArr[i]);
        if pgate <> nil then begin
          if pgate.Socket <> nil then begin
            if pgate.sendbytes < 1024 then
              sendb := IntToStr(pgate.sendbytes) + 'b '
            else
              sendb := IntToStr(pgate.sendbytes div 1024) + 'kb ';
            str := str + '[G' + IntToStr(i + 1) + ': ' +
              IntToStr(pgate.curbuffercount) + '/' + IntToStr(pgate.remainbuffercount) +
              ' ' + sendb + IntToStr(pgate.sendsoccount) + '] ';
          end;
        end;
      end;
    end;
    Label3.Caption := str;

    down := 7;
    Inc(minruncount);
    Dec(maxsoctime);
    Dec(maxusrtime);
    Dec(maxhumtime);
    Dec(maxmontime);
    Dec(maxhumrotatetime);

  except
    MainOutMessage('Exception Timer1Timer :' + IntToStr(down));
  end;
end;

procedure TFrmMain.SaveVariableTimerTimer(Sender: TObject);
begin
  SaveItemNumber;
end;

procedure TFrmMain.MakeStoneMines;
var
  i, k, x, y: integer;
  ev:  TStoneMineEvent;
  env: TEnvirnoment;
begin
  for i := 0 to GrobalEnvir.Count - 1 do begin
    env := TEnvirnoment(GrobalEnvir[i]);
    if (env.MineMap > 0) then begin
      for x := 0 to env.MapWidth - 1 do
        for y := 0 to env.MapHeight - 1 do begin
          ev := nil;
          if env.minemap = 1 then
            ev := TStoneMineEvent.Create(env, x, y, ET_MINE)   //�������� ��
          else if env.minemap = 2 then
            ev := TStoneMineEvent.Create(env, x, y, ET_MINE2)  //�������� ��
          else
            ev := TStoneMineEvent.Create(env, x, y, ET_MINE3);  //�������� ��

          // ������ �� �־����ٸ� ����������..
          if (ev <> nil) and ev.IsAddToMap = False then begin
            ev.Free;
            ev := nil;
            // MainOutMessage('STONMIME FREE');
          end else begin
            EventMan.AddDormantEvent (ev);
          end;

        end;
    end;
  end;
end;

procedure TFrmMain.StartServer;
var
  error: integer;
  TotalDecoMonCount: integer;
begin
  try

    FrmIDSoc.Initialize;
    Memo1.Lines.Add('IDSoc Initialized..');

    GrobalEnvir.InitEnvirnoments;
    Memo1.Lines.Add('GrobalEnvir loaded..');

    MakeStoneMines; //������ ä���.
    Memo1.Lines.Add('MakeStoneMines...');

    error := FrmDB.LoadMerchants;
    if error < 0 then begin
      ShowMessage('merchant.txt' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('merchant loaded...');

    //---------------------------------------------
    //����ٹ̱� ������ ����Ʈ �ε�(sonmg)
    //LoadAgitDecoMon���� ���� ����Ǿ�� ��.
    error := FrmDB.LoadDecoItemList;
    if error < 0 then begin
      ShowMessage('DecoItem.txt' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('DecoItemList loaded..');

    //0�� ���������� �о����.
    if ServerIndex = 0 then begin
      //����ٹ̱� ������Ʈ �ε�(sonmg)
      //LoadDecoItemList���� ���߿� ����Ǿ�� ��.
      error := GuildAgitMan.LoadAgitDecoMon;
      if error < 0 then begin
        ShowMessage(GuildBaseDir + AGITDECOMONFILE +
          ' : Failure was occurred while reading this file. code=' + IntToStr(error));
        Close;
        exit;
      end else begin
        //����� �ٹ̱� ������Ʈ�� ������Ų��.
        TotalDecoMonCount := GuildAgitMan.MakeAgitDecoMon;
        //����� �ٹ̱� ������Ʈ ������ �����Ѵ�.
        GuildAgitMan.ArrangeEachAgitDecoMonCount;
        Memo1.Lines.Add('AgitDecoMon ' + IntToStr(TotalDecoMonCount) +
          ' loaded...');
      end;
    end;
    //---------------------------------------------

    if not BoVentureServer then begin  //���輭�������� ����� ����.
      error := FrmDB.LoadGuards;
      if error < 0 then begin
        ShowMessage('Guardlist.txt' +
          ' : Failure was occurred while reading this file. code=' + IntToStr(error));
        Close;
        exit;
      end;
    end;

    error := FrmDB.LoadNpcs;
    if error < 0 then begin
      ShowMessage('Npc.txt' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('Npc loaded..');

    error := FrmDB.LoadMakeItemList;
    if error < 0 then begin
      ShowMessage('MakeItem.txt' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('MakeItem loaded..');

    error := FrmDB.LoadStartPoints;
    if error < 0 then begin
      ShowMessage('StartPoint.txt' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('StartPoints loaded..');

    error := FrmDB.LoadSafePoints;
    if error < 0 then begin
      ShowMessage('SafePoint.txt' +
        ' : Failure was occurred while reading this file. code=' + IntToStr(error));
      Close;
      exit;
    end else
      Memo1.Lines.Add('SafePoints loaded..');

    FrontEngine.Resume;
    Memo1.Lines.Add('F-Engine resumed..');

    UserEngine.Initialize;
    Memo1.Lines.Add('U-Engine initialized..');

    UserMgrEngine.Resume;
    Memo1.Lines.Add('UserMgr-Engine resumed..');

    SQlEngine.Resume;
    Memo1.Lines.Add('SQL-Engine resumed..');

  except
    MainOutMessage('startserver exception..');
  end;
end;

procedure TFrmMain.ConnectTimerTimer(Sender: TObject);
begin
  if not DBSocket.Active then begin
    DBSocket.Active := True;
  end;
end;


{--------------- Gate�� ����Ÿ�� ó���� --------------}

procedure TFrmMain.RunTimerTimer(Sender: TObject);
begin
  if ServerReady then begin
    RunSocket.Run;

    FrmIDSoc.DecodeSocStr;

    UserEngine.ExecuteRun;

    //��Ź����
    SqlEngine.ExecuteRun;

    EventMan.Run;

    if ServerIndex = 0 then begin //0�� ������ �����Ͱ� �ȴ�.
      FrmSrvMsg.Run;
    end else begin
      FrmMsgClient.Run;
    end;
  end;

  Inc(rcount);
  if GetTickCount - runstart > 250 then begin
    runstart    := GetTickCount;
    curruncount := rcount;
    if minruncount > curruncount then
      minruncount := curruncount;
    rcount := 0;
  end;
end;

{------------- Gate Socket ���� �Լ� ----------------}

procedure TFrmMain.GateSocketClientConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  RunSocket.Connect(Socket);
end;

procedure TFrmMain.GateSocketClientDisconnect(Sender: TObject;
  Socket: TCustomWinSocket);
begin
  RunSocket.Disconnect(Socket);
end;

procedure TFrmMain.GateSocketClientError(Sender: TObject;
  Socket: TCustomWinSocket; ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin
  RunSocket.SocketError(Socket, ErrorCode);
end;

procedure TFrmMain.GateSocketClientRead(Sender: TObject; Socket: TCustomWinSocket);
begin
  RunSocket.SocketRead(Socket);
end;

{------------- DB Socket ���� �Լ� ----------------}

function DBConnected: boolean;
begin
  if FrmMain.DBSocket.Active then
    Result := FrmMain.DBSocket.Socket.Connected
  else
    Result := False;
end;

procedure TFrmMain.DBSocketConnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  ;
end;

procedure TFrmMain.DBSocketDisconnect(Sender: TObject; Socket: TCustomWinSocket);
begin
  ;
end;

procedure TFrmMain.DBSocketError(Sender: TObject; Socket: TCustomWinSocket;
  ErrorEvent: TErrorEvent; var ErrorCode: integer);
begin
  ErrorCode := 0;
  Socket.Close;
end;

procedure TFrmMain.DBSocketRead(Sender: TObject; Socket: TCustomWinSocket);
var
  Data: AnsiString;
begin
  csSocLock.Enter;
  try
    SetLength(Data, Socket.ReceiveLength);
    SetLength(Data, Socket.ReceiveBuf(Pointer(Data)^, Length(Data)));
    //Data := Socket.ReceiveText;
    RDBSocData := RDBSocData + Data;
    if not ReadyDBReceive then
      RDBSocData := '';

  finally
    csSocLock.Leave;
  end;

  // DB �������� �����͸� �ִ´�. PDS...
  UserMgrEngine.OnDBRead(Data);


  //   if ReadyDBReceive then MainOutMessage ('DB-> ' + IntToStr(Length(data)) + ' OK')
  //   else MainOutMessage ('DB-> ' + IntToStr(Length(data)) + ' Miss');
end;

procedure TFrmMain.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  if not ServerClosing then begin
    CanClose := False;
    if MessageDlg('exit server ? (yes=exit)', mtConfirmation,
      [mbYes, mbNo, mbCancel], 0) = mrYes then begin
      ServerClosing := True;
      TCloseTimer.Enabled := True;
      RunSocket.CloseAllGate;
    end;
  end;
end;

procedure TFrmMain.TCloseTimerTimer(Sender: TObject);
begin
  if (UserEngine.GetRealUserCount = 0) and (FrontEngine.IsFinished) then begin
    TCloseTimer.Enabled := False;
    Close;
  end;
end;

procedure TFrmMain.Panel1DblClick(Sender: TObject);
var
  ini: TIniFile;
  fname, bostr: string;
begin
  if FrmServerValue.Execute then begin
    fname := '.\!setup.txt';
    ini   := TIniFile.Create(fname);
    if ini <> nil then begin
      ini.WriteInteger('Server', 'HumLimit', HumLimitTime);
      ini.WriteInteger('Server', 'MonLimit', MonLimitTime);
      ini.WriteInteger('Server', 'ZenLimit', ZenLimitTime);
      ini.WriteInteger('Server', 'SocLimit', SocLimitTime);
      ini.WriteInteger('Server', 'DecLimit', DecLimitTime);
      ini.WriteInteger('Server', 'NpcLimit', NpcLimitTime);

      ini.WriteInteger('Server', 'SendBlock', SENDBLOCK);
      ini.WriteInteger('Server', 'CheckBlock', SENDCHECKBLOCK);
      ini.WriteInteger('Server', 'GateLoad', GATELOAD);

      if BoViewHackCode then
        bostr := 'TRUE'
      else
        bostr := 'FALSE';
      ini.WriteString('Server', 'ViewHackMessage', bostr);

      if BoViewAdmissionFail then
        bostr := 'TRUE'
      else
        bostr := 'FALSE';
      ini.WriteString('Server', 'ViewAdmissionFailure', bostr);

    end;
  end;
end;

procedure TFrmMain.Exit1Click(Sender: TObject);
begin
  Close;
end;

procedure TFrmMain.Initialize1Click(Sender: TObject);
var
  ini:   TIniFile;
  fname: string;
begin
  FrmIDSoc.Timer1Timer(self);

  with FrmMsgClient do begin
    if ServerIndex <> 0 then
      if not MsgClient.Socket.Connected then begin
        MsgClient.Active := True;
      end;
  end;

  fname := '.\!setup.txt';
  if FileExists(fname) then begin
    ini := TIniFile.Create(fname);
    if ini <> nil then begin
      LogServerAddress := ini.ReadString('Server', 'LogServerAddr', '192.168.0.152');
      LogServerPort    := ini.ReadInteger('Server', 'LogServerPort', 10000);

      ClientFileName1 := ini.ReadString('Setup', 'ClientFile1', '');
      ClientFileName2 := ini.ReadString('Setup', 'ClientFile2', '');
      ClientFileName3 := ini.ReadString('Setup', 'ClientFile3', '');
    end;
    ini.Free;
  end;
  IdUDPClient.Active    := False;
  IdUDPClient.Host      := LogServerAddress;
  IdUDPClient.Port      := LogServerPort;
  IdUDPClient.Active    := True;

  LoadMultiServerTables;

  FrmIDSoc.LoadShareIPList;

  LoadClientFileCheckSum;
end;

procedure TFrmMain.AdminList1Click(Sender: TObject);
begin
  FrmDB.LoadAdminFiles;
end;

procedure TFrmMain.ChatLogList1Click(Sender: TObject);
begin
  FrmDB.LoadChatLogFiles;
end;

end.

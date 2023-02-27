program GameSvr;

uses
  Forms,
  svMain in 'svMain.pas' {FrmMain},
  RunSock in 'RunSock.pas',
  FrnEngn in 'FrnEngn.pas',
  UsrEngn in 'UsrEngn.pas',
  ObjBase in 'ObjBase.pas',
  Envir in 'Envir.pas',
  M2Share in 'M2Share.pas',
  ObjMon in 'ObjMon.pas',
  RunDB in 'RunDB.pas',
  MfdbDef in 'MfdbDef.pas',
  LocalDB in 'LocalDB.pas' {FrmDB},
  IdSrvClient in 'IdSrvClient.pas' {FrmIDSoc},
  ObjNpc in 'ObjNpc.pas',
  MudUtil in 'MudUtil.pas',
  itmunit in 'itmunit.pas',
  Magic in 'Magic.pas',
  NoticeM in 'NoticeM.pas',
  ObjGuard in 'ObjGuard.pas',
  ObjMon2 in 'ObjMon2.pas',
  ObjAxeMon in 'ObjAxeMon.pas',
  Guild in 'Guild.pas',
  Mission in 'Mission.pas',
  Event in 'Event.pas',
  FSrvValue in 'FSrvValue.pas' {FrmServerValue},
  InterServerMsg in 'InterServerMsg.pas' {FrmSrvMsg},
  InterMsgClient in 'InterMsgClient.pas' {FrmMsgClient},
  Castle in 'Castle.pas',
  SQLLocalDB in 'SQLLocalDB.pas',
  ObjMon3 in 'ObjMon3.pas',
  DragonSystem in 'DragonSystem.pas',
  DBSQL in 'DBSQL.pas',
  CmdMgr in 'CmdMgr.pas',
  FriendSystem in 'FriendSystem.pas',
  MaketSystem in 'MaketSystem.pas',
  SqlEngn in 'SqlEngn.pas',
  TagSystem in 'TagSystem.pas',
  UserMgr in 'UserMgr.pas',
  UserMgrEngn in 'UserMgrEngn.pas',
  UserSystem in 'UserSystem.pas',
  Relationship in 'Relationship.pas',
  EDCode in '..\_Def\EDCode.pas',
  Grobal2 in '..\_Def\Grobal2.pas',
  HUtil32 in '..\_Def\HUtil32.pas',
  GLists in '..\_Def\GLists.pas';

{$R *.RES}

begin
  //ReportMemoryLeaksOnShutdown := DebugHook <> 0;

  Application.Initialize;
  Application.Title := 'GameSvr';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmDB, FrmDB);
  Application.CreateForm(TFrmIDSoc, FrmIDSoc);
  Application.CreateForm(TFrmServerValue, FrmServerValue);
  Application.CreateForm(TFrmSrvMsg, FrmSrvMsg);
  Application.CreateForm(TFrmMsgClient, FrmMsgClient);
  Application.Run;
end.

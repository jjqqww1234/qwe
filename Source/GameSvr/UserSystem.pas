unit UserSystem;

interface

uses
  Classes, SysUtils, CmdMgr, {ElHashList ,} grobal2, HUtil32;

type
  // TUserInfo Class Declarations --------------------------------------------
  TUserInfo = class(ICommand)
  private
    FUserName: string;         // ����� �̸�
    FConnState: integer;       // ���ӻ���
    FGateIdx: integer;         // ���Ӽ����� ���ӵ� ����Ʈ ��ȣ
    FUserGateIdx: integer;     // ���Ӽ����� ���ӵ� ����Ʈ ��ȣ
    FUserHandle: integer;      // ���� �ڵ�
    FRecog:   integer;         // Hum �޸��� �ּ�
    FMapInfo: string;          // ������ ���� �� ����
  public
    constructor Create; override;
    destructor Destroy; override;

    procedure OnUserOpen;
    procedure OnUserClose;
    // ��ɾ� ��ġ
    procedure OnCmdChange(var Cmd: TCmdMsg); override;

    // ��ɾ� ���� ����
    procedure OnCmdISMFriendOpen(Cmd: TCmdMsg);
    procedure OnCmdISMFriendClose(Cmd: TCmdMsg);
    procedure OnCmdISMUserInfo(Cmd: TCmdMsg);


    // ���� ����Լ� ���� ������Ƽ
    property UserName: string Read FUserName Write FUserName;
    property ConnState: integer Read FConnState Write FConnState;
    property GateIdx: integer Read FGateIdx Write FGateIdx;
    property UserGateIdx: integer Read FUserGateIdx Write FUserGateIdx;
    property UserHandle: integer Read FUserHandle Write FUserHandle;
    property Recog: integer Read FRecog Write FRecog;
    property MapInfo: string Read FMapInfo Write FMapInfo;

  end;

  PTUserInfo = ^TUserInfo;

implementation

uses
  UserMgr, svMain;

// TUserInfo =================================================================
constructor TUserInfo.Create;
begin
  inherited;
  //TO DO Initialize
  FUserName   := '';
  FConnState  := CONNSTATE_UNKNOWN;
  FGateIdx    := 0;
  FUserHandle := 0;
  FRecog      := 0;
  FMapInfo    := '';
end;

destructor TUserInfo.Destroy;
begin
  // TO DO Free Mem

  inherited;
end;

 //------------------------------------------------------------------------------
 // �ý����� �����ϰ� �����.
 //------------------------------------------------------------------------------
procedure TUserInfo.OnUserOpen;
begin

end;

 //------------------------------------------------------------------------------
 // �ý�����  �Ұ����ϰ� �����.
 //------------------------------------------------------------------------------
procedure TUserInfo.OnUserClose;
begin

end;
 //------------------------------------------------------------------------------
 // ��ɾ� �̺�Ʈ ó��
 //------------------------------------------------------------------------------
procedure TUserInfo.OnCmdChange(var Cmd: TCmdMsg);
begin

  case Cmd.CmdNum of
    ISM_FRIEND_OPEN: OnCmdISMFriendOpen(Cmd);
    ISM_FRIEND_CLOSE: OnCmdISMFriendClose(Cmd);
    ISM_USER_INFO: OnCmdISMUserInfo(Cmd);
  end;

end;

 //------------------------------------------------------------------------------
 // ģ���ý��� ����
 //------------------------------------------------------------------------------
procedure TUserInfo.OnCmdISMFriendOpen(Cmd: TCmdMsg);
begin

end;

 //------------------------------------------------------------------------------
 // ģ�� �ý��� ����
 //------------------------------------------------------------------------------
procedure TUserInfo.OnCmdISMFriendClose(Cmd: TCmdMsg);
begin

end;

 //------------------------------------------------------------------------------
 // ģ�� �ý��۵�� ������ ���������� Ŭ���̾�Ʈ�� �����Ѵ�.
 //------------------------------------------------------------------------------
procedure TUserInfo.OnCmdISMUserInfo(Cmd: TCmdMsg);
var
  UserName: string;
  ConnState: string;
  MapInfo: string;
  Str: string;

  UserInfo: TUserInfo;
begin

  // ���¸޼��� �и�
  Str := GetValidStr3(Cmd.body, UserName, ['/']);
  Str := GetValidStr3(Str, ConnState, ['/']);
  Str := GetValidStr3(Str, MapInfo, ['/']);

  // ������ �޼����� �����Ѵ�.
  UserInfo := Cmd.pInfo;
  Str      := UserName + '/' + MapInfo;

  // Ŭ���̾�Ʈ�� �޼��� ���� 2003-070-01 : ������ ������ ������ ������.

  UserMgrEngine.InterSendMsg(stClient, 0, UserInfo.GateIdx,
    UserInfo.UserGateIdx, UserInfo.UserHandle,
    UserInfo.UserName, UserInfo.Recog, SM_USER_INFO,
    {Str_ToInt(ConnState,0)} 0, 0, 0, Str);

end;



end.

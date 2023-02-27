unit FriendSystem;

interface

uses
  Classes, SysUtils, CmdMgr, {ElHashList ,} grobal2, UserSystem, HUtil32;

type

  // TFriendInfo Class Declarations ------------------------------------------
  TFriendInfo = class(ICommand)
  private
    FOwnner:   string;      // ������ �̸�
    FName:     string;      // ����� �̸�
    FRegState: integer;     // ��ϻ���
    FDesc:     string;      // ������ ����

    //        FIsSendAble  : Boolean;     // ������ ���۰����ϰ� �Ǵ�.

  public
    constructor Create; override;
    destructor Destroy; override;

    // ��ɾ� ��ġ
    //       procedure   OnCmdChange( var Msg : TCmdMsg ) ; override;

    // ���� ������ٿ� ������Ƽ
    property Name: string Read FName Write FName;
    property Ownner: string Read FOwnner Write FOwnner;
    property RegState: integer Read FRegState Write FRegState;
    property Desc: string Read FDesc Write FDesc;


  end;

  PTFriendInfo = ^TFriendInfo;

  // TFreiendMgr Class Declarations ------------------------------------------
  TFriendMgr = class(ICommand)
  private
    FItems: TList;
    //TElHashList;      // ģ�������� �������ִ� �ؽ����̺�
    FIsListSendAble: boolean;          // ����Ʈ�� ���۰����ϰ� ����
    FWantListFlag: boolean;
    // ����Ʈ�� ���۰����ϱ����� Ŭ���̾�Ʈ�� ��û��

    // ���� ���� ..............................
    procedure RemoveAll;

  public
    constructor Create; override;
    destructor Destroy; override;

    procedure OnUserOpen;
    procedure OnUserClose;

    // ã��
    function Find(UserName_: string): TFriendInfo;
    // ģ���߰� ...............................
    function Add(UserInfo: TUserInfo; Friend: string; RegState: integer;
      Desc: string): boolean;
    // ģ�� ���� ..............................
    function Delete(UserInfo: TUserInfo; Friend: string): boolean;
    // ���� ���� ..............................
    function SetDesc(UserInfo: TUserInfo; Friend: string; Desc: string): boolean;
    // ģ�� ã�� .............................
    function IsFriend(Name: string): boolean;

    //----------------------------------------------------------------------
    procedure OnCmdChange(var Msg: TCmdMsg); override;

    //----------------------------------------------------------------------
    // ���������� �޼��� ���� �ռ���
    procedure OnMsgInfoToClient(UserInfo: TUserInfo; FriendName: string;
      ConnState: integer; RegState: integer; Desc: string);
    procedure OnMsgInfoToServer(UserInfo: TUserInfo; FriendName: string;
      RegState: integer; Desc: string);


    // �������ݰ� ���õ� �Լ���.............................................
    procedure OnSendListToClient(UserInfo: TUserInfo);
    procedure OnSendInfoToClient(UserInfo: TUserInfo; Friend: string);
    //        procedure OnSendInfoToOthers( UserInfo : TUserInfo ; LinkedFriend : String );

    // Client �κ��� ���� ��ɾ�� .........................................
    procedure OnCmdCMList(Cmd: TCmdMsg);
    procedure OnCmdCMAdd(Cmd: TCmdMsg);
    procedure OnCmdCMDelete(Cmd: TCmdMsg);
    procedure OnCmdCMEdit(Cmd: TCmdMsg);

    // Client �� ������ ��ɾ��............................................
    procedure OnCmdSMInfo(UserInfo: TUserInfo; FriendName: string;
      RegState: word; Conn: word; Desc: string);

    procedure OnCmdSMDelete(UserInfo: TUserInfo; FriendName: string);

    procedure OnCmdSMResult(UserInfo: TUserInfo; CmdNum: word; Value: word);

    // ���������� ������ ��ɾ�� ........................................
    procedure OnCmdISMInfo(Cmd: TCmdMsg);
    procedure OnCmdISMDelete(Cmd: TCmdMsg);
    procedure OnCmdISMResult(Cmd: TCmdMsg);

    // ���������� ������ ��ɾ��...........................................
    procedure OnCmdOSMInfo(UserName: string; SvrIndex: integer;
      FriendName: string; RegState: integer;  // ��ϻ���
      Conn: integer;      // ���ӻ���
      Desc: string        // ����
      );
    procedure OnCmdOSMDelete(UserName: string; SvrIndex: integer;
      FriendName: string    // ������ ģ����
      );
    procedure OnCmdOSMResult(UserName: string; SvrIndex: integer;
      CmdNum: word;          // ��ɾ��ȣ
      ResultValue: word      // �����
      );

    //DB �� ������ ��ɾ�� ................................................
    procedure OnCmdDBList(UserInfo: TUserInfo);
    procedure OnCmdDBAdd(UserInfo: TUserInfo; Friend: string;
      RegState: word; Desc: string);
    procedure OnCmdDBDelete(UserInfo: TUserInfo; Friend: string);
    procedure OnCmdDBEdit(UserInfo: TUserInfo; Friend: string; Desc: string);

    //DB �κ��� ���� ��ɾ�� ..............................................
    procedure OnCmdDBRList(Cmd: TCmdMsg);
    procedure OnCmdDBRResult(Cmd: TCmdMsg);


  end;

  PTFriendMgr = ^TFriendMgr;

implementation

uses
  UserMgr, svMain;
// TFriendInfo =================================================================
constructor TFriendInfo.Create;
begin
  inherited;
  //TO DO Initialize

end;

destructor TFriendInfo.Destroy;
begin
  // TO DO Free Mem

  inherited;
end;

{
procedure TFriendInfo.OnCmdChange( var Msg : TCmdMsg );
begin
    // TO DO : �̺�Ʈ ó��
end;
}

// TFreiendMgr =================================================================
constructor TFriendMgr.Create;
begin
  inherited;
  //TO DO Initialize
  FItems := TList.Create;     //TElHashList.Create;


  FIsListSendAble := False;   //  Ŭ���̾�Ʈ�� ��������Ʈ ���� ���ɿ���
  FWantListFlag   := False;   //  Ŭ���̾�Ʈ���� ����Ʈ ���� ��û

end;

destructor TFriendMgr.Destroy;
begin
  RemoveAll;

  FItems.Free;
  inherited;
end;
 //------------------------------------------------------------------------------
 // �ý����� �����ϰ� �Ѵ�.
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnUserOpen;
begin

end;

 //------------------------------------------------------------------------------
 // �ý����� �Ұ����ϰ� �Ѵ�.
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnUserClose;
begin

end;

function TFriendMgr.Find(UserName_: string): TFriendInfo;
var
  Item: TFriendInfo;
  i:    integer;
begin
  Result := nil;
  for i := 0 to FItems.Count - 1 do begin
    Item := TFriendInfo(FItems.Items[i]);
    if Item.FName = UserName_ then begin
      Result := Item;
      exit;
    end;
  end;
end;

 //------------------------------------------------------------------------------
 // ģ�� �޴����� ģ������ �߰�
 //------------------------------------------------------------------------------
function TFriendMgr.Add(UserInfo: TUserInfo; Friend: string;
  RegState: integer; Desc: string): boolean;
var
  Info: TFriendInfo;
begin

  Result := False;

  if (Friend <> '') and (not IsFriend(Friend)) then begin

    Info := TFriendInfo.Create;

    if (Info <> nil) then begin
      Info.Name     := Friend;
      Info.Ownner   := UserInfo.UserName;
      Info.RegState := RegState;
      Info.Desc     := Desc;

      FItems.Add(Info); //FItems.Add ( Friend , Info );

      Result := True;
    end else
      ErrMsg('Nil Pointer When Create -[TFriendMgr.Add]');

  end else
    ErrMsg('Empty "Friend" -[TFriendMgr.Add]');
end;

 //------------------------------------------------------------------------------
 // ģ�� �޴������� ģ������ ����
 //------------------------------------------------------------------------------
function TFriendMgr.Delete(UserInfo: TUserInfo; Friend: string): boolean;
var
  Item: TFriendInfo;
  i:    integer;
begin
  Result := False;

  Item := Find(Friend);   //FItems.Item[ Friend ];
  if Item <> nil then begin
    i := FItems.IndexOf(Item);
    if i >= 0 then begin
      FItems.Delete(i); //FItems.Delete( Friend );
      Item.Free;
      Result := True;
    end;
  end;
end;

 //------------------------------------------------------------------------------
 // ģ���� ������ �����Ѵ�.
 //------------------------------------------------------------------------------
function TFriendMgr.SetDesc(UserInfo: TUserInfo; Friend: string; Desc: string): boolean;
var
  Item: TFriendInfo;
begin
  Result := False;

  Item := Find(Friend);   //FItems.Item[ Friend ];
  if Item <> nil then begin
    Item.FDesc := Desc;
    Result     := True;
  end;
end;

 //------------------------------------------------------------------------------
 // ģ���� ��ϵ� ������ �˾ƺ��� 
 //------------------------------------------------------------------------------
function TFriendMgr.IsFriend(Name: string): boolean;
var
  Item: TFriendInfo;
begin
  Result := False;
  Item   := Find(Name);
  if Item <> nil then
    Result := True;
  //  if FItems.Item[ Name ] <> nil then Result := TRUE;

end;
 //------------------------------------------------------------------------------
 // ��ϵ� ��� ģ�������� �����Ѵ�.
 //------------------------------------------------------------------------------
procedure TFriendMgr.RemoveAll;
var
  i:    integer;
  Item: TFriendInfo;
begin
  // TO DO Free Mem
  for i := 0 to FItems.Count - 1 do begin

    Item := FItems.Items[i];

    if (Item <> nil) then begin
      Item.Free;
    end;

  end;

  FItems.Clear;

end;

 //------------------------------------------------------------------------------
 // ģ�������� Ŭ���̾�Ʈ�� ����
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnMsgInfoToClient(UserInfo: TUserInfo; FriendName: string;
  ConnState: integer; RegState: integer; Desc: string);
var
  str: string;
begin
  str := FriendName + '/' + Desc;

  UserMgrEngine.InterSendMsg(
    stClient, 0, UserInfo.GateIdx, UserInfo.UserGateIdx, UserInfo.UserHandle,
    UserInfo.UserName, UserInfo.Recog, SM_FRIEND_INFO,
    RegState, ConnState, 0, str);
end;

 //------------------------------------------------------------------------------
 // ģ�������� �ٸ� ���Ӽ����� ����
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnMsgInfoToServer(UserInfo: TUserInfo; FriendName: string;
  RegState: integer; Desc: string);
var
  str: string;
begin
  str := IntToStr(RegState) + ':' + FriendName + ':' + Desc;

  UserMgrEngine.InterSendMsg(
    stClient, 0, 0,
    0, 0, UserInfo.UserName, UserInfo.Recog,
    ISM_FRIEND_INFO, 0, 0, 0, str);

end;


 //------------------------------------------------------------------------------
 // ����Ʈ�� Ŭ���̾�Ʈ�� ����
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnSendInfoToClient(UserInfo: TUserInfo; Friend: string);
var
  i:    integer;
  friendinfo: TUserInfo;
  Item: TFriendInfo;
begin
  Item := Find(Friend);  // FItems.Item[Friend];

  if Item <> nil then begin
        { // 2003 -07-01 ��δ� ���� ���ѻ������ �˷��ش� (����)
        // ģ���� ������ ����ΰ� ������ �˾ƺ���
        if UserMgrEngine.InterGetUserInfo( Item.Name , friendinfo) then
        begin
            // ������ ����̸� ���������� �˷��ְ�
            OnMsgInfoToClient(  UserInfo,
                                Item.Name,
                                friendinfo.ConnState,
                                Item.RegState,
                                Item.Desc );
        end
        else
        }
    begin
      // �������� ����̸� ������������ �˷��ش�.
      OnMsgInfoToClient(UserInfo,
        Item.Name,
        CONNSTATE_DISCONNECT,
        Item.RegState,
        Item.Desc);
    end;// if g_UserMgr...

  end;// if Item <> nil...

end;
 //------------------------------------------------------------------------------
 // ����Ʈ�� Ŭ���̾�Ʈ�� ����
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnSendListToClient(UserInfo: TUserInfo);
var
  i:    integer;
  friendinfo: TUserInfo;
  Item: TFriendInfo;
begin
  // ������ ������ ��� ģ������Ʈ�� �����Ѵ�.
  for i := 0 to FItems.Count - 1 do begin

    Item := FItems.Items[i];    // FItems.GetByIndex( i );

    //������ ������� �˾ƺ���.
        {  2003-07-01 ������ ���� ���� (����)
        if UserMgrEngine.InterGetUserInfo( Item.Name , friendinfo) then
        begin
            // ������ ����̸� ���������� �˷��ְ�
            OnMsgInfoToClient(  UserInfo,
                                Item.Name,
                                friendinfo.ConnState,
                                Item.RegState,
                                Item.Desc );
        end
        else
        }
    begin
      // �������� ����̸� ������������ �˷��ش�.
      OnMsgInfoToClient(UserInfo,
        Item.Name,
        CONNSTATE_DISCONNECT,
        Item.RegState,
        Item.Desc);
    end;

  end;// for i :=0 ...

end;
 //------------------------------------------------------------------------------
 // ģ�� ��ɾ� ó�� ��ƾ Override ��
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdChange(var Msg: TCmdMsg);
begin
  case Msg.CmdNum of
    CM_FRIEND_ADD: OnCmdCMAdd(Msg);
    CM_FRIEND_DELETE: OnCmdCMDelete(Msg);
    CM_FRIEND_EDIT: OnCmdCMEdit(Msg);
    CM_FRIEND_LIST: OnCmdCMList(Msg);
    ISM_FRIEND_INFO: OnCmdISMInfo(Msg);
    ISM_FRIEND_DELETE: OnCmdISMDelete(Msg);
    ISM_FRIEND_RESULT: OnCmdISMResult(Msg);
    DBR_FRIEND_LIST: OnCmdDBRList(Msg);
    //    DBR_FRIEND_WONLIST  : OnCmdDBROwnList( Msg );
    DBR_FRIEND_RESULT: OnCmdDBRResult(Msg);
  end;

end;

 //==============================================================================
 // Ŭ���̾�Ʈ�κ��� ���� ��ɾ��
 //==============================================================================
 //------------------------------------------------------------------------------
 // CM_FRIEND_LIST  : �������� ����Ʈ�� �����ش޶�� ��û
 // Params   : ����
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdCMList(Cmd: TCmdMsg);
begin
  // ����Ʈ�� �����ش޶�� ��û�÷��� ����
  FWantListFlag := True;

  // ����Ʈ ���� �غ� �Ǿ��ִٸ�
  if (FIsListSendAble) then begin
    // ����Ʈ ����
    OnSendListToClient(Cmd.pInfo);
  end;
end;

 //------------------------------------------------------------------------------
 // CM_FRIEND_ADD  : ģ���߰�
 // Params  : �ɸ��� , ��ϻ��� ( ģ�� , ���� , ���� , �ǿ� )
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdCMAdd(Cmd: TCmdMsg);
var
  friend:    string;
  owner:     string;
  regstate:  integer;
  userinfo:  TUserInfo;
  forceflag: integer;
begin
  // ��Ŷ��ȯ
  owner     := Cmd.UserName;
  friend    := Cmd.body;
  regstate  := Cmd.Msg.Param;
  forceflag := Cmd.Msg.Tag;

{$IFDEF DEBUG}
    ErrMsg ('Cmd_CM_Add'+ Owner + '/' + Friend + '/' + IntToStr(regState) );
{$ENDIF}
  if UserMgrEngine.InterGetUserInfo(friend, userinfo) then begin

    // �߰��� �ߵǴ��� �׽�Ʈ ... ���߿� DB ��ɾ �����Ͽ� �ٲ�ߵ�
    if Add(Cmd.pInfo, friend, regstate, '') then begin
      // ������ ���̽��� ��ɾ� ����
      OnCmdDBAdd(Cmd.pInfo, Friend, regstate, '');
      OnMsgInfoToClient(Cmd.pInfo, friend, {userinfo.ConnState} 0,
        regstate, '');
    end;

  end else begin
    //��ڿ� ���� ���� �Է��� ���
    if forceflag = 1 then begin
      if Add(Cmd.pInfo, friend, regstate, '') then begin
        // ��񿡴� �������� �ʰ� Ŭ���̾�Ʈ�� �˷��ش�.
        OnMsgInfoToClient(Cmd.pInfo, friend, CONNSTATE_DISCONNECT,
          regstate, '');
      end;
    end;

  end;

end;

 //------------------------------------------------------------------------------
 // CM_FRIEND_DELETEADD  : ģ������
 // Params  : ������ �ɸ���
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdCMDelete(Cmd: TCmdMsg);
var
  Owner:  string;
  Friend: string;
begin
  Owner  := Cmd.UserName;
  Friend := Cmd.body;

{$IFDEF DEBUG}
    ErrMsg ('Cmd_CM_Delete'+ Owner + '/' + Friend );
{$ENDIF}

  if True = Delete(Cmd.pInfo, Friend) then begin
    OnCmdSMDelete(Cmd.pInfo, Friend);
    OnCmdDBDelete(Cmd.pInfo, Friend);
  end else begin
    OnCmdSMResult(Cmd.pInfo, Cmd.CmdNum, CR_DONTDELETE);
  end;

end;

 //------------------------------------------------------------------------------
 // CM_FRIEND_EDIT  : ģ����������
 // Params  : ������ �ɸ��� , ��������
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdCMEdit(Cmd: TCmdMsg);
var
  Owner:  string;
  Friend: string;
  Desc:   string;
begin
  Owner := Cmd.UserName;
  Desc  := GetValidStr3(Cmd.body, Friend, ['/']);

{$IFDEF DEBUG}
    ErrMsg ('Cmd_CM_SerDesc'+ Friend + '/' + Desc );
{$ENDIF}

  if (True = SetDesc(Cmd.pInfo, Friend, Desc)) then begin
    OnSendInfoToClient(Cmd.pInfo, Friend);
    OnCmdDBEdit(Cmd.pInfo, Friend, Desc);
  end;

end;

 ////////////////////////////////////////////////////////////////////////////////
 // Client �� ������ ��ɾ��
 ////////////////////////////////////////////////////////////////////////////////
 //------------------------------------------------------------------------------
 // SM_FRIEND_INFO  : ģ����������
 // Params  : ģ���ɸ��� , ��ϻ��� , ���ӻ��� , ���ܼ���
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdSMInfo(UserInfo: TUserInfo; FriendName: string;
  RegState: word; Conn: word; Desc: string);
var
  str: string;
begin
  str := Desc;

  UserMgrEngine.InterSendMsg(stClient,
    0,
    UserInfo.GateIdx,
    UserInfo.UserGateIdx,
    UserInfo.UserHandle,
    UserInfo.UserName,
    UserInfo.Recog,
    SM_FRIEND_INFO,
    RegState,
    Conn,
    0,
    str);
end;

 //------------------------------------------------------------------------------
 // SM_FRIEND_DELETE  : ģ������ ��û
 // Params  : ģ���ɸ���
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdSMDelete(UserInfo: TUserInfo; FriendName: string);
var
  str: string;
begin
  str := FriendName;

  UserMgrEngine.InterSendMsg(stClient, 0,
    UserInfo.GateIdx, UserInfo.UserGateIdx,
    UserInfo.UserHandle,
    UserInfo.UserName, UserInfo.Recog,
    SM_FRIEND_DELETE, 0, 0, 0, str);

end;

 //------------------------------------------------------------------------------
 // SM_FRIEND_RESULT  : Ŭ���̾�Ʈ ��û�� ���� �����
 // Params  : ���۹��� Ŭ���̾�Ʈ �������� ��ȣ  , ���ϰ�
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdSMResult(UserInfo: TUserInfo; CmdNum: word; Value: word);
begin
  UserMgrEngine.InterSendMsg(stClient, 0,
    UserInfo.GateIdx, UserInfo.UserGateIdx, UserInfo.UserHandle,
    UserInfo.UserName, UserInfo.Recog,
    SM_FRIEND_RESULT, CmdNum, Value, 0, '');

end;

 ////////////////////////////////////////////////////////////////////////////////
 // �������� ������ ��ɾ��
 ////////////////////////////////////////////////////////////////////////////////
 //------------------------------------------------------------------------------
 // ISM_FRIEND_INFO  : ������ ģ���߰� ���� ���۹���
 // Params  : ģ���� , ��ϻ��� , ���ܼ���
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdISMInfo(Cmd: TCmdMsg);
var
  Friend:   string;
  RegState: string;
  Desc:     string;
  TempStr:  string;
begin
  TempStr := GetValidStr3(Cmd.body, RegState, [':']);
  Desc    := GetValidStr3(TempStr, Friend, [':']);
  // �߰�
  if not Add(Cmd.pInfo, Friend, Str_ToInt(RegState, 0), Desc) then begin
    ErrMsg('OnCmdISMInfo Dont Add Friend :' + Cmd.Body);
  end;

end;

 //------------------------------------------------------------------------------
 // ISM_FRIEND_DELETE  : ������ ģ������
 // Params  : ģ����
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdISMDelete(Cmd: TCmdMsg);
var
  Friend:  string;
  TempStr: string;
begin
  Friend := Cmd.Body;

  // ����
  if not Delete(Cmd.pInfo, Friend) then begin
    ErrMsg('OnCmdISMInfo Dont Delete Friend :' + Cmd.Body);
  end;

end;

 //------------------------------------------------------------------------------
 // ISM_FRIEND_RESULT  : ������ ��ɾ� �������
 // Params  : ģ����
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdISMResult(Cmd: TCmdMsg);
begin
  // TO TEST : �������� ����� �ۼ��Ѵ�.
  ErrMsg('OnCmdISMRsult :' + Cmd.Body);
end;

 ////////////////////////////////////////////////////////////////////////////////
 // �������� ������ ��ɾ��
 ////////////////////////////////////////////////////////////////////////////////
 //------------------------------------------------------------------------------
 // ISM_FRIEND_INFO  : ������ ģ����� ������
 // Params  : ģ���� , ��ϻ��� , ���ܼ���
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdOSMInfo(UserName: string; SvrIndex: integer;
  FriendName: string; RegState: integer; Conn: integer; Desc: string);
var
  str: string;
begin
  // ��Ŷ����
  str := IntToStr(RegState) + ':' + IntToStr(Conn) + ':' + FriendName;
  // ��Ŷ����
  UserMgrEngine.InterSendMsg(stOtherServer, 0, 0, 0, 0,
    UserName, 0, ISM_FRIEND_INFO,
    SvrIndex, 0, 0, str);
end;

 //------------------------------------------------------------------------------
 // ISM_FRIEND_DELETE  : ������ ģ������ ������
 // Params  : ģ����
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdOSMDelete(UserName: string; SvrIndex: integer;
  FriendName: string);
var
  str: string;
begin
  str := FriendName;

  UserMgrEngine.InterSendMsg(stOtherServer, 0, 0, 0, 0,
    UserName, 0, ISM_FRIEND_DELETE,
    SvrIndex, 0, 0, str);

end;

 //------------------------------------------------------------------------------
 // ISM_FRIEND_DELETE  : ������ ��ɾ ���� ����� ����
 // Params  : ��ɹ�ȣ , �����
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdOSMResult(UserName: string; SvrIndex: integer;
  CmdNum: word; ResultValue: word);
var
  str: string;
begin
  str := IntToStr(CmdNum) + ':' + IntToStr(ResultValue);

  UserMgrEngine.InterSendMsg(stOtherServer, 0, 0, 0, 0,
    UserName, 0, ISM_FRIEND_RESULT,
    SvrIndex, 0, 0, str);

end;

 ////////////////////////////////////////////////////////////////////////////////
 // DB �� ������ ��ɾ��
 ////////////////////////////////////////////////////////////////////////////////
 //------------------------------------------------------------------------------
 // DB_FRIEND_LIST  :  DB�� ģ������Ʈ ��û
 // Params  : ģ����
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdDBList(UserInfo: TUserInfo);
begin
  UserMgrEngine.InterSendMsg(stDBServer, ServerIndex, 0, 0, 0,
    UserInfo.UserName, 0, DB_FRIEND_LIST,
    0, 0, 0, '');
end;

{//------------------------------------------------------------------------------
// DB_FRIEND_OWNLIST  :  DB�� ģ���� ��ϵ� ����� ����Ʈ ��û
// Params  : ����
//------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdDBOwnList( UserInfo : TUserInfo );
begin
    g_UserMgr.SendMsgQueue1(   stDBServer ,ServerIndex,0,0,0,
                                UserInfo.UserName ,0, DB_FRIEND_OWNLIST ,
                                0,0,0,'' );
end;
}
 //------------------------------------------------------------------------------
 // DB_FRIEND_ADD  :  DB�� ģ���߰�
 // Params  : ģ���� , ��ϻ��� , ���ܼ���
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdDBAdd(UserInfo: TUserInfo; Friend: string;
  RegState: word; Desc: string);
var
  str: string;
begin
  str := IntToStr(regState) + ':' + Friend + ':' + Desc + '/';

  UserMgrEngine.InterSendMsg(stDBServer, ServerIndex, 0, 0, 0,
    UserInfo.UserName, 0, DB_FRIEND_ADD,
    RegState, 0, 0, str);
end;

 //------------------------------------------------------------------------------
 // DB_FRIEND_DELETE  :  DB�� ģ������
 // Params  : ģ����
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdDBDelete(UserInfo: TUserInfo; Friend: string);
var
  str: string;
begin
  str := Friend + '/';

  UserMgrEngine.InterSendMsg(stDBServer, ServerIndex, 0, 0, 0,
    UserInfo.UserName, 0, DB_FRIEND_DELETE,
    0, 0, 0, str);
end;

 //------------------------------------------------------------------------------
 // DB_FRIEND_EDIT  :  DB�� ģ������ ����
 // Params  : ģ����  , ���ܼ���
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdDBEdit(UserInfo: TUserInfo; Friend: string; Desc: string);
var
  str: string;
begin
  str := Friend + ':' + Desc + '/';
  UserMgrEngine.InterSendMsg(stDBServer, ServerIndex, 0, 0, 0,
    UserInfo.UserName, 0, DB_FRIEND_EDIT,
    0, 0, 0, str);
end;

 ////////////////////////////////////////////////////////////////////////////////
 // DB �κ��� ���� ��ɾ��
 ////////////////////////////////////////////////////////////////////////////////
 //------------------------------------------------------------------------------
 // DBR_FRIEND_LIST  :  DB���� ������ ģ������Ʈ
 // Params  : ģ�� ����Ʈ
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdDBRList(Cmd: TCmdMsg);
var
  ListCount: integer;
  Friend: string;
  RegState: string;
  Desc: string;
  i: integer;
  TempStr: string;
  BodyStr: string;
begin
  // TO DO : ����Ʈ�� ģ�������� ���� Ŭ���̾�Ʈ�� ����
  BodyStr := GetValidStr3(Cmd.body, TempStr, ['/']);

  // ����Ʈ ���� ���
  ListCount := Str_ToInt(TempStr, 0);

  for i := 0 to ListCount - 1 do begin
    // �и��ڷ� ���ο�Ҹ� �и��Ѵ�.
    BodyStr := GetValidStr3(BodyStr, TempStr, ['/']);
    // ���� �и��ڷ� �ɸ���� ��������� �и��Ѵ�.
    if (TempStr <> '') then begin
      TempStr := GetValidStr3(TempStr, RegState, [':']);
      Desc    := GetValidStr3(TempStr, Friend, [':']);
      Add(Cmd.pInfo, Friend, Str_ToInt(RegState, 0), Desc);
    end;
  end;

  // Ŭ���̾�Ʈ�� ����Ʈ�� ������ �غ� �Ǿ��ִ�.
  FIsListSendAble := True;

  // �����ڸ���Ʈ�� ��û�Ѵ�.
  //    OnCmdDBOwnList( Cmd.pInfo );

  // �̹� Ŭ���̾�Ʈ�� ����Ʈ�� ��û�߾��ٸ� ����Ʈ ����
  if FWantListFlag then begin
    OnSendListToClient(Cmd.pInfo);
  end;

end;

{
//------------------------------------------------------------------------------
// DBR_FRIEND_OWNLIST  :  DB���� ������ ģ���� ����ѻ�� ����Ʈ
// Params  : ģ���� ����ѻ�� ����Ʈ
//------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdDBROwnList( Cmd : TCmdMsg );
var
    ListCount   : integer;
    Friend      : string;
    i           : integer;
    TempStr     : string;
    BodyStr     : string;
begin
    // TO DO : ����Ʈ�� User��  ����� ����鿡�� ���������� ����
    BodyStr := GetValidStr3(Cmd.body,TempStr, ['/']);

    // ����Ʈ ���� ���
    ListCount := Str_ToInt( TempStr , 0);

    for i :=0 to ListCount -1 do
    begin
        // �и��ڷ� ���ο�Ҹ� �и��Ѵ�.
        BodyStr     := GetValidStr3 (BodyStr,Friend, ['/']);

        if ( Friend <> '') then
        begin
            OnSendInfoToOthers( Cmd.pInfo , Friend );
        end;
    end;

end;
}
 //------------------------------------------------------------------------------
 // DBR_FRIEND_RSULT  :  DB���� ������ �����
 // Params  : ���� ��ɾ� , �����
 //------------------------------------------------------------------------------
procedure TFriendMgr.OnCmdDBRResult(Cmd: TCmdMsg);
var
  CmdNum:  string;
  ErrCode: string;

begin
  // TO TEST:
  ErrMsg('CmdDBRResult[Friend] :' + Cmd.Body);

  CmdNum := GetValidStr3(Cmd.body, ErrCode, ['/']);

  case Str_ToInt(CmdNum, 0) of
    DB_FRIEND_LIST: ;    // DB ����
    DB_FRIEND_ADD: ;     // Client �� ����Ҽ� ���� �޼��� ����
    DB_FRIEND_DELETE: ;  // ���� �Ǵ� ����
    DB_FRIEND_OWNLIST: ; // DB ���� ����
    DB_FRIEND_EDIT: ;    // DB �v�� ����
  end;

end;


end.

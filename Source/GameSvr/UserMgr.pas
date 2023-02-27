unit UserMgr;

interface

uses
  Classes, CmdMgr, {ElHashList ,} grobal2, UserSystem, TagSystem, FriendSystem,
  SysUtils, HUtil32, SyncObjs;

type

  // Sub System 's Type
  TSystemType = (stTag, stFriend);

  // TUserFunc Class Declarations --------------------------------------------
  // UserMgr ���� ����Ʈ�� ������ �ý����� ����
  // -------------------------------------------------------------------------
  TUserfunc = class(ICommand)
  public
    FInfo:   TUserInfo;
    FTag:    TTagMgr;
    FFriend: TFriendMgr;

    constructor Create; override;
    destructor Destroy; override;
    procedure OnCmdChange(var Msg: TCmdMsg); override;

    function IsRealUser: boolean;
    // for TagMgr...
    function OpenTag: boolean;
    procedure CloseTag;

    // For FriendMgr...
    function OpenFriend: boolean;
    procedure CloseFriend;

  end;

  PTUserfunc = ^TUserfunc;

  // TUserMgr Class Declarations ---------------------------------------------
  // ���� �ý����� �����̸��� ������ �ؽ� ����Ʈ�� ������
  // -------------------------------------------------------------------------
  TUserMgr = class(TCmdMgr)
  private
    FItems:   TList;  //TElHashList;
    FHumanCS: TCriticalSection;
    // ���� ���� ���� ����
    procedure RemoveAll;
  public
    constructor Create; override;
    destructor Destroy; override;

    // ���� �߰�
    function Add(UserName_: string;       // �����̸�
      Recog_: integer;      // Hum �� �޸� ��ȣ
      ConnState_: integer;      // ���� ����
      GateIdx_: integer;      // ����Ʈ ��ȣ
      userGateIdx_: integer;      // ���� ����Ʈ ��ȣ
      UserHandle_: integer       // ���� �ڵ�
      ): boolean;
    function Find(UserName_: string): TUserFunc;
    // ���� ����
    function Delete(UserName_: string): boolean;

    procedure OpenUser(UserName_: string);   // ����ý����� ���డ���ϰ�
    procedure CloserUser(UserName_: string); // ����ý����� ����Ұ����ϰ�

    function GetUserInfo(UserName_: string; var UserInfo_: TUserInfo): boolean;
    function GetUserFunc(UserName_: string; var UserFunc_: TUserFunc): boolean;

    procedure OnCmdChange(var Msg: TCmdMsg); override;

    // DB �ʿ��� ���� ���۵�
    procedure OnCmdDBROwnList(Cmd: TCmdMsg);
    procedure OnCmdDBRLMList(Cmd: TCmdMsg);
    // DB ������ ��� ����
    procedure OnCmdDBOwnList(UserInfo: TUserInfo);
    procedure OnSendInfoToOthers(UserName: string; ConnState: integer;
      MapInfo: string; LinkedFriend: string);

    // For UserInfo...
    // ���� ���� ����
    function SetConnState(UserName_: string; ConnState_: integer): boolean;
    // ���� �Ǵ� ģ�� �ý��۵��� ����
    procedure OpenSubSystem(UserName_: string; SystemType: TSystemType);
    // ���� �Ǵ� ģ�� �ý��۵��� ����
    procedure CloseSubSystem(Username_: string; SystemType: TSystemType);

  end;

  PTUserMgr = ^TUserMgr;

 //var
 //    g_UserMgr : TUserMgr; // �ý��� ��ü�������� �� �ִ� ���� �޴��� ����

implementation

uses
  svMain;
 ////////////////////////////////////////////////////////////////////////////////
 // TUserFunc
 ////////////////////////////////////////////////////////////////////////////////
constructor TUserFunc.Create;
begin
  inherited;
  //TO DO Initialize
  FInfo   := TUserInfo.Create;
  FTag    := nil;
  FFriend := nil;

end;

destructor TUserFunc.Destroy;
begin
  if (FInfo <> nil) then
    FInfo.Free;
  if (FTag <> nil) then
    FTag.Free;
  if (FFriend <> nil) then
    FFriend.Free;

  inherited;
end;

 //------------------------------------------------------------------------------
 // ��ɾ� �̺�Ʈ �߻��� �Ҹ��� ��
 //------------------------------------------------------------------------------
procedure TUserFunc.OnCmdChange(var Msg: TCmdMsg);
begin

end;

 //------------------------------------------------------------------------------
 // ���������� �����ϰ� ��Ʈ�� ������ ������ ����
 //------------------------------------------------------------------------------
function TUserFunc.IsRealUser: boolean;
begin
  Result := False;

  if FInfo <> nil then begin
    if (FInfo.UserHandle > 0) then begin
      Result := True;
    end;
  end;

end;
 //------------------------------------------------------------------------------
 // ���� �ý��� ����
 //------------------------------------------------------------------------------
function TUserFunc.OpenTag: boolean;
begin
  Result := False;
  if FInfo <> nil then begin
    if FTag <> nil then
      CloseTag;

    FTag := TTagMgr.Create;

    // Loading Datas...
    // ������ Ŭ���� ���� ��񿡼� �о���� ����
    // FTag.OnCmdDBList( FInfo );
    FTag.OnCmdDBRejectList(FInfo);

    Result := True;
  end;
end;

 //------------------------------------------------------------------------------
 // ���� �ý��� �ݱ�
 //------------------------------------------------------------------------------
procedure TUserFunc.CloseTag;
begin
  if FTag <> nil then begin
    FTag.Free;
    FTag := nil;
  end;
end;

 //------------------------------------------------------------------------------
 // ģ�� �ý��� ����
 //------------------------------------------------------------------------------
function TUserFunc.OpenFriend: boolean;
begin
  Result := False;
  if FInfo <> nil then begin
    if FFriend <> nil then
      CloseFriend;
    FFriend := TFriendMgr.Create;

    // Loading Datas...
    FFriend.OnCmdDBList(FInfo);

    Result := True;
  end;

end;

 //------------------------------------------------------------------------------
 // ģ�� �ý��� �ݱ�
 //------------------------------------------------------------------------------
procedure TUserFunc.CloseFriend;
begin
  if FFriend <> nil then begin
    FFriend.Free;
    FFriend := nil;
  end;
end;

 ////////////////////////////////////////////////////////////////////////////////
 // TUserMgr
 ////////////////////////////////////////////////////////////////////////////////
constructor TUserMgr.Create;
begin
  inherited;
  //TO DO Initialize
  FItems   := TList.Create;   //TElHashList.Create;
  FHumanCS := TCriticalSection.Create;

end;

destructor TUserMgr.Destroy;
begin
  RemoveAll;

  FItems.Free;

  FHumanCS.Free;

  inherited;
end;

 //------------------------------------------------------------------------------
 // ADD Info To hash List
 //------------------------------------------------------------------------------
function TUserMgr.Add(UserName_: string; Recog_: integer; ConnState_: integer;
  GateIdx_: integer; UserGateIdx_: integer; UserHandle_: integer): boolean;
var
  Info:  TUserFunc;
  ReUse: boolean;
begin
  Result := False;

  // ���� �̸��� ����ڰ� �ֳ�����
  if GetUserFunc(UserName_, Info) then begin
    ErrMsg('Exist User !:' + UserName_);
    ReUse := True;
  end else begin
    // �޸� ����
    Info  := TUserFunc.Create;
    ReUse := False;
  end;


  if (Info <> nil) then begin
    // �����͸� ���� ��������
    Info.FInfo.UserName   := UserName_;
    Info.FInfo.Recog      := Recog_;
    Info.FInfo.ConnState  := ConnState_;
    Info.FInfo.GateIdx    := GateIdx_;
    Info.FInfo.UserGateIdx := UserGateIdx_;
    Info.FInfo.UserHandle := UserHandle_;

    // ToTest
    // ErrMsg( UserName_ +':'+ IntTostr( Recog_ ) + ':'+IntToStr( UserHandle_ ));

    // �޸� ������ ��쿡�� �׳� �Ѿ��
    if not ReUse then
      FItems.Add(Info);
    //          FItems.Add ( UserName_ , Info );

    // ���� ���� �ý����� ����....
    OpenUser(UserName_);

    // ģ�� ���� ������ ����Ʈ �θ���
    // UserHandle_ = 0 �̸� �ٸ��������� ������ �����
    if Info.IsRealUser then
      OnCmdDBOwnList(Info.FInfo);

    Result := True;
  end;

end;

function TUserMgr.Find(UserName_: string): TUserFunc;
var
  Item: TUserFunc;
  i:    integer;
begin
  Result := nil;
  for i := 0 to FItems.Count - 1 do begin
    Item := TUserFunc(FItems.Items[i]);
    if Item.FInfo.UserName = UserName_ then begin
      Result := Item;
      exit;
    end;
  end;
end;

 //------------------------------------------------------------------------------
 // Delete Info From hash List
 //------------------------------------------------------------------------------
function TUserMgr.Delete(UserName_: string): boolean;
var
  Item: TUserFunc;
  i:    integer;
begin
  Result := False;

  Item := Find(UserName_);   //FItems.Item[ UserName_ ];
  if Item <> nil then begin
    // ģ�� ���� ������ ����Ʈ �θ���
    if Item.IsRealUser then
      OnCmdDBOwnList(Item.FInfo);
    i := FItems.IndexOf(Item);
    if i >= 0 then begin
      //         FItems.Delete( UserName_ );
      FItems.Delete(i);
      Item.Free;
      Result := True;
    end;
  end;
end;


 //------------------------------------------------------------------------------
 // Open Sub System and Send Info To Others
 //------------------------------------------------------------------------------
procedure TUserMgr.OpenUser(UserName_: string);
var
  Item: TUserFunc;
begin
  Item := Find(UserName_);   //FItems.Item[ UserName_ ];
  if Item <> nil then begin
    if Item.FInfo <> nil then
      Item.FInfo.OnUserOpen;
    if Item.FTag <> nil then
      Item.FTag.OnUserOpen;
    if Item.FFriend <> nil then
      Item.FFriend.OnUserOpen;
  end;

end;

 //------------------------------------------------------------------------------
 // CLose Sub System and Send Info To Others
 //------------------------------------------------------------------------------
procedure TUserMgr.CloserUser(UserName_: string);
var
  Item: TUserFunc;
begin
  Item := Find(UserName_);  // FItems.Item[ UserName_ ];
  if Item <> nil then begin
    if Item.FInfo <> nil then
      Item.FInfo.OnUserClose;
    if Item.FTag <> nil then
      Item.FTag.OnUserClose;
    if Item.FFriend <> nil then
      Item.FFriend.OnUserClose;
  end;

end;
 //------------------------------------------------------------------------------
 // Delete All Info From hash List
 //------------------------------------------------------------------------------
procedure TUserMgr.RemoveAll;
var
  i:    integer;
  Item: TUserFunc;
begin
  // TO DO Free Mem
  for i := 0 to FItems.Count - 1 do begin
    Item := FItems.Items[i];
    Item.Free;
  end;

  FItems.Clear;

end;

 //------------------------------------------------------------------------------
 // Find And Get Userfunc From hash List
 //------------------------------------------------------------------------------
function TUserMgr.GetUserFunc(UserName_: string; var UserFunc_: TUserfunc): boolean;
var
  Item: TUserFunc;
begin
  Item := Find(UserName_);  // FItems.Item[ UserName_ ];
  if Item <> nil then begin
    UserFunc_ := Item;
    Result    := True;
  end else begin
    UserFunc_ := nil;
    Result    := False;
  end;
end;

 //------------------------------------------------------------------------------
 // Find And Get UserInfo From hash List
 //------------------------------------------------------------------------------
function TUserMgr.GetUserInfo(UserName_: string; var UserInfo_: TUserInfo): boolean;
var
  Item: TUserFunc;
begin
  UserInfo_ := nil;
  Result    := False;

  Item := Find(UserName_); //FItems.Item[ UserName_ ];

  if (Item <> nil) then begin
    if (Item.FInfo <> nil) then begin
      UserInfo_ := Item.FInfo;
      Result    := True;
    end;
  end;

end;

 //------------------------------------------------------------------------------
 // Change Info's ConnState
 //------------------------------------------------------------------------------
function TUserMgr.SetConnState(UserName_: string; ConnState_: integer): boolean;
var
  Item: TUserInfo;
begin
  Result := False;

  if GetUserInfo(UserName_, Item) then begin
    Item.ConnState := ConnState_;
    Result := True;
  end;

end;

 //------------------------------------------------------------------------------
 // The Event Call When Command is Changed
 //------------------------------------------------------------------------------
procedure TUserMgr.OnCmdChange(var Msg: TCmdMsg);
var
  Func: TUserFunc;
begin

  // UserMgr ���� ó���� ��ɾ�
  case Msg.CmdNum of
    DBR_FRIEND_WONLIST: begin
      OnCmdDBROwnList(Msg);
      exit;
    end;
    DBR_LM_LIST: begin
      OnCmdDBRLMList(Msg);
      exit;
    end;

    ISM_FUNC_USEROPEN: begin
      // ������ �߰��Ѵ�.
      if Add(Msg.UserName, Msg.Msg.Recog, Msg.Msg.Param, Msg.GateIdx,
        Msg.UserGateIdx, Msg.Userhandle) then begin
        // UserHandle_ = 0 �̸� �ٸ��������� ������ ����̴�
        // ���� �ý����� ���� �ʴ´�.
        if Msg.Userhandle <> 0 then begin
          OpenSubSystem(Msg.UserName, stFriend);
          OpenSubSystem(Msg.UserName, stTag);
        end;
      end;
      exit;

    end;
    ISM_FUNC_USERCLOSE: begin
      CloserUser(Msg.UserName);
      Delete(Msg.UserName);
      exit;
    end;
  end;


  if GetUserFunc(Msg.UserName, Func) then begin
    // TO TEST: � ��ɾ �Դ��� �����ش�.
    //ErrMsg( Format('%d,%d,%d,%d,%d,%s',
    //[Msg.Msg.Recog , Msg.Msg.Ident ,Msg.Msg.Param ,Msg.Msg.Tag ,Msg.Msg.Series, Msg.Body ]));

    Msg.pInfo := Func.FInfo;

    // Friend System -----------------------------------
    if (Func.FInfo <> nil) then begin

      case Msg.CmdNum of
        ISM_FRIEND_OPEN,
        ISM_FRIEND_CLOSE,
        ISM_USER_INFO: begin
          Func.FInfo.OnCmdChange(Msg);
          exit;
        end;
      end;

    end else
      exit; // UserInfo �������� �ȵ�

    // Friend System -----------------------------------
    if Func.FFriend <> nil then begin
      case Msg.CmdNum of
        CM_FRIEND_ADD,
        CM_FRIEND_DELETE,
        CM_FRIEND_EDIT,
        CM_FRIEND_LIST,
        ISM_FRIEND_INFO,
        ISM_FRIEND_DELETE,
        ISM_FRIEND_RESULT,
        DBR_FRIEND_LIST,
        DBR_FRIEND_RESULT: begin
          Func.FFriend.OnCmdChange(Msg);
          Exit;
        end;
      end;
    end;

    // Tag System --------------------------------------
    if Func.FTag <> nil then begin
      case Msg.CmdNum of
        CM_TAG_ADD,
        CM_TAG_ADD_DOUBLE,
        CM_TAG_DELETE,
        CM_TAG_SETINFO,
        CM_TAG_LIST,
        CM_TAG_REJECT_LIST,
        CM_TAG_REJECT_ADD,
        CM_TAG_REJECT_DELETE,
        ISM_TAG_SEND,
        ISM_TAG_RESULT,
        DBR_TAG_LIST,
        DBR_TAG_REJECT_LIST,
        DBR_TAG_NOTREADCOUNT,
        DBR_TAG_RESULT: begin
          Func.FTag.OnCmdChange(Msg);
          Exit;
        end;
      end;
    end;

  end; // if GetUserFunc...

end;

 //------------------------------------------------------------------------------
 // ���� �ý����� ģ���� ������ ���� �����.
 //------------------------------------------------------------------------------
procedure TUserMgr.OpenSubSystem(UserName_: string; SystemType: TSystemType);
var
  userfunc: TUserFunc;
begin
  if GetUserfunc(UserName_, userfunc) then begin
    case SystemType of
      stTag: userfunc.OpenTag;
      stFriend: userfunc.OpenFriend;
    end;
  end;
end;

 //------------------------------------------------------------------------------
 // ���νý����� ģ���� ������ �����Ѵ�.
 //------------------------------------------------------------------------------
procedure TUserMgr.CloseSubSystem(Username_: string; SystemType: TSystemType);
var
  userfunc: TUserFunc;
begin
  if GetUserFunc(UserName_, userfunc) then begin
    case SystemType of
      stTag: userfunc.CloseTag;
      stFriend: userfunc.CloseFriend;
    end;
  end;
end;

 //------------------------------------------------------------------------------
 // DB_FRIEND_OWNLIST  :  DB�� ģ���� ��ϵ� ����� ����Ʈ ��û
 // Params  : ����
 //------------------------------------------------------------------------------
procedure TUserMgr.OnCmdDBOwnList(UserInfo: TUserInfo);
begin
  // ������ ����Ʈ ���� ���� 2003-07-01
{
    UserMgrEngine.InterSendMsg(   stDBServer ,ServerIndex,0,0,0,
                     UserInfo.UserName ,0, DB_FRIEND_OWNLIST ,
                     0,0,0,'' );
}
end;



 //------------------------------------------------------------------------------
 // DBR_FRIEND_OWNLIST  :  DB���� ������ ģ���� ����ѻ�� ����Ʈ
 // Params  : ģ���� ����ѻ�� ����Ʈ
 //------------------------------------------------------------------------------
procedure TUserMgr.OnCmdDBROwnList(Cmd: TCmdMsg);
var
  ListCount: integer;
  Friend: string;
  i: integer;
  ConnState: integer;
  TempStr: string;
  BodyStr: string;
  MapInfo: string;
  userinfo: TUserInfo;
begin
  // TO DO : ����Ʈ�� User��  ����� ����鿡�� ���������� ����
  BodyStr := GetValidStr3(Cmd.body, TempStr, ['/']);

  // ����Ʈ ���� ���
  ListCount := Str_ToInt(TempStr, 0);

  // Ŀ�ؼ� ���¸� ã�´�.
  ConnState := 0;
  MapInfo   := '';
  if GetUserInfo(Cmd.UserName, userinfo) then begin
    ConnState := userinfo.ConnState;
    MapInfo   := userinfo.MapInfo;
  end;

  for i := 0 to ListCount - 1 do begin
    // �и��ڷ� ���ο�Ҹ� �и��Ѵ�.
    BodyStr := GetValidStr3(BodyStr, Friend, ['/']);

    if (Friend <> '') then begin
      // ������ �ִ� ����鿡�Ը� ������
      if GetUserInfo(Friend, userinfo) then
        OnSendInfoToOthers(Cmd.UserName, ConnState, MapInfo, Friend);
    end;
  end;

end;

 //------------------------------------------------------------------------------
 // ���踮��Ʈ�� �о���.
 //------------------------------------------------------------------------------
procedure TUserMgr.OnCmdDBRLMList(Cmd: TCmdMsg);
begin

  FHumanCS.Enter;
  try
    UserEngine.ExternSendMessage(Cmd.UserName, RM_LM_DBGETLIST,
      0, 0, 0, 0, Cmd.Body);
  finally
    FHumanCS.Leave;
  end;

end;

 //------------------------------------------------------------------------------
 // �ڽ��� ģ������� �������� ���ӵǾ����� �˸���.
 //------------------------------------------------------------------------------
procedure TUserMgr.OnSendInfoToOthers(UserName: string; ConnState: integer;
  MapInfo: string; LinkedFriend: string);
var
  str: string;
begin
  str := UserName + '/' + IntToStr(ConnState) + '/' + MapInfo + '/';

  UserMgrEngine.InterSendMsg(stOtherServer, ServerIndex, 0, 0, 0,
    LinkedFriend, 0, ISM_USER_INFO,
    ServerIndex, 0, 0, str);

{
    // ģ�� ������ ����
    if g_UserMgr.GetUserInfo( LinkedFriend  , FriendInfo) then
    begin

        // ���ӵ� ����� �˾Ƴ���
        if FriendInfo.ConnState >= CONNSTATE_CONNECT_0 then
        begin
            // ģ���޴������� ģ�������� ����.
            ItemInfo := FItems.Item[LinkedFriend];
            if ( ItemInfo <> nil ) then
            begin

                // �ڽ��� ������ ���� �������ִ»���̸�
                if FriendInfo.ConnState = ( ServerIndex + CONNSTATE_CONNECT_0) then
                begin
                    // TO DO : Ŭ���̾�Ʈ���� Ŀ�ؼ� ������ ����
                    OnCmdSMUserInfo( F
                end
                else
                begin
                    // TO DO : �ٸ������� Ŀ�׼� ������ ����

                end;

            end;// if ItemInfo <> nil .../
        end; // if FriendInfo.ConnState...

    end
}
end;


// END.-------------------------------------------------------------------------
end.

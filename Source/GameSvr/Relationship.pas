unit Relationship;

interface

uses
  Classes, SysUtils, grobal2, Windows, HUtil32;

const
  MAX_LOVERCOUNT = 1;

type

  TRelationShipInfo = class
  private
    FOwnner:  string;      // ������ �̸�
    FName:    string;      // ����� �̸�
    FState:   byte;        // ��ϻ���
    FLevel:   byte;        // ����
    FSex:     byte;        // ����
    FDate:    string;      // ��ϳ�¥
    FServerDate: string;   // ������¥
    FMapInfo: string;      // ������

  public
    constructor Create;
    destructor Destroy; override;

    //���糯¥�� ���信 �°� ��ȭ��Ų��.
    function GetNowDate: string;

    // ���� ������ٿ� ������Ƽ
    property Ownner: string Read FOwnner Write FOwnner;
    property Name: string Read FName Write FName;
    property State: byte Read FState Write FState;
    property Level: byte Read FLevel Write FLevel;
    property Sex: byte Read FSex Write FSex;
    property Date: string Read FDate Write FDate;
    property ServerDate: string Read FServerDate Write FServerDate;
    property MapInfo: string Read FMapInfo Write FMapInfo;

  end;

  PTRelationShipInfo = ^TRelationShipInfo;


  TRelationShipMgr = class
  private
    FItems:      TList;
    FEnableJoinLover: boolean;
    FReqSequence: integer;
    FCancelTime: longword;
    FLoverCount: integer;
    procedure RemoveAll;

    function GetReqSequence: integer;
    procedure SetReqSequence(Sequence: integer);
    function GetDayStr(datestr, delimeter: string): string;
    function GetDayNow(datestr, serverdatestr: string): string;
  public
    constructor Create;
    destructor Destroy; override;


    // ã��
    function GetInfo(Name_: string; var Info_: TRelationShipInfo): boolean;
    function Find(Name_: string): boolean;

    // �߰�
    function Add(Ownner_: string; Other_: string; State_: byte;
      Level_: byte; Sex_: byte; var Date_: string; MapInfo_: string): boolean;
    // ����
    function Delete(Name_: string): boolean;
    // ��������
    function ChangeLevel(Name_: string; Level_: byte): boolean;

    function GetEnableJoin(ReqType: integer): integer;
    function GetEnableJoinReq(ReqType: integer): boolean;
    procedure SetEnable(ReqType: integer; Enable: integer);
    function GetEnable(ReqType: integer): integer;
    function GetListMsg(ReqType: integer; var ListCount: integer): string;

    // Request sequence ó��
    property ReqSequence: integer Read GetReqSequence Write SetReqSequence;
    property EnableJoinLover: boolean Read FEnableJoinLover;
    function GetLoverCount: integer;
    function GetLoverName: string;
    function GetLoverDays: string;
  end;


implementation

// TRealtionShipInfo ===========================================================
constructor TRelationShipInfo.Create;
begin
  inherited;
  //TO DO Initialize
  FOwnner  := '';
  FName    := '';
  FState   := 0;
  FLevel   := 0;
  FSex     := 0;
  FDate    := GetNowDate;
  FMapInfo := '';
  FServerDate := GetNowDate;
end;

destructor TRelationShipInfo.Destroy;
begin
  // TO DO Free Mem

  inherited;
end;

// ���糯¥�� ���信 �°� ��ȯ��Ų��.
function TRelationShipInfo.GetNowDate: string;
begin
  Result := FormatDateTime('yymmddhhnn', Now);
end;

// TRealtionShipMgr ============================================================
constructor TRelationShipMgr.Create;
begin
  inherited;
  //TO DO Initialize
  FItems      := TList.Create;
  FEnableJoinLover := False;
  FReqSequence := rsReq_None;
  FCancelTime := 0;
  FLoverCount := 0;

end;

destructor TRelationShipMgr.Destroy;
begin
  // TO DO Free Mem
  RemoveAll;
  FItems.Free;

  inherited;
end;

procedure TRelationShipMgr.RemoveAll;
var
  Info: TRelationShipInfo;
  i:    integer;
begin
  for i := 0 to FItems.Count - 1 do begin
    Info := FItems[i];

    if (Info <> nil) then begin
      Info.Free;
      Info := nil;
    end;
  end;

  FItems.Clear;
end;

function TRelationShipMgr.GetReqSequence: integer;
begin
  if (FcancelTime = 0) or ((GetTickCount - FCancelTime) <= MAX_WAITTIME) then begin
    // ������ �ð� ���� �� ���� ����
    ;
  end else begin
    // �ð��� �ʹ� ���� �������Ƿ� ��ȿ
    FReqSequence := RsReq_None;
  end;

  Result := FReqSequence;
end;

procedure TRelationShipMgr.SetReqSequence(Sequence: integer);
begin
  if (FCancelTime = 0) or ((GetTickCount - FCancelTime) <= MAX_WAITTIME) then begin
    FReqSequence := Sequence;
  end else begin
    // �ð��� �ʹ� ���� �������Ƿ� ��ȿ
    FReqSequence := RsReq_None;
  end;
  FCancelTime := GetTickCount;
end;


function TRelationShipMgr.GetDayStr(datestr: string; delimeter: string): string;
begin
  Result := '';
  if length(datestr) >= 6 then begin
    Result := '20' + datestr[1] + datestr[2] + delimeter + datestr[3] +
      datestr[4] + delimeter + datestr[5] + datestr[6];
  end;

end;

function TRelationShipMgr.GetDayNow(datestr: string; serverdatestr: string): string;
var
  //    date        : TDateTime;
  //    serverdate  : TDateTime;
  str, strtemp: string;
  exdate, extime, exdatetime, exdatetime2: TDateTime;
  cYear, cMon, cDay, cHour, cMin, cSec, cMSec: word;
begin
  Result := '0';
  //      exit;
  try
    str := GetDayStr(datestr, '-');

    str   := GetValidStr3(str, strtemp, ['-']);
    cYear := word(StrToInt(strtemp));
    str   := GetValidStr3(str, strtemp, ['-']);
    cMon  := word(StrToInt(strtemp));
    cDay  := word(StrToInt(str));

    cHour := 0;
    cMin  := 0;
    cSec  := 0;
    cMSec := 0;

    exdate     := Trunc(EncodeDate(cYear, cMon, cDay));
    extime     := EncodeTime(cHour, cMin, cSec, cMSec);
    exdatetime := exdate + extime + 1;


    str := GetDayStr(serverdatestr, '-');

    str   := GetValidStr3(str, strtemp, ['-']);
    cYear := word(StrToInt(strtemp));
    str   := GetValidStr3(str, strtemp, ['-']);
    cMon  := word(StrToInt(strtemp));
    cDay  := word(StrToInt(str));

    cHour := 0;
    cMin  := 0;
    cSec  := 0;
    cMSec := 0;

    exdate      := Trunc(EncodeDate(cYear, cMon, cDay));
    extime      := EncodeTime(cHour, cMin, cSec, cMSec);
    exdatetime2 := exdate + extime + 1;

    Result := IntToStr(Trunc(exdatetime2 - exdatetime) + 1);
  except
    Result := '0';
  end;

  //    date        := StrToDate( GetDayStr( datestr        , '-') );
  //    serverdate  := StrToDate( GetDayStr( serverdatestr  , '-') );

  //    Result := IntTostr ( Trunc( serverdate - date ) + 1 );

end;

// ���� ���� ����
function TRelationShipMgr.GetEnableJoin(ReqType: integer): integer;
begin
  Result := 3;   //����(��Ÿ)

  case ReqType of
    RsState_Lover: begin
      //����(�������� ���°� �ƴ�)
      if not fEnableJoinLover then begin
        Result := 1;
        exit;
      end;
      if fLoverCount < MAX_LOVERCOUNT then begin
        //����
        Result := 0;
        exit;
      end else begin
        //����(�̹� ������ ����)
        Result := 2;
        exit;
      end;
    end;
  end;

end;

// ���� ���� ����
function TRelationShipMgr.GetEnableJoinReq(ReqType: integer): boolean;
begin
  Result := False;

  case ReqType of
    RsState_Lover: if fEnableJoinLover and (fLoverCount < MAX_LOVERCOUNT) then
        Result := True;
  end;

end;

procedure TRelationShipMgr.SetEnable(ReqType: integer; enable: integer);
begin
  case ReqType of
    RsState_Lover: begin
      if enable = 1 then
        FEnableJoinLover := True
      else
        FEnableJoinLover := False;
    end;
  end;
end;


function TRelationShipMgr.GetEnable(ReqType: integer): integer;
begin
  Result := 0;

  case ReqType of
    RsState_Lover: begin
      if FEnableJoinLover then
        Result := 1
      else
        Result := 0;
    end;
  end;
end;

function TRelationShipMgr.GetListMsg(ReqType: integer; var ListCount: integer): string;
var
  i:    integer;
  Info: TRelationShipInfo;
  msg:  string;
begin
  ListCount := 0;
  msg := '';
  for i := 0 to FItems.Count - 1 do begin
    Info := Fitems[i];

    if Info.FState = ReqType then begin
      // ��ϻ���:�ɸ����̸�:����:����:�������:��������:������/
      msg := msg + IntToStr(Info.FState) + ':' + Info.Name + ':' +
        IntToStr(Info.Level) + ':' + IntToStr(Info.Sex) + ':' +
        Info.Date + ':' + Info.ServerDate + ':' + Info.MapInfo + '/';
      Inc(ListCount);
    end;

  end;
  Result := msg;
end;

// Get Infomation...
function TRelationShipMgr.GetInfo(Name_: string; var Info_: TRelationShipInfo): boolean;
var
  i:    integer;
  Info: TrelationShipInfo;
begin
  Result := False;
  Info_  := nil;

  for i := 0 to FItems.Count - 1 do begin
    Info := FItems[i];
    if (Info <> nil) and (Info.Name = Name_) then begin
      Info_  := Info;
      Result := True;
      Exit;
    end;
  end;
end;

function TRelationShipMgr.Find(Name_: string): boolean;
var
  Info: TRelationShipInfo;
begin
  Result := GetInfo(Name_, Info);
end;


function TRelationShipMgr.Add(Ownner_: string; Other_: string;
  State_: byte; Level_: byte; Sex_: byte; var Date_: string; MapInfo_: string): boolean;
var
  Info: TRelationShipInfo;
begin
  Result := False;

  // ������ üũ
  if (Ownner_ = '') or (Other_ = '') or (Level_ = 0) then
    Exit;

  // ��ϵǾ����� ���� ����̶�� ����Ѵ�.
  Info := nil;
  if not Find(Other_) then begin
    Info := TRelationShipInfo.Create;

    Info.Ownner := Ownner_;
    Info.Name   := Other_;
    Info.State  := State_;
    Info.Level  := Level_;
    Info.Sex    := Sex_;
    if Date_ <> '' then
      Info.Date := Date_
    else
      Date_     := Info.Date;
    Info.MapInfo := MapInfo_;

    FItems.Add(Info);

    case State_ of
      RsState_Lover: Inc(fLoverCount);
    end;

    Result := True;
  end;
end;

function TRelationShipMgr.Delete(Name_: string): boolean;
var
  Info: TRelationShipInfo;
  i:    integer;
begin
  Result := False;

  for i := 0 to FItems.Count - 1 do begin
    Info := FItems[i];
    if (Info <> nil) and (Info.Name = Name_) then begin
      // ������Ʈ�� �´� ����� �����Ѵ�.
      case Info.State of
        RsState_Lover: Dec(fLoverCount);
      end;

      Info.Free;
      Info := nil;
      FItems.Delete(i);
      Result := True;
      Exit;
    end;
  end;

end;

function TRelationShipMgr.ChangeLevel(Name_: string; Level_: byte): boolean;
var
  Info: TRelationShipInfo;
begin
  Result := False;
  // ������ 0 ���� ũ��
  if Level_ > 0 then begin
    // ������ ��
    if GetInfo(Name_, Info) then begin
      // ��������
      if Info <> nil then begin
        Info.Level := Level_;
        Result     := True;
      end;
    end;
  end;
end;

function TRelationShipMgr.GetLoverCount: integer;
begin
  Result := fLoverCount;
end;

function TRelationShipMgr.GetLoverName: string;
var
  Info: TRelationShipInfo;
  i:    integer;
begin
  Result := '';

  for i := 0 to FItems.Count - 1 do begin
    Info := FItems[i];

    if (Info <> nil) then begin
      Result := Info.Name;
      exit;
    end;
  end;
end;

function TRelationShipMgr.GetLoverDays: string;
var
  Info: TRelationShipInfo;
  i:    integer;
begin
  Result := '';

  for i := 0 to FItems.Count - 1 do begin
    Info := FItems[i];

    if (Info <> nil) then begin
      Result := GetDayNow(Info.Date, Info.ServerDate);
      exit;
    end;
  end;
end;


end.

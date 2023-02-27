unit Guild;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  ScktComp, syncobjs, MudUtil, HUtil32, Grobal2, Envir, EdCode,
  M2Share, SQLEngn;

const
  DEFRANK = 99; //������ ���� ���� ���
  GUILDAGIT_DAYUNIT = 7;  //7��
  GUILDAGIT_SALEWAIT_DAYUNIT = 1;  //1��
  MAXGUILDAGITCOUNT = 100;
  GABOARD_NOTICE_LINE = 3;
  GABOARD_COUNT_PER_PAGE = 10;     //����Խ��� 1�������� ���μ�.
  GABOARD_MAX_ARTICLE_COUNT = 73;  //����Խ��� �ִ� �Խù� ��.
  AGITDECOMONFILE = 'AgitDecoMon.txt';   //����ٹ̱� ��ġ ������ ����Ʈ ����.
  MAXCOUNT_DECOMON_PER_AGIT = 50;  //�ٹ̱� ������ ����� �ִ� ��ġ ����

  GUILDAGITMAXGOLD = 100000000;

  //���� ���
  GUILDAGITREGFEE    = 10000000;
  GUILDAGITEXTENDFEE = 1000000;

type
  TGuildRank = record
    Rank:     integer;      //����
    RankName: string;       //��å�̸�
    MemList:  TStringList;  //�ɹ� ����Ʈ
  end;
  PTGuildRank = ^TGuildRank;

  TGuild = class;

  TGuildWarInfo = record
    WarGuild:     TGuild;
    WarStartTime: longword;
    WarRemain:    longword;
  end;
  PTGuildWarInfo = ^TGuildWarInfo;

  TGuild = class
    GuildName:      string;
    NoticeList:     TStringList;
    KillGuilds:     TStringList;
    AllyGuilds:     TStringList;
    MemberList:     TList;    //list of PTGuildRank
    MatchPoint:     integer;  //���Ĵ������� ����
    BoStartGuildFight: boolean;
    FightMemberList: TStringList; //���Ĵ����� �츮�� ����Ʈ
    AllowAllyGuild: boolean;      //���� ��� ����
  private
    guildsavetime: longword;
    dosave: boolean;
    procedure FreeMemberList;
  public
    constructor Create(gname: string);
    destructor Destroy; override;
    function LoadGuild: boolean;
    function LoadGuildFile(flname: string): boolean;
    procedure BackupGuild(flname: string);
    procedure SaveGuild;
    procedure GuildInfoChange;
    procedure CheckSave;

    function IsMember(who: string): boolean;
    function GetGuildMaster: string;
    function GetAnotherGuildMaster: string;
    function AddGuildMaster(who: string): boolean; //ó���� ���� �����ɶ��� ���
    function DelGuildMaster(who: string): boolean; //������ ���ֳ����� ���� ����
    procedure BreakGuild;  //������ ���İ� ������. (����)
    function AddMember(who: TObject): boolean;
    function DelMember(who: string): boolean;
    function MemberLogin(who: TObject; var grank: integer): string;
    procedure MemberLogout(who: TObject);
    procedure MemberNameChanged;
    procedure GuildMsg(str: string; nameexcept: string = '');
    function UpdateGuildRankStr(rankstr: string): integer;

    function IsHostileGuild(aguild: TGuild): boolean;
    function DeclareGuildWar(aguild: TGuild;
      var backresult: boolean): PTGuildWarInfo;
    //���� ���Ŀ� ���Ľ��� �Ǵ�.
    //3�ð����� ��ȿ, �ƹ����� �� �� �ִ�.

    function IsAllyGuild(aguild: TGuild): boolean;
    function MakeAllyGuild(aguild: TGuild): boolean;
    //���� ���Ŀ� ������ �Ἲ�Ѵ�.
    //���ֳ��� ���� ���ֺ��� �� �� �ִ�.
    function CanAlly(aguild: TGuild): boolean;
    function BreakAlly(aguild: TGuild): boolean;

    procedure CanceledGuildWar(aguild: TGuild);

    procedure TeamFightStart;
    procedure TeamFightEnd;
    procedure TeamFightAdd(whostr: string);
    procedure TeamFightWhoWinPoint(whostr: string; point: integer);
    procedure TeamFightWhoDead(whostr: string);

    function GetTotalMemberCount: integer;
  end;


  TGuildManager = class
  private
  public
    GuildList: TList;
    constructor Create;
    destructor Destroy; override;
    procedure ClearGuildList;
    procedure LoadGuildList;
    procedure SaveGuildList;
    function GetGuild(gname: string): TGuild;
    function GetGuildFromMemberName(who: string): TGuild;
    function AddGuild(gname, mastername: string): boolean;
    function DelGuild(gname: string): boolean;
    procedure CheckGuildWarTimeOut;
  end;

  {-----------------------------------}
  // �������(sonmg)
  TGuildAgit = class
    GuildAgitNumber: integer;       // �����ȣ(1-base)
    GuildName:      string;         // ���ĸ�
    GuildMasterName: string;        // ���ָ�
    GuildMasterNameSecond: string;  // �ι�° ���ָ�
    RegistrationTime: string;       // ����Ͻ�
    ContractPeriod: integer;        // ���Ⱓ(��)
    GuildAgitTotalGold: integer;    // ��� ��α�

    ForSaleFlag:      integer;              // �Ǹ� �÷���(1,0)
    ForSaleMoney:     integer;              // �Ǹ� �ݾ�
    ForSaleWait:      integer;              // ���� �����Ⱓ(��)
    ForSaleGuildName: string;               // ���� ���� ���ĸ�
    ForSaleGuildMasterName: string;         // ���� ���� ���ָ�
    ForSaleTime:      string;               // ���� ����Ͻ�
  private
    procedure InitGuildAgitRecord;
  public
    constructor Create;
    destructor Destroy; override;
    procedure SetGuildAgitRecord(agitnumber: integer;
      gname, mastername, regtime: string; period, agittotalgold: integer);
    procedure SetGuildAgitForSaleRecord(saleflag, salemoney, salewait: integer;
      salegname, salemastername, saletime: string);
    function AddGuildAgitRecord(nextnumber: integer;
      gname, mastername, secondmastername: string): boolean;
    function GetGuildAgitRemainDateTime: TDateTime;
    procedure ExpulsionMembers;
    function IsExpired: boolean;
    function GetCurrentDelayStatus: integer;
    function GetGuildAgitRegDateTime: TDateTime;
    function ConvertStringToDatetime(datestring: string): TDateTime;
    function ConvertDateTimeToString(datetime: TDateTime): string;
    function IsForSale: boolean;
    function IsSoldOut: boolean;
    function IsSoldOutExpired: boolean;
    procedure ResetForSaleFields;
    function ChangeGuildAgitMaster: boolean;
    function UpdateGuildMaster: string;
  end;

  //-------------------------------
  // �����������(sonmg)
  TGuildAgitManager = class
    GuildAgitFileVersion: integer;
    ReturnMapName:    string;
    ReturnX, ReturnY: integer;
    EntranceX, EntranceY: integer;
    GuildAgitMapName: array [0..3] of string; // ���̸�
  private
  public
    GuildAgitList:    TList;
    // ����ٹ̱� ������Ʈ ����Ʈ(sonmg 2004/06/23)
    AgitDecoMonList:  TList;
    // ����ٹ̱� ������Ʈ ����
    AgitDecoMonCount: array [1..MAXGUILDAGITCOUNT] of integer;

    constructor Create;
    destructor Destroy; override;
    procedure ClearGuildAgitList;
    procedure LoadGuildAgitList;
    procedure SaveGuildAgitList(bBackup: boolean);
    function GetGuildAgit(gname: string): TGuildAgit;
    function AddGuildAgit(gname, mastername, secondmastername: string): integer;
    function DelGuildAgit(gname: string): boolean;
    function GetNextGuildAgitNumber: integer;
    function CheckGuildAgitTimeOut(gaCount: integer): boolean;
    function ExtendTime(Count: integer; gname: string): integer;
    function GetRemainDateTime(gname: string): TDateTime;
    function GetTradingRemainDate(gname: string): integer;
    function IsDelayed(gname: string): boolean;
    function ConvertDatetimeToFileName(datetime: TDateTime): string;
    procedure GetGuildAgitSaleList(var salelist: TStringList);
    function IsGuildAgitExpired(gname: string): boolean;
    function GuildAgitTradeOk(gname, new_gname, new_mastername: string): boolean;
    function IsExistInForSaleGuild(gname: string): boolean;
    function GetGuildNameFromAgitNum(AgitNum: integer): string;
    function GetGuildMasterNameFromAgitNum(AgitNum: integer): string;
    //����ٹ̱�
    function MakeAgitDecoMon: integer;   //����� �������� ����Ų��.
    function MakeDecoItemToMap(DropMapName: string; ItemName: string;
      LookIndex, Durability: integer; dx, dy: integer): integer;
    function DeleteAgitDecoMon(mapname: string; x, y: word): boolean;
    function AddAgitDecoMon(item: TAgitDecoItem): boolean;
    function UpdateDuraAgitDecoMon(mapname: string; x, y, dura: word): boolean;
    function LoadAgitDecoMon: integer;
    procedure SaveAgitDecoMonList;
    function GetDecoItemName(index: integer; var price: string): string;
    function GetAgitDecoMonCount(agitnum: integer): integer;
    procedure IncAgitDecoMonCount(gname: string);
    procedure IncAgitDecoMonCountByAgitNum(agitnum: integer);
    procedure DecAgitDecoMonCount(gname: string);
    procedure DecAgitDecoMonCountByAgitNum(agitnum: integer);
    procedure ArrangeEachAgitDecoMonCount;
    function IsAvailableDecoMonCount(gname: string): boolean;
    function IsMatchDecoItemInOutdoor(index: integer; mapname: string): boolean;
    function GetGuildAgitMapFloor(mapname: string): integer;
    function GetGuildAgitNumFromMapName(gmapname: string): integer;
    function DecreaseDecoMonDurability: boolean;
  end;

  // ����Խ��ǰ���(sonmg)
  TGuildAgitBoardManager = class
  private
    GaBoardList: TList; // List of List
    function GetAllPage(WholeLine: integer): integer;
    procedure ConvertNumSeriesToInteger(var NumSeries: string;
      var OrgNum, SrcNum1, SrcNum2, SrcNum3: integer);
    function GetNewArticleNumber(gname: string;
      var OrgNum, SrcNum1, SrcNum2, SrcNum3: integer): integer;

  public
    constructor Create;
    destructor Destroy; override;
    function LoadOneGaBoard(uname: string; nAgitNum: integer): boolean;
    function LoadAllGaBoardList(uname: string): boolean;
    procedure AddGaBoardList(pSearchInfo: PTSearchGaBoardList);
    function GetPageList(uname, gname: string; var nPage, nAllPage: integer;
      var subjectlist: TStringList): boolean;
    function AddArticle(gname: string; nKind, AgitNum: integer;
      uname, Data: string): boolean;
    function GetArticle(gname: string; NumSeries: string): string;
    function DelArticle(gname, uname: string; NumSeries: string): boolean;
    function EditArticle(gname, uname, Data: string): boolean;
  end;

implementation

uses
  svMain, ObjBase;

constructor TGuild.Create(gname: string);
begin
  inherited Create;
  GuildName  := gname;
  NoticeList := TStringList.Create;
  KillGuilds := TStringList.Create;
  AllyGuilds := TStringList.Create;
  MemberList := TList.Create;
  FightMemberList := TStringList.Create;

  guildsavetime := 0;
  dosave     := False;
  MatchPoint := 0;
  BoStartGuildFight := False;
  AllowAllyGuild := False;

end;

destructor TGuild.Destroy;
begin
  NoticeList.Free;
  KillGuilds.Free;
  AllyGuilds.Free;
  FreeMemberList;
  MemberList.Free;
  FightMemberList.Free;
  inherited Destroy;
end;

procedure TGuild.FreeMemberList;
var
  i:      integer;
  pgrank: PTGuildRank;
begin
  if MemberList <> nil then begin
    for i := 0 to MemberList.Count - 1 do begin
      pgrank := PTGuildRank(MemberList[i]);
      if pgrank.MemList <> nil then begin
        pgrank.MemList.Free;
      end;
      Dispose(pgrank);
    end;
    MemberList.Clear;
  end;
end;

function TGuild.LoadGuild: boolean;
begin
  Result := LoadGuildFile(GuildName + '.txt');
end;

function TGuild.LoadGuildFile(flname: string): boolean;
var
  i:      integer;
  strlist: TStringList;
  str, Data, rtstr, rankname: string;
  step, rank: integer;
  pgrank: PTGuildRank;
  pgw:    PTGuildWarInfo;
  aguild: TGuild;
begin
  Result := False;
  pgrank := nil;

  if FileExists(GuildDir + flname) then begin

    FreeMemberList;
    NoticeList.Clear;
    for i := 0 to KillGuilds.Count - 1 do
      Dispose(PTGuildWarInfo(KillGuilds.Objects[i]));
    KillGuilds.Clear;
    AllyGuilds.Clear;
    step     := 0;
    rank     := 0;
    rankname := '';

    strlist := TStringList.Create;
    strlist.LoadFromFile(GuildDir + flname);
    for i := 0 to strlist.Count - 1 do begin
      str := strlist[i];
      if str <> '' then begin
        if str[1] = ';' then
          continue;
        if str[1] <> '+' then begin
          if str = 'Notice' then
            step := 1;
          if str = 'EnemyGuild' then
            step := 2;
          if str = 'AlliedGuild' then
            step := 3;
          if str = 'GuildMember' then
            step := 4;
          if str[1] = '#' then begin
            str      := Copy(str, 2, length(str) - 1);
            str      := GetValidStr3(str, Data, [',', ' ']);
            rank     := Str_ToInt(Data, 0);
            rankname := Trim(str);
            pgrank   := nil;
          end;
        end else begin
          str := Copy(str, 2, length(str) - 1);
          case step of
            1: begin
              NoticeList.Add(str);
            end;
            2: begin
              while str <> '' do begin
                str := GetValidStr3(str, Data, [',', ' ']);
                str := GetValidStr3(str, rtstr, [',', ' ']);
                if Data <> '' then begin
                  new(pgw);
                  pgw.WarGuild := GuildMan.GetGuild(Data);
                  if pgw.WarGuild <> nil then begin
                    pgw.WarStartTime := GetTickCount;
                    pgw.WarRemain    := Str_ToInt(Trim(rtstr), 0);
                    KillGuilds.AddObject(pgw.WarGuild.GuildName,
                      TObject(pgw));
                  end else
                    Dispose(pgw);
                end else
                  break;
              end;
            end;
            3: begin
              while str <> '' do begin
                str := GetValidStr3(str, Data, [',', ' ']);
                if Data <> '' then begin
                  aguild := GuildMan.GetGuild(Data);
                  if aguild <> nil then
                    AllyGuilds.AddObject(Data, aguild);
                end else
                  break;
              end;
            end;
            4: begin
              if (rank > 0) and (rankname <> '') then begin
                if pgrank = nil then begin
                  new(pgrank);
                  pgrank.Rank     := rank;
                  pgrank.RankName := rankname;
                  pgrank.MemList  := TStringList.Create;
                  MemberList.Add(pgrank);
                end;
                while str <> '' do begin
                  str := GetValidStr3(str, Data, [',', ' ']);
                  if Data <> '' then begin
                    pgrank.MemList.Add(Data);
                  end else
                    break;
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    strlist.Free;
    Result := True;
  end;
end;

procedure TGuild.BackupGuild(flname: string);
var
  i, k, remain: integer;
  Data:    string;
  strlist: TStringList;
  pgr:     PTGuildRank;
  pgw:     PTGuildWarInfo;
begin
  strlist := TStringList.Create;

  strlist.Add('Notice');

  for i := 0 to NoticeList.Count - 1 do
    strlist.Add('+' + NoticeList[i]);
  strlist.Add(' ');

  strlist.Add('EnemyGuild');
  for i := 0 to KillGuilds.Count - 1 do begin
    pgw    := PTGuildWarInfo(KillGuilds.Objects[i]);
    remain := pgw.WarRemain - (GetTickCount - pgw.WarStartTime);
    if remain > 0 then
      strlist.Add('+' + KillGuilds[i] + ' ' + IntToStr(remain));
  end;
  strlist.Add(' ');

  strlist.Add('AlliedGuild');
  for i := 0 to AllyGuilds.Count - 1 do
    strlist.Add('+' + AllyGuilds[i]);
  strlist.Add(' ');

  strlist.Add('GuildMember');
  for i := 0 to MemberList.Count - 1 do begin
    pgr := PTGuildRank(MemberList[i]);
    strlist.Add('#' + IntToStr(pgr.Rank) + ' ' + pgr.RankName);
    for k := 0 to pgr.MemList.Count - 1 do begin
      strlist.Add('+' + pgr.MemList[k]);
    end;
  end;
  try
    strlist.SaveToFile(flname);
  except
    MainOutMessage(flname + 'Saving error...');
  end;
  strlist.Free;
end;

procedure TGuild.SaveGuild;
begin
  if ServerIndex = 0 then begin
    BackupGuild(GuildDir + GuildName + '.txt');
  end else begin
    BackupGuild(GuildDir + GuildName + '.' + IntToStr(ServerIndex));
  end;
end;

procedure TGuild.GuildInfoChange;
begin
  dosave := True;
  guildsavetime := GetTickCount;
  SaveGuild;
end;

procedure TGuild.CheckSave;
begin
  if dosave then begin  //���⼭ �ð��Ǹ� ������.
    if GetTickCount - guildsavetime > 30 * 1000 then begin  //������� 30��
      dosave := False;
      SaveGuild;
    end;
  end;
end;

function TGuild.IsMember(who: string): boolean;
var
  i, k:   integer;
  pgrank: PTGuildRank;
begin
  Result := False;
  CheckSave;

  if MemberList <> nil then begin
    for i := 0 to MemberList.Count - 1 do begin
      pgrank := PTGuildRank(MemberList[i]);
      for k := 0 to pgrank.MemList.Count - 1 do begin
        if pgrank.MemList[k] = who then begin
          Result := True;
          exit;
        end;
      end;
    end;
  end;
end;

function TGuild.MemberLogin(who: TObject; var grank: integer): string;
var
  i, k:   integer;
  pgrank: PTGuildRank;
begin
  Result := '';
  if MemberList <> nil then begin
    for i := 0 to MemberList.Count - 1 do begin
      pgrank := PTGuildRank(MemberList[i]);
      for k := 0 to pgrank.MemList.Count - 1 do begin
        if pgrank.MemList[k] = TCreature(who).UserName then begin
          pgrank.MemList.Objects[k] := who;
          grank  := pgrank.Rank;
          Result := pgrank.RankName;
          TUserHuman(who).UserNameChanged;
          TUserHuman(who).SendMsg(TUserHuman(who), RM_CHANGEGUILDNAME,
            0, 0, 0, 0, '');
          exit;
        end;
      end;
    end;
  end;
end;

function TGuild.GetGuildMaster: string;
var
  i: integer;
begin
  Result := '';
  if MemberList <> nil then begin
    if MemberList.Count > 0 then begin
      if PTGuildRank(MemberList[0]).MemList.Count > 0 then begin
        Result := PTGuildRank(MemberList[0]).MemList[0];
      end;
    end;
  end;
end;

//�� �ٸ� ����.
function TGuild.GetAnotherGuildMaster: string;
var
  i: integer;
begin
  Result := '';
  if MemberList <> nil then begin
    if MemberList.Count > 0 then begin
      if PTGuildRank(MemberList[0]).MemList.Count >= 2 then begin
        Result := PTGuildRank(MemberList[0]).MemList[1];
      end;
    end;
  end;
end;

function TGuild.AddGuildMaster(who: string): boolean;
var
  pgrank: PTGuildRank;
begin
  Result := False;
  if MemberList <> nil then begin
    if MemberList.Count = 0 then begin
      new(pgrank);
      pgrank.Rank     := 1;
      pgrank.RankName := 'GuildChief';
      pgrank.MemList  := TStringList.Create;
      pgrank.MemList.Add(who);
      MemberList.Add(pgrank);
      SaveGuild;
      Result := True;
    end;
  end;
end;

function TGuild.DelGuildMaster(who: string): boolean;
var
  pgrank: PTGuildRank;
begin
  Result := False;
  //���� ȥ�� ������ ���, ���� Ż��� ���� ����..
  if MemberList <> nil then begin
    if MemberList.Count = 1 then begin  //��� ��å�� �� �������� ����
      pgrank := PTGuildRank(MemberList[0]);
      if pgrank.MemList.Count = 1 then begin
        if pgrank.MemList[0] = who then begin
          BreakGuild;  //���� ����... ��繮�� ©��
          Result := True;
        end;
      end;
    end;
  end;
end;


procedure TGuild.BreakGuild;   //���� �����, //��忡 �α����� ������� ���Ŀ��� ����.
var
  i, k:   integer;
  pgrank: PTGuildRank;
  hum:    TUserHuman;
begin
  if ServerIndex = 0 then
    BackupGuild(GuildDir + GuildName + '.' + IntToStr(GetCurrentTime) + '.bak');

  if MemberList <> nil then begin
    for i := 0 to MemberList.Count - 1 do begin
      pgrank := PTGuildRank(MemberList[i]);
      for k := 0 to pgrank.MemList.Count - 1 do begin
        hum := TUserHuman(pgrank.MemList.Objects[k]);
        if hum <> nil then begin
          hum.MyGuild := nil;
          hum.GuildRankChanged(0, '');
        end;
      end;
      pgrank.MemList.Free;
    end;
    MemberList.Clear;
  end;
  if NoticeList <> nil then
    NoticeList.Clear;
  if KillGuilds <> nil then begin
    for i := 0 to KillGuilds.Count - 1 do
      Dispose(PTGuildWarInfo(KillGuilds.Objects[i]));
    KillGuilds.Clear;
  end;

  if AllyGuilds <> nil then
    AllyGuilds.Clear;

  SaveGuild;
end;

function TGuild.AddMember(who: TObject): boolean;
var
  i: integer;
  pgrank, drank: PTGuildRank;
begin
  Result := False;
  drank  := nil;
  if MemberList <> nil then begin
    for i := 0 to MemberList.Count - 1 do begin
      pgrank := PTGuildRank(MemberList[i]);
      if pgrank.Rank = DEFRANK then begin
        drank := pgrank;
        break;
      end;
    end;
    if drank = nil then begin
      new(drank);
      drank.Rank     := DEFRANK;
      drank.RankName := 'GuildMember';
      drank.MemList  := TStringList.Create;
      MemberList.Add(drank);
    end;
    drank.MemList.AddObject(TCreature(who).UserName, who);
    GuildInfoChange;
    Result := True;
  end;
end;

function TGuild.DelMember(who: string): boolean;
var
  i, k:   integer;
  pgrank: PTGuildRank;
  done:   boolean;
begin
  Result := False;
  done   := False;
  if MemberList <> nil then begin
    for i := 0 to MemberList.Count - 1 do begin
      pgrank := PTGuildRank(MemberList[i]);
      for k := 0 to pgrank.MemList.Count - 1 do begin
        if pgrank.MemList[k] = who then begin
          pgrank.MemList.Delete(k);
          done := True;
          break;
        end;
      end;
      if done then
        break;
    end;
  end;
  if done then
    GuildInfoChange;
  Result := done;
end;

procedure TGuild.MemberLogout(who: TObject);
var
  i, k:   integer;
  pgrank: PTGuildRank;
begin
  if self = nil then
    exit;   // 2004/04/28(sonmg)

  CheckSave;
  if MemberList <> nil then begin
    for i := 0 to MemberList.Count - 1 do begin
      pgrank := PTGuildRank(MemberList[i]);
      for k := 0 to pgrank.MemList.Count - 1 do begin
        if pgrank.MemList.Objects[k] = who then begin
          pgrank.MemList.Objects[k] := nil;
          exit;
        end;
      end;
    end;
  end;
end;

procedure TGuild.MemberNameChanged;
var
  i, k:  integer;
  prank: PTGuildRank;
  hum:   TUserHuman;
begin
  if MemberList <> nil then begin
    for i := 0 to MemberList.Count - 1 do begin
      prank := PTGuildRank(MemberList[i]);
      for k := 0 to prank.MemList.Count - 1 do begin
        if prank.MemList.Objects[k] <> nil then begin
          hum := TUserHuman(prank.MemList.Objects[k]);
          hum.UserNameChanged;
        end;
      end;
    end;
  end;
end;

procedure TGuild.GuildMsg(str: string; nameexcept: string);
var
  i, k:  integer;
  prank: PTGuildRank;
  hum:   TUserHuman;
begin
  if MemberList <> nil then begin
    for i := 0 to MemberList.Count - 1 do begin
      prank := PTGuildRank(MemberList[i]);
      for k := 0 to prank.MemList.Count - 1 do begin
        if prank.MemList.Objects[k] <> nil then begin
          hum := TUserHuman(prank.MemList.Objects[k]);
          if hum <> nil then begin
            //Ư�� �̸� ����
            if hum.UserName <> nameexcept then begin
              if hum.BoHearGuildMsg then
                hum.SendMsg(hum, RM_GUILDMESSAGE, 0, 0, 0, 0, str);
            end;
          end;
        end;
      end;
    end;
  end;
end;


function TGuild.UpdateGuildRankStr(rankstr: string): integer;

  procedure FreeMembs(var memb: TList);
  var
    i, k: integer;
  begin
    for i := 0 to memb.Count - 1 do begin
      PTGuildRank(memb[i]).MemList.Free;
      Dispose(PTGuildRank(memb[i]));
    end;
    memb.Free;
  end;

var
  nmembs: TList;
  pgr, pgr2: PTGuildRank;
  i, j, k, m, oldcount, newcount: integer;
  Data, s1, s2, mname: string;
  flag: boolean;
  hum: TUserHuman;
begin
  Result := -1;
  //�Ľ� -> pgr�� ����Ʈ�� �����.
  nmembs := TList.Create;
  pgr    := nil;
  while True do begin
    if rankstr = '' then
      break;
    rankstr := GetValidStr3(rankstr, Data, [#13]);
    Data    := Trim(Data);
    if Data <> '' then begin
      if Data[1] = '#' then begin
        Data := Copy(Data, 2, length(Data) - 1);
        Data := GetValidStr3(Data, s1, [' ', '<']);
        Data := GetValidStr3(Data, s2, ['<', '>']);
        if pgr <> nil then
          nmembs.Add(pgr);
        new(pgr);
        pgr.Rank     := Str_ToInt(s1, 99);
        pgr.RankName := Trim(s2);
        //��å�� ����ִ� ��츦 ���´�.(sonmg 2004/08/16)
        if pgr.RankName = '' then begin
          Result := -7;
          exit;
        end;
        pgr.MemList := TStringList.Create;
      end else begin
        if pgr <> nil then
          for i := 0 to 9 do begin
            if Data = '' then
              break;
            Data := GetValidStr3(Data, mname, [' ', ',']);
            if mname <> '' then
              pgr.MemList.Add(mname);
          end;
      end;
    end;
  end;
  if pgr <> nil then
    nmembs.Add(pgr);


  //���� ������ ��Ȯ�� ������ �� �̻� ó�� ����.
  if MemberList <> nil then begin
    if MemberList.Count = nmembs.Count then begin
      flag := True;
      for i := 0 to MemberList.Count - 1 do begin
        pgr  := PTGuildRank(MemberList[i]);
        pgr2 := PTGuildRank(nmembs[i]);
        if (pgr.Rank = pgr2.Rank) and (pgr.RankName = pgr2.RankName) and
          (pgr.MemList.Count = pgr2.MemList.Count) then begin
          for k := 0 to pgr.MemList.Count - 1 do begin
            if pgr.MemList[k] <> pgr2.MemList[k] then begin
              flag := False;  //�ٸ�
              break;
            end;
          end;
        end else begin
          flag := False; //�ٸ�
          break;
        end;
      end;
      if flag then begin
        Result := -1;  //������ ��Ȯ�� �� ����.
        FreeMembs(nmembs);
        exit;
      end;
    end;
  end;


  //���ְ� ����������ȵ�.
  Result := -2;  //���ְ� ���� ����.
  if nmembs.Count > 0 then begin
    if PTGuildRank(nmembs[0]).Rank = 1 then begin
      if PTGuildRank(nmembs[0]).RankName <> '' then begin
        Result := 0; //����
      end else
        Result := -3; //������ ��Ī�� ����.
    end;
  end;


  //���� ���ְ� ����Ǵ� ���, ���� ����� ����� �����ϰ� �־�� �Ѵ�.
  //������ ���� 2���� �ʰ� ����
  if Result = 0 then begin
    pgr := PTGuildRank(nmembs[0]);
    if pgr.MemList.Count <= 2 then begin
      m := pgr.MemList.Count;
      for i := 0 to pgr.MemList.Count - 1 do begin
        if UserEngine.GetUserHuman(pgr.MemList[i]) = nil then begin
          Dec(m);
          break;
        end;
      end;
      if m <= 0 then
        Result := -5;  //��� �Ѹ��� ���ְ� �����ϰ� �־�� �Ѵ�.
    end else
      Result := -4; //���� 2�� �ʰ� ����
  end;


  //��� ������ �߰�,���� �Ǿ� ���� �ʾƾ� �Ѵ�.
  if Result = 0 then begin
    oldcount := 0;
    newcount := 0;
    //���κ���� ����Ʈ�� ��������Ʈ�� ����
    for i := 0 to MemberList.Count - 1 do begin
      pgr  := PTGuildRank(MemberList[i]);
      flag := True;
      for j := 0 to pgr.MemList.Count - 1 do begin
        flag  := False;
        mname := pgr.MemList[j];
        Inc(oldcount);

        for k := 0 to nmembs.Count - 1 do begin
          pgr2 := PTGuildRank(nmembs[k]);
          for m := 0 to pgr2.MemList.Count - 1 do begin
            if mname = pgr2.MemList[m] then begin
              flag := True;
              break;
            end;
          end;
          if flag then
            break;
        end;

        if not flag then begin
          Result := -6; //��������Ʈ�� ��ġ���� ����.
          break;
        end;
      end;
      if not flag then
        break;
    end;

    //�ٽ��ѹ� �Ųٷ� ���Ѵ�.
    for i := 0 to nmembs.Count - 1 do begin
      pgr  := PTGuildRank(nmembs[i]);
      flag := True;
      for j := 0 to pgr.MemList.Count - 1 do begin
        flag  := False;
        mname := pgr.MemList[j];
        Inc(newcount);

        for k := 0 to MemberList.Count - 1 do begin
          pgr2 := PTGuildRank(MemberList[k]);
          for m := 0 to pgr2.MemList.Count - 1 do begin
            if mname = pgr2.MemList[m] then begin
              flag := True;
              break;
            end;
          end;
          if flag then
            break;
        end;

        if not flag then begin
          Result := -6; //��������Ʈ�� ��ġ���� ����.
          break;
        end;
      end;
      if not flag then
        break;
    end;

    if Result = 0 then
      if oldcount <> newcount then begin
        Result := -6;  //��������Ʈ�� ��ġ���� ���� .
      end;

  end;


  //��å�� �ߺ����� �ʾҴ��� �˻�.
  if Result = 0 then begin
    for i := 0 to nmembs.Count - 1 do begin
      m := PTGuildRank(nmembs[i]).Rank;
      for k := i + 1 to nmembs.Count - 1 do begin
        if (m = PTGuildRank(nmembs[k]).Rank) or (m <= 0) or (m > 99) then begin
          Result := -7; //��å �ߺ�
          break;
        end;
      end;
      if Result <> 0 then
        break;
    end;
  end;


  //���� -> �����ϰ� �ִ� ��� �������� ��å�� ��å���� �����ش�.
  if Result = 0 then begin
    FreeMembs(MemberList); //������ Free��Ŵ
    MemberList := nmembs;
    for i := 0 to MemberList.Count - 1 do begin
      pgr := PTGuildRank(MemberList[i]);
      for k := 0 to pgr.MemList.Count - 1 do begin
        hum := UserEngine.GetUserHuman(pgr.MemList[k]);
        if hum <> nil then begin
          pgr.MemList.Objects[k] := hum;
          hum.GuildRankChanged(pgr.Rank, pgr.RankName);
        end;
      end;
    end;
    GuildInfoChange;
  end else
    FreeMembs(nmembs);
end;

function TGuild.IsHostileGuild(aguild: TGuild): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to KillGuilds.Count - 1 do begin
    if PTGuildWarInfo(KillGuilds.Objects[i]).WarGuild = aguild then begin
      Result := True;
      break;
    end;
  end;
end;

function TGuild.DeclareGuildWar(aguild: TGuild;
  var backresult: boolean): PTGuildWarInfo;
var
  i:   integer;
  pgw: PTGuildWarInfo;
begin
  Result     := nil;
  backresult := False;
  if aguild <> nil then begin
    if not IsAllyGuild(aguild) then begin
      pgw := nil;
      for i := 0 to KillGuilds.Count - 1 do begin
        if PTGuildWarInfo(KillGuilds.Objects[i]).WarGuild = aguild then begin
          pgw := PTGuildWarInfo(KillGuilds.Objects[i]);
          if pgw <> nil then begin
            // 12�ð� ����
            if pgw.WarRemain < 12 * 60 * 60 * 1000 then begin
              //pgw.WarStartTime := GetTickCount;
              //������ ���� ����(sonmg 2005/08/05)
              pgw.WarRemain := pgw.WarRemain + 3 * 60 * 60 * 1000;
              GuildMsg('***' + aguild.GuildName +
                'Guild war was extended  for 3 hours .');
              backresult := True;
              break;
            end;
          end;
        end;
      end;
      if pgw = nil then begin
        new(pgw);
        pgw.WarGuild     := aguild;
        pgw.WarStartTime := GetTickCount;
        pgw.WarRemain    := 3 * 60 * 60 * 1000;
        KillGuilds.AddObject(aguild.GuildName, TObject(pgw));
        GuildMsg('***' + aguild.GuildName + 'Guild war started (for 3 hours)');
        backresult := True;
      end;
      Result := pgw;
    end;
  end;
  MemberNameChanged;
  GuildInfoChange;
end;

procedure TGuild.CanceledGuildWar(aguild: TGuild);
begin
  GuildMsg('***' + aguild.GuildName + 'Guild war ended.');
end;

function TGuild.IsAllyGuild(aguild: TGuild): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to AllyGuilds.Count - 1 do begin
    if AllyGuilds.Objects[i] = aguild then begin
      Result := True;
      exit;
    end;
  end;
end;

function TGuild.MakeAllyGuild(aguild: TGuild): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to AllyGuilds.Count - 1 do begin
    if AllyGuilds.Objects[i] = aguild then begin  //�ߺ��˻�
      exit;
    end;
  end;
  AllyGuilds.AddObject(aguild.GuildName, aguild);
  SaveGuild;
end;

function TGuild.CanAlly(aguild: TGuild): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to KillGuilds.Count - 1 do begin
    if PTGuildWarInfo(KillGuilds.Objects[i]).WarGuild = aguild then
    begin  //�������̸� ������ ���Ѵ�.
      exit;
    end;
  end;
  Result := True;
end;

function TGuild.BreakAlly(aguild: TGuild): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to AllyGuilds.Count - 1 do begin
    if TGuild(AllyGuilds.Objects[i]) = aguild then begin  //�������̸�
      AllyGuilds.Delete(i);
      Result := True;
      break;
    end;
  end;
  SaveGuild;
end;



//���� ��� ���� �Լ�

procedure TGuild.TeamFightStart;
begin
  MatchPoint := 0;
  BoStartGuildFight := True;
  FightMemberList.Clear;
end;

procedure TGuild.TeamFightEnd;
begin
  BoStartGuildFight := False;
end;

procedure TGuild.TeamFightAdd(whostr: string);
begin
  FightMemberList.Add(whostr);
end;

procedure TGuild.TeamFightWhoWinPoint(whostr: string; point: integer);
var
  i, n: integer;
begin
  if BoStartGuildFight then begin  //������ �߿��� ������ �ö󰣴�.
    MatchPoint := MatchPoint + point;
    for i := 0 to FightMemberList.Count - 1 do
      if FightMemberList[i] = whostr then begin
        n := integer(FightMemberList.Objects[i]);
        //Loword: dead count, Hiword: win point
        FightMemberList.Objects[i] := TObject(MakeLong(Loword(n), Hiword(n) + point));
      end;
  end;
end;

procedure TGuild.TeamFightWhoDead(whostr: string);
var
  i, n: integer;
begin
  if BoStartGuildFight then begin  //������ �߿��� ��ϵȴ�.
    for i := 0 to FightMemberList.Count - 1 do
      if FightMemberList[i] = whostr then begin
        n := integer(FightMemberList.Objects[i]);
        //Loword: dead count, Hiword: win point
        FightMemberList.Objects[i] := TObject(MakeLong(Loword(n) + 1, Hiword(n)));
      end;
  end;
end;

function TGuild.GetTotalMemberCount: integer;
var
  i: integer;
begin
  Result := 0;

  // ���ָ� ������ ��� ���Ŀ��� ���� �˷���.
  if MemberList <> nil then begin
    for i := 0 to MemberList.Count - 1 do begin
      Result := Result + PTGuildRank(MemberList[i]).MemList.Count;
    end;
  end;
end;


{-------------------------------------------------------------------}



constructor TGuildManager.Create;
begin
  inherited Create;
  GuildList := TList.Create;
end;

destructor TGuildManager.Destroy;
begin
  GuildList.Free;
  inherited Destroy;
end;

procedure TGuildManager.ClearGuildList;
var
  i: integer;
begin
  for i := 0 to GuildList.Count - 1 do
    TGuild(GuildList[i]).Free;
  GuildList.Clear;
end;

procedure TGuildManager.LoadGuildList;
var
  strlist: TStringList;
  i:     integer;
  gname: string;
  guild: TGuild;
begin
  if FileExists(GuildFile) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(GuildFile);
    for i := 0 to strlist.Count - 1 do begin
      gname := Trim(strlist[i]);
      if gname <> '' then begin
        guild := TGuild.Create(gname);
        GuildList.Add(guild);
      end;
    end;
    strlist.Free;
    for i := 0 to GuildList.Count - 1 do begin
      if not TGuild(GuildList[i]).LoadGuild then
        MainOutMessage(TGuild(GuildList[i]).GuildName +
          ' Information reading failure.');
    end;
    MainOutMessage('Guild information ' + IntToStr(GuildList.Count) + ' read .');
  end else
    MainOutMessage('no guild file loaded...');
end;

procedure TGuildManager.SaveGuildList;
var
  strlist: TStringList;
  i: integer;
begin
  if ServerIndex = 0 then begin  //������ ������ ������ �Ѵ�.
    strlist := TStringList.Create;
    for i := 0 to GuildList.Count - 1 do
      strlist.Add(TGuild(GuildList[i]).GuildName);
    try
      strlist.SaveToFile(GuildFile);
    except
      MainOutMessage(GuildFile + 'Saving error...');
    end;
    strlist.Free;
  end;
end;

function TGuildManager.GetGuild(gname: string): TGuild;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to GuildList.Count - 1 do begin
    if Uppercase(TGuild(GuildList[i]).GuildName) = Uppercase(gname) then begin
      Result := TGuild(GuildList[i]);
      break;
    end;
  end;
end;

function TGuildManager.GetGuildFromMemberName(who: string): TGuild;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to GuildList.Count - 1 do begin
    if TGuild(GuildList[i]).IsMember(who) then begin
      Result := TGuild(GuildList[i]);
      break;
    end;
  end;
end;

function TGuildManager.AddGuild(gname, mastername: string): boolean;
var
  guild: TGuild;
begin
  Result := False;
  if IsValidFileName(gname) then begin
    if GetGuild(gname) = nil then begin
      guild := TGuild.Create(gname);
      guild.AddGuildMaster(mastername);
      GuildList.Add(guild);
      SaveGuildList;
      Result := True;
    end;
  end;
end;

function TGuildManager.DelGuild(gname: string): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to GuildList.Count - 1 do begin
    if TGuild(GuildList[i]).GuildName = gname then begin
      if TGuild(GuildList[i]).MemberList.Count <= 1 then begin
        // ��� ��ȯ �� ���Ļ���.
        GuildAgitMan.DelGuildAgit(gname);

        TGuild(GuildList[i]).BreakGuild;
        //Guild�� �Ϻη� �޸𸮸� �������� ����
        //TGuild(GuildList[i]).Free;  //Free���� ��� �޸� ������ �����...
        GuildList.Delete(i);
        SaveGuildList;
        Result := True;
      end;
      break;
    end;
  end;
end;

procedure TGuildManager.CheckGuildWarTimeOut;
var
  i, k: integer;
  g:    TGuild;
  pgw:  PTGuildWarInfo;
  changed: boolean;
begin
  for i := 0 to GuildList.Count - 1 do begin
    g := TGuild(GuildList[i]);
    changed := False;
    for k := g.KillGuilds.Count - 1 downto 0 do begin
      pgw := PTGuildWarInfo(g.KillGuilds.Objects[k]);
      if GetTickCount - pgw.WarStartTime > pgw.WarRemain then begin
        g.CanceledGuildWar(pgw.WarGuild);
        g.KillGuilds.Delete(k);
        Dispose(pgw);
        changed := True;
      end;
    end;
    if changed then
      g.GuildInfoChange;
  end;
end;


 {-------------------------------------------------------------------}
 // TGuildAgit

constructor TGuildAgit.Create;
begin
  inherited Create;
  InitGuildAgitRecord;
end;

destructor TGuildAgit.Destroy;
begin
  inherited Destroy;
end;

procedure TGuildAgit.InitGuildAgitRecord;
begin
  if self = nil then
    exit;

  GuildAgitNumber := -1;
  GuildName      := '';
  GuildMasterName := '';
  GuildMasterNameSecond := '';
  RegistrationTime := '';
  ContractPeriod := -1;
  GuildAgitTotalGold := 0;

  ForSaleFlag      := 0;
  ForSaleMoney     := 0;
  ForSaleWait      := 0;
  ForSaleGuildName := '';
  ForSaleGuildMasterName := '';
  ForSaleTime      := '';
end;

procedure TGuildAgit.SetGuildAgitRecord(agitnumber: integer;
  gname, mastername, regtime: string; period, agittotalgold: integer);
var
  aguild: TGuild;
begin
  if self = nil then
    exit;

  GuildAgitNumber := agitnumber;
  GuildName      := gname;
  GuildMasterName := mastername;
  GuildMasterNameSecond := '';
  RegistrationTime := regtime;
  ContractPeriod := period;
  GuildAgitTotalGold := agittotalgold;

  // �ι�° ���� ��� ����.
  aguild := GuildMan.GetGuild(gname);
  if aguild <> nil then begin
    GuildMasterNameSecond := aguild.GetAnotherGuildMaster;
  end;
end;

procedure TGuildAgit.SetGuildAgitForSaleRecord(saleflag, salemoney, salewait: integer;
  salegname, salemastername, saletime: string);
begin
  if self = nil then
    exit;

  ForSaleFlag      := saleflag;
  ForSaleMoney     := salemoney;
  ForSaleWait      := salewait;
  ForSaleGuildName := salegname;
  ForSaleGuildMasterName := salemastername;
  ForSaleTime      := saletime;
end;

function TGuildAgit.AddGuildAgitRecord(nextnumber: integer;
  gname, mastername, secondmastername: string): boolean;
var
  RegDateTime: TDateTime;
  //   RegDate, RegTime : TDateTime;
  //   Year, Month, Day : Word;
  //   Hour, Min, Sec, MSec : Word;
begin
  Result := True;

  if self = nil then begin
    Result := False;
    exit;
  end;

  RegDateTime      := Now;
  RegistrationTime := ConvertDatetimeToString(RegDateTime);

  GuildAgitNumber := nextnumber;
  GuildName      := gname;
  GuildMasterName := mastername;
  GuildMasterNameSecond := secondmastername;
  ContractPeriod := GUILDAGIT_DAYUNIT; //7��(�⺻����)
  // ��� ��α�
  GuildAgitTotalGold := 0;
end;

function TGuildAgit.GetGuildAgitRemainDateTime: TDateTime;
var
  regdatetime, regdate, regtime: TDateTime;
  //   nowdatetime, nowdate, nowtime : TDateTime;
  enddatetime, enddate, endtime: TDateTime;
  remaindatetime, remaindate, remaintime: TDateTime;
  //   str, data: string;
  //   Year, Month, Day : Word;
  //   Hour, Min, Sec, MSec : Word;
  //   RemainSeconds : integer;
begin
  Result := -100;

  if self = nil then
    exit;

  regdatetime := ConvertStringToDatetime(RegistrationTime);

  // ������ ���
{$IFNDEF UNDEF_DEBUG}//sonmg
  enddatetime := regdatetime + ContractPeriod;
{$ELSE}
   enddatetime := regdatetime + (ContractPeriod/60/24);
{$ENDIF}

  // �����ð� = ������ - ����ð�.
  remaindatetime := enddatetime - Now;

  Result := remaindatetime;
end;

procedure TGuildAgit.ExpulsionMembers;
var
  list: TList;
  cret: TCreature;
  i, j, ix, iy: integer;
  env:  TEnvirnoment;
begin
  if self = nil then
    exit;

  try
    list := TList.Create;
    // ��� �� ��ü ��ǥ�� �˻��Ͽ� �� ��ǥ�� �ִ�
    // ��� �������� ������ ��ҷ� ���� �̵���Ų��.
    for i := 0 to 3 do begin
      env := GrobalEnvir.GetEnvir(GuildAgitMan.GuildAgitMapName[i] +
        IntToStr(GuildAgitNumber));
      if env <> nil then begin
        for ix := 0 to env.MapWidth - 1 do begin
          for iy := 0 to env.MapHeight - 1 do begin
            list.Clear;
            env.GetAllCreature(ix, iy, True, list);

            for j := 0 to list.Count - 1 do begin
              cret := TCreature(list[j]);
              if cret <> nil then begin
                if cret.RaceServer = RC_USERHUMAN then begin
                  //�߹�.
                  cret.SendRefMsg(RM_SPACEMOVE_HIDE, 0, 0, 0, 0, '');
                  //                           cret.SpaceMove (GuildAgitMan.ReturnMapName, GuildAgitMan.ReturnX, GuildAgitMan.ReturnY, 0); //�����̵�
                  cret.UserSpaceMove(cret.HomeMap,
                    IntToStr(cret.HomeX), IntToStr(cret.HomeY));
                  cret.SysMsg(
                    'Your guild has been expelled due to rent term expiration.', 0);
                end;
              end;
            end;
          end;
        end;
      end;
    end;
    list.Free;
  except
    MainOutMessage('[Exception]TGuildAgit.ExpulsionMembers');
  end;
end;

function TGuildAgit.IsExpired: boolean;
begin
  Result := False;

  if self = nil then begin
    Result := True;
    exit;
  end;

{$IFNDEF UNDEF_DEBUG}//sonmg
  if GetGuildAgitRemainDateTime <= -GUILDAGIT_DAYUNIT then begin
{$ELSE}
   if GetGuildAgitRemainDateTime <= -(GUILDAGIT_DAYUNIT / 60 / 24) then begin
{$ENDIF}
    Result := True;
  end;
end;

function TGuildAgit.GetCurrentDelayStatus: integer;
var
  RemainDateTime: TDateTime;
begin
  //�������
  Result := 1;

  if self = nil then begin
    Result := -1;
    exit;
  end;

  RemainDateTime := GetGuildAgitRemainDateTime;

  if RemainDateTime < 0 then begin
    //��ü����
    Result := 0;
{$IFNDEF UNDEF_DEBUG}//sonmg
    if RemainDateTime <= -GUILDAGIT_DAYUNIT then begin
{$ELSE}
      if RemainDateTime <= -(GUILDAGIT_DAYUNIT / 60 / 24) then begin
{$ENDIF}
      //��������
      Result := -1;
    end;
  end;
end;

function TGuildAgit.GetGuildAgitRegDateTime: TDateTime;
var
  regdatetime: TDateTime;
begin
  Result := -100;

  if self = nil then
    exit;

  regdatetime := ConvertStringToDatetime(RegistrationTime);

  Result := regdatetime;
end;

function TGuildAgit.ConvertStringToDatetime(datestring: string): TDateTime;
var
  regdatetime, regdate, regtime: TDateTime;
  str, Data: string;
  Year, Month, Day: word;
  Hour, Min, Sec, MSec: word;
begin
  Result := -100;

  try
    str := datestring;

    str   := GetValidStr3(str, Data, ['.', ':']);
    Year  := Str_ToInt(Data, 0);
    str   := GetValidStr3(str, Data, ['.', ':']);
    Month := Str_ToInt(Data, 0);
    str   := GetValidStr3(str, Data, ['.', ':']);
    Day   := Str_ToInt(Data, 0);
    str   := GetValidStr3(str, Data, ['.', ':']);
    Hour  := Str_ToInt(Data, 0);
    str   := GetValidStr3(str, Data, ['.', ':']);
    Min   := Str_ToInt(Data, 0);
    str   := GetValidStr3(str, Data, ['.', ':']);
    Sec   := Str_ToInt(Data, 0);
    str   := GetValidStr3(str, Data, ['.', ':']);
    MSec  := Str_ToInt(Data, 0);

    // �����
    regdate := Trunc(EncodeDate(Year, Month, Day));
    regtime := EncodeTime(Hour, Min, Sec, MSec);

    regdatetime := regdate + regtime;

    //      ReplaceDate(regdatetime, regdate);
    //      ReplaceTime(regdatetime, regtime);

    Result := regdatetime;
  except
    MainOutMessage('[Exception]TGuildAgit.ConvertStringToDatetime');
  end;
end;

function TGuildAgit.ConvertDateTimeToString(datetime: TDateTime): string;
var
  Year, Month, Day:     word;
  Hour, Min, Sec, MSec: word;
begin
  Result := '';

  try
    DecodeDate(datetime, Year, Month, Day);
    DecodeTime(datetime, Hour, Min, Sec, MSec);

    Result := IntToStr(Year) + '.' + IntToStr(Month) + '.' +
      IntToStr(Day) + '.' + IntToStr(Hour) + ':' + IntToStr(Min) +
      ':' + IntToStr(Sec);
  except
    MainOutMessage('[Exception]TGuildAgit.ConvertDateTimeToString');
  end;
end;

function TGuildAgit.IsForSale: boolean;
begin
  Result := False;

  // �÷��װ� 1�̰�, ���Խ�û���İ� ������ TRUE
  if (ForSaleFlag = 1) and (ForSaleGuildName = '') then begin
    Result := True;
  end;
end;

function TGuildAgit.IsSoldOut: boolean;
begin
  Result := False;

  // �÷��װ� 0�̰�, ���Խ�û���İ� ������ �ŷ� ����� ���
  if (ForSaleFlag = 0) and (ForSaleGuildName <> '') then begin
    Result := True;
  end;
end;

function TGuildAgit.IsSoldOutExpired: boolean;
var
  SaleDateTime: TDateTime;
begin
  Result := False;

  // �ŷ��� ����� ����߿���
  if IsSoldOut then begin
    // ���� �ð��� �ǸŽð� + ForSaleWait ���� �������� Expired
    SaleDateTime := ConvertStringToDatetime(ForSaleTime);
{$IFNDEF UNDEF_DEBUG}//sonmg
    if Now > SaleDateTime + ForSaleWait then begin
{$ELSE}
      if Now > SaleDateTime + (ForSaleWait / 24 / 60) then begin
{$ENDIF}
      Result := True;
    end;
  end;
end;

procedure TGuildAgit.ResetForSaleFields;
begin
  ForSaleFlag      := 0;
  ForSaleMoney     := 0;
  ForSaleWait      := 0;
  ForSaleGuildName := '';
  ForSaleGuildMasterName := '';
  ForSaleTime      := '';
end;

function TGuildAgit.ChangeGuildAgitMaster: boolean;
var
  RemainDateTime: TDateTime;
  RemainYear, RemainMonth, RemainDay: word;
begin
  Result := False;

  if (ForSaleGuildName = '') or (ForSaleGuildMasterName = '') then
    exit;

  // ���� ����� ���� �뿩�Ⱓ
  RemainDateTime := GetGuildAgitRemainDateTime;

  // ��� ���ĸ� �� ���ķ� ��ü
  GuildName := ForSaleGuildName;
  // ��� ���ָ� �� ���ַ� ��ü
  GuildMasterName := ForSaleGuildMasterName;
  GuildMasterNameSecond := '';
  // ����� ����(����ð�)
  RegistrationTime := ConvertDateTimeToString(Now);
  // �뿩�Ⱓ �ʱ�ȭ
  //   ContractPeriod := GUILDAGIT_DAYUNIT;
  // �뿩�Ⱓ : 7�� �̻� �������� 7�Ϸ� �ʱ�ȭ, 7�� �����̸� �״�� ����(?)
  if RemainDateTime <= 0 then begin
    ContractPeriod := 0;
    //   end else if RemainDateTime >= GUILDAGIT_DAYUNIT then begin
    //      ContractPeriod := GUILDAGIT_DAYUNIT;
  end else begin
    // ���� �Ⱓ �ݿø�
    ContractPeriod := Round(RemainDateTime);
  end;
  // ��� ��α�(�ʱ�ȭ? or �״�� �ΰ�?)
  GuildAgitTotalGold := GuildAgitTotalGold;//0;

  Result := True;
end;

function TGuildAgit.UpdateGuildMaster: string;
var
  gname:  string;
  aguild: TGuild;
begin
  // ���ָ� ���� ���ַ� �ֽ�ȭ��Ų��.
  if GuildName <> '' then begin
    aguild := GuildMan.GetGuild(GuildName);
    if aguild <> nil then begin
      GuildMasterName := aguild.GetGuildMaster;
      GuildMasterNameSecond := aguild.GetAnotherGuildMaster;
    end;
  end;
end;


 {-------------------------------------------------------------------}
 // TGuildAgitManager

constructor TGuildAgitManager.Create;
var
  i: integer;
begin
  inherited Create;

  //���� ����
  GuildAgitFileVersion := 0;
  //��� ���
  GuildAgitList   := TList.Create;
  //����ٹ̱�
  AgitDecoMonList := TList.Create;

  // �⺻ �� �̸� �ʱ�ȭ.
  GuildAgitMapName[0] := 'GA0';
  GuildAgitMapName[1] := 'GA1';
  GuildAgitMapName[2] := 'GA2';
  GuildAgitMapName[3] := 'GA3';

  // ������ ��, ��ǥ
  ReturnMapName := '0';
  ReturnX := 333;
  ReturnY := 276;

  // �Ա� ��ǥ
  EntranceX := 119;
  EntranceY := 122;

  // ����ٹ̱� ������Ʈ ���� �ʱ�ȭ
  for i := 1 to MAXGUILDAGITCOUNT do
    AgitDecoMonCount[i] := 0;
end;

destructor TGuildAgitManager.Destroy;
var
  i: integer;
begin
  GuildAgitList.Free;
  //����ٹ̱�
  for i := 0 to AgitDecoMonList.Count - 1 do
    Dispose(PTAgitDecoItem(AgitDecoMonList[i]));
  AgitDecoMonList.Free;

  inherited Destroy;
end;

procedure TGuildAgitManager.ClearGuildAgitList;
var
  i: integer;
begin
  for i := 0 to GuildAgitList.Count - 1 do
    TGuildAgit(GuildAgitList[i]).Free;
  GuildAgitList.Clear;
end;

procedure TGuildAgitManager.LoadGuildAgitList;
var
  strlist: TStringList;
  i: integer;
  str, Data: string;
  guildagit: TGuildAgit;

  agitnumber, period: integer;
  gname, mastername, regtime: string;
  saleflag, salemoney, salewait: integer;
  salegname, salemastername, saletime: string;
  agittotalgold:      integer;
begin
  agittotalgold := 0;

  if FileExists(GuildAgitFile) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(GuildAgitFile);
    for i := 0 to strlist.Count - 1 do begin
      str := strlist[i];
      //���� ���� Ȯ��
      if i = 0 then begin
        str := Trim(str);
        if str[1] = '[' then begin
          str := GetValidStr3(str, Data, ['=', '[', ' ', ',', #9]);
          if UPPERCASE(Data) = 'VERSION' then begin
            str := GetValidStr3(str, Data, ['=', '[', ']', ' ', ',', #9]);
            GuildAgitFileVersion := Str_ToInt(Data, 0);
            continue;
          end;
        end;
      end;
      if str = '' then
        continue;
      if str[1] = ';' then
        continue;
      str := GetValidStr3(str, Data, [' ', ',', #9]);
      agitnumber := Str_ToInt(Data, 0);

      if Data = '' then
        continue;

      str     := GetValidStr3(str, Data, [' ', ',', #9]);
      gname   := Data;
      str     := GetValidStr3(str, Data, [' ', ',', #9]);
      mastername := Data;
      str     := GetValidStr3(str, Data, [' ', ',', #9]);
      regtime := Data;
      str     := GetValidStr3(str, Data, [' ', ',', #9]);
      period  := Str_ToInt(Data, 0);
      // ��� ��α�
      if GuildAgitFileVersion = 1 then begin
        str := GetValidStr3(str, Data, [' ', ',', #9]);
        agittotalgold := Str_ToInt(Data, 0);
      end;

      if Data = '' then begin
        MainOutMessage('GuildAgitList ' + IntToStr(i) + 'th Line is error.');
        continue; //��� ���� ����.
      end;

      // ���Թ�������
      str      := GetValidStr3(str, Data, [' ', ',', #9]);
      saleflag := Str_ToInt(Data, 0);
      str      := GetValidStr3(str, Data, [' ', ',', #9]);
      salemoney := Str_ToInt(Data, -1);
      str      := GetValidStr3(str, Data, [' ', ',', #9]);
      salewait := Str_ToInt(Data, 0);
      str      := GetValidStr3(str, Data, [' ', ',', #9]);
      salegname := Data;
      str      := GetValidStr3(str, Data, [' ', ',', #9]);
      salemastername := Data;
      str      := GetValidStr3(str, Data, [' ', ',', #9]);
      saletime := Data;

      if agitnumber > -1 then begin
        guildagit := TGuildAgit.Create;
        if guildagit <> nil then begin
          guildagit.SetGuildAgitRecord(agitnumber, gname, mastername,
            regtime, period, agittotalgold);
          guildagit.SetGuildAgitForSaleRecord(saleflag, salemoney,
            salewait, salegname, salemastername, saletime);
          GuildAgitList.Add(guildagit);
        end;
      end;
    end;
    strlist.Free;
    MainOutMessage(IntToStr(GuildAgitList.Count) + ' guildagits are loaded.');

    // ������ �� ���� üũ 0�̸� 1�� �ø��� ���� ��� �� ������
    if GuildAgitFileVersion <= 0 then
      GuildAgitMan.SaveGuildAgitList(True);
  end else
    MainOutMessage('No guildagit file loaded...');
end;

procedure TGuildAgitManager.SaveGuildAgitList(bBackup: boolean);
var
  strlist: TStringList;
  i: integer;
begin
  if ServerIndex = 0 then begin  //������ ������ ������ �Ѵ�.
    //���
    if bBackup then begin
      FileCopy(GuildAgitFile, GuildAgitFile + ConvertDatetimeToFileName(Now));
    end;

    strlist := TStringList.Create;

    //���� ���� ������Ʈ
    if GuildAgitFileVersion <= 0 then
      GuildAgitFileVersion := 1;

    //��� ��� ���� ���� ���
    strlist.Add('[VERSION=' + IntToStr(GuildAgitFileVersion) + ']');
    //�׸� ����
    strlist.Add(
      ';Territory no.|Guild name|Guild master|Reg Date|Remain days|Territory gold|On sale|Sale gold|Sale remain days|Buy Guild name|Buy Guild master|Conclusion date');

    if GuildAgitFileVersion <= 0 then begin
      for i := 0 to GuildAgitList.Count - 1 do
        strlist.Add(IntToStr(TGuildAgit(GuildAgitList[i]).GuildAgitNumber) +
          #9 + TGuildAgit(GuildAgitList[i]).GuildName + #9 +
          TGuildAgit(GuildAgitList[i]).GuildMasterName + #9 +
          TGuildAgit(GuildAgitList[i]).RegistrationTime + #9 +
          IntToStr(TGuildAgit(GuildAgitList[i]).ContractPeriod) + #9 +
          // ���Թ��� ����
          IntToStr(TGuildAgit(GuildAgitList[i]).ForSaleFlag) +
          #9 + IntToStr(TGuildAgit(GuildAgitList[i]).ForSaleMoney) +
          #9 + IntToStr(TGuildAgit(GuildAgitList[i]).ForSaleWait) +
          #9 + TGuildAgit(GuildAgitList[i]).ForSaleGuildName +
          #9 + TGuildAgit(GuildAgitList[i]).ForSaleGuildMasterName +
          #9 + TGuildAgit(GuildAgitList[i]).ForSaleTime
          );
    end else begin
      for i := 0 to GuildAgitList.Count - 1 do
        strlist.Add(IntToStr(TGuildAgit(GuildAgitList[i]).GuildAgitNumber) +
          #9 + TGuildAgit(GuildAgitList[i]).GuildName + #9 +
          TGuildAgit(GuildAgitList[i]).GuildMasterName + #9 +
          TGuildAgit(GuildAgitList[i]).RegistrationTime + #9 +
          IntToStr(TGuildAgit(GuildAgitList[i]).ContractPeriod) + #9 +
          // ��� ��α�
          IntToStr(TGuildAgit(GuildAgitList[i]).GuildAgitTotalGold) + #9 +
          // ���Թ��� ����
          IntToStr(TGuildAgit(GuildAgitList[i]).ForSaleFlag) +
          #9 + IntToStr(TGuildAgit(GuildAgitList[i]).ForSaleMoney) +
          #9 + IntToStr(TGuildAgit(GuildAgitList[i]).ForSaleWait) +
          #9 + TGuildAgit(GuildAgitList[i]).ForSaleGuildName +
          #9 + TGuildAgit(GuildAgitList[i]).ForSaleGuildMasterName +
          #9 + TGuildAgit(GuildAgitList[i]).ForSaleTime
          );
    end;

    try
      strlist.SaveToFile(GuildAgitFile);
    except
      MainOutMessage(GuildAgitFile + ' Saving error...');
    end;
    strlist.Free;
  end;
end;

function TGuildAgitManager.GetGuildAgit(gname: string): TGuildAgit;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to GuildAgitList.Count - 1 do begin
    if TGuildAgit(GuildAgitList[i]).GuildName = gname then begin
      Result := TGuildAgit(GuildAgitList[i]);
      break;
    end;
  end;
end;

// ���ϰ� : �����ȣ (-1 �̸� Error)
function TGuildAgitManager.AddGuildAgit(gname, mastername, secondmastername:
  string): integer;
var
  guildagit:  TGuildAgit;
  nextnumber: integer;
begin
  Result := -1;
  //   if IsValidFileName (gname) then begin   //����Ư������ ���ܱ�� ����(2004/11/05)
  if GetGuildAgit(gname) = nil then begin
    //������� ��������.
    if GuildAgitList.Count >= GuildAgitMaxNumber then
      exit;

    guildagit  := TGuildAgit.Create;
    nextnumber := GetNextGuildAgitNumber;
    if guildagit.AddGuildAgitRecord(nextnumber, gname, mastername,
      secondmastername) then begin
      GuildAgitList.Add(guildagit);
      SaveGuildAgitList(False);
      Result := nextnumber;
    end;
  end;
  //   end;
end;

function TGuildAgitManager.DelGuildAgit(gname: string): boolean;
var
  guildagit:     TGuildAgit;
  i, nextnumber: integer;
begin
  Result := False;
  for i := 0 to GuildAgitList.Count - 1 do begin
    guildagit := TGuildAgit(GuildAgitList[i]);
    if guildagit <> nil then begin
      if guildagit.GuildName = gname then begin
        //�߹�.
        guildagit.ExpulsionMembers;

        //Guild�� �Ϻη� �޸𸮸� �������� ����(why?)
        guildagit.Free;  //Free���� ��� �޸� ������ �����...
        GuildAgitList.Delete(i);
        SaveGuildAgitList(True);
        Result := True;
        break;
      end;
    end;
  end;
end;

function TGuildAgitManager.GetNextGuildAgitNumber: integer;
var
  i, j: integer;
begin
  Result := -1;
  if GuildAgitList.Count = 0 then begin
    Result := GuildAgitStartNumber;
    exit;
  end;

  for j := GuildAgitStartNumber to GuildAgitMaxNumber do begin
    for i := 0 to GuildAgitList.Count - 1 do begin
      if TGuildAgit(GuildAgitList[i]).GuildAgitNumber = j then
        break;
    end;
    // ��ȣ�� ������
    if i = GuildAgitList.Count then begin
      Result := j;
      exit;
    end;
  end;
end;

function TGuildAgitManager.CheckGuildAgitTimeOut(gaCount: integer): boolean;
var
  i: integer;
  SaveFlag: boolean;
  agitnumber: integer;
  guildagit: TGuildAgit;
begin
  Result     := False;
  SaveFlag   := False;
  agitnumber := -1;
  guildagit  := nil;

  // GuildAgitList���� �˻��Ͽ�
  // �ð��� 7�� ���� GuildAgit�� �����ϰ�
  // �׿� ���� ��ġ(��� ���� �ִ� ���Ŀ� �߹�)�� ���Ѵ�.
  for i := GuildAgitList.Count - 1 downto 0 do begin
    guildagit := TGuildAgit(GuildAgitList[i]);
    if gaCount = 0 then begin
      //10�п� �ѹ���
      //�ش� ������ ���ְ� �ٲ������ �˻��Ͽ� �ֽ�ȭ ��Ų��.
      guildagit.UpdateGuildMaster;
    end;

    // 1�п� �ѹ���
    // ��� ��α� - ��ü�� �Ǹ� ���� ��α��� �˻��Ͽ� �ڵ� ���� ��Ų��.
    if guildagit.GetCurrentDelayStatus <= 0 then begin
      if guildagit.GuildAgitTotalGold >= GUILDAGITEXTENDFEE then begin
        agitnumber := GuildAgitMan.ExtendTime(1, guildagit.GuildName);
        if agitnumber > -1 then begin
          guildagit.GuildAgitTotalGold :=
            guildagit.GuildAgitTotalGold - GUILDAGITEXTENDFEE;

          //�α׳���
          AddUserLog('38'#9 + //�忬��_
            'GUILDAGIT' + ''#9 + '0' + ''#9 + '0' + ''#9 +
            'AUTOEXTEND' + ''#9 + guildagit.GuildName + ''#9 +
            IntToStr(agitnumber) + ''#9 + '1'#9 + IntToStr(
            GUILDAGITEXTENDFEE));

          SaveFlag := True;

          UserEngine.SendInterMsg(ISM_RELOADGUILDAGIT, ServerIndex, '');
        end;
      end;
    end;

    //�뿩�Ⱓ�� ���� ����� �����ϱ� ���� ���� �ŷ� ����� ��� �߿���
    //�����Ⱓ�� ���� ����� ������ ��ü�Ѵ�.
    if guildagit.IsSoldOutExpired then begin
      guildagit.ChangeGuildAgitMaster;
      guildagit.ResetForSaleFields;

      //��� �� ���Ŀ� �߹�
      guildagit.ExpulsionMembers;

      SaveFlag := True;
      Result   := True;
    end;

    //�뿩�Ⱓ�� ���� ����� �����Ѵ�.
    if guildagit.IsExpired then begin
      //��� �� ���Ŀ� �߹�
      guildagit.ExpulsionMembers;

      //Guild�� �Ϻη� �޸𸮸� �������� ����(why?)
      guildagit.Free;  //Free���� ��� �޸� ������ �����...
      GuildAgitList.Delete(i);
      SaveFlag := True;
      Result   := True;
    end;
  end;

  if SaveFlag then
    SaveGuildAgitList(True);

end;

// ���ϰ� : �����ȣ (-1 �̸� Error)
function TGuildAgitManager.ExtendTime(Count: integer; gname: string): integer;
const
  LIMIT_DAY = 300;
var
  i: integer;
  guildagit: TGuildAgit;
  RegDateTime, NowDateTime: TDateTime;
  BackupFlag: boolean;
begin
  Result     := -1;
  BackupFlag := False;

  // �� ���� ������ �� �ִ� count�� 100���� ����.
  if (Count < 1) or (Count > 100) then
    exit;

  // GuildAgit�� ���´�.
  guildagit := GetGuildAgit(gname);

  if guildagit <> nil then begin
    // ������ ����(����)�� ����Ϸκ��� 300���� ���� ��쿡��
    // ������ڸ� ���������+300�Ϸ� �����ϰ�
    // ���Ⱓ�� �������Ⱓ-300�Ϸ� �����Ѵ�.
    RegDateTime := guildagit.GetGuildAgitRegDateTime;
    NowDateTime := Now;

    if NowDateTime - RegDateTime > LIMIT_DAY then begin
      if guildagit.ContractPeriod > LIMIT_DAY then begin
        RegDateTime := RegDateTime + LIMIT_DAY;
        guildagit.RegistrationTime :=
          guildagit.ConvertDatetimeToString(RegDateTime);
        guildagit.ContractPeriod := guildagit.ContractPeriod - LIMIT_DAY;
        BackupFlag  := True;
      end else begin
        exit;
      end;
    end else begin
      // �뿩�Ⱓ�� 365�Ϸ� ����.
      if guildagit.ContractPeriod + (Count * GUILDAGIT_DAYUNIT) > 365 then
        exit;
    end;

    // �뿩�Ⱓ�� count ��ŭ �����Ѵ�.
    guildagit.ContractPeriod := guildagit.ContractPeriod + (Count * GUILDAGIT_DAYUNIT);

    SaveGuildAgitList(BackupFlag);
    Result := guildagit.GuildAgitNumber;
  end;
end;

function TGuildAgitManager.GetRemainDateTime(gname: string): TDateTime;
var
  guildagit: TGuildAgit;
begin
  Result := -100;

  // GuildAgit�� ���´�.
  guildagit := GetGuildAgit(gname);
  if guildagit <> nil then
    Result := guildagit.GetGuildAgitRemainDateTime;
end;

//��� �ŷ� ����Ǿ��� �� ���� ���� �뿩 �Ⱓ�� ���Ѵ�.
function TGuildAgitManager.GetTradingRemainDate(gname: string): integer;
var
  guildagit: TGuildAgit;
begin
  Result := -100;

  // GuildAgit�� ���´�.
  guildagit := GetGuildAgit(gname);
  if guildagit <> nil then
    Result := Round(guildagit.GetGuildAgitRemainDateTime);
end;

function TGuildAgitManager.IsDelayed(gname: string): boolean;
var
  guildagit: TGuildAgit;
begin
  Result := False;

  // GuildAgit�� ���´�.
  guildagit := GetGuildAgit(gname);
  if guildagit <> nil then begin
    if guildagit.GetCurrentDelayStatus = 0 then
      Result := True;
  end;
end;

function TGuildAgitManager.ConvertDatetimeToFileName(datetime: TDateTime): string;
var
  Year, Month, Day:     word;
  Hour, Min, Sec, MSec: word;
begin
  Result := '.bak';

  DecodeDate(datetime, Year, Month, Day);
  DecodeTime(datetime, Hour, Min, Sec, MSec);

  Result := '.' + IntToStr(Year) + '_' + IntToStr(Month) + '_' +
    IntToStr(Day) + '_' + IntToStr(Hour) + '_' + IntToStr(Min) +
    '_' + IntToStr(Sec) + '.txt';
end;

procedure TGuildAgitManager.GetGuildAgitSaleList(var salelist: TStringList);
var
  guildagit: TGuildAgit;
  guild: TGuild;
  AnotherGuildMaster: string;
  i: integer;
  RemainDateTime: TDateTime;
  RemainDay: string;
  strStatus, strtemp: string;
begin
  salelist  := nil;
  strStatus := '';
  AnotherGuildMaster := '';

  for i := 0 to GuildAgitList.Count - 1 do begin
    guildagit := TGuildAgit(GuildAgitList[i]);

    strStatus := 'Normal';

    // ����� �Ǹ����̸�
    if guildagit.IsForSale then begin
      strStatus := 'On Sale';
    end else if guildagit.IsSoldOut then begin
      strStatus := 'Conclusion';
    end;

    if salelist = nil then
      salelist := TStringList.Create;

    RemainDateTime := guildagit.GetGuildAgitRemainDateTime;
    if RemainDateTime <= 0 then begin
      RemainDay := 'Arrear';
    end else begin
      // ���� ��¥�� �Ҽ��� 1�ڸ����� ����.(�� : 10.5��)
      RemainDateTime := Trunc(RemainDateTime * 10);
      RemainDateTime := RemainDateTime / 10;
      // ���� ��¥�� ��ȯ.
      RemainDateTime := GUILDAGIT_DAYUNIT - RemainDateTime;
{$IFNDEF DEBUG}//sonmg
      RemainDay      := FloatToStr(RemainDateTime) + 'Day(s)';
{$ELSE}
         RemainDay := FloatToStr( RemainDateTime ) + 'Min.';
{$ENDIF}
    end;

    // ���ڿ� ����.
    strtemp := IntToStr(guildagit.GuildAgitNumber);
    if Length(strtemp) = 1 then
      strtemp := '0' + strtemp;

    // �Ǵٸ� ���ְ� �ִ��� �˻�.
    guild := GuildMan.GetGuild(guildagit.GuildName);
    if guild <> nil then begin
      AnotherGuildMaster := guildagit.GuildMasterNameSecond;   //����
      //         AnotherGuildMaster := guild.GetAnotherGuildMaster;
    end;

    if AnotherGuildMaster = '' then begin
      AnotherGuildMaster := '---';    //�� �ٸ� ���� ����.
    end;

    salelist.Add(strtemp + '/' + guildagit.GuildName + '/' +
      guildagit.GuildMasterName + '/' + AnotherGuildMaster + '/' +
      IntToStr(guildagit.ForSaleMoney) + '/' + strStatus
      );
  end;

  // �Ǹ� ��� ��Ʈ.
  if salelist <> nil then
    salelist.Sort;
end;

function TGuildAgitManager.IsGuildAgitExpired(gname: string): boolean;
var
  i: integer;
  guildagit: TGuildAgit;
begin
  Result := False;
  for i := 0 to GuildAgitList.Count - 1 do begin
    guildagit := TGuildAgit(GuildAgitList[i]);
    if guildagit <> nil then begin
      if guildagit.GuildName = gname then begin
        if guildagit.IsExpired then begin
          Result := True;
          break;
        end;
      end;
    end;
  end;
end;

function TGuildAgitManager.GuildAgitTradeOk(
  gname, new_gname, new_mastername: string): boolean;
var
  i: integer;
  guildagit: TGuildAgit;
begin
  Result := False;

  // ���� ����.
  if (gname = '') or (new_gname = '') or (new_mastername = '') then
    exit;

  for i := 0 to GuildAgitList.Count - 1 do begin
    guildagit := TGuildAgit(GuildAgitList[i]);
    if guildagit <> nil then begin
      if (guildagit.GuildName = gname) and (guildagit.ForSaleFlag = 1) then begin
        guildagit.ForSaleFlag      := 0;
        //guildagit.ForSaleMoney := guildagit.ForSaleMoney;   //�״��
        guildagit.ForSaleWait      := GUILDAGIT_SALEWAIT_DAYUNIT;
        guildagit.ForSaleGuildName := new_gname;
        guildagit.ForSaleGuildMasterName := new_mastername;
        guildagit.ForSaleTime      := guildagit.ConvertDatetimeToString(Now);

        SaveGuildAgitList(True);
        Result := True;
        break;
      end;
    end;
  end;
end;

function TGuildAgitManager.IsExistInForSaleGuild(gname: string): boolean;
var
  i: integer;
  guildagit: TGuildAgit;
begin
  Result := False;

  for i := 0 to GuildAgitList.Count - 1 do begin
    guildagit := TGuildAgit(GuildAgitList[i]);
    if guildagit <> nil then begin
      if guildagit.ForSaleGuildName = gname then begin
        Result := True;
        break;
      end;
    end;
  end;
end;

function TGuildAgitManager.GetGuildNameFromAgitNum(AgitNum: integer): string;
var
  i: integer;
  guildagit: TGuildAgit;
begin
  Result := '';

  if AgitNum > -1 then begin
    for i := 0 to GuildAgitList.Count - 1 do begin
      guildagit := TGuildAgit(GuildAgitList[i]);
      if guildagit <> nil then begin
        if guildagit.GuildAgitNumber = AgitNum then begin
          Result := guildagit.GuildName;
          break;
        end;
      end;
    end;
  end;
end;

function TGuildAgitManager.GetGuildMasterNameFromAgitNum(AgitNum: integer): string;
var
  i: integer;
  guildagit: TGuildAgit;
begin
  Result := '';

  if AgitNum > -1 then begin
    for i := 0 to GuildAgitList.Count - 1 do begin
      guildagit := TGuildAgit(GuildAgitList[i]);
      if guildagit <> nil then begin
        if guildagit.GuildAgitNumber = AgitNum then begin
          Result := guildagit.GuildMasterName;
          break;
        end;
      end;
    end;
  end;
end;

function TGuildAgitManager.MakeAgitDecoMon: integer;
var
  env:   TEnvirnoment;
  pmi, pr: PTMapItem;
  i:     integer;
  pitem: PTAgitDecoItem;
  Count: integer;
begin
  Result := 0;
  Count  := 0;

  for i := 0 to AgitDecoMonList.Count - 1 do begin
    pitem := PTAgitDecoItem(AgitDecoMonList[i]);
    if pitem <> nil then begin
      if MakeDecoItemToMap(pitem.MapName, pitem.Name, pitem.Looks,
        pitem.Dura, pitem.x, pitem.y) > 0 then begin
        Inc(Count);
      end;
    end;
  end;

  Result := Count;
end;

function TGuildAgitManager.MakeDecoItemToMap(DropMapName: string;
  ItemName: string; LookIndex, Durability: integer; dx, dy: integer): integer;
var
  ps:      PTStdItem;
  newpu:   PTUserItem;
  pmi, pr: PTMapItem;
  iTemp:   integer;
  dropenvir: TEnvirnoment;
  pricestr: string;
begin
  Result := 0;

  //����Ʈ�� ������ ������ ����.
  if DecoItemList.Count <= 0 then
    exit;

  try
    ps := UserEngine.GetStdItemFromName(NAME_OF_DECOITEM);

    if ps <> nil then begin
      new(newpu);
      if UserEngine.CopyToUserItemFromName(ps.Name, newpu^) then begin
        //�����ָӴ� ���� ����
        newpu.Dura    := LookIndex;
        //�����ָӴ� ���� ����
        newpu.DuraMax := Durability;

        new(pmi);
        pmi.UserItem := newpu^;

        if (ps.StdMode = STDMODE_OF_DECOITEM) and (ps.Shape = SHAPE_OF_DECOITEM) then
        begin
          //����ٹ̱� - �����ָӴ�
          pmi.Name      := GetDecoItemName(LookIndex, pricestr) +
            '[' + IntToStr(Round(Durability / 1000)) + ']' + '/' + '1';
          pmi.Count     := 1;
          pmi.Looks     := LookIndex;
          pmi.AniCount  := ps.AniCount;
          pmi.Reserved  := 0;
          pmi.Ownership := nil;
          pmi.Droptime  := GetTickCount;
          pmi.Droper    := nil;
        end;

        dropenvir := GrobalEnvir.GetEnvir(DropMapName);
        pr := dropenvir.AddToMap(dx, dy, OS_ITEMOBJECT, TObject(pmi));
        if pr = pmi then begin
          // ������� MakeIndex;
          Result := pmi.useritem.MakeIndex;

          // �����α�
          MainOutMessage('[DecoItemGen] ' + pmi.Name + '(' +
            IntToStr(dx) + ',' + IntToStr(dy) + ')');
        end else begin
          //�����ΰ��
          Dispose(pmi);
        end;
      end;

      if newpu <> nil then
        Dispose(newpu);   // Memory Leak sonmg
    end;
  except
    MainOutMessage('[Exception] TGuildAgitManager.MakeDecoItemToMap');
  end;
end;

//DecoMonList���� ������Ʈ�� �����Ѵ�.
function TGuildAgitManager.DeleteAgitDecoMon(mapname: string; x, y: word): boolean;
var
  i: integer;
  tempitem: PTAgitDecoItem;
  agitnum: integer;
begin
  Result := False;

  try
    for i := 0 to AgitDecoMonList.Count - 1 do begin
      tempitem := PTAgitDecoItem(AgitDecoMonList[i]);
      if tempitem <> nil then begin
        if (tempitem.MapName = mapname) and (tempitem.x = x) and
          (tempitem.y = y) then begin
          //����ٹ̱� ������Ʈ ����
          AgitDecoMonList.Delete(i);
          //����ٹ̱� ������Ʈ ���� ����
          agitnum := GetGuildAgitNumFromMapName(mapname);
          if (agitnum > 0) and (agitnum <= MAXGUILDAGITCOUNT) then begin
            DecAgitDecoMonCountByAgitNum(agitnum);
          end;
          Result := True;
          break;
        end;
      end;
    end;
  except
    MainOutMessage('[Exception] TGuildAgitManager.DeleteAgitDecoMon');
  end;
end;

//DecoMonList�� ������Ʈ�� �߰��Ѵ�.
function TGuildAgitManager.AddAgitDecoMon(item: TAgitDecoItem): boolean;
var
  pitem: PTAgitDecoItem;
begin
  Result := False;

  try
    new(pitem);
    pitem^ := item;     //�̸��� ���� �������� ����� ��������...
    AgitDecoMonList.Add(pitem);

    Result := True;
  except
    MainOutMessage('[Exception] TGuildAgitManager.AddAgitDecoMon');
  end;
end;

//DecoMonList�� ������ ������ ������Ʈ�Ѵ�.
function TGuildAgitManager.UpdateDuraAgitDecoMon(mapname: string;
  x, y, dura: word): boolean;
var
  i: integer;
  tempitem: PTAgitDecoItem;
begin
  Result := False;

  try
    for i := 0 to AgitDecoMonList.Count - 1 do begin
      tempitem := PTAgitDecoItem(AgitDecoMonList[i]);
      if tempitem <> nil then begin
        if (tempitem.MapName = mapname) and (tempitem.x = x) and
          (tempitem.y = y) then begin
          tempitem.Dura := dura;
          Result := True;
          break;
        end;
      end;
    end;
  except
    MainOutMessage('[Exception] TGuildAgitManager.UpdateDuraAgitDecoMon');
  end;
end;

function TGuildAgitManager.LoadAgitDecoMon: integer;
var
  i:     integer;
  str, flname, decomonname, map, indexstr, xstr, ystr, maker, durastr: string;
  //   nx, ny: integer;
  strlist: TStringList;
  //   merchant: TMerchant;
  //   cret: TCreature;
  item:  TAgitDecoItem;
  pitem: PTAgitDecoItem;
begin
  flname := GuildBaseDir + AGITDECOMONFILE;
  if FileExists(flname) then begin
    strlist := TStringList.Create;
    strlist.LoadFromFile(flname);
    for i := 0 to strlist.Count - 1 do begin
      str := Trim(strlist[i]);
      if str = '' then
        continue;
      if str[1] = ';' then
        continue;
      str := GetValidStr3(str, decomonname, [' ', #9]);
      str := GetValidStr3(str, indexstr, [' ', #9]);
      str := GetValidStr3(str, map, [' ', #9]);
      str := GetValidStr3(str, xstr, [' ', #9]);
      str := GetValidStr3(str, ystr, [' ', #9]);

      str := GetValidStrCap(str, maker, [' ', #9]);
      str := GetValidStr3(str, durastr, [' ', #9]);

      item.Name  := Copy(decomonname, 0, 20);
      item.Looks := Str_ToInt(indexstr, 0);
      item.MapName := Copy(map, 0, 14);
      item.x     := Str_ToInt(xstr, 0);
      item.y     := Str_ToInt(ystr, 0);
      item.Maker := Copy(maker, 0, 14);
      item.Dura  := Str_ToInt(durastr, 0);

      new(pitem);
      pitem^ := item;     //�̸��� ���� �������� ����� ��������...
      AgitDecoMonList.Add(pitem);
    end;
    strlist.Free;
  end;
  Result := 1;
end;

procedure TGuildAgitManager.SaveAgitDecoMonList;
var
  strlist: TStringList;
  i: integer;
begin
  if ServerIndex = 0 then begin  //������ ������ ������ �Ѵ�.
    strlist := TStringList.Create;
    for i := 0 to AgitDecoMonList.Count - 1 do
      strlist.Add(PTAgitDecoItem(AgitDecoMonList[i]).Name + #9 +
        IntToStr(PTAgitDecoItem(AgitDecoMonList[i]).Looks) + #9 +
        PTAgitDecoItem(AgitDecoMonList[i]).MapName + #9 +
        IntToStr(PTAgitDecoItem(AgitDecoMonList[i]).x) + #9 +
        IntToStr(PTAgitDecoItem(AgitDecoMonList[i]).y) + #9 +
        PTAgitDecoItem(AgitDecoMonList[i]).Maker + #9 +
        IntToStr(PTAgitDecoItem(AgitDecoMonList[i]).Dura)
        );
    try
      strlist.SaveToFile(GuildBaseDir + AGITDECOMONFILE);
    except
      MainOutMessage(AGITDECOMONFILE + ' ���� ����...');
    end;
    strlist.Free;
  end;
end;

function TGuildAgitManager.GetDecoItemName(index: integer; var price: string): string;
var
  str, Name: string;
begin
  Result := '';
  str    := '';

  if index < 0 then
    exit;
  if DecoItemList.Count <= index then
    exit;

  str   := DecoItemList[index];
  price := GetValidStr3(str, Name, ['/']);

  Result := Name;
end;

function TGuildAgitManager.GetAgitDecoMonCount(agitnum: integer): integer;
begin
  Result := -1;

  if agitnum <= 0 then
    exit;
  if agitnum > MAXGUILDAGITCOUNT then
    exit;

  Result := AgitDecoMonCount[agitnum];
end;

procedure TGuildAgitManager.IncAgitDecoMonCount(gname: string);
var
  agitnum:   integer;
  guildagit: TGuildAgit;
begin
  guildagit := GetGuildAgit(gname);

  if guildagit <> nil then begin
    agitnum := guildagit.GuildAgitNumber;
    if (agitnum > 0) and (agitnum <= MAXGUILDAGITCOUNT) then begin
      AgitDecoMonCount[agitnum] := AgitDecoMonCount[agitnum] + 1;
    end;
  end;
end;

procedure TGuildAgitManager.IncAgitDecoMonCountByAgitNum(agitnum: integer);
begin
  if (agitnum > 0) and (agitnum <= MAXGUILDAGITCOUNT) then begin
    AgitDecoMonCount[agitnum] := AgitDecoMonCount[agitnum] + 1;
  end;
end;

procedure TGuildAgitManager.DecAgitDecoMonCount(gname: string);
var
  agitnum:   integer;
  guildagit: TGuildAgit;
begin
  guildagit := GetGuildAgit(gname);

  if guildagit <> nil then begin
    agitnum := guildagit.GuildAgitNumber;
    if (agitnum > 0) and (agitnum <= MAXGUILDAGITCOUNT) then begin
      AgitDecoMonCount[agitnum] := _MAX(0, AgitDecoMonCount[agitnum] - 1);
    end;
  end;
end;

procedure TGuildAgitManager.DecAgitDecoMonCountByAgitNum(agitnum: integer);
begin
  if (agitnum > 0) and (agitnum <= MAXGUILDAGITCOUNT) then begin
    AgitDecoMonCount[agitnum] := _MAX(0, AgitDecoMonCount[agitnum] - 1);
  end;
end;

procedure TGuildAgitManager.ArrangeEachAgitDecoMonCount;
var
  i, agitnum: integer;
  pitem:      PTAgitDecoItem;
begin
  for i := 0 to AgitDecoMonList.Count - 1 do begin
    pitem := PTAgitDecoItem(AgitDecoMonList[i]);
    if pitem <> nil then begin
      agitnum := GetGuildAgitNumFromMapName(pitem.MapName);
      if (agitnum > 0) and (agitnum <= MAXGUILDAGITCOUNT) then begin
        IncAgitDecoMonCountByAgitNum(agitnum);
      end;
    end;
  end;
end;

//����ٹ̱� ������ ��ġ ���� �ʰ� ���� �˻�
function TGuildAgitManager.IsAvailableDecoMonCount(gname: string): boolean;
var
  guildagit:    TGuildAgit;
  decomoncount: integer;
begin
  Result := False;
  decomoncount := -1;

  //��� �� ���� ����
  if AgitDecoMonList.Count >= 1000 then
    exit;

  guildagit := GetGuildAgit(gname);
  if guildagit <> nil then begin
    decomoncount := GetAgitDecoMonCount(guildagit.GuildAgitNumber);
    if (decomoncount < 0) or (decomoncount >= MAXCOUNT_DECOMON_PER_AGIT) then
      exit;
    Result := True;
  end;
end;

function TGuildAgitManager.IsMatchDecoItemInOutdoor(index: integer;
  mapname: string): boolean;
var
  kind, floor: integer;
begin
  Result := False;
  kind   := -1;
  floor  := -1;

  if DecoItemList = nil then
    exit;
  if (index < 0) or (index >= DecoItemList.Count) then
    exit;

  // 1:�ǳ�, 2:�ǿ�, 3:�Ѵ�
  kind  := Hiword(integer(DecoItemList.Objects[index]));
  floor := GetGuildAgitMapFloor(mapname);

  if (kind = 1) and (floor = 2) then
    Result := True;
  if (kind = 2) and (floor = 0) then
    Result := True;
  if (kind = 3) and ((floor = 2) or (floor = 0)) then
    Result := True;
end;

function TGuildAgitManager.GetGuildAgitMapFloor(mapname: string): integer;
begin
  Result := -1;

  if Length(mapname) < 3 then
    exit;

  //0: ����, 1,2,3��
  Result := Str_ToInt(mapname[3], -1);
end;

function TGuildAgitManager.GetGuildAgitNumFromMapName(gmapname: string): integer;
var
  gname:      string;
  agitnumstr: string;
  mapnamelen, agitnum: integer;
begin
  Result := -1;

  mapnamelen := Length(gmapname);
  if mapnamelen <= 3 then
    exit;

  agitnumstr := Copy(gmapname, 4, mapnamelen - 3);
  agitnum    := Str_ToInt(agitnumstr, -1);
  if (agitnum > 0) and (agitnum <= MAXGUILDAGITCOUNT) then begin
    Result := agitnum;
  end;
end;

//����ٹ̱� ������ ���� ���ҽ�Ŵ.
function TGuildAgitManager.DecreaseDecoMonDurability: boolean;
var
  list:    TList;
  cret:    TCreature;
  i, j, ix, iy: integer;
  env:     TEnvirnoment;
  pm:      PTMapInfo;
  pmapitem: PTMapItem;
  inrange: boolean;
  down, k: integer;
  ObjShape: byte;
  agitnum: integer;
  pricestr: string;
  ps:      PTStdItem;
const
  //(���� 7,000 : 1�ð��� 40�� ���� => �������̸� 6,720����)
  DEC_DURA = 40;
begin
  Result := False;

  //��ü ����� �˻��Ͽ�
  //�ʿ� �ִ� �������� ����ٹ̱� �������̸� ���� ���ҽ�Ų��.
  //����Ʈ�� ������Ʈ�ϰ�
  //����Ʈ�� �����Ѵ�.
  try
    list := TList.Create;
    // ��� �� ��ü ��ǥ�� �˻��Ͽ� �� ��ǥ�� �ִ� �ٹ̱� �������� ������ ���ҽ�Ų��.
    for i := 0 to 3 do begin
      for agitnum := 1 to GuildAgitMaxNumber do begin
        env := GrobalEnvir.GetEnvir(GuildAgitMapName[i] + IntToStr(agitnum));
        if env <> nil then begin
          for ix := 0 to env.MapWidth - 1 do begin
            for iy := 0 to env.MapHeight - 1 do begin
              down    := 0;
              //------------------------------------------------------------
              //����ٹ̱� �������� ������ ���� ����
              inrange := env.GetMapXY(ix, iy, pm);
              if inrange then begin
                if pm.ObjList <> nil then begin
                  k := 0;
                  while True do begin
                    if k >= pm.ObjList.Count then
                      break; //-1 do begin //downto 0 do begin
                    if pm.ObjList[k] <> nil then begin
                      // Check Object wrong Memory 2003-09-15 PDS
                      try
                        // �޸𸮿��� ������ ������ �ͼ��� �ɸ���
                        ObjShape := PTAThing(pm.ObjList[k]).Shape;
                      except
                        // ������Ʈ���� ��������.
                        MainOutMessage(
                          '[TGuildAgit.ExpulsionMembers] DELOBJ-WRONG MEMORY:' +
                          env.MapName + ',' + IntToStr(ix) + ',' + IntToStr(iy));
                        pm.ObjList.Delete(k);
                        continue;
                      end;

                      {item}
                      down := 6;
                      if PTAThing(pm.ObjList[k]).Shape = OS_ITEMOBJECT then
                      begin
                        down     := 10;
                        pmapitem :=
                          PTMapItem(PTAThing(pm.ObjList[k]).AObject);
                        //                                    UpdateVisibleItems (i, j, pmapitem);

                        //����ٹ̱� ���������� Ȯ��
                        ps := UserEngine.GetStdItem(pmapitem.UserItem.Index);
                        if ps <> nil then begin
                          if (ps.StdMode = STDMODE_OF_DECOITEM) and
                            (ps.Shape = SHAPE_OF_DECOITEM) then begin
                            //������ DEC_DURA���� ũ�� DEC_DURA�� ���ҽ�Ų��.
                            if pmapitem.UserItem.DuraMax >= DEC_DURA then
                            begin
                              pmapitem.UserItem.DuraMax :=
                                pmapitem.UserItem.DuraMax - DEC_DURA;
                              pmapitem.Name :=
                                GetDecoItemName(pmapitem.Looks, pricestr) +
                                '[' + IntToStr(Round(pmapitem.UserItem.DuraMax / 1000)) +
                                ']' + '/' + '1';
                              //������ ���ҽ�Ű�� �����Ѵ�.
                              if UpdateDuraAgitDecoMon(
                                env.MapName, ix, iy, pmapitem.UserItem.DuraMax) then
                                SaveAgitDecoMonList;
                            end else begin
                              pmapitem.UserItem.DuraMax := 0;
                            end;

                            //������ 0�����̸� ���ش�.
                            if pmapitem.UserItem.DuraMax <= 0 then begin
                              //����Ʈ���� �����ϰ� �����Ѵ�.
                              if DeleteAgitDecoMon(
                                env.MapName, ix, iy) then
                                SaveAgitDecoMonList;

                              //������ 1�ð��� ������ ���ش�. -PDS �߸��� ���ɼ� ����
                              // Dispose (PTMapItem (PTAThing (pm.ObjList[k]).AObject));

                              Dispose(PTAThing(pm.ObjList[k]));
                              pm.ObjList.Delete(k);
                              down := 8;
                              if pm.ObjList.Count <= 0 then begin
                                down := 9;
                                pm.ObjList.Free;
                                pm.ObjList := nil;
                                break;
                              end;
                              continue;
                            end;

                            if (pmapitem.Ownership <> nil) or
                              (pmapitem.Droper <> nil) then begin
                              if GetTickCount -
                              pmapitem.Droptime > ANTI_MUKJA_DELAY then begin
                                pmapitem.Ownership := nil;
                                pmapitem.Droper    := nil;
                              end else begin
                                //{����} ���� ��ȣ �ð��� 5��(���� ĳ�� free �����ð�)�� �ʰ��ϸ�
                                //�� �κп��� ���װ� �߻��Ѵ�.
                                if pmapitem.Ownership <> nil then
                                  if TCreature(
                                    pmapitem.Ownership).BoGhost then
                                    pmapitem.Ownership := nil;
                                if pmapitem.Droper <> nil then
                                  if TCreature(
                                    pmapitem.Droper).BoGhost then
                                    pmapitem.Droper := nil;
                              end;
                            end;
                          end;
                        end;
                      end;
                    end;

                    Inc(k);

                  end;
                end;
              end;
              //------------------------------------------------------------
            end;
          end;
        end;
      end;
    end;
    list.Free;
  except
    MainOutMessage('[Exception]TGuildAgitManager.DecreaseDecoMonDurability');
  end;

  Result := True;
end;


 {-------------------------------------------------------------------}
 // TGuildAgitBoardManager(����Խ���)


constructor TGuildAgitBoardManager.Create;
var
  i: integer;
begin
  inherited Create;

  // ������� Overflow �˻�
  if GuildAgitMaxNumber > MAXGUILDAGITCOUNT then begin
    MainOutMessage('[Exception] TGuildAgitBoardManager : GuildAgitMaxNumber > MAXGUILDAGITCOUNT');
    exit;
  end;

  GaBoardList := TList.Create;
end;

destructor TGuildAgitBoardManager.Destroy;
var
  i: integer;
begin
  GaBoardList.Free;
  inherited Destroy;
end;

function TGuildAgitBoardManager.LoadOneGaBoard(uname: string;
  nAgitNum: integer): boolean;
var
  gname: string;
begin
  Result := False;

  if nAgitNum < 0 then
    exit;

  gname := GuildAgitMan.GetGuildNameFromAgitNum(nAgitNum);

  if gname = '' then
    exit;

  SQLEngine.RequestLoadGuildAgitBoard(uname, gname);

  Result := True;
end;

function TGuildAgitBoardManager.LoadAllGaBoardList(uname: string): boolean;
var
  i: integer;
begin
  Result := False;

  //���� ����Ʈ�� �����.
  GaBoardList.Clear;

  // DB���� �� ����� �Խù��� ��� �ε��Ѵ�.
  for i := GuildAgitStartNumber to GuildAgitMaxNumber do begin
    LoadOneGaBoard(uname, i);

    Result := True;
  end;
end;

procedure TGuildAgitBoardManager.AddGaBoardList(pSearchInfo: PTSearchGaBoardList);
var
  pSearchList: PTSearchGaBoardList;
  pArticleLoad: PTGaBoardArticleLoad;
  rList: TList;
  i:     integer;
  ps:    PTStdItem;
  std:   TStdItem;
begin
  //    if pInfo.IsOK <> UMRESULT_SUCCESS then Exit;

  if pSearchInfo.ArticleList <> nil then begin
    new(pSearchList);
    pSearchList.AgitNum   := pSearchInfo.AgitNum;
    pSearchList.GuildName := pSearchInfo.GuildName;
    pSearchList.OrgNum    := pSearchInfo.OrgNum;
    pSearchList.SrcNum1   := pSearchInfo.SrcNum1;
    pSearchList.SrcNum2   := pSearchInfo.SrcNum2;
    pSearchList.SrcNum3   := pSearchInfo.SrcNum3;
    pSearchList.Kind      := pSearchInfo.Kind;

    rList := TList.Create;

    for i := 0 to pSearchInfo.ArticleList.Count - 1 do begin
      new(pArticleLoad);
      pArticleLoad.AgitNum   :=
        PTGaBoardArticleLoad(pSearchInfo.ArticleList.Items[i]).AgitNum;
      pArticleLoad.GuildName :=
        PTGaBoardArticleLoad(pSearchInfo.ArticleList.Items[i]).GuildName;
      pArticleLoad.OrgNum    :=
        PTGaBoardArticleLoad(pSearchInfo.ArticleList.Items[i]).OrgNum;
      pArticleLoad.SrcNum1   :=
        PTGaBoardArticleLoad(pSearchInfo.ArticleList.Items[i]).SrcNum1;
      pArticleLoad.SrcNum2   :=
        PTGaBoardArticleLoad(pSearchInfo.ArticleList.Items[i]).SrcNum2;
      pArticleLoad.SrcNum3   :=
        PTGaBoardArticleLoad(pSearchInfo.ArticleList.Items[i]).SrcNum3;
      pArticleLoad.Kind      :=
        PTGaBoardArticleLoad(pSearchInfo.ArticleList.Items[i]).Kind;
      pArticleLoad.UserName  :=
        PTGaBoardArticleLoad(pSearchInfo.ArticleList.Items[i]).UserName;
      pArticleLoad.Content   :=
        PTGaBoardArticleLoad(pSearchInfo.ArticleList.Items[i]).Content;

      rList.Add(pArticleLoad);
    end;

    pSearchList.ArticleList := rList;

    GaBoardList.Add(pSearchList);

    //        MainOutMessage( PTGaBoardArticleLoad(PTSearchGaBoardList(GaBoardList.Items[0]).ArticleList.Items[0]).Content );
    //        MainOutMessage('GaBoardList.Count : ' + IntToStr(GaBoardList.Count));
    //        MainOutMessage('PTSearchGaBoardList.Count : ' + IntToStr(pSearchList.ArticleList.Count));
  end else begin
    //        GaBoardList.Add( nil );
  end;
end;

function TGuildAgitBoardManager.GetAllPage(WholeLine: integer): integer;
var
  iTemp: integer;
begin
  if WholeLine <= GABOARD_NOTICE_LINE then begin
    Result := 1;
  end else begin
    // (WholeLine - 4)�� 7�� ���� ��...
    iTemp  := (WholeLine - GABOARD_NOTICE_LINE - 1) div
      (GABOARD_COUNT_PER_PAGE - GABOARD_NOTICE_LINE);
    // 1�� ���� ���� �������� ��.
    Result := iTemp + 1;
  end;
end;

procedure TGuildAgitBoardManager.ConvertNumSeriesToInteger(var NumSeries: string;
  var OrgNum, SrcNum1, SrcNum2, SrcNum3: integer);
var
  strOrgNum, strSrcNum1, strSrcNum2, strSrcNum3: string;
begin
  // �ʱ�ȭ.
  OrgNum  := 0;
  SrcNum1 := 0;
  SrcNum2 := 0;
  SrcNum3 := 0;

  // �۹�ȣ �и�.
  NumSeries := GetValidStr3(NumSeries, strOrgNum, ['/']);
  if NumSeries = '' then
    exit;
  NumSeries := GetValidStr3(NumSeries, strSrcNum1, ['/']);
  if NumSeries = '' then
    exit;
  NumSeries := GetValidStr3(NumSeries, strSrcNum2, ['/']);
  if NumSeries = '' then
    exit;
  NumSeries := GetValidStr3(NumSeries, strSrcNum3, ['/', #0]);

  // �� �Է�.
  OrgNum  := Str_ToInt(strOrgNum, 0);
  SrcNum1 := Str_ToInt(strSrcNum1, 0);
  SrcNum2 := Str_ToInt(strSrcNum2, 0);
  SrcNum3 := Str_ToInt(strSrcNum3, 0);
end;

// �� �� ��ȣ�� �ο��Ѵ�.
function TGuildAgitBoardManager.GetNewArticleNumber(gname: string;
  var OrgNum, SrcNum1, SrcNum2, SrcNum3: integer): integer;
var
  i, j, newIndex:  integer;
  IndentationFlag: integer;
  pEachSearchBoardList: PTSearchGaBoardList;
  pArticleList:    TList;
  pArticleLoad:    PTGaBoardArticleLoad;
  newOrgNum, newSrcNum1, newSrcNum2, newSrcNum3: integer;
begin
  Result   := -1;
  newIndex := GABOARD_NOTICE_LINE;

  //����� �Խ��� �˻�.
  for i := 0 to GaBoardList.Count - 1 do begin
    pEachSearchBoardList := PTSearchGaBoardList(GaBoardList.Items[i]);

    // �ش� ������ �Խ��� ����Ʈ.
    if pEachSearchBoardList.GuildName = gname then begin
      pArticleList := pEachSearchBoardList.ArticleList;
      if pArticleList = nil then
        continue;

      if (OrgNum <= 0) and (SrcNum1 <= 0) and (SrcNum2 <= 0) and (SrcNum3 <= 0) then
      begin
        // ������ �����̸�...
        // �ֱ� �������� 3���� ��ȣ�� �Ϲݱ��� ù��° �� ��ȣ �߿���
        // ���� ū ��ȣ+1�� ���Ѵ�.
        OrgNum := 0;   // 0���� �ʱ�ȭ.
        for j := 0 to pArticleList.Count - 1 do begin
          pArticleLoad := pArticleList.Items[j];
          if pArticleLoad <> nil then begin
            if OrgNum < pArticleLoad.OrgNum then begin
              OrgNum  := pArticleLoad.OrgNum;
              SrcNum1 := 0;
              SrcNum2 := 0;
              SrcNum3 := 0;
            end;
            if j >= GABOARD_NOTICE_LINE then
              break;
          end;
        end;
        OrgNum := OrgNum + 1; //�ϳ� ����.
        Result := newIndex;
      end else begin
        // ��� �����̸�...
        //�ʱ�ȭ.
        IndentationFlag := 0;
        newOrgNum  := 0;
        newSrcNum1 := 0;
        newSrcNum2 := 0;
        newSrcNum3 := 0;

        // �������� ����.
        if pArticleList.Count <= GABOARD_NOTICE_LINE then begin
          //�Ϲݱ��� ���� �������� �ۿ� ������...
          break;
        end else begin
          /////////////////////////////////////////////////////////////
          //�ش� �������� ���� ã�´�.
          //������ �鿩���� ����(IndentationFlag)�� �����ϰ�
          //�� ���ķδ� �鿩���� ���� ������ �۹�ȣ�� �޶��� ������ �˻� �� ���� �����Ѵ�.
          //�鿩���� ���� ������ �۹�ȣ�� �޶�����
          //�� �������� ������ �۹�ȣ���� �鿩���� ���ؿ� �ش��ϴ� �۹�ȣ�� +1�� �Ѵ�.
          /////////////////////////////////////////////////////////////
          for j := GABOARD_NOTICE_LINE to pArticleList.Count - 1 do begin
            pArticleLoad := pArticleList.Items[j];
            if pArticleLoad <> nil then begin
              //�ش� �������� ã�Ƽ� �� �ؿ� �޷��ִ� [������ ����� ��ȣ+1]�� �ο��Ѵ�.
              if (pArticleLoad.OrgNum = OrgNum) and
                (pArticleLoad.SrcNum1 = SrcNum1) and
                (pArticleLoad.SrcNum2 = SrcNum2) and
                (pArticleLoad.SrcNum3 = SrcNum3) then begin
                newOrgNum  := pArticleLoad.OrgNum;
                newSrcNum1 := pArticleLoad.SrcNum1;
                newSrcNum2 := pArticleLoad.SrcNum2;
                newSrcNum3 := pArticleLoad.SrcNum3;

                //��� ���� �÷��� �� ����.
                if SrcNum1 = 0 then begin
                  IndentationFlag := 1;
                end else if SrcNum2 = 0 then begin
                  IndentationFlag := 2;
                end else if SrcNum3 = 0 then begin
                  IndentationFlag := 3;
                end else begin
                  IndentationFlag := 3;
                end;

                Inc(newIndex);
                continue;
              end;

              if IndentationFlag = 1 then begin
                if pArticleLoad.OrgNum = OrgNum then begin
                  newOrgNum  := pArticleLoad.OrgNum;
                  newSrcNum1 := pArticleLoad.SrcNum1;
                end else begin
                  break;
                end;
              end else if IndentationFlag = 2 then begin
                if (pArticleLoad.OrgNum = OrgNum) and
                  (pArticleLoad.SrcNum1 = SrcNum1) then begin
                  newOrgNum  := pArticleLoad.OrgNum;
                  newSrcNum1 := pArticleLoad.SrcNum1;
                  newSrcNum2 := pArticleLoad.SrcNum2;
                end else begin
                  break;
                end;
              end else if IndentationFlag = 3 then begin
                if (pArticleLoad.OrgNum = OrgNum) and
                  (pArticleLoad.SrcNum1 = SrcNum1) and
                  (pArticleLoad.SrcNum2 = SrcNum2) then begin
                  newOrgNum  := pArticleLoad.OrgNum;
                  newSrcNum1 := pArticleLoad.SrcNum1;
                  newSrcNum2 := pArticleLoad.SrcNum2;
                  newSrcNum3 := pArticleLoad.SrcNum3;
                end else begin
                  break;
                end;
              end;

              Inc(newIndex);
            end;
          end;//for

          // ���� ����� �� ��� ��ȣ ����.
          if IndentationFlag = 1 then begin
            OrgNum  := newOrgNum;
            SrcNum1 := newSrcNum1 + 1;
            SrcNum2 := newSrcNum2;
            SrcNum3 := newSrcNum3;
          end else if IndentationFlag = 2 then begin
            OrgNum  := newOrgNum;
            SrcNum1 := newSrcNum1;
            SrcNum2 := newSrcNum2 + 1;
            SrcNum3 := newSrcNum3;
          end else if IndentationFlag = 3 then begin
            OrgNum  := newOrgNum;
            SrcNum1 := newSrcNum1;
            SrcNum2 := newSrcNum2;
            SrcNum3 := newSrcNum3 + 1;
          end else begin
            //�ش� �������� ������...(???)
            OrgNum  := newOrgNum + 1;
            SrcNum1 := 0;
            SrcNum2 := 0;
            SrcNum3 := 0;
          end;

          Result := newIndex;
        end;//if
      end;//if
      break;
    end;//if
  end;//for
end;

function TGuildAgitBoardManager.GetPageList(uname, gname: string;
  var nPage, nAllPage: integer; var subjectlist: TStringList): boolean;
var
  i, j, k:      integer;
  pEachSearchBoardList: PTSearchGaBoardList;
  pArticleList: TList;
  pArticleLoad: PTGaBoardArticleLoad;
  subject:      string[40];
  StartCount, LastCount: integer;
begin
  Result     := False;
  StartCount := 0;
  if nPage <= 0 then
    nPage := 1;

  //�ش� ������ �Խ����� �� ������ �о��.
  for i := 0 to GaBoardList.Count - 1 do begin
    pEachSearchBoardList := PTSearchGaBoardList(GaBoardList.Items[i]);

    // �ش� ������ �Խ��� ����Ʈ.
    if pEachSearchBoardList.GuildName = gname then begin
      pEachSearchBoardList.UserName := uname;

      pArticleList := pEachSearchBoardList.ArticleList;
      if pArticleList = nil then
        continue;

      // ������ ������(�ּ� 3���� �Ǿ�� ��).
      if pArticleList.Count < GABOARD_NOTICE_LINE then
        exit;

      // ���������� ������ ���ٿ� �߰�.
      for j := 0 to GABOARD_NOTICE_LINE - 1 do begin
        pArticleLoad := pArticleList.Items[j];
        if pArticleLoad <> nil then begin
          subject := Copy(pArticleLoad.Content, 0, sizeof(subject));
          subjectlist.Add(pArticleLoad.UserName + '/' +
            IntToStr(pArticleLoad.OrgNum) + '/' +
            IntToStr(pArticleLoad.SrcNum1) + '/' +
            IntToStr(pArticleLoad.SrcNum2) + '/' + IntToStr(pArticleLoad.SrcNum3) +
            '/' + subject);
        end;
      end;

      nAllPage   := GetAllPage(pArticleList.Count);
      StartCount := _MAX(GABOARD_NOTICE_LINE,
        ((nPage - 1) * (GABOARD_COUNT_PER_PAGE - GABOARD_NOTICE_LINE)) +
        GABOARD_NOTICE_LINE);
      LastCount  := _MIN(pArticleList.Count, nPage * GABOARD_COUNT_PER_PAGE);
      for j := StartCount to LastCount - 1 do begin
        pArticleLoad := pArticleList.Items[j];
        if pArticleLoad <> nil then begin
          subject := Copy(pArticleLoad.Content, 0, sizeof(subject));
          subjectlist.Add(pArticleLoad.UserName + '/' +
            IntToStr(pArticleLoad.OrgNum) + '/' +
            IntToStr(pArticleLoad.SrcNum1) + '/' +
            IntToStr(pArticleLoad.SrcNum2) + '/' + IntToStr(pArticleLoad.SrcNum3) +
            '/' + subject);
          Result := True;
        end;
      end;
      break;
    end;
  end;
end;

function TGuildAgitBoardManager.AddArticle(gname: string; nKind, AgitNum: integer;
  uname, Data: string): boolean;
var
  i, j, newIndex: integer;
  OrgNum, SrcNum1, SrcNum2, SrcNum3: integer;
  pEachSearchBoardList: PTSearchGaBoardList;
  pArticleList:   TList;
  pNewArticleLoad, pArticleLoad: PTGaBoardArticleLoad;
begin
  Result := False;

  ConvertNumSeriesToInteger(Data, OrgNum, SrcNum1, SrcNum2, SrcNum3);

  // ������ ������ �۾��⸦ �� �� ����.
  if Trim(Data) = '' then
    exit;

  // ���۹�ȣ�� �����Ѵ�. ���ϰ��� �ε���.
  newIndex := GetNewArticleNumber(gname, OrgNum, SrcNum1, SrcNum2, SrcNum3);
  if newIndex > 0 then begin
    // ����Ʈ�� ������ �߰��Ѵ�.
    GetMem(pNewArticleLoad, sizeof(TGaBoardArticleLoad));

    // �д� ���� ����
    pNewArticleLoad.AgitNum   := AgitNum;
    pNewArticleLoad.GuildName := gname;
    pNewArticleLoad.OrgNum    := OrgNum;
    pNewArticleLoad.SrcNum1   := SrcNum1;
    pNewArticleLoad.SrcNum2   := SrcNum2;
    pNewArticleLoad.SrcNum3   := SrcNum3;
    pNewArticleLoad.Kind      := nKind;
    pNewArticleLoad.UserName  := uname;
    FillChar(pNewArticleLoad.Content, sizeof(pNewArticleLoad.Content), #0);
    StrPLCopy(pNewArticleLoad.Content, Data, sizeof(pNewArticleLoad.Content) - 1);

    for i := 0 to GaBoardList.Count - 1 do begin
      pEachSearchBoardList := PTSearchGaBoardList(GaBoardList.Items[i]);

      // �ش� ������ �Խ��� ����Ʈ.
      if pEachSearchBoardList.GuildName = gname then begin
        pEachSearchBoardList.UserName := uname;

        pArticleList := pEachSearchBoardList.ArticleList;
        if pArticleList <> nil then begin
          // �������� ����...
          if nKind = KIND_NOTICE then begin
            // ������ ������ ����� ù��° ������ �߰��Ѵ�.
            for j := pArticleList.Count - 1 downto 0 do begin
              pArticleLoad := pArticleList.Items[j];

              if pArticleLoad <> nil then begin
                // ���� ������ ���� �����Ѵ�.
                if j = GABOARD_NOTICE_LINE - 1 then begin
                  // DB�� ���� ��û.
                  SQLEngine.RequestGuildAgitBoardDelArticle(
                    gname, pArticleLoad.OrgNum, pArticleLoad.SrcNum1,
                    pArticleLoad.SrcNum2,
                    pArticleLoad.SrcNum3, uname);

                  // ����Ʈ���� ����.
                  pArticleList.Delete(j);
                  break;
                end;
              end;
            end;

            newIndex := 0;
            // ���� �����Ѵ�.
            pArticleList.Insert(newIndex, pNewArticleLoad);
          end else if nKind = KIND_GENERAL then begin
            //�Խù� ���� �ִ� ���� ������ ���� ������ �� ���� �� �߰�.
            if pArticleList.Count >= GABOARD_MAX_ARTICLE_COUNT then begin
              for j := pArticleList.Count - 1 downto 0 do begin
                pArticleLoad := pArticleList.Items[j];

                if pArticleLoad <> nil then begin
                  // ������ ���� �����Ѵ�.
                  if j >= GABOARD_MAX_ARTICLE_COUNT - 1 then begin
                    // DB�� ���� ��û.
                    SQLEngine.RequestGuildAgitBoardDelArticle(
                      gname, pArticleLoad.OrgNum, pArticleLoad.SrcNum1,
                      pArticleLoad.SrcNum2,
                      pArticleLoad.SrcNum3, uname);

                    // ����Ʈ���� ����.(�Ѿ�� �� ��� ����)
                    pArticleList.Delete(j);
                  end else begin
                    break;
                  end;
                end;
              end;
            end;

            // �Ϲݱ� �߰�...
            // ���� �����Ѵ�.
            pArticleList.Insert(newIndex, pNewArticleLoad);
          end else begin
            exit;
          end;

        end;
      end;
    end;

    // DB�� ���� ��û�Ѵ�.
    Result := SQLEngine.RequestGuildAgitBoardAddArticle(
      gname, OrgNum, SrcNum1, SrcNum2, SrcNum3, nKind, AgitNum, uname, Data);
  end;
end;

// �۹�ȣ�� �ش��ϴ� ���� ������ �о�´�.
function TGuildAgitBoardManager.GetArticle(gname, NumSeries: string): string;
var
  i, j: integer;
  pEachSearchBoardList: PTSearchGaBoardList;
  pArticleList: TList;
  pArticleLoad: PTGaBoardArticleLoad;
  OrgNum, SrcNum1, SrcNum2, SrcNum3: integer;
begin
  Result := '';

  ConvertNumSeriesToInteger(NumSeries, OrgNum, SrcNum1, SrcNum2, SrcNum3);

  if OrgNum <= 0 then
    exit;

  for i := 0 to GaBoardList.Count - 1 do begin
    pEachSearchBoardList := PTSearchGaBoardList(GaBoardList.Items[i]);

    // �ش� ������ �Խ��� ����Ʈ.
    if pEachSearchBoardList.GuildName = gname then begin
      pArticleList := pEachSearchBoardList.ArticleList;

      if pArticleList <> nil then begin
        for j := 0 to pArticleList.Count - 1 do begin
          pArticleLoad := pArticleList.Items[j];

          if pArticleLoad <> nil then begin
            //�ش� ���� �Խ��ǿ� �۹�ȣ�� ���� ���� ������...
            if (pArticleLoad.OrgNum = OrgNum) and
              (pArticleLoad.SrcNum1 = SrcNum1) and
              (pArticleLoad.SrcNum2 = SrcNum2) and (pArticleLoad.SrcNum3 = SrcNum3) then
            begin
              //�۹�ȣ/��۹�ȣ1/��۹�ȣ2/��۹�ȣ3/�����̸�/����
              Result :=
                IntToStr(OrgNum) + '/' + IntToStr(SrcNum1) + '/' +
                IntToStr(SrcNum2) + '/' + IntToStr(SrcNum3) +
                '/' + pArticleLoad.UserName + '/' + string(pArticleLoad.Content);
              exit; //��������.
            end;
          end;
        end;
        // ����� ������ 0���� ����.
        OrgNum  := 0;
        SrcNum1 := 0;
        SrcNum2 := 0;
        SrcNum3 := 0;
        break;
      end;
    end;
  end;
end;

function TGuildAgitBoardManager.DelArticle(gname, uname: string;
  NumSeries: string): boolean;
var
  i, j: integer;
  OrgNum, SrcNum1, SrcNum2, SrcNum3: integer;
  pEachSearchBoardList: PTSearchGaBoardList;
  pArticleList: TList;
  pNewArticleLoad, pArticleLoad: PTGaBoardArticleLoad;
begin
  Result := False;

  ConvertNumSeriesToInteger(NumSeries, OrgNum, SrcNum1, SrcNum2, SrcNum3);

  for i := 0 to GaBoardList.Count - 1 do begin
    pEachSearchBoardList := PTSearchGaBoardList(GaBoardList.Items[i]);

    // �ش� ������ �Խ��� ����Ʈ.
    if pEachSearchBoardList.GuildName = gname then begin
      pArticleList := pEachSearchBoardList.ArticleList;

      if pArticleList <> nil then begin
        for j := pArticleList.Count - 1 downto 0 do begin
          pArticleLoad := pArticleList.Items[j];

          if pArticleLoad <> nil then begin
            //�ش� ���� �Խ��ǿ� �۹�ȣ�� ���� ���� ������ �����Ѵ�.
            if (pArticleLoad.OrgNum = OrgNum) and
              (pArticleLoad.SrcNum1 = SrcNum1) and
              (pArticleLoad.SrcNum2 = SrcNum2) and (pArticleLoad.SrcNum3 = SrcNum3) then
            begin
              if pArticleLoad.Kind = KIND_NOTICE then begin
                //���� ������ �����Ŀ� ������ ���� �����Ѵ�.
                //����...
                pArticleList.Delete(j);

                // ����Ʈ�� ������ �߰��Ѵ�.
                GetMem(pNewArticleLoad, sizeof(TGaBoardArticleLoad));

                // �д� ���� ����
                pNewArticleLoad.AgitNum   := 0;
                pNewArticleLoad.GuildName := gname;
                pNewArticleLoad.OrgNum    := 0;
                pNewArticleLoad.SrcNum1   := 0;
                pNewArticleLoad.SrcNum2   := 0;
                pNewArticleLoad.SrcNum3   := 0;
                pNewArticleLoad.Kind      := KIND_NOTICE;
                pNewArticleLoad.UserName  := 'GuildMaster';
                //���� (sonmg 2005/05/06)
                pNewArticleLoad.Content   := 'Guild master''s message is empty.';

                pArticleList.Insert(GABOARD_NOTICE_LINE - 1, pNewArticleLoad);
                break;
              end else begin
                //����...
                pArticleList.Delete(j);
                break;
              end;
            end;
          end;
        end;
      end;
    end;
  end;

  Result := SQLEngine.RequestGuildAgitBoardDelArticle(
    gname, OrgNum, SrcNum1, SrcNum2, SrcNum3, uname);
end;

function TGuildAgitBoardManager.EditArticle(gname, uname, Data: string): boolean;
var
  i, j: integer;
  OrgNum, SrcNum1, SrcNum2, SrcNum3: integer;
  pEachSearchBoardList: PTSearchGaBoardList;
  pArticleList: TList;
  pArticleLoad: PTGaBoardArticleLoad;
begin
  Result := False;

  ConvertNumSeriesToInteger(Data, OrgNum, SrcNum1, SrcNum2, SrcNum3);

  // ������ ������ �ۼ����� �� �� ����.
  if Trim(Data) = '' then
    exit;

  for i := 0 to GaBoardList.Count - 1 do begin
    pEachSearchBoardList := PTSearchGaBoardList(GaBoardList.Items[i]);

    // �ش� ������ �Խ��� ����Ʈ.
    if pEachSearchBoardList.GuildName = gname then begin
      pArticleList := pEachSearchBoardList.ArticleList;

      if pArticleList <> nil then begin
        for j := pArticleList.Count - 1 downto 0 do begin
          pArticleLoad := pArticleList.Items[j];

          if pArticleLoad <> nil then begin
            //�ش� ���� �Խ��ǿ� �۹�ȣ�� ���� ���� ������ �����Ѵ�.
            if (pArticleLoad.OrgNum = OrgNum) and
              (pArticleLoad.SrcNum1 = SrcNum1) and
              (pArticleLoad.SrcNum2 = SrcNum2) and (pArticleLoad.SrcNum3 = SrcNum3) then
            begin
              //����...
              FillChar(pArticleLoad.Content, sizeof(pArticleLoad.Content), #0);
              StrPLCopy(pArticleLoad.Content, Data,
                sizeof(pArticleLoad.Content) - 1);
              break;
            end;
          end;
        end;
      end;
    end;
  end;

  Result := SQLEngine.RequestGuildAgitBoardEditArticle(
    gname, OrgNum, SrcNum1, SrcNum2, SrcNum3, uname, Data);
end;


end.

unit DragonSystem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  Grobal2, Hutil32, Envir, usrengn, objBase;

const
  DRAGON_MAX_LEVEL = 13;
  DRAGON_RESETTIME = 15 * 60 * 1000; // �ִ� 15�а��� ���µ����ʴ´�.
  MAP_ATTACK_TIME  = 10 * 1000;      // �㿡�ִ� ����鿡�� �����ϴ� �ð�
  DRAGONITEMFILE   = 'DragonItem.txt';

type
  // ������ �������
  TDropItemInfo = record
    Name:      string;
    FirstRate: integer;
    SecondRate: integer;
    Amount:    integer;
    DropCount: integer;
  end;
  PTDropItemInfo = ^TDropItemInfo;

  // ���� ��������
  TDragonLevelInfo = record
    Level:   integer;
    DropExp: integer;
    DropItemList: TList;
  end;

  TATMapInfo = record
    Envir: TEnvirnoment;
    Mode:  integer;   // 1= ���� , 2= �������� ����
  end;
  PTATMapInfo = ^TATMapInfo;

  TDragonSystem = class(TObject)
  private
    //�ʱ⿡ �ε��Ǿ��� ȭ���̸� ���ε�ÿ� ���
    FInitFileName: string;
    //���� ���� ������ 13�������� �Ǿ��ִ�.
    FLevelInfo:    array [0..DRAGON_MAX_LEVEL - 1] of TDragonLevelInfo;

    FLevel: integer;
    FExp:   integer;

    FLastChangeExpTime: longword; // ������ ����ġ ����ð�
    FLastAttackTme:     longword; // ���������� �ʿ� �ڵ������� �ð�

    // ������ ���� �����¸�
    FAutoAttackMap: TList;

    FDropMapName:  string;
    FDopItemEnvir: TEnvirnoment;
    FDropItemRect: TRect;
    FExpDivider:   integer;

    procedure RemoveAll;
    procedure InitFirst;
    function DecodeStrInfo(StrInfo: TStringList; var IsSuccess: boolean): string;
    function GetNextLevelExp: integer;
    procedure ResetLevel;

    procedure SetExpDivider(divvalue: integer);
    function GetExpDivider: integer;
  protected
  public
    constructor Create;
    destructor Destroy; override;
    function Initialize(FileName: string; var IsSuccess: boolean): string;
    function Reload(var IsSuccess: boolean): string;
    procedure SetAutoAttackMap(Envir_: TEnvirnoment; Mode_: integer);
    procedure SetItemDropMap(MapName: string; Area_: TRect);

    procedure ChangeExp(exp: integer);
    procedure Run;

    procedure OnLevelup(changelevel: integer);    // �������� �Ǿ����� �ؾ��Ѵ°�
    procedure OnDropItem(changelevel: integer);   // ������ ��ӽ�
    procedure OnMapAutoAttack;                    // �ʿ��ִ»���� �ڵ�����
    procedure OnAutoAttack(Envir_: TEnvirnoment; Mode_: integer);
    procedure OnAttackTarget(Envir_: TEnvirnoment; user_: TCreature;
      Mode_: integer);

    property Level: integer Read FLevel;
    property Exp: integer Read FExp;
    property ExpDivider: integer Read GetExpDivider Write SetExpDivider;

  end;

implementation

uses
  svMain;

constructor TDragonSystem.Create;
var
  RetSuccess: boolean;
begin
  inherited;

  // �⺻������ �ʱ�ȭ
  InitFirst;

  Initialize(FInitFileName, RetSuccess);

  if RetSuccess = False then
  ;  //MainOutMessage('TDragonSystem Initialization Failure');
end;

destructor TDragonSystem.Destroy;
begin

  RemoveAll;

  inherited;
end;

 // �ý����� �����ɶ� ó�� �ʱ�ȭ �ϴºκ�
 //  �޸𸮸� ��� ����������� ����Ҽ� �ִ�.
procedure TDragonSystem.InitFirst;
var
  i: integer;
begin

  try
    // �ʱ� ���� �Է�
    for i := 0 to DRAGON_MAX_LEVEL - 1 do begin
      FLevelInfo[i].Level   := i + 1;
      FLevelInfo[i].DropExp := (i + 1) * 10000;
      FLevelInfo[i].DropItemList := TList.Create;
    end;

    FAutoAttackMap := TList.Create;
  except
  end;

  // ��Ӿ������� �������� ��
  FDopItemEnvir      := nil;
  // �������°� �ʱ�ȭ
  FDropItemRect.Left := -1;
  FDropItemRect.Top  := -1;
  FDropItemRect.Right := -1;
  FDropItemRect.Bottom := -1;


  FLevel := 1;
  FExp   := 0;
  FExpDivider := 1;
  FLastChangeExpTime := GetTickCount; // ������ ����ġ ����ð�
  FLastAttackTme := GetTickCount;     // ���������� �ʿ� �ڵ������� �ð�

  FInitFileName := {EnvirDir +} DRAGONITEMFILE;

end;

// �޸𸮻��� ������ �����
procedure TDragonSystem.RemoveAll;
var
  i, j: integer;
begin

  try
    for i := 0 to DRAGON_MAX_LEVEL - 1 do begin
      // ���������� �ʱ�ȭ �Ǿ�������
      if FLevelInfo[i].DropItemList <> nil then begin
        // �����۸���Ʈ�� ������Ʈ �����.
        for j := FLevelInfo[i].DropItemList.Count - 1 downto 0 do begin
          // ��ü �޸� ����
          dispose(FLevelInfo[i].DropItemList[0]);
          // ����Ʈ����
          FLevelInfo[i].DropItemList.Delete(0);
        end;
        // ����Ʈ Free
        FLevelInfo[i].DropItemList.Free;
        FLevelInfo[i].DropItemList := nil;

      end;
    end;
  except
  end;

  try
    // ������ �ʱ�ȭ
    for i := 0 to FAutoAttackMap.Count - 1 do begin
      dispose(FAutoAttackMap[0]);
      FAutoAttackMap.Delete(0);
    end;
    FAutoAttackMap.Free;
    FAutoAttackMap := nil;
  except
  end;

end;

function TDragonSystem.DecodeStrInfo(StrInfo: TStringList;
  var IsSuccess: boolean): string;
var
  i: integer;
  str, str1, str2, str3: string;
  infostr: string;
  CurrentLevel: integer;
  CurrentExp: integer;
  pDropItemInfo: PTDropItemInfo;
  levelCount: integer;
  expcount: integer;
  itemcount: integer;
begin
  Result    := '';
  IsSuccess := False;

  levelcount := 0;
  expcount   := 0;
  levelcount := 0;
  ItemCount  := 0;

  CurrentLevel := 1;
  CurrentExp   := 10000;

  try
    for i := 0 to StrInfo.Count - 1 do begin
      str := Trim(StrInfo.Strings[i]);

      if (str <> '') and (str[1] <> ';') then begin
        infostr := str[1];

        // ó�����ڰ� ��ɾ���ϰ�쿡
        if infostr = '!' then begin
          str2 := GetValidStr3(str, str1, [' ', #9]);

          //����������
          if CompareText(str1, '!LEVEL') = 0 then begin
            CurrentLevel := Str_ToInt(Trim(Str2), 1);
            //������ �ִ��ּҰ��� ������ ����
            if (CurrentLevel <= 0) and (CurrentLevel >
              DRAGON_MAX_LEVEL) then
            begin
              Result :=
                '[' + IntToStr(i + 1) + '] ' + 'ERROR! LevelInfo Worng 1~' +
                IntToStr(DRAGON_MAX_LEVEL) + ':' + str2;
              Exit;
            end;
            Inc(levelcount);
          end else if CompareText(str1, '!EXP') = 0 then            // ����ġ ǥ����
          begin
            CurrentExp := Str_ToInt(Trim(str2), 0);

            if CurrentExp > 0 then begin
              FLevelInfo[CurrentLevel - 1].DropExp := CurrentExp;
              Inc(expcount);
            end else // ����ġ�� 0�����۰ų� 0�̸� �ȵ�
            begin
              Result :=
                '[' + IntToStr(i + 1) + '] ' + 'ERROR! ExpInfo Worong Exp < 0:' + str2;
              Exit;
            end;
          end else if CompareText(str1, '!DROPMAP') = 0 then begin
            FDropMapName := Trim(str2);
          end else if CompareText(str1, '!DROPAREA') = 0 then begin
            str2 := GetValidStr3(str2, str3, [' ', #9]);
            FDropItemRect.Left := Str_ToInt(str3, -1);
            str2 := GetValidStr3(str2, str3, [' ', #9]);
            FDropItemRect.Top := Str_ToInt(str3, -1);
            str2 := GetValidStr3(str2, str3, [' ', #9]);
            FDropItemRect.Right := Str_ToInt(str3, -1);
            str2 := GetValidStr3(str2, str3, [' ', #9]);
            FDropItemRect.Bottom := Str_ToInt(str3, -1);
          end else begin
            // �׹ۿ� �ٸ� ���ڸ� �ȵ�.
            Result := '[' + IntToStr(i + 1) + '] ' + 'ERROR! Check String :' + str1;
            Exit;
          end;
        end else begin
          new(pDropItemInfo);

          // �������̸�
          str2 := GetValidStr3(str, str1, [' ', #9]);
          pDropItemInfo.Name := trim(str1);

          // ������ Ȯ����
          str2 := GetValidStr3(str2, str1, [' ', #9]);
          pDropItemInfo.FirstRate := Str_ToInt(str1, 0);

          //�и��� Ȯ����
          str2 := GetValidStr3(str2, str1, [' ', #9]);
          pDropItemInfo.SecondRate := Str_ToInt(str1, 1);

          // ��
          str2 := GetValidStr3(str2, str1, [' ', #9]);
          pDropItemInfo.Amount := Str_ToInt(str1, 1);

          // ���Ƚ��
          str2 := GetValidStr3(str2, str1, [' ', #9]);
          pDropItemInfo.DropCount := Str_ToInt(str1, 1);

          //üũ ��ƾ��
          // ������ Ȯ�� �˻�
          if pDropItemInfo.FirstRate > pDropItemInfo.SecondRate then begin
            Result := '[' + IntToStr(i + 1) + '] ' + 'ERROR! FirstRate > SeconRate ';
            dispose(pDropItemInfo);
            Exit;
          end;
          // �������� ���� �˻� 
          if pDropItemInfo.DropCount < 1 then begin
            Result := '[' + IntToStr(i + 1) + '] ' + 'ERROR! DropCount is 0 ';
            dispose(pDropItemInfo);
            Exit;
          end;


          FLevelInfo[CurrentLevel - 1].DropItemList.Add(pDropItemInfo);

          Inc(itemcount);

        end;

      end;// ���ý�Ʈ���ΰ��

    end;//for i...
  except
  end;

  IsSuccess := True;
  Result    := 'READ SUCCESS Level:' + IntToStr(LevelCount) + ' ,Exp:' +
    IntToStr(ExpCount) + ' ,ITEM' + IntToStr(ItemCount) + ' DROPMAP: ' +
    FDropMapName + 'DROPAREA: ' + ' X1:' + IntToStr(FDropItemRect.Left) +
    ',' + ' Y1:' + IntToStr(FDropItemRect.Top) + ',' + ' X2:' +
    IntToStr(FDropItemRect.Right) + ',' + ' Y2:' + IntToStr(FDropItemRect.Bottom);

end;

function TDragonSystem.Initialize(FileName: string; var IsSuccess: boolean): string;
var
  fileinfo: TStringList;
begin
  Result    := '';
  IsSuccess := False;

  try
    // ȭ���� �����ϴ��� �˾ƺ���.
    if not FileExists(FileName) then begin
      Result := self.ClassName + '|Do not Find FileName:' + FileName;
      Exit;
    end;

    fileinfo := TStringList.Create;
    fileinfo.LoadFromFile(FileName);

    // ȭ���� ���ڵ忡 �ִ´�.
    Result := DecodeStrInfo(fileinfo, IsSuccess);

    fileinfo.Free;
  except
  end;
end;

function TDragonSystem.reload(var IsSuccess: boolean): string;
begin
  RemoveAll;
  InitFirst;
  Result := Initialize(FInitFileName, IsSuccess);
end;

function TDragonSystem.GetNextLevelExp: integer;
begin
  if (FLEVEL > 0) and (FLEVEL <= DRAGON_MAX_LEVEL) then
    Result := (FLevelInfo[FLEVEL - 1].DropExp) div FExpDivider
  else
    Result := $7FFFFFFF;
end;

procedure TDragonSystem.OnLevelup(changelevel: integer);
begin

  // �������� ������.
  OnDropItem(changelevel);

end;

// �������� �ʿ� ���ž� �Ҷ�..
procedure TDragonSystem.OnDropItem(changelevel: integer);
var
  i, j, px, py: integer;
  pinfo: PTDropItemInfo;
  slope1, slope2, slope3, slope4: integer;
  LowValue, HighValue: integer;
  itemmakeindex: integer;
begin
  if (changelevel < 1) or (changelevel >= 13) then
    exit;

  for i := 0 to FLevelInfo[changelevel - 1].DropItemList.Count - 1 do begin
    pinfo := PTDropItemInfo(FLevelInfo[changelevel - 1].DropItemList[i]);

    for j := 0 to pinfo.DropCount - 1 do begin
      if random(pinfo.secondrate) < pinfo.FirstRate then begin
        px := random(abs(FDropItemRect.Right - FDropItemRect.Left) + 1) +
          FDropItemRect.Left;
        // Old Code...(���簢��)
        //                  py := random( abs(FDropItemRect.Bottom - FDropItemRect.Top ) ) + FDropItemRect.Top;

        // �밢�� �������� ����(sonmg)
        // �밢�� ������ �����ϴ� �� ������ ���⸦ ���Ѵ�.
        slope1 := FDropItemRect.Left + FDropItemRect.Top + 4; // 121
        slope2 := FDropItemRect.Right + FDropItemRect.Bottom - 4;   // 133
        slope3 := FDropItemRect.Top - FDropItemRect.Left - 4; // -33
        slope4 := FDropItemRect.Bottom - FDropItemRect.Right + 4;   // -25
        // ������ x��ǥ(px)���� ������ y��ǥ(py) ������ ���Ѵ�.
        LowValue := _MAX(slope1 - px, px + slope3);
        HighValue := _MIN(slope2 - px, px + slope4);
        //                  LowValue := _MAX(77 + 44 - px, px - 83 + 50);
        //                  HighValue := _MIN(79 + 54 - px, px - 73 + 48);
        // ������ ���� ������ Random �� y��ǥ�� ���Ѵ�.
        py := Random(HighValue - LowValue + 1) + LowValue;
        itemmakeindex := 0;
        itemmakeindex :=
          UserEngine.MakeItemToMap(FDropMapName, pinfo.Name, pinfo.Amount, px, py);

        if itemmakeindex <> 0 then begin

          AddUserLog('15'#9 + //����_
            FDropMapName + ''#9 + IntToStr(px) + ''#9 + IntToStr(py) +
            ''#9 + 'EvilMir' + ''#9 + pInfo.Name + ''#9 + IntToStr(itemmakeindex) +
            ''#9 + '0' + ''#9 + '0');

          //                    MainOutMessage('DRAGON GIVE ITEM MAP:('+IntTOStr(changelevel)+')'+FDropMapName +
          //                    'ITEMNAME:'+pinfo.Name +'AMOUNT:'+intToStr(pInfo.Amount)+'X:'+
          //                    IntTOStr(px )+'Y:'+IntToStr(py));

        end;
      end;
    end;

  end;
end;

procedure TDragonSystem.OnAttackTarget(Envir_: TEnvirnoment;
  user_: TCreature; Mode_: integer);
var
  pwr, dam: integer;
begin
  if (not user_.Death) and (not user_.BoGhost) and (not user_.BoSysopMode) and
    (not user_.BoSuperviserMode) then begin

    // ����Ʈ �����ְ�...
    case Mode_ of
      1: user_.SendRefMsg(RM_NORMALEFFECT, 0, user_.CX, user_.CY, NE_THUNDER, '');
      2: user_.SendRefMsg(RM_NORMALEFFECT, 0, user_.CX, user_.CY, NE_FIRE, '');
    end;

    // ������ ����� �����ش�.
    pwr := 20 * (random(3) + 1);
    dam := user_.GetMagStruckDamage(nil, pwr);
    user_.StruckDamage(dam, nil);
    user_.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
      user_.WAbil.HP{lparam1}, user_.WAbil.MaxHP{lparam2}, longint(nil){hiter}, '', 200);

  end;

end;

procedure TDragonSystem.OnAutoAttack(Envir_: TEnvirnoment; Mode_: integer);
var
  userlist: TList;
  usercount: integer;
  i: integer;
  Tempuser: TCreature;
begin
  userlist  := TList.Create;
  usercount := UserEngine.GetAreaAllUsers(Envir_, userlist);

  for i := 0 to userlist.Count - 1 do begin
    Tempuser := TCreature(UserList[i]);

    // ����� �����Ѵ�.
    if TempUser.RaceServer = RC_USERHUMAN then begin
      //�������� �ɸ��� ��������
      if random(2) = 0 then begin
        onAttacktarget(Envir_, Tempuser, Mode_);
      end;
    end;
  end;

  userlist.Clear;
  userlist.Free;
end;

//�ʿ� �ڵ������Ҷ�
procedure TDragonSystem.OnMapAutoAttack;
var
  i: integer;
  pmapinfo: PTATMapInfo;
begin
  for i := 0 to FAutoAttackMap.Count - 1 do begin
    pmapinfo := FAutoAttackMap[i];

    OnAutoAttack(pmapinfo.Envir, pmapinfo.Mode);
  end;
end;

// �ڵ����ݸʿ����� �������Ѵ�.
procedure TDragonSystem.SetAutoAttackMap(Envir_: TEnvirnoment; Mode_: integer);
var
  pmapinfo: PTATMapInfo;
begin

  if FAutoAttackMap <> nil then begin
    new(pmapinfo);
    pmapinfo.Envir := Envir_;
    pmapinfo.Mode  := Mode_;

    FAutoAttackMap.Add(pmapinfo);

  end;
end;

// �������� �������� �ʰ� ������ �����Ѵ�.
procedure TDragonSystem.SetItemDropMap(MapName: string; Area_: TRect);
begin

  FDopItemEnvir := GrobalEnvir.GetEnvir(FDropMapName);
  FDropItemRect := Area_;

end;

// ���� �´°�� ����ġ�� �����Ѵ�.
procedure TDragonSystem.ChangeExp(exp: integer);
begin
  FLastChangeExpTime := GetTickCount;
  // �ִ� �������� ������..
  if FLevel < DRAGON_MAX_LEVEL then begin

    if exp > 0 then begin
      if FEXP < GetNextLevelExp then begin
        FEXP := FEXP + exp;


        if FEXP >= GetNextLevelExp then begin
          FLEVEL := FLEVEL + 1;
          FEXP   := 0;
          //�������� �Ǿ����� �������� ��������.
          OnLevelup(FLEVEL);

          MainOutMessage('DRAGON LEVELUP LEVEL:' + IntToStr(FLEVEL));

        end;

      end; //FEXP <
    end;

  end;
end;

procedure TDragonSystem.SetExpDivider(divvalue: integer);
begin
  if (divvalue <= 1000) and (divvalue >= 1) then begin
    FExpDivider := divvalue;
  end;
end;

function TDragonSystem.GetExpDivider: integer;
begin
  Result := FExpDivider;
end;

// ������ �ð��� ������ ������ �ʱ�ȭ �ȴ�.
procedure TDragonSystem.ResetLevel;
begin
  if (FLevel <> 1) or (FEXP <> 0) then begin
    FLevel := 1;
    FExp   := 0;
    MainOutMessage('DRAGON RESET LEVEL');
  end;
end;

procedure TDragonSystem.Run;
begin
  try
    // ���������� ����ġ �����ð�(Ÿ��������������)�� �����Ǹ�(30������) �������ش�.
    if GetTickCount - FLastChangeExpTime > DRAGON_RESETTIME then begin
      FLastChangeExpTime := GetTickCount;   //�ٽ� �ð��� �ʱ�ȭ ���ش�.
      ResetLevel;
    end;


    if GetTickCount - FLastAttackTme > MAP_ATTACK_TIME then begin
      FLastAttackTme := GetTickCount;
      OnMapAutoAttack;
    end;
  except
    MainOutMessage('EXCEPTION DRAGON SYSTEM');
  end;
end;


end.

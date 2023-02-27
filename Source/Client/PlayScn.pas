unit PlayScn;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DXDraws, DXClass, DirectX, IntroScn, Grobal2, CliUtil, HUtil32,
  Actor, HerbActor, AxeMon, SoundUtil, ClEvent, Wil,
  StdCtrls, clFunc, magiceff, ExtCtrls;

const
  MAPSURFACEWIDTH = 800;
  MAPSURFACEHEIGHT = 550;
  LONGHEIGHT_IMAGE = 35;
  FLASHBASE = 410;
  AAX   = 16;
  SOFFX = 0;
  SOFFY = 0;
  LMX   = 30;
  LMY   = 26;

  SCREENWIDTH  = 800;
  SCREENHEIGHT = 600;

  MAXLIGHT = 5;
  LightFiles: array[0..MAXLIGHT] of string = (
    'Data\lig0a.dat',
    'Data\lig0b.dat',
    'Data\lig0c.dat',
    'Data\lig0d.dat',
    'Data\lig0e.dat',
    'Data\lig0f.dat'
    );
  LightSizes: array[0..MAXLIGHT] of integer = (
    34496,
    161280,
    327360,
    405920,
    542976,
    713632
    );

  LightMask0: array[0..2, 0..2] of shortint = (
    (0, 1, 0),
    (1, 3, 1),
    (0, 1, 0)
    );
  LightMask1: array[0..4, 0..4] of shortint = (
    (0, 1, 1, 1, 0),
    (1, 1, 3, 1, 1),
    (1, 3, 4, 3, 1),
    (1, 1, 3, 1, 1),
    (0, 1, 2, 1, 0)
    );
  LightMask2: array[0..8, 0..8] of shortint = (
    (0, 0, 0, 1, 1, 1, 0, 0, 0),
    (0, 0, 1, 2, 3, 2, 1, 0, 0),
    (0, 1, 2, 3, 4, 3, 2, 1, 0),
    (1, 2, 3, 4, 4, 4, 3, 2, 1),
    (1, 3, 4, 4, 4, 4, 4, 3, 1),
    (1, 2, 3, 4, 4, 4, 3, 2, 1),
    (0, 1, 2, 3, 4, 3, 2, 1, 0),
    (0, 0, 1, 2, 3, 2, 1, 0, 0),
    (0, 0, 0, 1, 1, 1, 0, 0, 0)
    );
  LightMask3: array[0..10, 0..10] of shortint = (
    (0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0),
    (0, 0, 0, 1, 2, 2, 2, 1, 0, 0, 0),
    (0, 0, 1, 2, 3, 3, 3, 2, 1, 0, 0),
    (0, 1, 2, 3, 4, 4, 4, 3, 2, 1, 0),
    (1, 2, 3, 4, 4, 4, 4, 4, 3, 2, 1),
    (2, 3, 4, 4, 4, 4, 4, 4, 4, 3, 2),
    (1, 2, 3, 4, 4, 4, 4, 4, 3, 2, 1),
    (0, 1, 2, 3, 4, 4, 4, 3, 2, 1, 0),
    (0, 0, 1, 2, 3, 3, 3, 2, 1, 0, 0),
    (0, 0, 0, 1, 2, 2, 2, 1, 0, 0, 0),
    (0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0)
    );

  LightMask4: array[0..14, 0..14] of shortint = (
    (0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 1, 1, 2, 2, 2, 1, 1, 0, 0, 0, 0),
    (0, 0, 0, 1, 1, 2, 3, 3, 3, 2, 1, 1, 0, 0, 0),
    (0, 0, 1, 1, 2, 3, 4, 4, 4, 3, 2, 1, 1, 0, 0),
    (0, 1, 1, 2, 3, 4, 4, 4, 4, 4, 3, 2, 1, 1, 0),
    (1, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1, 1),
    (1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1),
    (1, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 3, 2, 1, 1),
    (0, 1, 1, 2, 3, 4, 4, 4, 4, 4, 3, 2, 1, 1, 0),
    (0, 0, 1, 1, 2, 3, 4, 4, 4, 3, 2, 1, 1, 0, 0),
    (0, 0, 0, 1, 1, 2, 3, 3, 3, 2, 1, 1, 0, 0, 0),
    (0, 0, 0, 0, 1, 1, 2, 2, 2, 1, 1, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0)
    );

  LightMask5: array[0..16, 0..16] of shortint = (
    (0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 1, 2, 4, 4, 4, 2, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 1, 2, 4, 4, 4, 4, 4, 2, 1, 0, 0, 0, 0),
    (0, 0, 0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0, 0, 0),
    (0, 0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0, 0),
    (0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0),
    (1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1),
    (1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1),
    (1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1),
    (0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0),
    (0, 0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0, 0),
    (0, 0, 0, 1, 2, 4, 4, 4, 4, 4, 4, 4, 2, 1, 0, 0, 0),
    (0, 0, 0, 0, 1, 2, 4, 4, 4, 4, 4, 2, 1, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 1, 2, 4, 4, 4, 2, 1, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 1, 2, 2, 2, 1, 0, 0, 0, 0, 0, 0),
    (0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0)
     { (0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0),
      (0,0,0,0,0,0,0,1,2,2,2,1,0,0,0,0,0,0,0),
      (0,0,0,0,0,0,1,2,4,4,4,2,1,0,0,0,0,0,0),
      (0,0,0,0,0,1,2,4,4,4,4,4,2,1,0,0,0,0,0),
      (0,0,0,0,1,2,4,4,4,4,4,4,4,2,1,0,0,0,0),
      (0,0,0,1,2,4,4,4,4,4,4,4,4,4,2,1,0,0,0),
      (0,0,1,2,4,4,4,4,4,4,4,4,4,4,4,2,1,0,0),
      (0,1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1,0),
      (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
      (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
      (1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1),
      (0,1,2,4,4,4,4,4,4,4,4,4,4,4,4,4,2,1,0),
      (0,0,1,2,4,4,4,4,4,4,4,4,4,4,4,2,1,0,0),
      (0,0,0,1,2,4,4,4,4,4,4,4,4,4,2,1,0,0,0),
      (0,0,0,0,1,2,4,4,4,4,4,4,4,2,1,0,0,0,0),
      (0,0,0,0,0,1,2,4,4,4,4,4,2,1,0,0,0,0,0),
      (0,0,0,0,0,0,1,2,4,4,4,2,1,0,0,0,0,0,0),
      (0,0,0,0,0,0,0,1,2,2,2,1,0,0,0,0,0,0,0),
      (0,0,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0) }
    );

type
  PShoftInt = ^shortint;

  TLightEffect = record
    Width:  integer;
    Height: integer;
    PFog:   Pbyte;
  end;

  TLightMapInfo = record
    ShiftX: integer;
    ShiftY: integer;
    light:  integer;
    bright: integer;
  end;

  TPlayScene = class(TScene)
  private
    MapSurface: TDirectDrawSurface;
    ObjSurface: TDirectDrawSurface;

    FogScreen:  array[0..MAPSURFACEHEIGHT, 0..MAPSURFACEWIDTH] of byte;
    PFogScreen: PByte;
    FogWidth, FogHeight: integer;
    Lights:     array[0..MAXLIGHT] of TLightEffect;
    MoveTime:   longword;
    MoveStepCount: integer;
    AniTime:    longword;
    DefXX, DefYY: integer;
    MainSoundTimer: TTimer;

    MsgList:  TList;
    LightMap: array[0..LMX, 0..LMY] of TLightMapInfo;
    procedure DrawTileMap;
    procedure LoadFog;
    procedure ClearLightMap;
    procedure AddLight(x, y, shiftx, shifty, light: integer; nocheck: boolean);
    procedure UpdateBright(x, y, light: integer);
    function CheckOverLight(x, y, light: integer): boolean;
    procedure ApplyLightMap;
    procedure DrawLightEffect(lx, ly, bright: integer);
    procedure EdChatKeyPress(Sender: TObject; var Key: char);
    procedure SoundOnTimer(Sender: TObject);
  public
    EdChat:     TEdit;
    ActorList, TempList: TList;
    GroundEffectList: TList;  //�ٴڿ� �򸮴� ���� ����Ʈ
    EffectList: TList;  //����ȿ�� ����Ʈ
    FlyList:    TList;  //���ƴٴϴ� �� (��������, â, ȭ��)
    BlinkTime:  longword;
    ViewBlink:  boolean;
    constructor Create;
    destructor Destroy; override;
    procedure Initialize; override;
    procedure Finalize; override;
    procedure OpenScene; override;
    procedure CloseScene; override;
    procedure OpeningScene; override;
    procedure DrawMiniMap(surface: TDirectDrawSurface; transparent: boolean);
    procedure PlayScene(MSurface: TDirectDrawSurface); override;
    function ButchAnimal(x, y: integer): TActor;

    function FindActor(id: integer): TActor;
    function FindActorXY(x, y: integer): TActor;
    function IsValidActor(actor: TActor): boolean;
    function NewActor(chrid: integer; cx, cy, cdir: word;
      cfeature, cstate: integer): TActor;
    procedure ActorDied(actor: TObject); //���� actor�� �� ����
    procedure SetActorDrawLevel(actor: TObject; level: integer);
    procedure ClearActors;
    function DeleteActor(id: integer): TActor;
    procedure DelActor(actor: TObject);
    procedure SendMsg(ident, chrid, x, y, cdir, feature, state, param: integer;
      str: string);

    procedure NewMagic(aowner: TActor;
      magid, magnumb, cx, cy, tx, ty, targetcode: integer; mtype: TMagicType;
      Recusion: boolean; anitime: integer; var bofly: boolean);
    procedure DelMagic(magid: integer);
    function NewFlyObject(aowner: TActor; cx, cy, tx, ty, targetcode: integer;
      mtype: TMagicType): TMagicEff;
    //function  NewStaticMagic (aowner: TActor; tx, ty, targetcode, effnum: integer);

    procedure ScreenXYfromMCXY(cx, cy: integer; var sx, sy: integer);
    procedure CXYfromMouseXY(mx, my: integer; var ccx, ccy: integer);
    procedure CXYfromMouseXYMid(mx, my: integer; var ccx, ccy: integer);
    function GetCharacter(x, y, wantsel: integer; var nowsel: integer;
      liveonly: boolean): TActor;
    function GetAttackFocusCharacter(x, y, wantsel: integer;
      var nowsel: integer; liveonly: boolean): TActor;
    function IsSelectMyself(x, y: integer): boolean;
    function GetDropItems(x, y: integer; var inames: string): PTDropItem;
    procedure DropItemsShow;
    function CanRun(sx, sy, ex, ey: integer): boolean;
    function CanWalk(mx, my: integer): boolean;
    function CrashMan(mx, my: integer): boolean; //������� ��ġ�°�?
    function CanFly(mx, my: integer): boolean;
    procedure RefreshScene;
    procedure CleanObjects;
  end;


implementation

uses
  ClMain, FState, Relationship;

constructor TPlayScene.Create;
begin
  MapSurface := nil;
  ObjSurface := nil;
  MsgList    := TList.Create;
  ActorList  := TList.Create;
  TempList   := TList.Create;
  GroundEffectList := TList.Create;
  EffectList := TList.Create;
  FlyList    := TList.Create;
  BlinkTime  := GetTickCount;
  ViewBlink  := False;

  EdChat := TEdit.Create(FrmMain.Owner);
  with EdChat do begin
    Parent := FrmMain;
    BorderStyle := bsNone;
    OnKeyPress := EdChatKeyPress;
    Visible := False;
    MaxLength := 70;
    Ctl3D  := False;
    Left   := 208;
    Top    := SCREENHEIGHT - 19;
    Height := 12;
    Width  := 387;
    Color  := clSilver;
  end;
  MoveTime     := GetTickCount;
  AniTime      := GetTickCount;
  MainAniCount := 0;
  MoveStepCount := 0;
  MainSoundTimer := TTimer.Create(FrmMain.Owner);
  with MainSoundTimer do begin
    OnTimer  := SoundOnTimer;
    Interval := 1;
    Enabled  := False;
  end;
end;

destructor TPlayScene.Destroy;
var
  i: Integer;
begin
  MsgList.Free;

  for i:=0 to ActorList.Count - 1 do
    TActor(ActorList[i]).Free;
  ActorList.Free;
  
  TempList.Free;
  GroundEffectList.Free;
  EffectList.Free;
  FlyList.Free;
  inherited Destroy;
end;

procedure TPlayScene.SoundOnTimer(Sender: TObject);
begin
  PlaySound(s_main_theme);
  MainSoundTimer.Interval := 46 * 1000;
end;

procedure TPlayScene.EdChatKeyPress(Sender: TObject; var Key: char);
begin
  if Key = #13 then begin
    FrmMain.SendSay(EdChat.Text);
    EdChat.Text := '';
    EdChat.Visible := False;
    Key := #0;
    SetImeMode(EdChat.Handle, imSAlpha);
  end;
  if Key = #27 then begin
    EdChat.Text := '';
    EdChat.Visible := False;
    Key := #0;
    SetImeMode(EdChat.Handle, imSAlpha);
  end;
end;

procedure TPlayScene.Initialize;
var
  i: integer;
begin
  MapSurface := TDirectDrawSurface.Create(FrmMain.DXDraw1.DDraw);
  MapSurface.SystemMemory := True;
  MapSurface.SetSize(MAPSURFACEWIDTH + UNITX * 4 + 30, MAPSURFACEHEIGHT + UNITY * 4);
  ObjSurface := TDirectDrawSurface.Create(FrmMain.DXDraw1.DDraw);
  ObjSurface.SystemMemory := True;
  ObjSurface.SetSize(MAPSURFACEWIDTH - SOFFX * 2, MAPSURFACEHEIGHT);

  FogWidth   := MAPSURFACEWIDTH - SOFFX * 2;
  FogHeight  := MAPSURFACEHEIGHT;
  PFogScreen := @FogScreen;
  //PFogScreen := AllocMem (FogWidth * FogHeight);
  ZeroMemory(PFogScreen, MAPSURFACEHEIGHT * MAPSURFACEWIDTH);

  ViewFog := False;
  for i := 0 to MAXLIGHT do
    Lights[i].PFog := nil;
  LoadFog;
end;

procedure TPlayScene.Finalize;
var
  i: integer;
begin
  if MapSurface <> nil then begin
    MapSurface.Free;
    MapSurface := nil;
  end;

  if ObjSurface <> nil then begin
    ObjSurface.Free;
    ObjSurface := nil;
  end;

  for i := 0 to MAXLIGHT do begin
    if Lights[i].PFog <> nil then
      FreeMem(Lights[i].PFog);
  end;
end;

procedure TPlayScene.OpenScene;
begin
  FrmMain.WProgUse.ClearCache;  //�α��� �̹��� ĳ�ø� �����.
  FrmDlg.ViewBottomBox(True);
  //EdChat.Visible := TRUE;
  //EdChat.SetFocus;
  SetImeMode(FrmMain.Handle, LocalLanguage);
  //MainSoundTimer.Interval := 1000;
  //MainSoundTimer.Enabled := TRUE;
end;

procedure TPlayScene.CloseScene;
begin
  //MainSoundTimer.Enabled := FALSE;
  SilenceSound;

  EdChat.Visible := False;
  FrmDlg.ViewBottomBox(False);
end;

procedure TPlayScene.OpeningScene;
begin
end;

procedure TPlayScene.RefreshScene;
var
  i: integer;
begin
  Map.OldClientRect.Left := -1;
  for i := 0 to ActorList.Count - 1 do
    TActor(ActorList[i]).LoadSurface;
end;

procedure TPlayScene.CleanObjects; //���� �ű�, �ڽ� ���� �ʱ�ȭ
var
  i: integer;
begin
  for i := ActorList.Count - 1 downto 0 do begin
    if TActor(ActorList[i]) <> Myself then begin
      TActor(ActorList[i]).Free;
      ActorList.Delete(i);
    end;
  end;
  MsgList.Clear;
  TargetCret  := nil;
  FocusCret   := nil;
  MagicTarget := nil;
  //������ �ʱ�ȭ �ؾ���.
  for i := 0 to GroundEffectList.Count - 1 do
    TMagicEff(GroundEffectList[i]).Free;
  GroundEffectList.Clear;
  for i := 0 to EffectList.Count - 1 do
    TMagicEff(EffectList[i]).Free;
  EffectList.Clear;
end;

{---------------------- Draw Map -----------------------}

procedure TPlayScene.DrawTileMap;
var
  i, j, m, n, imgnum: integer;
  DSurface: TDirectDrawSurface;
begin
  with Map do
    if (ClientRect.Left = OldClientRect.Left) and
      (ClientRect.Top = OldClientRect.Top) then
      exit;
  Map.OldClientRect := Map.ClientRect;
  MapSurface.Fill(0);

  with Map.ClientRect do begin
    m := -UNITY * 2;
    for j := (Top - Map.BlockTop - 1) to (Bottom - Map.BlockTop + 1) do begin
      n := AAX + 14 - UNITX;
      for i := (Left - Map.BlockLeft - 2) to (Right - Map.BlockLeft + 1) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and
          (j < LOGICALMAPUNIT * 3) then begin
          imgnum := (Map.MArr[i, j].BkImg and $7FFF);
          if imgnum > 0 then begin
            if (i mod 2 = 0) and (j mod 2 = 0) then begin
              imgnum   := imgnum - 1;
              DSurface := FrmMain.WTiles.Images[imgnum];
              if Dsurface <> nil then
                MapSurface.Draw(n, m, DSurface.ClientRect, DSurface, False);
            end;
          end;
        end;
        Inc(n, UNITX);
      end;
      Inc(m, UNITY);
    end;
  end;

  with Map.ClientRect do begin
    m := -UNITY;
    for j := (Top - Map.BlockTop - 1) to (Bottom - Map.BlockTop + 1) do begin
      n := AAX + 14 - UNITX;
      for i := (Left - Map.BlockLeft - 2) to (Right - Map.BlockLeft + 1) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and
          (j < LOGICALMAPUNIT * 3) then begin
          imgnum := Map.MArr[i, j].MidImg;
          if imgnum > 0 then begin
            imgnum   := imgnum - 1;
            DSurface := FrmMain.WSmTiles.Images[imgnum];
            if Dsurface <> nil then
              MapSurface.Draw(n, m, DSurface.ClientRect, DSurface, True);
          end;
        end;
        Inc(n, UNITX);
      end;
      Inc(m, UNITY);
    end;
  end;

end;

{----------------------- ����, ����Ʈ ó�� -----------------------}


procedure TPlayScene.LoadFog;  //����Ʈ ����Ÿ �б�
var
  i, fhandle, w, h, prevsize: integer;
  cheat: boolean;
begin
  prevsize := 0; //���� üũ
  cheat    := False;
  for i := 0 to MAXLIGHT do begin
    if FileExists(LightFiles[i]) then begin
      fhandle := FileOpen(LightFiles[i], fmOpenRead or fmShareDenyNone);
      FileRead(fhandle, w, sizeof(integer));
      FileRead(fhandle, h, sizeof(integer));
      Lights[i].Width  := w;
      Lights[i].Height := h;
      Lights[i].PFog   := AllocMem(w * h + 8);
      if prevsize < w * h then begin
        FileRead(fhandle, Lights[i].PFog^, w * h);
      end else
        cheat := True;
      prevsize := w * h;
      if LightSizes[i] <> prevsize then
        cheat := True;
      FileClose(fhandle);
    end;
  end;
  if cheat then
    for i := 0 to MAXLIGHT do begin
      if Lights[i].PFog <> nil then
        FillChar(Lights[i].PFog^, Lights[i].Width * Lights[i].Height + 8, #0);
    end;
end;

procedure TPlayScene.ClearLightMap;
var
  i, j: integer;
begin
  FillChar(LightMap, (LMX + 1) * (LMY + 1) * sizeof(TLightMapInfo), 0);
  for i := 0 to LMX do
    for j := 0 to LMY do
      LightMap[i, j].Light := -1;
end;

procedure TPlayScene.UpdateBright(x, y, light: integer);
var
  i, j, r, lx, ly: integer;
  pmask: ^shortint;
begin
  r := -1;
  case light of
    0: begin
      r     := 2;
      pmask := @LightMask0;
    end;
    1: begin
      r     := 4;
      pmask := @LightMask1;
    end;
    2: begin
      r     := 8;
      pmask := @LightMask2;
    end;
    3: begin
      r     := 10;
      pmask := @LightMask3;
    end;
    4: begin
      r     := 14;
      pmask := @LightMask4;
    end;
    5: begin
      r     := 16;
      pmask := @LightMask5;
    end;
  end;
  for i := 0 to r do
    for j := 0 to r do begin
      lx := x - (r div 2) + i;
      ly := y - (r div 2) + j;
      if (lx in [0..LMX]) and (ly in [0..LMY]) then
        LightMap[lx, ly].bright :=
          LightMap[lx, ly].bright + PShoftInt(integer(pmask) +
          (i * (r + 1) + j) * sizeof(shortint))^;
    end;
end;

function TPlayScene.CheckOverLight(x, y, light: integer): boolean;
var
  i, j, r, mlight, lx, ly, Count, check: integer;
  pmask: ^shortint;
begin
  r := -1;
  case light of
    0: begin
      r     := 2;
      pmask := @LightMask0;
      check := 0;
    end;
    1: begin
      r     := 4;
      pmask := @LightMask1;
      check := 4;
    end;
    2: begin
      r     := 8;
      pmask := @LightMask2;
      check := 8;
    end;
    3: begin
      r     := 10;
      pmask := @LightMask3;
      check := 18;
    end;
    4: begin
      r     := 14;
      pmask := @LightMask4;
      check := 30;
    end;
    5: begin
      r     := 16;
      pmask := @LightMask5;
      check := 40;
    end;
  end;
  Count := 0;
  for i := 0 to r do
    for j := 0 to r do begin
      lx := x - (r div 2) + i;
      ly := y - (r div 2) + j;
      if (lx in [0..LMX]) and (ly in [0..LMY]) then begin
        mlight := PShoftInt(integer(pmask) + (i * (r + 1) + j) * sizeof(shortint))^;
        if LightMap[lx, ly].bright < mlight then begin
          Inc(Count, mlight - LightMap[lx, ly].bright);
          if Count >= check then begin
            Result := False;
            exit;
          end;
        end;
      end;
    end;
  Result := True;
end;

procedure TPlayScene.AddLight(x, y, shiftx, shifty, light: integer; nocheck: boolean);
var
  lx, ly: integer;
begin
  lx := x - Myself.Rx + LMX div 2;
  ly := y - Myself.Ry + LMY div 2;
  if (lx >= 1) and (lx < LMX) and (ly >= 1) and (ly < LMY) then begin
    if LightMap[lx, ly].light < light then begin
      if not CheckOverLight(lx, ly, light) or nocheck then begin
        // > LightMap[lx, ly].light then begin
        UpdateBright(lx, ly, light);
        LightMap[lx, ly].light  := light;
        LightMap[lx, ly].Shiftx := shiftx;
        LightMap[lx, ly].Shifty := shifty;
      end;
    end;
  end;
end;

procedure TPlayScene.ApplyLightMap;
var
  i, j, light, defx, defy, lx, ly, lxx, lyy, lcount: integer;
begin
  defx   := -UNITX * 2 + AAX + 14 - Myself.ShiftX;
  defy   := -UNITY * 3 - Myself.ShiftY;
  lcount := 0;
  for i := 1 to LMX - 1 do
    for j := 1 to LMY - 1 do begin
      light := LightMap[i, j].light;
      if light >= 0 then begin
        lx  := (i + Myself.Rx - LMX div 2);
        ly  := (j + Myself.Ry - LMY div 2);
        lxx := (lx - Map.ClientRect.Left) * UNITX + defx + LightMap[i, j].ShiftX;
        lyy := (ly - Map.ClientRect.Top) * UNITY + defy + LightMap[i, j].ShiftY;

        FogCopy(Lights[light].PFog,
          0,
          0,
          Lights[light].Width,
          Lights[light].Height,
          PFogScreen,
          lxx - (Lights[light].Width - UNITX) div 2,
          lyy - (Lights[light].Height - UNITY) div 2 - 5,
          FogWidth,
          FogHeight,
          20);
        Inc(lcount);
      end;
    end;
end;

procedure TPlayScene.DrawLightEffect(lx, ly, bright: integer);
begin
  if (bright > 0) and (bright <= MAXLIGHT) then
    FogCopy(Lights[bright].PFog,
      0,
      0,
      Lights[bright].Width,
      Lights[bright].Height,
      PFogScreen,
      lx - (Lights[bright].Width - UNITX) div 2,
      ly - (Lights[bright].Height - UNITY) div 2,
      FogWidth,
      FogHeight,
      15);
end;

{-----------------------------------------------------------------------}

procedure TPlayScene.DrawMiniMap(surface: TDirectDrawSurface; transparent: boolean);
var
  d:     TDirectDrawSurface;
  v:     boolean;
  i, k, cl, ix, mx, my: integer;
  rc:    TRect;
  actor: TActor;
begin
  // 2003/02/11 ���ڰŸ��� �ʰ� ��...
  //   if GetTickCount > BlinkTime + 300 then begin
  //      BlinkTime := GetTickCount;
  //      ViewBlink := not ViewBlink;
  //   end;

  d := FrmMain.WMMap.Images[MiniMapIndex];
  if d <> nil then begin
    mx      := (Myself.XX * 48) div 32;
    my      := (Myself.YY * 32) div 32;
    rc.Left := _MAX(0, mx - 60);
    rc.Top  := _MAX(0, my - 60);
    rc.Right := _MIN(d.ClientRect.Right, rc.Left + 120);
    rc.Bottom := _MIN(d.ClientRect.Bottom, rc.Top + 120);

    if transparent then
      DrawBlendEx(surface, (SCREENWIDTH - 120), 0, d, rc.Left, rc.Top, 120, 120, 0)
    else
      surface.Draw((SCREENWIDTH - 120), 0, rc, d, False);

    //    if ViewBlink then begin
    ix := (SCREENWIDTH - 120) - rc.Left;
    // 2003/02/11 �̴ϸʻ� �ٸ� ������Ʈ�� ���
    if ActorList.Count > 0 then begin
      for i := 0 to ActorList.Count - 1 do begin
        mx := ix + (TActor(ActorList[i]).XX * 48) div 32;
        my := (TActor(ActorList[i]).YY * 32) div 32 - rc.Top;
        cl := 0;
        case TActor(ActorList[i]).Race of
          RC_USERHUMAN: if (TActor(ActorList[i]) = Myself) then
              cl := 255
            else if (nil <> fLover) and
              (Length(Trim(TActor(ActorList[i]).UserName)) > 0) and
              (TActor(ActorList[i]).UserName =
              Copy(fLover.GetDisplay(0), length(STR_LOVER) + 1, 20)) and
              (not TActor(ActorList[i]).BoOpenHealth) then begin
              //      DScreen.AddChatBoardString ('TActor(ActorList[i]).UserName=> '+TActor(ActorList[i]).UserName, clYellow, clRed);
              //      DScreen.AddChatBoardString ('fLover.GetDisplay(0)=> '+fLover.GetDisplay(0), clYellow, clRed);
              cl := 253;
            end else
              cl := 0;  // ��� ������� ����...�׷���� ViewList���� ���

          RCC_GUARD,
          RCC_GUARD2,
          RCC_MERCHANT: cl := 251;
          54, 55: cl := 0;
          // �ż� ������� ����...ViewList���� ���...250
          98, 99: cl := 0;
          else
            if ((TActor(ActorList[i]).Visible) and (not TActor(ActorList[i]).Death) and
              (pos('(', TActor(ActorList[i]).UserName) = 0)) then
              cl := 249;
        end;

        if (mx > 680) and (my < 119) then begin //@@@@old
          if cl > 0 then begin
            surface.Pixels[mx - 1, my - 1] := cl;
            surface.Pixels[mx, my - 1] := cl;
            surface.Pixels[mx + 1, my - 1] := cl;
            surface.Pixels[mx - 1, my] := cl;
            surface.Pixels[mx, my]     := cl;
            surface.Pixels[mx + 1, my] := cl;
            surface.Pixels[mx - 1, my + 1] := cl;
            surface.Pixels[mx, my + 1] := cl;
            surface.Pixels[mx + 1, my + 1] := cl;
          end;
        end;
      end;
    end;
    if ViewListCount > 0 then begin
      for i := 1 to ViewListCount do begin
        if ((abs(ViewList[i].x - Myself.XX) < 40) and
          (abs(ViewList[i].y - Myself.YY) < 40)) then begin
          mx := ix + (ViewList[i].x * 48) div 32;
          my := (ViewList[i].y * 32) div 32 - rc.Top;
          if (mx > 680) and (my < 119) then begin //@@@@old
            cl := 252;
            surface.Pixels[mx - 1, my - 1] := cl;
            surface.Pixels[mx, my - 1] := cl;
            surface.Pixels[mx + 1, my - 1] := cl;
            surface.Pixels[mx - 1, my] := cl;
            surface.Pixels[mx, my] := cl;
            surface.Pixels[mx + 1, my] := cl;
            surface.Pixels[mx - 1, my + 1] := cl;
            surface.Pixels[mx, my + 1] := cl;
            surface.Pixels[mx + 1, my + 1] := cl;
          end;
        end;
        // ���������� ������...
        if (((GetTickCount - ViewList[i].LastTick) > 5000) and
          (ViewList[i].Index > 0)) then begin
          // 2003/03/04 �׷�� Ž���Ŀ� ����
          actor := FindActor(ViewList[i].Index);
          if actor <> nil then begin
            actor.BoOpenHealth := False;
            if GroupIdList.Count > 0 then
              for k := 0 to GroupIdList.Count - 1 do begin  // MonOpenHp
                if integer(GroupIdList[k]) = actor.RecogId then begin
                  GroupIdList.Delete(k);
                  Break;
                end;
              end;
          end;
          // ���� ������ �ִٸ� �̵�
          if (ViewListCount > 0) then begin
            ViewList[i].Index := ViewList[ViewListCount].Index;
            ViewList[i].x     := ViewList[ViewListCount].x;
            ViewList[i].y     := ViewList[ViewListCount].y;
            ViewList[i].LastTick := ViewList[ViewListCount].LastTick;
            ViewList[ViewListCount].Index := 0;
            ViewList[ViewListCount].x := 0;
            ViewList[ViewListCount].y := 0;
            ViewList[ViewListCount].LastTick := 0;
          end;
          Dec(ViewListCount);
        end;
      end;
    end;
    //    end;
  end;
end;


{-----------------------------------------------------------------------}


procedure TPlayScene.PlayScene(MSurface: TDirectDrawSurface);

  function CheckOverlappedObject(myrc, obrc: TRect): boolean;
  begin
    if (obrc.Right > myrc.Left) and (obrc.Left < myrc.Right) and
      (obrc.Bottom > myrc.Top) and (obrc.Top < myrc.Bottom) then
      Result := True
    else
      Result := False;
  end;

var
  i, j, k, n, m, mmm, ix, iy, line, defx, defy, wunit, fridx, ani,
  anitick, ax, ay, idx, drawingbottomline: integer;
  DSurface, d: TDirectDrawSurface;
  blend, movetick: boolean;
  //myrc, obrc: TRect;
  pd:     PTDropItem;
  evn:    TClEvent;
  actor:  TActor;
  meff:   TMagicEff;
  msgstr: string;
  px, py, ImgPosX, ImgPosY: integer;
begin
  if (Myself = nil) then begin
    msgstr := 'Please wait just for a little while.';
    with MSurface.Canvas do begin
      SetBkMode(Handle, TRANSPARENT);
      BoldTextOut(MSurface, (SCREENWIDTH - TextWidth(msgstr)) div 2, 200,
        clWhite, clBlack, msgstr);
      Release;
    end;
    exit;
  end;

  DoFastFadeOut := False;

  //ĳ���Ϳ��鿡�� �޼����� ����    07/03
  movetick := False;
  if GetTickCount - MoveTime >= 100 then begin
    MoveTime := GetTickCount;   //�̵��� ����ȭ
    movetick := True;           //�̵� ƽ
    Inc(MoveStepCount);
    if MoveStepCount > 1 then
      MoveStepCount := 0;
  end;
  if GetTickCount - AniTime >= 50 then begin
    AniTime := GetTickCount;
    Inc(MainAniCount);
    if MainAniCount > 1000000 then
      MainAniCount := 0;
  end;

  try
    i := 0;                          //����� �޼����� ó����
    while True do begin              //Frame ó���� ���⼭ ����.
      if i >= ActorList.Count then
        break;
      actor := ActorList[i];
      if movetick then
        actor.LockEndFrame := False;
      if not actor.LockEndFrame then begin
        actor.ProcMsg;   //�޼��� ó���ϸ鼭 actor�� ������ �� ����.
        if movetick then
          if actor.Move(MoveStepCount) then begin  //����ȭ�ؼ� ������
            Inc(i);
            continue;
          end;
        actor.Run;    //ĳ���͵��� �����̰� ��.
        if actor <> Myself then
          actor.ProcHurryMsg;
      end;
      if actor = Myself then
        actor.ProcHurryMsg;
      //������ ���
      if actor.WaitForRecogId <> 0 then begin
        if actor.IsIdle then begin
          DelChangeFace(actor.WaitForRecogId);
          NewActor(actor.WaitForRecogId, actor.XX, actor.YY,
            actor.Dir, actor.WaitForFeature, actor.WaitForStatus);
          actor.WaitForRecogId := 0;
          actor.BoDelActor     := True;
        end;
      end;
      if actor.BoDelActor then begin
        //actor.Free;
        FreeActorList.Add(actor);
        ActorList.Delete(i);
        if TargetCret = actor then
          TargetCret := nil;
        if FocusCret = actor then
          FocusCret := nil;
        if MagicTarget = actor then
          MagicTarget := nil;
      end else
        Inc(i);
    end;
  except
    DebugOutStr('101');
  end;

  try
    i := 0;
    while True do begin
      if i >= GroundEffectList.Count then
        break;
      meff := GroundEffectList[i];
      if meff.Active then begin
        if not meff.Run then begin //����ȿ��
          meff.Free;
          GroundEffectList.Delete(i);
          continue;
        end;
      end;
      Inc(i);
    end;
    i := 0;
    while True do begin
      if i >= EffectList.Count then
        break;
      meff := EffectList[i];
      if meff.Active then begin
        if not meff.Run then begin //����ȿ��
          meff.Free;
          EffectList.Delete(i);
          continue;
        end;
      end;
      Inc(i);
    end;
    i := 0;
    while True do begin
      if i >= FlyList.Count then
        break;
      meff := FlyList[i];
      if meff.Active then begin
        if not meff.Run then begin //����,ȭ��� ���ư��°�
          meff.Free;
          FlyList.Delete(i);
          continue;
        end;
      end;
      Inc(i);
    end;

    EventMan.Execute;
  except
    DebugOutStr('102');
  end;

  try
    //����� ������ üũ
    for k := 0 to DropedItemList.Count - 1 do begin
      pd := PTDropItem(DropedItemList[k]);
      if pd <> nil then begin
        if (Abs(pd.x - Myself.XX) > 30) and (Abs(pd.y - Myself.YY) > 30) then begin
          Dispose(PTDropItem(DropedItemList[k]));
          DropedItemList.Delete(k);
          break;  //�ѹ��� �Ѱ���..
        end;
      end;
    end;
    //����� ���̳��Ϳ�����Ʈ �˻�
    for k := 0 to EventMan.EventList.Count - 1 do begin
      evn := TClEvent(EventMan.EventList[k]);
      if (Abs(evn.X - Myself.XX) > 30) and (Abs(evn.Y - Myself.YY) > 30) then begin
        evn.Free;
        EventMan.EventList.Delete(k);
        break;  //�ѹ��� �Ѱ���
      end;
    end;
  except
    DebugOutStr('103');
  end;

  try
    with Map.ClientRect do begin
      Left   := MySelf.Rx - 9;
      Top    := MySelf.Ry - 9;
      Right  := MySelf.Rx + 9;                         // ������ ¥���� �׸�
      Bottom := MySelf.Ry + 8;
    end;
    Map.UpdateMapPos(Myself.Rx, Myself.Ry);

    ///////////////////////
    //ViewFog := FALSE;
    ///////////////////////

    if NoDarkness or (Myself.Death) then begin
      ViewFog := False;
    end;

    if ViewFog then begin //����
      ZeroMemory(PFogScreen, MAPSURFACEHEIGHT * MAPSURFACEWIDTH);
      ClearLightMap;
    end;

    drawingbottomline := 450;
    ObjSurface.Fill(0);
    DrawTileMap;
    ObjSurface.Draw(0, 0,
      Rect(UNITX * 3 + Myself.ShiftX, UNITY * 2 + Myself.ShiftY,
      UNITX * 3 + Myself.ShiftX + MAPSURFACEWIDTH, UNITY * 2 +
      Myself.ShiftY + MAPSURFACEHEIGHT),
      MapSurface,
      False);

  except
    DebugOutStr('104');
  end;

  defx  := -UNITX * 2 - Myself.ShiftX + AAX + 14;
  defy  := -UNITY * 2 - Myself.ShiftY;
  DefXX := defx;
  DefYY := defy;

  try
    m := defy - UNITY;
    for j := (Map.ClientRect.Top - Map.BlockTop)
      to (Map.ClientRect.Bottom - Map.BlockTop + LONGHEIGHT_IMAGE) do begin
      if j < 0 then begin
        Inc(m, UNITY);
        continue;
      end;
      n := defx - UNITX * 2;
      //*** 48*32 Ÿ���� ������Ʈ �׸���
      for i := (Map.ClientRect.Left - Map.BlockLeft - 2)
        to (Map.ClientRect.Right - Map.BlockLeft + 2) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and
          (j < LOGICALMAPUNIT * 3) then begin
          fridx := (Map.MArr[i, j].FrImg) and $7FFF;
          if fridx > 0 then begin
            ani   := Map.MArr[i, j].AniFrame;
            wunit := Map.MArr[i, j].Area;
            if (ani and $80) > 0 then begin
              blend := True;
              ani   := ani and $7F;
            end;
            if ani > 0 then begin
              anitick := Map.MArr[i, j].AniTick;
              fridx   := fridx + (MainAniCount mod (ani + (ani * anitick))) div
                (1 + anitick);
            end;
            if (Map.MArr[i, j].DoorOffset and $80) > 0 then begin //����
              if (Map.MArr[i, j].DoorIndex and $7F) > 0 then  //������ ǥ�õ� �͸�
                fridx := fridx + (Map.MArr[i, j].DoorOffset and $7F); //���� ��
            end;
            fridx    := fridx - 1;
            // ��ü �׸�
            DSurface := FrmMain.GetObjs(wunit, fridx);
            if DSurface <> nil then begin
              if (DSurface.Width = 48) and (DSurface.Height = 32) then begin
                mmm := m + UNITY - DSurface.Height;
                if (n + DSurface.Width > 0) and (n <= SCREENWIDTH) and
                  (mmm + DSurface.Height > 0) and (mmm < drawingbottomline) then begin
                  ObjSurface.Draw(n, mmm, DSurface.ClientRect, Dsurface, True);
                end else begin
                  if mmm < drawingbottomline then begin
                    //���ʿ��ϰ� �׸��� ���� ����
                    ObjSurface.Draw(n, mmm, DSurface.ClientRect, DSurface, True);
                  end;
                end;
              end;
            end;
          end;
        end;
        Inc(n, UNITX);
      end;
      Inc(m, UNITY);
    end;

    //���ٴڿ� �׷����� ����
    for k := 0 to GroundEffectList.Count - 1 do begin
      meff := TMagicEff(GroundEffectList[k]);
      //if j = (meff.Ry - Map.BlockTop) then begin
      meff.DrawEff(ObjSurface);
      if ViewFog then begin
        AddLight(meff.Rx, meff.Ry, 0, 0, meff.light, False);
      end;
    end;

  except
    DebugOutStr('105');
  end;

  try
    m := defy - UNITY;
    for j := (Map.ClientRect.Top - Map.BlockTop)
      to (Map.ClientRect.Bottom - Map.BlockTop + LONGHEIGHT_IMAGE) do begin
      if j < 0 then begin
        Inc(m, UNITY);
        continue;
      end;
      n := defx - UNITX * 2;
      //*** ��������Ʈ �׸���
      for i := (Map.ClientRect.Left - Map.BlockLeft - 2)
        to (Map.ClientRect.Right - Map.BlockLeft + 2) do begin
        if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and
          (j < LOGICALMAPUNIT * 3) then begin
          fridx := (Map.MArr[i, j].FrImg) and $7FFF;
          if fridx > 0 then begin
            blend := False;
            wunit := Map.MArr[i, j].Area;
            //���ϸ��̼�
            ani   := Map.MArr[i, j].AniFrame;
            if (ani and $80) > 0 then begin
              blend := True;
              ani   := ani and $7F;
            end;
            if ani > 0 then begin
              anitick := Map.MArr[i, j].AniTick;
              fridx   := fridx + (MainAniCount mod (ani + (ani * anitick))) div
                (1 + anitick);
            end;
            if (Map.MArr[i, j].DoorOffset and $80) > 0 then begin //����
              if (Map.MArr[i, j].DoorIndex and $7F) > 0 then  //������ ǥ�õ� �͸�
                fridx := fridx + (Map.MArr[i, j].DoorOffset and $7F); //���� ��
            end;
            fridx := fridx - 1;
            // ��ü �׸�
            if not blend then begin
              DSurface := FrmMain.GetObjs(wunit, fridx);
              if DSurface <> nil then begin
                if (DSurface.Width <> 48) or (DSurface.Height <> 32) then begin
                  mmm := m + UNITY - DSurface.Height;
                  if (n + DSurface.Width > 0) and (n <= SCREENWIDTH) and
                    (mmm + DSurface.Height > 0) and (mmm < drawingbottomline) then begin
                    ObjSurface.Draw(n, mmm, DSurface.ClientRect, Dsurface, True);
                  end else begin
                    if mmm < drawingbottomline then begin
                      //���ʿ��ϰ� �׸��� ���� ����
                      ObjSurface.Draw(n, mmm, DSurface.ClientRect,
                        DSurface, True);
                    end;
                  end;
                end;
              end;
            end else begin
              DSurface := FrmMain.GetObjsEx(wunit, fridx, ax, ay);
              if DSurface <> nil then begin
                mmm := m + ay - 68; //UNITY - DSurface.Height;
                if (n > 0) and (mmm + DSurface.Height > 0) and
                  (n + Dsurface.Width < SCREENWIDTH) and (mmm < drawingbottomline) then
                begin
                  DrawBlend(ObjSurface, n + ax - 2, mmm, DSurface, 1);
                end else begin
                  if mmm < drawingbottomline then begin
                    //���ʿ��ϰ� �׸��� ���� ����
                    DrawBlend(ObjSurface, n + ax - 2, mmm, DSurface, 1);
                  end;
                end;
              end;
            end;
          end;

        end;
        Inc(n, UNITX);
      end;

      if (j <= (Map.ClientRect.Bottom - Map.BlockTop)) and (not BoServerChanging) then
      begin

        //*** �ٴڿ� ����� ���� ����
        for k := 0 to EventMan.EventList.Count - 1 do begin
          evn := TClEvent(EventMan.EventList[k]);
          if j = (evn.Y - Map.BlockTop) then begin
            evn.DrawEvent(ObjSurface,
              (evn.X - Map.ClientRect.Left) * UNITX + defx,
              m);
          end;
        end;

        //*** �ٴڿ� ������ ������ �׸���
        for k := 0 to DropedItemList.Count - 1 do begin
          pd := PTDropItem(DropedItemList[k]);
          if pd <> nil then begin

            if j = (pd.y - Map.BlockTop) then begin
              if pd.BoDeco then
                d := FrmMain.WDecoImg.Images[pd.Looks]
              else
                d := FrmMain.WDnItem.Images[pd.Looks];

              if d <> nil then begin
                ix := (pd.x - Map.ClientRect.Left) * UNITX + defx + SOFFX;
                // + actor.ShiftX;
                iy := m; // + actor.ShiftY;
                if pd.BoDeco then begin
                  FrmMain.WDecoImg.GetCachedImage(pd.Looks, px, py);
                  ImgPosX := ix + px;
                  ImgPosY := iy + py;
                end else begin
                  ImgPosX := ix + HALFX - (d.Width div 2);
                  ImgPosY := iy + HALFY - (d.Height div 2);
                end;
                if pd = FocusItem then begin
                  if (d.Width > ImgMixSurface.Width) or
                    (d.Height > ImgMixSurface.Height) then begin
                    ImgLargeMixSurface.Draw(0, 0, d.ClientRect, d, False);
                    DrawEffect(0, 0, d.Width, d.Height,
                      ImgLargeMixSurface, ceBright);
                    ObjSurface.Draw(ImgPosX, ImgPosY,
                      d.ClientRect,
                      ImgLargeMixSurface, True);
                  end else begin
                    ImgMixSurface.Draw(0, 0, d.ClientRect, d, False);
                    DrawEffect(0, 0, d.Width, d.Height, ImgMixSurface, ceBright);
                    //                        ObjSurface.Draw (ix + HALFX-(d.Width div 2),
                    //                                      iy + HALFY-(d.Height div 2),
                    //                                      d.ClientRect,
                    //                                      ImgMixSurface, TRUE);
                    ObjSurface.Draw(ImgPosX, ImgPosY,
                      d.ClientRect,
                      ImgMixSurface, True);
                  end;
                end else
                  //                        ObjSurface.Draw (ix + HALFX-(d.Width div 2),
                  //                                      iy + HALFY-(d.Height div 2),
                  //                                      d.ClientRect,
                  //                                      d, TRUE);
                  ObjSurface.Draw(ImgPosX, ImgPosY,
                    d.ClientRect,
                    d, True);

              end;
            end;
          end;
        end;

        //*** ĳ���� �׸���
        for k := 0 to ActorList.Count - 1 do begin
          actor := ActorList[k];
          if actor.Race = 81 then begin  // ����(õ��)
            if actor.State and $00800000 = 0 then begin//������ �ƴϸ�
              actor.DrawChr(ObjSurface,
                (actor.Rx - Map.ClientRect.Left) * UNITX + defx,
                (actor.Ry - Map.ClientRect.Top - 1) * UNITY + defy, True, False);
            end;
          end;

          if (j = actor.Ry - Map.BlockTop - actor.DownDrawLevel) then begin
            actor.SayX := (actor.Rx - Map.ClientRect.Left) * UNITX +
              defx + actor.ShiftX + 24;
            if actor.Death then
              actor.SayY :=
                m + UNITY + actor.ShiftY + 16 - 60 + (actor.DownDrawLevel * UNITY)
            else
              actor.SayY := m + UNITY + actor.ShiftY + 16 - 95 +
                (actor.DownDrawLevel * UNITY);
            actor.DrawChr(ObjSurface, (actor.Rx - Map.ClientRect.Left) * UNITX + defx,
              m + (actor.DownDrawLevel * UNITY),
              False, True);
          end;
        end;
        for k := 0 to FlyList.Count - 1 do begin
          meff := TMagicEff(FlyList[k]);
          if j = (meff.Ry - Map.BlockTop) then
            meff.DrawEff(ObjSurface);
        end;

      end;
      Inc(m, UNITY);
    end;
  except
    DebugOutStr('106');
  end;


  try
    if ViewFog then begin
      m := defy - UNITY * 4;
      for j := (Map.ClientRect.Top - Map.BlockTop - 4)
        to (Map.ClientRect.Bottom - Map.BlockTop + LONGHEIGHT_IMAGE) do begin
        if j < 0 then begin
          Inc(m, UNITY);
          continue;
        end;
        n := defx - UNITX * 5;
        //��� ���� �׸���
        for i := (Map.ClientRect.Left - Map.BlockLeft - 5)
          to (Map.ClientRect.Right - Map.BlockLeft + 5) do begin
          if (i >= 0) and (i < LOGICALMAPUNIT * 3) and (j >= 0) and
            (j < LOGICALMAPUNIT * 3) then begin
            idx := Map.MArr[i, j].Light;
            if idx > 0 then begin
              AddLight(i + Map.BlockLeft, j + Map.BlockTop, 0, 0, idx, False);
            end;
          end;
          Inc(n, UNITX);
        end;
        Inc(m, UNITY);
      end;

      //ĳ���� ���� �׸���
      if ActorList.Count > 0 then begin
        for k := 0 to ActorList.Count - 1 do begin
          actor := ActorList[k];
          if (actor = Myself) or (actor.Light > 0) then
            AddLight(actor.Rx, actor.Ry, actor.ShiftX, actor.ShiftY,
              actor.Light, actor = Myself);
        end;
      end else begin
        if Myself <> nil then
          AddLight(Myself.Rx, Myself.Ry, Myself.ShiftX, Myself.ShiftY,
            Myself.Light, True);
      end;
    end;
  except
    DebugOutStr('107');
  end;

  if not BoServerChanging then begin
    try
      if (MagicTarget <> nil) then begin
        //         if IsValidActor (MagicTarget) and (MagicTarget <> Myself) then
        //         if IsValidActor (MagicTarget) and (MagicTarget <> Myself) and ((actor.Race <> 81)) then
        if IsValidActor(MagicTarget) and (MagicTarget <> Myself) and
          ((MagicTarget.Race <> 81)) then
          if MagicTarget.State and $00800000 = 0 then //������ �ƴϸ�
            MagicTarget.DrawChr(ObjSurface,
              (MagicTarget.Rx - Map.ClientRect.Left) * UNITX + defx,
              (MagicTarget.Ry - Map.ClientRect.Top - 1) * UNITY + defy,
              True, False);
      end;

      //**** ���ΰ� ĳ���� �׸���
      //      if not CheckBadMapMode then
      //         if ( Myself.State and $00800000 = 0 ) then //������ �ƴϸ� 1������϶����� Ǯ����
      //         begin
      Myself.DrawChr(ObjSurface, (Myself.Rx - Map.ClientRect.Left) * UNITX + defx,
        (Myself.Ry - Map.ClientRect.Top - 1) * UNITY + defy, True, False);
      //         end;

      //**** ���콺�� ���ٴ�� �ִ� ĳ����
      if (FocusCret <> nil) then begin
        //         if IsValidActor (FocusCret) and (FocusCret <> Myself) then
        //         if IsValidActor (FocusCret) and (FocusCret <> Myself) and (actor.Race <> 81) then
        if IsValidActor(FocusCret) and (FocusCret <> Myself) and
          (FocusCret.Race <> 81) then
          if FocusCret.State and $00800000 = 0 then //������ �ƴϸ�
            FocusCret.DrawChr(ObjSurface,
              (FocusCret.Rx - Map.ClientRect.Left) * UNITX + defx,
              (FocusCret.Ry - Map.ClientRect.Top - 1) * UNITY + defy, True, False);
      end;
    except
      DebugOutStr('108');
    end;
  end;

  try
    //**** ���� ȿ��
    for k := 0 to ActorList.Count - 1 do begin
      actor := ActorList[k];
      actor.DrawEff(ObjSurface,
        (actor.Rx - Map.ClientRect.Left) * UNITX + defx,
        (actor.Ry - Map.ClientRect.Top - 1) * UNITY + defy);
    end;
    for k := 0 to EffectList.Count - 1 do begin
      meff := TMagicEff(EffectList[k]);
      //if j = (meff.Ry - Map.BlockTop) then begin
      meff.DrawEff(ObjSurface);
      if ViewFog then begin
        AddLight(meff.Rx, meff.Ry, 0, 0, meff.Light, False);
      end;
    end;
    if ViewFog then begin
      for k := 0 to EventMan.EventList.Count - 1 do begin
        evn := TClEvent(EventMan.EventList[k]);
        if evn.light > 0 then
          AddLight(evn.X, evn.Y, 0, 0, evn.light, False);
      end;
    end;
  except
    DebugOutStr('109');
  end;

  //���� ������ ������ ��¦�Ÿ��� ��
  try
    for k := 0 to DropedItemList.Count - 1 do begin
      pd := PTDropItem(DropedItemList[k]);
      if (pd <> nil) and (not pd.BoDeco) then begin
        if GetTickCount - pd.FlashTime > 5 * 1000 then begin
          pd.FlashTime := GetTickCount;
          pd.BoFlash   := True;
          pd.FlashStepTime := GetTickCount;
          pd.FlashStep := 0;
        end;
        if pd.BoFlash then begin
          //               if GetTickCount - pd.FlashStepTime >= 20 then begin
          if GetTickCount - pd.FlashStepTime >= 50 then begin
            pd.FlashStepTime := GetTickCount;
            Inc(pd.FlashStep);
          end;
          ix := (pd.x - Map.ClientRect.Left) * UNITX + defx + SOFFX;
          iy := (pd.y - Map.ClientRect.Top - 1) * UNITY + defy + SOFFY;
          if (pd.FlashStep >= 0) and (pd.FlashStep < 10) then begin
            DSurface := FrmMain.WProgUse.GetCachedImage(
              FLASHBASE + pd.FlashStep, ax, ay);
            DrawBlend(ObjSurface, ix + ax, iy + ay, DSurface, 1);
          end else
            pd.BoFlash := False;
        end;
      end;
    end;
  except
    DebugOutStr('110');
  end;

  try
    if ViewFog then begin
      ApplyLightMap;
      DrawFog(ObjSurface, PFogScreen, FogWidth);
      MSurface.Draw(SOFFX, SOFFY, ObjSurface.ClientRect, ObjSurface, False);
    end else begin
      if Myself.Death then
        DrawEffect(0, 0, ObjSurface.Width, ObjSurface.Height, ObjSurface, ceGrayScale);
      //������Ʈ ���̾��  ���� �ռ�
      MSurface.Draw(SOFFX, SOFFY, ObjSurface.ClientRect, ObjSurface, False);
    end;
  except
    DebugOutStr('111');
  end;

  if ViewMiniMapStyle > 0 then begin
    if ViewMiniMapStyle = 1 then
      DrawMiniMap(MSurface, True)
    else
      DrawMiniMap(MSurface, False);
  end;

end;

{-------------------------------------------------------}

//cx, cy, tx, ty : ���� ��ǥ
procedure TPlayScene.NewMagic(aowner: TActor;
  magid, magnumb, cx, cy, tx, ty, targetcode: integer; mtype: TMagicType;
  Recusion: boolean; anitime: integer; var bofly: boolean);
var
  i, scx, scy, sctx, scty, effnum: integer;
  meff:   TMagicEff;
  target: TActor;
  wimg:   TWMImages;
begin
  bofly := False;
  if (magid <> 111) and (not (magid in [SM_DRAGON_LIGHTING, 70, 71, 72, 73, 74])) then
    //�߻� ������ �ߺ���. // FireDragon
    for i := 0 to EffectList.Count - 1 do
      if TMagicEff(EffectList[i]).ServerMagicId = magid then
        exit; //�̹� ����..
  if magnumb in [52, 53] then begin
  ScreenXYfromMCXY(cx, cy, scx, scy);
  ScreenXYfromMCXY(tx, ty - 20, sctx, scty);
  end else begin
  ScreenXYfromMCXY(cx, cy, scx, scy);
  ScreenXYfromMCXY(tx, ty, sctx, scty);
  end;
  if magnumb > 0 then
    GetEffectBase(magnumb - 1, 0, wimg, effnum)
  else
    effnum := -magnumb;
  target := FindActor(targetcode);

  meff := nil;
  case mtype of
    mtReady, mtFly, mtFlyAxe: begin
      meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
        scty, mtype, Recusion, anitime);
      meff.TargetActor := target;

      meff.ImgLib := wimg;

      bofly := True;
    end;
    mtFlyBug: begin
      meff  := TFlyingBug.Create(magid, effnum, scx, scy, sctx,
        scty, mtype, Recusion, anitime);
      meff.TargetActor := target;
      //if effnum = 38 then
      //   meff.ImgLib := FrmMain.WMagic2;
      bofly := True;
    end;
    mtFlySoulBang: begin
      meff  := TFlyingSoulBang.Create(magid, effnum, scx, scy, sctx,
        scty, mtype, Recusion, anitime);
      meff.TargetActor := target;
      //if effnum = 38 then
      //   meff.ImgLib := FrmMain.WMagic2;
      bofly := True;
    end;
    mtRockPull: begin
      meff  := TRockPull.Create(magid, effnum, scx, scy, sctx,
        scty, mtype, Recusion, anitime);
      meff.TargetActor := target;
      bofly := True;
    end;
    mtFlyCurse: begin
      meff  := TFlyingCurse.Create(magid, effnum, scx, scy, sctx,
        scty, mtype, Recusion, anitime);
      meff.TargetActor := target;
      //if effnum = 38 then
      //   meff.ImgLib := FrmMain.WMagic2;
      bofly := True;
    end;

    mtExplosion: case magnumb of
        18: begin //��ȥ��
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 1570;
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
        end;
        21: begin //������
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 1660;
          meff.TargetActor := nil; //target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 20;
          meff.Light := 3;
        end;
        26: begin //Ž���Ŀ�
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 3990;
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 10;
          meff.Light := 2;
        end;
        27: begin //��ȸ����
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 1800;
          meff.TargetActor := nil; //target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 10;
          meff.Light := 3;
        end;
        30: begin //������ȸ
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 3930;
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 16;
          meff.Light := 3;
        end;
        31: begin //����ǳ
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 3850;
          meff.TargetActor := nil; //target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 20;
          meff.Light := 3;
        end;
        40: begin //��ȭ��
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 620;
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 10;
          meff.Light := 3;
          meff.ImgLib := wimg;
        end;
        47: begin //���°�
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 1010;
          meff.TargetActor := target;
          meff.NextFrameTime := 120;
          meff.ExplosionFrame := 10;
          meff.Light := 2;
          meff.ImgLib := wimg;
        end;
        52: begin //Blizzard
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 1550;
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 30;
          meff.Light := 2;
          wimg   := FrmMain.WMagic2;
          meff.ImgLib := wimg;
          PlaySound(10523);
          meff.TargetActor := nil
        end;
        53: begin //MeteorStrike
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 1610;
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
          meff.ExplosionFrame := 30;
          meff.Light := 2;
          wimg   := FrmMain.WMagic2;
          meff.ImgLib := wimg;
          PlaySound(10532);
          PlaySound(10533);
          meff.TargetActor := nil;
        end;
        90: begin // �뼮�� ���� FireDragon
          wimg   := FrmMain.WDragonImg;
          meff.ImgLib := wimg;
          effnum := 350;
          meff   := TMagicEff.Create(magid, effnum, scx, scy,
            sctx, scty, mtype, Recusion, anitime);
          meff.MagExplosionBase := 350;
          meff.ExplosionFrame := 30;
          meff.TargetActor := nil; //target;
          meff.NextFrameTime := 100;
          meff.Light := 3;
        end;

        else begin  //ȸ����..
          meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
            scty, mtype, Recusion, anitime);
          meff.TargetActor := target;
          meff.NextFrameTime := 80;
        end;
      end;
    mtFireWind: meff := nil;  //ȿ�� ����
    mtFireGun: //ȭ�����
      meff := TFireGunEffect.Create(930, scx, scy, sctx, scty);
    mtThunder: begin
      if magnumb = SM_DRAGON_LIGHTING then begin
        meff := TThuderEffectEx.Create(230, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 5;
        //               meff.MagExplosionBase := 250;
        meff.ImgLib := FrmMain.WDragonImg;
        meff.NextFrameTime := 80;
      end else if magnumb = MAGIC_DUN_THUNDER then begin
        meff := TThuderEffectEx.Create(400, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 5;
        meff.ImgLib := FrmMain.WDragonImg;
        meff.NextFrameTime := 100;
      end else if magnumb = MAGIC_ROCK_PULL then begin
        meff := TThuderEffectEx.Create(1410, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 10;
        meff.ImgLib := FrmMain.WMon24Img;
        meff.NextFrameTime := 100;
      end else if magnumb = MAGIC_FOX_THUNDER then begin
        meff := TThuderEffectEx.Create(FOXWIZARDATTACKEFFECTBASE, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 10;
        meff.ImgLib := FrmMain.WMon24Img;
        meff.NextFrameTime := 100;
      end else if magnumb = MAGIC_FOX_BANG then begin
        meff := TThuderEffectEx.Create(790, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 10;
        meff.ImgLib := FrmMain.WMon24Img;
        meff.NextFrameTime := 100;
      end else if magnumb = MAGIC_DUN_FIRE1 then begin
        //      DScreen.AddChatBoardString ('magnumb = MAGIC_DUN_THUNDER', clYellow, clRed);
        meff := TThuderEffectEx.Create(440, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 20;
        meff.ImgLib := FrmMain.WDragonImg;
        meff.NextFrameTime := 90;
      end else if magnumb = MAGIC_DUN_FIRE2 then begin
        meff := TThuderEffectEx.Create(470, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 10;
        meff.ImgLib := FrmMain.WDragonImg;
        meff.NextFrameTime := 90;
      end else if magnumb = MAGIC_DRAGONFIRE then begin
        meff := TThuderEffectEx.Create(200, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 20;
        meff.ImgLib := FrmMain.WDragonImg;
        meff.NextFrameTime := 120;
      end else if magnumb = MAGIC_FIREBURN then begin
        meff := TThuderEffectEx.Create(350, sctx, scty, nil, magnumb); //target);
        meff.ExplosionFrame := 35;
        meff.ImgLib := FrmMain.WDragonImg;
        meff.NextFrameTime := 100;
      end else if magnumb = MAGIC_SERPENT_1 then begin
        meff := TThuderEffectEx.Create(1250, sctx, scty, nil, magnumb);
        //target);
        meff.ExplosionFrame := 15;
        meff.ImgLib := FrmMain.WMagic2;
        meff.NextFrameTime := 90;
      end else begin
        meff := TThuderEffect.Create(10, sctx, scty, nil); //target);
        meff.ExplosionFrame := 6;
        meff.ImgLib := FrmMain.WMagic2;
      end;
    end;
    // 2003/03/15 �űԹ��� �߰�
    mtFireThunder: begin
      meff := TThuderEffect.Create(140, sctx, scty, nil); //target);
      meff.ExplosionFrame := 10;
      meff.ImgLib := FrmMain.WMagic2;
    end;

    mtLightingThunder: meff :=
        TLightingThunder.Create(970, scx, scy, sctx, scty, target);
    mtExploBujauk: begin
      case magnumb of
        10: begin  //�����
          meff := TExploBujaukEffect.Create(1160, magnumb, scx,
            scy, sctx, scty, target);
          meff.MagExplosionBase := 1360;
        end;
        17: begin  //������
          meff := TExploBujaukEffect.Create(1160, magnumb, scx,
            scy, sctx, scty, target);
          meff.MagExplosionBase := 1540;
        end;
        49: begin  //�;ȼ�
          meff := TExploBujaukEffect.Create(1160, magnumb, scx,
            scy, sctx, scty, target);
          meff.MagExplosionBase := 1110;
          meff.ExplosionFrame := 10;
          //                  meff.ImgLib := FrmMain.WMagic2;
        end;
      end;
      bofly := True;
    end;
    // 2003/03/04
    mtGroundEffect: begin
      meff := TMagicEff.Create(magid, effnum, scx, scy, sctx,
        scty, mtype, Recusion, anitime);
      if meff <> nil then begin
        case magnumb of
          32: begin  //������1
            meff.ImgLib := FrmMain.WMon21Img;
            meff.MagExplosionBase := 3580;
            meff.TargetActor := target;
            meff.Light := 3;
            meff.ExplosionFrame := 20;
          end;
          37: begin
            meff.ImgLib := FrmMain.WMon22Img;
            meff.MagExplosionBase := 3520;
            meff.TargetActor := target;
            meff.Light := 5;
            meff.ExplosionFrame := 20;
          end;
        end;
      end;
      //          bofly := TRUE;
    end;
    mtBujaukGroundEffect: begin
      meff := TBujaukGroundEffect.Create(1160, magnumb, scx, scy, sctx, scty);
      case magnumb of
        11: meff.ExplosionFrame := 16; //�׸�����
        12: meff.ExplosionFrame := 16; //������ȣ
        46: meff.ExplosionFrame := 24; //���ּ�
        55: begin
            meff.ExplosionFrame := 20; //PoisonCloud
            PlaySound(10553);
            meff.TargetActor := nil;
            end;
      end;
      bofly := True;
    end;
    mtKyulKai: begin
      meff := nil; //TKyulKai.Create (1380, scx, scy, sctx, scty);
    end;
  end;
  if meff = nil then
    exit;

  meff.TargetRx := tx;
  meff.TargetRy := ty;
  if meff.TargetActor <> nil then begin
    meff.TargetRx := TActor(meff.TargetActor).XX;
    meff.TargetRy := TActor(meff.TargetActor).YY;
  end;
  meff.MagOwner := aowner;
  EffectList.Add(meff);
end;

procedure TPlayScene.DelMagic(magid: integer);
var
  i: integer;
begin
  for i := 0 to EffectList.Count - 1 do begin
    if TMagicEff(EffectList[i]).ServerMagicId = magid then begin
      TMagicEff(EffectList[i]).Free;
      EffectList.Delete(i);
      break;
    end;
  end;
end;

//cx, cy, tx, ty : ���� ��ǥ
function TPlayScene.NewFlyObject(aowner: TActor; cx, cy, tx, ty, targetcode: integer;
  mtype: TMagicType): TMagicEff;
var
  i, scx, scy, sctx, scty: integer;
  meff: TMagicEff;
begin
  ScreenXYfromMCXY(cx, cy, scx, scy);
  ScreenXYfromMCXY(tx, ty, sctx, scty);
  case mtype of
    mtFlyArrow: meff := TFlyingArrow.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    mtFlySpikes: meff := TFlyingArrow.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    mtFlyBug: meff   := TFlyingBug.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    mtFlySoulBang: meff   := TFlyingSoulBang.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    mtRockPull: meff   := TRockPull.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    mtFlyCurse: meff   := TFlyingCurse.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    mtFireBall: meff := TFlyingFireBall.Create(1, 1, scx, scy, sctx,
        scty, mtype, True, 0);
    else
      meff := TFlyingAxe.Create(1, 1, scx, scy, sctx, scty, mtype, True, 0);
  end;
  meff.TargetRx    := tx;
  meff.TargetRy    := ty;
  meff.TargetActor := FindActor(targetcode);
  meff.MagOwner    := aowner;
  FlyList.Add(meff);
  Result := meff;
end;

 //������ ������ ����ó�� ��� ������ ����
 //effnum: �� ��ȣ���� Base�� �� �ٸ���.
{function  NewStaticMagic (aowner: TActor; tx, ty, targetcode, effnum: integer);
var
   i, scx, scy, sctx, scty, effbase: integer;
   meff: TMagicEff;
begin
   ScreenXYfromMCXY (cx, cy, scx, scy);
   ScreenXYfromMCXY (tx, ty, sctx, scty);
   case effnum of
      1: effbase := 340;   //������ ����Ʈ���� ���� ��ġ
      else exit;
   end;

   meff := TLightingEffect.Create (effbase, 1, 1, scx, scy, sctx, scty, mtype, TRUE, 0);
   meff.TargetRx := tx;
   meff.TargetRy := ty;
   meff.TargetActor := FindActor (targetcode);
   meff.MagOwner := aowner;
   FlyList.Add (meff);
   Result := meff;
end;  }

{-------------------------------------------------------}

//�� ��ǥ��� �� �߾��� ��ũ�� ��ǥ�� ��
{procedure TPlayScene.ScreenXYfromMCXY (cx, cy: integer; var sx, sy: integer);
begin
   if Myself = nil then exit;
   sx := -UNITX*2 - Myself.ShiftX + AAX + 14 + (cx - Map.ClientRect.Left) * UNITX + UNITX div 2;
   sy := -UNITY*3 - Myself.ShiftY + (cy - Map.ClientRect.Top) * UNITY + UNITY div 2;
end; }

procedure TPlayScene.ScreenXYfromMCXY(cx, cy: integer; var sx, sy: integer);
begin
  if Myself = nil then
    exit;
  sx := (cx - Myself.Rx) * UNITX + 364 + UNITX div 2 - Myself.ShiftX;
  sy := (cy - Myself.Ry) * UNITY + 192 + UNITY div 2 - Myself.ShiftY;
end;

//��ũ���� mx, my�� ���� ccx, ccy��ǥ�� ��
procedure TPlayScene.CXYfromMouseXY(mx, my: integer; var ccx, ccy: integer);
begin
  if Myself = nil then
    exit;
  ccx := UpInt((mx - 364 + Myself.ShiftX - UNITX) / UNITX) + Myself.Rx;
  ccy := UpInt((my - 192 + Myself.ShiftY - UNITY) / UNITY) + Myself.Ry;
end;

procedure TPlayScene.CXYfromMouseXYMid(mx, my: integer; var ccx, ccy: integer);
// ������ ���� ��Ȯ�� ��ġ�� �Ѹ��� ����..
begin
  if Myself = nil then
    exit;
  ccx := UpInt((mx - 364 + Myself.ShiftX - UNITX) / UNITX) + Myself.Rx;
  ccy := UpInt((my - (192 - 20) + Myself.ShiftY - UNITY) / UNITY) + Myself.Ry;

end;

//ȭ����ǥ�� ĳ����, �ȼ� ������ ����..
function TPlayScene.GetCharacter(x, y, wantsel: integer; var nowsel: integer;
  liveonly: boolean): TActor;
var
  k, i, ccx, ccy, dx, dy: integer;
  a: TActor;
begin
  Result := nil;
  nowsel := -1;
  CXYfromMouseXY(x, y, ccx, ccy);
  for k := ccy + 8 downto ccy - 1 do begin
    for i := ActorList.Count - 1 downto 0 do
      if TActor(ActorList[i]) <> Myself then begin
        a := TActor(ActorList[i]);
        if (not liveonly or not a.Death) and (a.BoHoldPlace) and (a.Visible) then
        begin
          if a.YY = k then begin
            //�� ���� ������ ���õǰ�
            dx := (a.Rx - Map.ClientRect.Left) * UNITX + DefXX + a.px + a.ShiftX;
            dy := (a.Ry - Map.ClientRect.Top - 1) * UNITY + DefYY + a.py + a.ShiftY;
            if a.CheckSelect(x - dx, y - dy) then begin
              Result := a;
              Inc(nowsel);
              if nowsel >= wantsel then
                exit;
            end;
          end;
        end;
      end;
  end;
end;

//���콺�� ĳ������ ��ó���� �־ ���õǵ���....
function TPlayScene.GetAttackFocusCharacter(x, y, wantsel: integer;
  var nowsel: integer; liveonly: boolean): TActor;
var
  k, i, ccx, ccy, dx, dy, centx, centy: integer;
  a: TActor;
begin
  Result := GetCharacter(x, y, wantsel, nowsel, liveonly);
  if Result = nil then begin
    nowsel := -1;
    CXYfromMouseXY(x, y, ccx, ccy);
    for k := ccy + 8 downto ccy - 1 do begin
      for i := ActorList.Count - 1 downto 0 do
        if TActor(ActorList[i]) <> Myself then begin
          a := TActor(ActorList[i]);
          if (not liveonly or not a.Death) and (a.BoHoldPlace) and (a.Visible) then
          begin
            if a.YY = k then begin

              dx := (a.Rx - Map.ClientRect.Left) * UNITX + DefXX + a.px + a.ShiftX;
              dy := (a.Ry - Map.ClientRect.Top - 1) * UNITY + DefYY + a.py + a.ShiftY;
              if a.CharWidth > 40 then
                centx := (a.CharWidth - 40) div 2
              else
                centx := 0;
              if a.CharHeight > 70 then
                centy := (a.CharHeight - 70) div 2
              else
                centy := 0;
              if (x - dx >= centx) and (x - dx <= a.CharWidth - centx) and
                (y - dy >= centy) and (y - dy <= a.CharHeight - centy) then begin
                Result := a;
                Inc(nowsel);
                if nowsel >= wantsel then
                  exit;
              end;
            end;
          end;
        end;
    end;
  end;
end;

function TPlayScene.IsSelectMyself(x, y: integer): boolean;
var
  k, i, ccx, ccy, dx, dy: integer;
begin
  Result := False;
  CXYfromMouseXY(x, y, ccx, ccy);
  for k := ccy + 2 downto ccy - 1 do begin
    if Myself.YY = k then begin
      //�� ���� ������ ���õǰ�
      dx := (Myself.Rx - Map.ClientRect.Left) * UNITX + DefXX + Myself.px +
        Myself.ShiftX;
      dy := (Myself.Ry - Map.ClientRect.Top - 1) * UNITY + DefYY +
        Myself.py + Myself.ShiftY;
      if Myself.CheckSelect(x - dx, y - dy) then begin
        Result := True;
        exit;
      end;
    end;
  end;
end;

function TPlayScene.GetDropItems(x, y: integer; var inames: string): PTDropItem;
var
  k, i, ccx, ccy, ssx, ssy, dx, dy: integer;
  d: PTDropItem;
  s: TDirectDrawSurface;
  c: byte;
begin
  Result := nil;
  CXYfromMouseXY(x, y, ccx, ccy);
  ScreenXYfromMCXY(ccx, ccy, ssx, ssy);
  dx     := x - ssx;
  dy     := y - ssy;
  inames := '';
  for i := 0 to DropedItemList.Count - 1 do begin
    d := PTDropItem(DropedItemList[i]);
    if (d.X = ccx) and (d.Y = ccy) then begin
      if d.BoDeco then
        s := FrmMain.WDecoImg.Images[d.Looks]
      else
        s := FrmMain.WDnItem.Images[d.Looks];
      if s = nil then
        continue;
      dx := (x - ssx) + (s.Width div 2) - 3;
      dy := (y - ssy) + (s.Height div 2);
      c  := s.Pixels[dx, dy];
      if (c <> 0) or d.BoDeco then begin
        //����ٹ̱� Deco�������� ��� �̸� �ߴ� ���� Ȯ��
        if Result = nil then
          Result := d;
        inames := inames + d.Name + '\';
        //break;
      end;
    end;
  end;
end;

procedure TPlayScene.DropItemsShow; //@@@@
var
  i, k, mx, my, HintX, HintY, HintWidth, HintHeight: integer;
  d:   PTDropItem;
  dds: TDirectDrawSurface;
begin

  dds := FrmMain.WProgUse.Images[394];
  for i := 0 to DropedItemList.Count - 1 do begin
    d := PTDropItem(DropedItemList[i]);
    if d <> nil then begin
      ScreenXYfromMCXY(d.X, d.Y, mx, my);
      if dds <> nil then begin
        HintWidth := FrmMain.Canvas.TextWidth(d.Name) + 4 * 2;
        if HintWidth > dds.Width then
          HintWidth := dds.Width;
        HintHeight := (FrmMain.Canvas.TextHeight('A') + 1) + 3 * 2;
        DrawBlendEx(FrmMain.DxDraw1.Surface, mx + 2 - ((Length(d.Name) div 2) * 6),
          my - 26 - 3, dds, 0, 0, HintWidth, HintHeight, 0);
      end;
    end;
  end;

  SetBkMode(FrmMain.DxDraw1.Surface.Canvas.Handle, TRANSPARENT);
  FrmMain.DxDraw1.Surface.Canvas.Font.Color := clWhite;

  for k := 0 to DropedItemList.Count - 1 do begin
    d := PTDropItem(DropedItemList[k]);
    if d <> nil then begin
      ScreenXYfromMCXY(d.X, d.Y, mx, my);
      FrmMain.DxDraw1.Surface.Canvas.TextOut(mx + 2 - ((Length(d.Name) div 2) * 6) + 4,
        my - 26, d.Name);
    end;
  end;
  FrmMain.DxDraw1.Surface.Canvas.Release;
end;

function TPlayScene.CanRun(sx, sy, ex, ey: integer): boolean;
var
  ndir, rx, ry: integer;
begin
  ndir := GetNextDirection(sx, sy, ex, ey);
  rx   := sx;
  ry   := sy;
  GetNextPosXY(ndir, rx, ry);
  if CanWalk(rx, ry) and CanWalk(ex, ey) then
    Result := True
  else
    Result := False;
end;

function TPlayScene.CanWalk(mx, my: integer): boolean;
begin
  Result := False;
  if Map.CanMove(mx, my) then
    Result := not CrashMan(mx, my);
end;

function TPlayScene.CrashMan(mx, my: integer): boolean;
var
  i: integer;
  a: TActor;
begin
  Result := False;
  for i := 0 to ActorList.Count - 1 do begin
    a := TActor(ActorList[i]);
    if (a.Visible) and (a.BoHoldPlace) and (not a.Death) and
      (a.XX = mx) and (a.YY = my) then begin
      Result := True;
      break;
    end;
  end;
end;

function TPlayScene.CanFly(mx, my: integer): boolean;
begin
  Result := Map.CanFly(mx, my);
end;


{------------------------ Actor ------------------------}

function TPlayScene.FindActor(id: integer): TActor;
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ActorList.Count - 1 do begin
    if TActor(ActorList[i]).RecogId = id then begin
      Result := TActor(ActorList[i]);
      break;
    end;
  end;
end;

function TPlayScene.FindActorXY(x, y: integer): TActor;  //�� ��ǥ�� actor ����
var
  i: integer;
begin
  Result := nil;
  for i := 0 to ActorList.Count - 1 do begin
    if (TActor(ActorList[i]).XX = x) and (TActor(ActorList[i]).YY = y) then begin
      Result := TActor(ActorList[i]);
      if not Result.Death and Result.Visible and Result.BoHoldPlace then
        break;
    end;
  end;
end;

function TPlayScene.IsValidActor(actor: TActor): boolean;
var
  i: integer;
begin
  Result := False;
  for i := 0 to ActorList.Count - 1 do begin
    if TActor(ActorList[i]) = actor then begin
      Result := True;
      break;
    end;
  end;
end;

function TPlayScene.NewActor(chrid: integer; cx: word; //x
  cy: word; //y
  cdir: word; cfeature: integer; //race, hair, dress, weapon
  cstate: integer): TActor;
var
  i:     integer;
  actor: TActor;
  pm:    PTMonsterAction;
begin
  Result := nil;
  for i := 0 to ActorList.Count - 1 do
    if TActor(ActorList[i]).RecogId = chrid then begin
      Result := TActor(ActorList[i]);
      exit; //�̹� ����
    end;
  if IsChangingFace(chrid) then
    exit;  //������...

  case RACEfeature(cfeature) of
    0: actor := THumActor.Create;
    9: actor := TSoccerBall.Create;  //�౸��

    13: actor := TKillingHerb.Create;
    14: actor := TSkeletonOma.Create;
    15: actor := TDualAxeOma.Create;

    16: actor := TGasKuDeGi.Create;  //������� ������

    17: actor := TCatMon.Create;   //����, ����(����,â�����,ö�����)
    18: actor := THuSuABi.Create;
    19: actor := TCatMon.Create;   //����(����,â�����,ö������)

    20: actor := TFireCowFaceMon.Create;
    21: actor := TCowFaceKing.Create;
    22: actor := TDualAxeOma.Create;     //ħ��� ��ũ
    23: actor := TWhiteSkeleton.Create;  //��ȯ���

    24: actor := TSuperiorGuard.Create;  //���ִ� ���

    30: actor := TCatMon.Create;      //������
    31: actor := TCatMon.Create;      //������
    32: actor := TScorpionMon.Create; //������ 2����

    33: actor     := TCentipedeKingMon.Create;  //���׿�, �˷��
    34, 97: actor := TBigHeartMon.Create;       //������, ����, �㳪��, ������
    35: actor     := TSpiderHouseMon.Create;    //���ȰŹ�
    36: actor     := TExplosionSpider.Create;   //����
    37: actor     := TFlyingSpider.Create;      //�񵶰Ź�

    40: actor := TZombiLighting.Create;  //���� 1 (���� ���� ����)
    41: actor := TZombiDigOut.Create;    //���İ� ������ ����
    42: actor := TZombiZilkin.Create;

    43: actor := TBeeQueen.Create;

    45: actor := TArcherMon.Create;
    47: actor := TSculptureMon.Create;  //�����屺, ���Ҵ���
    48: actor := TSculptureMon.Create;
    49: actor := TSculptureKingMon.Create;  //�ָ���

    50: actor := TNpcActor.Create;

    52, 53: actor := TGasKuDeGi.Create;  //������� ���⳪��, ��
    54: actor     := TSmallElfMonster.Create;
    55: actor     := TWarriorElfMonster.Create;

    60: actor     := TElectronicScolpionMon.Create;   //������
    61: actor     := TBossPigMon.Create;              //�յ�
    62: actor     := TKingOfSculpureKingMon.Create;   //�ָ�����(���߿�)
    // 2003/02/11 �ű� �� �߰� .. �ذ񺻿�, �νı�
    63: actor     := TSkeletonKingMon.Create;
    64: actor     := TGasKuDeGi.Create;
    65: actor     := TSamuraiMon.Create;
    66: actor     := TSkeletonSoldierMon.Create;
    67: actor     := TSkeletonSoldierMon.Create;
    68: actor     := TSkeletonSoldierMon.Create;
    69: actor     := TSkeletonArcherMon.Create;
    70: actor     := TBanyaGuardMon.Create;           //�ݾ߿��
    71: actor     := TBanyaGuardMon.Create;           //�ݾ��»�
    72: actor     := TBanyaGuardMon.Create;           //���õ��
    // 2003/07/15 ���ź�õ �� �߰�
    73: actor     := TPBOMA1Mon.Create;               //���Ϳ���
    74: actor     := TCatMon.Create;                  //�����˺�/����/������/ģ����
    75: actor     := TStoneMonster.Create;            //���輮1
    76: actor     := TSuperiorGuard.Create;           //���ź�õ���
    77: actor     := TStoneMonster.Create;            //���輮2
    78: actor     := TBanyaGuardMon.Create;           //��Ȳ����
    79: actor     := TPBOMA6Mon.Create;               //�������ú�
    80, 96: actor := TMineMon.Create;             //�������

    81: actor := TAngel.Create;          //����(õ��)
    83: actor := TFireDragon.Create;     //��õ����
    84, 85, 86, 87, 88, 89: actor := TDragonStatue.Create; //�뼮��
    90: actor := TDragonBody.Create;              //��õ���� �����
    91: actor := TBanyaGuardMon.Create;  //���δ���
    92: actor := TJumaThunderMon.Create; //�ָ��ݷ���  TSculptureMon ��ӹ���
    93: actor := TBanyaGuardMon.Create;  //ȯ����ȣ
    94: actor := TBanyaGuardMon.Create;  //�Ź�(�ż�������)
    95: actor := TGasKuDeGi.Create;      //�̺�Ʈ���� 96:�ɴ� 97:������

    98: actor := TWallStructure.Create;
    99: actor := TCastleDoor.Create;  //����...

    100: actor := TBanyaGuardMon.Create;   //Ȳ���̹���
    101: actor := TCatMon.Create;   //���(û����)

    102: actor := TFoxWarrior.Create;   //BlackFoxman
    103: actor := TFoxWizard.Create;    //RedFoxman
    104: actor := TFoxTao.Create;   //WhiteFoxman
    105: actor := TTrapRock.Create;    //TrapRock
    106: actor := TGuardRock.Create;    //GuardianRock
    107, 108: actor := TElements.Create;   //ThunderElement, CloudElement
    109: actor := TKingElement.Create;    //GreatFoxSpirit
    110, 111: actor := TBigKekTal.Create;  //Big KekTals

    else
      actor := TActor.Create;
  end;

  with actor do begin
    RecogId := chrid;
    XX      := cx;
    YY      := cy;
    Rx      := XX;
    Ry      := YY;
    Dir     := cdir;
    Feature := cfeature;
    Race    := RACEfeature(cfeature);         //changefeature�� ��������
    hair    := HAIRfeature(cfeature);         //����ȴ�.
    dress   := DRESSfeature(cfeature);
    weapon  := WEAPONfeature(cfeature);
    Appearance := APPRfeature(cfeature);

    pm := RaceByPm(Race, Appearance);
    if pm <> nil then
      WalkFrameDelay := pm.ActWalk.ftime;

    if Race = 0 then begin
      Sex := dress mod 2;   //0:���� 1:����
    end else
      Sex := 0;
    state := cstate;
    Saying[0] := '';
  end;
  ActorList.Add(actor);
  Result := actor;
end;

procedure TPlayScene.ActorDied(actor: TObject);
var
  i:    integer;
  flag: boolean;
begin
  for i := 0 to ActorList.Count - 1 do
    if ActorList[i] = actor then begin
      ActorList.Delete(i);
      break;
    end;
  flag := False;
  for i := 0 to ActorList.Count - 1 do
    if not TActor(ActorList[i]).Death then begin
      ActorList.Insert(i, actor);
      flag := True;
      break;
    end;
  if not flag then
    ActorList.Add(actor);
end;

procedure TPlayScene.SetActorDrawLevel(actor: TObject; level: integer);
var
  i: integer;
begin
  if level = 0 then begin  //�� ó���� �׸����� ��
    for i := 0 to ActorList.Count - 1 do
      if ActorList[i] = actor then begin
        ActorList.Delete(i);
        ActorList.Insert(0, actor);
        break;
      end;
  end;
end;

procedure TPlayScene.ClearActors;  //�α׾ƿ��� ���
var
  i: integer;
begin
  for i := 0 to ActorList.Count - 1 do
    TActor(ActorList[i]).Free;
  ActorList.Clear;
  Myself      := nil;
  TargetCret  := nil;
  FocusCret   := nil;
  MagicTarget := nil;

  //������ �ʱ�ȭ �ؾ���.
  for i := 0 to EffectList.Count - 1 do
    TMagicEff(EffectList[i]).Free;
  EffectList.Clear;
end;

function TPlayScene.DeleteActor(id: integer): TActor;
var
  i: integer;
begin
  Result := nil;
  i      := 0;
  while True do begin
    if i >= ActorList.Count then
      break;
    if TActor(ActorList[i]).RecogId = id then begin
      if TargetCret = TActor(ActorList[i]) then
        TargetCret := nil;
      if FocusCret = TActor(ActorList[i]) then
        FocusCret := nil;
      if MagicTarget = TActor(ActorList[i]) then
        MagicTarget := nil;
      TActor(ActorList[i]).DeleteTime := GetTickCount;
      FreeActorList.Add(ActorList[i]);
      //TActor(ActorList[i]).Free;
      ActorList.Delete(i);
    end else
      Inc(i);
  end;
end;

procedure TPlayScene.DelActor(actor: TObject);
var
  i: integer;
begin
  for i := 0 to ActorList.Count - 1 do
    if ActorList[i] = actor then begin
      TActor(ActorList[i]).DeleteTime := GetTickCount;
      FreeActorList.Add(ActorList[i]);
      ActorList.Delete(i);
      break;
    end;
end;

function TPlayScene.ButchAnimal(x, y: integer): TActor;
var
  i: integer;
  a: TActor;
begin
  Result := nil;
  for i := 0 to ActorList.Count - 1 do begin
    a := TActor(ActorList[i]);
    if a.Death and (a.Race <> 0) then begin //���� ��ü
      if (abs(a.XX - x) <= 1) and (abs(a.YY - y) <= 1) then begin
        Result := a;
        break;
      end;
    end;
  end;
end;


{------------------------- Msg -------------------------}


 //�޼����� ���۸��ϴ� ������ ?
 //ĳ������ �޼��� ���ۿ� �޼����� ���� �ִ� ���¿���
 //���� �޼����� ó���Ǹ� �ȵǱ� ������.
procedure TPlayScene.SendMsg(ident, chrid, x, y, cdir, feature, state, param: integer;
  str: string);
var
  actor: TActor;
  meff:  TMagicEff;
begin
  case ident of
    SM_TEST: begin
      actor  := NewActor(111, 254{x}, 214{y}, 0, 0, 0);
      Myself := THumActor(actor);
      Map.LoadMap('0', Myself.XX, Myself.YY);
    end;
    SM_CHANGEMAP,
    SM_NEWMAP: begin
      Map.LoadMap(str, x, y);
      DarkLevel := cdir;
      //DayBright_fake := msg.Param;

      DarkLevel_fake   := cdir;
      pDarkLevelCheck^ := cdir;

      if DarkLevel = 0 then
        ViewFog := False
      else
        ViewFog := True;
      if (ident = SM_NEWMAP) and (Myself <> nil) then begin
        //�����̵� �Ҷ� �ε巴�� ���̵��� �ϰ� �������
        Myself.XX := x;
        Myself.YY := y;
        Myself.RX := x;
        Myself.RY := y;
        DelActor(Myself);
      end;

      //BoViewMiniMap := FALSE;
      if BoWantMiniMap then begin
        if ViewMiniMapStyle > 0 then
          PrevVMMStyle := ViewMiniMapStyle;
        ViewMiniMapStyle := 0;
        FrmMain.SendWantMiniMap;
      end;

    end;
    SM_LOGON: begin
      actor := FindActor(chrid);
      if actor = nil then begin
        actor := NewActor(chrid, x, y, Lobyte(cdir), feature, state);
        actor.ChrLight := Hibyte(cdir);
        cdir  := Lobyte(cdir);
        actor.SendMsg(SM_TURN, x, y, cdir, feature, state, '', 0);
      end;
      if Myself <> nil then begin
        Myself := nil;
      end;
      Myself := THumActor(actor);
    end;
    SM_HIDE: begin
      actor := FindActor(chrid);
      if actor <> nil then begin
        if actor.BoDelActionAfterFinished then begin
          //������ ������� �ִϸ��̼��� ������ �ڵ����� �����.
          exit;
        end;
        if actor.WaitForRecogId <> 0 then begin
          //������.. ������ ������ �ڵ����� �����
          exit;
        end;
      end;
      DeleteActor(chrid);
    end;
    else begin
      actor := FindActor(chrid);
      if (ident = SM_TURN) or (ident = SM_RUN) or (ident = SM_WALK) or
        (ident = SM_BACKSTEP) or (ident = SM_DEATH) or
        (ident = SM_SKELETON) or (ident = SM_DIGUP) or (ident = SM_ALIVE) then begin
        if actor = nil then
          actor := NewActor(chrid, x, y, Lobyte(cdir), feature, state);
        if actor <> nil then begin
          actor.ChrLight := Hibyte(cdir);
          cdir := Lobyte(cdir);
          if ident = SM_SKELETON then begin
            actor.Death    := True;
            actor.Skeleton := True;
          end else if ident = SM_ALIVE then begin  //2005/05/11 ��Ȱ //####
            actor.Feature := feature;
            actor.FeatureChanged;
            if DarkLevel = 0 then
              ViewFog := False
            else
              ViewFog := True;
            actor.Death := False;
            actor.Skeleton := False;
          end;

        end;
      end;
      if actor = nil then
        exit;
      case ident of
        SM_FEATURECHANGED: begin
          actor.Feature := feature;
          actor.FeatureChanged;
        end;
        SM_CHARSTATUSCHANGED: begin
          actor.State    := Feature;
          actor.HitSpeed := state;
          if actor = Myself then begin
            ChangeWalkHitValues(Myself.Abil.Level
              , Myself.HitSpeed
              , Myself.Abil.Weight + Myself.Abil.MaxWeight +
              Myself.Abil.WearWeight + Myself.Abil.MaxWearWeight +
              Myself.Abil.HandWeight + Myself.Abil.MaxHandWeight
              , RUN_STRUCK_DELAY
              );
            //                        if Myself.State and $10000000 <> 0 then begin        //POISON_STUN
            //                           DizzyDelayStart := GetTickCount;
            //                           DizzyDelayTime  := 1500; //������
            //                        end;
          end;
          // 2003/07/15 ���Ͽ� ���� �����̻� ����Ʈ �߰�
          if Feature and $10000000 <> 0 then begin        //POISON_STUN
            meff := TCharEffect.Create(380, 6, actor);
            meff.NextFrameTime := 100;
            meff.ImgLib := FrmMain.WMagic2;
            meff.RepeatUntil := GetTickCount + 2000;
            EffectList.Add(meff);
          end;
        end;
        else begin
          if ident = SM_TURN then begin
            if str <> '' then
              actor.UserName := str;
          end;
          if ident = SM_WALK then begin
            if param > 0 then
              actor.WalkFrameDelay := param;
          end;
          actor.SendMsg(ident, x, y, cdir, feature, state, '', 0);
        end;
      end;
    end;
  end;

end;


end.

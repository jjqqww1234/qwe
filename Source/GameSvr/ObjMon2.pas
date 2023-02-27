unit ObjMon2;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  ScktComp, syncobjs, MudUtil, HUtil32, Grobal2, Envir, EdCode, ObjBase,
  M2Share, Event, ObjMon;

type
  TDoorState = (dsOpen, dsClose, dsBroken);

  TStickMonster = class(TAnimal)
  private
  protected
    RunDone:      boolean;
    DigupRange:   integer;
    DigdownRange: integer;
    function AttackTarget: boolean; dynamic;
    procedure CheckComeOut; dynamic;
    procedure ComeOut; dynamic;
    procedure ComeDown; dynamic;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RunMsg(msg: TMessageInfo); override;
    procedure Run; override;
  end;

  TBeeQueen = class(TAnimal)   //�񸷿���, ����
  private
    //childcount: integer;
    childlist: TList;  //������ ���ϵ��� ����Ʈ
  protected
    procedure MakeChildBee;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RunMsg(msg: TMessageInfo); override;
    procedure Run; override;
  end;

  TCentipedeKingMonster = class(TStickMonster)
  private
    appeartime: longword;
  protected
    function FindTarget: boolean;
    function AttackTarget: boolean; override;
  public
    constructor Create;
    procedure ComeOut; override;
    procedure Run; override;
  end;

  TBigHeartMonster = class(TAnimal)  //������, �������
  private
  protected
    function AttackTarget: boolean; dynamic;
  public
    constructor Create;
    procedure Run; override;
  end;

  TBamTreeMonster = class(TAnimal)
  public
    StruckCount, DeathStruckCount: integer;
    constructor Create;
    procedure Struck(hiter: TCreature); override;
    procedure Run; override;
  end;


  TSpiderHouseMonster = class(TAnimal)   //���ȰŹ�, ����
  private
    childlist: TList;  //������ ���ϵ��� ����Ʈ
  protected
    procedure MakeChildSpider;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RunMsg(msg: TMessageInfo); override;
    procedure Run; override;
  end;

  TExplosionSpider = class(TMonster)
  public
    maketime: longword;
    constructor Create;
    procedure DoSelfExplosion;
    function AttackTarget: boolean; override;
    procedure Run; override;
  end;


  //���, ����, �ü�

  TGuardUnit = class(TAnimal)
    OriginX, OriginY, OriginDir: integer;
  public
    procedure Struck(hiter: TCreature); override;
    function IsProperTarget(target: TCreature): boolean; override;
  end;

  TArcherGuard = class(TGuardUnit)
  private
    procedure ShotArrow(targ: TCreature);
  public
    constructor Create;
    procedure Run; override;
  end;

  TArcherMaster = class(TATMonster)   //�ü�ȣ����
  private
    procedure ShotArrow(targ: TCreature);
  public
    constructor Create;
    function AttackTarget: boolean; override;
    procedure Run; override;
  end;

  TArcherPolice = class(TArcherGuard)
  private
  public
    constructor Create;
  end;

  TCastleDoor = class(TGuardUnit)
  public
    BrokenTime:  longword; //�μ��� �ð�
    BoOpenState: boolean;  //���ΰ�� �������ִ���
    constructor Create;
    procedure Run; override;
    procedure Initialize; override;
    procedure Die; override;
    procedure RepairStructure;
    procedure ActiveDoorWall(dstate: TDoorState); //TRUE: �̵���, false:����, ��������
    procedure OpenDoor;
    procedure CloseDoor;
  end;

  TWallStructure = class(TGuardUnit)
  public
    BrokenTime: longword;
    BoBlockPos: boolean;
    constructor Create;
    procedure Initialize; override;
    procedure Die; override;
    procedure RepairStructure;
    procedure Run; override;
  end;


  TSoccerBall = class(TAnimal)
  public
    GoPower: integer;
    constructor Create;
    procedure Struck(hiter: TCreature); override;
    procedure Run; override;
  end;

  TMineMonster = class(TAnimal)
  private
  protected
    RunDone:      boolean;
    DigupRange:   integer;
    DigdownRange: integer;
    function AttackTarget: boolean; dynamic;
    procedure CheckComeOut; dynamic;
    procedure ComeOut; dynamic;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RunMsg(msg: TMessageInfo); override;
    procedure Run; override;
  end;

  TTrapRock = class(TAnimal)
  protected
    mon:          TCreature;
    mon2:          TCreature;
    mon3:          TCreature;
    RunDone:      boolean;
    DigupRange:   integer;
    DigdownRange: integer;
    aax, aay, bbx, bby, ccx, ccy, ddx, ddy: integer;
    function AttackTarget: boolean; dynamic;
    procedure ComeOut; dynamic;
    procedure ComeDown; dynamic;
    procedure CheckComeOut; dynamic;
  public
    constructor Create;
    procedure Struck(hiter: TCreature); override;
    procedure Run; override;    
    procedure Die; override;
  end;




implementation

uses
  svMain, Castle, Guild;

constructor TStickMonster.Create;
begin
  inherited Create;
  RunDone      := False;
  ViewRange    := 7;
  RunNextTick  := 250;
  SearchRate   := 2500 + longword(Random(1500));
  SearchTime   := GetTickCount;
  RaceServer   := RC_KILLINGHERB;
  DigupRange   := 4;
  DigdownRange := 4;
  HideMode     := True;
  StickMode    := True;
  BoAnimal     := True;  //��� ��������, �����ʿ��Ű� ����.
end;

destructor TStickMonster.Destroy;
begin
  inherited Destroy;
end;

function TStickMonster.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if TargetCret <> nil then begin
    if TargetInAttackRange(TargetCret, targdir) then begin
      if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
        HitTime := GetCurrentTime;
        TargetFocusTime := GetTickCount;
        Attack(TargetCret, targdir);
      end;
      Result := True;
    end else begin
      if TargetCret.MapName = self.MapName then
        SetTargetXY(TargetCret.CX, TargetCret.CY)
      else
        LoseTarget;  //<!!����> TargetCret := nil�� �ٲ�
    end;
  end;
end;

procedure TStickMonster.ComeOut;
begin
  HideMode := False;
  SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
end;

procedure TStickMonster.ComeDown;
var
  i: integer;
begin
  SendRefMsg(RM_DIGDOWN, {Dir}0, CX, CY, 0, '');
  try
    for i := 0 to VisibleActors.Count - 1 do
      Dispose(PTVisibleActor(VisibleActors[i]));
    VisibleActors.Clear;
  except
    MainOutMessage('[Exception] TStickMonster VisbleActors Dispose(..)');
  end;
  HideMode := True;
end;

procedure TStickMonster.CheckComeOut;
var
  i:    integer;
  cret: TCreature;
begin
  for i := 0 to VisibleActors.Count - 1 do begin
    cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
    if (not cret.Death) and (IsProperTarget(cret)) and
      (not cret.BoHumHideMode or BoViewFixedHide) then begin
      if (abs(CX - cret.CX) <= DigupRange) and (abs(CY - cret.CY) <= DigupRange) then
      begin
        ComeOut; //������ ������. ���δ�.
        break;
      end;
    end;
  end;
end;

procedure TStickMonster.RunMsg(msg: TMessageInfo);
begin
  inherited RunMsg(msg);
end;

procedure TStickMonster.Run;
var
  boidle: boolean;
begin
  //   if (not BoGhost) and (not Death) and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if IsMoveAble then begin
    if GetCurrentTime - WalkTime > GetNextWalkTime then begin
      WalkTime := GetCurrentTime;
      if HideMode then begin //���� ����� ��Ÿ���� �ʾ���.
        CheckComeOut;
      end else begin
        if integer(GetCurrentTime - HitTime) > GetNextHitTime then
        begin //��ӹ��� run ���� HitTime �缳����.
              ///HitTime := GetTickCount; //�Ʒ� AttackTarget���� ��.
          MonsterNormalAttack;
        end;

        boidle := False;
        if TargetCret <> nil then begin
          if (abs(TargetCret.CX - CX) > DigdownRange) or
            (abs(TargetCret.CY - CY) > DigdownRange) then
            boidle := True;
        end else
          boidle := True;

        if boidle then
          ComeDown //�ٽ� ����.
        else if AttackTarget then begin
          inherited Run;
          exit;
        end;
      end;
    end;
  end;

  inherited Run;

end;

// Mine Monster -----------------------------------------------------------------
constructor TMineMonster.Create;
begin
  inherited Create;
  RunDone      := False;
  ViewRange    := 7;
  RunNextTick  := 250;
  SearchRate   := 2500 + longword(Random(1500));
  SearchTime   := GetTickCount;
  RaceServer   := RC_MINE;
  DigupRange   := 4;
  DigdownRange := 4;
  HideMode     := True;
  StickMode    := True;
  BoAnimal     := False;  //��� ��������, �����ʿ��Ű� ����.
end;

destructor TMineMonster.Destroy;
begin
  inherited Destroy;
end;

function TMineMonster.AttackTarget: boolean;
var
  targdir: byte;
begin
  WAbil.HP := 0;
  Result   := True;
end;

procedure TMineMonster.ComeOut;
begin
  HideMode := False;
  SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
end;


procedure TMineMonster.CheckComeOut;
var
  i:    integer;
  cret: TCreature;
begin
  for i := 0 to VisibleActors.Count - 1 do begin
    cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
    if (not cret.Death) and (IsProperTarget(cret)) and
      (not cret.BoHumHideMode or BoViewFixedHide) then begin
      if (abs(CX - cret.CX) <= DigupRange) and (abs(CY - cret.CY) <= DigupRange) then
      begin
        ComeOut; //������ ������. ���δ�.
        break;
      end;
    end;
  end;
end;

procedure TMineMonster.RunMsg(msg: TMessageInfo);
begin
  inherited RunMsg(msg);
end;

procedure TMineMonster.Run;
begin
  //   if (not BoGhost) and (not Death) and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if IsMoveAble then begin
    if GetCurrentTime - WalkTime > GetNextWalkTime then begin
      WalkTime := GetCurrentTime;
      if HideMode then begin //���� ����� ��Ÿ���� �ʾ���.
        CheckComeOut;
      end else begin
        if integer(GetCurrentTime - HitTime) > GetNextHitTime then
        begin //��ӹ��� run ���� HitTime �缳����.
              ///HitTime := GetTickCount; //�Ʒ� AttackTarget���� ��.
          if AttackTarget then begin
            inherited Run;
            exit;
          end;

        end;
      end;
    end;
  end;

  inherited Run;

end;


 {--------------------------------------------------------------}
 //����

constructor TBeeQueen.Create;
begin
  inherited Create;
  ViewRange   := 9;
  RunNextTick := 250;
  SearchRate  := 2500 + longword(Random(1500));
  SearchTime  := GetTickCount;
  StickMode   := True;
  childlist   := TList.Create;
end;

destructor TBeeQueen.Destroy;
begin
  childlist.Free;
  inherited Destroy;
end;

procedure TBeeQueen.MakeChildBee;
begin
  if childlist.Count < 15 then begin
    SendRefMsg(RM_HIT, self.Dir, CX, CY, 0, '');
    SendDelayMsg(self, RM_ZEN_BEE, 0, 0, 0, 0, '', 500);
  end;
end;

procedure TBeeQueen.RunMsg(msg: TMessageInfo);
var
  nx, ny:  integer;
  monname: string;
  mon:     TCreature;
begin
  case msg.Ident of
    RM_ZEN_BEE: begin
      monname := __Bee;  //����
      mon     := UserEngine.AddCreatureSysop(PEnvir.MapName, CX, CY, monname);
      if mon <> nil then begin
        mon.SelectTarget(TargetCret);
        childlist.Add(mon);
      end;
    end;
  end;
  inherited RunMsg(msg);
end;

procedure TBeeQueen.Run;
var
  i: integer;
begin
  //   if (not BoGhost) and (not Death) and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if IsMoveAble then begin
    if GetCurrentTime - WalkTime > GetNextWalkTime then begin
      WalkTime := GetCurrentTime;
      if integer(GetCurrentTime - HitTime) > GetNextHitTime then
      begin //��ӹ��� run ���� HitTime �缳����.
        HitTime := GetTickCount;
        MonsterNormalAttack;

        if TargetCret <> nil then
          MakeChildBee;

      end;

      for i := childlist.Count - 1 downto 0 do begin
        if (TCreature(childlist[i]).Death) or (TCreature(childlist[i]).BoGhost) then
        begin
          childlist.Delete(i);
        end;
      end;
    end;
  end;

  inherited Run;
end;



 {--------------------------------------------------------------}
 //���׿�, �˷��

constructor TCentipedeKingMonster.Create;
begin
  inherited Create;
  ViewRange    := 6;
  DigupRange   := 4;
  DigdownRange := 6;
  BoAnimal     := False;
  appeartime   := GetTickCount;
end;

function TCentipedeKingMonster.FindTarget: boolean;
var
  i:    integer;
  cret: TCreature;
begin
  Result := False;
  for i := 0 to VisibleActors.Count - 1 do begin
    cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
    if (not cret.Death) and IsProperTarget(cret) then begin
      if (abs(CX - cret.CX) <= ViewRange) and (abs(CY - cret.CY) <= ViewRange) then begin
        Result := True;
        break;
      end;
    end;
  end;
end;

function TCentipedeKingMonster.AttackTarget: boolean;
var
  i, pwr:  integer;
  cret:    TCreature;
  targdir: byte;
begin
  Result := False;
  if FindTarget then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;
      //inherited HitHit (nil, HM_CROSSHIT, Dir);
      HitMotion(RM_HIT, self.Dir, CX, CY);

      with WAbil do
        pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

      for i := 0 to VisibleActors.Count - 1 do begin
        cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
        if (not cret.Death) and IsProperTarget(cret) then begin
          if (abs(CX - cret.CX) <= ViewRange) and (abs(CY - cret.CY) <= ViewRange) then
          begin
            TargetFocusTime := GetTickCount;

            SendDelayMsg(self, RM_DELAYMAGIC, pwr,
              MakeLong(cret.CX, cret.CY), 2, integer(cret), '', 600);
            //cret.SendDelayMsg (self, RM_MAGSTRUCK, 0, acpwr, 0, 0, '', 600);
            if Random(4) = 0 then begin
              if Random(3) <> 0 then
                cret.MakePoison(POISON_DECHEALTH, 60, 3)   //ü���� ����
              else
                cret.MakePoison(POISON_STONE, 5{�ð�,��}, 0);
            end;

            TargetCret := cret;
          end;
        end;
      end;
    end;
    Result := True;
  end;
end;

procedure TCentipedeKingMonster.ComeOut;
begin
  inherited ComeOut;
  WAbil.HP := WAbil.MaxHP;   //������ϸ� ü���� ����
end;


procedure TCentipedeKingMonster.Run;   //���׿�,�˷��
var
  i, dis, d:      integer;
  cret, nearcret: TCreature;
begin
  //   if (not BoGhost) and (not Death) and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if IsMoveAble then begin
    if GetCurrentTime - WalkTime > NextWalkTime then begin
      WalkTime := GetCurrentTime;
      if HideMode then begin //���� ����� ��Ÿ���� �ʾ���.
        if GetTickCount - appeartime > 10 * 1000 then begin
          for i := 0 to VisibleActors.Count - 1 do begin
            cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
            if (not cret.Death) and (IsProperTarget(cret)) and
              (not cret.BoHumHideMode or BoViewFixedHide) then begin
              if (abs(CX - cret.CX) <= DigupRange) and
                (abs(CY - cret.CY) <= DigupRange) then begin
                ComeOut; //������ ������. ���δ�.
                appeartime := GetTickCount;
                break;
              end;
            end;
          end;
        end;
      end else begin
        if GetTickCount - appeartime > 3 * 1000 then begin
          if AttackTarget then begin
            inherited Run;
            exit;
          end else begin  //���� ����
            if GetTickCount - appeartime > 10 * 1000 then begin
              ComeDown;
              appeartime := GetTickCount;
            end;
          end;
        end;
      end;
    end;
  end;

  inherited Run;
end;


 {--------------------------------------------------------------}
 //TBigHeartMonster

constructor TBigHeartMonster.Create;
begin
  inherited Create;
  ViewRange := 16;
  BoAnimal  := False;
end;

function TBigHeartMonster.AttackTarget: boolean;
var
  i, pwr: integer;
  cret:   TCreature;
  ev2:    TEvent;
begin
  Result := False;
  if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
    HitTime := GetCurrentTime;
    HitMotion(RM_HIT, self.Dir, CX, CY);

    with WAbil do
      pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

    for i := 0 to VisibleActors.Count - 1 do begin
      cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
      if (not cret.Death) and IsProperTarget(cret) then begin
        if (abs(CX - cret.CX) <= ViewRange) and (abs(CY - cret.CY) <= ViewRange) then
        begin

          //����....
          SendDelayMsg(self, RM_DELAYMAGIC, pwr, MakeLong(cret.CX, cret.CY),
            1{range}, integer(cret), '', 200);
          SendRefMsg(RM_NORMALEFFECT, 0, cret.CX, cret.CY, NE_HEARTPALP, '');

          //ev2 := TEvent (PEnvir.GetEvent (cret.CX, cret.CY));    //���� ȿ��, ����
          //if ev2 = nil then begin
          //   ev2 := TPileStones.Create (PEnvir, cret.CX, cret.CY, ET_HEARTPALP, 3 * 60 * 1000, TRUE);
          //   EventMan.AddEvent (ev2);
          //end;

        end;
      end;
    end;

    Result := True;
  end;
end;

procedure TBigHeartMonster.Run;
begin
  //   if (not BoGhost) and (not Death) and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if IsMoveAble then begin
    if VisibleActors.Count > 0 then
      AttackTarget;
  end;
  inherited Run;
end;


 {--------------------------------------------------------------}
 //�㳪��


constructor TBamTreeMonster.Create;
begin
  inherited Create;
  BoAnimal    := False;
  StruckCount := 0;
  DeathStruckCount := 0;  //HP;;;
end;

procedure TBamTreeMonster.Struck(hiter: TCreature);
begin
  inherited Struck(hiter);
  Inc(StruckCount);
end;

procedure TBamTreeMonster.Run;
begin
  if DeathStruckCount = 0 then
    DeathStruckCount := WAbil.MaxHP;
  WAbil.HP := WAbil.MaxHP;

  if StruckCount >= DeathStruckCount then
    WAbil.HP := 0;

  inherited Run;
end;



 {--------------------------------------------------------------}
 //���ȰŹ�,  �Ź���


constructor TSpiderHouseMonster.Create;
begin
  inherited Create;
  ViewRange   := 9;
  RunNextTick := 250;
  SearchRate  := 2500 + longword(Random(1500));
  SearchTime  := GetTickCount;
  StickMode   := True;
  childlist   := TList.Create;
end;

destructor TSpiderHouseMonster.Destroy;
begin
  childlist.Free;
  inherited Destroy;
end;

procedure TSpiderHouseMonster.MakeChildSpider;
begin
  if childlist.Count < 15 then begin
    SendRefMsg(RM_HIT, self.Dir, CX, CY, 0, '');
    SendDelayMsg(self, RM_ZEN_BEE, 0, 0, 0, 0, '', 500);
  end;
end;

procedure TSpiderHouseMonster.RunMsg(msg: TMessageInfo);
var
  nx, ny:  integer;
  monname: string;
  mon:     TCreature;
begin
  case msg.Ident of
    RM_ZEN_BEE: begin
      monname := __Spider;  //����

      //�Ź��� ���⿡ ���� ���� �Ź��� ��ġ�� ����
      nx := CX;
      ny := CY + 1;

      if PEnvir.CanWalk(nx, ny, True) then begin
        mon := UserEngine.AddCreatureSysop(PEnvir.MapName, nx, ny, monname);
        if mon <> nil then begin
          mon.SelectTarget(TargetCret);
          childlist.Add(mon);
        end;
      end;
    end;
  end;
  inherited RunMsg(msg);
end;

procedure TSpiderHouseMonster.Run;
var
  i: integer;
begin
  //   if (not BoGhost) and (not Death) and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if IsMoveAble then begin
    if GetCurrentTime - WalkTime > GetNextWalkTime then begin
      WalkTime := GetCurrentTime;
      if integer(GetCurrentTime - HitTime) > GetNextHitTime then
      begin //��ӹ��� run ���� HitTime �缳����.
        HitTime := GetTickCount;
        MonsterNormalAttack;

        if TargetCret <> nil then
          MakeChildSpider;

      end;

      for i := childlist.Count - 1 downto 0 do begin
        if (TCreature(childlist[i]).Death) or (TCreature(childlist[i]).BoGhost) then
        begin
          childlist.Delete(i);
        end;
      end;
    end;
  end;

  inherited Run;
end;



 {--------------------------------------------------------------}
 //����,  ���� �Ź�

constructor TExplosionSpider.Create;
begin
  inherited Create;
  ViewRange   := 5;
  RunNextTick := 250;
  SearchRate  := 2500 + longword(Random(1500));
  SearchTime  := 0; //GetTickCount;
  maketime    := GetTickCount;
end;

procedure TExplosionSpider.DoSelfExplosion;
var
  i, pwr, dam: integer;
  cret: TCreature;
begin
  WAbil.HP := 0;  //����
  //������ �������� �ش�.

  with WAbil do
    pwr := _MAX(0, Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1));

  for i := 0 to VisibleActors.Count - 1 do begin
    cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
    if (abs(cret.CX - CX) <= 1) and (abs(cret.CY - CY) <= 1) then begin
      if (not cret.Death) and (IsProperTarget(cret)) then begin
        dam := 0;
        dam := dam + cret.GetHitStruckDamage(self, pwr div 2);
        dam := dam + cret.GetMagStruckDamage(self, pwr div 2);
        if dam > 0 then begin
          cret.StruckDamage(dam, self);
          cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
            cret.WAbil.HP{lparam1}, cret.WAbil.MaxHP{lparam2},
            longint(self){hiter}, '', 700);
        end;
      end;
    end;
  end;
end;

function TExplosionSpider.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if TargetCret <> nil then begin
    if TargetInAttackRange(TargetCret, targdir) then begin
      if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
        HitTime := GetCurrentTime;
        TargetFocusTime := GetTickCount;
        //����....
        DoSelfExplosion;
      end;
      Result := True;
    end else begin
      if TargetCret.MapName = self.MapName then
        SetTargetXY(TargetCret.CX, TargetCret.CY)
      else
        LoseTarget;  //<!!����> TargetCret := nil�� �ٲ�
    end;
  end;
end;

procedure TExplosionSpider.Run;
begin
  if (not Death) and (not BoGhost) then begin
    if GetTickCount - maketime > 1 * 60 * 1000 then begin  //����
      maketime := GetTickCount;
      DoSelfExplosion;
    end;
  end;
  inherited Run;
end;


 {--------------------------------------------------------------}
 // TGuardUnit

procedure TGuardUnit.Struck(hiter: TCreature);
begin
  inherited Struck(hiter);
  if Castle <> nil then begin
    hiter.BoCrimeforCastle   := True;
    hiter.CrimeforCastleTime := GetTickCount;
  end;
end;

function TGuardUnit.IsProperTarget(target: TCreature): boolean;
begin
  Result := False;
  if Castle <> nil then begin
    if LastHiter = target then
      Result := True;

    if target.BoCrimeforCastle then begin
      if GetTickCount - target.CrimeforCastleTime < 2 * 60 * 1000 then begin //5��
        Result := True;
      end else
        target.BoCrimeforCastle := False;
      if TCreature(target).Castle <> nil then begin
        target.BoCrimeforCastle := False;
        Result := False;
      end;
    end;

    //�⺻ ���� ��� (���������� ���� �����ϴ� ���)
    if TUserCastle(Castle).BoCastleUnderAttack then begin
      Result := True;
    end;

    if TUserCastle(Castle).OwnerGuild <> nil then begin
      if target.Master = nil then begin
        if ((TUserCastle(Castle).OwnerGuild = target.MyGuild) or
          TUserCastle(Castle).OwnerGuild.IsAllyGuild(TGuild(target.MyGuild))) and
          (LastHiter <> target) then
          Result := False;
      end else begin
        if ((TUserCastle(Castle).OwnerGuild = target.Master.MyGuild) or
          TUserCastle(Castle).OwnerGuild.IsAllyGuild(
          TGuild(target.Master.MyGuild))) and (LastHiter <> target.Master) and
          (LastHiter <> target) then
          Result := False;
      end;
    end;

    if target.BoSysopMode or target.BoStoneMode or (target.RaceServer >= RC_NPC) and
      (target.RaceServer < RC_ANIMAL) or (target = self) or
      (TCreature(target).Castle = self.Castle) then
      //���, ����,...
      Result := False;

  end else begin
    ///Result := inherited IsProperTarget (target);

    //�ڽ��� ������
    if LastHiter = target then
      Result := True;

    //���� �ú��� �����ϴ� ���� ����
    if target.TargetCret <> nil then
      if target.TargetCret.RaceServer = RC_ARCHERGUARD then
        Result := True;

    if target.PKLevel >= 2 then begin  //�ü��� �����̸� �����Ѵ�.
      Result := True;
    end;

    if target.BoSysopMode or target.BoStoneMode or (target = self) then
      //���, ����,...
      Result := False;
  end;
end;



 {--------------------------------------------------------------}
 // TArcherGuard

constructor TArcherGuard.Create;
begin
  inherited Create;
  ViewRange  := 12;
  WantRefMsg := True;
  Castle     := nil;
  OriginDir  := -1;
  RaceServer := RC_ARCHERGUARD;
end;

//�ݵ�� target <> nil
procedure TArcherGuard.ShotArrow(targ: TCreature);
var
  dam, armor: integer;
begin
  if targ = nil then
    exit;

  Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
  with WAbil do
    dam := Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1);
  if dam > 0 then begin
    //armor := (Lobyte(targ.WAbil.AC) + Random(ShortInt(Hibyte(targ.WAbil.AC)-Lobyte(targ.WAbil.AC)) + 1));
    //dam := dam - armor;
    //if dam <= 0 then
    //   if dam > -10 then dam := 1;
    dam := targ.GetHitStruckDamage(self, dam);
  end;
  if dam > 0 then begin
    targ.SetLastHiter(self);
    targ.ExpHiter := nil; //����ġ��
    targ.StruckDamage(dam, self);
    targ.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
      targ.WAbil.HP{lparam1}, targ.WAbil.MaxHP{lparam2},
      longint(self){hiter}, '', 600 + _MAX(Abs(CX - targ.CX), Abs(CY - targ.CY)) * 50);
  end;
  SendRefMsg(RM_FLYAXE, Dir, CX, CY, integer(targ), '');
end;

procedure TArcherGuard.Run;
var
  i, d, dis:      integer;
  cret, nearcret: TCreature;
begin
  dis      := 9999;
  nearcret := nil;
  //   if not Death and not BoGhost and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if IsMoveAble then begin
    if GetCurrentTime - WalkTime > GetNextWalkTime then begin
      WalkTime := GetCurrentTime;
      for i := 0 to VisibleActors.Count - 1 do begin
        cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
        if (not cret.Death) and (IsProperTarget(cret)) then begin
          d := abs(CX - cret.CX) + abs(CY - cret.CY);
          if d < dis then begin
            dis      := d;
            nearcret := cret;
          end;
        end;
      end;
      if nearcret <> nil then begin
        SelectTarget(nearcret);
      end else begin
        LoseTarget;
      end;
    end;
    if TargetCret <> nil then begin
      if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
        HitTime := GetCurrentTime;
        ShotArrow(TargetCret);
      end;
    end else begin
      if OriginDir >= 0 then
        if OriginDir <> Dir then
          Turn(OriginDir);
    end;
  end;
  inherited Run;

end;


 {--------------------------------------------------------------}
 // TArcherMaster

constructor TArcherMaster.Create;
begin
  inherited Create;
  ViewRange := 12;
end;

//�ݵ�� target <> nil
procedure TArcherMaster.ShotArrow(targ: TCreature);
var
  dam, armor: integer;
begin
  if targ = nil then
    exit;

  Dir := GetNextDirection(CX, CY, targ.CX, targ.CY);
  with WAbil do
    dam := Lobyte(DC) + Random(shortint(Hibyte(DC) - Lobyte(DC)) + 1);
  if dam > 0 then begin
    //armor := (Lobyte(targ.WAbil.AC) + Random(ShortInt(Hibyte(targ.WAbil.AC)-Lobyte(targ.WAbil.AC)) + 1));
    //dam := dam - armor;
    //if dam <= 0 then
    //   if dam > -10 then dam := 1;
    dam := targ.GetHitStruckDamage(self, dam);
  end;
  if dam > 0 then begin
    targ.SetLastHiter(self);
    targ.ExpHiter := nil; //����ġ��
    targ.StruckDamage(dam, self);
    targ.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
      targ.WAbil.HP{lparam1}, targ.WAbil.MaxHP{lparam2},
      longint(self){hiter}, '', 600 + _MAX(Abs(CX - targ.CX), Abs(CY - targ.CY)) * 50);
  end;
  SendRefMsg(RM_FLYAXE, Dir, CX, CY, integer(targ), '');
end;

function TArcherMaster.AttackTarget: boolean;
var
  i, pwr:  integer;
  cret:    TCreature;
  targdir: byte;
begin
  Result := False;
  if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
    HitTime := GetCurrentTime;
    ShotArrow(TargetCret);
  end;
  Result := True;
end;

procedure TArcherMaster.Run;
var
  i, dis, d:      integer;
  cret, nearcret: TCreature;
begin
  dis      := 9999;
  nearcret := nil;
  if not RunDone and IsMoveAble then begin
    if GetTickCount - SearchEnemyTime > 5000 then begin
      SearchEnemyTime := GetTickCount;
      //��ӹ��� run ���� HitTime �缳����.
      for i := 0 to VisibleActors.Count - 1 do begin
        cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
        if (not cret.Death) and (IsProperTarget(cret)) and
          (not cret.BoHumHideMode or BoViewFixedHide) then begin
          d := abs(CX - cret.CX) + abs(CY - cret.CY);
          if d < dis then begin
            dis      := d;
            nearcret := cret;
          end;
        end;
      end;
      if nearcret <> nil then
        SelectTarget(nearcret);
    end;

    AttackTarget;

    if GetCurrentTime - WalkTime > GetNextWalkTime then begin
      //��ӹ��� run���� WalkTime �缳����
      if TargetCret <> nil then
        if (abs(CX - TargetCret.CX) <= 4) and (abs(CY - TargetCret.CY) <= 4) then begin
          if (abs(CX - TargetCret.CX) <= 2) and (abs(CY - TargetCret.CY) <= 2) then
          begin
            if Random(3) = 0 then begin
              //�ʹ� ������ ������.
              GetBackPosition(self, TargetX, TargetY);
              if TargetX <> -1 then begin //������ ���� ����
                GotoTargetXY;
              end;
            end;
          end;
        end;
    end;
  end;
  inherited Run;
end;


 {--------------------------------------------------------------}
 //�ü�����

constructor TArcherPolice.Create;
begin
  inherited Create;
  RaceServer := RC_ARCHERPOLICE;  //��ȭ���� ������ �ȵǰ�
end;


 {--------------------------------------------------------------}
 //����, ����

constructor TCastleDoor.Create;
begin
  inherited Create;
  BoAnimal    := False;
  StickMode   := True;
  BoOpenState := False; //���� ����
  AntiPoison  := 200;
  //HideMode := TRUE;  //���� ��ô� �Ⱥ��̴� �����
end;

procedure TCastleDoor.Initialize;
begin
  Dir := 0;  //�ʱ����
  inherited Initialize;
  if WAbil.HP > 0 then begin
    if BoOpenState then
      ActiveDoorWall(dsOpen)
    else
      ActiveDoorWall(dsClose);
  end else
    ActiveDoorWall(dsBroken);
end;

//���� ������
procedure TCastleDoor.RepairStructure;
var
  n, newdir: integer;
begin
  if not BoOpenState then begin
    newdir := 3 - Round(WAbil.HP / WAbil.MaxHP * 3);
    if not (newdir in [0..2]) then
      newdir := 0;
    Dir := newdir;
    SendRefMsg(RM_ALIVE, Dir, CX, CY, 0, '');
  end;
end;

//��ϼ����� ��쿡�� ���
procedure TCastleDoor.ActiveDoorWall(dstate: TDoorState);
var
  bomove: boolean;
begin
  PEnvir.GetMarkMovement(CX, CY - 2, True);
  PEnvir.GetMarkMovement(CX + 1, CY - 1, True);
  PEnvir.GetMarkMovement(CX + 1, CY - 2, True);
  if dstate = dsClose then
    bomove := False
  else
    bomove := True;

  PEnvir.GetMarkMovement(CX, CY, bomove);
  PEnvir.GetMarkMovement(CX, CY - 1, bomove);
  PEnvir.GetMarkMovement(CX, CY - 2, bomove);
  PEnvir.GetMarkMovement(CX + 1, CY - 1, bomove);
  PEnvir.GetMarkMovement(CX + 1, CY - 2, bomove);
  PEnvir.GetMarkMovement(CX - 1, CY, bomove);
  PEnvir.GetMarkMovement(CX - 2, CY, bomove);
  PEnvir.GetMarkMovement(CX - 1, CY - 1, bomove);
  PEnvir.GetMarkMovement(CX - 1, CY + 1, bomove);
  if dstate = dsOpen then begin
    PEnvir.GetMarkMovement(CX, CY - 2, False);
    PEnvir.GetMarkMovement(CX + 1, CY - 1, False);
    PEnvir.GetMarkMovement(CX + 1, CY - 2, False);
  end;
end;

procedure TCastleDoor.OpenDoor;
begin
  if not Death then begin
    Dir := 7; //�Ⱥ��̴� ����
    SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
    BoOpenState := True;
    BoStoneMode := True;     //���� ����
    ActiveDoorWall(dsOpen);  //�̵������ϰ�
    HoldPlace := False;      //�ڸ����� ����
  end;
end;

procedure TCastleDoor.CloseDoor;
begin
  if not Death then begin
    Dir := 3 - Round(WAbil.HP / WAbil.MaxHP * 3);
    if not (Dir in [0..2]) then
      Dir := 0;
    SendRefMsg(RM_DIGDOWN, {Dir}0, CX, CY, 0, '');
    BoOpenState := False;
    BoStoneMode := False;  //����
    ActiveDoorWall(dsClose);  //�̵� ���ϰ�
    HoldPlace := True;  //�ڸ����� ��
  end;
end;

procedure TCastleDoor.Die;
begin
  inherited Die;
  BrokenTime := GetTickCount;
  ActiveDoorWall(dsBroken);  //�̵������ϰ�
end;

procedure TCastleDoor.Run;
var
  n, newdir: integer;
begin
  if Death and (Castle <> nil) then begin
    DeathTime := GetTickCount;  //�������� �ʴ´�.
  end else
    HealthTick := 0;  //ü���� �ٽ� ���� �ʴ´�.

  if not BoOpenState then begin
    newdir := 3 - Round(WAbil.HP / WAbil.MaxHP * 3);
    if (newdir <> Dir) and (newdir < 3) then begin  //���� 0,1,2
      Dir := newdir;
      SendRefMsg(RM_TURN, Dir, CX, CY, 0, '');
    end;
  end;

  inherited Run;
end;



 //---------------------------------------------------------------------
 //����,

constructor TWallStructure.Create;
begin
  inherited Create;
  BoAnimal   := False;
  StickMode  := True;
  BoBlockPos := False;
  AntiPoison := 200;
  //HideMode := TRUE;
end;

procedure TWallStructure.Initialize;
begin
  Dir := 0;  //�ʱ����
  inherited Initialize;
end;

//���� ������
procedure TWallStructure.RepairStructure;
var
  n, newdir: integer;
begin
  if WAbil.HP > 0 then
    newdir := 3 - Round(WAbil.HP / WAbil.MaxHP * 3)
  else
    newdir := 4;
  if not (newdir in [0..4]) then
    newdir := 0;
  Dir := newdir;
  SendRefMsg(RM_ALIVE, Dir, CX, CY, 0, '');
end;

procedure TWallStructure.Die;
begin
  inherited Die;
  BrokenTime := GetTickCount;
end;

procedure TWallStructure.Run;
var
  n, newdir: integer;
begin
  if Death then begin
    DeathTime := GetTickCount;  //�������� �ʴ´�.
    if BoBlockPos then begin
      PEnvir.GetMarkMovement(CX, CY, True);  //�̵� �����ϰ�
      BoBlockPos := False;
    end;
  end else begin
    HealthTick := 0;  //ü���� �ٽ� ���� �ʴ´�.
    if not BoBlockPos then begin
      PEnvir.GetMarkMovement(CX, CY, False);  //�̵� ���ϰ�
      BoBlockPos := True;
    end;
  end;

  if WAbil.HP > 0 then
    newdir := 3 - Round(WAbil.HP / WAbil.MaxHP * 3)
  else
    newdir := 4;
  if (newdir <> Dir) and (newdir < 5) then begin  //���� 0,1,2,3,4
    Dir := newdir;
    SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');  //�μ����� �ִϸ��̼�
  end;

  inherited Run;
end;


 //---------------------------------------------------------------------
 // �౸��

constructor TSoccerBall.Create;
begin
  inherited Create;
  BoAnimal := False;
  NeverDie := True;
  GoPower  := 0;
  TargetX  := -1;
end;

procedure TSoccerBall.Struck(hiter: TCreature);
var
  nx, ny: integer;
begin
  if hiter <> nil then begin
    Dir     := hiter.Dir;  //��������� �������� ���� ����.
    GoPower := GoPower + 4 + Random(4);
    GoPower := _MIN(20, GoPower);
    GetNextPosition(PEnvir, CX, CY, Dir, GoPower, nx, ny);
    TargetX := nx;
    TargetY := ny;
  end;

end;


procedure TSoccerBall.Run;
var
  i, dis, nx, ny, nnx, nny: integer;
  bohigh: boolean;
begin
  bohigh := False; // �౸���� ��ġ�� �ȵ� 
  if GoPower > 0 then begin
    if GetNextPosition(PEnvir, CX, CY, Dir, 1, nx, ny) then begin
      if not PEnvir.CanWalk(nx, ny, bohigh) then begin  //���� �ε���
        case Dir of
          0: Dir := 4;
          1: Dir := 7;
          2: Dir := 6;
          3: Dir := 5;
          4: Dir := 0;
          5: Dir := 3;
          6: Dir := 2;
          7: Dir := 1;
        end;
        GetNextPosition(PEnvir, CX, CY, Dir, GoPower, nx, ny);
        TargetX := nx;
        TargetY := ny;
      end;
    end;
  end else
    TargetX := -1;

  if TargetX <> -1 then begin
    GotoTargetXY;
    if (TargetX = CX) and (TargetY = CY) then
      GoPower := 0;
  end;

  inherited Run;

end;

//TrapRock ===================================================================
constructor TTrapRock.Create;
begin
  inherited Create;
  RunDone      := False;
  ViewRange    := 12;
  RunNextTick  := 250;
  SearchRate   := 2500 + longword(Random(1500));
  SearchTime   := GetTickCount;
  RaceServer   := RC_TRAPROCK;
  DigupRange   := 12;
  DigdownRange := 1;
  HideMode     := True;
  StickMode    := True;
  BoAnimal     := False;  //��� ��������, �����ʿ��Ű� ����.
end;


function TTrapRock.AttackTarget: boolean;
var
  targdir: byte;
begin
  Result := False;
  if TargetCret <> nil then begin
    if TargetInAttackRange(TargetCret, targdir) then begin
      if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
        HitTime := GetCurrentTime;
        TargetFocusTime := GetTickCount;
        Attack(TargetCret, targdir);
SendRefMsg(RM_NORMALEFFECT, 0, TargetCret.CX, TargetCret.CY, ROCK_SN_POISON, '');
            if Random(20) = 0 then begin
                    TargetCret.MakePoison(POISON_STONE, 5{�ð�,��}, 0);
                 end;
      end;
      Result := True;
    end else begin
      if TargetCret.MapName = self.MapName then
        SetTargetXY(TargetCret.CX, TargetCret.CY)
      else
        LoseTarget;  //<!!����> TargetCret := nil�� �ٲ�
    end;
  end;
end;


procedure TTrapRock.ComeOut;
begin
  HideMode := False;
  SendRefMsg(RM_DIGUP, Dir, CX, CY, 0, '');
end;


procedure TTrapRock.CheckComeOut;
var
  i, nx, ny, damage:    integer;
  cret: TCreature;
begin
  for i := 0 to VisibleActors.Count - 1 do begin
    cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
    if (not cret.Death) and (IsProperTarget(cret)) and
      (not cret.BoHumHideMode or BoViewFixedHide) then begin
      if (abs(CX - cret.CX) <= DigupRange) and (abs(CY - cret.CY) <= DigupRange) then
      begin
        cret.MakePoison(POISON_STONE, 5{�ð�,��}, 0);
        cret.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, damage{wparam},
          cret.WAbil.HP{lparam1}, cret.WAbil.MaxHP{lparam2},
          longint(self){hiter}, '', 1000);
      case Random(4) of
      1:
      begin
      aax := Cret.CX+1;
      aay := Cret.CY-1;
      bbx := Cret.CX-1;
      bby := Cret.CY-1;
      ccx := Cret.CX+1;
      ccy := Cret.CY+1;
      ddx := Cret.CX-1;
      ddy := Cret.CY+1;
      mon := UserEngine.AddCreatureSysop(MapName, cret.CX, cret.CY-1, 'TrapRock1');
      mon2 := UserEngine.AddCreatureSysop(MapName, cret.CX+1, cret.CY, 'TrapRock1');
      mon3 := UserEngine.AddCreatureSysop(MapName, cret.CX-1, cret.CY, 'TrapRock1');
      mon.SelectTarget(cret);
      mon2.SelectTarget(cret);
      mon3.SelectTarget(cret);
      PEnvir.GetMarkMovement(aax, aay, False);
      PEnvir.GetMarkMovement(bbx, bby, False);
      PEnvir.GetMarkMovement(ccx, ccy, False);
      PEnvir.GetMarkMovement(ddx, ddy, False);
      nx := cret.CX;
      ny := Cret.CY+1;
      if PEnvir.CanWalk(nx, ny, True) then begin
      Self.SpaceMove(MapName, cret.CX, cret.CY+1, 0);
      end else begin
      nx := cret.CX;
      ny := Cret.CY-1;
      if PEnvir.CanWalk(nx, ny, True) then begin
      mon.MakeGhost(8);
      Self.SpaceMove(MapName, cret.CX, cret.CY-1, 0);
      end else begin
      nx := cret.CX+1;
      ny := Cret.CY;
      if PEnvir.CanWalk(nx, ny, True) then begin
      mon2.MakeGhost(8);
      Self.SpaceMove(MapName, cret.CX+1, cret.CY, 0);
      end else begin
      nx := cret.CX-1;
      ny := Cret.CY;
      if PEnvir.CanWalk(nx, ny, True) then begin
      mon3.MakeGhost(8);
      Self.SpaceMove(MapName, cret.CX-1, cret.CY, 0);
      end else begin
      WAbil.HP := 0;
      end;
      end;
      end;
      end;
            Self.SelectTarget(cret);
        ComeOut; //������ ������. ���δ�.
        break;
      end;
      2:
      begin
      aax := Cret.CX+1;
      aay := Cret.CY-1;
      bbx := Cret.CX-1;
      bby := Cret.CY-1;
      ccx := Cret.CX+1;
      ccy := Cret.CY+1;
      ddx := Cret.CX-1;
      ddy := Cret.CY+1;
      mon := UserEngine.AddCreatureSysop(MapName, cret.CX, cret.CY+1, 'TrapRock1');
      mon2 := UserEngine.AddCreatureSysop(MapName, cret.CX+1, cret.CY, 'TrapRock1');
      mon3 := UserEngine.AddCreatureSysop(MapName, cret.CX-1, cret.CY, 'TrapRock1');
      mon.SelectTarget(cret);
      mon2.SelectTarget(cret);
      mon3.SelectTarget(cret);
      PEnvir.GetMarkMovement(aax, aay, False);
      PEnvir.GetMarkMovement(bbx, bby, False);
      PEnvir.GetMarkMovement(ccx, ccy, False);
      PEnvir.GetMarkMovement(ddx, ddy, False);
      nx := cret.CX;
      ny := Cret.CY-1;
      if PEnvir.CanWalk(nx, ny, True) then begin
      Self.SpaceMove(MapName, cret.CX, cret.CY-1, 0);
      end else begin
      nx := cret.CX;
      ny := Cret.CY+1;
      if PEnvir.CanWalk(nx, ny, True) then begin
      mon.MakeGhost(8);
      Self.SpaceMove(MapName, cret.CX, cret.CY+1, 0);
      end else begin
      nx := cret.CX+1;
      ny := Cret.CY;
      if PEnvir.CanWalk(nx, ny, True) then begin
      mon2.MakeGhost(8);
      Self.SpaceMove(MapName, cret.CX+1, cret.CY, 0);
      end else begin
      nx := cret.CX-1;
      ny := Cret.CY;
      if PEnvir.CanWalk(nx, ny, True) then begin
      mon3.MakeGhost(8);
      Self.SpaceMove(MapName, cret.CX-1, cret.CY, 0);
      end else begin
      WAbil.HP := 0;
      end;
      end;
      end;
      end;
            Self.SelectTarget(cret);
        ComeOut; //������ ������. ���δ�.
        break;
      end;
      3:
      begin
      aax := Cret.CX+1;
      aay := Cret.CY-1;
      bbx := Cret.CX-1;
      bby := Cret.CY-1;
      ccx := Cret.CX+1;
      ccy := Cret.CY+1;
      ddx := Cret.CX-1;
      ddy := Cret.CY+1;
      mon := UserEngine.AddCreatureSysop(MapName, cret.CX, cret.CY-1, 'TrapRock1');
      mon2 := UserEngine.AddCreatureSysop(MapName, cret.CX, cret.CY+1, 'TrapRock1');
      mon3 := UserEngine.AddCreatureSysop(MapName, cret.CX-1, cret.CY, 'TrapRock1');
      mon.SelectTarget(cret);
      mon2.SelectTarget(cret);
      mon3.SelectTarget(cret);
      PEnvir.GetMarkMovement(aax, aay, False);
      PEnvir.GetMarkMovement(bbx, bby, False);
      PEnvir.GetMarkMovement(ccx, ccy, False);
      PEnvir.GetMarkMovement(ddx, ddy, False);
      nx := cret.CX+1;
      ny := Cret.CY;
      if PEnvir.CanWalk(nx, ny, True) then begin
      Self.SpaceMove(MapName, cret.CX+1, cret.CY, 0);
      end else begin
      nx := cret.CX;
      ny := Cret.CY-1;
      if PEnvir.CanWalk(nx, ny, True) then begin
      mon.MakeGhost(8);
      Self.SpaceMove(MapName, cret.CX, cret.CY-1, 0);
      end else begin
      nx := cret.CX;
      ny := Cret.CY+1;
      if PEnvir.CanWalk(nx, ny, True) then begin
      mon2.MakeGhost(8);
      Self.SpaceMove(MapName, cret.CX, cret.CY+1, 0);
      end else begin
      nx := cret.CX-1;
      ny := Cret.CY;
      if PEnvir.CanWalk(nx, ny, True) then begin
      mon3.MakeGhost(8);
      Self.SpaceMove(MapName, cret.CX-1, cret.CY, 0);
      end else begin
      WAbil.HP := 0;
      end;
      end;
      end;
      end;
            Self.SelectTarget(cret);
        ComeOut; //������ ������. ���δ�.
        break;
      end;
      4:
      begin
      aax := Cret.CX+1;
      aay := Cret.CY-1;
      bbx := Cret.CX-1;
      bby := Cret.CY-1;
      ccx := Cret.CX+1;
      ccy := Cret.CY+1;
      ddx := Cret.CX-1;
      ddy := Cret.CY+1;
      mon := UserEngine.AddCreatureSysop(MapName, cret.CX, cret.CY-1, 'TrapRock1');
      mon2 := UserEngine.AddCreatureSysop(MapName, cret.CX+1, cret.CY, 'TrapRock1');
      mon3 := UserEngine.AddCreatureSysop(MapName, cret.CX, cret.CY+1, 'TrapRock1');
      mon.SelectTarget(cret);
      mon2.SelectTarget(cret);
      mon3.SelectTarget(cret);
      PEnvir.GetMarkMovement(aax, aay, False);
      PEnvir.GetMarkMovement(bbx, bby, False);
      PEnvir.GetMarkMovement(ccx, ccy, False);
      PEnvir.GetMarkMovement(ddx, ddy, False);
      nx := cret.CX-1;
      ny := Cret.CY;
      if PEnvir.CanWalk(nx, ny, True) then begin
      Self.SpaceMove(MapName, cret.CX-1, cret.CY, 0);
      end else begin
      nx := cret.CX;
      ny := Cret.CY-1;
      if PEnvir.CanWalk(nx, ny, True) then begin
      mon.MakeGhost(8);
      Self.SpaceMove(MapName, cret.CX, cret.CY-1, 0);
      end else begin
      nx := cret.CX+1;
      ny := Cret.CY;
      if PEnvir.CanWalk(nx, ny, True) then begin
      mon2.MakeGhost(8);
      Self.SpaceMove(MapName, cret.CX+1, cret.CY, 0);
      end else begin
      nx := cret.CX;
      ny := Cret.CY+1;
      if PEnvir.CanWalk(nx, ny, True) then begin
      mon3.MakeGhost(8);
      Self.SpaceMove(MapName, cret.CX, cret.CY+1, 0);
      end else begin
      WAbil.HP := 0;
      end;
      end;
      end;
      end;
      Self.SelectTarget(cret);
        ComeOut; //������ ������. ���δ�.
        break;
      end;
end;
end;
end;
end;
end;

procedure TTrapRock.Struck(hiter: TCreature);
var
deathblow: integer;
begin
  if hiter <> nil then begin
  if WAbil.MaxHP > 0 then begin
  deathblow := Wabil.MaxHP div 10;
  if Random(deathblow) = 0 then begin
    WAbil.HP := 0;
  end else begin
  WAbil.HP := WAbil.MaxHP;
  end;
  end;
  end;
end;

procedure TTrapRock.Die;
begin
  inherited Die;
     PEnvir.GetMarkMovement(aax, aay, True);
      PEnvir.GetMarkMovement(bbx, bby, True);
      PEnvir.GetMarkMovement(ccx, ccy, True);
      PEnvir.GetMarkMovement(ddx, ddy, True);
      mon.WAbil.HP := 0;
      mon2.WAbil.HP := 0;
      mon3.WAbil.HP := 0;
end;

procedure TTrapRock.ComeDown;
begin
WAbil.HP := 0;
end;

procedure TTrapRock.Run;
var
  boidle: boolean;
begin
  //   if (not BoGhost) and (not Death) and
  //      (StatusArr[POISON_STONE] = 0) and (StatusArr[POISON_ICE] = 0) and
  //      (StatusArr[POISON_STUN] = 0) then begin
  if IsMoveAble then begin
    if GetCurrentTime - WalkTime > GetNextWalkTime then begin
      WalkTime := GetCurrentTime;
      if HideMode then begin //���� ����� ��Ÿ���� �ʾ���.
        CheckComeOut;
      end else begin
        if integer(GetCurrentTime - HitTime) > GetNextHitTime then
        begin //��ӹ��� run ���� HitTime �缳����.
              ///HitTime := GetTickCount; //�Ʒ� AttackTarget���� ��.
          MonsterNormalAttack;
        end;

        boidle := False;
        if TargetCret <> nil then begin
          if (abs(TargetCret.CX - CX) > DigdownRange) or
            (abs(TargetCret.CY - CY) > DigdownRange) then
            boidle := True;
        end else
          boidle := True;

        if boidle then
          ComeDown //�ٽ� ����.
        else if AttackTarget then begin
          inherited Run;
          exit;
        end;
      end;
    end;
  end;

  inherited Run;

end;



end.

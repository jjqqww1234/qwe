unit Magic;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  ScktComp, syncobjs, MudUtil, HUtil32, Grobal2, Envir, EdCode, ObjBase,
  M2Share, Event;

type
  TMagicManager = class
  private
  public
    constructor Create;
    function MPow(pum: PTUserMagic): integer;
    function MagPushAround(user: TCreature; pushlevel: integer): integer; //0..3
    function MagLightingShock(user, target: TCreature;
      x, y, shocklevel: integer): boolean;
    function MagTurnUndead(user, target: TCreature; x, y, mlevel: integer): boolean;
    function MagLightingSpaceMove(user: TCreature; slevel: integer): boolean;
    function MagMakeHolyCurtain(user: TCreature; htime, x, y: integer): integer;
    function MagMakeFireCross(user: TCreature; dam, htime, x, y: integer): integer;
    function MagBigHealing(user: TCreature; pwr, x, y: integer): boolean;
    function MagBigExplosion(user: TCreature; pwr, x, y, wide: integer): boolean;
    function MagBlizzard(user: TCreature; dam, htime, x, y: integer): integer;
    function MagMeteor(user: TCreature; dam, htime, x, y: integer): integer;
    function MagDragonFire(user: TCreature; pwr, skilllevel: integer): boolean;
    function MagElecBlizzard(user: TCreature; pwr: integer): boolean;
    function MagMakePrivateTransparent(user: TCreature; htime: integer): boolean;
    function MagMakeGroupTransparent(user: TCreature; x, y, htime: integer): boolean;
    function IsSwordSkill(mid: integer): boolean;
    function SpellNow(user: TCreature; pum: PTUserMagic; xx, yy: integer;
      target: TCreature; spell: integer): boolean;
    // 2003/07/15 �űԹ���
    function MagMakePrivateClean(user: TCreature; x, y, pct: integer): boolean;
    procedure WindCutHit(user, target: TCreature; hitPwr, magpwr: integer);
    function MagWindCut(user: TCreature; skilllevel: integer): boolean;
    // 2004/06/23 �űԹ���
    function MagPullMon(user, target: TCreature; skilllevel: integer): boolean;
    function MagBlindEye(user, target: TCreature; pum: PTUserMagic): boolean;

  end;


implementation

uses
  svMain;

constructor TMagicManager.Create;
begin
  inherited Create;
end;

 //�˼����� �ƴ��� ����..
 //�˼��� Ű�� ���� ����ϴ� ������ �ƴ�
function TMagicManager.IsSwordSkill(mid: integer): boolean;
begin
  Result := False;
  //2003/03/15 �űԹ��� �߰�
  case mid of
    3, 4, 7, 12, 25, 26, 27, 34, 38, 59, 60: Result := True;
  end;
end;

function TMagicManager.MPow(pum: PTUserMagic): integer;
begin
  Result := pum.pDef.MinPower + Random(pum.pDef.MaxPower - pum.pDef.MinPower);
end;

//pushlevel = 0..3
function TMagicManager.MagPushAround(user: TCreature; pushlevel: integer): integer;
var
  i, ndir, levelgap, push: integer;
  cret: TCreature;
begin
  Result := 0;
  for i := 0 to user.VisibleActors.Count - 1 do begin
    cret := TCreature(PTVisibleActor(user.VisibleActors[i]).cret);
    if (abs(user.CX - cret.CX) <= 1) and (abs(user.CY - cret.CY) <= 1) then begin
      if (not cret.Death) and (cret <> user) then begin
        if (user.Abil.Level > cret.Abil.Level) and (not cret.StickMode) then begin
          levelgap := user.Abil.Level - cret.Abil.Level;
          if (Random(20) < 6 + pushlevel * 3 + levelgap) then begin  //���������� ����
            if user.IsProperTarget(cret) then begin
              push := 1 + _MAX(0, pushlevel - 1) + Random(2);
              ndir := GetNextDirection(user.CX, user.CY, cret.CX, cret.CY);
              cret.CharPushed(ndir, push);
              Inc(Result);
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TMagicManager.MagDragonFire(user: TCreature;
  pwr, skilllevel: integer): boolean;
var
  i:     integer;
  rlist: TList;
  cret:  TCreature;
  wide:  integer;
begin
  Result := False;
  rlist  := TList.Create;
  wide   := 2;
  user.GetMapCreatures(user.PEnvir, user.CX, user.CY, wide, rlist);
  for i := 0 to rlist.Count - 1 do begin
    cret := TCreature(rlist[i]);
    if user.IsProperTarget(cret) then begin
      user.SelectTarget(cret);
      cret.SendMsg(user, RM_MAGSTRUCK, 0, pwr, 0, 0, '');
      Result := True;
    end;
  end;
  rlist.Free;

end;

function TMagicManager.MagLightingShock(user, target: TCreature;
  x, y, shocklevel: integer): boolean;
var
  ran: integer;
begin
  Result := False;
  if (target.RaceServer <> RC_USERHUMAN) and (Random(4 - shocklevel) = 0) then begin
    target.TargetCret := nil;
    //��: �����Ͽ��� ��ȥ���� ���� �����.
    if target.Master = user then begin
      target.MakeHolySeize((10 + shocklevel * 5) * 1000);
      //������ ����, ���� �Ҿ����
      Result := True;
      exit;
    end;

    if (Random(2) = 0) then begin
      if target.Abil.Level <= user.Abil.Level + 2 then begin
        if Random(3) = 0 then begin
          if (10 + target.Abil.Level) < Random(20 + user.Abil.Level +
            shocklevel * 5) then begin
            //                  if (not target.NoMaster) and
            //                     (target.LifeAttrib = LA_CREATURE) and
            //                     (target.RaceServer <> RC_CLONE  ) and
            //                     (target.RaceServer <> RC_ANGEL  ) and
            //2003/02/11 �ִ뷡�� ����
            //                     (target.Abil.Level < MAXKINGLEVEL-1) and     //50
            //                     (user.SlaveList.Count < (2 + shocklevel) and
            if user.EnableRecallMob(target, shockLevel) then begin
              //�����ִ¸��̰�, ������ 50�̸��̾�� �ϰ�, ���ϼ��� 5���� �̸��� ���
              ran := target.WAbil.MaxHP div 100;

              if target.RaceServer = RC_GHOST_TIGER then
                ran := ran div 4;

              if ran <= 2 then
                ran := 2
              else
                ran := ran + ran;

              if (target.Master <> user) and (Random(ran) = 0) then begin
                target.BreakCrazyMode;
                if target.Master <> nil then //���� ���� ����
                  target.WAbil.HP := target.WAbil.HP div 10;
                target.Master := user;  //��ȯ���� ����´�.
                target.MasterRoyaltyTime :=
                  GetTickCount + longword(20 + shocklevel *
                  20 + Random(user.Abil.Level * 2)) * 60 * 1000;
                target.SlaveMakeLevel    := shocklevel;
                if target.SlaveLifeTime = 0 then
                  target.SlaveLifeTime := GetTickCount;
                //target.SlaveExpLevel := 0;
                target.BreakHolySeize;
                if target.NextWalkTime > 1500 - (shocklevel * 200) then
                  target.NextWalkTime := 1500 - (shocklevel * 200);
                if target.NextHitTime > 2000 - (shocklevel * 200) then
                  target.NextHitTime := 2000 - (shocklevel * 200);
                //target.FeatureChanged;
                target.UserNameChanged;
                user.SlaveList.Add(target);
              end else begin
                if (Random(20) = 0) then begin
                  target.WAbil.HP := 0;  //�ٷ� �״´�.
                end;
              end;
            end else begin
              if (target.LifeAttrib = LA_UNDEAD) and (Random(2) = 0) then begin
                target.WAbil.HP := 0;  //�ٷ� �״´�.
              end;
            end;
          end else begin
            if (target.LifeAttrib <> LA_UNDEAD) and (Random(2) = 0) then
            begin //�𵥵尡 �ƴѰ�� ���ֻ���
              target.MakeCrazyMode(10 + Random(20));
            end;
          end;
        end else begin
          if target.LifeAttrib <> LA_UNDEAD then begin //�𵥵尡 �ƴѰ�� ���ֻ���
            target.MakeCrazyMode(10 + Random(20));
          end;
        end;
      end;
    end else begin
      target.MakeHolySeize((10 + shocklevel * 5) * 1000);
      //������ ����, ���� �Ҿ����
    end;
    Result := True;
  end else if Random(2) = 0 then
    Result := True;
end;

function TMagicManager.MagTurnUndead(user, target: TCreature;
  x, y, mlevel: integer): boolean;
var
  lvgap: integer;
begin
  Result := False;
  if (not target.NeverDie) and (target.LifeAttrib = LA_UNDEAD) then begin
    TAnimal(target).Struck(user);
    if target.TargetCret = nil then begin  //��� ������ �Ͼ𵥵尡 ���� ��� ������
      TAnimal(target).BoRunAwayMode := True;
      TAnimal(target).RunAwayStart  := GetTickCount;
      TAnimal(target).RunAwayTime   := 10 * 1000;
    end;
    user.SelectTarget(target);
    // ���� 52���� ���� ����(sonmg 2004/09/08)
    if (target.Abil.Level < (_MIN(user.Abil.Level, 51) - 1 + Random(4))) and
      //2003/02/11 �ִ뷡�� ����
      (target.Abil.Level < MAXKINGLEVEL - 1)   //50 -> 61
    then begin
      lvgap := user.Abil.Level - target.Abil.Level;
      if Random(100) < (15 + mlevel * 7 + lvgap) then begin
        target.SetLastHiter(user);
        target.WAbil.HP := 0;  //�ٷ� �״´�.
        Result := True;
      end;
    end;
  end;
end;

function TMagicManager.MagLightingSpaceMove(user: TCreature; slevel: integer): boolean;
var
  oldenvir: TEnvirnoment;
  hum:      TUserHuman;
begin
  Result := False;
  if not user.BoTaiwanEventUser then begin
    if not (user.PEnvir.NoEscapeMove or user.PEnvir.NoTeleportMove) then
    begin  //�ư���� ���Ұ�(sonmg)
      if Random(11) < 4 + slevel * 2 then begin
        user.SendRefMsg(RM_SPACEMOVE_HIDE2, 0, 0, 0, 0, '');
        if user is TUserHuman then begin
          oldenvir := user.PEnvir;

          TUserHuman(user).RandomSpaceMove(user.HomeMap, 1);

          if oldenvir <> user.PEnvir then begin
            //���������� �ٸ� ������ �̵� �Ͽ���
            if user.RaceServer = RC_USERHUMAN then begin
              //                     hum := TUserHuman (self); //�����ǹ���
              hum := TUserHuman(user);   // �����ڵ�
              hum.BoTimeRecall := False;    //TimeRecall ���
              hum.BoTimeRecallGroup := False;    //TimeRecall ���
            end;
          end;
        end;
        Result := True;
      end;
    end;
  end;
end;

function TMagicManager.MagMakeHolyCurtain(user: TCreature;
  htime, x, y: integer): integer;
var
  event: TEvent;
  i:     integer;
  rlist: TList;
  cret:  TCreature;
  phs:   PTHolySeizeInfo;
begin
  Result := 0;
  if user.PEnvir.CanWalk(x, y, True) then begin
    rlist := TList.Create;
    phs   := nil;
    user.GetMapCreatures(user.PEnvir, x, y, 1, rlist);
    for i := 0 to rlist.Count - 1 do begin
      cret := TCreature(rlist[i]);
      if (cret.RaceServer >= RC_ANIMAL) and (cret.Abil.Level <
        (user.Abil.Level - 1 + Random(4))) and
        //2003/02/11 �ִ뷡�� ����
        (cret.Abil.Level < MAXKINGLEVEL - 1) and    //50 -> 61
        (cret.Master = nil) then begin  //��迡 �ɸ���.
        cret.MakeHolySeize(htime * 1000);
        if phs = nil then begin
          phs := new(PTHolySeizeInfo);    //�������
          FillChar(phs^, sizeof(THolySeizeInfo), #0);
          phs.seizelist := TList.Create;
          phs.OpenTime  := GetTickCount;
          //��谡 �ּҷ� ������ �ð�(����� �ִ�ð��� 3��)
          phs.SeizeTime := htime * 1000; //����� ���ӽð�
        end;
        phs.seizelist.Add(cret);
        //��迡 �ɸ� ���� ���, ���߿� ��谡 �����Ǿ������� �˱�����
        Inc(Result);
      end else begin
        Result := 0;  //��迡 �ɸ��� �ʴ� ���� ���ԵǾ� ������ ��ҵ�
        break;
      end;
    end;
    rlist.Free;

    if (Result > 0) and (phs <> nil) then begin
      //8���� ���� ��´�.
      event := THolyCurtainEvent.Create(user.PEnvir, x - 1, y - 2,
        ET_HOLYCURTAIN, htime * 1000);
      EventMan.AddEvent(event);
      phs.earr[0] := event;
      event := THolyCurtainEvent.Create(user.PEnvir, x + 1, y - 2,
        ET_HOLYCURTAIN, htime * 1000);
      EventMan.AddEvent(event);
      phs.earr[1] := event;
      event := THolyCurtainEvent.Create(user.PEnvir, x - 2, y - 1,
        ET_HOLYCURTAIN, htime * 1000);
      EventMan.AddEvent(event);
      phs.earr[2] := event;
      event := THolyCurtainEvent.Create(user.PEnvir, x + 2, y - 1,
        ET_HOLYCURTAIN, htime * 1000);
      EventMan.AddEvent(event);
      phs.earr[3] := event;
      event := THolyCurtainEvent.Create(user.PEnvir, x - 2, y + 1,
        ET_HOLYCURTAIN, htime * 1000);
      EventMan.AddEvent(event);
      phs.earr[4] := event;
      event := THolyCurtainEvent.Create(user.PEnvir, x + 2, y + 1,
        ET_HOLYCURTAIN, htime * 1000);
      EventMan.AddEvent(event);
      phs.earr[5] := event;
      event := THolyCurtainEvent.Create(user.PEnvir, x - 1, y + 2,
        ET_HOLYCURTAIN, htime * 1000);
      EventMan.AddEvent(event);
      phs.earr[6] := event;
      event := THolyCurtainEvent.Create(user.PEnvir, x + 1, y + 2,
        ET_HOLYCURTAIN, htime * 1000);
      EventMan.AddEvent(event);
      phs.earr[7] := event;

      UserEngine.HolySeizeList.Add(phs); //����߰�
    end else begin
      if phs <> nil then begin
        phs.seizelist.Free;
        Dispose(phs);
      end;
    end;
  end;
end;

function TMagicManager.MagMakeFireCross(user: TCreature;
  dam, htime, x, y: integer): integer;
var
  event: TEvent;
  i:     integer;
  rlist: TList;
  cret:  TCreature;
begin
  if user.PEnvir.GetEvent(x, y - 1) = nil then begin
    event := TFireBurnEvent.Create(user, x, y - 1, ET_FIRE, htime * 1000, dam);
    EventMan.AddEvent(event);
  end;
  if user.PEnvir.GetEvent(x - 1, y) = nil then begin
    event := TFireBurnEvent.Create(user, x - 1, y, ET_FIRE, htime * 1000, dam);
    EventMan.AddEvent(event);
  end;
  if user.PEnvir.GetEvent(x, y) = nil then begin
    event := TFireBurnEvent.Create(user, x, y, ET_FIRE, htime * 1000, dam);
    EventMan.AddEvent(event);
  end;
  if user.PEnvir.GetEvent(x + 1, y) = nil then begin
    event := TFireBurnEvent.Create(user, x + 1, y, ET_FIRE, htime * 1000, dam);
    EventMan.AddEvent(event);
  end;
  if user.PEnvir.GetEvent(x, y + 1) = nil then begin
    event := TFireBurnEvent.Create(user, x, y + 1, ET_FIRE, htime * 1000, dam);
    EventMan.AddEvent(event);
  end;

  Result := 1;
end;

function TMagicManager.MagBigHealing(user: TCreature; pwr, x, y: integer): boolean;
var
  i:     integer;
  rlist: TList;
  cret:  TCreature;
begin
  Result := False;
  rlist  := TList.Create;
  user.GetMapCreatures(user.PEnvir, x, y, 1, rlist);
  for i := 0 to rlist.Count - 1 do begin
    cret := TCreature(rlist[i]);
    if user.IsProperFriend(cret) then begin
      if cret.WAbil.HP < cret.WAbil.MaxHP then begin
        cret.SendDelayMsg(user, RM_MAGHEALING, 0, pwr, 0, 0, '', 800);
        Result := True;
      end;
      if user.BoAbilSeeHealGauge then begin
        user.SendMsg(cret, RM_INSTANCEHEALGUAGE, 0, 0, 0, 0, '');
      end;
    end;
  end;
  rlist.Free;
end;

function TMagicManager.MagBigExplosion(user: TCreature;
  pwr, x, y, wide: integer): boolean;
var
  i:     integer;
  rlist: TList;
  cret:  TCreature;
begin
  Result := False;
  rlist  := TList.Create;
  user.GetMapCreatures(user.PEnvir, x, y, wide, rlist);
  for i := 0 to rlist.Count - 1 do begin
    cret := TCreature(rlist[i]);
    if user.IsProperTarget(cret) then begin
      user.SelectTarget(cret);
      cret.SendMsg(user, RM_MAGSTRUCK, 0, pwr, 0, 0, '');
      Result := True;
    end;
  end;
  rlist.Free;
end;

function TMagicManager.MagBlizzard(user: TCreature;
  dam, htime, x, y: integer): integer;
var
  event: TEvent;
  i:     integer;
  rlist: TList;
  cret:  TCreature;
begin
    User.UseBlizzard := True;
    event := TBlizzardEvent.Create(user, x, y, ET_BLIZZARD, htime, Round(dam * 1.15));
    EventMan.AddEvent(event);
    event := TBlizzardEvent.Create(user, x - 1, y - 1, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TBlizzardEvent.Create(user, x, y - 1, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TBlizzardEvent.Create(user, x + 1, y - 1, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TBlizzardEvent.Create(user, x - 1, y, ET_BLIZZARD, htime, Round(dam * 1.15));
    EventMan.AddEvent(event);
    event := TBlizzardEvent.Create(user, x + 1, y, ET_BLIZZARD, htime, Round(dam * 1.15));
    EventMan.AddEvent(event);
    event := TBlizzardEvent.Create(user, x - 1, y + 1, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TBlizzardEvent.Create(user, x, y + 1, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TBlizzardEvent.Create(user, x + 1, y + 1, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TBlizzardEvent.Create(user, x - 2, y, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TBlizzardEvent.Create(user, x + 2, y, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);

Result := 1;
end;

function TMagicManager.MagMeteor(user: TCreature;
  dam, htime, x, y: integer): integer;
var
  event: TEvent;
  i:     integer;
  rlist: TList;
  cret:  TCreature;
begin
    User.UseBlizzard := True;
    event := TMeteorEvent.Create(user, x, y, ET_METEOR, htime, Round(dam * 1.5));
    EventMan.AddEvent(event);
    event := TMeteorEvent.Create(user, x - 1, y - 1, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TMeteorEvent.Create(user, x, y - 1, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TMeteorEvent.Create(user, x + 1, y - 1, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TMeteorEvent.Create(user, x - 1, y, ET_BLIZZARD, htime, Round(dam * 1.5));
    EventMan.AddEvent(event);
    event := TMeteorEvent.Create(user, x + 1, y, ET_BLIZZARD, htime, Round(dam * 1.5));
    EventMan.AddEvent(event);
    event := TMeteorEvent.Create(user, x - 1, y + 1, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TMeteorEvent.Create(user, x, y + 1, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TMeteorEvent.Create(user, x + 1, y + 1, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TMeteorEvent.Create(user, x - 2, y, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);
    event := TMeteorEvent.Create(user, x + 2, y, ET_BLIZZARD, htime, dam);
    EventMan.AddEvent(event);

Result := 1;
end;

function TMagicManager.MagElecBlizzard(user: TCreature; pwr: integer): boolean;
var
  i, acpwr: integer;
  rlist:    TList;
  cret:     TCreature;
begin
  Result := False;
  rlist  := TList.Create;
  user.GetMapCreatures(user.PEnvir, user.CX, user.CY, 2, rlist);
  for i := 0 to rlist.Count - 1 do begin
    cret := TCreature(rlist[i]);
    if cret.LifeAttrib <> LA_UNDEAD then  //�𵥵� �迭 ���Ϳ��� ���ݷ��� ����
      acpwr := pwr div 10
    else
      acpwr := pwr;
    if user.IsProperTarget(cret) then begin
      cret.SendMsg(user, RM_MAGSTRUCK, 0, acpwr, 0, 0, '');
      Result := True;
    end;
  end;
  rlist.Free;
end;


 //���ڰ� ������ �ȴ�. ���� �����ϰ� �ִ� ������ ���� ���󺻴�.
 //���ڰ� ������ ������.
 //���ڰ� �̵��ϸ� �����ȴ�.
function TMagicManager.MagMakePrivateTransparent(user: TCreature;
  htime: integer): boolean;
var
  i:     integer;
  rlist: TList;
  cret:  TCreature;
begin
  Result := False;
  if user.StatusArr[STATE_TRANSPARENT] > 0 then
    exit;  //�̹� ����

  rlist := TList.Create;
  user.GetMapCreatures(user.PEnvir, user.CX, user.CY, 9, rlist);
  for i := 0 to rlist.Count - 1 do begin
    cret := TCreature(rlist[i]);
    if cret.RaceServer >= RC_ANIMAL then begin
      if cret.TargetCret = user then begin
        //������ �ִ³��� 1/2 �� �Ѿ��.
        if (abs(cret.CX - user.CX) > 1) or (abs(cret.CY - user.CY) > 1) or
          (Random(2) = 0) then begin
          cret.TargetCret := nil;
        end;
      end;
    end;
  end;
  rlist.Free;
  user.StatusArr[STATE_TRANSPARENT] := htime;
  user.CharStatus := user.GetCharStatus;
  user.CharStatusChanged;
  user.BoHumHideMode := True;
  user.BoFixedHideMode := True; //�� �ڸ������� ���Ű���, �̵��ϸ� ������ Ǯ����.
  Result := True;
end;

function TMagicManager.MagMakeGroupTransparent(user: TCreature;
  x, y, htime: integer): boolean;
var
  i:     integer;
  rlist: TList;
  cret:  TCreature;
begin
  Result := False;
  rlist  := TList.Create;
  user.GetMapCreatures(user.PEnvir, x, y, 1, rlist);
  for i := 0 to rlist.Count - 1 do begin
    cret := TCreature(rlist[i]);
    //if cret.RaceServer = RC_USERHUMAN then begin
    if user.IsProperFriend(cret) then begin  //. or (cret.Master <> nil) then begin  //
      if cret.StatusArr[STATE_TRANSPARENT] = 0 then begin  //������ �ƴ� ����
        cret.SendDelayMsg(cret, RM_TRANSPARENT, 0, htime, 0, 0, '', 800);
        //if MagMakePrivateTransparent (cret, htime) then
        Result := True;
      end;
    end;
  end;
  rlist.Free;
end;

function TMagicManager.MagMakePrivateClean(user: TCreature;
  x, y, pct: integer): boolean;
var
  i:     integer;
  rlist: TList;
  cret:  TCreature;
begin
  Result := False;
  if Random(100) > pct then
    exit;

  rlist := TList.Create;
  user.GetMapCreatures(user.PEnvir, x, y, 0, rlist);
  for i := 0 to rlist.Count - 1 do begin
    cret := TCreature(rlist[i]);
    if user.IsProperFriend(cret) then begin
      cret.StatusArr[POISON_DECHEALTH] := 0;
      cret.StatusArr[POISON_DAMAGEARMOR] := 0;
      cret.StatusArr[POISON_ICE] := 0;
      cret.StatusArr[POISON_STUN] := 0;
      cret.StatusArr[POISON_DONTMOVE] := 0;
      cret.StatusArr[POISON_STONE] := 0;
      cret.StatusArr[POISON_SLOW] := 0;
      cret.CharStatus := cret.GetCharStatus;
      cret.CharStatusChanged;
      Result := True;
    end;
  end;
  rlist.Free;
end;

procedure TMagicManager.WindCutHit(user, target: TCreature; hitPwr, magpwr: integer);
var
  i, dam: integer;
  //   list: TList;
  //   cret: TCreature;
begin
  //   list := TList.Create;
  //   user.PEnvir.GetAllCreature (target.CX, target.CY, TRUE, list);
  //   for i:=0 to list.Count-1 do begin
  //      cret := TCreature(list[i]);
  if user.IsProperTarget(target) then begin
    dam := 0;
    dam := dam + target.GetHitStruckDamage(user, hitpwr);
    dam := dam + target.GetMagStruckDamage(user, magpwr);
    if dam > 0 then begin
      target.StruckDamage(dam, user);
      target.SendDelayMsg(TCreature(RM_STRUCK), RM_REFMESSAGE, dam{wparam},
        target.WAbil.HP{lparam1}, target.WAbil.MaxHP{lparam2},
        longint(user){hiter}, '', 200);
    end;
  end;
  //   end;
  //   list.Free;

end;

function TMagicManager.MagWindCut(user: TCreature; skilllevel: integer): boolean;
var
  i:      integer;
  rlist:  TList;
  cret:   TCreature;
  pwr:    integer;
  isnear: boolean;
  xx, yy: integer;
  f1x, f1y, f2x, f2y: integer;
  CriticalDamage: boolean;
  DcRandom: integer;
begin
  Result := False;
  pwr    := 0;
  isnear := False;
  rlist  := TList.Create;

  // ������ �ܽ��� �Ǵ� ��ǥ ����
  xx  := user.CX;
  yy  := user.CY;
  f1x := xx;
  f1y := yy;
  f2x := xx;
  f2y := yy;

  case user.dir of
    0: begin
      // ���ϰ� Ÿ���� ���� ��ǥ ����
      f1x := xx;
      f1y := yy - 1;
      f2x := xx;
      f2y := yy - 2;

      //�߾���ǥ ����
      yy := yy - 2;

      user.GetMapCreatures(user.PEnvir, xx, yy, 1, rlist);
    end;
    1: begin

      // ���ϰ� Ÿ���� ���� ��ǥ ����
      f1x := xx + 1;
      f1y := yy - 1;
      f2x := xx + 2;
      f2y := yy - 2;

      //�߾���ǥ ����
      //            xx := xx + 1;
      //            yy := yy - 1;
      xx := xx + 2;
      yy := yy - 2;

      user.GetObliqueMapCreatures(user.PEnvir, xx, yy, 1, user.dir, rlist);
    end;
    2: begin
      // ���ϰ� Ÿ���� ���� ��ǥ ����
      f1x := xx + 1;
      f1y := yy;
      f2x := xx + 2;
      f2y := yy;

      //�߾���ǥ ����
      xx := xx + 2;

      user.GetMapCreatures(user.PEnvir, xx, yy, 1, rlist);
    end;
    3: begin
      // ���ϰ� Ÿ���� ���� ��ǥ ����
      f1x := xx + 1;
      f1y := yy + 1;
      f2x := xx + 2;
      f2y := yy + 2;

      //�߾���ǥ ����
      //            xx := xx + 1;
      //            yy := yy + 1;
      xx := xx + 2;
      yy := yy + 2;

      user.GetObliqueMapCreatures(user.PEnvir, xx, yy, 1, user.dir, rlist);
    end;
    4: begin
      // ���ϰ� Ÿ���� ���� ��ǥ ����
      f1x := xx;
      f1y := yy + 1;
      f2x := xx;
      f2y := yy + 2;

      //�߾���ǥ ����
      yy := yy + 2;

      user.GetMapCreatures(user.PEnvir, xx, yy, 1, rlist);
    end;
    5: begin
      // ���ϰ� Ÿ���� ���� ��ǥ ����
      f1x := xx - 1;
      f1y := yy + 1;
      f2x := xx - 2;
      f2y := yy + 2;

      //�߾���ǥ ����
      //            xx := xx - 1;
      //            yy := yy + 1;
      xx := xx - 2;
      yy := yy + 2;

      user.GetObliqueMapCreatures(user.PEnvir, xx, yy, 1, user.dir, rlist);
    end;
    6: begin
      // ���ϰ� Ÿ���� ���� ��ǥ ����
      f1x := xx - 1;
      f1y := yy;
      f2x := xx - 2;
      f2y := yy;

      //�߾���ǥ ����
      xx := xx - 2;

      user.GetMapCreatures(user.PEnvir, xx, yy, 1, rlist);
    end;
    7: begin
      // ���ϰ� Ÿ���� ���� ��ǥ ����
      f1x := xx - 1;
      f1y := yy - 1;
      f2x := xx - 2;
      f2y := yy - 2;

      //�߾���ǥ ����
      //            xx := xx - 1;
      //            yy := yy - 1;
      xx := xx - 2;
      yy := yy - 2;

      user.GetObliqueMapCreatures(user.PEnvir, xx, yy, 1, user.dir, rlist);
    end;
  end;

  // ����� ���ϰ� �Ѵ�����
  //   user.HitMotion( RM_HIT, user.Dir, user.CX, user.CY);
  //   user.SendRefMsg( RM_WINDCUT , user.Dir , user.CX , user.CY , 0, '');

  //��� ���ġ�� ũ��Ƽ�� Ȯ�� ����
  CriticalDamage := False;
  if Random(100) <= (1 + user.UseItems[U_WEAPON].Desc[3] -
    user.UseItems[U_WEAPON].Desc[4]) then
    CriticalDamage := True;

  for i := 0 to rlist.Count - 1 do begin
    cret := TCreature(rlist[i]);
    if user.IsProperTarget(cret) and (not cret.Death) and (not cret.BoGhost) then
    begin

      // Ÿ���� ���ϰ� ���ߵ� �Ѱ� ���ϰ� ���ߵ� �� �Ǵ�.
      if ((cret.CX = f1x) and (cret.CY = f1y)) or
        ((cret.CX = f2x) and (cret.CY = f2y)) then begin
        isnear := True;
      end else begin
        isnear := False;
      end;

      //ũ��Ƽ�� ������
      if CriticalDamage then begin
        DcRandom := HIBYTE(user.Wabil.DC);
      end else begin
        DcRandom := Random(HIBYTE(user.Wabil.DC));
      end;

      //���� 1*2�� ����:
      //((1.2+0.3*(Lv_S+(LV/20)) * Random(Dcmax)/3+DC
      //�� �� ����: ((0.8+0.2*(Lv_S+LV/20)) * Random(Dcmax)/3+DC
      //Ÿ��ġ�� �ٸ��� �����
      if isnear then begin
        pwr := ((12 + 3 * (SkillLevel + user.Abil.Level div 20))) *
          DcRandom div 30 + LOBYTE(user.Wabil.DC);
      end else begin
        pwr := ((8 + 2 * (SkillLevel + user.Abil.Level div 20))) *
          DcRandom div 30 + LOBYTE(user.Wabil.DC);
      end;

      //ũ��Ƽ�� ������
      if CriticalDamage then begin
        pwr := pwr * 2;
      end;

      if pwr > 0 then begin
        //�׽�Ʈ��
{
            if isnear then
               cret.MakePoison( POISON_STONE , 2 ,1 )
            else
               cret.MakePoison( POISON_SLOW , 2 ,1 );
}
        windcuthit(user, cret, pwr, 0);
        Result := True;
      end;
    end;
  end;
  rlist.Free;

end;

//���°�
function TMagicManager.MagPullMon(user, target: TCreature;
  skilllevel: integer): boolean;
var
  levelgap, rush, rushdir, rushDist, Dur: integer;
  SuccessFlag: boolean;
begin
  Result      := False;
  SuccessFlag := False;
  if user = nil then
    exit;

  if target <> nil then begin
    //������� �� �� ����.
    if target.RaceServer = RC_USERHUMAN then
      exit;

    //�������� �ʴ� ���ʹ� ����� �� ����(2004/12/01)
    if target.StickMode then
      exit;

    // �ʹ� ������ ������ ����� �� �� ����.
    if (abs(user.CX - target.CX) < 3) and (abs(user.CY - target.CY) < 3) then begin
      user.SysMsg('Target is too close.', 0);
      exit;
    end else if (abs(user.CX - target.CX) > 7) and (abs(user.CY - target.CY) > 7) then
    begin
      //         user.SysMsg('��밡 �ʹ� �ָ� �ֽ��ϴ�.', 0);
      exit;
    end;

    // �ָ��ִ� ���� �������.
    user.Dir := GetNextDirectionNew(user.CX, user.CY, target.CX, target.CY);
    //      user.SendRefMsg (RM_LIGHTING, user.Dir, user.CX, user.CY, Integer(target), '');

    // ���⺰ ������� �Ÿ� ����
    rushDir := ((user.Dir + 4) mod 8);
    if rushDir in [0, 4] then begin
      rushDist := abs(user.CY - target.CY) - 3;
    end else if rushDir in [2, 6] then begin
      rushDist := abs(user.CX - target.CX) - 3;
    end else begin
      rushDist := _MAX(0, _MIN(abs(user.CX - target.CX) - 2,
        abs(user.CY - target.CY) - 2));
    end;

    if user.IsProperTarget(target) then begin
      // ��ü�� �ƴϰ� �������� �ƴϾ�� ��.
      if (not target.Death) and (target.Master = nil) then begin
        if (target.Abil.Level < user.Abil.Level + 5 + Random(8)) and
          (target.Abil.Level < 60) then begin
          levelgap := user.Abil.Level - target.Abil.Level;
          if target.RaceServer = RC_USERHUMAN then begin
            if (Random(30) < ((skilllevel + 1) * 2) + levelgap + 4) then
              SuccessFlag := True;
          end else if target.RaceServer >= RC_ANIMAL then begin
            if (Random(30) < ((skilllevel + 1) * 3) + levelgap + 9) then
              SuccessFlag := True;
          end;

          if SuccessFlag then begin
            // ������ �ִ³Ѹ� �����.(1ĭ�� �¿�� �ִ� �ѵ� �����)
            if (user.CX = target.CX) or (user.CY = target.CY) or
              (abs(user.CX - target.CX) = abs(user.CY - target.CY)) or
              (user.CX + 1 = target.CX) or (user.CY + 1 = target.CY) or
              (abs(abs(user.CX - target.CX) - abs(user.CY - target.CY)) =
              1) or (user.CX - 1 = target.CX) or (user.CY - 1 = target.CY) then
            begin
              rush := RushDist;
              target.CharDrawingRush(RushDir, rush, False);
              if target.RaceServer <> RC_USERHUMAN then begin
                Dur :=
                  Round((skilllevel + 1) * 1.6) + _MAX(1, 10 - target.SpeedPoint);
              end else begin
                Dur :=
                  Round((skilllevel + 1) * 0.8) + _MAX(1, 10 - target.SpeedPoint);
                if user.RaceServer = RC_USERHUMAN then begin
                  //����� ���� ���..
                  target.AddPkHiter(user);
                end;
              end;
              target.MakePoison(POISON_STONE, Dur, 1);
              target.SendRefMsg(RM_LOOPNORMALEFFECT, integer(target),
                1500, 0, NE_MONCAPTURE, '');
              Result := True;
            end else begin
              //                     user.SysMsg('���� ��� �� ���� ��ġ�� �ֽ��ϴ�.', 0);
            end;
          end;
        end;
      end;
    end;
  end;
end;

function TMagicManager.MagBlindEye(user, target: TCreature; pum: PTUserMagic): boolean;

  function GetRPow(pw: word): byte;
  begin
    if Hibyte(pw) > Lobyte(pw) then begin
      Result := Lobyte(pw) + Random(Hibyte(pw) - Lobyte(pw) + 1);
    end else
      Result := Lobyte(pw);
  end;

  function GetPower(pw: integer): integer;  //���� 0 �ܰ迡���� 1/4�� �Ŀ���
  begin
    Result := Round(pw / (pum.pDef.MaxTrainLevel + 1) * (pum.Level + 1)) +
      (pum.pDef.DefMinPower + Random(pum.pDef.DefMaxPower - pum.pDef.DefMinPower));
  end;

  function GetPower13(pw: integer): integer;  //���� 0 �ܰ迡�� 1/3�� �Ŀ��� ��
  var
    p1, p2: real;
  begin
    p1     := pw / 3;
    p2     := pw - p1;
    Result := Round(p1 + p2 / (pum.pDef.MaxTrainLevel + 1) *
      (pum.Level + 1) + (pum.pDef.DefMinPower +
      Random(pum.pDef.DefMaxPower - pum.pDef.DefMinPower)));
  end;

var
  pwr:      integer;
  levelgap: integer;
  //   flag : Boolean;
begin
  Result := False;
  //   flag := FALSE;
  if user.IsProperTarget(target) then begin
    //���Ϳ��� �ɸ�.
    if target.RaceServer >= RC_ANIMAL then begin
      //��ų������ ���� �������ΰ� ����
      levelgap := user.Abil.Level - target.Abil.Level;
      if (20 - (pum.Level + 1) * 2) <= Random(GetRPow(user.WAbil.SC) +
        (user.Abil.Level div 5) + (levelgap * 2)) then begin
        //(���� ���� < ������ ����+1+Random(3)) and (���淹�� < 55)
        if (target.Abil.Level < user.Abil.Level + 1 + Random(3)) and
          (target.Abil.Level < 55) then begin
          if (target.BoGoodCrazyMode = False) then begin //�ߺ��ؼ� �ɸ��� �ʴ´�.
            //pwr = ���ֽð�
            pwr := GetPower13(10) + Round(GetRPow(user.WAbil.SC) / 3);
            pwr := pwr + Random(20);
            target.TargetCret := nil;
            target.MakeGoodCrazyMode(pwr);
            //                  target.SendRefMsg (RM_LOOPNORMALEFFECT, integer(target), pwr * 1000, 0, NE_BLINDEFFECT, '');
            //                  flag := TRUE;
            //                  user.SysMsg('������ ��ȥ�� ���ǽ��׽��ϴ�.', 1);
          end;
        end;

        Result := True;
      end;
      user.SelectTarget(target);
    end;
  end;

  //   if flag = FALSE then
  //      user.SysMsg('������ ��ȥ�� ���ǽ�Ű�� ���߽��ϴ�.', 0);
end;

function TMagicManager.SpellNow(user: TCreature; pum: PTUserMagic;
  xx, yy: integer; target: TCreature; spell: integer): boolean;

  function GetRPow(pw: word): byte;
  begin
    if Hibyte(pw) > Lobyte(pw) then begin
      Result := Lobyte(pw) + Random(Hibyte(pw) - Lobyte(pw) + 1);
    end else
      Result := Lobyte(pw);
  end;

  function GetPower(pw: integer): integer;  //���� 0 �ܰ迡���� 1/4�� �Ŀ���
  begin
    Result := Round(pw / (pum.pDef.MaxTrainLevel + 1) * (pum.Level + 1)) +
      (pum.pDef.DefMinPower + Random(pum.pDef.DefMaxPower - pum.pDef.DefMinPower));
  end;

  function GetPower13(pw: integer): integer;  //���� 0 �ܰ迡�� 1/3�� �Ŀ��� ��
  var
    p1, p2: real;
  begin
    p1     := pw / 3;
    p2     := pw - p1;
    Result := Round(p1 + p2 / (pum.pDef.MaxTrainLevel + 1) *
      (pum.Level + 1) + (pum.pDef.DefMinPower +
      Random(pum.pDef.DefMaxPower - pum.pDef.DefMinPower)));
  end;

  function CanUseBujuk(user: TCreature; Count: integer): integer;
  var
    pstd: PTStdItem;
  begin
    Result := 0;
    // 2003/03/15 COPARK ������ �κ��丮 Ȯ��
    if (user.UseItems[U_BUJUK].Index > 0) then begin   // U_ARMRINGL->U_BUJUK
      pstd := UserEngine.GetStdItem(user.UseItems[U_BUJUK].Index);
      if pstd <> nil then begin
        if (pstd.StdMode = 25) and (pstd.Shape = 5) then begin  //����
          if Round(user.UseItems[U_BUJUK].Dura / 100) >= (Count - 1) then begin
            Result := 1;
          end;
        end;
      end;
    end;
    if (user.UseItems[U_ARMRINGL].Index > 0) and (Result = 0) then begin
      pstd := UserEngine.GetStdItem(user.UseItems[U_ARMRINGL].Index);
      if pstd <> nil then begin
        if (pstd.StdMode = 25) and (pstd.Shape = 5) then begin  //����
          if Round(user.UseItems[U_ARMRINGL].Dura / 100) >= (Count - 1) then begin
            Result := 2;
          end;
        end;
      end;
    end;
  end;

  procedure UseBujuk(user: TCreature);
  var
    hum:  TUserHuman;
    pstd: PTStdItem;
  begin
    // 2003/03/15 COPARK ������ �κ��丮 Ȯ��
    //�� �� ������ �������.
    if user.UseItems[U_BUJUK].Index > 0 then begin
      if user.UseItems[U_BUJUK].Dura < 100 then begin    // U_ARMRINGL->U_BUJUK
        user.UseItems[U_BUJUK].Dura := 0;
        //�� �� ������ �������.
        if user.RaceServer = RC_USERHUMAN then begin
          hum := TUserHuman(user);
          hum.SendDelItem(user.UseItems[U_BUJUK]); //Ŭ���̾�Ʈ�� �������� ����
          hum.SysMsg('Your Amulet has been exhausted.', 0);
          //���� �� ����� �� �޽���(2004/11/15)
        end;
        user.UseItems[U_BUJUK].Index := 0;
      end;
    end;
    if user.UseItems[U_ARMRINGL].Index > 0 then begin
      pstd := UserEngine.GetStdItem(user.UseItems[U_ARMRINGL].Index);
      if pstd <> nil then begin
        if (pstd.StdMode = 25) then begin  //25:����/���ָӴ�
          if user.UseItems[U_ARMRINGL].Dura < 100 then begin
            user.UseItems[U_ARMRINGL].Dura := 0;
            //�� �� ������ �������.
            if user.RaceServer = RC_USERHUMAN then begin
              hum := TUserHuman(user);
              hum.SendDelItem(user.UseItems[U_ARMRINGL]);
              //Ŭ���̾�Ʈ�� �������� ����
              hum.SysMsg('Your Amulet has been exhausted.', 0);
              //���� �� ����� �� �޽���(2004/11/15)
            end;
            user.UseItems[U_ARMRINGL].Index := 0;
          end;
        end;
      end;
    end;
  end;

var
  idx, sx, sy, ndir, pwr, sec, MoC, Dur, Gap, i: integer;
  train, nofire, needfire: boolean;
  bhasitem: integer;
  bujuckcount: integer;
  pstd:     PTStdItem;
  hum:      TUserHuman;
  TempCret, restarget: TCreature;
  PoiList, ResList: TList;
begin
  Result := False;
  if IsSwordSkill(pum.MagicId) then
    exit;

  //���� �غ����� ���� ����
  user.SendRefMsg(RM_SPELL, pum.pDef.Effect, xx, yy, pum.pDef.MagicId, '');
  if target <> nil then
    if target.Death then begin  //Ÿ���� �������.....
      target := nil;
    end;

  train    := False;
  nofire   := False;
  needfire := True;
  pwr      := 0;
  case pum.pDef.MagicId of
    1, //ȭ����
    5: //�ݰ�ȭ����
      if user.MagCanHitTarget(user.CX, user.CY, target) then begin
        if user.IsProperTarget(target) then begin
          if (target.AntiMagic <= Random(50)) and (abs(target.CX - xx) <= 1) and
            (abs(target.CY - yy) <= 1) then begin
            with user do begin
              pwr := GetAttackPower(GetPower(MPow(pum)) +
                Lobyte(WAbil.MC), shortint(Hibyte(WAbil.MC) - Lobyte(WAbil.MC)) +
                1);
              //pwr := GetPower (MPow(pum)) + (Lobyte(WAbil.MC) + Random(Hibyte(WAbil.MC)-Lobyte(WAbil.MC) + 1));
              //Ÿ�� ����, �Ŀ� ȿ����Ÿ��
              //target.SendDelayMsg (user, RM_MAGSTRUCK, 0, pwr, 0, 0, '', 1200 + _MAX(Abs(CX-xx),Abs(CY-yy)) * 50 );
            end;
            //rm-delaymagic���� selecttarget�� ó���Ѵ�.
            user.SendDelayMsg(user, RM_DELAYMAGIC, pwr,
              MakeLong(xx, yy), 2, integer(target), '', 600);
            if (target.RaceServer >= RC_ANIMAL) then
              train := True;
          end else
            target := nil;
        end else
          target := nil;
      end else
        target := nil;
       //2003/03/15 �űԹ��� �߰�
    37,//�����...���� �б� ����
    8: //ȭ��ǳ
    begin
      if MagPushAround(user, pum.Level) > 0 then //������ �о
        train := True;
    end;
    9: //������
    begin
      ndir := GetNextDirection(user.CX, user.CY, xx, yy);
      if GetNextPosition(user.PEnvir, user.CX, user.CY, ndir, 1, sx, sy) then begin
        GetNextPosition(user.PEnvir, user.CX, user.CY, ndir, 5, xx, yy);
        with user do begin
          pwr := GetAttackPower(GetPower(MPow(pum)) + Lobyte(WAbil.MC),
            shortint(Hibyte(WAbil.MC) - Lobyte(WAbil.MC)) + 1);
        end;
        if user.MagPassThroughMagic(sx, sy, xx, yy, ndir, pwr, False) > 0 then
          train := True;
      end;
    end;
    10: //������
    begin
      ndir := GetNextDirection(user.CX, user.CY, xx, yy);
      if GetNextPosition(user.PEnvir, user.CX, user.CY, ndir, 1, sx, sy) then begin
        GetNextPosition(user.PEnvir, user.CX, user.CY, ndir, 8, xx, yy);
        with user do begin
          pwr := GetAttackPower(GetPower(MPow(pum)) + Lobyte(WAbil.MC),
            shortint(Hibyte(WAbil.MC) - Lobyte(WAbil.MC)) + 1);
        end;
        if user.MagPassThroughMagic(sx, sy, xx, yy, ndir, pwr, True) > 0 then
          train := True;
      end;
    end;
        //2003/03/15 �űԹ��� �߰�
    35, //��õȭ
    11: //����
      if user.IsProperTarget(target) then begin
        if target.AntiMagic <= Random(50) then begin
          with user do begin
            pwr := GetAttackPower(GetPower(MPow(pum)) +
              Lobyte(WAbil.MC), shortint(Hibyte(WAbil.MC) - Lobyte(WAbil.MC)) +
              1);
          end;
          //user.SelectTarget (target);
          if pum.pDef.MagicId = 11 then begin
            if target.LifeAttrib = LA_UNDEAD then
              pwr := Round(pwr * 1.5);
          end else begin
            if (target.LifeAttrib <> LA_UNDEAD) and
              (target.RaceServer <> RC_USERHUMAN) then
              pwr := Round(pwr * 1.2);
          end;
          user.SendDelayMsg(user, RM_DELAYMAGIC, pwr, MakeLong(xx, yy),
            2, integer(target), '', 600);
          if (target.RaceServer >= RC_ANIMAL) then
            train := True;
        end else
          target := nil;
      end else
        target := nil;
    20: //��ȥ��
      if user.IsProperTarget(target) then begin
        if MagLightingShock(user, target, xx, yy, pum.Level) then
          train := True;
      end;
    32: //������ȸ
      if user.IsProperTarget(target) then begin
        if MagTurnUndead(user, target, xx, yy, pum.Level) then
          train := True;
      end;
    21: //�ư����
    begin
      user.SendRefMsg(RM_MAGICFIRE, 0, MakeWord(pum.pDef.EffectType,
        pum.pDef.Effect), MakeLong(xx, yy), integer(target), '');
      needfire := False;
      if MagLightingSpaceMove(user, pum.Level) then
        train := True;
    end;
    22: //������
    begin
      if MagMakeFireCross(user, user.GetAttackPower(GetPower(MPow(pum)) +
        Lobyte(user.WAbil.MC), shortint(Hibyte(user.WAbil.MC) -
        Lobyte(user.WAbil.MC)) + 1), GetPower(10) + GetRPow(user.WAbil.MC) div
        2, xx, yy) > 0 then begin
        train := True;
      end;
    end;
    23: //������
    begin
      if MagBigExplosion(user, user.GetAttackPower(GetPower(MPow(pum)) +
        Lobyte(user.WAbil.MC), shortint(Hibyte(user.WAbil.MC) -
        Lobyte(user.WAbil.MC)) + 1), xx, yy, 1) then begin
        train := True;
      end;
    end;
    45: // ȭ��⿰
    begin
      with user do begin
        // Random(0.8+(0.5*(Lv_S+1)))*Mcmax)+(1.2*Lv_S)*Mc
        pwr := (Random(8 + (5 * (pum.level + 1))) * Hibyte(WAbil.MC) +
          (12 * pum.level) * Lobyte(WAbil.MC)) div 10;
      end;

      if MagDragonFire(user, pwr, pum.Level) then
        train := True;
    end;

    33: //����ǳ
    begin
      if MagBigExplosion(user, user.GetAttackPower(GetPower(MPow(pum)) +
        Lobyte(user.WAbil.MC), shortint(Hibyte(user.WAbil.MC) -
        Lobyte(user.WAbil.MC)) + 1), xx, yy, 1) then begin
        train := True;
      end;
    end;
    24: //�ڼ�ȭ
    begin
      if MagElecBlizzard(user, user.GetAttackPower(GetPower(MPow(pum)) +
        Lobyte(user.WAbil.MC), shortint(Hibyte(user.WAbil.MC) -
        Lobyte(user.WAbil.MC)) + 1)) then begin
        train := True;
      end;
    end;
    31: //�ּ��Ǹ�
    begin
      if user.MagBubbleDefenceUp(pum.Level,
        GetPower(15 + GetRPow(user.WAbil.MC))) then
        train := True;
    end;


    2: //ȸ����
    begin
      if target = nil then begin
        target := user;
        xx     := user.CX;
        yy     := user.CY;
      end;
      if user.IsProperFriend(target) then begin
        with user do begin
          pwr := GetAttackPower(GetPower(MPow(pum)) + Lobyte(WAbil.SC) *
            2, shortint(Hibyte(WAbil.SC) - Lobyte(WAbil.SC)) * 2 + 1);
        end;
        if target.WAbil.HP < target.WAbil.MaxHP then begin
          target.SendDelayMsg(user, RM_MAGHEALING, 0, pwr, 0, 0, '', 800);
          train := True;
        end;
        if user.BoAbilSeeHealGauge then begin
          user.SendMsg(target, RM_INSTANCEHEALGUAGE, 0, 0, 0, 0, '');
        end;
      end;
    end;
    29: //��ȸ����
    begin
      with user do begin
        pwr := GetAttackPower(GetPower(MPow(pum)) + Lobyte(WAbil.SC) *
          2, shortint(Hibyte(WAbil.SC) - Lobyte(WAbil.SC)) * 2 + 1);
      end;
      if MagBigHealing(user, pwr, xx, yy) then
        train := True;
    end;
         50: //Rage
          begin
          case pum.Level of
          0: begin
            sec := 18;
            pwr := Round(Hibyte(user.WAbil.DC) * 0.12);
            end;
          1: begin
            sec := 24;
            pwr := Round(Hibyte(user.WAbil.DC) * 0.15);
            end;
          2: begin
            sec := 30;
            pwr := Round(Hibyte(user.WAbil.DC) * 0.18);
            end;
          3: begin
            sec := 36;
            pwr := Round(Hibyte(user.WAbil.DC) * 0.21);
            end;
            end;

            if user.MagDcUp(sec{��}, pwr) then
              train := True;
            //Ÿ���� �ɷ�ġ�� �÷���(sonmg 2005/06/07)
            if (target <> nil) and (target.RaceServer = RC_USERHUMAN) then
            begin
              if target.MagDcUp(sec, pwr) then begin
           //     target.SendRefMsg(RM_LOOPNORMALEFFECT,
           //       integer(target), 0, 0, NE_RAGEEFFECT, '');
                train := True;
              end;
            end;
          end;
          51: //ProtectionField
          begin
            if GetTickCount - user.PFTime > user.PFUseTime then begin
            sec := 2+(pum.Level + 1) + shortint(Hibyte(user.WAbil.AC));
            pwr := (LOBYTE(user.WAbil.AC) div 9) + Random(HIBYTE(user.WAbil.AC) div 9);
            if user.MagDefenceUp(sec, pwr) then begin
            user.PFUseTime := sec;
            user.PFTime := GetTickCount;
              train := True;
          end;    
          end;
          end;
          61: //Assassin Skill 3
          begin
          case pum.Level of
          0: begin
            sec := 10;
            pwr := 3;
            end;
          1: begin
            sec := 15;
            pwr := 3;
            end;
          2: begin
            sec := 30;
            pwr := 3;
            end;
          3: begin
            sec := 50;
            pwr := 3;
            end;
            end;
            if user.MagHitSpeedUp(sec, pwr) then begin
              train := True;
          end;
          end;
          52: //Blizzard
    begin
      if MagBlizzard(user, user.GetAttackPower(GetPower(MPow(pum)) +
        Lobyte(user.WAbil.MC), shortint(Hibyte(user.WAbil.MC) -
        Lobyte(user.WAbil.MC)) + 1), 2500, xx, yy) > 0 then begin
        train := True;
      end;
    end;
          53: //MeteorStrike
    begin
      if MagMeteor(user, user.GetAttackPower(GetPower(MPow(pum)) +
        Lobyte(user.WAbil.MC), shortint(Hibyte(user.WAbil.MC) -
        Lobyte(user.WAbil.MC)) + 1), 2500, xx, yy) > 0 then begin
        train := True;
      end;
    end;

    6: //�Ͽ���
    begin
      nofire   := True;
      bhasitem := 0;
      pstd     := nil;
      if user.IsProperTarget(target) then begin
        //�Ͽ����� �������ָӴϰ� �־�� �Ѵ�.
        // 2003/03/15 COPARK ������ �κ��丮 Ȯ��
        if (user.UseItems[U_BUJUK].Index > 0) then begin
          // U_ARMRINGL->U_BUJUK
          pstd := UserEngine.GetStdItem(user.UseItems[U_BUJUK].Index);
          if pstd <> nil then begin
            if (pstd.StdMode = 25) and (pstd.Shape <= 2) then
            begin  //25:���ָӴ�
              if user.UseItems[U_BUJUK].Dura >= 100 then begin
                user.UseItems[U_BUJUK].Dura :=
                  user.UseItems[U_BUJUK].Dura - 100;
                //������ ������ �˸�
                user.SendMsg(user, RM_DURACHANGE, U_BUJUK,
                  user.UseItems[U_BUJUK].Dura, user.UseItems[U_BUJUK].DuraMax, 0, '');
                bhasItem := 1;
              end;
            end;
          end;
        end;
        if (user.UseItems[U_ARMRINGL].Index > 0) and (bhasitem = 0) then begin
          pstd := UserEngine.GetStdItem(user.UseItems[U_ARMRINGL].Index);
          if pstd <> nil then begin
            if (pstd.StdMode = 25) and (pstd.Shape <= 2) then
            begin  //25:���ָӴ�
              if user.UseItems[U_ARMRINGL].Dura >= 100 then begin
                user.UseItems[U_ARMRINGL].Dura :=
                  user.UseItems[U_ARMRINGL].Dura - 100;
                //������ ������ �˸�
                user.SendMsg(user, RM_DURACHANGE, U_ARMRINGL,
                  user.UseItems[U_ARMRINGL].Dura,
                  user.UseItems[U_ARMRINGL].DuraMax, 0, '');
                bhasItem := 2;
              end;
            end;
          end;
        end;

        if pstd <> nil then begin
          if bhasItem > 0 then begin
            //��ų������ ���� �������ΰ� ����
            if 6 >= Random(7 + target.AntiPoison) then begin
              case pstd.Shape of
                1: //ȸ��������: �ߵ�
                begin
                  //sec = �ߵ��ð�  60�� + ����
                  sec := GetPower13(30) + 2 * GetRPow(user.WAbil.SC);
                  //pwr := pum.Level;
                  pwr :=
                    pum.Level + _MAX(0,
                    _MIN(3, _MAX(0, HIBYTE(user.WAbil.SC) - 30) * 15 div 100));
                  target.SendDelayMsg(user, RM_MAKEPOISON,
                    POISON_DECHEALTH{wparam}, sec, integer(user), pwr, '', 1000);
                end;
                2: //Ȳ��������: ���°���
                begin
                  //�쵶�� �� ��밡 �������� �� ���¿��� ������ �ɸ� �쵶�� �������.(sonmg 2004/12/27)
                  if (target.LastHiter = nil) and
                    (target.StatusArr[POISON_DECHEALTH] > 0) then begin
                    target.StatusArr[POISON_DECHEALTH] := 0;
                  end;
                  //sec = �ߵ��ð� 40�� + ����
                  sec := GetPower13(40) + 2 * GetRPow(user.WAbil.SC);
                  //(Lobyte(user.WAbil.SC) + Random(ShortInt(Hibyte(user.WAbil.SC)-Lobyte(user.WAbil.SC)) + 1));
                  //pwr := 2{pum.Level};
                  pwr := _MAX(2, _MIN(5, HIBYTE(user.WAbil.SC) div 10));
                  target.SendDelayMsg(user, RM_MAKEPOISON,
                    POISON_DAMAGEARMOR{wparam}, sec, integer(user), pwr, '', 1000);
                end;
              end;

              //���,���Ϳ��� �ɾ����� ���õȴ�.
              if (target.RaceServer = RC_USERHUMAN) or
                (target.RaceServer >= RC_ANIMAL) then
                train := True;
            end;
            user.SelectTarget(target);
            nofire := False;
          end;
        end;
        //�� �� ���� �������.
        if bhasitem = 1 then begin
          if user.UseItems[U_BUJUK].Dura < 100 then begin
            user.UseItems[U_BUJUK].Dura := 0;
            //�� ������ �������.
            if user.RaceServer = RC_USERHUMAN then begin
              hum := TUserHuman(user);
              hum.SendDelItem(user.UseItems[U_BUJUK]);
              //Ŭ���̾�Ʈ�� �������� ����
              hum.SysMsg('The Poison item has been exhausted.', 0);
              //������ �� ����� �� �޽���(2004/11/15)
            end;
            user.UseItems[U_BUJUK].Index := 0;
          end;
        end;
        if (user.UseItems[U_ARMRINGL].Index > 0) and (bhasitem = 2) then begin
          pstd := UserEngine.GetStdItem(user.UseItems[U_ARMRINGL].Index);
          if pstd <> nil then begin
            if (pstd.StdMode = 25) then begin  //25:���ָӴ�
              if user.UseItems[U_ARMRINGL].Dura < 100 then begin
                user.UseItems[U_ARMRINGL].Dura := 0;
                //�� ������ �������.
                if user.RaceServer = RC_USERHUMAN then begin
                  hum := TUserHuman(user);
                  hum.SendDelItem(user.UseItems[U_ARMRINGL]);
                  //Ŭ���̾�Ʈ�� �������� ����
                  hum.SysMsg('The Poison item has been exhausted.', 0);
                  //������ �� ����� �� �޽���(2004/11/15)
                end;
                user.UseItems[U_ARMRINGL].Index := 0;
              end;
            end;
          end;
        end;
      end;
    end;

    54: //Reincarnation
    begin
      needfire := False;
      bhasitem := 0;
      pstd     := nil;
      Reslist := TList.Create;
      user.GetMapCreatures(user.PEnvir, xx, yy, 1, Reslist);
      if Reslist.Count = 0 then begin
      user.SendRefMsg(RM_MAGICFIRE, 0, MakeWord(pum.pDef.EffectType,
      pum.pDef.Effect), MakeLong(xx, yy), 0, '');
      user.RevivalMode := False;
      end else begin
      for i := 0 to Reslist.Count - 1 do begin
      target := TCreature(Reslist[i]);
      if not target.Death then begin
      user.SendRefMsg(RM_MAGICFIRE, 0, MakeWord(pum.pDef.EffectType,
      pum.pDef.Effect), MakeLong(xx, yy), 0, '');
      user.RevivalMode := False;
      end else begin
      if user.RevivalMode = False then begin
      user.SendDelayMsg(user, RM_LOOPNORMALEFFECT, integer(user),
      0, 0, NE_REVIVALCHARGE, '', 0);// 1000);
      UserEngine.CryCry(RM_CRY, user.PEnvir, xx, yy, 10000, user.UserName + ' is attempting to revive ' + target.UserName);
      user.RevivalTarget := target;
      user.RevivalMode := True;
      user.SendRefMsg(RM_MAGICFIRE, 0, MakeWord(pum.pDef.EffectType,
      pum.pDef.Effect), MakeLong(xx, yy), integer(target), '');
      end else begin
      if target <> user.RevivalTarget then begin
      user.RevivalMode := False;
      user.SendRefMsg(RM_MAGICFIRE, 0, MakeWord(pum.pDef.EffectType,
      pum.pDef.Effect), MakeLong(xx, yy), 0, '');
      end else begin
      user.RevivalMode := False;
      user.SendRefMsg(RM_MAGICFIRE, 0, MakeWord(pum.pDef.EffectType,
      pum.pDef.Effect), MakeLong(xx, yy), integer(target), '');
        if (user.UseItems[U_BUJUK].Index > 0) then begin
          // U_ARMRINGL->U_BUJUK
          pstd := UserEngine.GetStdItem(user.UseItems[U_BUJUK].Index);
          if pstd <> nil then begin
            if (pstd.StdMode = 25) and (pstd.Shape = 7) then
            begin  //25:���ָӴ�
              if user.UseItems[U_BUJUK].Dura >= 100 then begin
                user.UseItems[U_BUJUK].Dura :=
                  user.UseItems[U_BUJUK].Dura - 100;
                //������ ������ �˸�
                user.SendMsg(user, RM_DURACHANGE, U_BUJUK,
                  user.UseItems[U_BUJUK].Dura, user.UseItems[U_BUJUK].DuraMax, 0, '');
                bhasItem := 1;
              end;
            end;
          end;
        end;
        if (user.UseItems[U_ARMRINGL].Index > 0) and (bhasitem = 0) then begin
          pstd := UserEngine.GetStdItem(user.UseItems[U_ARMRINGL].Index);
          if pstd <> nil then begin
            if (pstd.StdMode = 25) and (pstd.Shape = 7) then
            begin  //25:���ָӴ�
              if user.UseItems[U_ARMRINGL].Dura >= 100 then begin
                user.UseItems[U_ARMRINGL].Dura :=
                  user.UseItems[U_ARMRINGL].Dura - 100;
                //������ ������ �˸�
                user.SendMsg(user, RM_DURACHANGE, U_ARMRINGL,
                  user.UseItems[U_ARMRINGL].Dura,
                  user.UseItems[U_ARMRINGL].DuraMax, 0, '');
                bhasItem := 2;
              end;
            end;
          end;
        end;
        end;
        end;
        end;
        end;
        end;

        if pstd <> nil then begin
          if bhasItem > 0 then begin
            //��ų������ ���� �������ΰ� ����
              case pstd.Shape of
                7: //ȸ��������: �ߵ�
                begin
                          case pum.Level of
          0: begin
                target.WAbil.HP := Round(target.WAbil.MaxHP * 0.25);
                target.Abil.HP := Round(target.Abil.MaxHP * 0.25);
            end;
          1: begin
                target.WAbil.HP := Round(target.WAbil.MaxHP * 0.5);
                target.Abil.HP := Round(target.Abil.MaxHP * 0.5);
            end;
          2: begin
                target.WAbil.HP := Round(target.WAbil.MaxHP * 0.75);
                target.Abil.HP := Round(target.Abil.MaxHP * 0.75);
            end;
          3: begin
                target.WAbil.HP := target.WAbil.MaxHP;
                target.Abil.HP := target.Abil.MaxHP;
            end;
            end;
                target.Alive;
                end;
                end;

              //���,���Ϳ��� �ɾ����� ���õȴ�.
              if (target.RaceServer = RC_USERHUMAN) or
                (target.RaceServer >= RC_ANIMAL) then
                train := True;
            end;
            user.SelectTarget(target);
          end;
        //�� �� ���� �������.
        if bhasitem = 1 then begin
          if user.UseItems[U_BUJUK].Dura < 100 then begin
            user.UseItems[U_BUJUK].Dura := 0;
            //�� ������ �������.
            if user.RaceServer = RC_USERHUMAN then begin
              hum := TUserHuman(user);
              hum.SendDelItem(user.UseItems[U_BUJUK]);
              //Ŭ���̾�Ʈ�� �������� ����
              hum.SysMsg('The Amulet has been exhausted.', 0);
              //������ �� ����� �� �޽���(2004/11/15)
            end;
            user.UseItems[U_BUJUK].Index := 0;
          end;
        end;
        if (user.UseItems[U_ARMRINGL].Index > 0) and (bhasitem = 2) then begin
          pstd := UserEngine.GetStdItem(user.UseItems[U_ARMRINGL].Index);
          if pstd <> nil then begin
            if (pstd.StdMode = 25) then begin  //25:���ָӴ�
              if user.UseItems[U_ARMRINGL].Dura < 100 then begin
                user.UseItems[U_ARMRINGL].Dura := 0;
                //�� ������ �������.
                if user.RaceServer = RC_USERHUMAN then begin
                  hum := TUserHuman(user);
                  hum.SendDelItem(user.UseItems[U_ARMRINGL]);
                  //Ŭ���̾�Ʈ�� �������� ����
                  hum.SysMsg('The Amulet has been exhausted.', 0);
                  //������ �� ����� �� �޽���(2004/11/15)
                end;
                user.UseItems[U_ARMRINGL].Index := 0;
              end;
            end;
          end;
          end;
          end;

    55: //PoisonCloud
    begin
      nofire   := False;
      bhasitem := 0;
      pstd     := nil;
      Poilist := TList.Create;
      user.GetMapCreatures(user.PEnvir, xx, yy, 3, Poilist);
      For i := 0 to Poilist.Count - 1 do begin
      target := TCreature(Poilist[i]);
      if user.IsProperTarget(target) or (target = nil) then begin
        //�Ͽ����� �������ָӴϰ� �־�� �Ѵ�.
        // 2003/03/15 COPARK ������ �κ��丮 Ȯ��
        if (user.UseItems[U_BUJUK].Index > 0) then begin
          // U_ARMRINGL->U_BUJUK
          pstd := UserEngine.GetStdItem(user.UseItems[U_BUJUK].Index);
          if pstd <> nil then begin
            if (pstd.StdMode = 25) and (pstd.Shape <= 2) then
            begin  //25:���ָӴ�
              if user.UseItems[U_BUJUK].Dura >= 500 then begin
                user.UseItems[U_BUJUK].Dura :=
                  user.UseItems[U_BUJUK].Dura - 500;
                //������ ������ �˸�
                user.SendMsg(user, RM_DURACHANGE, U_BUJUK,
                  user.UseItems[U_BUJUK].Dura, user.UseItems[U_BUJUK].DuraMax, 0, '');
                bhasItem := 1;
              end;
            end;
          end;
        end;
        if (user.UseItems[U_ARMRINGL].Index > 0) and (bhasitem = 0) then begin
          pstd := UserEngine.GetStdItem(user.UseItems[U_ARMRINGL].Index);
          if pstd <> nil then begin
            if (pstd.StdMode = 25) and (pstd.Shape <= 2) then
            begin  //25:���ָӴ�
              if user.UseItems[U_ARMRINGL].Dura >= 500 then begin
                user.UseItems[U_ARMRINGL].Dura :=
                  user.UseItems[U_ARMRINGL].Dura - 500;
                //������ ������ �˸�
                user.SendMsg(user, RM_DURACHANGE, U_ARMRINGL,
                  user.UseItems[U_ARMRINGL].Dura,
                  user.UseItems[U_ARMRINGL].DuraMax, 0, '');
                bhasItem := 2;
              end;
            end;
          end;
        end;

        if pstd <> nil then begin
          if bhasItem > 0 then begin
            //��ų������ ���� �������ΰ� ����
            if 6 >= Random(7 + target.AntiPoison) then begin
              case pstd.Shape of
                1: //ȸ��������: �ߵ�
                begin
    sec := GetPower13(40) + 2 * GetRPow(user.WAbil.SC);
    pwr := _MAX(2, _MIN(5, HIBYTE(user.WAbil.SC) div 10));
    target.SendDelayMsg(user, RM_MAKEPOISON,
    POISON_DECHEALTH{wparam}, sec, integer(user), pwr, '', 1000);
                end;
                2: //Ȳ��������: ���°���
                begin
                end;
              end;

              //���,���Ϳ��� �ɾ����� ���õȴ�.
              if (target.RaceServer = RC_USERHUMAN) or
                (target.RaceServer >= RC_ANIMAL) then
                train := True;
            end;
          //  User.SelectTarget(nil);
          //  target := nil;
          end;
        end;
        //�� �� ���� �������.
        if bhasitem = 1 then begin
          if user.UseItems[U_BUJUK].Dura < 500 then begin
            user.UseItems[U_BUJUK].Dura := 0;
            //�� ������ �������.
            if user.RaceServer = RC_USERHUMAN then begin
              hum := TUserHuman(user);
              hum.SendDelItem(user.UseItems[U_BUJUK]);
              //Ŭ���̾�Ʈ�� �������� ����
              hum.SysMsg('The Poison item has been exhausted.', 0);
              //������ �� ����� �� �޽���(2004/11/15)
            end;
            user.UseItems[U_BUJUK].Index := 0;
          end;
        end;
        if (user.UseItems[U_ARMRINGL].Index > 0) and (bhasitem = 2) then begin
          pstd := UserEngine.GetStdItem(user.UseItems[U_ARMRINGL].Index);
          if pstd <> nil then begin
            if (pstd.StdMode = 25) then begin  //25:���ָӴ�
              if user.UseItems[U_ARMRINGL].Dura < 500 then begin
                user.UseItems[U_ARMRINGL].Dura := 0;
                //�� ������ �������.
                if user.RaceServer = RC_USERHUMAN then begin
                  hum := TUserHuman(user);
                  hum.SendDelItem(user.UseItems[U_ARMRINGL]);
                  //Ŭ���̾�Ʈ�� �������� ����
                  hum.SysMsg('The Poison item has been exhausted.', 0);
                  //������ �� ����� �� �޽���(2004/11/15)
                end;
                user.UseItems[U_ARMRINGL].Index := 0;
              end;
            end;
          end;
          end;
          end;
      end;
    end;
        //2003/03/15 �űԹ��� �߰�
    36, //��������
    13, //�����(����)
    14, //�׸�����
    15, //������ȣ
    16, //���
    17, //����ȯ��
    18, //���ż�
    19, //�����ż�
    41, //õ���ȯ(��ȥ��ȯ-����)
    46, //���ּ�
    49: //�;ȼ�(��ȥ��)
    begin
      nofire      := True;
      bujuckCount := 1;
      try
        // õ���ȯ(��ȥ��ȯ-����)�ϰ�쿡�� 5�� �Һ�
        case pum.pDef.MagicId of
          41: begin
            TempCret := user.GetExistSlave(__AngelMob);
            if TempCret <> nil then begin
              TempCret.forcemovetomaster := True;
              exit;
            end;
            bujuckCount := 5;
          end;
          17: begin
            TempCret := user.GetExistSlave(__WhiteSkeleton);
            if TempCret <> nil then begin
              TempCret.forcemovetomaster := True;
              exit;
            end;
            bujuckCount := 1;
          end;
          else
            bujuckcount := 1;
        end;

      except
        MainOutMessage('EXCEPTION BUJUCK CALC');
      end;


      bhasItem := 0;
      if bujuckcount > 0 then
        bhasItem := CanUseBujuk(user, bujuckcount);

      if bhasItem > 0 then begin
        if bhasitem = 1 then begin
          // 2003/03/15 COPARK ������ �κ��丮 Ȯ��
          if user.UseItems[U_BUJUK].Dura >= (bujuckcount * 100) then
            // U_ARMRINGL->U_BUJUK
            user.UseItems[U_BUJUK].Dura :=
              user.UseItems[U_BUJUK].Dura - (bujuckcount * 100)
          else
            user.UseItems[U_BUJUK].Dura := 0;
          user.SendMsg(user, RM_DURACHANGE, U_BUJUK,
            user.UseItems[U_BUJUK].Dura, user.UseItems[U_BUJUK].DuraMax, 0, '');
        end;
        if bhasitem = 2 then begin
          if user.UseItems[U_ARMRINGL].Dura >= (bujuckcount * 100) then
            user.UseItems[U_ARMRINGL].Dura :=
              user.UseItems[U_ARMRINGL].Dura - (bujuckcount * 100)
          else
            user.UseItems[U_ARMRINGL].Dura := 0;
          user.SendMsg(user, RM_DURACHANGE, U_ARMRINGL,
            user.UseItems[U_ARMRINGL].Dura, user.UseItems[U_ARMRINGL].DuraMax, 0, '');
        end;

        case pum.pDef.MagicId of
          13:  //�����
            if user.MagCanHitTarget(user.CX, user.CY, target) then begin
              if user.IsProperTarget(target) then begin
                if (target.AntiMagic <= Random(50)) and
                  (abs(target.CX - xx) <= 1) and (abs(target.CY - yy) <= 1) then begin
                  with user do begin //�Ŀ�
                    pwr :=
                      GetAttackPower(GetPower(MPow(pum)) +
                      Lobyte(WAbil.SC), shortint(
                      Hibyte(WAbil.SC) - Lobyte(WAbil.SC)) + 1);
                    //Ÿ�� ����, �Ŀ� ȿ����Ÿ��
                    //target.SendDelayMsg (user, RM_MAGSTRUCK, 0, pwr, 0, 0, '', 1200 + _MAX(Abs(CX-xx),Abs(CY-yy)) * 50 );
                  end;
                  //user.SelectTarget (target);
                  user.SendDelayMsg(user, RM_DELAYMAGIC,
                    pwr, MakeLong(xx, yy), 2, integer(target), '', 1200);
                  if (target.RaceServer >= RC_ANIMAL) then
                    train := True;
                end;
              end;
            end else
              target := nil;
          14: //�׸�����
          begin
            pwr :=
              user.GetAttackPower(GetPower13(60) + 5 *
              Lobyte(user.WAbil.SC), 5 *
              (shortint(Hibyte(user.WAbil.SC) - Lobyte(user.WAbil.SC)) + 1));
            if user.MagMakeDefenceArea(xx, yy, 3, pwr{��}, True) > 0 then
              train := True;
          end;
          46: //���ּ�
          begin

            sec :=
              (((pum.level + 1) * 24) + Hibyte(user.WAbil.SC) + user.Abil.Level) div 2;

            case pum.Level of
              0: pwr := 93;
              1: pwr := 88;
              2: pwr := 82;
              3: pwr := 75;
            end;

            if user.MagMakeCurseArea(xx, yy, 2, sec, pwr, pum.level,
              True) > 0 then
              train := True;

          end;
              //2003/03/15 �űԹ��� �߰�
          36: //UltimaEnhancer
          begin
            sec :=
              user.GetAttackPower(GetPower13(60) + 5 *
              Lobyte(user.WAbil.SC), 5 *
              (shortint(Hibyte(user.WAbil.SC) - Lobyte(user.WAbil.SC)) + 1));
            //�����Ǵ� �ı���
            pwr := ((Hibyte(user.WAbil.SC) - 1) div 5) + 1;
            if (pwr > 8) then
              pwr := 8;

            if user.MagDcUp(sec{��}, pwr) then
              train := True;
            //Ÿ���� �ɷ�ġ�� �÷���(sonmg 2005/06/07)
            if (target <> nil) and (target.RaceServer = RC_USERHUMAN) then
            begin
              if target.MagDcUp(sec{��}, pwr) then begin
                target.SendRefMsg(RM_LOOPNORMALEFFECT,
                  integer(target), 0, 0, NE_BIGFORCE, '');
                train := True;
              end;
            end;
          end;
          15: //������ȣ
          begin
            pwr :=
              user.GetAttackPower(GetPower13(60) + 5 *
              Lobyte(user.WAbil.SC), 5 *
              (shortint(Hibyte(user.WAbil.SC) - Lobyte(user.WAbil.SC)) + 1));
            if user.MagMakeDefenceArea(xx, yy, 3, pwr{��}, False) > 0 then
              train := True;
          end;
          16: //���
          begin
            if MagMakeHolyCurtain(user, GetPower13(40) + 3 *
              GetRPow(user.WAbil.SC), //Lobyte(user.WAbil.SC),
              xx, yy) > 0 then begin
              train := True;
            end;
          end;
          17: //����ȯ��
          begin
            try
              TempCret := user.GetExistSlave(__WhiteSkeleton);
              if TempCret = nil then begin
                if (user.GetExistSlave(__Shinsu) = nil) and
                  (user.GetExistSlave(__Shinsu1) = nil) then
                  if user.MakeSlave(__WhiteSkeleton, pum.Level,
                    1, 10 * 24 * 60 * 60) <> nil then
                    train := True;
              end;
            except
              MainOutMessage('EXCEPT WHITE SKELETON');
            end;
          end;
          18: //����
          begin
            if MagMakePrivateTransparent(user, GetPower13(30) +
              3 * GetRPow(user.WAbil.SC)) then begin
              train := True;
            end;
          end;
          19: //������
          begin
            if MagMakeGroupTransparent(user, xx, yy, GetPower13(30) +
              3 * GetRPow(user.WAbil.SC)) then begin
              train := True;
            end;
          end;
          41: //õ���ȯ��(��ȥ��ȯ��)
          begin
            try
              TempCret := user.GetExistSlave(__AngelMob);
              if TempCret = nil then begin
                //õ��(����)�� ����.
                if user.MakeSlave(__AngelMob, pum.Level, 1,
                  10 * 24 * 60 * 60) <> nil then
                  train := True;
              end;
            except
              MainOutMessage('EXCEPT ALGEL ');
            end;
          end;
          49: //�;ȼ�(��ȥ��)
          begin
            if MagBlindEye(user, target, pum) then begin
              train := True;
            end;
          end;
        end;

        nofire := False;
        UseBujuk(user);
      end;
    end;
    30: //�ż���ȯ
    begin
      nofire := True;
      try

        TempCret := user.GetExistSlave(__ShinSu);
        if TempCret = nil then
          TempCret := user.GetExistSlave(__ShinSu1);

        if TempCret <> nil then begin
          TempCret.forcemovetomaster := True;
          exit;
        end;


        bhasItem := CanUseBujuk(user, 5);
        if bhasItem > 0 then begin
          if bhasitem = 1 then begin
            // 2003/03/15 COPARK ������ �κ��丮 Ȯ��
            if user.UseItems[U_BUJUK].Dura >= 500 then      // U_ARMRINGL->U_BUJUK
              user.UseItems[U_BUJUK].Dura := user.UseItems[U_BUJUK].Dura - 500
            else
              user.UseItems[U_BUJUK].Dura := 0;
            //������ ������ �˸�
            user.SendMsg(user, RM_DURACHANGE, U_BUJUK,
              user.UseItems[U_BUJUK].Dura, user.UseItems[U_BUJUK].DuraMax, 0, '');
          end;
          if bhasitem = 2 then begin
            if user.UseItems[U_ARMRINGL].Dura >= 500 then
              user.UseItems[U_ARMRINGL].Dura :=
                user.UseItems[U_ARMRINGL].Dura - 500
            else
              user.UseItems[U_ARMRINGL].Dura := 0;
            user.SendMsg(user, RM_DURACHANGE, U_ARMRINGL,
              user.UseItems[U_ARMRINGL].Dura, user.UseItems[U_ARMRINGL].DuraMax, 0, '');
          end;
          case pum.pDef.MagicId of
            30: //�ż���ȯ
            begin
              if (user.GetExistSlave(__WhiteSkeleton) = nil) then
                if user.MakeSlave(__ShinSu, pum.Level, 1, 10 *
                  24 * 60 * 60) <> nil then
                  train := True;
            end;
          end;
          nofire := False;
          UseBujuk(user);  // ���� ����(2004/09/01 sonmg)
        end;

      except
        MainOutMessage('EXCEPT SHINSU');
      end;

    end;
    42: //�нż�ȯ
    begin
      try
        TempCret := user.GetExistSlave(__CloneMob);
        if TempCret <> nil then begin
          // �н��ѳ��� �ִ�.
          TempCret.BoDisapear := True;
          // MP �ٽ� ��������
          user.Wabil.MP := user.WAbil.MP + Spell;
        end else // �н��ѳ��� ����.
        begin

          TempCret := user.MakeSlave(__CloneMob, pum.Level, 5, 10 * 24 * 60 * 60);
          if TempCret <> nil then begin
            user.SendRefMsg(RM_NORMALEFFECT, 0, TempCret.CX,
              TempCret.CY, NE_CLONESHOW, '');
            train := True;
          end;

        end;

      except
        MainOutMessage('EXCET CLONE');
      end;

    end;

    28:  //Ž���Ŀ�
    begin
      if target <> nil then begin
        if not target.BoOpenHealth then begin
          if Random(6) <= 3 + pum.Level then begin
            target.OpenHealthStart := GetTickCount;
            target.OpenHealthTime  :=
              GetPower13(30 + GetRPow(user.WAbil.SC) * 2) * 1000;
            target.SendDelayMsg(target, RM_DOOPENHEALTH, 0, 0, 0, 0, '', 1500);
            train := True;
          end;
        end;
      end;
    end;
    // 2003/07/15 �űԹ���
    39:   // �����
      if user.MagCanHitTarget(user.CX, user.CY, target) then begin
        if user.IsProperTarget(target) then begin
          if (target.AntiMagic <= Random(50)) and (abs(target.CX - xx) <= 1) and
            (abs(target.CY - yy) <= 1) then begin
            with user do begin
              //����� ���� ����(sonmg 2004/10/20)
              //                     Dur := (Round (0.4+pum.Level*0.2) * (Lobyte(WAbil.MC) + Hibyte(WAbil.MC)));
              Dur := (Round(0.4 + pum.Level * 0.2) *
                (Lobyte(WAbil.MC) + Random(Hibyte(WAbil.MC)) +
                (Hibyte(WAbil.MC) div 2)));
              pwr := pum.pDef.MinPower + Dur;
            end;
            user.SendDelayMsg(user, RM_DELAYMAGIC, pwr,
              MakeLong(xx, yy), 2, integer(target), '', 600);
            // �����̻�...��ȭ����
            if (target.Abil.Level < 60) and
              (target.StatusArr[POISON_SLOW] = 0) and
              (target.StatusArr[POISON_ICE] = 0) and
              (Random(50) > target.AntiMagic) then begin    // 100->50
              MoC := 1;
              Gap := target.Abil.Level - user.Abil.Level;
              if Gap > 10 then
                Gap := 10;
              if Gap < -10 then
                Gap := -10;
              if target.RaceServer = RC_USERHUMAN then
                MoC := 2;
              if Random(100) < (20 + (pum.Level - Gap) div Moc) then begin
                Dur := (900 * pum.Level + 3300) div 1000;
                if (MoC = 1) and (Random(10) = 0) then
                  target.MakePoison(POISON_ICE, Dur, 1)
                else if (MoC = 2) and (Random(100) = 0) then
                  target.MakePoison(POISON_ICE, Dur, 1)
                else
                  target.MakePoison(POISON_SLOW, Dur + 1, 1);
              end;
            end;
            if (target.RaceServer >= RC_ANIMAL) then
              train := True;
          end else
            target := nil;
        end else
          target := nil;
      end else
        target := nil;
    40:   // ��ȭ��
    begin
      if MagMakePrivateClean(user, xx, yy, pum.Level * 15 + 45) then begin
        train := True;
      end;
    end;
    43: // ������
    begin
      try
        //             nofire := true;   //sonmg(2004/05/19)
        user._Attack(HM_STONEHIT, nil);
      except
        MainOutMessage('EXCEPTION STONEHIT');
      end;
      train := False;
    end;
    44: // ���ļ�
    begin
      if MagWindCut(user, pum.Level) then begin
        train := True;
      end;
    end;
    47: // ���°�
    begin
      if MagPullMon(user, target, pum.Level) then begin
        train := True;
      end;
    end;
    48: // ������
      if user.IsProperTarget(target) then begin
        if target.AntiMagic <= Random(50) then begin
          with user do begin
            pwr := GetAttackPower(GetPower(MPow(pum)) +
              Lobyte(WAbil.MC), shortint(Hibyte(WAbil.MC) - Lobyte(WAbil.MC)) +
              1);
          end;
          //user.SelectTarget (target);
          if (target.LifeAttrib <> LA_UNDEAD) and
            (target.RaceServer <> RC_USERHUMAN) then
            pwr := Round(pwr * 1.2);
          user.SendDelayMsg(user, RM_DELAYMAGIC, pwr, MakeLong(xx, yy),
            2, integer(target), '', 0);
          if (target.RaceServer >= RC_ANIMAL) then begin
            //������ ����� ��� ������� HP��.
            user.IncHealth := (pwr * (pum.Level + 1) * 10 + Random(20)) div 100;
            train := True;
          end else begin
            //������� ����� ��� ������� HP��.
            user.IncHealth :=
              ((pwr * (pum.Level + 1) * 10 + Random(10)) div 100) *
              _MAX(0, 1 - target.AntiMagic div 25);
          end;
          //               user.SendRefMsg (RM_LOOPNORMALEFFECT, integer(user), 0, 0, NE_BLOODSUCK, '');
          user.SendDelayMsg(user, RM_LOOPNORMALEFFECT, integer(user),
            0, 0, NE_BLOODSUCK, '', 1000);
        end else
          target := nil;
      end else
        target := nil;

  end;

  if not nofire then begin
    with user do begin
      if needfire then
        SendRefMsg(RM_MAGICFIRE, 0, MakeWord(pum.pDef.EffectType, pum.pDef.Effect),
          MakeLong(xx, yy), integer(target), '');
      //2003/03/15 �űԹ��� �߰�
      //���� ���
      if (pum.Level < 3) and train then
        if Abil.Level >= pum.pDef.NeedLevel[pum.Level] then begin
          //���÷����� ������ ���
          user.TrainSkill(pum, 1 + Random(3));
          if not CheckMagicLevelup(pum) then
            SendDelayMsg(user, RM_MAGIC_LVEXP, 0, pum.pDef.MagicId,
              pum.Level, pum.CurTrain, '', 1000);
        end;
    end;
    Result := True;
  end;
end;

end.

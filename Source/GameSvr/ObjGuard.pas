unit ObjGuard;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  ScktComp, syncobjs, MudUtil, HUtil32, Grobal2, Envir, EdCode, ObjBase,
  ObjNpc, M2Share;

type
  TSuperGuard = class(TNormNpc)
  private
  public
    constructor Create;
    destructor Destroy; override;
    procedure RunMsg(msg: TMessageInfo); override;
    function AttackTarget: boolean;
    procedure Run; override;
  end;


implementation

uses
  svMain;

constructor TSuperGuard.Create;
begin
  inherited Create;
  RaceServer := RC_DOORGUARD;
  ViewRange  := 7;
  Light      := 2;
end;

destructor TSuperGuard.Destroy;
begin
  inherited Destroy;
end;

procedure TSuperGuard.RunMsg(msg: TMessageInfo);
begin
  inherited RunMsg(msg);
end;

function TSuperGuard.AttackTarget: boolean;
var
  ox, oy: integer;
  olddir: byte;
begin
  Result := False;
  if TargetCret.PEnvir = PEnvir then begin
    if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
      HitTime := GetCurrentTime;
      TargetFocusTime := GetTickCount;
      ox      := CX;
      oy      := CY;
      olddir  := Dir;
      GetBackPosition(TargetCret, CX, CY);
      Dir := GetNextDirection(CX, CY, TargetCret.CX, TargetCret.CY);
      //Turn (Dir);
      SendRefMsg(RM_HIT, Dir, CX, CY, 0, '');
      _Attack(HM_HIT, TargetCret); //�����ؼ� ����
      TargetCret.SetLastHiter(self);
      TargetCret.ExpHiter := nil; //����ġ��
      CX  := ox;
      CY  := oy;
      Dir := olddir;
      Turn(Dir);
      BreakHolySeize;
    end;
    Result := True;
  end else
    LoseTarget;
end;

procedure TSuperGuard.Run;
var
  i:    integer;
  cret: TCreature;
begin
  if integer(GetCurrentTime - HitTime) > GetNextHitTime then begin
    //��ӹ��� run ���� HitTime �缳����.
    for i := 0 to VisibleActors.Count - 1 do begin
      cret := TCreature(PTVisibleActor(VisibleActors[i]).cret);
      if (not cret.Death) and ((cret.PKLevel >= 2) or
        ((cret.RaceServer >= RC_MONSTER) and (not cret.BoHasMission))) then begin
        SelectTarget(cret);
        break;
      end;
    end;
  end;
  if TargetCret <> nil then
    AttackTarget;
  inherited Run;
end;


end.

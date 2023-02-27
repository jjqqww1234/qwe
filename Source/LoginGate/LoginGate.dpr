program LoginGate;

uses
  Forms,
  GateMain in 'GateMain.pas' {FrmMain},
  showip in 'showip.pas' {FrmShowIp},
  EDCode in '..\_Def\EDCode.pas',
  Grobal2 in '..\_Def\Grobal2.pas',
  HUtil32 in '..\_Def\HUtil32.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'LoginGate';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmShowIp, FrmShowIp);
  Application.Run;
end.

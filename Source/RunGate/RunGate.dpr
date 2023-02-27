program RunGate;

uses
  Forms,
  GateMain in 'GateMain.pas' {FrmMain},
  showip in 'showip.pas' {FrmShowIp},
  WarningMsg in 'WarningMsg.pas' {FrmWarning},
  EDCode in '..\_Def\EDCode.pas',
  Grobal2 in '..\_Def\Grobal2.pas',
  HUtil32 in '..\_Def\HUtil32.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'RunGate';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmShowIp, FrmShowIp);
  Application.CreateForm(TFrmWarning, FrmWarning);
  Application.Run;
end.

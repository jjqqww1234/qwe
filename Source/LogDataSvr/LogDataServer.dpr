program LogDataServer;

uses
  Forms,
  LogDataMain in 'LogDataMain.pas' {FrmLogData};

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'LogDataServer';
  Application.CreateForm(TFrmLogData, FrmLogData);
  Application.Run;
end.

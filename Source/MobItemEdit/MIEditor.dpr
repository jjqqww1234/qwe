program MIEditor;

uses
  Forms,
  MICMain in 'MICMain.pas' {MIEForm},
  MCIData in 'MCIData.pas' {RES_DATAS: TDataModule};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TMIEForm, MIEForm);
  Application.CreateForm(TRES_DATAS, RES_DATAS);
  Application.Run;
end.

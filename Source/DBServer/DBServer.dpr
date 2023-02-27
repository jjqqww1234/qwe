program DBServer;

uses
  Forms,
  DBSMain in 'DBSMain.pas' {FrmDBSrv},
  MfdbDef in 'MfdbDef.pas',
  FDBexpl in 'FDBexpl.pas' {FrmFDBExplore},
  viewrcd in 'viewrcd.pas' {FrmFDBViewer},
  newchr in 'newchr.pas' {FrmNewChr},
  qrfilename in 'qrfilename.pas' {FrmQueryFileName},
  passwd in 'passwd.pas' {PasswordDlg},
  frmcpyrcd in 'frmcpyrcd.pas' {FrmCopyRcd},
  mudutil in 'mudutil.pas',
  HumDb in 'HumDb.pas',
  FIDHum in 'FIDHum.pas' {FrmIDHum},
  CreateId in 'CreateId.pas' {FrmCreateId},
  CreateChr in 'CreateChr.pas' {FrmCreateChr},
  FSMemo in 'FSMemo.pas' {FrmSysMemo},
  FeeDb in 'FeeDb.pas',
  FeeUtil in 'FeeUtil.pas' {FrmFeeUtil},
  FAccount in 'FAccount.pas' {FrmAccountForm},
  CliMain in 'CliMain.pas' {FrmAccServer},
  UsrSoc in 'UsrSoc.pas' {FrmUserSoc},
  IDSocCli in 'IDSocCli.pas' {FrmIDSoc},
  AddrEdit in 'AddrEdit.pas' {FrmEditAddr},
  FrmInID in 'FrmInID.pas' {FrmInputID},
  EDCode in '..\_Def\EDCode.pas',
  Grobal2 in '..\_Def\Grobal2.pas',
  HUtil32 in '..\_Def\HUtil32.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'DBServer';
  Application.CreateForm(TFrmDBSrv, FrmDBSrv);
  Application.CreateForm(TFrmFDBExplore, FrmFDBExplore);
  Application.CreateForm(TFrmFDBViewer, FrmFDBViewer);
  Application.CreateForm(TFrmNewChr, FrmNewChr);
  Application.CreateForm(TFrmQueryFileName, FrmQueryFileName);
  Application.CreateForm(TPasswordDlg, PasswordDlg);
  Application.CreateForm(TFrmCopyRcd, FrmCopyRcd);
  Application.CreateForm(TFrmIDHum, FrmIDHum);
  Application.CreateForm(TFrmCreateId, FrmCreateId);
  Application.CreateForm(TFrmCreateChr, FrmCreateChr);
  Application.CreateForm(TFrmSysMemo, FrmSysMemo);
  Application.CreateForm(TFrmFeeUtil, FrmFeeUtil);
  Application.CreateForm(TFrmAccountForm, FrmAccountForm);
  Application.CreateForm(TFrmAccServer, FrmAccServer);
  Application.CreateForm(TFrmUserSoc, FrmUserSoc);
  Application.CreateForm(TFrmIDSoc, FrmIDSoc);
  Application.CreateForm(TFrmEditAddr, FrmEditAddr);
  Application.CreateForm(TFrmInputID, FrmInputID);
  Application.Run;
end.

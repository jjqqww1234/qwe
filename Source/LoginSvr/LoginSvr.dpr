program LoginSvr;

uses
  Forms,
  LMain in 'LMain.pas' {FrmMain},
  GateSet in 'GateSet.pas' {FrmGateSetting},
  mudutil in 'mudutil.pas',
  IDDB in 'IDDB.pas',
  MasSock in 'MasSock.pas' {FrmMasSoc},
  FrmFindId in 'FrmFindId.pas' {FrmFindUserId},
  EditUserInfo in 'EditUserInfo.pas' {FrmUserInfoEdit},
  MonSoc in 'MonSoc.pas' {FrmMonSoc},
  FAccountView in 'FAccountView.pas' {FrmAccountView},
  Parse in 'Parse.pas',
  EDCode in '..\_Def\EDCode.pas',
  Grobal2 in '..\_Def\Grobal2.pas',
  HUtil32 in '..\_Def\HUtil32.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'LoginSvr';
  Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmGateSetting, FrmGateSetting);
  Application.CreateForm(TFrmMasSoc, FrmMasSoc);
  Application.CreateForm(TFrmFindUserId, FrmFindUserId);
  Application.CreateForm(TFrmUserInfoEdit, FrmUserInfoEdit);
  Application.CreateForm(TFrmMonSoc, FrmMonSoc);
  Application.CreateForm(TFrmAccountView, FrmAccountView);
  Application.Run;
end.

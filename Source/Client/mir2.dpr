program mir2;

uses
  Forms,
  Dialogs,
  IniFiles,
  Windows,
  SysUtils,
  Classes,
  NPGameDLL,
  ClMain in 'ClMain.pas' {FrmMain},
  DrawScrn in 'DrawScrn.pas',
  IntroScn in 'IntroScn.pas',
  PlayScn in 'PlayScn.pas',
  MapUnit in 'MapUnit.pas',
  FState in 'FState.pas' {FrmDlg},
  ClFunc in 'ClFunc.pas',
  cliUtil in 'cliUtil.pas',
  DWinCtl in 'DWinCtl.pas',
  WIL in 'WIL.pas',
  magiceff in 'magiceff.pas',
  SoundUtil in 'SoundUtil.pas',
  Actor in 'Actor.pas',
  HerbActor in 'HerbActor.pas',
  AxeMon in 'AxeMon.pas',
  clEvent in 'clEvent.pas',
  ButtonListBox in 'ButtonListBox.pas',
  SingleInstance in 'SingleInstance.pas',
  MaketSystem in 'MaketSystem.pas',
  RelationShip in 'RelationShip.pas',
  EDCode in '..\_Def\EDCode.pas',
  Grobal2 in '..\_Def\Grobal2.pas',
  HUtil32 in '..\_Def\HUtil32.pas',
  List32 in '..\Common\List32.pas';

{$R *.RES}

const
  //  PatchTempFile = 'Patch#n.dat';
  PatchTempFile     = 'Mir2Patch#n.dat';
  PatchTempTestFile = 'Patch#n1.dat';
  PatchTestProgram  = 'AutoTestPatch.exe';
  //  PatchProgram = 'Patch.exe';
  PatchProgram      = 'Mir2Patch.exe';
  FindHackProgram   = 'findhack.exe';

var
  mini:    TIniFile;
  boneedpatchprog: boolean;
  patchprogramname: string;
  patchtemp: string;
  str:     string;
  pstr:    array[0..255] of char;
  //   pi: PROCESS_INFORMATION;
  //   so: STARTUPINFO;
  strlist: TStringList;
  flname:  string;
  g_SingleInstance: TSingleInstance;

  //   exitcode: DWORD;
  //   SEInfo: TShellExecuteInfo;
  //   ExitCode: DWORD;
  //   ExecuteFile, ParamString, StartInString: string;
  //   ProcInf : TProcessInformation;

  dwResult: DWORD;

begin

  boneedpatchprog := True;
  TerminateNow    := False;

  if BO_FOR_TEST then begin
    patchprogramname := PatchTestProgram;
    patchtemp := PatchTempTestFile;
  end else begin
    patchprogramname := PatchProgram;
    patchtemp := PatchTempFile;
  end;

  if FileExists(patchtemp) then begin  //패치 프로그램이 변경되야 하는 경우..
    if FileSize(patchtemp) > 140 * 1024 then begin //일정한 크기 이상..
      FileCopy(patchtemp, patchprogramname);
    end;
  end;

  if GetCommandLine = ' -U' then begin
    boneedpatchprog := False;
    Sleep(2000);
  end else begin
    boneedpatchprog := True;
  end;

  g_SingleInstance := TSingleInstance.Create;
  if (not g_SingleInstance.Initialize('Crazy4U')) then begin
    MessageDlg('Only one Program enabled.', mtError, [mbOK], 0);
    Application.Terminate;
    exit;
  end;
  g_SingleInstance.Free;

  if CheckMirProgram then begin
    MessageDlg('Checking Mir program...', mtError, [mbOK], 0);
    Application.Terminate;
    exit;
  end;

  if HasMMX then begin
    Application.Initialize;
    Application.Title := 'legend of mir2';
    Application.CreateForm(TFrmMain, FrmMain);
  Application.CreateForm(TFrmDlg, FrmDlg);
  if boneedpatchprog and BoNeedPatch then begin
      if TaiwanVersion then begin
        strlist := TStringList.Create;
        flname  := '.\license.dat';
        if FileExists(flname) then begin
          strlist.LoadFromFile(flname);
          DecodeLicenseStrings(strlist);
        end;

        //           if not FrmConfirmDlg.ExecuteDlg (strlist) then
        //              TerminateNow := TRUE;
        strlist.Free;
      end;

      if not TerminateNow then
        if not BoCompileMode then begin
          if FileExists(patchprogramname) then begin
            StrPCopy(pstr, patchprogramname);
            TerminateNow := True;
            Application.Terminate;
            WinExec(pstr, SW_SHOWDEFAULT);
            exit;
          end else
            MessageDlg(patchprogramname +
              ' file not found. Can not use auto-patch utility.', mtWarning, [mbOK], 0);
        end;

    end;
  end else begin
    MessageDlg('Do not use MMX.', mtError, [mbOK], 0);
    TerminateNow := True;
  end;




  if not BoCompileMode then begin
    //GameGuard 2005/11/01
    SetCallbackToGameMon(@NPGameMonCallback);
    PreInitNPGameMonA('Mir2PH');
    dwResult := InitNPGameMon();

    if dwResult <> NPGAMEMON_SUCCESS then begin

      // ‘6. 주요에러코드’를 참조하여 상황에 맞는 메시지를 출력해줍니다.
      case dwResult of
        NPGAMEMON_ERROR_EXIST: begin
          MessageDlg('GameGuard is already running.' + #13 +
            'Try rebooting first and executing the game again. Code=' +
            IntToStr(dwResult),
            mtError, [mbOK], 0);
          CloseNPGameMon;
          Application.Terminate;
          exit;
        end;
        NPGAMEMON_ERROR_GAME_EXIST: begin
          MessageDlg(
            'There are multiple events of game execution or GameGuard is already running.'
            + #13 + 'Close the game then try again. Code=' +
            IntToStr(dwResult), mtError, [mbOK], 0);
          CloseNPGameMon;
          Application.Terminate;
          exit;
        end;
        NPGAMEMON_ERROR_INIT: begin
          MessageDlg('GameGuard initialization error.' + #13 +
            'Try rebooting and executing the game or close the program considered' +
            #13 + 'to cause a collision. Code=' + IntToStr(dwResult),
            mtError, [mbOK], 0);
          CloseNPGameMon;
          Application.Terminate;
          exit;
        end;
        NPGAMEMON_ERROR_AUTH_GAMEGUARD,
        NPGAMEMON_ERROR_NFOUND_GG,
        NPGAMEMON_ERROR_AUTH_INI,
        NPGAMEMON_ERROR_NFOUND_INI: begin
          MessageDlg('GameGuard file does not exist or is corrupted.' +
            #13 + 'Please install the GameGuard setup file. Code=' + IntToStr(dwResult),
            mtError, [mbOK], 0);
          CloseNPGameMon;
          Application.Terminate;
          exit;
        end;
        NPGAMEMON_ERROR_CRYPTOAPI: MessageDlg(
            'Window system files might be corrupted.' + #13 +
            'Please reinstall the Internet Explorer(IE). Code=' + IntToStr(dwResult),
            mtError, [mbOK], 0);
        NPGAMEMON_ERROR_EXECUTE: begin
          MessageDlg('Fail to run GameGuard.' + #13 +
            'Please reinstall the GameGuard setup file. Code=' + IntToStr(dwResult),
            mtError, [mbOK], 0);
          CloseNPGameMon;
          Application.Terminate;
          exit;
        end;
        NPGAMEMON_ERROR_ILLEGAL_PRG: begin
          MessageDlg('Illegal program detected.' + #13 +
            'Close all the unnecessary programs before running the game. Code=' +
            IntToStr(dwResult),
            mtError, [mbOK], 0);
          CloseNPGameMon;
          Application.Terminate;
          exit;
        end;
        NPGMUP_ERROR_ABORT: begin
          MessageDlg('GameGuard update has been aborted.' + #13 +
            'Please check the status of Internet network or personal firewall settings' +
            #13 + 'when unable to connect continuously. Code=' +
            IntToStr(dwResult), mtError, [mbOK], 0);
          CloseNPGameMon;
          Application.Terminate;
          exit;
        end;
        NPGMUP_ERROR_CONNECT,
        NPGMUP_ERROR_DOWNCFG: begin
          MessageDlg('Fail to connect the GameGuard update server.' +
            #13 +
            'Please try again after a while, or check personal Firewall settings if any. Code='
            +
            IntToStr(dwResult), mtError, [mbOK], 0);
          CloseNPGameMon;
          Application.Terminate;
          exit;
        end;
        NPGMUP_ERROR_AUTH: begin
          MessageDlg('Fail to complete GameGuard update.' + #13 +
            'Suspend Anti-Virus program temporarily and try the game,' +
            #13 + 'or check the settings of PC management programs if any. Code=' +
            IntToStr(dwResult),
            mtError, [mbOK], 0);
          CloseNPGameMon;
          Application.Terminate;
          exit;
        end;
        NPGAMEMON_ERROR_NPSCAN: begin
          MessageDlg('Failed to load virus and hacking tool scanning module.' +
            #13 + 'Possibly due to lack of memory or virus infection. Code=' +
            IntToStr(dwResult),
            mtError, [mbOK], 0);
          CloseNPGameMon;
          Application.Terminate;
          exit;
        end;

        else
          MessageDlg('Error occurred while running GameGuard.' + #13 +
            'Please send all *.erl files in GameGuard folder to game@inca.co.kr via email. Code='
            + IntToStr(dwResult), mtError, [mbOK], 0);
          CloseNPGameMon;
          Application.Terminate;
          exit;
      end;
    end;

    SetHwndToGameMon(Application.Handle);
  end;

  //if CheckMirProgram then begin
  //   TerminateNow := TRUE;
  //Application.Terminate;
  //exit;
  //end;

  FrmMain.InitializeClient;
  Application.Run;
end.

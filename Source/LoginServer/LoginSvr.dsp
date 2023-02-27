# Microsoft Developer Studio Project File - Name="LoginSvr" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=LoginSvr - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "LoginSvr.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "LoginSvr.mak" CFG="LoginSvr - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "LoginSvr - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "LoginSvr - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "LoginSvr - Win32 Release"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "../_Bin"
# PROP Intermediate_Dir "../_Obj_Release/LoginSvr"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /YX /FD /c
# ADD CPP /nologo /MT /W3 /GX /O2 /I "C:\Program Files\Microsoft SDK\include" /I "..\_Oranze Library" /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_MBCS" /D "WIN32_LEAN_AND_MEAN" /D "_EXLOG" /FR /YX /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x412 /d "NDEBUG"
# ADD RSC /l 0x412 /d "NDEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /machine:I386
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /machine:I386

!ELSEIF  "$(CFG)" == "LoginSvr - Win32 Debug"

# PROP BASE Use_MFC 0
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 0
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "../_Bin"
# PROP Intermediate_Dir "../_Obj_Debug/LoginSvr"
# PROP Ignore_Export_Lib 0
# PROP Target_Dir ""
# ADD BASE CPP /nologo /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /YX /FD /GZ /c
# ADD CPP /nologo /MTd /W3 /Gm /GX /ZI /Od /I "C:\Program Files\Microsoft SDK\include" /I "..\_Oranze Library" /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_MBCS" /D "WIN32_LEAN_AND_MEAN" /D "_TIMER_DEBUG" /FR /YX /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x412 /d "_DEBUG"
# ADD RSC /l 0x412 /d "_DEBUG"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# ADD LINK32 kernel32.lib user32.lib gdi32.lib winspool.lib comdlg32.lib advapi32.lib shell32.lib ole32.lib oleaut32.lib uuid.lib odbc32.lib odbccp32.lib /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "LoginSvr - Win32 Release"
# Name "LoginSvr - Win32 Debug"
# Begin Group "Resource"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\Res\icon.ico
# End Source File
# Begin Source File

SOURCE=.\Res\resource.aps
# End Source File
# Begin Source File

SOURCE=.\Res\resource.h
# End Source File
# Begin Source File

SOURCE=.\Res\resource.rc
# End Source File
# Begin Source File

SOURCE=.\Res\toolbar.bmp
# End Source File
# End Group
# Begin Group "UI"

# PROP Default_Filter ""
# Begin Source File

SOURCE=.\dlgcfg.cpp
# End Source File
# Begin Source File

SOURCE=.\dlgcfg.h
# End Source File
# Begin Source File

SOURCE=.\mir2wnd.cpp
# End Source File
# Begin Source File

SOURCE=.\mir2wnd.h
# End Source File
# End Group
# Begin Group "Common"

# PROP Default_Filter ""
# Begin Source File

SOURCE=..\Common\endecode.cpp
# End Source File
# Begin Source File

SOURCE=..\Common\endecode.h
# End Source File
# Begin Source File

SOURCE=..\Common\mir2packet.cpp
# End Source File
# Begin Source File

SOURCE=..\Common\mir2packet.h
# End Source File
# End Group
# Begin Source File

SOURCE=.\dbtable.h
# End Source File
# Begin Source File

SOURCE=.\loginsvrwnd.cpp
# End Source File
# Begin Source File

SOURCE=.\loginsvrwnd.h
# End Source File
# Begin Source File

SOURCE=.\mir2dbhandler.cpp
# End Source File
# Begin Source File

SOURCE=.\mir2dbhandler.h
# End Source File
# Begin Source File

SOURCE=.\netcheckserver.cpp
# End Source File
# Begin Source File

SOURCE=.\netcheckserver.h
# End Source File
# Begin Source File

SOURCE=.\netgameserver.cpp
# End Source File
# Begin Source File

SOURCE=.\netgameserver.h
# End Source File
# Begin Source File

SOURCE="..\_Oranze Library\netiocp.cpp"
# End Source File
# Begin Source File

SOURCE="..\_Oranze Library\netiocp.h"
# End Source File
# Begin Source File

SOURCE=.\netlogingate.cpp
# End Source File
# Begin Source File

SOURCE=.\netlogingate.h
# End Source File
# Begin Source File

SOURCE=.\netloginsvr.cpp
# End Source File
# Begin Source File

SOURCE=.\netloginsvr.h
# End Source File
# Begin Source File

SOURCE=.\protocol.h
# End Source File
# Begin Source File

SOURCE="..\_Oranze Library\_Bin\_Oranze Library_Debug.lib"
# End Source File
# End Target
# End Project

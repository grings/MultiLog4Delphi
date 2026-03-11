unit MultiLog4D.Android;

interface

uses
  System.SysUtils,

  Multilog4D.Base,
  Multilog4D.Types,
  Multilog4D.Interfaces
  {$IFDEF ANDROID}
  ,Androidapi.Helpers
  ,Androidapi.JNI.JavaTypes
  ,Androidapi.JNI.Util
  ,MultiLog4D.Java.Interfaces
  {$ENDIF}
  ;

type
  TMultiLog4DAndroid = class(TMultiLog4DBase)
  protected
    procedure LogWriteToDestination(const AMsg: string; const ALogType: TLogType);
  public
    function LogWrite(const AMsg: string; const ALogType: TLogType): IMultiLog4D; override;
    function LogWriteInformation(const AMsg: string): IMultiLog4D; override;
    function LogWriteWarning(const AMsg: string): IMultiLog4D; override;
    function LogWriteError(const AMsg: string): IMultiLog4D; override;
    function LogWriteFatalError(const AMsg: string): IMultiLog4D; override;
  end;

implementation

procedure TMultiLog4DAndroid.LogWriteToDestination(const AMsg: string; const ALogType: TLogType);
begin
  if FTag = EmptyStr then
    GetDefaultTag;

  {$IFDEF ANDROID}
  case ALogType of
    ltWarning    : TJutil_Log.JavaClass.w(StringToJString(FTag), StringToJString(AMsg));
    ltError,
    ltFatalError : TJutil_Log.JavaClass.e(StringToJString(FTag), StringToJString(AMsg));
  else
    TJutil_Log.JavaClass.i(StringToJString(FTag), StringToJString(AMsg));
  end;
  {$ENDIF}

  NotifyProviders(AMsg, ALogType);
end;

function TMultiLog4DAndroid.LogWrite(const AMsg: string; const ALogType: TLogType): IMultiLog4D;
begin
  LogWriteToDestination(AMsg, ALogType);
  Result := Self as IMultiLog4D;
end;

function TMultiLog4DAndroid.LogWriteInformation(const AMsg: string): IMultiLog4D;
begin
  LogWriteToDestination(AMsg, ltInformation);
  Result := Self as IMultiLog4D;
end;

function TMultiLog4DAndroid.LogWriteWarning(const AMsg: string): IMultiLog4D;
begin
  LogWriteToDestination(AMsg, ltWarning);
  Result := Self as IMultiLog4D;
end;

function TMultiLog4DAndroid.LogWriteError(const AMsg: string): IMultiLog4D;
begin
  LogWriteToDestination(AMsg, ltError);
  Result := Self as IMultiLog4D;
end;

function TMultiLog4DAndroid.LogWriteFatalError(const AMsg: string): IMultiLog4D;
begin
  LogWriteToDestination(AMsg, ltFatalError);
  Result := Self as IMultiLog4D;
end;

end.

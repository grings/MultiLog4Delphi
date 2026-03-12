unit MultiLog4D.iOS;

interface

uses
  System.SysUtils,
  System.StrUtils,
  System.Classes,

  MultiLog4D.Interfaces,
  MultiLog4D.Types,
  MultiLog4D.Base
{$IFDEF IOS}
  ,iOSapi.Foundation
  ,Macapi.Helpers
{$ENDIF}
  ;

type
  TMultiLog4DiOS = class(TMultiLog4DBase)
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

procedure TMultiLog4DiOS.LogWriteToDestination(const AMsg: string; const ALogType: TLogType);
begin
  {$IFDEF IOS}
  NSLog(StringToID(FTag + GetLogPrefix(ALogType) + AMsg));
  {$ENDIF}
  NotifyProviders(AMsg, ALogType);
end;

function TMultiLog4DiOS.LogWrite(const AMsg: string; const ALogType: TLogType): IMultiLog4D;
begin
  LogWriteToDestination(AMsg, ALogType);
  Result := Self as IMultiLog4D;
end;

function TMultiLog4DiOS.LogWriteInformation(const AMsg: string): IMultiLog4D;
begin
  LogWriteToDestination(AMsg, ltInformation);
  Result := Self as IMultiLog4D;
end;

function TMultiLog4DiOS.LogWriteWarning(const AMsg: string): IMultiLog4D;
begin
  LogWriteToDestination(AMsg, ltWarning);
  Result := Self as IMultiLog4D;
end;

function TMultiLog4DiOS.LogWriteError(const AMsg: string): IMultiLog4D;
begin
  LogWriteToDestination(AMsg, ltError);
  Result := Self as IMultiLog4D;
end;

function TMultiLog4DiOS.LogWriteFatalError(const AMsg: string): IMultiLog4D;
begin
  LogWriteToDestination(AMsg, ltFatalError);
  Result := Self as IMultiLog4D;
end;

end.

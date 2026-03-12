unit MultiLog4D.Provider.Events;

interface

uses
  System.SysUtils,
  MultiLog4D.Provider.Interfaces,
  MultiLog4D.Provider.Base;

type
  TMultiLog4DProviderEvents = class(TMultiLog4DProviderBase)
  private
    FOnLog: TProc<TMultiLog4DLogEntry>;
  public
    constructor Create(const AOnLog: TProc<TMultiLog4DLogEntry>);
    procedure WriteLog(const AEntry: TMultiLog4DLogEntry); override;
  end;

implementation

constructor TMultiLog4DProviderEvents.Create(const AOnLog: TProc<TMultiLog4DLogEntry>);
begin
  inherited Create;
  FOnLog := AOnLog;
end;

procedure TMultiLog4DProviderEvents.WriteLog(const AEntry: TMultiLog4DLogEntry);
begin
  if Assigned(FOnLog) then
    FOnLog(AEntry);
end;

end.

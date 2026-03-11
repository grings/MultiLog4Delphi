unit MultiLog4D.Provider.Base;

interface

uses
  MultiLog4D.Types,
  MultiLog4D.Provider.Interfaces;

type
  TMultiLog4DProviderBase = class(TInterfacedObject, IMultiLog4DProvider)
  private
    FEnabled: Boolean;
    FLogTypeFilter: TLogTypeFilter;
  protected
    function GetEnabled: Boolean;
    procedure SetEnabled(const AValue: Boolean);
    function GetLogTypeFilter: TLogTypeFilter;
    procedure SetLogTypeFilter(const AValue: TLogTypeFilter);
  public
    constructor Create;
    procedure WriteLog(const AEntry: TMultiLog4DLogEntry); virtual; abstract;
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property LogTypeFilter: TLogTypeFilter read GetLogTypeFilter write SetLogTypeFilter;
  end;

implementation

constructor TMultiLog4DProviderBase.Create;
begin
  inherited Create;
  FEnabled       := True;
  FLogTypeFilter := [ltInformation, ltWarning, ltError, ltFatalError];
end;

function TMultiLog4DProviderBase.GetEnabled: Boolean;
begin
  Result := FEnabled;
end;

procedure TMultiLog4DProviderBase.SetEnabled(const AValue: Boolean);
begin
  FEnabled := AValue;
end;

function TMultiLog4DProviderBase.GetLogTypeFilter: TLogTypeFilter;
begin
  Result := FLogTypeFilter;
end;

procedure TMultiLog4DProviderBase.SetLogTypeFilter(const AValue: TLogTypeFilter);
begin
  FLogTypeFilter := AValue;
end;

end.

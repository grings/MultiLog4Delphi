unit MultiLog4D.Provider.REST;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  System.Net.HttpClient,
  System.Net.URLClient,
  MultiLog4D.Provider.Interfaces,
  MultiLog4D.Provider.Base;

type
  TMultiLog4DProviderREST = class(TMultiLog4DProviderBase)
  protected
    FEndpointURL: string;
    FHeaders: TDictionary<string, string>;
  public
    constructor Create(const AEndpointURL: string);
    destructor Destroy; override;
    procedure AddHeader(const AName, AValue: string);
    procedure WriteLog(const AEntry: TMultiLog4DLogEntry); override;
  end;

implementation

uses
  System.JSON,
  MultiLog4D.Types;

constructor TMultiLog4DProviderREST.Create(const AEndpointURL: string);
begin
  inherited Create;
  FEndpointURL := AEndpointURL;
  FHeaders := TDictionary<string, string>.Create;
end;

destructor TMultiLog4DProviderREST.Destroy;
begin
  FHeaders.Free;
  inherited Destroy;
end;

procedure TMultiLog4DProviderREST.AddHeader(const AName, AValue: string);
begin
  FHeaders.AddOrSetValue(AName, AValue);
end;

procedure TMultiLog4DProviderREST.WriteLog(const AEntry: TMultiLog4DLogEntry);
const
  LogTypeNames: array[TLogType] of string = ('Information', 'Warning', 'Error', 'FatalError');
var
  LHTTPClient: THTTPClient;
  LPayload: TStringStream;
  LJSON: TJSONObject;
  LHeaders: TNetHeaders;
  I: Integer;
  LHeaderPair: TPair<string, string>;
begin
  LJSON := TJSONObject.Create;
  try
    LJSON.AddPair('timestamp', FormatDateTime('yyyy-mm-dd"T"hh:nn:ss', AEntry.TimeStamp));
    LJSON.AddPair('logType', LogTypeNames[AEntry.LogType]);
    LJSON.AddPair('tag', AEntry.Tag);
    LJSON.AddPair('message', AEntry.Message);

    LPayload := TStringStream.Create(LJSON.ToJSON, TEncoding.UTF8);
    try
      LHTTPClient := THTTPClient.Create;
      try
        SetLength(LHeaders, FHeaders.Count);
        I := 0;
        for LHeaderPair in FHeaders do
        begin
          LHeaders[I] := TNameValuePair.Create(LHeaderPair.Key, LHeaderPair.Value);
          Inc(I);
        end;
        LHTTPClient.Post(FEndpointURL, LPayload, nil, LHeaders);
      finally
        LHTTPClient.Free;
      end;
    finally
      LPayload.Free;
    end;
  finally
    LJSON.Free;
  end;
end;

end.

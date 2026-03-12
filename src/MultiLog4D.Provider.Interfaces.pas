unit MultiLog4D.Provider.Interfaces;

interface

uses
  System.SysUtils,
  MultiLog4D.Types;

type
  TMultiLog4DLogEntry = record
    TimeStamp: TDateTime;
    LogType: TLogType;
    Tag: string;
    Message: string;
  end;

  IMultiLog4DProvider = interface
    ['{A8B6C3D1-E5F2-4890-ABCD-EF1234567890}']
    procedure WriteLog(const AEntry: TMultiLog4DLogEntry);
    function GetEnabled: Boolean;
    procedure SetEnabled(const AValue: Boolean);
    function GetLogTypeFilter: TLogTypeFilter;
    procedure SetLogTypeFilter(const AValue: TLogTypeFilter);
    property Enabled: Boolean read GetEnabled write SetEnabled;
    property LogTypeFilter: TLogTypeFilter read GetLogTypeFilter write SetLogTypeFilter;
  end;

implementation

end.

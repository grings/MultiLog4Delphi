program Android2Telegram;

uses
  MultiLog4D.Util,
  System.StartUpCopy,
  FMX.Forms,
  Unit4 in 'Unit4.pas' {Form4};

{$R *.res}

{$I ..\TelegramConfig.inc}

begin
  TMultiLog4DUtil.Logger
    .Tag('TelegramAndroid')
    .LogWriteInformation('>>>>>>>>>> Starting Telegram Android Sample <<<<<<<<<<');

  Application.Initialize;
  Application.CreateForm(TForm4, Form4);
  Application.Run;
end.

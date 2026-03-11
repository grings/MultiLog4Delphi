program Android_Telegram;

uses
  MultiLog4D.Util,
  System.StartUpCopy,
  FMX.Forms,
  UMain in 'UMain.pas' {FormTelegramAndroid};

{$R *.res}

{$I ..\TelegramConfig.inc}

begin
  TMultiLog4DUtil.Logger
    .Tag('TelegramAndroid')
    .LogWriteInformation('>>>>>>>>>> Starting Telegram Android Sample <<<<<<<<<<');

  Application.Initialize;
  Application.CreateForm(TFormTelegramAndroid, FormTelegramAndroid);
  Application.Run;
end.

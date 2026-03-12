program VCL_Telegram;

uses
  Vcl.Forms,
  UMain in 'UMain.pas' {FormTelegramDesktop},
  MultiLog4D.Provider.Telegram in '..\..\..\..\src\Providers\MultiLog4D.Provider.Telegram.pas';

{$R *.res}
{$I ..\TelegramConfig.inc}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormTelegramDesktop, FormTelegramDesktop);
  Application.Run;
end.

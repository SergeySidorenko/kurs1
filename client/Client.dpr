program Client;

uses
  Forms,
  ClientUnit in '..\client\bin\ClientUnit.pas' {ClientForm},
  uLkJSON in '..\client\bin\uLkJSON.pas' {JSON},
  UserUtil in '..\client\bin\UserUtil.pas' {UsUtil},
  LoginUnit in '..\client\bin\LoginUnit.pas' {LoginForm},
  SettingUnit in '..\client\bin\SettingUnit.pas' {SettingForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TClientForm, ClientForm);
  Application.CreateForm(TLoginForm, LoginForm);
  Application.CreateForm(TSettingForm, SettingForm);
  Application.Run;
end.

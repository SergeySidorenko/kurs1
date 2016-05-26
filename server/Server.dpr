program Server;

uses
  Forms,
  ServerUnit in 'ServerUnit.pas' {Form1},
  DBUtil in 'DBUtil.pas',
  UserUtil in 'UserUtil.pas',
  uLkJSON in 'uLkJSON.pas' {JSON};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

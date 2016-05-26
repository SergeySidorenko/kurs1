unit ServerUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, StdCtrls,
  ExtCtrls, DBXpress, SqlExpr, ADODB, ScktComp, WinSock, DBUtil,
  IdTCPServer, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IniFiles, uLkJSON, UserUtil,
  Menus, sSkinManager;

type

TForm1 = class(TForm)
    Timer1: TTimer;
    ADOConnection1: TADOConnection;
    ADOQuery1: TADOQuery;
    Memo1: TMemo;
    IdTCPServer1: TIdTCPServer;
    SG: TStringGrid;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    Label1: TLabel;
    Label2: TLabel;
    sSkinManager1: TsSkinManager;
    procedure Timer1Timer(Sender: TObject);
    procedure FormCreate(Sender: TObject);

    procedure UpdateSG;
    procedure OpenPort;

    procedure IdTCPServer1TIdCH_LoginCommand(ASender: TIdCommand);
    procedure IdTCPServer1TIdCH_RegistrationCommand(ASender: TIdCommand);
    procedure IdTCPServer1TIdCH_ReadContactListCommand(
      ASender: TIdCommand);
    procedure IdTCPServer1TIdCH_AddFriendCommand(ASender: TIdCommand);
    procedure IdTCPServer1TIdCH_SearchUserCommand(ASender: TIdCommand);
    procedure IdTCPServer1TIdCH_DeleteFriendCommand(ASender: TIdCommand);
    procedure IdTCPServer1TIdCH_DeleteAccountCommand(ASender: TIdCommand);
    procedure IdTCPServer1TIdCH_LogOutCommand(ASender: TIdCommand);
    procedure N1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
   Form1: TForm1;
   WorkWithDB: TWorkWithDB;
   User: TUser;

implementation


{$R *.dfm}

//////  Start server  //////////////////////////////////////////

procedure TForm1.FormCreate(Sender: TObject);
begin
   try
      OpenPort;
      caption := 'Server - Port: ' + inttostr(IdTCPServer1.DefaultPort);
      Application.Title := 'Server';
      SG.Cells[0,0] := 'Id';
      SG.Cells[1,0] := 'Status';
      SG.Cells[2,0] := 'Login';
      SG.Cells[3,0] := 'Port';
      SG.Cells[4,0] := 'IP';
      SG.Cells[5,0] := 'Date';
      ADOConnection1.Open;
      WorkWithDB := TWorkWithDB.Create(ADOQuery1);
      UpdateSG;
   except
      timer1.enabled := false;
      MessageBox(handle, PChar('Сервер не может работать без запущенной быза данных. Запустите ее, после чего перезапустите сервер.'),PChar('Ошибка!'), MB_ICONERROR+MB_OKCANCEL);
      close;
   end;
end;

procedure TForm1.OpenPort;
var
   ServDataFile: TIniFile;
   ServPort: integer;
begin
   ServDataFile := TIniFile.Create('.\data\ServerData.ini');
   ServPort := strtoint(ServDataFile.ReadString('server', 'port', '3033'));
   IdTCPServer1.DefaultPort := ServPort;
   IdTCPServer1.Active := true;
end;

//////  WORH WITH DB  //////////////////////////////////////////

//! update server table
procedure TForm1.UpdateSG;
var
   i: integer;
   TempList: TList;
begin
   TempList := WorkWithDB.AllUsers;
   SG.RowCount := TempList.Count + 1;
   for i := 0 to TempList.Count - 1 do
   begin
      SG.Cells[0,i + 1] := inttostr(i + 1);
      SG.Cells[1,i + 1] := inttostr(TUser(TempList[i]).status);
      SG.Cells[2,i + 1] := TUser(TempList[i]).login;
      SG.Cells[3,i + 1] := inttostr(TUser(TempList[i]).port);
      SG.Cells[4,i + 1] := TUser(TempList[i]).ip;
      SG.Cells[5,i + 1] := TUser(TempList[i]).date;
   end;
   TempList.Free;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
   WorkWithDB.TimerDeleteAndUpdateUsers;
   UpdateSg;
end;

procedure TForm1.IdTCPServer1TIdCH_LoginCommand(ASender: TIdCommand);
var
   js: TlkJSONobject;
   JSLogin, JSPass, JSAddr, JSPort, ClientMessage: string;
   DBAnswer, DBStatus: boolean;
begin
   ClientMessage := ASender.UnparsedParams;
   try
      js := TlkJSONobject.Create;
      js := TlkJSON.ParseText(ClientMessage) as TlkJSONobject;
      JSLogin := js.getString('login');
      JSPass := js.getString('pass');
      JSAddr := ASender.Thread.Connection.Socket.Binding.PeerIP;
      JSPort := js.getString('port');
      js.Free;

      try
         DBStatus := WorkWithDB.FindUser(JSLogin).status = 1;
      except
         DBStatus := true;
      end;
      DBAnswer := WorkWithDB.LoginUser(JSLogin, JSPass, JSAddr,  strtoint(JSPort));

      js := TlkJSONobject.Create;
      js.Add('answer', booltostr(DBAnswer));
      js.Add('status', booltostr(DBStatus));
      js.Add('ip', JSAddr);
      ClientMessage := TlkJSON.GenerateText(js);
      js.Free;
      ASender.Response.Add(ClientMessage);
      Memo1.Lines.Add('LoginCommand  :  ' + DateTimeToStr(now()));
   except
      Memo1.Lines.Add('Error in LoginCommand  :  ' + DateTimeToStr(now()));
   end;
end;

procedure TForm1.IdTCPServer1TIdCH_RegistrationCommand(
  ASender: TIdCommand);
var
   js: TlkJSONobject;
   JSLogin, JSPass, JSName, ClientMessage: string;
   DBAnswer: boolean;
begin
   ClientMessage := ASender.UnparsedParams;
   try
      js := TlkJSONobject.Create;
      js := TlkJSON.ParseText(ClientMessage) as TlkJSONobject;
      JSLogin := js.getString('login');
      JSPass := js.getString('pass');
      js.Free;

      DBAnswer := WorkWithDB.RegisterUser(JSLogin, JSPass);

      js := TlkJSONobject.Create;
      js.Add('answer', booltostr(DBAnswer));
      ClientMessage := TlkJSON.GenerateText(js);
      js.Free;
      ASender.Response.Add(ClientMessage);
      Memo1.Lines.Add('RegistrationCommand  :  ' + DateTimeToStr(now()));
   except
      Memo1.Lines.Add('Error in RegistrationCommand  :  '  + DateTimeToStr(now()));
   end;
end;


procedure TForm1.IdTCPServer1TIdCH_ReadContactListCommand(
  ASender: TIdCommand);
var
   js: TlkJSONobject;
   JSLogin, ClientMessage: string;
   JSList: TlkJSONlist;
   TempList: TList;
   i: integer;
begin
   ClientMessage := ASender.UnparsedParams;
   try
      js := TlkJSONobject.Create;
      js := TlkJSON.ParseText(ClientMessage) as TlkJSONobject;
      JSLogin := js.getString('login');
      js.Free;
      TempList := TList.Create;
      TempList := WorkWithDB.ReadContactList(JSlogin);
      JSList := TlkJSONlist.Create;

      for i := 0 to TempList.Count - 1 do
      begin
         JSList.Add(TUser(TempList.Items[i]).toJSON);
      end;
      ClientMessage := TlkJSON.GenerateText(JSList);
      JSList.Free;
      ASender.Response.Add(ClientMessage);
   except
      Memo1.Lines.Add('Error in ReadContactListCommand  :  '  + DateTimeToStr(now()));
   end;
end;

procedure TForm1.IdTCPServer1TIdCH_AddFriendCommand(ASender: TIdCommand);
var
   js: TlkJSONobject;
   JSLogin1, JSLogin2, ClientMessage: string;
begin
   ClientMessage := ASender.UnparsedParams;
   try
      js := TlkJSONobject.Create;
      js := TlkJSON.ParseText(ClientMessage) as TlkJSONobject;
      JSLogin1 := js.getString('login1');
      JSLogin2 := js.getString('login2');
      js.Free;
      WorkWithDB.AddFriend(JSLogin1, JSLogin2);
      Memo1.Lines.Add('AddFriendCommand  :  ' + DateTimeToStr(now()));
   except
       Memo1.Lines.Add('Error in AddFriendCommand  :  '  + DateTimeToStr(now()));
   end;
end;

procedure TForm1.IdTCPServer1TIdCH_DeleteFriendCommand(
  ASender: TIdCommand);
var
   js: TlkJSONobject;
   JSLogin1, JSLogin2, ClientMessage:string;
begin
   ClientMessage := ASender.UnparsedParams;
   try
      js := TlkJSONobject.Create;
      js := TlkJSON.ParseText(ClientMessage) as TlkJSONobject;
      JSLogin1 := js.getString('login1');
      JSLogin2 := js.getString('login2');
      js.Free;
      WorkWithDB.DeleteFriend(JSLogin1, JSLogin2);
      Memo1.Lines.Add('DeleteFriendCommand  :  ' + DateTimeToStr(now()));
   except
       Memo1.Lines.Add('Error in DeleteFriendCommand  :  '  + DateTimeToStr(now()));
   end;
end;

procedure TForm1.IdTCPServer1TIdCH_SearchUserCommand(ASender: TIdCommand);
var
   js: TlkJSONobject;
   TempUser: TUser;
   JSLogin, ClientMessage: string;
begin
   ClientMessage := ASender.UnparsedParams;
   try
      js := TlkJSONobject.Create;
      js := TlkJSON.ParseText(ClientMessage) as TlkJSONobject;
      JSLogin := js.getString('login');
      js.Free;

      TempUser := WorkWithDB.FindUser(JSLogin);
      if TempUser = nil then
      begin
         js := TlkJSONobject.Create;
         js.Add('id', inttostr(123));
         js.Add('ip', 'noip');
         js.Add('status', inttostr(3));
         js.Add('port', inttostr(123));
         ClientMessage := TlkJSON.GenerateText(js);
         js.Free
      end
      else
      begin
         js := TlkJSONobject.Create;
         js.Add('id', inttostr(TempUser.id));
         js.Add('ip', TempUser.ip);
         js.Add('status', inttostr(TempUser.status));
         js.Add('port', inttostr(TempUser.port));
         ClientMessage := TlkJSON.GenerateText(js);
         js.Free;
      end;
      ASender.Response.Add(ClientMessage);
      Memo1.Lines.Add('SearchUserCommand  :  ' + DateTimeToStr(now()));
   except
      Memo1.Lines.Add('Error in SearchUserCommand  :  '  + DateTimeToStr(now()));
   end;
end;


procedure TForm1.IdTCPServer1TIdCH_DeleteAccountCommand(
  ASender: TIdCommand);
var
   js: TlkJSONobject;
   JSLogin, ClientMessage: string;
begin
   ClientMessage := ASender.UnparsedParams;
   try
      js := TlkJSONobject.Create;
      js := TlkJSON.ParseText(ClientMessage) as TlkJSONobject;
      JSLogin := js.getString('login');
      js.Free;
      WorkWithDB.DeleteAccount(JSLogin);
      Memo1.Lines.Add('DeleteAccountCommand  :  ' + DateTimeToStr(now()));
   except
      Memo1.Lines.Add('Error in DeleteAccountCommand  :  '  + DateTimeToStr(now()));
   end;
end;

procedure TForm1.IdTCPServer1TIdCH_LogOutCommand(ASender: TIdCommand);
var
   js: TlkJSONobject;
   JSLogin, JSPassword, ClientMessage: string;
begin
   ClientMessage := ASender.UnparsedParams;
   try
      js := TlkJSONobject.Create;
      js := TlkJSON.ParseText(ClientMessage) as TlkJSONobject;
      JSLogin := js.getString('login');
      JSPassword := js.getString('password');
      js.Free;
      WorkWithDB.LogoutUser(JSLogin, JSPassword);
      Memo1.Lines.Add('LogOutCommand  :  ' + DateTimeToStr(now()));
   except
       Memo1.Lines.Add('Error in LogoutCommand  :  '  + DateTimeToStr(now()));
   end;
end;
procedure TForm1.N1Click(Sender: TObject);
begin
   MessageBox(handle, PChar('Server - 19.05.2016' + #13#13#10 + 'Сидоренко Вячеслав 551006'),PChar('О программе'), MB_ICONASTERISK+MB_DEFBUTTON2)
end;

end.

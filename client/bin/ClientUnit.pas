unit ClientUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ScktComp, IniFiles, ComCtrls, WinSock, uLkJSON, Menus,
  ExtCtrls, IdTCPConnection, IdTCPClient, IdBaseComponent, IdComponent, UserUtil,
  IdTCPServer, CoolTrayIcon, ImgList, sSkinManager, sButton;

type
  TServerIni = class(TIniFile)
  public
    procedure clearLogin;
    constructor Create;
  end;

  TClientForm = class(TForm)
    StatusBar1: TStatusBar;
    ListBox1: TListBox;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    About1: TMenuItem;
    Setting1: TMenuItem;
    CenterPanel: TPanel;
    Label3: TLabel;
    MessagesMemo: TMemo;
    MessageMemo: TMemo;
    SendButton: TButton;
    UpdateContactsTimer: TTimer;
    TempMemo: TMemo;
    Label4: TLabel;
    IdTCPServerClient: TIdTCPClient;
    SearchUser: TEdit;
    SearchUserButton: TButton;
    IdTCPServerServer: TIdTCPServer;
    IdTCPClientWithServerWork: TIdTCPClient;
    Label5: TLabel;
    PopupMenu1: TPopupMenu;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    ImageList1: TImageList;
    PopupMenu2: TPopupMenu;
    CoolTrayIcon1: TCoolTrayIcon;
    N1: TMenuItem;
    N5: TMenuItem;
    Panel2: TPanel;
    Panel1: TPanel;

    procedure StartWork(TempLogin, TempPass: string);
    function RegisterNewUser(TempLogin, TempPass: string): boolean;
    function SendLoginAndPass(TempLogin, TempPass: string): boolean;
    procedure WorkWhisSaveData(var TempLogin, TempPass: string);
    procedure WorkWhisServerData;
    procedure WorkWithSettings;
    procedure LogOut;

    procedure NewMessages(status: boolean);
    procedure LoadUser(login, ip: string; port: word; status: byte);
    procedure LoadHistory(login: string);
    function CheckNewUser(login, ip: string; port: word): boolean;
    procedure CheckListBox;
    procedure WorkWithUser(TempUser: TUser);
    procedure ErrorWithServer;
    procedure WorkWithAddToFriend(UsIp, UsPort, UsLogin, UsStatus, UsNamem, UsId: string);
    procedure UpdateUserFriends;

    procedure ListBox1DblClick(Sender: TObject);
    procedure UpdateContactsTimerTimer(Sender: TObject);
    procedure SearchUserButtonClick(Sender: TObject);
    procedure IdTCPServerServerTIdCH_ReadMessageCommand(
      ASender: TIdCommand);
    procedure SendButtonClick(Sender: TObject);
    procedure IdTCPServerServerTIdCH_AddFriendCommand(ASender: TIdCommand);
    procedure ListBox1Click(Sender: TObject);
    procedure ListBox1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure Setting1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormActivate(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure About1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CoolTrayIcon1DblClick(Sender: TObject);
    procedure FormPaint(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormDestroy(Sender: TObject);
    procedure MessagesMemoChange(Sender: TObject);
    procedure MessagesMemoMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Panel2Click(Sender: TObject);
    procedure Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel1Click(Sender: TObject);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormResize(Sender: TObject);
    procedure MessageMemoKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure MessageMemoKeyPress(Sender: TObject; var Key: Char);
private
    { Private declarations }
public

end;
   UsInfo = record
      id: integer;
      login: string[40];
      ip: string[15];
      port: word;
      status: byte;
      NewMessages: integer;
   end;

   TUsers = class(TObject)
   private
      function FindUser(login: string): integer;
      function FindUserByLogin(login: string): TUser;
   public
      AllUsers: TList;
      constructor Create;
      function UsersCount: integer;
      function UserMessages(id: integer): string;
      function CheckUserLogin(login: string): boolean;
      procedure DeleteMessages(id: integer);
      procedure DeleteUser(login: string);
      procedure AddMessage(owner, login, text: string);
      procedure AddUser(login, ip: string; port: word; status: byte);
      procedure UpdateUser(login, ip: string; port: word; status: byte);
      procedure UpdateMessages(owner, login, text: string);
   end;

var
   ClientForm: TClientForm;
   Users: TUsers;

   UserLogin, UserAddr, ServAddr, UserPass: string;
   UserPort, ServPort: integer;

   Settings: TSettings;

   ActiveUser: TUser;
   Err, ServError, FirstActive: boolean;

   ini: TServerIni;

implementation

uses SettingUnit, LoginUnit;

{$R *.dfm}

///// TUSERS /////////////////////////////////////////////////

constructor TUsers.Create;
begin
   self.AllUsers := TList.Create;
end;

function TUsers.UsersCount: integer;
begin
   UsersCount := AllUsers.Count;
end;

procedure TUsers.AddUser(login, ip: string; port: word; status: byte);
begin
   AllUsers.Add(TUser.Create(login, ip, port, status));
end;

function TUsers.CheckUserLogin(login: string): boolean;
var
   i: integer;
begin
   CheckUserLogin := false;
   if AllUsers.Count > 0 then
   begin
     for i := 0 to AllUsers.Count - 1 do
      if login = TUser(AllUsers[i]).login then
      begin
         CheckUserLogin := true;
         break;
      end;
   end;
end;

function TUsers.FindUser(login: string): integer;
var
   i: integer;
begin
   Result := -1;
   if AllUsers.Count > 0 then
   begin
   for i := 0 to AllUsers.Count - 1 do
      if login = TUser(AllUsers[i]).login then
      begin
         FindUser := i;
         break;
      end;
   end;
end;

function TUsers.FindUserByLogin(login: string): TUser;
var
   i: integer;
begin
   Result := nil;
   if AllUsers.Count > 0 then
   begin
   for i := 0 to AllUsers.Count - 1 do
      if login = TUser(AllUsers[i]).login then
      begin
         Result := TUser(AllUsers[i]);
         break;
      end;
   end;
end;

procedure TUsers.UpdateUser(login, ip: string; port: word; status: byte);
var
   user: TUser;
begin
   user := FindUserByLogin(login);
   if user <> nil then
   begin
     user.ip := ip;
     user.port := port;
     user.status := status;
   end;
end;

procedure TUsers.DeleteUser(login: string);
var
   UserIndex: integer;
begin
   UserIndex := FindUser(login);
   if UserIndex > -1 then
     AllUsers.Delete(UserIndex);
end;


////// messages ///////

procedure TUsers.UpdateMessages(owner, login, text: string);
var
   User: TUser;
   OpFile: textfile;
   s: string;
begin
   User := FindUserByLogin(login);
   if User <> nil then
   begin
      user.Messages := user.Messages + text;
      s := '.\history\' + owner + '\' + login + '.txt';
      assignFile(OpFile, s);
      append(OpFile);
      writeln(OpFile, text);
      closeFile(OpFile);
   end;
end;

procedure TUsers.AddMessage(owner, login, text: string);
var
   User: TUser;
   OpFile: textfile;
begin
   User := FindUserByLogin(login);
   if User <> nil then
   begin
      inc(user.NewMessages);
      UpdateMessages(owner, login, text);
   end;
end;

function TUsers.UserMessages(id: integer): string;
begin
   UserMessages := TUser(AllUsers[id]).Messages;
end;

procedure TUsers.DeleteMessages(id: integer);
begin
   TUser(AllUsers[id]).Messages := '';
   TUser(AllUsers[id]).NewMessages := 0;
end;

///// WORK WITH CONTACT LIST /////////////////////////////////////////////////

procedure TClientForm.UpdateContactsTimerTimer(Sender: TObject);
var
   i: integer;
begin
   UpdateUserFriends;
   if Users.UsersCount > 0 then
   begin
     for i := 0 to Users.UsersCount - 1 do
     begin
         case TUser(Users.AllUsers[i]).status of
            1 : listbox1.Items[i] := TUser(Users.AllUsers[i]).login + ' ('+ inttostr(TUser(Users.AllUsers[i]).NewMessages) + ') - online';
            0 : listbox1.Items[i] := TUser(Users.AllUsers[i]).login + ' ('+ inttostr(TUser(Users.AllUsers[i]).NewMessages) + ') - offline';
         else
            listbox1.Items[i] := TUser(Users.AllUsers[i]).login + ' - unknow status';
         end;
      end;
   end
   else
      if messagesmemo.Text <> '' then
         messagesmemo.Text := '';
   CheckListBox;

   try
      if UpdateContactsTimer.Interval = 10 then
      begin
         if listbox1.Count > 0 then
         begin
            listbox1.ItemIndex := 0;
            ListBox1DblClick(self);
         end;
         UpdateContactsTimer.Interval := 1000;
      end;

      if (ActiveUser <> nil) and (ActiveUser.status = 1) then
      begin
         label4.Caption := ActiveUser.ip + '  /  ' + inttostr(ActiveUser.port) + '  /  online';
         SendButton.Enabled := true;
      end
      else
      begin
         label4.Caption := 'offline';
         SendButton.Enabled := false;
      end;
      if length(label4.Caption) > 9 then
         label4.Left := CenterPanel.width - 175
      else
         label4.Left := CenterPanel.width - 52;

   except
   end;
   StatusBar1.Panels[1].Text := ' ' + DateTimeToStr(now());
end;

procedure TClientForm.UpdateUserFriends;
var
   js: TlkJSONobject;
   JSList: TlkJSONlist;
   i: integer;
   resp, SendMessage: string;
   TempUser: TUser;
begin
   js := TlkJSONobject.Create;
   js.Add('login', UserLogin);
   SendMessage := TlkJSON.GenerateText(js);
   js.Free;

   with IdTCPClientWithServerWork do
   begin
      try
         connect;
         try
            writeln('ReadContactList '+ SendMessage);
            resp := Trim(readln);

            JSList := TlkJSONlist.Create;
            JSList := TlkJSON.ParseText(resp) as TlkJSONlist;
            if JSList.Count > 0 then
            begin
              for i := 0 to JSList.Count - 1 do
              begin
                 TempUser := TUser.Create('log', 'ip', 123, 0);
                 TempUser.fromString(TlkJSON.GenerateText(JSList.Child[i]));
                 WorkWithUser(TempUser);
              end;
              TempUser.Free;
            end;
            JSList.Free;

            finally
               disconnect;
            end;
      except
         ErrorWithServer;
      end;
   end;
end;

procedure TClientForm.WorkWithUser(TempUser: TUser);
begin
    LoadUser(TempUser.login, TempUser.ip, TempUser.port, TempUser.status);
end;

procedure TClientForm.CheckListBox;
var
   i: integer;
   UserLogin, PredLogin: string;
begin
   PredLogin := '';
   if listbox1.Items.Count > 0 then
   begin
     for i := 0 to listbox1.Items.Count - 1 do
     begin
        UserLogin := ListBox1.Items[i];
        delete(UserLogin, pos('(', UserLogin) - 1, length(UserLogin));
        if (not Users.CheckUserLogin(UserLogin)) or (UserLogin = PredLogin) then
           ListBox1.Items.Delete(i);
        PredLogin := UserLogin;
     end;
   end;
end;

procedure TClientForm.ListBox1DblClick(Sender: TObject);
var
   i: integer;
   TempUserLogin, TempMessage: string;
   TempUser: TUser;
begin
   TempUserLogin := ListBox1.Items[ListBox1.ItemIndex];
   delete(TempUserLogin, pos('(', TempUserLogin) - 1, length(TempUserLogin));
   ActiveUser := Users.FindUserByLogin(TempUserLogin);
   if ActiveUser <> nil then
   begin
      if  ActiveUser.status = 0 then
      begin
         label4.Caption := 'offline';
         SendButton.Enabled := false;
      end
      else
      begin
         label4.Caption := ActiveUser.ip + '  /  ' + inttostr(ActiveUser.port) + '  /  online';
         SendButton.Enabled := true;
      end;
      caption := 'Client - ' + UserLogin + ' - ' + TempUserLogin;
      LoadHistory(ActiveUser.login);
      label3.Caption := ActiveUser.login;
      MessagesMemo.SelStart:=Length(MessagesMemo.lines.text);
      MessagesMemo.perform(EM_LINESCROLL,0,MessagesMemo.lines.count);
   end;
   if length(label4.Caption) > 9 then
      label4.Left := CenterPanel.width - 175
   else
      label4.Left := CenterPanel.width - 52;
end;


///// WORK WITH HISTORY /////////////////////////////////////////////////

procedure TClientForm.LoadUser(login, ip: string; port: word; status: byte);
begin
   CreateDir('./history/' + UserLogin);
   if not FileExists('./history/' + UserLogin + '/' + login + '.txt') then
   begin
      TempMemo.Text := '';
      TempMemo.Lines.SaveToFile('./history/' + UserLogin + '/' + login + '.txt');
   end;

   if not Users.CheckUserLogin(login) then
   begin
      Users.AddUser(login, ip, port, status);
      try
         TempMemo.Lines.LoadFromFile('./history/' + UserLogin + '/' + login + '.txt');
      except
         TempMemo.Text := '';
         TempMemo.Lines.SaveToFile('./history/' + UserLogin + '/' + login + '.txt');
      end;
         TempMemo.Text := '';
   end
   else
      Users.UpdateUser(login, ip, port, status);
end;

procedure TClientForm.LoadHistory(login: string);
var
   i: integer;
begin
   CreateDir('./history/' + UserLogin);
   i := Users.FindUser(login);

   if length(Users.UserMessages(i)) <> 0 then
   begin
      Users.DeleteMessages(i);
   end;

   try
      MessagesMemo.Lines.LoadFromFile('./history/' + UserLogin + '/' + login + '.txt');
   except
      TempMemo.Text := '';
      TempMemo.Lines.SaveToFile('./history/' + UserLogin + '/' + login + '.txt');
   end;
end;


///// WORK WITH CLIENT MESSAGES /////////////////////////////////////////////////

procedure TClientForm.IdTCPServerServerTIdCH_ReadMessageCommand(
  ASender: TIdCommand);
var
   js: TlkJSONobject;
   ClientMessage, JSLoginTo, JSLoginSender, JSMessage: string;
begin
   ClientMessage := ASender.UnparsedParams;
   try
      js := TlkJSONobject.Create;
      js := TlkJSON.ParseText(ClientMessage) as TlkJSONobject;
      JSMessage := js.getString('message');
      JSLoginTo := js.getString('LoginTo');
      JSLoginSender := js.getString('SendLogin');
      js.Free;

      if Users.CheckUserLogin(JSLoginSender) then
      begin
         NewMessages(true);
         if Settings.NewMessages then
            CoolTrayIcon1.ShowBalloonHint('Новое сообщение от ' + Copy(JSLoginSender, 1, 20), Copy(Trim(JSMessage), 1, 70) + '...', bitInfo, 11);
      end;

      if JSLoginSender = ActiveUser.login then
      begin
         MessagesMemo.Lines.Add(JSLoginSender + ' : ' + DateTimeToStr(now()));
         MessagesMemo.Lines.Add(JSMessage);
         MessagesMemo.Lines.Add('');

         TempMemo.Text := '';
         TempMemo.Lines.Add(JSLoginSender + ' : ' + DateTimeToStr(now()));
         TempMemo.Lines.Add(JSMessage);
         TempMemo.Lines.Add('');
         Users.UpdateMessages(UserLogin, JSLoginSender, TempMemo.Text);
      end
      else
      begin
         if Users.CheckUserLogin(JSLoginSender) then
         begin
            TempMemo.Text := '';
            TempMemo.Lines.Add(JSLoginSender + ' : ' + DateTimeToStr(now()));
            TempMemo.Lines.Add(JSMessage);
            TempMemo.Lines.Add('');
            Users.AddMessage(UserLogin, JSLoginSender, TempMemo.Text);
         end;
      end;
   except
      MessageMemo.text := '';
      MessagesMemo.Lines.Add('!>> Ошибка! Присланное сообщение не было прочитанно и выведено из-за его неверного формата.');
      MessagesMemo.Lines.Add('');
   end;
end;

procedure TClientForm.SendButtonClick(Sender: TObject);
var
   js: TlkJSONobject;
   resp, SendMessage, SendMsg, UsName, UsLogin, UsPort, UsIp, UsStatus, UsId: string;
   UserFormResult: integer;
begin
   IdTCPServerClient.Host := ActiveUser.ip;
   IdTCPServerClient.Port := ActiveUser.port;
   SendMsg := MessageMemo.text;
   SendMessage := SendMsg;

   if (Length(SendMsg) > 2) and (ActiveUser.status = 1) then
   begin
      js := TlkJSONobject.Create;
      js.Add('message', SendMsg);
      js.Add('SendLogin', UserLogin);         // от кого
      js.Add('LoginTo', ActiveUser.login);    // кому
      SendMsg := TlkJSON.GenerateText(js);
      js.Free;

      with IdTCPServerClient do
      begin
         try
            connect;
             try
               writeln('ReadMessage '+ SendMsg);
               MessageMemo.text := '';

               MessagesMemo.Lines.Add(UserLogin + ' : ' + DateTimeToStr(now()));
               MessagesMemo.Lines.Add(SendMessage);
               MessagesMemo.Lines.Add('');

              TempMemo.Text := '';
              TempMemo.Lines.Add(UserLogin + ' : ' + DateTimeToStr(now()));
              TempMemo.Lines.Add(SendMessage);
              TempMemo.Lines.Add('');
              Users.UpdateMessages(UserLogin, ActiveUser.login, TempMemo.Text);
            finally
               disconnect;
            end;
         except
            MessageMemo.Lines.Delete(MessageMemo.Lines.Count);
            MessageMemo.Lines.Delete(MessageMemo.Lines.Count);
            MessageMemo.Lines.Delete(MessageMemo.Lines.Count);
            MessageMemo.Lines.Delete(MessageMemo.Lines.Count);
            MessageMemo.text := '';
            MessagesMemo.Lines.Add('!>> Ошибка! Cообщение не было отправленно из-за неполадок со связью. Попробуйте еще раз.');
            MessagesMemo.Lines.Add('');
         end;
      end;
   end;
end;



///// Add To Friend and delete friend /////////////////////////////////////////////////

procedure TClientForm.N3Click(Sender: TObject);
var
   str: string;
   DeleteFile: textFile;
   MBResult: integer;
begin
   str := 'Вы уверены, что хотите удалить всю свою переписку с пользователем ' + ActiveUser.login;
   MBResult := MessageBox(handle, PChar(str),PChar('Удаление истории'), MB_ICONERROR+MB_OKCANCEL);
   if MBResult = mrOK then
   begin
      str := './history/' + UserLogin + '/' + ActiveUser.login + '.txt';
      MessagesMemo.text := '';
      assignFile(DeleteFile, str);
      rewrite(DeleteFile);
      closeFile(DeleteFile);
   end;
end;


procedure TClientForm.N2Click(Sender: TObject);
var
   js: TlkJSONobject;
   MBResult: integer;
   str, SendMessage: string;
begin
   if (ActiveUser <> nil) and (ActiveUser.login <> '') then
   begin
      str := 'Вы уверены, что хотите удалить пользователя ' + ActiveUser.login + ' из своего списка контактов?';
      MBResult := MessageBox(handle, PChar(str),PChar('Удаление контакта'), MB_ICONERROR+MB_OKCANCEL);
      if MBResult = mrOK then
      begin
         js := TlkJSONobject.Create;
         js.Add('login1', UserLogin);
         js.Add('login2', ActiveUser.login);
         SendMessage := TlkJSON.GenerateText(js);
         with IdTCPClientWithServerWork do
         begin
            try
               connect;
               try
                  Users.DeleteUser(ActiveUser.login);
                  writeln('DeleteFriend '+ SendMessage);
               finally
                  disconnect;
               end;
            except
               MessageBox(handle, PChar('Ошибка соединения с сервером. Скорее всего она связана с его недоступностью.'),PChar('Ошибка соединения'), MB_ICONERROR+MB_DEFBUTTON2);
            end;
         end;
      end;
   end;
end;


procedure TClientForm.SearchUserButtonClick(Sender: TObject);
var
   js: TlkJSONobject;
   resp, SendMessage, UsName, UsLogin, UsPort, UsIp, UsStatus, UsId: string;
   UserFormResult: integer;
   usl: boolean;
begin
   usl := false;
   if (SearchUser.Text <> '') then
   begin
      UsLogin := SearchUser.Text;
      js := TlkJSONobject.Create;
      js.Add('login', UsLogin);
      SendMessage := TlkJSON.GenerateText(js);
      js.Free;

      with IdTCPClientWithServerWork do
      begin
         try
            connect;
            try
               writeln('SearchUser '+ SendMessage);
               resp := Trim(readln);
               js := TlkJSONobject.Create;
               js := TlkJSON.ParseText(resp) as TlkJSONobject;
               UsIp := js.getString('ip');
               UsName := js.getString('name');
               UsStatus := js.getString('status');
               UsPort := js.getString('port');
               UsId := js.getString('id');
               js.Free;
               usl := true;
            finally
               disconnect;
            end;
         except
            usl := false;
            MessageBox(handle, PChar('Ошибка соединения с сервером. Скорее всего она связана с его недоступностью.'),PChar('Ошибка соединения'), MB_ICONERROR+MB_DEFBUTTON2);
         end;
      end;
   end;
   if usl then
   begin
      try
         WorkWithAddToFriend(UsIp, UsPort, UsLogin, UsStatus, UsName, UsId);
      except
      end;
   end;
end;

procedure TClientForm.WorkWithAddToFriend(UsIp, UsPort, UsLogin, UsStatus, UsNamem, UsId: string);
var
   UserFormResult: integer;
   js: TlkJSONobject;
   SendMessage, resp: string;
   Status: string;
   MBType: boolean;
   JSAnswer, usl: boolean;
begin
   MBType := false;
   usl := false;
   if UsStatus = '3' then
   begin
      Status := 'Такого пользователя не существует!';
      MBType := false;
   end
   else
      if UsStatus <> '1' then
      begin
         Status := 'Пользователь сейчас не в сети, вы не можете ему отправить заявку.';
         MBType := false;
      end
      else
         if UsStatus = '1' then
         begin
            MBType := true;
            Status := 'Пользователь в сети. Отправить ему заявку?';
         end
         else
         begin
            MBType := false;
            Status := 'Неизвестный статус пользователя';
         end;

   if Users.CheckUserLogin(UsLogin) then
   begin
      MBType := false;
      Status := 'Этот пользователь уже есть у вас в друзьях';
   end;

   if UsLogin = UserLogin then
   begin
      Status := 'Да это же вы! К сожалению добавить себя в друзья нельзя.';
      MBType := false;
   end;

   if MBType then
      UserFormResult := MessageBox(handle, PChar('Поиск: ' + UsLogin + #10#13 + Status),PChar('Результаты поиска'), MB_ICONASTERISK+MB_OKCANCEL)
   else
      UserFormResult := MessageBox(handle, PChar('Поиск: ' + UsLogin + #10#13 + Status),PChar('Результаты поиска'), MB_ICONASTERISK+MB_OK);

   if (UserFormResult = mrOk) and MBType then
   begin
   try
      IdTCPServerClient.Host := UsIp;
      IdTCPServerClient.Port := strtoint(UsPort);

      js := TlkJSONobject.Create;
      js.Add('name', 'NAME_TEMP');
      js.Add('login', UserLogin);
      SendMessage := TlkJSON.GenerateText(js);
      js.Free;

      with IdTCPServerClient do
      begin
         try
            connect;
               try
                  writeln('AddFriend '+ SendMessage);
                  resp := Trim(readln);
                  js := TlkJSONobject.Create;
                  js := TlkJSON.ParseText(resp) as TlkJSONobject;
                  JSAnswer := strtobool(js.getString('answer'));
                  js.Free;
                  usl := true;
                finally
                  disconnect;
               end;
         except
            usl := false;
            MessageBox(handle, PChar('Ошибка соединения с пользователем. Скорее всего она связана с его недоступностью, либо неактуальностью данных на сервере. Попробуйте через минуту еще раз.'),PChar('Ошибка соединения'), MB_ICONERROR+MB_DEFBUTTON2);
         end;
      end;
   except

   end;

   end;

   if usl and MBType and JSAnswer then
   begin
      js := TlkJSONobject.Create;
      js.Add('login1', UserLogin);
      js.Add('login2', UsLogin);
      SendMessage := TlkJSON.GenerateText(js);
      js.Free;
      UpdateContactsTimer.Enabled := false;
      with IdTCPClientWithServerWork do
      begin
         try
            connect;
            try
               writeln('AddFriend '+ SendMessage);
            finally
               disconnect;
            end;
         except
            ErrorWithServer;
         end;
      end;
   end;
   if usl and MBType then
      if JSAnswer then
         MessageBox(handle, PChar('Пользователь ' + UsLogin + ' принял вашу заявку.'),PChar('Подтверждение заявки'), MB_ICONASTERISK+MB_OK)
      else
         MessageBox(handle, PChar('Пользователь ' + UsLogin + ' отклонил ваш запрос.'),PChar('Подтверждение заявки'), MB_ICONASTERISK+MB_OK);

   UpdateContactsTimer.Enabled := true;
   SearchUser.Text := '';
end;


procedure TClientForm.IdTCPServerServerTIdCH_AddFriendCommand(
  ASender: TIdCommand);
var
   js: TlkJSONobject;
   JSLogin, ClientMessage, JSName: string;
   JSAnswer: boolean;
   UserFormResult: integer;
begin
   ClientMessage := ASender.UnparsedParams;
   try
      js := TlkJSONobject.Create;
      js := TlkJSON.ParseText(ClientMessage) as TlkJSONobject;
      JSLogin := js.getString('login');
      JSName := js.getString('name');
      js.Free;

      if Settings.NewFriends then
      begin
         UserFormResult := MessageBox(handle, PChar('Пользователь '+ JSLogin + ' хочет добавить вас в друзья. Вы согласны?'),PChar('Заявка в друзья'), MB_ICONASTERISK+MB_YESNO);
         JSAnswer := UserFormResult = mrYES;
      end
      else
         JSAnswer := false;

      js := TlkJSONobject.Create;
      js.Add('answer', booltostr(JSAnswer));
      ClientMessage := TlkJSON.GenerateText(js);
      js.Free;

      ASender.Response.Add(ClientMessage);
   except
      MessageBox(handle, PChar('Ошибка соединения с пользователем. Скорее всего она связана с его недоступностью, либо неактуальностью данных на сервере. Попробуйте через минуту еще раз.'),PChar('Ошибка соединения'), MB_ICONERROR+MB_DEFBUTTON2);
   end;
end;



///// WORK WITH SERVER /////////////////////////////////////////////////


function TClientForm.SendLoginAndPass(TempLogin, TempPass: string): boolean;
var
   js: TlkJSONobject;
   SendMessage: string;
begin
   SendLoginAndPass := false;
   if (TempLogin <> '') and (TempPass <> '') then
   begin
      js := TlkJSONobject.Create;
      js.Add('login', TempLogin);
      js.Add('pass', TempPass);
      js.Add('port', inttostr(UserPort));
      SendMessage := TlkJSON.GenerateText(js);
      js.Free;

      with IdTCPClientWithServerWork do
      begin
         connect;
         try
            writeln('Login '+ SendMessage);
            SendMessage := Trim(readln);

            js := TlkJSONobject.Create;
            js := TlkJSON.ParseText(SendMessage) as TlkJSONobject;
            SendLoginAndPass := strtobool(js.getString('answer'));
            UserAddr := js.getString('ip');
            js.Free;
         finally
            disconnect;
         end;
      end;
   end;
end;

function TClientForm.RegisterNewUser(TempLogin, TempPass: string): boolean;
var
   js: TlkJSONobject;
   SendMessage: string;
begin
   RegisterNewUser := false;
   if (TempLogin <> '') and (TempPass <> '') then
   begin
      js := TlkJSONobject.Create;
      js.Add('login', TempLogin);
      js.Add('pass', TempPass);
      SendMessage := TlkJSON.GenerateText(js);
      js.Free;

      with IdTCPClientWithServerWork do
      begin
         connect;
         try
            writeln('Registration '+ SendMessage);
            SendMessage := Trim(readln);
            js := TlkJSONobject.Create;
            js := TlkJSON.ParseText(SendMessage) as TlkJSONobject;
            RegisterNewUser := strtobool(js.getString('answer'));
            js.Free;
         finally
            disconnect;
         end;
      end;
   end;
end;



///// WORK WITH FILES /////////////////////////////////////////////////

procedure TClientForm.WorkWithSettings;
begin
   Settings := TSettings.Create(ini.Readinteger('settings', 'NewMessages', 1), ini.Readinteger('settings', 'NewFriends', 1));
   Settings.SendMessage := ini.Readinteger('settings', 'SendMessage', 13);
   Settings.NextUser := ini.Readinteger('settings', 'NextUser', 114);
   Settings.PredUser := ini.Readinteger('settings', 'PredUser', 113);
end;

procedure TClientForm.WorkWhisSaveData(var TempLogin, TempPass: string);
begin
   TempLogin := ini.ReadString('client', 'login', '');
   TempPass := ini.ReadString('client', 'pass', '');
end;

procedure TClientForm.WorkWhisServerData;
begin
   ServAddr := ini.ReadString('server', 'ip', '127.0.0.1');
   ServPort := strtoint(ini.ReadString('server', 'port', '3033'));

 // TEMP
   UserPort := strtoint(ini.ReadString('client', 'port', '3040'));
end;



///// OTHER /////////////////////////////////////////////////

function TClientForm.CheckNewUser(login, ip: string; port: word): boolean;
var
   i: integer;
begin
   CheckNewUser := true;
   if Users.UsersCount > 0 then
   begin
     for i := 0 to Users.UsersCount - 1 do
     begin
        if (port = TUser(Users.AllUsers[i]).port) and (ip = TUser(Users.AllUsers[i]).ip) then
        begin
           CheckNewUser := false;
           break;
        end;
     end;
   end;
end;


procedure TClientForm.ListBox1Click(Sender: TObject);
begin
   ListBox1DblClick(self)
end;

procedure TClientForm.ListBox1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
  point : TPoint;
  index : integer;
begin
   if (Button = mbRight) then
   begin
      point.X := X;
      point.Y := Y;
      index := ListBox1.ItemAtPos(point, true);
      if index >= 0 then
      begin
         ListBox1.Selected[index] := true;
         ListBox1DblClick(self);
         PopupMenu1.Popup(
         ListBox1.ClientOrigin.X + X,
         ListBox1.ClientOrigin.Y + Y);
      end;
   end;
end;

procedure TClientForm.Setting1Click(Sender: TObject);
var
   js: TlkJSONobject;
   SendMessage: string;
begin
   SettingUnit.UserLogin := UserLogin;
   SettingUnit.Settings := Settings;
   SettingForm.Showmodal;
   Settings := SettingUnit.Settings;
   if SettingUnit.DeleteAccount then
   begin
      js := TlkJSONobject.Create;
      js.Add('login', UserLogin);
      SendMessage := TlkJSON.GenerateText(js);
      js.Free;
      with IdTCPClientWithServerWork do
      begin
         try
            connect;
            try
               writeln('DeleteAccount '+ SendMessage);
               UpdateContactsTimer.Enabled := false;
               FormActivate(self);
            finally
               disconnect;
            end;
         except
            MessageBox(handle, PChar('Ошибка соединения с сервером. Скорее всего она связана с его недоступностью.'),PChar('Ошибка соединения'), MB_ICONERROR+MB_DEFBUTTON2);
         end;
      end;
      close;
   end;
end;

procedure TClientForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if CoolTrayIcon1.CycleIcons then
      NewMessages(false);

   if (key = Settings.NextUser) then
      if listbox1.ItemIndex < listbox1.Count then
      begin
          listbox1.ItemIndex := listbox1.ItemIndex + 1;
          ListBox1DblClick(self);
      end;

   if (key = Settings.PredUser) then
      if listbox1.ItemIndex <> 0 then
      begin
          listbox1.ItemIndex := listbox1.ItemIndex - 1;
          ListBox1DblClick(self);
      end;

   if (key = Settings.SendMessage) then
      if MessagesMemo.Text <> '' then
      begin
          SendButtonClick(self);
      end;
end;

procedure TClientForm.ErrorWithServer;
begin
   if not ServError then
   begin
      ServError := true;
      Err := true;
      FirstActive := true;
      UpdateContactsTimer.Enabled := false;
      FormActivate(self);
    end;
end;

procedure TClientForm.StartWork(TempLogin, TempPass: string);
begin
   ServError := false;
   Users := TUsers.Create;
   UserLogin := TempLogin;
   UserPass := TempPass;
   Label3.Caption := 'Имя пользователя';
   Label4.Caption := 'Его данные';
   caption := 'Client - ' + UserLogin;
   Application.Title := 'Client - ' + UserLogin;
   StatusBar1.Panels[0].Text := ' Пользователь:  ' +  UserLogin + '      IP:  ' +  UserAddr + '      Порт:  ' +  inttostr(UserPort);
   UpdateContactsTimer.Interval := 10;
   UpdateContactsTimer.Enabled := true;
   IdTCPServerServer.DefaultPort := UserPort;
   IdTCPServerServer.Active := true;
end;

procedure TClientForm.FormActivate(Sender: TObject);
var
   js: TlkJSONobject;
   SendMessage, TempLogin, TempPass: string;
   JSAnswer: boolean;
   res: integer;
begin
if FirstActive then
begin
   if ServError then
      TempLogin := ''
   else
      WorkWhisSaveData(TempLogin, TempPass);

   WorkWhisServerData;
   WorkWithSettings;
 //  FindOpenPort;

   IdTCPClientWithServerWork.Host := ServAddr;
   IdTCPClientWithServerWork.Port := ServPort;
   try
      if SendLoginAndPass(TempLogin, TempPass) then
      begin
         StartWork(TempLogin, TempPass);
      end
      else
      begin
         LoginForm.LoginEdit.Text := TempLogin;
         LoginForm.PassEdit.Text := TempPass;
        // LoginForm.InfoLabel.Caption := 'Возникли проблемы в работе программы.' + #13#10 + '    Попробуйте войти в систему еще раз';
         res := LoginForm.ShowModal;
         if res = mrOk then
         begin
            if ServError then
            begin
               listbox1.Clear;
               Users.AllUsers.Clear;
            end;
            TempLogin := LoginForm.LoginEdit.Text;
            TempPass := LoginForm.PassEdit.Text;
            StartWork(TempLogin, TempPass);
         end
         else
         begin
            if Err then
               close;
            if ServError then
            begin
               UpdateContactsTimer.Enabled := true;
            end
            else
               close;
         end;
      end;
   except
      LoginForm.LoginEdit.Text := TempLogin;
      LoginForm.PassEdit.Text := TempPass;
      LoginForm.InfoLabel.Caption :=  'Возникли проблемы в работе программы.' + #13#10 + '    Попробуйте войти в систему еще раз';
      res := LoginForm.ShowModal;
      try
         if res = mrOk then
         begin
            TempLogin := LoginForm.LoginEdit.Text;
            TempPass := LoginForm.PassEdit.Text;
            StartWork(TempLogin, TempPass)
         end
         else
            close;
     except

     end;
   end;
   FirstActive := false;
end;
end;

procedure TClientForm.N4Click(Sender: TObject);
begin
   UpdateContactsTimer.Enabled := false;
//   MessagesMemo.Text := '';
   ServError := true;
   FirstActive := true;
   FormActivate(self);
end;

procedure TClientForm.About1Click(Sender: TObject);
begin
   MessageBox(handle, PChar('Client - 19.05.2016' + #13#13#10 + 'Сидоренко Вячеслав 551006'),PChar('Client - О программе'), MB_ICONASTERISK+MB_DEFBUTTON2)
end;

procedure TClientForm.NewMessages(status: boolean);
begin
   if status then
   begin
      CoolTrayIcon1.CycleInterval := 700;
      CoolTrayIcon1.CycleIcons := true;
      CoolTrayIcon1.Hint := 'Есть непрочитанные сообщения!';
      CoolTrayIcon1.Refresh;
   end
   else
   begin
   try
      if CoolTrayIcon1.CycleIcons then
      begin
         CoolTrayIcon1.CycleIcons := false;
         CoolTrayIcon1.CycleInterval := 0;
         CoolTrayIcon1.IconIndex := 0;
         CoolTrayIcon1.Hint := 'Новых сообщений нет!';
         CoolTrayIcon1.Refresh;
      end;
   except
   end;
   end;
end;


procedure TClientForm.FormCreate(Sender: TObject);
begin
   Err := false;
   FirstActive := true;
   CoolTrayIcon1.ShowHint := true;
   ini := TServerIni.Create;
end;

procedure TClientForm.CoolTrayIcon1DblClick(Sender: TObject);
begin
   CoolTrayIcon1.ShowMainForm;
end;

procedure TClientForm.FormPaint(Sender: TObject);
begin
   NewMessages(false);
end;

procedure TClientForm.N5Click(Sender: TObject);
begin
   close;
end;

procedure TClientForm.N1Click(Sender: TObject);
begin
   CoolTrayIcon1.ShowMainForm;
end;

procedure TClientForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   if CoolTrayIcon1.CycleIcons then
      NewMessages(false);
   panel2.Color := rgb(229,237,241);
   Panel1.Color := rgb(229,237,241);
end;

procedure TClientForm.LogOut;
var
   js: TlkJSONobject;
   resp, SendMessage: string;
begin
   if (UserLogin <> '') and (UserPass <> '') then
   begin
      js := TlkJSONobject.Create;
      js.Add('login', UserLogin);
      js.Add('password', UserPass);
      SendMessage := TlkJSON.GenerateText(js);
      js.Free;

      with IdTCPClientWithServerWork do
      begin
         try
            connect;
            writeln('Logout '+ SendMessage);
         except
            ErrorWithServer;
         end;
      end;
   end;
end;

procedure TClientForm.FormDestroy(Sender: TObject);
begin
try
   LogOut;
except
end;
end;

  constructor TServerIni.Create;
  begin
    inherited Create('.\data\SettingsData.ini');
  end;

  procedure TServerIni.clearLogin;
  begin
    self.WriteString('client', 'Login', '');
    self.WriteString('client', 'Pass', '');
  end;

procedure TClientForm.MessagesMemoChange(Sender: TObject);
begin
   HideCaret(MessagesMemo.Handle);
end;

procedure TClientForm.MessagesMemoMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
   HideCaret(MessagesMemo.Handle);
end;

procedure TClientForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
try
   UpdateContactsTimer.Enabled := false;
   Users.AllUsers.Clear;
   Users.Free;
   CoolTrayIcon1.Free;
except
end;
end;

procedure TClientForm.Panel2Click(Sender: TObject);
begin
   SearchUserButtonClick(self);
end;

procedure TClientForm.Panel2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
   Tpanel(sender).Color := rgb(212,229,237);
   Tpanel(sender).Cursor := crHandPoint;
end;

procedure TClientForm.Panel1Click(Sender: TObject);
begin
   SendButtonClick(self)
end;

procedure TClientForm.Panel1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
   if SendButton.Enabled then
   begin
      Tpanel(sender).Color := rgb(212,229,237);
      Tpanel(sender).Cursor := crHandPoint;
   end
   else
      Tpanel(sender).Cursor := crDefault
end;

procedure TClientForm.FormResize(Sender: TObject);
begin
   CenterPanel.width := ClientForm.ClientWidth - 200;
   CenterPanel.height := ClientForm.ClientHeight - 19;
   MessagesMemo.Width := CenterPanel.width - 30;
   MessageMemo.Width := CenterPanel.width - 30;
   panel1.Left := CenterPanel.width - 168;
   statusbar1.Panels[0].Width := CenterPanel.width + 30;
   if length(label4.Caption) < 8 then
      label4.Left := CenterPanel.width - 52
   else
      label4.Left := CenterPanel.width - 175;

end;

procedure TClientForm.MessageMemoKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if CoolTrayIcon1.CycleIcons then
      NewMessages(false);

   if (key = Settings.NextUser) then
      if listbox1.ItemIndex < listbox1.Count then
      begin
          listbox1.ItemIndex := listbox1.ItemIndex + 1;
          ListBox1DblClick(self);
      end;

   if (key = Settings.PredUser) then
      if listbox1.ItemIndex <> 0 then
      begin
          listbox1.ItemIndex := listbox1.ItemIndex - 1;
          ListBox1DblClick(self);
      end;

   if (key = Settings.SendMessage) then
      if MessagesMemo.Text <> '' then
      begin
          SendButtonClick(self);
      end;
end;

procedure TClientForm.MessageMemoKeyPress(Sender: TObject; var Key: Char);
begin
   if length(MessageMemo.Text) > 1 then
      if (MessageMemo.Text[length(MessageMemo.Text) - 1] = key) and (key = #13) then
         key := #0;
end;

end.


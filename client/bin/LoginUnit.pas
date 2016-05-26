unit LoginUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, IniFiles, IdTCPServer, IdBaseComponent, IdComponent,
  IdTCPConnection, IdTCPClient, ScktComp, WinSock, uLkJSON, ExtCtrls,
  Menus, UserUtil;

type
  TLoginForm = class(TForm)
    LoginEdit: TEdit;
    PassEdit: TEdit;
    LoginButton: TButton;
    SaveData: TCheckBox;
    InfoLabel: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Panel1: TPanel;
    RegisterButton: TButton;
    RegLoginEdit: TEdit;
    RegPass1Edit: TEdit;
    RegPass2Edit: TEdit;
    RegLoginLabel: TLabel;
    RegPassLabel: TLabel;
    Button2: TButton;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    MainMenu1: TMainMenu;
    G1: TMenuItem;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;

    procedure SaveNewData;
    procedure ClearData;
    function CheckAllEdits: boolean;
    procedure LoginButtonClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure RegisterButtonClick(Sender: TObject);
    procedure G1Click(Sender: TObject);
    procedure LoginEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormShow(Sender: TObject);
    procedure RegLoginEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel2Click(Sender: TObject);
    procedure Panel3Click(Sender: TObject);
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel4Click(Sender: TObject);
    procedure Panel5Click(Sender: TObject);
    procedure RegLoginEditKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
   LoginForm: TLoginForm;

implementation

uses ClientUnit;

{$R *.dfm}

//////  Start work  //////////////////////////////////////////

procedure TLoginForm.SaveNewData;
begin
   ini.clearLogin;
   ini.WriteString('client', 'login', LoginEdit.Text);
   ini.WriteString('client', 'pass', PassEdit.Text);
end;

procedure TLoginForm.ClearData;
begin
  ini.clearLogin;
end;


//////  Register and login work  //////////////////////////////////////////

procedure TLoginForm.RegisterButtonClick(Sender: TObject);
var
   js: TlkJSONobject;
   resp, SendMessage: string;
   JSAnswer: boolean;
begin
   if CheckAllEdits then
   begin
      try
         if ClientForm.RegisterNewUser(RegLoginEdit.Text, RegPass1Edit.Text) then
         begin
            panel1.Visible := false;
            RegLoginEdit.Text := '';
            RegPass1Edit.Text := '';
            RegPass2Edit.Text := '';
            label9.Caption := '';
            LoginForm.Caption := 'Вход в систему';
            MessageBox(handle, PChar('Ваш аккаут был успешно создан!'+ #13#10#13#10 + 'Теперь введить ваш логин и пароль, чтобы подтвердить создание аккаунта и войти на него.'),PChar('Регистрация'), MB_ICONASTERISK+MB_DEFBUTTON2);
            panel2.Visible := true;
            panel3.Visible := true;
            InfoLabel.Caption := '';
         end
         else
         begin
            label9.Caption := 'Вы не зарегистрировались';
            RegLoginLabel.Caption := '!!!';
            MessageBox(handle, PChar('Вы не были зарегистрированны, потому что:'+ #13#10#13#10 + 'Этот логин уже был зарегистрирован.'),PChar('Ошибка регистрации'), MB_ICONERROR+MB_DEFBUTTON2);
         end;
      except
          MessageBox(handle, PChar('Ошибка соединения с сервером. Скорее всего она связана с его недоступностью сервера, либо порчей файлов, содержащих его адрес.'),PChar('Ошибка соединения'), MB_ICONERROR+MB_DEFBUTTON2);
      end;
   end;
end;

procedure TLoginForm.LoginButtonClick(Sender: TObject);
var
   js: TlkJSONobject;
   resp, SendMessage: string;
   JSAnswer: boolean;
begin
   if SaveData.Checked then
     SaveNewData
   else
      ClearData;
   try
      if ClientForm.SendLoginAndPass(LoginEdit.Text, PassEdit.Text) then
      begin
         ClientForm.Visible := true;
         ModalResult := mrOk;
         InfoLabel.Caption := '';
      end
      else
         InfoLabel.Caption := '          Введенные данные некорректны!';
   except
       MessageBox(handle, PChar('Ошибка соединения с сервером. Скорее всего она связана с его недоступностью сервера, либо порчей файлов, содержащих его адрес.'),PChar('Ошибка соединения'), MB_ICONERROR+MB_DEFBUTTON2);
   end;
end;



//////  Other  //////////////////////////////////////////

function TLoginForm.CheckAllEdits: boolean;
const
   CorrectValues = ['A'..'Z', 'a'..'z', '1'..'9', '0', #8, '_'];
var
   i: integer;
   CheckAllEdit: boolean;
   ErrorStr: string;
begin
   CheckAllEdits := true;
   label9.Caption := 'Вы не зарегистрировались';

   // pass check
   if RegPass1Edit.Text <> RegPass2Edit.Text then
   begin
      RegPassLabel.Caption := '!!!';
      ErrorStr := ErrorStr + #13#10 + 'Пароли не совпадают. Введите заново.';
      CheckAllEdit
       := false;
   end
   else
      if length(RegPass1Edit.Text) < 6 then
      begin
         RegPassLabel.Caption := '!!!';
         ErrorStr := ErrorStr + #13#10 + 'Поле с паролем должно содержать минимум 6 символов.';
         CheckAllEdit := false;
      end
      else
         RegPassLabel.Caption := '';

      // login check
      RegLoginLabel.Caption := '';
      if length(RegLoginEdit.Text) < 3 then
      begin
         ErrorStr := ErrorStr + #13#10 + 'Логин должен содержать минимум 3 символа.';
         RegLoginLabel.Caption := '!!!';
         CheckAllEdit := false;
      end
      else
      begin
         for i := 1 to length(regLoginEdit.Text) do
            if not (regLoginEdit.Text[i] in CorrectValues) then
            begin
               RegLoginLabel.Caption := '!!!';
               ErrorStr := ErrorStr + #13#10 + 'В логине есть недопустимые символы. К допусимым символам можно отнести любые цифры, английский алфавит и знак подчеркивания';
               CheckAllEdit := false;
               break;
            end;
      end;

   if not CheckAllEdit then
      MessageBox(handle, PChar('Вы не были зарегистрированны, потому что:'+ #13#10 + ErrorStr),PChar('Ошибка регистрации'), MB_ICONERROR+MB_DEFBUTTON2);
   CheckAllEdits := CheckAllEdit

end;

procedure TLoginForm.Button2Click(Sender: TObject);
begin
   panel1.Visible := false;
   LoginForm.Height := 330;
   LoginForm.Caption := 'Client - Вход в систему';
end;

procedure TLoginForm.Button1Click(Sender: TObject);
begin
   panel1.Visible := true;
   LoginForm.Height := 366;
   LoginForm.Caption := 'Client - Регистрация';
end;

procedure TLoginForm.G1Click(Sender: TObject);
begin
   if panel1.Visible then
      MessageBox(handle, PChar('Заполните все поля и нажмите кнопку "Зарегистрироваться". Если все поля были заполнены верно, то для подтверждения создания аккаунта войдите в него. Если после регистрации в течении 5 минут не будет произведен вход на аккаунт, то он будет удален.'),PChar('Помощь'), MB_ICONASTERISK+MB_DEFBUTTON2)
   else
      MessageBox(handle, PChar('Если вы уже имеете аккаунт, то просто введите в форму ниже свой логин и пароль. Если же нет, вам придется зарегистрироваться.'),PChar('Помощь'), MB_ICONASTERISK+MB_DEFBUTTON2);
end;

procedure TLoginForm.LoginEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = 13 then
      LoginButtonClick(self);

   if key = 27 then
      close;
end;

procedure TLoginForm.FormShow(Sender: TObject);
begin
   if LoginEdit.Text <> '' then
      SaveData.Checked := true;
end;

procedure TLoginForm.RegLoginEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if key = 27 then
      close;
end;

procedure TLoginForm.Panel2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
   Tpanel(sender).Color := rgb(212,229,237);
   Tpanel(sender).Cursor := crHandPoint;
end;

procedure TLoginForm.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   panel2.Color := rgb(229,237,241);
   panel3.Color := rgb(229,237,241);

end;

procedure TLoginForm.Panel2Click(Sender: TObject);
begin
   LoginButtonClick(self)
end;

procedure TLoginForm.Panel3Click(Sender: TObject);
begin
   panel2.Visible := false;
   panel3.Visible := false;
   button1Click(self)
end;

procedure TLoginForm.Panel1MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
   panel4.Color := rgb(229,237,241);
   panel5.Color := rgb(229,237,241);

end;

procedure TLoginForm.Panel4Click(Sender: TObject);
begin
   panel2.Visible := true;
   panel3.Visible := true;
   Button2Click(self)
end;

procedure TLoginForm.Panel5Click(Sender: TObject);
begin
   RegisterButtonClick(self)
end;

procedure TLoginForm.RegLoginEditKeyPress(Sender: TObject; var Key: Char);
const
   CorrectValues = ['A'..'Z', 'a'..'z', '1'..'9', '0', #8, '_'];
begin
   if not (key in CorrectValues) then
      key := #0;
end;

end.

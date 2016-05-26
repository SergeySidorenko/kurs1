unit SettingUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UserUtil, IniFiles, Menus, Shellapi, ExtCtrls ;

type
  TSettingForm = class(TForm)
    GroupBox2: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    GroupBox3: TGroupBox;
    Button3: TButton;
    Button4: TButton;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    MainMenu1: TMainMenu;
    G1: TMenuItem;
    Button1: TButton;
    Panel2: TPanel;
    Panel1: TPanel;
    Panel3: TPanel;
    procedure SaveAll;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Edit1KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit2KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit3KeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure G1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Panel3Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  UserLogin: string;
  DeleteAccount: boolean;
  SettingForm: TSettingForm;
  Settings: TSettings;

implementation
  uses ClientUnit;
{$R *.dfm}

procedure TSettingForm.FormCreate(Sender: TObject);
begin
   Settings := TSettings.Create(1,1);
end;

procedure TSettingForm.FormShow(Sender: TObject);
begin
   DeleteAccount := false;
   CheckBox2.Checked := Settings.NewMessages;
   CheckBox1.Checked := Settings.NewFriends;
   edit1.Text := inttostr(settings.SendMessage);
   edit2.Text := inttostr(settings.NextUser);
   edit3.Text := inttostr(settings.PredUser);
end;

procedure TSettingForm.SaveAll;
begin
   settings.NewMessages := CheckBox2.Checked;
   settings.NewFriends := CheckBox1.Checked;
   ini.WriteString('settings', 'NewMessages', booltostr(settings.NewMessages));
   ini.WriteString('settings', 'NewFriends', booltostr(settings.NewFriends));
   ini.WriteString('settings', 'NextUser', inttostr(settings.NextUser));
   ini.WriteString('settings', 'PredUser', inttostr(settings.PredUser));
   ini.WriteString('settings', 'SendMessage', inttostr(settings.SendMessage));
end;

procedure TSettingForm.Button3Click(Sender: TObject);
var
   fos: TSHFileOpStruct;
   MBResult: integer;
begin
   MBResult := MessageBox(handle, PChar('Вы уверены, что хотите удалить всю историю переписок, со всеми пользователями, за все время?'),PChar('Удаление истории'), MB_ICONERROR+MB_OKCANCEL);
   if MBResult = mrOK then
   begin
      ZeroMemory(@fos, SizeOf(fos));
      with fos do
      begin
         wFunc  := FO_DELETE;
         fFlags := FOF_SILENT or FOF_NOCONFIRMATION;
         pFrom  := PChar('./history/' + UserLogin + #0);
      end;
      ShFileOperation(fos);
    end;
end;

procedure TSettingForm.Button4Click(Sender: TObject);
var
   MBResult: integer;
begin
   MBResult := MessageBox(handle, PChar('Вы уверены, что хотите удалить свой аккаунт? Вернуть его уже будет нельзя.'),PChar('Удаление аккаунта'), MB_ICONERROR+MB_OKCANCEL);
   if MBResult = mrOK then
   begin
      DeleteAccount := true;
      close;
   end;
end;

procedure TSettingForm.Edit1KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Settings.CheckEdit(key) then
   begin
      Settings.SendMessage := key;
      Edit1.Text := inttostr(key)
   end
   else
      MessageBox(handle, PChar('Эта клавиша уже занята! Выберите другую.'),PChar('Ошибка!'), MB_ICONERROR+MB_DEFBUTTON2);
end;

procedure TSettingForm.Edit2KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Settings.CheckEdit(key) then
   begin
      Settings.NextUser := key;
      Edit2.Text := inttostr(key)
   end
   else
      MessageBox(handle, PChar('Эта клавиша уже занята! Выберите другую.'),PChar('Ошибка!'), MB_ICONERROR+MB_DEFBUTTON2);
end;

procedure TSettingForm.Edit3KeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
   if Settings.CheckEdit(key) then
   begin
      Settings.PredUser := key;
      Edit3.Text := inttostr(key);
   end
   else
      MessageBox(handle, PChar('Эта клавиша уже занята! Выберите другую.'),PChar('Ошибка!'), MB_ICONERROR+MB_DEFBUTTON2);
end;

procedure TSettingForm.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
   key := #0;
end;

procedure TSettingForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
   SaveAll;
end;

procedure TSettingForm.G1Click(Sender: TObject);
begin
   MessageBox(handle, PChar('1. Для сохранения новых данных просто закройте окно.' + #13#10#13#10 + '2. Меняя настроки - будьте осторожны, ведь вернуть назад их уже будет нельзя.' + #13#10#13#10 + '3. Если захотите, вы всегда сможете откатить настройки на стандартные, нажав соответствующую кнопку.'),PChar('Помощь'), MB_ICONASTERISK+MB_DEFBUTTON2)
end;

procedure TSettingForm.Button1Click(Sender: TObject);
begin
   CheckBox1.Checked := true;
   CheckBox2.Checked := true;
   Settings.NextUser := 114;
   Settings.PredUser := 113;
   Settings.SendMessage := 13;
   close;
end;

procedure TSettingForm.Panel2MouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
   Tpanel(sender).Color := rgb(212,229,237);
   Tpanel(sender).Cursor := crHandPoint;
end;

procedure TSettingForm.FormMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
begin
  panel2.Color := rgb(229,237,241);
  panel3.Color := rgb(229,237,241);
  panel1.Color := rgb(229,237,241);
end;

procedure TSettingForm.Panel3Click(Sender: TObject);
begin
   Button3Click(self)
end;

procedure TSettingForm.Panel1Click(Sender: TObject);
begin
   Button4Click(self)
end;

procedure TSettingForm.Panel2Click(Sender: TObject);
begin
   Button1Click(self)
end;

end.

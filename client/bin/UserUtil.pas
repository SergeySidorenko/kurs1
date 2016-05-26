unit UserUtil;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, uLkJSON;

type
   TSettings = class(TObject)
   public
      NewMessages: boolean;
      NewFriends: boolean;
      NextUser: word;
      PredUser: word;
      SendMessage: word;

      function CheckEdit(EnterKey: word): boolean;
      constructor Create(NewMessages, NewFriends: integer);
   end;

   TUser = class(TObject)
   public
      id: integer;
      login: string;
      ip: string;
      port: word;
      status: byte;
      Messages: string;
      NewMessages: integer;

      constructor Create(login, ip: string; port: word; status: byte);
      function toString: String;
      function toJSON: TlkJSONobject;
      procedure fromString(json:String);
   end;

implementation

constructor TSettings.Create(NewMessages, NewFriends: integer);
begin
   if NewMessages = 0 then
      self.NewMessages := false
   else
      self.NewMessages := true;

   if NewFriends = 0 then
      self.NewFriends := false
   else
      self.NewFriends := true;
end;

function TSettings.CheckEdit(EnterKey: word): boolean;
begin
   CheckEdit := true;
   if EnterKey = SendMessage then
      CheckEdit := false;
   if EnterKey = NextUser then
      CheckEdit := false;
   if EnterKey = PredUser then
      CheckEdit := false;
end;



constructor TUser.Create(login, ip: string; port: word; status: byte);
begin
   self.login := login;
   self.ip := ip;
   self.port := port;
   self.status := status;
   self.NewMessages := 0;
end;

procedure TUser.fromString(json : String);
var
   js: TlkJSONobject;
begin
   js := TlkJSON.ParseText(json) as TlkJSONobject;
   self.id := js.getInt('id');
   self.login := js.getString('login');
   self.ip := js.getString('ip');
   self.status := js.getInt('status');
   self.port := js.getInt('port');
   js.Free;
end;

function TUser.toJSON: TlkJSONobject;
var
   js: TlkJSONobject;
begin
   js := TlkJSONobject.Create;
   js.Add('id', self.id);
   js.Add('login', self.login);
   js.Add('ip', self.ip);
   js.Add('status', self.status);
   js.Add('port', self.port);
   result := js;
   js.Free;
end;

function TUser.toString(): String;
var
   js: TlkJSONobject;
   res: String;
begin
   js := toJSON();
   res := TlkJSON.GenerateText(js);
   js.Free;
   result := res;
end;

end.

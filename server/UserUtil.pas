unit UserUtil;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, uLkJSON;

type
   TUser = class(TObject)
      id: integer;
      login: string;
      pass: string;
      ip: string;
      port: integer;
      status: integer;
      date: string;
   public
      function toString: String;
      function toJSON: TlkJSONobject;
      procedure fromString(json:String);
   end;

implementation

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

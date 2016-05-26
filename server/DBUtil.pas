unit DBUtil;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, Grids, DBGrids, StdCtrls,
  ExtCtrls, DBXpress, SqlExpr, ADODB, ScktComp, WinSock, UserUtil;

type
   TWorkWithDB = class(TForm)
   private
      prSQLQuery: TADOQuery;
      prSQLConnection: TADOConnection;
      function CreateQuery: TADOQuery;
      procedure DeleteQuery(Query: TADOQuery);
   public
      procedure UpdateIpPortStatus(ip, login: string; port, status: integer);
      procedure DeleteAccount(login: string);
      function ReadContactList(login: string): TList;
      function FindUser(login: string): TUser;
      constructor Create(SQL: TADOQuery);
      function LoginUser(login, pass, ip: string; port: integer): boolean;
      function RegisterUser(login, pass: string): boolean;
      procedure DeleteFriend(login1, login2: string);
      procedure AddFriend(login1, login2: string);
      procedure LogoutUser(login, password: string);

      function AllUsers: TList;
      procedure TimerDeleteAndUpdateUsers;
   end;

implementation


//////  PUBLIC  //////////////////////////////////////////

constructor TWorkWithDB.Create(SQL: TADOQuery);
begin
   self.prSQLConnection := SQL.Connection;
   self.prSQLQuery := SQL;
end;

//! check time and update status or delete new users
procedure TWorkWithDB.TimerDeleteAndUpdateUsers;
var
   SQLQuery: TADOQuery;
begin
  try
   SQLQuery := CreateQuery;

   SQLQuery.SQL.Add('update user set status = 0 where status = 1 and adddate(connected_on, interval 1 minute ) < current_timestamp');
   SQLQuery.ExecSQL;
   SQLQuery.SQL.Clear;

   SQLQuery.SQL.Add('delete from user where status = 2 and adddate(connected_on, interval 5 minute ) < current_timestamp');
   SQLQuery.ExecSQL;
   SQLQuery.Close;
 finally
   DeleteQuery(SQLQuery);
 end;
end;


//! login user and update status, ip, port
function TWorkWithDB.LoginUser(login, pass, ip: string; port: integer): boolean;
var
   TempUser: TUser;
begin
   TempUser := FindUser(login);
   if (TempUser = nil) or (TempUser.pass <> pass) then
      LoginUser := false
   else
   begin
      UpdateIpPortStatus(ip, login, port, 1);
      LoginUser:= true;
   end;
end;

//! check login and register new user
function TWorkWithDB.RegisterUser(login, pass: string): boolean;
var
   TempUser: TUser;
   SQLQuery: TADOQuery;
begin
   TempUser := FindUser(login);
   if TempUser = nil then
   begin
    try
      SQLQuery := CreateQuery;
      SQLQuery.SQL.Add('insert into user (login, password, status, port) values( ''' + login + ''', ''' + pass + ''', 2, 0);');
      SQLQuery.ExecSQL;
      SQLQuery.Close;
     finally
       DeleteQuery(SQLQuery);
     end;
      RegisterUser := true;
   end
   else
      RegisterUser := false;
end;

//! return all user info. if not login in db then result.id = 0
function TWorkWithDB.FindUser(login: string): TUser;
var
   SQLQuery: TADOQuery;
   TempUser : TUser;
begin
try
   SQLQuery := CreateQuery;

   SQLQuery.SQL.Text := 'select id, login , password, ip, port, status from user where login = ''' + login + ''';';
   SQLQuery.Parameters.ParseSQL(SQLQuery.SQL.Text, true);
   SQLQuery.Open;
   SQLQuery.First;
   if  SQLQuery.RecordCount > 0 then
   begin
      TempUser := TUser.Create;
      TempUser.id := strtoint(SQLQuery.fields[0].AsString);
      TempUser.login := SQLQuery.fields[1].AsString;
      TempUser.pass := SQLQuery.fields[2].AsString;
      TempUser.ip := SQLQuery.fields[3].AsString;
      TempUser.port := strtoint(SQLQuery.fields[4].AsString);
      TempUser.status := strtoint(SQLQuery.fields[5].AsString);
      result := TempUser;
   end
   else
      FindUser := nil;

   SQLQuery.Close;
 finally
   DeleteQuery(SQLQuery);
 end;
end;

//////  PRIVATE  //////////////////////////////////////////

function TWorkWithDB.CreateQuery: TADOQuery;
begin
  CreateQuery := TADOQuery.Create(nil);
  CreateQuery.Connection := self.prSQLConnection;
end;

procedure TWorkWithDB.DeleteQuery(Query: TADOQuery);
begin
   Query.Free;
end;

//! update this ip and port
procedure TWorkWithDB.UpdateIpPortStatus(ip, login: string; port, status: integer);
var
   SQLQuery: TADOQuery;
begin
  try
   SQLQuery := CreateQuery;
   if not((ip = '') and (port = 0)) then
      SQLQuery.SQL.Add('update user set ip = ''' + ip + ''' , port = ' + inttostr(port) + ' where login = ''' + login + ''';');
   SQLQuery.ExecSQL;
   SQLQuery.SQL.Clear;
   SQLQuery.SQL.Add('update user set status = ' + inttostr(status) + ', connected_on = current_timestamp where login = ''' + login + ''';');
   SQLQuery.ExecSQL;
   SQLQuery.Close;
 finally
   DeleteQuery(SQLQuery);
 end;
end;

procedure TWorkWithDB.DeleteAccount(login: string);
var
   SQLQuery: TADOQuery;
begin
try
   SQLQuery := CreateQuery;

   SQLQuery.SQL.Add('delete from user where login = '''+ login + ''';');
   SQLQuery.ExecSQL;

 finally
   DeleteQuery(SQLQuery);
 end;
end;



//// WITH OTHER TABLE WORK //////////////////////////////

procedure TWorkWithDB.DeleteFriend(login1, login2: string);
var
   SQLQuery: TADOQuery;
begin
  try
   SQLQuery := CreateQuery;

   SQLQuery.SQL.Add('delete from contact_list where (id in (select id from user where login = ''' +login1 + ''') and contact_id in (select id from user where login = ''' + login2 + ''')) or (id in (select id from user where login = ''' + login2 + ''') and contact_id in (select id from user where login = ''' + login1 + '''));');
   SQLQuery.ExecSQL;
 finally
   DeleteQuery(SQLQuery);
 end;
end;

procedure TWorkWithDB.AddFriend(login1, login2: string);
var
   SQLQuery: TADOQuery;
begin
try
   SQLQuery := CreateQuery;

   SQLQuery.SQL.Add('insert into contact_list(id, contact_id) select u1.id, u2.id from user u1 left join user u2 on u2.login = ''' + login1 + ''' where u1.login = ''' + login2 + ''';');
   SQLQuery.ExecSQL;
   SQLQuery.SQL.Clear;
   SQLQuery.SQL.Add('insert into contact_list(id, contact_id) select u1.id, u2.id from user u1 left join user u2 on u2.login = ''' + login2 + ''' where u1.login = ''' + login1 + ''';');
   SQLQuery.ExecSQL;

 finally
   DeleteQuery(SQLQuery);
 end;
end;

function TWorkWithDB.AllUsers: TList;
var
   TempList: Tlist;
   SQLQuery: TADOQuery;
   TempUser : TUser;
begin
   TempList := TList.Create;
  try
   SQLQuery := CreateQuery;
   SQLQuery.SQL.Text := 'select login, status, ip, port, connected_on from user';
   SQLQuery.Active := true;
   SQLQuery.Open;
   SQLQuery.First;
   if  SQLQuery.RecordCount > 0 then
   begin
      while NOT SQLQuery.EOF do
      begin
         TempUser := TUser.Create;
         TempUser.login := SQLQuery.fields[0].AsString;
         TempUser.status := SQLQuery.fields[1].AsInteger;
         TempUser.ip := SQLQuery.fields[2].AsString;
         TempUser.port := SQLQuery.fields[3].AsInteger;
         TempUser.date := SQLQuery.fields[4].AsString;
         TempList.Add(TempUser);
         SQLQuery.Next;
      end;
   end;
   SQLQuery.Close;
  finally
   DeleteQuery(SQLQuery);
  end;
  Result := TempList;
end;

function TWorkWithDB.ReadContactList(login: string): TList;
var
   TempList: Tlist;
   SQLQuery: TADOQuery;
   TempUser : TUser;
begin
   TempList := TList.Create;
   try
      SQLQuery := CreateQuery;
      SQLQuery.SQL.Add('update user set connected_on = current_timestamp where login = ''' + login + ''';');
      SQLQuery.ExecSQL;
   finally
      DeleteQuery(SQLQuery);
   end;

   try
      SQLQuery := CreateQuery;

      SQLQuery.SQL.Text := 'select u.login, u.status, u.ip, u.port from user u inner join contact_list cl on cl.contact_id = u.id inner join user owner on cl.id = owner.id where owner.login = '''+ login +''';';
      SQLQuery.Active := true;

      SQLQuery.Open;
      SQLQuery.First;
      if  SQLQuery.RecordCount > 0 then
      begin
         while NOT SQLQuery.EOF do
         begin
            TempUser := TUser.Create;
            TempUser.login := SQLQuery.fields[0].AsString;
            TempUser.status := SQLQuery.fields[1].AsInteger;
            TempUser.ip := SQLQuery.fields[2].AsString;
            TempUser.port := SQLQuery.fields[3].AsInteger;
            TempList.Add(TempUser);
            SQLQuery.Next;
         end;
      end;
      SQLQuery.Close;
   finally
      DeleteQuery(SQLQuery);
   end;
   ReadContactList := TempList;
end;

procedure TWorkWithDB.LogoutUser(login, password: string);
var   SQLQuery: TADOQuery;
begin
  try
   SQLQuery := CreateQuery;

   SQLQuery.SQL.Add('update user set status = 0 where login = ''' + login + ''' and password = ''' + password + ''';');
   SQLQuery.ExecSQL;
  finally
   DeleteQuery(SQLQuery);
  end;

end;

end.

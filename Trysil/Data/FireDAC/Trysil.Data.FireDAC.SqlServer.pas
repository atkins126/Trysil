﻿(*

  Trysil
  Copyright © David Lastrucci
  All rights reserved

  Trysil - Operation ORM (World War II)
  http://codenames.info/operation/orm/

*)
unit Trysil.Data.FireDAC.SqlServer;

interface

uses
  System.Classes,
  System.SysUtils,
  Data.DB,
  FireDAC.UI.Intf,
  FireDAC.Comp.UI,
  FireDAC.Phys.MSSQL,
  FireDAC.Stan.Param,
  FireDAC.Comp.Client,

  Trysil.Data.FireDAC,
  Trysil.Data.FireDAC.Connection,
  Trysil.Data.SqlSyntax,
  Trysil.Data.SqlSyntax.SqlServer;

type

{ TTDataSqlServerConnection }

  TTDataSqlServerConnection = class(TTDataFireDACConnection)
  strict protected
    function CreateSyntaxClasses: TTDataSyntaxClasses; override;
  public
    function GetDatabaseObjectName(
      const ADatabaseObjectName: String): String; override;
  public
    class procedure RegisterConnection(
      const AName: String;
      const AServer: String;
      const ADatabaseName: String); overload;

    class procedure RegisterConnection(
      const AName: String;
      const AServer: String;
      const AUsername: String;
      const APassword: String;
      const ADatabaseName: String); overload;

    class procedure RegisterConnection(
      const AName: String;
      const AParameters: TStrings); overload;
  end;

implementation

{ TTDataSqlServerConnection }

function TTDataSqlServerConnection.GetDatabaseObjectName(
  const ADatabaseObjectName: String): String;
begin
   result := Format('[%s]', [ADatabaseObjectName]);
end;

function TTDataSqlServerConnection.CreateSyntaxClasses: TTDataSyntaxClasses;
begin
  result := TTDataSqlServerSyntaxClasses.Create;
end;

class procedure TTDataSqlServerConnection.RegisterConnection(
  const AName: String;
  const AServer: String;
  const ADatabaseName: String);
begin
  RegisterConnection(
    AName, AServer, String.Empty, String.Empty, ADatabaseName);
end;

class procedure TTDataSqlServerConnection.RegisterConnection(
  const AName: String;
  const AServer: String;
  const AUsername: String;
  const APassword: String;
  const ADatabaseName: String);
var
  LParameters: TStrings;
begin
  LParameters := TStringList.Create;
  try
    LParameters.Add(Format('Server=%s', [AServer]));
    LParameters.Add(Format('Database=%s', [ADatabaseName]));
    if AUsername.IsEmpty then
        LParameters.Add('OSAuthent=Yes')
    else
    begin
        LParameters.Add(Format('User_Name=%s', [AUserName]));
        LParameters.Add(Format('Password=%s', [APassword]));
    end;
    RegisterConnection(AName, LParameters);
  finally
    LParameters.Free;
  end;
end;

class procedure TTDataSqlServerConnection.RegisterConnection(
  const AName: String; const AParameters: TStrings);
begin
  TTDataFireDACConnectionPool.Instance.RegisterConnection(
    AName, 'MSSQL', AParameters);
end;

end.

(*

  Trysil
  Copyright � David Lastrucci
  All rights reserved

  Trysil - Operation ORM (World War II)
  http://codenames.info/operation/orm/

*)
unit Trysil.Http.MultiTenant.FirebirdSQL;

interface

uses
  System.SysUtils,
  System.Classes,
  Trysil.Data.FireDAC,
  Trysil.Data.FireDAC.FirebirdSQL,

  Trysil.Http.MultiTenant.Connection;

type

{ TTFirebirdSQLTenantConnection }

  TTFirebirdSQLTenantConnection = class(TTTenantConnection)
  strict protected
    function GetConnectionClass: TTFireDACConnectionClass; override;
    procedure RegisterConnection; override;
  end;

implementation

{ TTFirebirdSQLTenantConnection }

function TTFirebirdSQLTenantConnection.GetConnectionClass: TTFireDACConnectionClass;
begin
  result := TTFireDACConnection;
end;

procedure TTFirebirdSQLTenantConnection.RegisterConnection;
begin
  if FConfig.Username.IsEmpty and FConfig.Password.IsEmpty then
    TTFirebirdSQLConnection.RegisterConnection(
      FConfig.ConnectionName, FConfig.Server, FConfig.DatabaseName)
  else
    TTFirebirdSQLConnection.RegisterConnection(
      FConfig.ConnectionName,
      FConfig.Server,
      FConfig.Username,
      FConfig.Password,
      FConfig.DatabaseName);
end;

end.

unit Telegraph.Api;

interface

uses
  System.Generics.Collections,
  System.Rtti,
  Telegraph.Classes,
  Telega.Api.Core;

Type
  TTelegraphAPI = Class(TTelegaCore)
  private
  protected
    Function ApiUrl: String; override;
  public
    Function createAccount(Const short_name: String; Const author_name: String = '';
      author_url: String = ''): TtphAccount;
  End;

implementation

{ TTelegraphAPI }

function TTelegraphAPI.ApiUrl: String;
begin
  Result := 'https://api.telegra.ph/';
end;

function TTelegraphAPI.createAccount(const short_name, author_name: String; author_url: String)
  : TtphAccount;
var
  Param: TDictionary<String, TValue>;
begin
  Param := TDictionary<String, TValue>.Create;
  try
    Param.Add('short_name', short_name);
    Param.Add('author_name', author_name);
    Param.Add('author_url', author_url);
    Result := Api<TtphAccount>('createAccount', Param);
  finally
    Param.Free;
  end;
end;

end.

program Project4;

{$APPTYPE CONSOLE}
{$R *.res}

uses
  System.SysUtils,
  System.Rtti,
  Telegraph.API in '..\Source\Telegraph.API.pas',
  Telegraph.Classes in '..\Source\Telegraph.Classes.pas',
  TelegAPi.Utils in '..\Source\TelegAPi.Utils.pas';

Type
  TTelegraphSample = class
  private
    FTeleg: TTelegraphAPI;
  public
    Procedure OnError(Sender: TObject; Const Code: Integer; Const Message: String);
    constructor Create;
    destructor Destroy; override;
    Function Post(Msg: TArray<TtphNodeElement>): String; overload;
    Function Post(Msg: TArray<String>): String; overload;
    Procedure PostTest;
  end;

Procedure Go;
var
  Tph: TTelegraphSample;
Begin
  Tph := TTelegraphSample.Create;
  try
    Tph.PostTest;
  finally
    Tph.Free;
  end;
End;

{ TTelegraphSample }

constructor TTelegraphSample.Create;
begin
  FTeleg := TTelegraphAPI.Create;
  FTeleg.OnError := OnError;
end;

destructor TTelegraphSample.Destroy;
begin
  FTeleg.Free;
  inherited;
end;

procedure TTelegraphSample.OnError(Sender: TObject; const Code: Integer; const Message: String);
begin
  Writeln('Error: ', Code, ' ', Message);
end;

function TTelegraphSample.Post(Msg: TArray<TtphNodeElement>): String;
var
  LAccount: TtphAccount;
  LPage: TtphPage;
begin
  LAccount := nil;
  LPage := nil;
  try
    LAccount := FTeleg.createAccount('rareMax', 'rareMax', 'https://telegram.me/fire_monkey');
    if NOT Assigned(LAccount) then
      Exit;
    LPage := FTeleg.createPage(LAccount.access_token, 'Заголовок', Msg, LAccount.author_name,
      LAccount.author_url, False);
    if NOT Assigned(LPage) then
      Exit;
    Result := LPage.url;
  finally
    LAccount.Free;
    LPage.Free;
  end;
end;

function TTelegraphSample.Post(Msg: TArray<String>): String;
var
  LAccount: TtphAccount;
  LPage: TtphPage;
begin
  LAccount := nil;
  LPage := nil;
  try
    LAccount := FTeleg.createAccount('rareMax', 'rareMax', 'https://telegram.me/fire_monkey');
    if NOT Assigned(LAccount) then
      Exit;
    LPage := FTeleg.createPage(LAccount.access_token, 'Заголовок1', Msg, LAccount.author_name,
      LAccount.author_url, False);
    if NOT Assigned(LPage) then
      Exit;
    Result := LPage.url;
  finally
    LAccount.Free;
    LPage.Free;
  end;

end;

procedure TTelegraphSample.PostTest;
var
  LMsg: TtphNodeElement;
  LMsgString: String;
  LUrl: String;
begin
  LMsg := TtphNodeElement.Create;
  try
    LMsg.attrs := 'Привет #Fmx@Delphi!';
    LMsg.TagOrd := TtphTag.h3;
    LMsgString := LMsg.attrs;
    LUrl := Post([LMsg]);
    Writeln(LUrl);
  finally
    LMsg.Free;
  end;
end;

begin
  try
    { TODO -oUser -cConsole Main : Insert code here }
    Go;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
  Readln;
end.

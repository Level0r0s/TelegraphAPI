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
    Function tphFieldsToString(tphFields: TtphFields): String;
  protected
    Function ApiUrl: String; override;
  public
    /// <summary>
    /// Use this method to create a new Telegraph account.
    /// </summary>
    /// <param name="short_name">
    /// Required. Account name, helps users with several accounts remember
    /// which they are currently using. Displayed to the user above the
    /// "Edit/Publish" button on Telegra.ph, other users don't see this name.
    /// </param>
    /// <param name="author_name">
    /// Default author name used when creating new articles.
    /// </param>
    /// <param name="author_url">
    /// Default profile link, opened when users click on the author's name
    /// below the title. Can be any link, not necessarily to a Telegram
    /// profile or channel.
    /// </param>
    /// <returns>
    /// On success, returns an Account object with the regular fields and an
    /// additional access_token field.
    /// </returns>
    /// <remarks>
    /// Most users only need one account, but this can be useful for channel
    /// administrators who would like to keep individual author names and
    /// profile links for each of their channels.
    /// </remarks>
    Function createAccount(Const short_name: String; Const author_name: String = '';
      const author_url: String = ''): TtphAccount;
    Function editAccountInfo(Const access_token, short_name: String; Const author_name: String = '';
      const author_url: String = ''): TtphAccount;
    Function getAccountInfo(Const access_token: String;
      fields: TtphFields = [TtphField.short_name, TtphField.author_name, TtphField.author_url])
      : TtphAccount;
    Function revokeAccessToken(Const access_token: String): TtphAccount;
    /// <summary>
    /// Use this method to create a new Telegraph page.
    /// </summary>
    /// <param name="access_token">
    /// Required. Access token of the Telegraph account.
    /// </param>
    /// <param name="title">
    /// Required. Page title.
    /// </param>
    /// <param name="content">
    /// Required. Content of the page.
    /// </param>
    /// <param name="author_name">
    /// Author name, displayed below the article's title. <br />
    /// </param>
    /// <param name="author_url">
    /// Profile link, opened when users click on the author's name below the
    /// title. Can be any link, not necessarily to a Telegram profile or
    /// channel.
    /// </param>
    /// <param name="return_content">
    /// If true, a content field will be returned in the Page object (see:
    /// Content format).
    /// </param>
    /// <returns>
    /// On success, returns a Page object.
    /// </returns>
    Function createPage(Const access_token, title: String; content: TArray<String>;
      Const author_name: String = ''; Const author_url: String = '';
      return_content: Boolean = False): TtphPage; overload;
    Function createPage(Const access_token, title: String; content: TArray<TtphNodeElement>;
      Const author_name: String = ''; Const author_url: String = '';
      return_content: Boolean = False): TtphPage; overload;

    Function editPage(Const access_token, path, title: String; content: TArray<TValue>;
      Const author_name: String = ''; Const author_url: String = '';
      return_content: Boolean = False): TtphPage;
    Function getPage(Const path: String; Const return_content: Boolean = False): TtphPage;
    Function getPageList(Const access_token: String; Const offset: Integer = 0;
      Const limit: Integer = 50): TtphPageList;
    Function getViews(Const path: String; Const year, month, day, hour: Integer): Integer;
  End;

implementation

uses
  XSuperObject,
  System.TypInfo;

{ TTelegraphAPI }

function TTelegraphAPI.tphFieldsToString(tphFields: TtphFields): String;
var
  JA: ISuperArray;
begin
  JA := TSuperArray.Create;
  if TtphField.short_name in tphFields then
    JA.Add('short_name');
  if TtphField.author_name in tphFields then
    JA.Add('author_name');
  if TtphField.author_url in tphFields then
    JA.Add('author_url');
  if TtphField.auth_url in tphFields then
    JA.Add('auth_url');
  if TtphField.page_count in tphFields then
    JA.Add('page_count');
  Result := JA.AsJSON;
end;

function TTelegraphAPI.ApiUrl: String;
begin
  Result := 'https://api.telegra.ph/';
end;

function TTelegraphAPI.createAccount(const short_name, author_name, author_url: String)
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

function TTelegraphAPI.createPage(const access_token, title: String;
  content: TArray<String>; const author_name, author_url: String;
  return_content: Boolean): TtphPage;
var
  Param: TDictionary<String, TValue>;
  I: Integer;
begin
  Param := TDictionary<String, TValue>.Create;
  try
    Param.Add('access_token', access_token);
    Param.Add('title', title);
    Param.Add('content', TValue.From<TArray<String>>(content));
    Param.Add('author_name', author_name);
    Param.Add('author_url', author_url);
    Param.Add('return_content', return_content);
    Result := Api<TtphPage>('createPage', Param);
  finally
    Param.Free;
  end;
end;

function TTelegraphAPI.createPage(const access_token, title: String;
  content: TArray<TtphNodeElement>; const author_name, author_url: String;
  return_content: Boolean): TtphPage;
var
  Param: TDictionary<String, TValue>;
  I: Integer;
begin
  Param := TDictionary<String, TValue>.Create;
  try
    Param.Add('access_token', access_token);
    Param.Add('title', title);
    Param.Add('content', TValue.From<TArray<TtphNodeElement>>(content));
    Param.Add('author_name', author_name);
    Param.Add('author_url', author_url);
    Param.Add('return_content', return_content);
    Result := Api<TtphPage>('createPage', Param);
  finally
    Param.Free;
  end;
end;


function TTelegraphAPI.editAccountInfo(const access_token, short_name, author_name,
  author_url: String): TtphAccount;
var
  Param: TDictionary<String, TValue>;
begin
  Param := TDictionary<String, TValue>.Create;
  try
    Param.Add('access_token', access_token);
    Param.Add('short_name', short_name);
    Param.Add('author_name', author_name);
    Param.Add('author_url', author_url);
    Result := Api<TtphAccount>('editAccountInfo', Param);
  finally
    Param.Free;
  end;
end;

function TTelegraphAPI.editPage(const access_token, path, title: String; content: TArray<TValue>;
  const author_name, author_url: String; return_content: Boolean): TtphPage;
var
  Param: TDictionary<String, TValue>;
  TestArr: Array of TValue;
  I: Integer;
begin
  Param := TDictionary<String, TValue>.Create;
  try
    Param.Add('access_token', access_token);
    Param.Add('path', path);
    Param.Add('title', title);

    SetLength(TestArr, Length(content));
    for I := Low(content) to High(content) do
      TestArr[I] := content[I];

    Param.Add('content', TValue.FromArray(PTypeInfo(TestArr), TestArr));
    Param.Add('author_name', author_name);
    Param.Add('author_name', author_name);
    Param.Add('author_url', author_url);
    Param.Add('return_content', return_content);
    Result := Api<TtphPage>('editPage', Param);
  finally
    Param.Free;
  end;
end;

function TTelegraphAPI.getAccountInfo(const access_token: String; fields: TtphFields): TtphAccount;
var
  Param: TDictionary<String, TValue>;
begin
  Param := TDictionary<String, TValue>.Create;
  try
    Param.Add('access_token', access_token);
    Param.Add('fields', tphFieldsToString(fields));
    Result := Api<TtphAccount>('getAccountInfo', Param);
  finally
    Param.Free;
  end;
end;

function TTelegraphAPI.getPage(const path: String; const return_content: Boolean): TtphPage;
var
  Param: TDictionary<String, TValue>;
begin
  Param := TDictionary<String, TValue>.Create;
  try
    Param.Add('path', path);
    Param.Add('return_content', return_content);
    Result := Api<TtphPage>('getPage', Param);
  finally
    Param.Free;
  end;
end;

function TTelegraphAPI.getPageList(const access_token: String; const offset, limit: Integer)
  : TtphPageList;
var
  Param: TDictionary<String, TValue>;
begin
  Param := TDictionary<String, TValue>.Create;
  try
    Param.Add('access_token', access_token);
    Param.Add('offset', offset);
    Param.Add('limit', limit);
    Result := Api<TtphPageList>('getPageList', Param);
  finally
    Param.Free;
  end;
end;

function TTelegraphAPI.getViews(const path: String; const year, month, day, hour: Integer): Integer;
var
  Param: TDictionary<String, TValue>;
begin
  Param := TDictionary<String, TValue>.Create;
  try
    Param.Add('path', path);
    Param.Add('year', year);
    Param.Add('month', month);
    Param.Add('day', day);
    Param.Add('hour', hour);
    Result := Api<Integer>('getViews', Param);
  finally
    Param.Free;
  end;
end;

function TTelegraphAPI.revokeAccessToken(const access_token: String): TtphAccount;
var
  Param: TDictionary<String, TValue>;
begin
  Param := TDictionary<String, TValue>.Create;
  try
    Param.Add('access_token', access_token);
    Result := Api<TtphAccount>('revokeAccessToken', Param);
  finally
    Param.Free;
  end;
end;

end.

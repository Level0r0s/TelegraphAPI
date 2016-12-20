unit Telegraph.API;

interface

{$DEFINE TG_AUTOLib}
{$IF Defined(TG_AUTOLib)}
{$I jedi.inc}
{$IF Defined(DELPHIXE8_UP)}
{$DEFINE TG_NetHttpClient}
{$ELSE}
{$DEFINE TG_INDY}
{$ENDIF}
{$ENDIF}

uses
  System.Generics.Collections,
  System.Rtti,
  System.SysUtils,
{$IF Defined(TG_NetHttpClient)}
  System.Net.Mime,
  System.Net.HttpClient,
{$ELSEIF Defined(TG_INDY)}
  IdMultiPartFormData,
  IdHttp,
{$ELSEIF Defined(TG_ICS)}
{$ELSE}
{$ENDIF}
  TelegAPi.Classes;

Type
{$IF Defined(TG_NetHttpClient)}
{$ELSEIF Defined(TG_INDY)}
  TMultipartFormData = TIdMultiPartFormDataStream;

  TMultipartFormDataHelper = Class Helper for TIdMultiPartFormDataStream
    procedure AddField(const AField, AValue: string);
  End;
{$ELSE}
{$ENDIF}

  TtphOnError = procedure(Sender: TObject; Const Code: Integer; Const Message: String) of Object;

  TTelegraph = Class
  private
    FOnError: TtphOnError;
    Function API<T>(Const Method: String; Parameters: TDictionary<String, TValue>): T;
    Function ParamsToFormData(Parameters: TDictionary<String, TValue>): TMultipartFormData;
  published
    property OnError: TtphOnError read FOnError write FOnError;
  End;

implementation

{$IFDEF TG_NetHttpClient}
{ TTelegramBotNetHttp }

function TTelegraph.API<T>(const Method: String; Parameters: TDictionary<String, TValue>): T;
var
  lHttp: THTTPClient;
  lHttpResponse: IHTTPResponse;
  lApiResponse: TtgApiResponse<T>;
  lURL_TELEG: String;
  LParamToDate: TMultipartFormData;
begin
  lHttp := THTTPClient.Create;
  try
    lURL_TELEG := 'https://api.telegra.ph/' + Method;
    // Преобразовуем параметры в строку, если нужно
    if Assigned(Parameters) then
    Begin
      LParamToDate := ParamsToFormData(Parameters);
      lHttpResponse := lHttp.Post(lURL_TELEG, LParamToDate);
    End
    else
      lHttpResponse := lHttp.Get(lURL_TELEG);
    if lHttpResponse.StatusCode <> 200 then
    begin
      if Assigned(OnError) then
        OnError(Self, lHttpResponse.StatusCode, lHttpResponse.StatusText);
      Exit;
    end;
    lApiResponse := TtgApiResponse<T>.FromJSON(lHttpResponse.ContentAsString);
    if Not lApiResponse.Ok then
    begin
      if Assigned(OnError) then
        OnError(Self, lApiResponse.Code, lApiResponse.Message);
      Exit;
    end;
    Result := lApiResponse.ResultObject;
    lApiResponse.ResultObject := Default (T);
  finally
    FreeAndNil(LParamToDate);
    FreeAndNil(lHttp);
    FreeAndNil(lApiResponse);
  end;
end;
{$ELSEIF Defined(TG_INDY)}
{ TMultipartFormDataHelper }

procedure TMultipartFormDataHelper.AddField(const AField, AValue: string);
begin
  AddFormField(AField, AValue);
end;

{ TTelegramBotIndy }

function TTelegraph.API<T>(const Method: String; Parameters: TDictionary<String, TValue>): T;
var
  lHttp: TIdHTTP;
  lHttpResponse: String;
  lApiResponse: TtgApiResponse<T>;
  lURL_TELEG: String;
  LParamToDate: TMultipartFormData;
begin
  lHttp := TIdHTTP.Create(Self);
  try
    lURL_TELEG := 'https://api.telegram.org/bot' + FToken + '/' + Method;
    // Преобразовуем параметры в строку, если нужно
    if Assigned(Parameters) then
    Begin
      LParamToDate := ParamsToFormData(Parameters);
      lHttpResponse := lHttp.Post(lURL_TELEG, LParamToDate);
    End
    else
      lHttpResponse := lHttp.Get(lURL_TELEG);
    if lHttp.ResponseCode <> 200 then
    begin
      if Assigned(OnError) then
        OnError(Self, lHttp.ResponseCode, lHttp.ResponseText);
      Exit;
    end;
    lApiResponse := TtgApiResponse<T>.FromJSON(lHttpResponse);
    if Not lApiResponse.Ok then
    begin
      if Assigned(OnError) then
        OnError(Self, lApiResponse.Code, lApiResponse.Message);
      Exit;
    end;
    Result := lApiResponse.ResultObject;
    lApiResponse.ResultObject := Default (T);
  finally
    FreeAndNil(LParamToDate);
    FreeAndNil(lHttp);
    FreeAndNil(lApiResponse);
  end;
end;
{$ELSE}
  ААААА сложна
{$ENDIF}

{ TTelegraph }

function TTelegraph.API<T>(const Method: String;
  Parameters: TDictionary<String, TValue>): T;
begin

end;

function TTelegraph.ParamsToFormData(
  Parameters: TDictionary<String, TValue>): TMultipartFormData;
begin

end;

end.

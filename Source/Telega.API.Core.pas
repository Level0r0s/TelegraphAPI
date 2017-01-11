unit Telega.API.Core;

interface

{$DEFINE TG_AUTOLib}
{$IF Defined(TG_AUTOLib)}
{$IF CompilerVersion >= 17.0}
{$DEFINE TG_NetHttpClient}
{$ELSE}
{$DEFINE TG_INDY}
{$ENDIF}
{$ENDIF}

uses
{$IFDEF DEBUG}
  FMX.Types,
{$ENDIF}
  System.Generics.Collections,
  System.Classes,
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
  XSuperObject,
  TelegAPi.Utils,
  Telegraph.Classes;

Type
{$IF Defined(TG_NetHttpClient)}
{$ELSEIF Defined(TG_INDY)}
  TMultipartFormData = TIdMultiPartFormDataStream;

  TMultipartFormDataHelper = Class Helper for TIdMultiPartFormDataStream
    procedure AddField(const AField, AValue: string);
  End;
{$ELSE}
  // ;
{$ENDIF}

  TtgOnError = procedure(Sender: TObject; Const Code: Integer; Const Message: String) of Object;

  TTelegaCore = Class
  private
    FOnError: TtgOnError;
  protected
    Function ApiUrl: String; virtual; abstract;
    Function API<T>(Const Method: String; Parameters: TDictionary<String, TValue>): T;
    Function ParamsToFormData(Parameters: TDictionary<String, TValue>): TMultipartFormData; virtual;
  published
    property OnError: TtgOnError read FOnError write FOnError;
  End;

implementation

{$IFDEF TG_NetHttpClient}
{ TTelegramBotNetHttp }

function TTelegaCore.API<T>(const Method: String; Parameters: TDictionary<String, TValue>): T;
var
  lHttp: THTTPClient;
  lHttpResponse: IHTTPResponse;
  lApiResponse: TtphApiResponse<T>;
  lURL_TELEG: String;
  LParamToDate: TMultipartFormData;
begin
  lHttp := THTTPClient.Create;
  try
    lURL_TELEG := ApiUrl + Method;
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
{$IFDEF DEBUG}
    Log.d(lHttpResponse.ContentAsString);
{$ENDIF}
    lApiResponse := TtphApiResponse<T>.FromJSON(lHttpResponse.ContentAsString);
    if Not lApiResponse.Ok then
    begin
{$IFDEF DEBUG}
      Log.d(lApiResponse.Error);
{$ENDIF}
      if Assigned(OnError) then
        OnError(Self, -1, lApiResponse.Error);
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
  lApiResponse: TtphApiResponse<T>;
  lURL_TELEG: String;
  LParamToDate: TMultipartFormData;
begin
  lHttp := TIdHTTP.Create(Self);
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
    if lHttp.ResponseCode <> 200 then
    begin
      if Assigned(OnError) then
        OnError(Self, lHttp.ResponseCode, lHttp.ResponseText);
      Exit;
    end;
    lApiResponse := TtphApiResponse<T>.FromJSON(lHttpResponse);
    if Not lApiResponse.Ok then
    begin
      if Assigned(OnError) then
        OnError(Self, -1, lApiResponse.Error);
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
{$ENDIF}
{ TTelegraph }

function TTelegaCore.ParamsToFormData(Parameters: TDictionary<String, TValue>): TMultipartFormData;
var
  parameter: TPair<String, TValue>;
  JA: ISuperArray;
  I: Integer;
  NodeArray: TArray<TtphNodeElement>;
  StringArray : TArray<String>;
begin
  Result := TMultipartFormData.Create;
  for parameter in Parameters do
  begin
    if parameter.Value.IsType<TtphNodeElement> then
    Begin
      Result.AddField(parameter.Key, parameter.Value.AsObject.AsJSON)
    End
    else if parameter.Value.IsType<TArray<TtphNodeElement>> then
    Begin
      JA := TSuperArray.Create();
      SetLength(NodeArray, Length(parameter.Value.AsType<TArray<TtphNodeElement>>));
      parameter.Value.ExtractRawData(@NodeArray);
      for I := Low(NodeArray) to High(NodeArray) do
      Begin
        if Assigned(NodeArray[I]) then
          JA.Add(NodeArray[I].AsJSON);
      End;
      Result.AddField(parameter.Key, JA.AsJSON);
      JA := Nil;
    End
    else if parameter.Value.IsType<TArray<String>> then
    Begin
      JA := TSuperArray.Create();
      SetLength(StringArray, Length(parameter.Value.AsType<TArray<String>>));
      parameter.Value.ExtractRawData(@StringArray);
      for I := Low(StringArray) to High(StringArray) do
      Begin
        if NOT StringArray[I].IsEmpty then
          JA.Add(StringArray[I]);
      End;
      Result.AddField(parameter.Key, JA.AsJSON);
      JA := Nil;
    End
    else if parameter.Value.IsType<string> then
    Begin
      if NOT parameter.Value.AsString.IsEmpty then
        Result.AddField(parameter.Key, parameter.Value.AsString)
    End
    else if parameter.Value.IsType<Int64> then
    Begin
      if parameter.Value.AsInt64 <> 0 then
        Result.AddField(parameter.Key, IntToStr(parameter.Value.AsInt64));
    End
    else if parameter.Value.IsType<Boolean> then
    Begin
      if parameter.Value.AsBoolean then
        Result.AddField(parameter.Key, TtgUtils.IfThen<String>(parameter.Value.AsBoolean,
          'true', 'false'))
    End;
  end;
end;

end.

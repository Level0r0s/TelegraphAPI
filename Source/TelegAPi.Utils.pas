unit TelegAPi.Utils;

interface

Type
  TtgUtils = class
    Class Function IfThen<T>(Const Value: Boolean; IfTrue, IfFalse: T): T;
  end;

  /// <remarks>
  ///   by Kami@telegram.me/fire_monkey
  /// </remarks>
  TEnum<T: record> = class
  public
    class function FromString(const S: string): T;
    class function ToString(Value: T): string;
  end;

implementation

uses
  System.SysUtils, System.TypInfo;
{ TuaUtils }

class function TtgUtils.IfThen<T>(const Value: Boolean; IfTrue, IfFalse: T): T;
begin
  if Value then
    Result := IfTrue
  else
    Result := IfFalse;
end;

{ TConversions<T> }

class function TEnum<T>.ToString(Value: T): string;
var
  P: PTypeInfo;
begin
  P := PTypeInfo(TypeInfo(T));
  case P^.Kind of
    tkEnumeration:
      case GetTypeData(P)^.OrdType of
        otSByte, otUByte:
          Result := GetEnumName(P, PByte(@Value)^);
        otSWord, otUWord:
          Result := GetEnumName(P, PWord(@Value)^);
        otSLong, otULong:
          Result := GetEnumName(P, PCardinal(@Value)^);
      end;
  else
    raise EArgumentException.CreateFmt('Type %s is not enumeration', [P^.Name]);
  end;
end;

class function TEnum<T>.FromString(const S: string): T;
var
  P: PTypeInfo;
begin
  P := PTypeInfo(TypeInfo(T));
  case P^.Kind of
    tkEnumeration:
      case GetTypeData(P)^.OrdType of
        otSByte, otUByte:
          PByte(@Result)^ := GetEnumValue(P, S);
        otSWord, otUWord:
          PWord(@Result)^ := GetEnumValue(P, S);
        otSLong, otULong:
          PCardinal(@Result)^ := GetEnumValue(P, S);
      end;
  else
    raise EArgumentException.CreateFmt('Type %s is not enumeration', [P^.Name]);
  end;
end;

end.

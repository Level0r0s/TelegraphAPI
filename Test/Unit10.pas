unit Unit10;

interface

uses
  Telegraph.Api,
  Telegraph.Classes,
  DUnitX.TestFramework;

type

  [TestFixture]
  TMyTestObject = class(TObject)
  private
    FAPI: TTelegraphAPI;
  public
    [Setup]
    procedure Setup;
    [TearDown]
    procedure TearDown;
    // Sample Methods
    // Simple single Test
    [Test]
    [TestCaseAttribute('TestSample', 'Sandbox,Anonymous')]
    procedure createAccount(const AValue1, AValue2, AValue3: String);
    [Test]
    [TestCaseAttribute('TestSample',
      'b968da509bb76866c35425099bc0989a5ec3b32997d55286c657e6994bbb,Sandbox,Anonymous')]
    procedure editAccountInfo(const AValue0, AValue1, AValue2, AValue3: String);
    [Test]
    procedure getAccountInfoTest;
  end;

implementation

procedure TMyTestObject.editAccountInfo(const AValue0, AValue1, AValue2, AValue3: String);
var
  LAccount: TtphAccount;
begin
  LAccount := FAPI.editAccountInfo(AValue0, AValue1, AValue2, AValue3);
  try
    Assert.AreEqual(LAccount.short_name, AValue1);
    Assert.AreEqual(LAccount.author_name, AValue2);
    Assert.AreEqual(LAccount.author_url, AValue3);
  finally
    LAccount.Free;
  end;
end;

procedure TMyTestObject.getAccountInfoTest;
var
  LAccount: TtphAccount;
begin
  LAccount := FAPI.getAccountInfo('b968da509bb76866c35425099bc0989a5ec3b32997d55286c657e6994bbb',
    [TtphField.short_name, TtphField.page_count]);
  try
    Assert.AreEqual(LAccount.short_name, 'Sandbox');
  finally
    LAccount.Free;
  end;
end;

procedure TMyTestObject.Setup;
begin
  FAPI := TTelegraphAPI.Create;
end;

procedure TMyTestObject.TearDown;
begin
  FAPI.Free;
end;

procedure TMyTestObject.createAccount;
var
  LAccount: TtphAccount;
begin
  LAccount := FAPI.createAccount(AValue1, AValue2, AValue3);
  try
    Assert.AreEqual(LAccount.short_name, AValue1);
    Assert.AreEqual(LAccount.author_name, AValue2);
    Assert.AreEqual(LAccount.author_url, AValue3);
  finally
    LAccount.Free;
  end;
end;

initialization

TDUnitX.RegisterTestFixture(TMyTestObject);

end.

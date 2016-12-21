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
  end;

implementation

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

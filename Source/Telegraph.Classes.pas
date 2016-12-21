unit Telegraph.Classes;

interface

uses
  XSuperObject,
  System.SysUtils;

Type
{$SCOPEDENUMS ON}
  TtphField = (short_name, author_name, author_url, auth_url, page_count);
  TtphFields = set of TtphField;
{$SCOPEDENUMS OFF}
  /// <summary>
  /// This object represents a DOM element node.
  /// </summary>
  [Alias('Node')]
  TtphNode = Class
  private
    FTag: String;
    Fattrs: String;
    Fchildren: TArray<TtphNode>;
  public
    destructor Destroy; override;
  published
    /// <summary>
    /// Name of the DOM element.
    /// </summary>
    /// <remarks>
    /// Available tags: a, aside, b, blockquote, br, code, em, figcaption,
    /// figure, h3, h4, hr, i, iframe, img, li, ol, p, pre, s, strong, u, ul,
    /// video.
    /// </remarks>
    [Alias('tag')]
    property Tag: String read FTag write FTag;
    /// <summary>
    /// Optional. Attributes of the DOM element. Key of object represents
    /// name of attribute, value represents value of attribute. Available
    /// attributes: href, src.
    /// </summary>
    [Alias('attrs')]
    property attrs: String read Fattrs write Fattrs; // !!!!
    /// <summary>
    /// Optional. List of child nodes for the DOM element.
    /// </summary>
    [Alias('children')]
    property children: TArray<TtphNode> read Fchildren write Fchildren;
  End;

  /// <summary>
  /// This object represents a page on Telegraph.
  /// </summary>
  [Alias('Page')]
  TtphPage = Class
  private
    Fpath: String;
    Furl: String;
    Ftitle: String;
    Fdescription: String;
    Fauthor_name: String;
    Fauthor_url: String;
    Fimage_url: String;
    Fcontent: TArray<TtphNode>;
    Fviews: Integer;
    Fcan_edit: Boolean;
  public
    destructor Destroy; override;
  published
    /// <summary>
    /// Path to the page.
    /// </summary>
    [Alias('path')]
    property path: String read Fpath write Fpath;
    /// <summary>
    /// URL of the page.
    /// </summary>
    [Alias('url')]
    property url: String read Furl write Furl;
    /// <summary>
    /// Title of the page.
    /// </summary>
    [Alias('title')]
    property title: String read Ftitle write Ftitle;
    /// <summary>
    /// Description of the page.
    /// </summary>
    [Alias('description')]
    property description: String read Fdescription write Fdescription;
    /// <summary>
    /// Optional. Name of the author, displayed below the title.
    /// </summary>
    [Alias('author_name')]
    property author_name: String read Fauthor_name write Fauthor_name;
    /// <summary>
    /// Optional. Profile link, opened when users click on the author's name
    /// below the title. Can be any link, not necessarily to a Telegram
    /// profile or channel.
    /// </summary>
    [Alias('author_url')]
    property author_url: String read Fauthor_url write Fauthor_url;
    /// <summary>
    /// Optional. Image URL of the page.
    /// </summary>
    [Alias('image_url')]
    property image_url: String read Fimage_url write Fimage_url;
    /// <summary>
    /// Optional. Content of the page.
    /// </summary>
    [Alias('content')]
    property content: TArray<TtphNode> read Fcontent write Fcontent;
    /// <summary>
    /// Number of page views for the page.
    /// </summary>
    [Alias('views')]
    property views: Integer read Fviews write Fviews;
    /// <summary>
    /// Optional. Only returned if access_token passed. True, if the target
    /// Telegraph account can edit the page.
    /// </summary>
    [Alias('can_edit')]
    property can_edit: Boolean read Fcan_edit write Fcan_edit;
  End;

  /// <summary>
  /// This object represents a list of Telegraph articles belonging to an
  /// account. Most recently created articles first.
  /// </summary>
  [Alias('PageList')]
  TtphPageList = Class
  private
    Ftotal_count: Integer;
    Fpages: TArray<TtphPage>;
  public
    destructor Destroy; override;
  published
    /// <summary>
    /// Total number of pages belonging to the target Telegraph account.
    /// </summary>
    [Alias('total_count')]
    property total_count: Integer read Ftotal_count write Ftotal_count;
    /// <summary>
    /// Requested pages of the target Telegraph account.
    /// </summary>
    [Alias('pages')]
    property pages: TArray<TtphPage> read Fpages write Fpages;
  End;

  /// <summary>
  /// This object represents a Telegraph account.
  /// </summary>
  [Alias('')]
  TtphAccount = Class
  private
    Fshort_name: String;
    Fauthor_name: String;
    Fauthor_url: String;
    Faccess_token: String;
    Fauth_url: String;
    Fpage_count: Integer;
  published
    /// <summary>
    /// Account name, helps users with several accounts remember which they
    /// are currently using. Displayed to the user above the "Edit/Publish"
    /// button on Telegra.ph, other users don't see this name.
    /// </summary>
    [Alias('short_name')]
    property short_name: String read Fshort_name write Fshort_name;
    /// <summary>
    /// Default author name used when creating new articles.
    /// </summary>
    [Alias('author_name')]
    property author_name: String read Fauthor_name write Fauthor_name;
    /// <summary>
    /// Profile link, opened when users click on the author's name below the
    /// title. Can be any link, not necessarily to a Telegram profile or
    /// channel.
    /// </summary>
    [Alias('author_url')]
    property author_url: String read Fauthor_url write Fauthor_url;
    /// <summary>
    /// Optional. Only returned by the createAccount and revokeAccessToken
    /// method. Access token of the Telegraph account.
    /// </summary>
    [Alias('access_token')]
    property access_token: String read Faccess_token write Faccess_token;
    /// <summary>
    /// Optional. URL to authorize a browser on telegra.ph and connect it to
    /// a Telegraph account. This URL is valid for only one use and for 5
    /// minutes only.
    /// </summary>
    [Alias('auth_url')]
    property auth_url: String read Fauth_url write Fauth_url;
    /// <summary>
    /// Optional. Number of pages belonging to the Telegraph account.
    /// </summary>
    [Alias('page_count')]
    property page_count: Integer read Fpage_count write Fpage_count;
  End;

  /// <summary>
  /// This object represents the number of page views for a Telegraph
  /// article.
  /// </summary>
  [Alias('PageViews')]
  TtphPageViews = Class
  private
    Fviews: Integer;
  published
    /// <summary>
    /// Number of page views for the target page.
    /// </summary>
    [Alias('views')]
    property views: Integer read Fviews write Fviews;
  End;

  [Alias('')]
  TtphApiResponse<T> = Class
  private
    FOk: Boolean;
    FResultObject: T;
    FMessage: String;
    FCode: Integer;
    Ferror: String;
  public
    destructor Destroy; override;
  published
    [Alias('ok')]
    property Ok: Boolean read FOk write FOk;
    [Alias('result')]
    property ResultObject: T read FResultObject write FResultObject;
    [Alias('error')]
    property Error: String read Ferror write Ferror;
  End;

implementation

{ TtphApiResponse<T> }

destructor TtphApiResponse<T>.Destroy;
begin
  if System.GetTypeKind(FResultObject) = tkClass then
{$IFNDEF AUTOREFCOUNT}
    FreeAndNil(FResultObject);
{$ENDIF}
  inherited;
end;

{ TtphNode }

destructor TtphNode.Destroy;
var
  I: Integer;
begin
  for I := Low(Fchildren) to High(Fchildren) do
    FreeAndNil(Fchildren[I]);
  inherited;
end;

{ TtphPage }

destructor TtphPage.Destroy;
var
  I: Integer;
begin
  for I := Low(Fcontent) to High(Fcontent) do
    FreeAndNil(Fcontent[I]);
  inherited;
end;

{ TtphPageList }

destructor TtphPageList.Destroy;
var
  I: Integer;
begin
  for I := Low(Fpages) to High(Fpages) do
    FreeAndNil(Fpages);
  inherited;
end;

end.

unit MaketSystem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  Grobal2;

const

  MAKET_ITEMCOUNT_PER_PAGE = 10;
  MAKET_MAX_PAGE      = 15;
  MAKET_MAX_ITEM_COUNT = MAKET_ITEMCOUNT_PER_PAGE * MAKET_MAX_PAGE;
  MARKET_CHARGE_MONEY = 1000;
  MARKET_ALLOW_LEVEL  = 1;           // 1 ���� �̻� �ȴ�.
  MARKET_COMMISION    = 10;          // 1000 ���� 1 ������ ����
  MARKET_MAX_TRUST_MONEY = 50000000; //�ִ�ݾ�
  MARKET_MAX_SELL_COUNT = 5;         // �ִ� ����� �ǳ�.

  MAKET_STATE_EMPTY   = 0;
  MAKET_STATE_LOADING = 1;
  MAKET_STATE_LOADED  = 2;

{
    TMaketItem = record
      Item     : TClientItem;  // ����� �ɷ�ġ�� ���⿡ �����.
      SellIndex  : integer;      // �ǸŹ�ȣ
      SellPrice  : integer;      // �Ǹ� ����
      SellWho  : string[20];  // �Ǹ���
      Selldate  : string[10]   // �Ǹų�¥(0312311210 = 2003-12-31 12:10 )
      SellState : word          // 1 = �Ǹ��� , 2 = �ǸſϷ�
   end;
}

type

  TMarketItemManager = class(TObject)
  private
    FState: integer;  // �޴��� ����  0 = Empty , 1 = Loading 2 = Full

    FMaxPage:    integer;  // �ִ� ������
    FCurrPage:   integer;  // ���� ������
    FLoadedpage: integer;  // �ε��� �ִ� ������

    FItems: TList;    // MaketItem �� ����Ʈ
    FSelectedIndex: integer;  // ���õ� �ε���

    FUserMode: integer;
    FItemType: integer;
  private
    procedure RemoveAll;
    procedure InitFirst;

    function CheckIndex(index_: integer): boolean;
  public
    ReqInfo: TMarKetReqInfo;
    constructor Create;
    destructor Destroy; override;

    procedure Load;
    procedure ReLoad;

    procedure Add(pInfo_: PTMarketItem);
    procedure Delete(Index_: integer);
    procedure Clear;

    function GetItem(Index_: integer; var rSelected: boolean): PTMarketItem;
      overload;
    function GetItem(Index_: integer): PTMarketItem; overload;
    function IsExistIndex(Index_: integer; var rMoney_: integer): boolean;
    function IsMyItem(Index_: integer; CharName_: string): boolean;
    function Select(Index_: integer): boolean;
    function IsEmpty: boolean;
    function Count: integer;
    function PageCount: integer;

    procedure OnMsgReadData;
    procedure OnMsgWriteData;

    property UserMode: integer Read FUserMode Write FUserMode;
    property ItemType: integer Read FItemType Write FItemType;
    property LodedPage: integer Read FLoadedPage;
    property CurrPage: integer Read FCurrPage Write FCurrPage;

  end;

implementation

// ������
constructor TMarketItemManager.Create;
begin
  inherited;

  FItems := TList.Create;
  InitFirst;
end;
// �Ҹ���
destructor TMarketItemManager.Destroy;
begin
  RemoveAll;
  FItems.Free;

  inherited;
end;

// ������ ����
procedure TMarketItemManager.RemoveAll;
var
  i:     integer;
  pinfo: PTMarketItem;
begin
  for i := FItems.Count - 1 downto 0 do begin
    pinfo := FItems.Items[i];

    if pinfo <> nil then
      dispose(pinfo);

    FItems.Delete(i);
  end;
  FItems.Clear;

  FState := MAKET_STATE_EMPTY;
end;

function TMarketItemManager.CheckIndex(Index_: integer): boolean;
begin
  if (Index_ >= 0) and (Index_ < FItems.Count) then
    Result := True
  else
    Result := False;
end;

// �ʱ�ȭ
procedure TMarketItemManager.InitFirst;
begin
  FSelectedIndex := -1;
  FState := MAKET_STATE_EMPTY;

  ReqInfo.UserName   := '';
  ReqInfo.MarketName := '';
  ReqInfo.SearchWho  := '';
  ReqInfo.SearchItem := '';
  ReqInfo.ItemType   := 0;
  ReqInfo.ItemSet    := 0;
  ReqInfo.UserMode   := 0;
end;

// ������ �о��
procedure TMarketItemManager.Load;
begin
  if IsEmpty and (FState = MAKET_STATE_EMPTY) then begin
    // ������ �б����� �޼��� ����
    OnMsgReadData;
  end;
end;

procedure TMarketItemManager.ReLoad;
begin
  if not IsEmpty then
    RemoveAll;

  Load;
end;

//������ �߰�
procedure TMarketItemManager.Add(pInfo_: PTMarketItem);
begin
  if (FItems <> nil) and (pInfo_ <> nil) then begin
    FItems.Add(pInfo_);
  end;

  //���������� ����
  if (FItems.Count mod MAKET_ITEMCOUNT_PER_PAGE) = 0 then
    FLoadedpage := (FItems.Count div MAKET_ITEMCOUNT_PER_PAGE)
  else
    FLoadedpage := (FItems.Count div MAKET_ITEMCOUNT_PER_PAGE) + 1;

end;

//������ ����
procedure TMarketItemManager.Delete(Index_: integer);
begin

end;

procedure TMarketItemManager.Clear;
begin
  RemoveAll;
  FSelectedIndex := -1;
  FState := MAKET_STATE_EMPTY;

end;

// ������ ����
function TMarketItemManager.Select(Index_: integer): boolean;
begin
  Result := False;

  if CheckIndex(Index_) then begin
    FSelectedIndex := Index_;
    Result := True;
  end;
end;

//�����Ͱ� ����ִ���
function TMarketItemManager.IsEmpty: boolean;
begin
  if FItems.Count > 0 then
    Result := False
  else
    Result := True;

end;

//������ ���´�.
function TMarketItemManager.Count: integer;
begin
  Result := FItems.Count;
end;

// ���������ڸ� �����´�.
function TMarketItemManager.PageCount: integer;
begin
  if FItems.Count mod MAKET_ITEMCOUNT_PER_PAGE = 0 then
    Result := FItems.Count div MAKET_ITEMCOUNT_PER_PAGE
  else
    Result := (FItems.Count div MAKET_ITEMCOUNT_PER_PAGE) + 1;
end;



//�����͸� �о�ö� ���õȳ����� �����Ѵ�.
function TMarketItemManager.GetItem(Index_: integer;     // ������ �ε���
  var rSelected: boolean      // ���õȳ����� ������
  ): PTMarketItem;
begin
  // �����͸� ���
  Result := GetItem(Index_);

  // ���õȳѰ� ������ TRUE
  if Result <> nil then begin
    if Index_ = FSelectedIndex then
      rSelected := True
    else
      rSelected := False;
  end;

end;

// ������ �о���̱�.
function TMarketItemManager.GetItem(Index_: integer      // ������ �ε���
  ): PTMarketItem;
begin
  Result := nil;

  if checkIndex(Index_) then begin
    Result := PTMarketItem(FItems.Items[Index_]);

  end;
end;

//�ε����� �ֳ� ���캸��.
function TMarketItemManager.IsExistIndex(Index_: integer;
  var rMoney_: integer): boolean;
var
  i:     integer;
  pInfo: PTMarketItem;
begin
  Result  := False;
  rMoney_ := 0;

  for i := 0 to FItems.Count - 1 do begin
    pInfo := FItems[i];

    if pInfo <> nil then begin
      if pInfo.Index = index_ then begin
        Result  := True;
        rMoney_ := pInfo.SellPrice;
        Exit;
      end;
    end;

  end;

end;

function TMarketItemManager.IsMyItem(Index_: integer; CharName_: string): boolean;
var
  i:     integer;
  pInfo: PTMarketItem;
begin
  Result := False;
  if CharName_ = '' then
    Exit;

  for i := 0 to FItems.Count - 1 do begin
    pInfo := FItems[i];

    if pInfo <> nil then begin
      if pInfo.Index = index_ then begin
        if (pInfo.SellWho = CharName_) then
          Result := True;
        Exit;
      end;
    end;

  end;

end;

// �������� �޼��� ���۹� ���� -------------------------------------------------
procedure TMarketItemManager.OnMsgReadData;
begin

end;

procedure TMarketItemManager.OnMsgWriteData;
begin

end;

end.

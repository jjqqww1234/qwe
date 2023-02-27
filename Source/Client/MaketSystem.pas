unit MaketSystem;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Dialogs,
  Grobal2, HUtil32, EdCode;

const

  MAKET_ITEMCOUNT_PER_PAGE = 10;
  MAKET_MAX_PAGE = 12;
  MAKET_MAX_ITEM_COUNT = MAKET_ITEMCOUNT_PER_PAGE * MAKET_MAX_PAGE;

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
    bFirst:    integer;
  public
    RecvCurPage: integer;
    RecvMaxPage: integer;
  private
    procedure RemoveAll;
    procedure InitFirst;

    function CheckIndex(index_: integer): boolean;
  public
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
    function Select(Index_: integer): boolean;
    function IsEmpty: boolean;
    function Count: integer;
    function GetFirst: integer;
    function PageCount: integer;
    function GetUserMode: integer;
    function GetItemType: integer;

    procedure OnMsgReadData(msg: TDefaultMessage; body: string);
    procedure OnMsgWriteData(msg: TDefaultMessage; body: string);

  end;

var
  g_Market: TMarketItemManager;

implementation

uses
  ClMain;

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

  RecvCurPage := 0;
  RecvMaxPage := 0;
end;

// ������ �о��
procedure TMarketItemManager.Load;
begin
  if IsEmpty and (FState = MAKET_STATE_EMPTY) then begin
    // ������ �б����� �޼��� ����
    //        OnMsgReadData;
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
end;

//������ ����
procedure TMarketItemManager.Delete(Index_: integer);
begin

end;

procedure TMarketItemManager.Clear;
begin
  RemoveAll;
  InitFirst;
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

function TMarketItemManager.GetFirst: integer;
begin
  Result := bFirst;
end;

// ���������ڸ� �����´�.
function TMarketItemManager.PageCount: integer;
begin
  if FItems.Count = 0 then
    Result := 0
  else
    Result := FItems.Count div MAKET_ITEMCOUNT_PER_PAGE + 1;
end;

function TMarketItemManager.GetUserMode: integer;
begin
  Result := FUserMode;
end;

function TMarketItemManager.GetItemType: integer;
begin
  Result := FitemType;
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


// �������� �޼��� ���۹� ���� -------------------------------------------------
procedure TMarketItemManager.OnMsgReadData(msg: TDefaultMessage; body: string);
begin

end;

procedure TMarketItemManager.OnMsgWriteData(msg: TDefaultMessage; body: string);
var
  //    itemtype    : integer;
  //    bFirst      : integer;
  nCount: integer;
  i:      integer;
  pInfo:  PTMarketItem;
  buffer1: string;
  buffer2: string;
begin
  //    DScreen.AddSysMsg ('GET MARKET MSG');

  case msg.Ident of
    SM_MARKET_LIST: begin
      FUserMode := msg.Recog;
      FItemType := msg.Param;
      bFirst    := msg.Tag;

      buffer1 := DecodeString(body);

      if bFirst > 0 then
        Clear;

      buffer1 := GetValidStr3(buffer1, buffer2, ['/']);
      nCount  := Str_ToInt(buffer2, 0);

      buffer1     := GetValidStr3(buffer1, buffer2, ['/']);
      RecvCurPage := Str_ToInt(buffer2, 0);

      buffer1     := GetValidStr3(buffer1, buffer2, ['/']);
      RecvMaxPage := Str_ToInt(buffer2, 0);

      for i := 0 to nCount - 1 do begin

        buffer1 := GetValidStr3(buffer1, buffer2, ['/']);
        new(pInfo);
        DecodeBuffer(buffer2, pointer(pInfo), sizeof(TMarketItem));

        Add(pInfo);
      end;

    end;
  end;
end;

end.
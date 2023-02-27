object RES_DATAS: TRES_DATAS
  OldCreateOrder = False
  Left = 260
  Top = 104
  Height = 640
  Width = 870
  object LeftDataSource: TDataSource
    DataSet = LeftTable
    Left = 109
    Top = 80
  end
  object RightDataSource: TDataSource
    DataSet = RightTable
    Left = 227
    Top = 80
  end
  object MagicDataSource: TDataSource
    DataSet = MagicTable
    Left = 233
    Top = 200
  end
  object ItemDataSource: TDataSource
    DataSet = ItemTable
    Left = 111
    Top = 200
  end
  object LeftTable: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    IndexFieldNames = 'MOBNAME'
    MasterFields = 'NAME'
    MasterSource = RightDataSource
    TableName = 'RES_MOBITEM'
    Left = 104
    Top = 24
  end
  object RightTable: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'RES_MONSTER'
    Left = 224
    Top = 32
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Provider=SQLOLEDB.1;Password=dpfh;Persist Security Info=True;Use' +
      'r ID=sa;Initial Catalog=Mir2ResTai;Data Source=PARK_DAE_SUNG'
    LoginPrompt = False
    Provider = 'SQLOLEDB.1'
    Left = 32
    Top = 24
  end
  object ADOQuery1: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'select name from res_stditems')
    Left = 32
    Top = 152
  end
  object ItemTable: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'RES_STDITEMS'
    Left = 104
    Top = 152
  end
  object MagicTable: TADOTable
    Connection = ADOConnection1
    CursorType = ctStatic
    TableName = 'RES_MAGIC'
    Left = 232
    Top = 144
  end
  object MobItemQuery: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 32
    Top = 288
  end
  object MobItemSource: TDataSource
    AutoEdit = False
    DataSet = MobItemQuery
    Left = 104
    Top = 288
  end
end

unit Frontoperate_newCustomerUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, ADODB, SPComm, ExtCtrls, StdCtrls, Buttons;

type
  Tfrm_Frontoperate_newCustomer = class(TForm)
    Panel1: TPanel;
    GroupBox5: TGroupBox;
    Label8: TLabel;
    Label13: TLabel;
    Panel2: TPanel;
    Bit_Add: TBitBtn;
    Bit_Close: TBitBtn;
    Edit_Customer_NO: TEdit;
    Edit_Customer_Telephone: TEdit;
    ADOQuery_newCustomer: TADOQuery;
    DataSource_Newmenber: TDataSource;
    Label3: TLabel;
    Edit_Customer_desc: TEdit;
    Label2: TLabel;
    Edit_Customer_name: TEdit;
    Label1: TLabel;
    Edit_Customer_QQ: TEdit;
    Panel_Message: TPanel;
    procedure Bit_AddClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Bit_CloseClick(Sender: TObject);
    procedure Edit_Customer_NOKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure SaveData_CustomerInfor;
    procedure Query_CustomerName_INdatabase;
  end;

var
  frm_Frontoperate_newCustomer: Tfrm_Frontoperate_newCustomer;

implementation

uses ICDataModule, strprocess;

{$R *.dfm}

procedure Tfrm_Frontoperate_newCustomer.Bit_AddClick(Sender: TObject);
begin
  if length(Edit_Customer_NO.Text) = 0 then
  begin
    Panel_Message.Caption := '出厂场地密码不能为空！';
    exit;
  end;

  SaveData_CustomerInfor;
  Query_CustomerName_INdatabase;
  Panel_Message.Caption := '';
  Edit_Customer_desc.Text := '';
    //Edit_Customer_NO.Text:='';
  Edit_Customer_Telephone.Text := '';
  Edit_Customer_QQ.text := '';
end;


//保存当前记录，包括流水号、积分值等信息

procedure Tfrm_Frontoperate_newCustomer.SaveData_CustomerInfor;
var
  strSQL: string;
  str1: string;
  StrYear: string;
begin
  strSQL := 'select * from [3F_Customer_Infor] ';
  with ADOQuery_newCustomer do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;
    Append;
    FieldByName('Customer_email').AsString := Edit_Customer_desc.Text;
    FieldByName('Customer_Name').AsString := Edit_Customer_Name.Text;
    FieldByName('Customer_NO').AsString := Edit_Customer_NO.Text;
    FieldByName('Customer_Telephone').AsString := Edit_Customer_Telephone.Text;
    FieldByName('Customer_QQ').AsString := Edit_Customer_QQ.text;
    //added by linlf 追加日期
    FieldByName('OUTFactory_Time').AsString := FormatDateTime('yyyy-MM-dd HH:mm:ss', now); //出厂日期
    Post;
    Active := False;
  end;
end;

procedure Tfrm_Frontoperate_newCustomer.FormShow(Sender: TObject);
begin
  Query_CustomerName_INdatabase;
  Edit_Customer_NO.Enabled := false;
  Panel_Message.Caption := '';
  Edit_Customer_desc.Text := '';
    //Edit_Customer_NO.Text:='';
  Edit_Customer_Telephone.Text := '';
  Edit_Customer_QQ.text := '';
end;
//根据读取的条码值流水，查询数据库中是否已经有相同记录，如果有则提示

procedure Tfrm_Frontoperate_newCustomer.Query_CustomerName_INdatabase;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  reTmpStr: Integer;
  strCustomer_NO: string;
  StrYear: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
//  strSQL := 'select Count(ID)  FROM [3F_Customer_Infor]';
  strSQL := 'select max(customer_no)  FROM [3F_Customer_Infor]';

  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    if (RecordCount > 0) then
    begin

      reTmpStr := StrToInt(ADOQTemp.Fields[0].AsString) + 1;

    end;
  end;
  FreeAndNil(ADOQTemp);

  StrYear := Copy(FormatDateTime('yyyy-MM-dd HH:mm:ss', now), 1, 4);
  //modified by linlf 20140309,use strprocess字符串公共函数;
  strCustomer_NO := '3F' + StrYear + IntToStrPad0(reTmpStr, 6, true);
                 
  Edit_Customer_Name.Text := strCustomer_NO;
  Edit_Customer_NO.Text := Copy(strCustomer_NO, length(strCustomer_NO) - 5, 6);



end;

procedure Tfrm_Frontoperate_newCustomer.Bit_CloseClick(Sender: TObject);
begin
  close;
end;

procedure Tfrm_Frontoperate_newCustomer.Edit_Customer_NOKeyPress(
  Sender: TObject; var Key: Char);
begin
  Panel_Message.Caption := '';
  if not (key in ['0'..'9', #8, #13]) then
  begin
    key := #0;
    ShowMessage('输入错误，只能输入数字');
  end;
     //else if key=#13 then
    // begin

     //     if length(Edit_old_Password_Input.Text)=6 then
     //         BitBtn_ChangBossPassword.setfocus;
    // end;

end;

end.

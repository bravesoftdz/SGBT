unit QC_AE_LineBarscanUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, SPComm, DB, ADODB, ExtCtrls, StdCtrls, OleCtrls,
  Buttons, Grids, DBGrids, ComCtrls;

type
  TfrmExchangeLottry = class(TForm)
    DataSourceBar: TDataSource;
    ADOQueryBar: TADOQuery;
    Panel2: TPanel;
    GroupBox1: TGroupBox;
    GroupBox6: TGroupBox;
    Label3: TLabel;
    Label2: TLabel;
    Label1: TLabel;
    Label4: TLabel;
    Label15: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Image1: TImage;
    edtBarScan: TEdit;
    edtCoin: TEdit;
    edtCardHeadID: TEdit;
    edtPrintTime: TEdit;
    btnExchangeLottry: TBitBtn;
    edtBarflow1: TEdit;
    btnClose: TBitBtn;
    edtLastCardHeadID: TEdit;
    edtProportion: TEdit;
    GroupBox2: TGroupBox;
    dgBarRecord: TDBGrid;
    BarCodeCOM2: TComm;
    edtBarflow2: TEdit;
    Label11: TLabel;
    Panel_Infor: TLabel;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnExchangeLottryClick(Sender: TObject);
    procedure BarCodeCOM2ReceiveData(Sender: TObject; Buffer: Pointer; BufferLength: Word);

  private
    { Private declarations }
    //数据库
    procedure InitDataBaseBarFlow; //条码
    function checkUniqueFirstBarFlow(strflow: string): Boolean;
    procedure SaveBarScanRecord(firstbar: string; secondbar: string);
    procedure ClearText;                                             
    procedure CheckCMDFromBarCodeCom2();


  public
    { Public declarations }
  end;

var
  frmExchangeLottry: TfrmExchangeLottry;
  curOrderNo: integer = 0;
  curOperNo: integer = 0;
  curScanNo: integer = 0;
  TotalCore: integer = 0;
  Operate_No: integer = 0;

  curOrderNo_Barcode: integer = 0;
  curOperNo_Barcode: integer = 0;
  curScanNo_Barcode: integer = 0;
  TotalCore_Barcode: integer = 0;
  Operate_No_Barcode: integer = 0;

  BAR1_CARDNO, BAR2_CARDNO: string;
  Tuibi_Operate_Enable: string;
  buffer: array[0..2048] of byte;
  BAR_Type1, BAR_Type2: string;
  orderLst_Barcode, recDataLst_Barcode, recData_fromICLst_Barcode: Tstrings;

  User_Pwd_Comfir: boolean;
  strInvalidresult: string = '1111';

implementation
uses SetParameterUnit, ICDataModule, ICCommunalVarUnit, ICEventTypeUnit, ICFunctionUnit
,Fileinput_machinerecordUnit
,Frontoperate_InitCardIDUnit;
{$R *.dfm}

//初始化数据库
procedure TfrmExchangeLottry.InitDataBaseBarFlow;
var
  strSQL: string;
begin
  strSQL := 'select  * from T_BAR_FLOW order by PRINT_TIME desc LIMIT 10';
  ICFunction.loginfo('strSQL :' + strSQL);
  with ADOQueryBar do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
  end;

end;


procedure TfrmExchangeLottry.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  i: integer;
begin
    //清理表格
  for i := 0 to ComponentCount - 1 do
  begin
    if components[i] is TEdit then
    begin
      (components[i] as TEdit).Clear;
    end
  end;


  orderLst_Barcode.Free();
  recDataLst_Barcode.Free();
  recData_fromICLst_Barcode.Free();
  BarCodeCOM2.StopComm();


end;



//保存当前记录，包括流水号、积分值等信息 
procedure TfrmExchangeLottry.SaveBarScanRecord(firstbar: string; secondbar: string);
var
  strSQL: string;
  strOperatetime: string;
//  tmptotalcore: integer;
begin
  SaveData_OK_flag := false;
  ShortDateFormat := 'yyyy-MM-dd'; //指定格式即可
  DateSeparator := '-';
  strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);



  if not frm_bind_cardheadid.checkUniqueBindCardHeadID(TrimRight(edtCardHeadID.Text)) then
  begin
    ShowMessage('当前条码的卡头ID号，在此系统未注册登陆！');
    exit;
  end;

  if (strtoint(TrimRight(edtProportion.Text)) > 20000) then
  begin
    edtProportion.Text := '';
    edtCoin.Text := '';
    MessageDlg('扫描异常，请重新扫描', mtConfirmation, [mbYes, mbNo], 0); 
    exit;
  end;

  strSQL := 'select * from T_BAR_FLOW  order by PRINT_TIME desc limit 10 ';
  ICFunction.loginfo('strSQL :' + strSQL);

  with ADOQueryBar do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;
    Append;
    FieldByName('FIRSTBAR').AsString := firstbar;
    FieldByName('SECONDBAR').AsString := secondbar;
    FieldByName('CARDHEADID').AsString := edtCardHeadID.Text; //卡头ID
    FieldByName('COIN').AsString := TrimRight(IntToStr(strToInt(edtCoin.Text))); 
    FieldByName('MACHINE_NAME').AsString := frm_bind_cardheadid.getMachineNameByCardHeadID(edtCardHeadID.Text);
    FieldByName('POSITION_NO').AsString := frm_bind_cardheadid.getPositionNoByCardHeadID(edtCardHeadID.Text);
    FieldByName('PRINT_TIME').AsString := edtPrintTime.Text;
    FieldByName('OPERATE_TIME').AsString := strOperateTime;
    FieldByName('OPERATOR_NO').AsString := G_User.UserName;  
    FieldByName('COIN_PROPORTION').AsString := edtProportion.Text; 
    Post;
    Active := False;
  end;
  

  SaveData_OK_flag := true; //保存操作完成




end;



procedure TfrmExchangeLottry.ClearText;
begin
  edtBarScan.text := '';
  edtCoin.text := '';
  edtCardHeadID.text := '';
  edtPrintTime.text := '';
  edtBarflow1.text := '';
  edtBarflow2.text := '';
end;

procedure TfrmExchangeLottry.FormShow(Sender: TObject);
begin
  InitDataBaseBarFlow();
//  InitDataBase_Tuibi();
    //加载配置文件
  ICFunction.InitSystemWorkground;
//  Edit_ID.Text := '';
//  Edit_UserPwd.Text := '';
  edtBarScan.Text := '';
  edtCoin.Text := '';
  edtProportion.Text := '';
  edtCardHeadID.Text := '';
  edtPrintTime.Text := '';
  edtLastCardHeadID.Text := '';
  edtBarflow1.text := '';
  edtBarflow2.text := '';

  BarCodeCOM2.StartComm();
  orderLst_BarCode := TStringList.Create;
  recDataLst_BarCode := tStringList.Create;
  recData_fromICLst_BarCode := tStringList.Create;
  ClearText;

end;



 



procedure TfrmExchangeLottry.btnCloseClick(Sender: TObject);
begin
  close;
end;

procedure TfrmExchangeLottry.btnExchangeLottryClick(Sender: TObject);
begin
  if BarCodeValue_OnlyCheck = 2 then
  begin
    SaveBarScanRecord(BarCodeValue_FLOW, BarCodeValue_CORE);
    if SaveData_OK_flag then
    begin
      BarCodeValue_OnlyCheck := 0; //清除
    end;
  end;
end;






 //根据接收到的数据判断此卡是否为合法卡 
procedure TfrmExchangeLottry.CheckCMDFromBarCodeCom2();
var
  i: integer;
  tmpStr: string;
  tmpStr_Barcode: string;

  stationNoStr: string;
  tmpStr_Hex: string;
  tmpStr_Hex_length: string;
  Send_value: string;
  RevComd: integer;
  ID_No: string;
  length_Data: integer;

  strTemp: string;
  tempStr: string;
  firstbit: string; //确定扫描的是哪一个条码
  FirstframeHex: string;
begin

   //首先截取接收的信息
  tmpStr_Barcode := recData_fromICLst_Barcode.Strings[0];

  ICFunction.loginfo('data return from Scanner : ' + tmpStr_Barcode);
  
  FirstframeHex := copy(tmpStr_Barcode, 1, 2);
  BarCodeValue := ICFunction.ChangeAreaHEXToStr(copy(tmpStr_Barcode, 3, length(tmpStr_Barcode) - 2));
  if (FirstframeHex = '39') then
  begin
    firstbit := 'A';
  end
  else if (FirstframeHex = '30') then
  begin
    firstbit := 'B';
  end
  else if (FirstframeHex = BarCodeFirstFrame[0]) then
  begin
    firstbit := 'A';
  end
  else if (FirstframeHex = BarCodeFirstFrame[1]) then
  begin
    firstbit := 'B';
  end
  else if (FirstframeHex = BarCodeFirstFrame[2]) then
  begin
    firstbit := 'C'; //35
  end
  else if (FirstframeHex = BarCodeFirstFrame[3]) then
  begin
    firstbit := 'D'; //36
  end
  else if (FirstframeHex = BarCodeFirstFrame[4]) then
  begin
    firstbit := 'E'; //37
  end
  else
  begin
    ShowMessage('请确认是否为本场地条码！');
    BarCodeValue := '';
    exit;
  end;

  begin


  tempStr := '0' + BarCodeValue;
  ICFunction.loginfo('ASCII String data return from Scanner tempStr : ' + tempStr);
    
  Panel_Infor.Caption := '';

        //交易记录 流水机台条码(FirstBar)，9-A
   if (firstbit = 'A') and ((length(tempStr) = 21) or (length(tempStr) = 20)) then
    begin  
        BAR_Type1 := 'A';
        edtBarScan.Text := tempStr;
        BarCodeValue_FLOW := tempStr; //条码1
        BarCodeValue := '';    
        //打印时间
        edtPrintTime.Text := copy(tempStr, 15, 1) + copy(tempStr, 12, 1) + '-'
                            + copy(tempStr, 4, 1) + copy(tempStr, 7, 1)
                            + '   ' + copy(tempStr, 2, 1) + copy(tempStr, 18, 1)
                            + ':' + copy(tempStr, 10, 1) + copy(tempStr, 5, 1);
        if (length(tempStr) = 21) then
        begin
          edtCardHeadID.Text := copy(tempStr, 20, 1) + copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
          BAR1_CARDNO := edtCardHeadID.Text;
        end 
        else if (length(tempStr) = 20) then
        begin
          edtCardHeadID.Text := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
          BAR1_CARDNO := edtCardHeadID.Text;
        end;
        edtBarflow1.text := copy(tempStr, 3, 1) + copy(tempStr, 9, 1) + copy(tempStr, 17, 1) + copy(tempStr, 14, 1) + copy(tempStr, 19, 1) + copy(tempStr, 8, 1) + copy(tempStr, 16, 1);
        strInvalidresult := copy(tempstr, 15, 1) + copy(tempstr, 12, 1) + copy(tempstr, 4, 1) + copy(tempstr, 7, 1);


    end
         //交易记录-积分条码(SecondBar)，0-B
    else if (firstbit = 'B') and ((length(tempStr) = 23) or (length(tempStr) = 22)) then
    begin  
        BAR_Type2 := 'B';
        edtBarScan.Text := '';
        BarCodeValue_CORE := tempStr;
        edtBarScan.Text := copy(tempStr, 2, 21);
        BarCodeValue := '';

                 //积分
        edtCoin.Text :=   copy(tempStr, 3, 1)
                        + copy(tempStr, 5, 1)
                        + copy(tempStr, 11, 1)
                        + copy(tempStr, 20, 1)
                        + copy(tempStr, 17, 1)
                        + copy(tempStr, 7, 1)
                        + copy(tempStr, 14, 1);

        ICFunction.loginfo('edtCoin.Text: ' + edtCoin.Text);
        //问题遗留
//        ICFunction.loginfo('edtCoin.Text: ' + strToInt(edtCoin.Text) + ' SGBTCOININFO.coinproportion: ' + strToInt(SGBTCOININFO.coinproportion) );
        edtProportion.Text := IntToStr( strToInt(edtCoin.Text) div strToInt(SGBTCOININFO.coinproportion) );

        ICFunction.loginfo('edtProportion.Text: ' + edtProportion.Text);

        edtLastCardHeadID.Text := copy(tempStr, 21, 1)
                                + copy(tempStr, 12, 1)
                                + copy(tempStr, 4, 1)
                                + copy(tempStr, 16, 1)
                                + copy(tempStr, 6, 1)
                                + copy(tempStr, 19, 1)
                                + copy(tempStr, 9, 1)
                                + copy(tempStr, 15, 1)
                                + copy(tempStr, 18, 1)
                                + copy(tempStr, 10, 1);
        ICFunction.loginfo('edtLastCardHeadID.Text: ' + edtLastCardHeadID.Text);

        edtBarflow2.Text := copy(tempStr, 21, 1)
                          + copy(tempStr, 4, 1)
                          + copy(tempStr, 19, 1)
                          + copy(tempStr, 16, 1)
                          + copy(tempStr, 9, 1)
                          + copy(tempStr, 12, 1)
                          + copy(tempStr, 6, 1);

        ICFunction.loginfo('edtBarflow2.Text: ' + edtBarflow2.Text);
        if (length(tempStr) = 23) then
        begin
          BAR2_CARDNO := copy(tempStr, 22, 1) + copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);
          edtCardHeadID.Text := BAR2_CARDNO;
          ICFunction.loginfo('edtBarflow2.Text: ' + edtBarflow2.Text);
        end
        else if (length(tempStr) = 22) then
        begin
          BAR2_CARDNO := copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);
          edtCardHeadID.Text := BAR2_CARDNO;
          ICFunction.loginfo('edtBarflow2.Text: ' + edtBarflow2.Text);
        end

    end

         //查询退币记录条码-流水机台条码，5-C
    else if (firstbit = 'C') and (length(tempStr) = 21) then
    begin

        BAR_Type1 := 'C';
        edtBarScan.Text := '';
        edtBarScan.Text := tempStr;
        BarCodeValue_FLOW := tempStr;
        BarCodeValue := '';
        edtPrintTime.Text := copy(tempStr, 15, 1) + copy(tempStr, 12, 1) + '-' + copy(tempStr, 4, 1) + copy(tempStr, 7, 1) + '   ' + copy(tempStr, 2, 1) + copy(tempStr, 18, 1) + ':' + copy(tempStr, 10, 1) + copy(tempStr, 5, 1);
        edtCardHeadID.Text := copy(tempStr, 21, 1) + copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
        BAR1_CARDNO := copy(tempStr, 21, 1) + copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
        edtBarflow1.Text := copy(tempStr, 3, 1) + copy(tempStr, 9, 1) + copy(tempStr, 17, 1) + copy(tempStr, 14, 1) + copy(tempStr, 19, 1) + copy(tempStr, 8, 1) + copy(tempStr, 16, 1);

    end
    //查询退币记录条码 -积分条码
    else if (firstbit = 'C') and (length(tempStr) = 23) then
    begin 
        BAR_Type2 := 'C';
        edtBarScan.Text := '';
        BarCodeValue_CORE := tempStr;
        edtBarScan.Text := copy(tempStr, 2, 20);
        BarCodeValue := '';
        edtCoin.Text := IntToStr(StrToInt(copy(tempStr, 3, 1) + copy(tempStr, 5, 1) + copy(tempStr, 11, 1) + copy(tempStr, 20, 1) + copy(tempStr, 17, 1) + copy(tempStr, 7, 1) + copy(tempStr, 14, 1)) div 10);
        edtLastCardHeadID.Text := copy(tempStr, 21, 1) + copy(tempStr, 12, 1) + copy(tempStr, 4, 1) + copy(tempStr, 16, 1) + copy(tempStr, 6, 1) + copy(tempStr, 19, 1) + copy(tempStr, 9, 1) + copy(tempStr, 15, 1) + copy(tempStr, 18, 1) + copy(tempStr, 10, 1);
        BAR2_CARDNO := copy(tempStr, 23, 1) + copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);

    end //查询投币记录条码 -积分条码
    else if (firstbit = 'D') and (length(tempStr) = 20) then
    begin

        BAR_Type1 := 'D';
        edtBarScan.Text := '';
        edtBarScan.Text := tempStr;
        BarCodeValue_FLOW := tempStr;
        BarCodeValue := '';
        edtPrintTime.Text := copy(tempStr, 15, 1) + copy(tempStr, 12, 1) + '-' + copy(tempStr, 4, 1) + copy(tempStr, 7, 1) + '   ' + copy(tempStr, 2, 1) + copy(tempStr, 18, 1) + ':' + copy(tempStr, 10, 1) + copy(tempStr, 5, 1);
        edtCardHeadID.Text := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
        BAR1_CARDNO := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
        edtBarflow1.Text := copy(tempStr, 3, 1) + copy(tempStr, 9, 1) + copy(tempStr, 17, 1) + copy(tempStr, 14, 1) + copy(tempStr, 19, 1) + copy(tempStr, 8, 1) + copy(tempStr, 16, 1);

    end
    else if (firstbit = 'D') and (length(tempStr) = 22) then //查询投币记录条码 -积分条码
    begin 
        BAR_Type2 := 'D';
        edtBarScan.Text := '';
        BarCodeValue_CORE := tempStr;
        edtBarScan.Text := copy(tempStr, 2, 20);
        BarCodeValue := '';
        edtCoin.Text := IntToStr(StrToInt(copy(tempStr, 3, 1) + copy(tempStr, 5, 1) + copy(tempStr, 11, 1) + copy(tempStr, 20, 1) + copy(tempStr, 17, 1) + copy(tempStr, 7, 1) + copy(tempStr, 14, 1)) div 10);
       edtLastCardHeadID.Text := copy(tempStr, 21, 1) + copy(tempStr, 12, 1) + copy(tempStr, 4, 1) + copy(tempStr, 16, 1) + copy(tempStr, 6, 1) + copy(tempStr, 19, 1) + copy(tempStr, 9, 1) + copy(tempStr, 15, 1) + copy(tempStr, 18, 1) + copy(tempStr, 10, 1);
       BAR2_CARDNO := copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);

    end 
         //查询异常发生时投币剩余数据记录条码-流水机台条码，7-E
    else if (firstbit = 'E') and (length(tempStr) = 20) then
    begin

        BAR_Type1 := 'E';
        edtBarScan.Text := '';
        edtBarScan.Text := tempStr;
        BarCodeValue_FLOW := tempStr;
        BarCodeValue := '';
        edtPrintTime.Text := copy(tempStr, 15, 1) + copy(tempStr, 12, 1) + '-' + copy(tempStr, 4, 1) + copy(tempStr, 7, 1) + '   ' + copy(tempStr, 2, 1) + copy(tempStr, 18, 1) + ':' + copy(tempStr, 10, 1) + copy(tempStr, 5, 1);
        edtCardHeadID.Text := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
        BAR1_CARDNO := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
        edtBarflow1.Text := copy(tempStr, 3, 1) + copy(tempStr, 9, 1) + copy(tempStr, 17, 1) + copy(tempStr, 14, 1) + copy(tempStr, 19, 1) + copy(tempStr, 8, 1) + copy(tempStr, 16, 1);

    end
    else if (firstbit = 'E') and (length(tempStr) = 22) then //查询异常发生时投币剩余数据记录条码 -积分条码
    begin

        BAR_Type2 := 'E';
        edtBarScan.Text := '';
        BarCodeValue_CORE := tempStr;
        edtBarScan.Text := copy(tempStr, 2, 20);
        BarCodeValue := '';
        edtCoin.Text := IntToStr(StrToInt(copy(tempStr, 3, 1) + copy(tempStr, 5, 1) + copy(tempStr, 11, 1) + copy(tempStr, 20, 1) + copy(tempStr, 17, 1) + copy(tempStr, 7, 1) + copy(tempStr, 14, 1)) div 10);
        edtLastCardHeadID.Text := copy(tempStr, 21, 1) + copy(tempStr, 12, 1) + copy(tempStr, 4, 1) + copy(tempStr, 16, 1) + copy(tempStr, 6, 1) + copy(tempStr, 19, 1) + copy(tempStr, 9, 1) + copy(tempStr, 15, 1) + copy(tempStr, 18, 1) + copy(tempStr, 10, 1);
        BAR2_CARDNO := copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);

    end;
         //保存条码记录

 //-----------------------------------------------------------------------------
    if (edtBarflow1.Text <> '') and (edtBarflow2.Text <> '') then
    begin
      if (edtBarflow1.Text <> edtBarflow2.Text) then
      begin
        Panel_Infor.Caption := '前后扫描的流水号不一致！';
        ClearText;
        exit;
      end
    end;

     //唯一性判断
    if (edtBarScan.text <> '') and (edtCoin.text <> '') and (edtCardHeadID.text <> '') and (edtPrintTime.text <> '') and (edtBarflow1.text <> '') then
    begin
      //判断扫描的前后条码的卡头ID值是否一致
      if not (BAR1_CARDNO = BAR2_CARDNO) then
      begin
        Panel_Infor.Caption := '前后扫描的机台识别码不一致！';
        exit;
      end;

      //add by linlf 20140413解决查账条码重复入库
      if (strInvalidresult = '0000') then
      begin
        Panel_Infor.Caption := '条码为查询获取的退币记录！';
        exit;
      end;


      //条码类型判断并执行相应事件---正常上、下分条码
      if ((BAR_Type1 = 'A') and (BAR_Type2 = 'B')) or ((BAR_Type1 = 'D') and (BAR_Type2 = 'D')) then
      begin
        if ( checkUniqueFirstBarFlow(BarCodeValue_FLOW) = True ) then //如果有记录
        begin //查询流水号是否唯一
          ClearText;
          Panel_Infor.Caption := '此条码重复使用，请确认！';
          exit;
        end
        else
        begin

            SaveBarScanRecord(BarCodeValue_FLOW, BarCodeValue_CORE);
            if SaveData_OK_flag then
            begin
              BarCodeValue_OnlyCheck := 0; //清除
              InitDataBaseBarFlow();
              SaveData_OK_flag := FALSE;
              BAR_Type1 := '';
              BAR_Type2 := '';
              Panel_Infor.Caption := '数据保存成功';
            end
            else
            begin
              Panel_Infor.Caption := '当前条码卡头ID在系统中未注册！';
            end;

              //-------增加取消密码确认  结束-----------------
        end; //记录唯一判断结束
      end

      else if ((BAR_Type1 = 'C') and (BAR_Type2 = 'C')) then
      begin
        Panel_Infor.Caption := '条码为查询获取的退币记录！';
      end
      else if (BAR_Type1 = 'D') and (BAR_Type2 = 'D') then
      begin
        Panel_Infor.Caption := '条码为查询获取的投币记录！';
      end

      else if (BAR_Type1 = 'E') and (BAR_Type2 = 'E') then
      begin
        Panel_Infor.Caption := '条码为投币异常时剩余的未上分记录！';
      end
      else
      begin
        Panel_Infor.Caption := '错误条码，请确认！';
      end;

    end; 
  end;
end;



//根据读取的条码值流水，查询数据库中是否已经有相同记录，如果有则提示

function TfrmExchangeLottry.checkUniqueFirstBarFlow(strflow: string): Boolean;
var
  ADOQ: TADOQuery;
  strSQL :String;
begin
  ADOQ := TADOQuery.Create(Self);
  ADOQ.Connection := DataModule_3F.ADOConnection_Main;

  with ADOQ do begin
    Close;
    SQL.Clear;
    strSQL := 'select 1 from T_BAR_FLOW where FIRSTBAR=''' + strflow + '''';
    ICFunction.loginfo('Exist check  strSQL: ' + strSQL);
    SQL.Add(strSQL);
    Open;
    if (Eof) then
      result := false
    else
      result := true;
  end;
  ADOQ.Close;
  ADOQ.Free;
end;


//从扫描枪读取的数据
procedure TfrmExchangeLottry.BarCodeCOM2ReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
  i: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //接收----------------
  tmpStrend := 'STR';
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for i := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[i]), 2); //将获得数据转换为16进制数

    if i = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;

  recData_fromICLst_Barcode.Clear;
  recData_fromICLst_Barcode.Add(recStr);
  CheckCMDFromBarCodeCom2(); //首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡 
end;

end.

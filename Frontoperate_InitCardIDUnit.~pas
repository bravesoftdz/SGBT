unit Frontoperate_InitCardIDUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, IniFiles,
  Dialogs, DB, ADODB, SPComm, StdCtrls, Buttons, ExtCtrls, OleCtrls,
  MSCommLib_TLB, Grids, DBGrids;

type
  TFrontoperate_InitCardID = class(TForm)
    Panel2: TPanel;
    Panel4: TPanel;
    Panel1: TPanel;
    DataSource_CardIDInit: TDataSource;
    ADOQuery_CardIDInit: TADOQuery;
    GroupBox2: TGroupBox;
    DBGrid_CardIDInit: TDBGrid;
    Panel3: TPanel;
    BitBtn18: TBitBtn;
    Image1: TImage;
    Image2: TImage;
    Combo_MCname: TComboBox;
    ComboBox_CardMC_ID: TComboBox;
    Edit_CARDID: TEdit;
    Edit_Comfir: TEdit;
    MC_ID_Set_Count: TEdit;
    BitBtn1: TBitBtn;
    BarCodeCOM2: TComm;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    procedure FormShow(Sender: TObject);
    procedure Combo_MCnameClick(Sender: TObject);
    procedure BitBtn18Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MSCbarcodeComm(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BarCodeCOM2ReceiveData(Sender: TObject; Buffer: Pointer;
      BufferLength: Word);

  private
    { Private declarations }
  public
    { Public declarations }
    procedure InitCarMC_ID(Str1: string);
    procedure CountCarMC_ID;
    procedure InitCombo_MCname; //初始化游戏名称下来框
    procedure SaveData_CardID;
    procedure InitDataBase;
    function INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
    function Date_Time_Modify(strinputdatetime: string): string;
    procedure Query_By_MCname(Str: string);


    procedure CheckCMD_BarCodeCom2();
  end;

var
  Frontoperate_InitCardID: TFrontoperate_InitCardID;
  
  CARDID_First, temp_First: string;
  CARDID_Comfir, temp_Comfir: string;
  SaveData_OK_flag_CardID: BOOLEAN;


  curOrderNo : integer=0;
  curOperNo : integer=0;
  curScanNo : integer=0;
  TotalCore : integer=0;
  Operate_No: integer=0;

  curOrderNo_Barcode : integer=0;
  curOperNo_Barcode : integer=0;
  curScanNo_Barcode : integer=0;
  TotalCore_Barcode : integer=0;
  Operate_No_Barcode: integer=0;

  BAR1_CARDNO,BAR2_CARDNO :STRING;
  Tuibi_Operate_Enable :STRING;
  buffer : array [0..2048] of byte;
  BAR_Type1,BAR_Type2:string;
  orderLst,recDataLst,recData_fromICLst : Tstrings;


  orderLst_Barcode,recDataLst_Barcode,recData_fromICLst_Barcode : Tstrings;

implementation

uses SetParameterUnit, ICDataModule, ICCommunalVarUnit, ICEventTypeUnit,ICFunctionUnit;
{$R *.dfm}

procedure TFrontoperate_InitCardID.FormShow(Sender: TObject);
begin
  InitDataBase;
  InitCombo_MCname;
  ComboBox_CardMC_ID.Items.Clear;
  
  CountCarMC_ID;
  Edit_CARDID.Text:='';
  Edit_Comfir.Text:='';

            BarCodeCOM2.StartComm();
          orderLst_BarCode:=TStringList.Create;
          recDataLst_BarCode:=tStringList.Create;
          recData_fromICLst_BarCode:=tStringList.Create;
end;

procedure TFrontoperate_InitCardID.InitCombo_MCname; //初始化游戏名称下来框
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSQL := 'select [GameName],[ID] from [TGameSet]  order by ID ASC ';
  with ADOQTemp do
  begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    Combo_MCname.Items.Clear;
    while not Eof do
    begin
      Combo_MCname.Items.Add(FieldByName('GameName').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure TFrontoperate_InitCardID.Combo_MCnameClick(
  Sender: TObject);
begin

  Query_By_MCname(Trim(Combo_MCname.Text));
end;


procedure TFrontoperate_InitCardID.Query_By_MCname(Str: string);
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  nameStr: string;
  i: integer;
begin

  if length(Trim(Str)) = 0 then
  begin
    ShowMessage('机台游戏名称不能空');
    exit;
  end
  else
  begin

    ADOQTemp := TADOQuery.Create(nil);
    strSQL := 'select [GameNo] from [TGameSet] where ([GameName]=''' + Combo_MCname.Text + ''')  ';
    with ADOQTemp do
    begin
      Connection := DataModule_3F.ADOConnection_Main;
      SQL.Clear;
      SQL.Add(strSQL);
      Active := True;
      while not Eof do
      begin
        InitCarMC_ID(FieldByName('GameNo').AsString); //查询已经设置卡头ID的数量
        Next;
      end;
    end;
    FreeAndNil(ADOQTemp);

  end;
end;

 //初始化卡头ID编号

procedure TFrontoperate_InitCardID.InitCarMC_ID(Str1: string);
var
  ADOQTemp: TADOQuery;
  strSQL, comp: string;
  strSET: string;
begin


  comp := '0';
  ADOQTemp := TADOQuery.Create(nil);
  //  strSQL := 'select distinct [MacNo] from [TChargMacSet] where GameNo=''' + Str1 + ''' and [Compter]=''' + comp + '''';
  strSQL := 'select distinct [MacNo] from [TChargMacSet] where GameNo=''' + Str1 + ''' ';
  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    ComboBox_CardMC_ID.Items.Clear;
    while not Eof do begin
      ComboBox_CardMC_ID.Items.Add(FieldByName('MacNo').AsString);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);

end;

procedure TFrontoperate_InitCardID.BitBtn18Click(Sender: TObject);
begin
  CLOSE;
end;



 //查询当前机台的相关信息

procedure TFrontoperate_InitCardID.CountCarMC_ID;
var
  ADOQTemp: TADOQuery;
  strSQL: string;
  strSET: string;
begin
  ADOQTemp := TADOQuery.Create(nil);
  strSET := '1';
 // strSQL := 'select Count(MID) from [TChargMacSet] where Card_MC_ID=''' + strSET + '''';
  strSQL := 'select Count(MID) from [TChargMacSet] where [COMPTER]=''' + strSET + '''';

  with ADOQTemp do begin
    Connection := DataModule_3F.ADOConnection_Main;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := True;
    MC_ID_Set_Count.Text := '';
    while not Eof do begin
      MC_ID_Set_Count.Text := IntToStr(ADOQTemp.Fields[0].AsInteger);
      Next;
    end;
  end;
  FreeAndNil(ADOQTemp);
end;

procedure TFrontoperate_InitCardID.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
       Combo_MCname.Items.Clear;
       ComboBox_CardMC_ID.Items.Clear;
       Combo_MCname.Text:='';
       ComboBox_CardMC_ID.Text:='';
       
orderLst.Free();
         recDataLst.Free();
       recData_fromICLst.Free();
       BarCodeCOM2.StopComm();
end;






procedure TFrontoperate_InitCardID.InitDataBase;
var
  strSQL: string;
  strtemp: string;
begin
  strtemp := '1';
  with ADOQuery_CardIDInit do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    strSQL := 'select GameName,MacNo,Card_ID_MC from [TGameSet],[TChargMacSet] '
          + ' where ([TGameSet].GameNo=[TChargMacSet].GameNo) and ([TChargMacSet].Compter=''' + strtemp + ''')';
    SQL.Add(strSQL);
    Active := True;
  end;

end;


//初始化卡计算指令

function TFrontoperate_InitCardID.INit_Send_CMD(StrCMD: string; StrIncValue: string): string;
var
  TmpStr: string; //规范后的日期和时间
  TmpStr_CheckSum: string; //校验和
  TmpStr_SendCMD: string; //指令内容
  TmpStr_Password_User: string; //指令内容
  reTmpStr: string;
  myIni: TiniFile;
  strinputdatetime: string;

  i: integer;
  Strsent: array[0..21] of string; //机型分组对应变量
begin
  strinputdatetime := DateTimetostr((now()));
  TmpStr := Date_Time_Modify(strinputdatetime); //规范日期和时间格式
  Strsent[0] := StrCMD; //帧命令

  Strsent[5] := IntToHex(Strtoint(Copy(TmpStr, 1, 2)), 2); //年份前2位
  Strsent[18] := IntToHex(Strtoint(Copy(TmpStr, 3, 2)), 2); //年份后2位
  Strsent[8] := IntToHex(Strtoint(Copy(TmpStr, 6, 2)), 2); //月份前2位
  Strsent[10] := IntToHex(Strtoint(Copy(TmpStr, 9, 2)), 2); //日期前2位
  Strsent[14] := IntToHex(Strtoint(Copy(TmpStr, 12, 2)), 2); //小时前2位
  Strsent[6] := IntToHex(Strtoint(Copy(TmpStr, 15, 2)), 2); //分钟前2位
  Strsent[1] := IntToHex(Strtoint(Copy(TmpStr, 18, 2)), 2); //秒前2位

  Strsent[2] := IntToHex((Strtoint('$' + Strsent[10]) + Strtoint('$' + Strsent[8])), 2);

  Strsent[3] := IntToHex((Strtoint('$' + Strsent[1]) + Strtoint('$' + Strsent[6])), 2);
  Strsent[7] := IntToHex((Strtoint('$' + Strsent[2]) + Strtoint('$' + Strsent[8])), 2);
  Strsent[16] := IntToHex((Strtoint('$' + Strsent[5]) + Strtoint('$' + Strsent[6])), 2);
  Strsent[13] := IntToHex((Strtoint('$' + Strsent[14]) + Strtoint('$' + Strsent[5])), 2);


  Strsent[4] := IntToHex(((Strtoint('$' + Strsent[7]) * Strtoint('$' + Strsent[16])) div 256), 2);
  Strsent[9] := IntToHex(((Strtoint('$' + Strsent[7]) * Strtoint('$' + Strsent[16])) mod 256), 2);
  Strsent[11] := IntToHex(((Strtoint('$' + Strsent[3]) * Strtoint('$' + Strsent[13])) mod 256), 2);
  Strsent[15] := IntToHex(((Strtoint('$' + Strsent[3]) * Strtoint('$' + Strsent[13])) div 256), 2);


  Strsent[17] := IntToHex((Strtoint('$' + Strsent[6]) + Strtoint('$' + Strsent[1])), 2);
  Strsent[12] := IntToHex((Strtoint('$' + Strsent[14]) + Strtoint('$' + Strsent[8])), 2);

    //Strsent[19]:= Receive_CMD_ID_Infor.ID_3F;
    //Strsent[20]:=Receive_CMD_ID_Infor.Password_3F;
                              //将读取的文档中的场地密码
  if FileExists(SystemWorkGroundFile) then
  begin
    myIni := TIniFile.Create(SystemWorkGroundFile);
    INit_Wright.BossPassword := MyIni.ReadString('PLC工作区域', 'PC托盘特征码', 'D6077');
    FreeAndNil(myIni);
  end;

    //将发送内容进行校核计算
  for i := 0 to 18 do
  begin
    TmpStr_SendCMD := TmpStr_SendCMD + Strsent[i];
  end;
     // TmpStr_CheckSum:=CheckSUMData(TmpStr_SendCMD);//求得校验和

    //TmpStr_CheckSum字节需要重新排布 ，低字节在前，高字节在后
  //  reTmpStr:=TmpStr_SendCMD+Select_CheckSum_Byte(TmpStr_CheckSum);//获取所有发送给IC的数据

  result := reTmpStr;
end;

//定时器扫描统计结果和详细记录

function TFrontoperate_InitCardID.Date_Time_Modify(strinputdatetime: string): string;
var
  strEnd: string;
  Strtemp: string;
begin

  Strtemp := Copy(strinputdatetime, length(strinputdatetime) - 8, 9);
  strinputdatetime := Copy(strinputdatetime, 1, length(strinputdatetime) - 9);
  if Copy(strinputdatetime, 7, 1) = '-' then //月份小于10
  begin
    if length(strinputdatetime) = 8 then //月份小于10,且日期小于10
    begin
      strEnd := Copy(strinputdatetime, 1, 5) + '0' + Copy(strinputdatetime, 6, 2) + '0' + Copy(strinputdatetime, 8, 1);
    end
    else
    begin
      strEnd := Copy(strinputdatetime, 1, 5) + '0' + Copy(strinputdatetime, 6, length(strinputdatetime) - 5);
    end;
  end
  else
  begin //月份大于9
    if length(strinputdatetime) = 9 then //月份大于9,但日期小于10
    begin
      strEnd := Copy(strinputdatetime, 1, 8) + '0' + Copy(strinputdatetime, 9, 1);
    end
    else
    begin
      strEnd := strinputdatetime;
    end;
  end;
  result := strEnd + Strtemp;
end;

procedure TFrontoperate_InitCardID.BitBtn1Click(Sender: TObject);
begin
       //保存条码记录
     //唯一性判断
  if (length(Trim(Combo_MCname.Text)) = 0) or (Combo_MCname.Text = '请点击选择') then
  begin
    ShowMessage('机台游戏名称不能空');
    exit;
  end;

  if (length(Trim(ComboBox_CardMC_ID.Text)) = 0) or (ComboBox_CardMC_ID.Text = '请点击选择') then
  begin
    ShowMessage('机台游戏位编号不能空');
    exit;
  end;

  if (length(Trim(Edit_CARDID.Text)) = 0) then
  begin
    ShowMessage('请先扫描卡头条码');
    exit;
  end;

  if (CARDID_Comfir <> '') and (CARDID_First <> '') and (CARDID_Comfir = CARDID_First) then
  begin
    if (DataModule_3F.Querystr_CardHeadID_Only(CARDID_Comfir) <> 'no_record') and (DataModule_3F.Querystr_CardHeadID_Only(CARDID_Comfir) <> '') then //如果有记录
    begin //查询卡头ID号是否唯一
      Panel3.Caption := '此卡头ID已使用，禁止重复！';
    end
    else
    begin
      SaveData_CardID; //保存卡头ID

      if SaveData_OK_flag_CardID then
      begin
        BarCodeValue_OnlyCheck := 0; //清除
        InitDataBase;
        SaveData_OK_flag_CardID := FALSE;
        Edit_CARDID.Text:='';
        Edit_Comfir.Text:='';
      end;
    end; //记录唯一判断结束
  end; //输入框不能为空判断结束
end;




//保存当前记录，包括流水号、积分值等信息

procedure TFrontoperate_InitCardID.SaveData_CardID;
var
  ADOQ: TADOQuery;
  strSQL, strTemp: string;
begin

  SaveData_OK_flag_CardID := FALSE; //保存操作完成

  strSQL := 'select * from [TChargMacSet] where MacNo=''' + ComboBox_CardMC_ID.text + '''';
  strTemp := '';
  ADOQ := TADOQuery.Create(nil);
  with ADOQ do begin
    Connection := DataModule_3F.ADOConnection_Main;
    Active := false;
    SQL.Clear;
    SQL.Add(strSQL);
    Active := true;
    if (RecordCount > 0) then begin
      Edit;
    
      FieldByName('Card_ID_MC').AsString := CARDID_First;
      FieldByName('Compter').AsString := '1';
      Post;
    end;
    Active := False;
  end;
  FreeAndNil(ADOQ);
  //InitDataBase;
  Query_By_MCname(Trim(Combo_MCname.Text));
  CountCarMC_ID;
  SaveData_OK_flag_CardID := true; //保存操作完成
end;

 //根据接收到的数据判断此卡是否为合法卡
procedure TFrontoperate_InitCardID.CheckCMD_BarCodeCom2();
var
    i : integer;
    tmpStr : string;
    tmpStr_Barcode : string;

    stationNoStr : string;
    tmpStr_Hex: string;
    tmpStr_Hex_length: string;
    Send_value:string;
    RevComd: integer;
    ID_No: string;
    length_Data:integer;

    strTemp:String;
    tempStr :String;
    firstbit :String; //确定扫描的是哪一个条码
    Firstframe_hex:string;
begin
    

   //首先截取接收的信息
       tmpStr_Barcode:= recData_fromICLst_Barcode.Strings[0];
       Edit1.Text:='';
       Edit1.Text:=tmpStr_Barcode;
       Edit2.Text:=BarCodeFirstFrame[0];
       Edit3.Text:=BarCodeFirstFrame[1];
       
       Firstframe_hex:=copy(tmpStr_Barcode, 1, 2);

       BarCodeValue:=ICFunction.ChangeAreaHEXToStr(copy(tmpStr_Barcode, 3, length(tmpStr_Barcode)-2));
      if (Firstframe_hex='39') then
         begin
            firstbit:='A';
         end
      else if (Firstframe_hex='30') then
         begin
            firstbit:='B';
         end
      else if (Firstframe_hex=BarCodeFirstFrame[0]) then
         begin
            firstbit:='A';
         end
      else if (Firstframe_hex=BarCodeFirstFrame[1]) then
         begin
            firstbit:='B';
         end
      else if (Firstframe_hex=BarCodeFirstFrame[2]) then
         begin
            firstbit:='C';//35
         end
      else if (Firstframe_hex=BarCodeFirstFrame[3]) then
         begin
            firstbit:='D';//36
         end
      else if (Firstframe_hex=BarCodeFirstFrame[4]) then
         begin
            firstbit:='E';//37
         end
      else
         begin
                ShowMessage('非法条码,请确认是否为本场地条码！');
                BarCodeValue :='';
                exit;
         end;

    begin
      tempStr:='0'+BarCodeValue ;
      Edit6.Text:=tempStr;
      //Panel_Infor.Caption:='';
      Edit5.Text:=inttostr(length(tempStr));
      
        //流水机台条码，9-A
      if (firstbit='A') and ((length(tempStr)=21) or (length(tempStr)=20) ) then
      //条码1
         begin
//---------------
          temp_First := tempStr;
          Edit_CARDID.Text := '';
          Panel3.Caption := '请确保扫描正确';
          if  (length(tempStr)=21) then
                  begin
                    CARDID_First  :=copy(tempStr, 20,1)+copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
                  end
          else if (length(tempStr)=20) then
                  begin
                    CARDID_First := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
                  end;
          Edit_CARDID.Text := CARDID_First;
          BarCodeValue_CardHead := '';

//
         end
         //积分条码，0-B
      else if (firstbit='B')  and ((length(tempStr)=23) or (length(tempStr)=22))   then
      //条码2
         begin
          temp_Comfir := tempStr;
          Edit_Comfir.Text := '111';
          Panel3.Caption := '请确保扫描正确';
          if  (length(tempStr) = 23) then
             begin
               CARDID_Comfir :=copy(tempStr,22,1)+copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);
             end
          else if (length(tempStr) = 22) then
             begin
               CARDID_Comfir := copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);
             end;

          Edit_Comfir.Text := CARDID_Comfir;
          BarCodeValue_CardHead := '';

         end;

    //保存条码记录

 //-----------------------------------------------------------------------------


     end;
end;



//接受彩票信息
procedure TFrontoperate_InitCardID.BarCodeCOM2ReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
    ii : integer;
    recStr : string;
    tmpStr : string;
    tmpStrend : string;
begin
   //接收----------------
    tmpStrend:= 'STR';
    recStr:='';
    SetLength(tmpStr, BufferLength);
    move(buffer^,pchar(tmpStr)^,BufferLength);
    for ii:=1 to BufferLength do
    begin
        recStr:=recStr+intTohex(ord(tmpStr[ii]),2); //将获得数据转换为16进制数

         if  ii=BufferLength then
        begin
           tmpStrend:= 'END';
        end;
    end;

      recData_fromICLst_Barcode.Clear;
      recData_fromICLst_Barcode.Add(recStr);

     begin
         CheckCMD_BarCodeCom2();//首先根据接收到的数据进行判断，确认此卡是否属于为正确的卡

     end;



end;

//不再使用这种类型的Comm
procedure TFrontoperate_InitCardID.MSCbarcodeComm(Sender: TObject);
var
  strTemp: string;
  tempStr: string;
  Dingwei: string; //确定扫描的是哪一个条码

begin
{
  if MSCbarcode.CommEvent = comEvReceive then
  begin
    strTemp := MSCbarcode.Input;
    BarCodeValue_CardHead := BarCodeValue_CardHead + strTemp;
    strTemp := '';
    begin
      tempStr := BarCodeValue_CardHead;
      Dingwei := copy(tempStr, 1, 1); //截取第一个字符，用于判断此条码信息是属于曲轴线的还是缸体线的，又或是打刻机

        //流水机台条码，
      if (Dingwei = '9') and ((length(tempStr) = 20) or (length(tempStr) = 21)) then
      begin
        begin
          temp_First := tempStr;
          Edit_CARDID.Text := '';
          Panel3.Caption := '请确保扫描正确';
          if  (length(tempStr)=21) then
                  begin
                    CARDID_First  :=copy(tempStr, 20,1)+copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
                  end
          else if (length(tempStr)=20) then
                  begin
                    CARDID_First := copy(tempStr, 11, 1) + copy(tempStr, 6, 1) + copy(tempStr, 13, 1);
                  end;
          Edit_CARDID.Text := CARDID_First;
          BarCodeValue_CardHead := '';

        end;
      end
         //积分条码，
      else if (Dingwei = '0') and ((length(tempStr) = 22) or (length(tempStr) = 23))  then
      begin
        begin
          temp_Comfir := tempStr;
          Edit_Comfir.Text := '111';
          Panel3.Caption := '请确保扫描正确';
          if  (length(tempStr) = 23) then
             begin
               CARDID_Comfir :=copy(tempStr,22,1)+copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);
             end
          else if (length(tempStr) = 22) then
             begin
               CARDID_Comfir := copy(tempStr, 2, 1) + copy(tempStr, 13, 1) + copy(tempStr, 8, 1);
             end;

          Edit_Comfir.Text := CARDID_Comfir;
          BarCodeValue_CardHead := '';
        end;
      end;
    end;
  end;
  }
end;
end.

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
    //���ݿ�
    procedure InitDataBaseBarFlow; //����
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

//��ʼ�����ݿ�
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
    //������
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



//���浱ǰ��¼��������ˮ�š�����ֵ����Ϣ 
procedure TfrmExchangeLottry.SaveBarScanRecord(firstbar: string; secondbar: string);
var
  strSQL: string;
  strOperatetime: string;
//  tmptotalcore: integer;
begin
  SaveData_OK_flag := false;
  ShortDateFormat := 'yyyy-MM-dd'; //ָ����ʽ����
  DateSeparator := '-';
  strOperateTime := FormatDateTime('yyyy-MM-dd HH:mm:ss', now);



  if not frm_bind_cardheadid.checkUniqueBindCardHeadID(TrimRight(edtCardHeadID.Text)) then
  begin
    ShowMessage('��ǰ����Ŀ�ͷID�ţ��ڴ�ϵͳδע���½��');
    exit;
  end;

  if (strtoint(TrimRight(edtProportion.Text)) > 20000) then
  begin
    edtProportion.Text := '';
    edtCoin.Text := '';
    MessageDlg('ɨ���쳣��������ɨ��', mtConfirmation, [mbYes, mbNo], 0); 
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
    FieldByName('CARDHEADID').AsString := edtCardHeadID.Text; //��ͷID
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
  

  SaveData_OK_flag := true; //����������




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
    //���������ļ�
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
      BarCodeValue_OnlyCheck := 0; //���
    end;
  end;
end;






 //���ݽ��յ��������жϴ˿��Ƿ�Ϊ�Ϸ��� 
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
  firstbit: string; //ȷ��ɨ�������һ������
  FirstframeHex: string;
begin

   //���Ƚ�ȡ���յ���Ϣ
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
    ShowMessage('��ȷ���Ƿ�Ϊ���������룡');
    BarCodeValue := '';
    exit;
  end;

  begin


  tempStr := '0' + BarCodeValue;
  ICFunction.loginfo('ASCII String data return from Scanner tempStr : ' + tempStr);
    
  Panel_Infor.Caption := '';

        //���׼�¼ ��ˮ��̨����(FirstBar)��9-A
   if (firstbit = 'A') and ((length(tempStr) = 21) or (length(tempStr) = 20)) then
    begin  
        BAR_Type1 := 'A';
        edtBarScan.Text := tempStr;
        BarCodeValue_FLOW := tempStr; //����1
        BarCodeValue := '';    
        //��ӡʱ��
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
         //���׼�¼-��������(SecondBar)��0-B
    else if (firstbit = 'B') and ((length(tempStr) = 23) or (length(tempStr) = 22)) then
    begin  
        BAR_Type2 := 'B';
        edtBarScan.Text := '';
        BarCodeValue_CORE := tempStr;
        edtBarScan.Text := copy(tempStr, 2, 21);
        BarCodeValue := '';

                 //����
        edtCoin.Text :=   copy(tempStr, 3, 1)
                        + copy(tempStr, 5, 1)
                        + copy(tempStr, 11, 1)
                        + copy(tempStr, 20, 1)
                        + copy(tempStr, 17, 1)
                        + copy(tempStr, 7, 1)
                        + copy(tempStr, 14, 1);

        ICFunction.loginfo('edtCoin.Text: ' + edtCoin.Text);
        //��������
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

         //��ѯ�˱Ҽ�¼����-��ˮ��̨���룬5-C
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
    //��ѯ�˱Ҽ�¼���� -��������
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

    end //��ѯͶ�Ҽ�¼���� -��������
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
    else if (firstbit = 'D') and (length(tempStr) = 22) then //��ѯͶ�Ҽ�¼���� -��������
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
         //��ѯ�쳣����ʱͶ��ʣ�����ݼ�¼����-��ˮ��̨���룬7-E
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
    else if (firstbit = 'E') and (length(tempStr) = 22) then //��ѯ�쳣����ʱͶ��ʣ�����ݼ�¼���� -��������
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
         //���������¼

 //-----------------------------------------------------------------------------
    if (edtBarflow1.Text <> '') and (edtBarflow2.Text <> '') then
    begin
      if (edtBarflow1.Text <> edtBarflow2.Text) then
      begin
        Panel_Infor.Caption := 'ǰ��ɨ�����ˮ�Ų�һ�£�';
        ClearText;
        exit;
      end
    end;

     //Ψһ���ж�
    if (edtBarScan.text <> '') and (edtCoin.text <> '') and (edtCardHeadID.text <> '') and (edtPrintTime.text <> '') and (edtBarflow1.text <> '') then
    begin
      //�ж�ɨ���ǰ������Ŀ�ͷIDֵ�Ƿ�һ��
      if not (BAR1_CARDNO = BAR2_CARDNO) then
      begin
        Panel_Infor.Caption := 'ǰ��ɨ��Ļ�̨ʶ���벻һ�£�';
        exit;
      end;

      //add by linlf 20140413������������ظ����
      if (strInvalidresult = '0000') then
      begin
        Panel_Infor.Caption := '����Ϊ��ѯ��ȡ���˱Ҽ�¼��';
        exit;
      end;


      //���������жϲ�ִ����Ӧ�¼�---�����ϡ��·�����
      if ((BAR_Type1 = 'A') and (BAR_Type2 = 'B')) or ((BAR_Type1 = 'D') and (BAR_Type2 = 'D')) then
      begin
        if ( checkUniqueFirstBarFlow(BarCodeValue_FLOW) = True ) then //����м�¼
        begin //��ѯ��ˮ���Ƿ�Ψһ
          ClearText;
          Panel_Infor.Caption := '�������ظ�ʹ�ã���ȷ�ϣ�';
          exit;
        end
        else
        begin

            SaveBarScanRecord(BarCodeValue_FLOW, BarCodeValue_CORE);
            if SaveData_OK_flag then
            begin
              BarCodeValue_OnlyCheck := 0; //���
              InitDataBaseBarFlow();
              SaveData_OK_flag := FALSE;
              BAR_Type1 := '';
              BAR_Type2 := '';
              Panel_Infor.Caption := '���ݱ���ɹ�';
            end
            else
            begin
              Panel_Infor.Caption := '��ǰ���뿨ͷID��ϵͳ��δע�ᣡ';
            end;

              //-------����ȡ������ȷ��  ����-----------------
        end; //��¼Ψһ�жϽ���
      end

      else if ((BAR_Type1 = 'C') and (BAR_Type2 = 'C')) then
      begin
        Panel_Infor.Caption := '����Ϊ��ѯ��ȡ���˱Ҽ�¼��';
      end
      else if (BAR_Type1 = 'D') and (BAR_Type2 = 'D') then
      begin
        Panel_Infor.Caption := '����Ϊ��ѯ��ȡ��Ͷ�Ҽ�¼��';
      end

      else if (BAR_Type1 = 'E') and (BAR_Type2 = 'E') then
      begin
        Panel_Infor.Caption := '����ΪͶ���쳣ʱʣ���δ�Ϸּ�¼��';
      end
      else
      begin
        Panel_Infor.Caption := '�������룬��ȷ�ϣ�';
      end;

    end; 
  end;
end;



//���ݶ�ȡ������ֵ��ˮ����ѯ���ݿ����Ƿ��Ѿ�����ͬ��¼�����������ʾ

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


//��ɨ��ǹ��ȡ������
procedure TfrmExchangeLottry.BarCodeCOM2ReceiveData(Sender: TObject;
  Buffer: Pointer; BufferLength: Word);
var
  i: integer;
  recStr: string;
  tmpStr: string;
  tmpStrend: string;
begin
   //����----------------
  tmpStrend := 'STR';
  recStr := '';
  SetLength(tmpStr, BufferLength);
  move(buffer^, pchar(tmpStr)^, BufferLength);
  for i := 1 to BufferLength do
  begin
    recStr := recStr + intTohex(ord(tmpStr[i]), 2); //���������ת��Ϊ16������

    if i = BufferLength then
    begin
      tmpStrend := 'END';
    end;
  end;

  recData_fromICLst_Barcode.Clear;
  recData_fromICLst_Barcode.Add(recStr);
  CheckCMDFromBarCodeCom2(); //���ȸ��ݽ��յ������ݽ����жϣ�ȷ�ϴ˿��Ƿ�����Ϊ��ȷ�Ŀ� 
end;

end.

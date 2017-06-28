unit ICmain;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons, jpeg, Menus, ComCtrls, ToolWin,
  ImgList, RzButton, RzPanel;

type
  TFrm_IC_Main = class(TForm)
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    M_INIT_BOSS: TMenuItem;
    N9: TMenuItem;
    M_INIT_3F: TMenuItem;
    M_Cunstom_Manage: TMenuItem;
    M_Frontoperate_InitID: TMenuItem;
    N28: TMenuItem;
    N29: TMenuItem;
    N30: TMenuItem;
    N31: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    N34: TMenuItem;
    N35: TMenuItem;
    N37: TMenuItem;
    M_ictest_main: TMenuItem;
    M_IC_485Testmain: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    N40: TMenuItem;
    N41: TMenuItem;
    N43: TMenuItem;
    N44: TMenuItem;
    ID1: TMenuItem;
    N6: TMenuItem;
    N8: TMenuItem;
    pnl1: TPanel;
    ID2: TMenuItem;
    _SetParameter_BossINIT: TMenuItem;
    M_SetParameter_BossMaxValue: TMenuItem;
    M_SetParameter_Boss: TMenuItem;
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N19: TMenuItem;
    N23: TMenuItem;
    N24: TMenuItem;
    N25: TMenuItem;
    N26: TMenuItem;
    N13: TMenuItem;
    pnl2: TPanel;
    pnl3: TPanel;
    img1: TImage;
    il1: TImageList;
    tlb1: TToolBar;
    btn1: TToolButton;
    btn2: TToolButton;
    btn3: TToolButton;
    btn4: TToolButton;
    btn5: TToolButton;
    pnl4: TPanel;
    pnlOperator: TPanel;
    pnl6: TPanel;
    pnl5: TPanel;
    btn6: TToolButton;
    btn7: TToolButton;
    procedure BitBtn_TestICClick(Sender: TObject);
    procedure BitBtn_FrontoperateClick(Sender: TObject);
    procedure BitBtn_AculateClick(Sender: TObject);
    procedure BitBtn_BehindoperateClick(Sender: TObject);
    procedure BitBtn_SetParameterClick(Sender: TObject);
    procedure BitBtn_FileinputClick(Sender: TObject);
    procedure ICtestClick(Sender: TObject);
    procedure M_Frontoperate_incvalueClick(Sender: TObject);
    procedure M_Frontoperate_newuserClick(Sender: TObject);
    procedure M_Frontoperate_pwdchangeClick(Sender: TObject);
    procedure M_Frontoperate_lostuserClick(Sender: TObject);
    procedure M_Frontoperate_renewuserClick(Sender: TObject);
    procedure M_Frontoperate_saleClick(Sender: TObject);
    procedure M_Frontoperate_lostvalueClick(Sender: TObject);
    procedure M_Frontoperate_userbackClick(Sender: TObject);
    procedure M_Fileinput_menberforClick(Sender: TObject);
    procedure M_Fileinput_machinerecordClick(Sender: TObject);
    procedure M_Fileinput_machinerstateClick(Sender: TObject);
    procedure M_Fileinput_prezentqueryClick(Sender: TObject);
    procedure M_Fileinput_prezentmatialClick(Sender: TObject);
    procedure M_Fileinput_cardsaleClick(Sender: TObject);
    procedure M_Fileinput_menbermatialClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitBtn1Click(Sender: TObject);
    procedure Panel14Click(Sender: TObject);
    procedure M_SetParameter_softparasetClick(Sender: TObject);
    procedure M_SetParameter_operatemaryClick(Sender: TObject);
    procedure M_SetParameter_cardsalepwdchangeClick(Sender: TObject);
    procedure M_SetParameter_syspwdmanageClick(Sender: TObject);
    procedure M_SetParameter_RightmanageClick(Sender: TObject);
    procedure M_SetParameter_datamentainClick(Sender: TObject);
    procedure M_Report_ClasschangeClick(Sender: TObject);
    procedure M_Report_SaleClick(Sender: TObject);
    procedure M_Report_MenberinfoClick(Sender: TObject);
    procedure M_Report_SaletotalClick(Sender: TObject);
    procedure M_ICtest_Net485Click(Sender: TObject);
    procedure M_Frontoperate_EBincvalueClick(Sender: TObject);
    procedure M_Frontoperate_BarcodeScanClick(Sender: TObject);
    procedure M_Frontoperate_InitCARDClick(Sender: TObject);
    procedure M_SetParameter_BossClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure M_SetParameter_BossINITClick(Sender: TObject);
    procedure M_SetParameter_BossMaxValueClick(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure N11Click(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);
    procedure N14Click(Sender: TObject);
    procedure N19Click(Sender: TObject);
    procedure N20Click(Sender: TObject);
    procedure N21Click(Sender: TObject);
    procedure N22Click(Sender: TObject);
    procedure frm_SetParameter_BossClick(Sender: TObject);
    procedure _SetParameter_BossINITClick(Sender: TObject);
    procedure N23Click(Sender: TObject);
    procedure N44Click(Sender: TObject);
    procedure N24Click(Sender: TObject);
    procedure N25Click(Sender: TObject);
    procedure N26Click(Sender: TObject);
    procedure M_Frontoperate_InitIDClick(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure N29Click(Sender: TObject);
    procedure N30Click(Sender: TObject);
    procedure N31Click(Sender: TObject);
    procedure N32Click(Sender: TObject);
    procedure N33Click(Sender: TObject);
    procedure N34Click(Sender: TObject);
    procedure N35Click(Sender: TObject);
    procedure N36Click(Sender: TObject);
    procedure N37Click(Sender: TObject);
    procedure M_ictest_mainClick(Sender: TObject);
    procedure M_IC_485TestmainClick(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure INIT_3F_LabClick(Sender: TObject);
    procedure lblInitialClick(Sender: TObject);
    procedure ID2Click(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure ID1Click(Sender: TObject);
    procedure lblClassClick(Sender: TObject);
    procedure N43Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure N_remoteClick(Sender: TObject);
    procedure CardSale_LabClick(Sender: TObject);
    procedure lab_checkdetailClick(Sender: TObject);
    procedure N41Click(Sender: TObject);
    procedure lblRechargeClick(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure btn3Click(Sender: TObject);
    procedure btn5Click(Sender: TObject);
    procedure tlb1CustomDraw(Sender: TToolBar; const ARect: TRect;
      var DefaultDraw: Boolean);
    procedure btn7Click(Sender: TObject);


  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Frm_IC_Main: TFrm_IC_Main;

implementation

uses ICtest_Main, FrontoperateUnit, AculateUnit, BehindoperateUnit,
  SetParameterUnit, FileinputUnit, Frontoperate_incvalueUnit,
  Frontoperate_newuserUnit, Frontoperate_pwdchangeUnit,
  Frontoperate_lostuserUnit, Frontoperate_renewuserUnit,
  Frontoperate_saleUnit, Frontoperate_lostvalueUnit,
  Frontoperate_userbackUnit, Fileinput_menberforUnit,
  Fileinput_machinerecordUnit, Fileinput_machinerstateUnit,
  Fileinput_prezentqueryUnit, Fileinput_prezentmatialUnit,
  Fileinput_cardsaleUnit, Fileinput_menbermatialUnit,
  QC_AE_LineBarscanUnit, IC_SetParameter_softparasetUnit,
  IC_SetParameter_operatemaryUnit, IC_SetParameter_cardsalepwdchangeUnit,
  IC_SetParameter_syspwdmanageUnit, IC_SetParameter_RightmanageUnit,
  IC_SetParameter_datamentainUnit, IC_Report_ClasschangeUnit,
  IC_Report_SaleUnit, IC_Report_MenberinfoUnit, IC_Report_SaletotalUnit,
  IC_485Testmain, Frontoperate_EBincvalueUnit, Frontoperate_EBincUnit,
  Frontoperate_InitIDUnit, IC_SetParameter_BossUnit, ICCommunalVarUnit,
  IC_SetParameter_BossINITUnit, IC_SetParameter_BossMaxValueUnit,
  frm_SetParameter_CardMCIDINITUnit, Frontoperate_InitCardIDUnit,
  AboutUnit, Frontoperate_newCustomerUnit,
  IC_SetParameter_DataBaseInitUnit, IC_SetParameter_BiLiUnit, Logon,
  IC_SetParameter_MaxDateUnit, IC_SetParameter_MenberControlUnit,
  check_detail, contact, untRecharge, untInitialRecord, untSumAccount,
  untNewMember,untMemberConfig;

{$R *.dfm}



procedure TFrm_IC_Main.BitBtn_TestICClick(Sender: TObject);
begin

  frm_ictest_main.show;
end;

procedure TFrm_IC_Main.BitBtn_FrontoperateClick(Sender: TObject);
begin
  frm_Frontoperate.show;
end;

procedure TFrm_IC_Main.BitBtn_AculateClick(Sender: TObject);
begin
  frm_Aculate.show;
end;

procedure TFrm_IC_Main.BitBtn_BehindoperateClick(Sender: TObject);
begin
  frm_Behindoperate.show;
end;

procedure TFrm_IC_Main.BitBtn_SetParameterClick(Sender: TObject);
begin
  frm_SetParameter.show;
end;

procedure TFrm_IC_Main.BitBtn_FileinputClick(Sender: TObject);
begin
  frm_Fileinput.show;
end;




  //IC卡测试

procedure TFrm_IC_Main.ICtestClick(Sender: TObject);
begin

  frm_ictest_main.show;
end;

 //充值

procedure TFrm_IC_Main.M_Frontoperate_incvalueClick(Sender: TObject);
begin
  frm_Frontoperate_incvalue.show;
end;

 //新建用户

procedure TFrm_IC_Main.M_Frontoperate_newuserClick(Sender: TObject);
begin
  frm_Frontoperate_newuser.ShowModal;
  // PageControl1.Enabled:=false;
end;

 //更改密码

procedure TFrm_IC_Main.M_Frontoperate_pwdchangeClick(Sender: TObject);
begin
  frm_Frontoperate_pwdchange.ShowModal;
end;

 //客户挂失

procedure TFrm_IC_Main.M_Frontoperate_lostuserClick(Sender: TObject);
begin
  frm_Frontoperate_lostuser.ShowModal;
end;

 //客户补卡

procedure TFrm_IC_Main.M_Frontoperate_renewuserClick(Sender: TObject);
begin
  frm_Frontoperate_renewuser.ShowModal;
end;

//人工售币

procedure TFrm_IC_Main.M_Frontoperate_saleClick(Sender: TObject);
begin
  frm_Frontoperate_sale.ShowModal;
end;

//客户消分

procedure TFrm_IC_Main.M_Frontoperate_lostvalueClick(Sender: TObject);
begin
  frm_Frontoperate_lostvalue.ShowModal;
end;


//客户退卡

procedure TFrm_IC_Main.M_Frontoperate_userbackClick(Sender: TObject);
begin
  frm_Frontoperate_userback.ShowModal;
end;
//会员套餐

procedure TFrm_IC_Main.M_Fileinput_menberforClick(Sender: TObject);
begin
  frm_Fileinput_menberfor.ShowModal;
end;
//机台登记

procedure TFrm_IC_Main.M_Fileinput_machinerecordClick(Sender: TObject);
begin
  frm_Fileinput_machinerecord.ShowModal;
end;
//机台状态

procedure TFrm_IC_Main.M_Fileinput_machinerstateClick(Sender: TObject);
begin
  frm_Fileinput_machinerstate.ShowModal;
end;
 //礼品查询

procedure TFrm_IC_Main.M_Fileinput_prezentqueryClick(Sender: TObject);
begin
  frm_Fileinput_prezentquery.ShowModal;
end;
//礼品资料

procedure TFrm_IC_Main.M_Fileinput_prezentmatialClick(Sender: TObject);
begin
  frm_Fileinput_prezentmatial.ShowModal;
end;
//售币套餐

procedure TFrm_IC_Main.M_Fileinput_cardsaleClick(Sender: TObject);
begin
  frm_Fileinput_cardsale.ShowModal;
end;
//用户资料

procedure TFrm_IC_Main.M_Fileinput_menbermatialClick(Sender: TObject);
begin
  frm_Fileinput_menbermatial.ShowModal;
end;

procedure TFrm_IC_Main.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Application.Terminate;
end;

procedure TFrm_IC_Main.BitBtn1Click(Sender: TObject);
begin
  //Frm_Logon.EnableMenu; //读取权限控制
end;

procedure TFrm_IC_Main.Panel14Click(Sender: TObject);
begin
  Close; ;
end;

procedure TFrm_IC_Main.M_SetParameter_softparasetClick(Sender: TObject);
begin
  frm_IC_SetParameter_softparaset.ShowModal;
end;

procedure TFrm_IC_Main.M_SetParameter_operatemaryClick(Sender: TObject);
begin
  frm_IC_SetParameter_operatemary.ShowModal;
end;

procedure TFrm_IC_Main.M_SetParameter_cardsalepwdchangeClick(
  Sender: TObject);
begin
  frm_IC_SetParameter_cardsalepwdchange.ShowModal;
end;

procedure TFrm_IC_Main.M_SetParameter_syspwdmanageClick(Sender: TObject);
begin
  frm_IC_SetParameter_syspwdmanage.ShowModal;
end;

procedure TFrm_IC_Main.M_SetParameter_RightmanageClick(Sender: TObject);
begin
  frm_IC_SetParameter_Rightmanage.ShowModal;
end;

procedure TFrm_IC_Main.M_SetParameter_datamentainClick(Sender: TObject);
begin
  frm_IC_SetParameter_datamentain.ShowModal;
end;

procedure TFrm_IC_Main.M_Report_ClasschangeClick(Sender: TObject);
begin
  frm_IC_Report_Classchange.ShowModal;
end;

procedure TFrm_IC_Main.M_Report_SaleClick(Sender: TObject);
begin
  frm_IC_Report_SaleDetial.ShowModal;
end;

procedure TFrm_IC_Main.M_Report_MenberinfoClick(Sender: TObject);
begin
  frm_IC_Report_Menberinfo.ShowModal;
end;

procedure TFrm_IC_Main.M_Report_SaletotalClick(Sender: TObject);
begin
  frm_IC_Report_Saletotal.ShowModal;
end;

procedure TFrm_IC_Main.M_ICtest_Net485Click(Sender: TObject);
begin
  frm_IC_485Testmain.ShowModal;
end;

procedure TFrm_IC_Main.M_Frontoperate_EBincvalueClick(Sender: TObject);
begin
  frm_Frontoperate_EBincvalue.ShowModal;
end;

procedure TFrm_IC_Main.M_Frontoperate_BarcodeScanClick(Sender: TObject);
begin
  frm_QC_AE_LineBarscan.ShowModal;
end;

procedure TFrm_IC_Main.M_Frontoperate_InitCARDClick(Sender: TObject);
begin
  frm_Frontoperate_InitID.ShowModal;
end;

procedure TFrm_IC_Main.M_SetParameter_BossClick(Sender: TObject);
begin
  frm_SetParameter_Boss.ShowModal;
end;

procedure TFrm_IC_Main.FormShow(Sender: TObject);
begin

  //在这里控制菜单显示情况
  N1.Enabled := true;
  N2.Enabled := true;
  N3.Enabled := true;
  M_INIT_BOSS.Enabled := true;
  N12.Enabled := true;
  M_INIT_3f.Enabled := true;
  M_Cunstom_Manage.Enabled := true; //用户管理
  N40.Enabled := true;

  N1.Visible := true;
  N2.Visible := true;
  N3.Visible := true;
  M_INIT_BOSS.Visible := true;
  N12.Visible := true;
  M_INIT_3f.Visible := true;
  M_Cunstom_Manage.Visible := true; //用户管理
  N40.Visible := true;

  pnlOperator.Caption := SGBTCONFIGURE.shopid;

 if  rootEnable = true then
 begin
      //
//      lab_checkdetail.Visible := true;
 end;  //进入最高权限


  {
  if not (LOAD_USER.ID_type = Copy(INit_Wright.Produecer_3F, 8, 2)) then
  begin
    Frm_Logon.EnableMenu; //读取权限控制
    if N4.Enabled then
      lblInitial.Visible := true //充值
    else
      lblInitial.Visible := false; //充值


    if N5.Enabled then
      lblRecharge.Visible := true //彩票兑换
    else
      lblRecharge.Visible := false; //彩票兑换



    if _SetParameter_BossINIT.Enabled then
      INIT_Boss_Lab.Visible := true //场地初始化
    else
      INIT_Boss_Lab.Visible := false; //场地初始化


    if N34.Enabled then
      changClass.Visible := true //|交班及结转|
    else
      changClass.Visible := false; //|交班及结转|
    end
  else
  begin
    lblRecharge.Visible := true; //彩票兑换
    lblInitial.Visible := true; //充值
    INIT_Boss_Lab.Visible := true; //场地初始化
    INIT_3F_Lab.Visible := true; //出厂初始化
    M_INIT_3F.Enabled := true; //出厂初始化
    M_INIT_BOSS.Enabled := true;
    M_Cunstom_Manage.Visible := true; //用户管理
  end
  }
end;

procedure TFrm_IC_Main.M_SetParameter_BossINITClick(Sender: TObject);
begin
  frm_SetParameter_BossINIT.ShowModal; //场地密码初始化
end;

procedure TFrm_IC_Main.M_SetParameter_BossMaxValueClick(Sender: TObject);
begin
  frm_SetParameter_BossMaxValue.ShowModal;
end;

procedure TFrm_IC_Main.N4Click(Sender: TObject);
begin
  if INit_Wright.MenberControl_short = '0' then
    frm_Frontoperate_EBincvalue.ShowModal
  else
    frm_Frontoperate_incvalue.ShowModal;
end;

procedure TFrm_IC_Main.N5Click(Sender: TObject);
begin
  frm_QC_AE_LineBarscan.ShowModal;
end;

procedure TFrm_IC_Main.N8Click(Sender: TObject);
begin
  frm_IC_SetParameter_DataBaseInit.ShowModal;
end;

procedure TFrm_IC_Main.N9Click(Sender: TObject);
begin
  frm_Fileinput_machinerecord.ShowModal;
end;

procedure TFrm_IC_Main.N10Click(Sender: TObject);
begin
    //frm_Fileinput_prezentmatial.ShowModal;
  frm_SetParameter_BILI_INIT.ShowModal;
end;

procedure TFrm_IC_Main.N11Click(Sender: TObject);
begin
  frm_SetParameter_MaxDate.ShowModal;
end;

procedure TFrm_IC_Main.N12Click(Sender: TObject);
begin
  frm_Fileinput_menbermatial.ShowModal;
end;

procedure TFrm_IC_Main.N13Click(Sender: TObject);
begin
//  frm_SetParameter_MenberControl_INIT.ShowModal;
    frmMemberConfig.ShowModal;

end;

procedure TFrm_IC_Main.N14Click(Sender: TObject);
begin
  frm_Fileinput_machinerstate.ShowModal;
end;

procedure TFrm_IC_Main.N19Click(Sender: TObject);
begin
  frm_Frontoperate_newuser.ShowModal;
end;

procedure TFrm_IC_Main.N20Click(Sender: TObject);
begin
  frm_Frontoperate_incvalue.show;

end;

procedure TFrm_IC_Main.N21Click(Sender: TObject);
begin
  frm_Frontoperate_sale.ShowModal;
end;

procedure TFrm_IC_Main.N22Click(Sender: TObject);
begin
  frm_SetParameter_BossMaxValue.ShowModal;
end;

procedure TFrm_IC_Main.frm_SetParameter_BossClick(Sender: TObject);
begin
  frm_SetParameter_Boss.ShowModal;
end;

procedure TFrm_IC_Main._SetParameter_BossINITClick(Sender: TObject);
begin
  frm_SetParameter_BossINIT.ShowModal; //场地密码初始化
end;

procedure TFrm_IC_Main.N23Click(Sender: TObject);
begin
  frm_Frontoperate_pwdchange.ShowModal;
end;

procedure TFrm_IC_Main.N44Click(Sender: TObject);
begin
  frm_Frontoperate_lostvalue.ShowModal;
end;

procedure TFrm_IC_Main.N24Click(Sender: TObject);
begin
  frm_Frontoperate_lostuser.ShowModal;
end;

procedure TFrm_IC_Main.N25Click(Sender: TObject);
begin
  frm_Frontoperate_renewuser.ShowModal;
end;

procedure TFrm_IC_Main.N26Click(Sender: TObject);
begin
  frm_Frontoperate_userback.ShowModal;
end;

procedure TFrm_IC_Main.M_Frontoperate_InitIDClick(Sender: TObject);
begin
  frm_Frontoperate_InitID.ShowModal;
end;

procedure TFrm_IC_Main.N27Click(Sender: TObject);
begin
  frm_IC_SetParameter_operatemary.ShowModal;
end;

procedure TFrm_IC_Main.N29Click(Sender: TObject);
begin
  frm_IC_SetParameter_Rightmanage.ShowModal;
end;

procedure TFrm_IC_Main.N30Click(Sender: TObject);
begin
  frm_IC_SetParameter_datamentain.ShowModal;
end;

procedure TFrm_IC_Main.N31Click(Sender: TObject);
begin
  frm_IC_SetParameter_syspwdmanage.ShowModal;
end;

procedure TFrm_IC_Main.N32Click(Sender: TObject);
begin
  frm_IC_SetParameter_softparaset.ShowModal;
end;

procedure TFrm_IC_Main.N33Click(Sender: TObject);
begin
  frm_IC_SetParameter_cardsalepwdchange.ShowModal;
end;

procedure TFrm_IC_Main.N34Click(Sender: TObject);
begin
  frm_IC_Report_Classchange.ShowModal;
end;

procedure TFrm_IC_Main.N35Click(Sender: TObject);
begin
  frm_IC_Report_SaleDetial.ShowModal;
end;

procedure TFrm_IC_Main.N36Click(Sender: TObject);
begin
  frm_IC_Report_Menberinfo.ShowModal;
end;

procedure TFrm_IC_Main.N37Click(Sender: TObject);
begin
  frm_IC_Report_Saletotal.ShowModal;
end;

procedure TFrm_IC_Main.M_ictest_mainClick(Sender: TObject);
begin
  frm_ictest_main.show;
end;

procedure TFrm_IC_Main.M_IC_485TestmainClick(Sender: TObject);
begin
  frm_IC_485Testmain.ShowModal;
end;

procedure TFrm_IC_Main.Label1Click(Sender: TObject);
begin
  //frm_SetParameter_BossINIT.ShowModal;
 // frm_QC_AE_LineBarscan.ShowModal;
  // frm_IC_SetParameter_DataBaseInit.ShowModal;
  frmAccountSum.ShowModal;

end;

procedure TFrm_IC_Main.INIT_3F_LabClick(Sender: TObject);
begin
  frm_Frontoperate_InitID.ShowModal;
end;

procedure TFrm_IC_Main.lblInitialClick(Sender: TObject);
begin
  frmInitial.ShowModal;
end;

procedure TFrm_IC_Main.ID2Click(Sender: TObject);
begin
  Frontoperate_InitCardID.ShowModal;
end;

procedure TFrm_IC_Main.N6Click(Sender: TObject);
begin
  frm_Frontoperate_newCustomer.ShowModal;
end;

procedure TFrm_IC_Main.ID1Click(Sender: TObject);
begin
  frm_SetParameter_CardMC_IDINIT.ShowModal;
end;

procedure TFrm_IC_Main.lblClassClick(Sender: TObject);
begin
  frm_IC_Report_Classchange.ShowModal;
end;

procedure TFrm_IC_Main.N43Click(Sender: TObject);
begin
  Frm_About.ShowModal;
end;

procedure TFrm_IC_Main.Image3Click(Sender: TObject);
begin
  frm_Frontoperate_EBincvalue.ShowModal;
end;

procedure TFrm_IC_Main.Image4Click(Sender: TObject);
begin
  frm_QC_AE_LineBarscan.ShowModal;
end;

procedure TFrm_IC_Main.Image1Click(Sender: TObject);
begin
  frm_SetParameter_BossINIT.ShowModal;
end;

procedure TFrm_IC_Main.Image5Click(Sender: TObject);
begin
//frm_Frontoperate_sale.ShowModal;
  frm_Frontoperate_incvalue.ShowModal;
end;

procedure TFrm_IC_Main.N_remoteClick(Sender: TObject);
begin
  if INit_Wright.MenberControl_short = '0' then
    frm_Frontoperate_EBincvalue.ShowModal
  else
    frm_Frontoperate_incvalue.ShowModal;


end;

procedure TFrm_IC_Main.CardSale_LabClick(Sender: TObject);
begin
  if INit_Wright.MenberControl_short = '0' then
    frm_Frontoperate_EBincvalue.ShowModal
  else
    frm_Frontoperate_incvalue.ShowModal;
end;

procedure TFrm_IC_Main.lab_checkdetailClick(Sender: TObject);
begin
 // frm_check_detail.ShowModal;
  //frmRecharge.ShowModal;

  frm_IC_SetParameter_DataBaseInit.ShowModal;

end;

procedure TFrm_IC_Main.N41Click(Sender: TObject);
begin
  frm_contact.ShowModal;
end;

procedure TFrm_IC_Main.lblRechargeClick(Sender: TObject);
begin
  frmRecharge.ShowModal;
end;

procedure TFrm_IC_Main.btn1Click(Sender: TObject);
begin
    frmInitial.ShowModal;
end;

procedure TFrm_IC_Main.btn3Click(Sender: TObject);
begin
    frmRecharge.ShowModal;
end;

procedure TFrm_IC_Main.btn5Click(Sender: TObject);
begin
   frmAccountSum.ShowModal;
    

end;



procedure TFrm_IC_Main.tlb1CustomDraw(Sender: TToolBar; const ARect: TRect;
  var DefaultDraw: Boolean);
var
  bitmap:TBitmap;
begin
  bitmap:= TBitmap.Create;
 // bitmap.LoadFromFile('F:\3F\40_images\Toolbar_BG.bmp');
 // tlb1.Canvas.StretchDraw(ARect,bitmap);
  bitmap.Free;
end;

procedure TFrm_IC_Main.btn7Click(Sender: TObject);
begin
  frmNewMember.ShowModal;

end;

end.


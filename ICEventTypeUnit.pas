unit ICEventTypeUnit;

interface

uses IniFiles, SysUtils, Classes;

type
  PLC_UnitType = record //PLC单元定义
    Name: string; //名称
    Command: string; //命令
    Address: string; //地址
    Size: integer; //长度
    Value: array of integer; //单元值（个数与Length相同）
    Style: string; //属性（输入、输出）
  end;

  PLC_EventType = record //事件定义
    Name: string; //事件描述
    UnitMsg: PLC_UnitType; //事件引用上面的哪一个
    Have: Boolean; //是否执行
  end;

  EventSystemType = record
    PLC_Type: integer; //PLC型号
    PLC_Unit: array of PLC_UnitType; //与PLC通讯用的单元定义
    PLC_EventIn: array of PLC_EventType; //PLC事件
    PLC_EventOut: array of PLC_EventType;
  end;

  EventUnitObj = class
    function TransStringToFloat(S: string): Real;
    function TransStringToInteger(S: string): Integer;

  public
    PLCCommandList: TStrings; //不重复命令集合

       //以下三个函数在此版本软件中未使用
    procedure LoadEventIni;
    procedure GetUnitMessageForName(var Eu: PLC_UnitType; UName: string);
    function GetUnitMessage(UMsg: string): PLC_UnitType;

  end;

var
  EventSystem: EventSystemType;
  EventObj: EventUnitObj;

implementation

uses ICCommunalVarUnit, ICFunctionUnit;

function EventUnitObj.GetUnitMessage(UMsg: string): PLC_UnitType;
var
  k: integer;
  rtn: PLC_UnitType;
begin
  //单元名称
  k := Pos(',', UMsg);
  rtn.Name := Copy(UMsg, 1, k - 1);

  //指令
  UMsg := Copy(UMsg, k + 1, Length(UMsg) - 1);
  k := Pos(',', UMsg);
  rtn.Command := Copy(UMsg, 1, k - 1);

  //单元地址
  UMsg := Copy(UMsg, k + 1, Length(UMsg) - 1);
  k := Pos(',', UMsg);
  rtn.Address := Copy(UMsg, 1, k - 1);

  //单元长度
  UMsg := Copy(UMsg, k + 1, Length(UMsg) - 1);
  k := Pos(',', UMsg);
  rtn.Size := TransStringToInteger(Copy(UMsg, 1, k - 1));

  //单元值
  Setlength(rtn.Value, rtn.Size); //说明该值能存多少个值，Value是个数组

  //单元属性
  rtn.Style := Copy(UMsg, k + 1, Length(UMsg) - 1);


  Result := rtn;
end;


procedure EventUnitObj.GetUnitMessageForName(var Eu: PLC_UnitType;
  UName: string);
var
  i: integer;
begin
  for i := 0 to Length(EventSystem.PLC_Unit) - 1 do begin
    if EventSystem.PLC_Unit[i].Name = UName then begin
      Eu.Name := EventSystem.PLC_Unit[i].Name;
      Eu.Command := EventSystem.PLC_Unit[i].Command;
      Eu.Address := EventSystem.PLC_Unit[i].Address;
      Eu.Size := EventSystem.PLC_Unit[i].Size;
      Eu.Style := EventSystem.PLC_Unit[i].Style;
      break;
    end;
  end;
end;

procedure EventUnitObj.LoadEventIni;
var
  myIni: TIniFile;
  i, Tot, j, k: integer;
  S: string;
begin

  if FileExists(SystemWorkGroundFile) then begin
    MyIni := TiniFile.Create(SystemWorkGroundFile);

    Tot := MyIni.ReadInteger('PLC单元', '总数', 0);
    SetLength(EventSystem.PLC_Unit, Tot);
    for i := 0 to Tot - 1 do begin
      S := MyIni.ReadString('PLC单元', '单元' + FormatCurr('#0', i + 1), ',,');
      EventSystem.PLC_Unit[i] := GetUnitMessage(S);

    end;

    Tot := MyIni.ReadInteger('PLC输入事件', '总数', 0);
    SetLength(EventSystem.PLC_EventIn, Tot);
    for i := 0 to Tot - 1 do begin
      S := MyIni.ReadString('PLC输入事件', '事件' + FormatCurr('#0', i + 1), ';;');
      //取事件名称
      j := Pos(';', S);
      EventSystem.PLC_EventIn[i].Name := Copy(S, 1, j - 1);
      S := Copy(S, j + 1, Length(S) - j);
      //取事件信息
      j := Pos(';', S);
      EventObj.GetUnitMessageForName(EventSystem.PLC_EventIn[i].UnitMsg, Copy(S, 1, j - 1));
      Setlength(EventSystem.PLC_EventIn[i].UnitMsg.Value, EventSystem.PLC_EventIn[i].UnitMsg.Size);
      //事件取值
      S := Copy(S, j + 1, Length(S) - j);
      for k := 0 to Length(EventSystem.PLC_EventIn[i].UnitMsg.Value) - 1 do begin
        j := Pos(',', S);
        if j > 0 then begin

          EventSystem.PLC_EventIn[i].UnitMsg.Value[k] := ICFunction.TransStringToInteger(Copy(S, 1, j - 1));
          S := Copy(S, j + 1, Length(S) - j);
        end
        else
          EventSystem.PLC_EventIn[i].UnitMsg.Value[k] := 0;
      end;

      EventSystem.PLC_EventIn[i].Have := False;
    end;

    Tot := MyIni.ReadInteger('PLC输出事件', '总数', 0);
    SetLength(EventSystem.PLC_EventOut, Tot);
    for i := 0 to Tot - 1 do begin
      S := MyIni.ReadString('PLC输出事件', '事件' + FormatCurr('#0', i + 1), ';;');
      //取事件名称
      j := Pos(';', S);
      EventSystem.PLC_EventOut[i].Name := Copy(S, 1, j - 1);
      S := Copy(S, j + 1, Length(S) - j);
      //取事件信息
      j := Pos(';', S);
      EventObj.GetUnitMessageForName(EventSystem.PLC_EventOut[i].UnitMsg, Copy(S, 1, j - 1));
      Setlength(EventSystem.PLC_EventOut[i].UnitMsg.Value, EventSystem.PLC_EventOut[i].UnitMsg.Size);
      //事件取值
      S := Copy(S, j + 1, Length(S) - j);
      for k := 0 to Length(EventSystem.PLC_EventOut[i].UnitMsg.Value) - 1 do begin
        j := Pos(',', S);
        if j > 0 then begin
          EventSystem.PLC_EventOut[i].UnitMsg.Value[k] := ICFunction.TransStringToInteger(Copy(S, 1, j - 1));
          S := Copy(S, j + 1, Length(S) - j);
        end
        else
          EventSystem.PLC_EventOut[i].UnitMsg.Value[k] := 0;
      end;
      //事件状态初始化
      EventSystem.PLC_EventOut[i].Have := False;
    end;
    {
    Tot := MyIni.ReadInteger('初始化事件','总数',0);
    Setlength(EventSystem.InitEventOut,Tot);
    for i := 0 to Tot-1 do begin
      S := MyIni.ReadString('初始化事件','事件'+FormatCurr('#0',i+1),'');
      SystemWorkground.InitEventOut[i] :=S;
      end;

    }
    PLCCommandList := TStringList.Create;
    Tot := MyIni.ReadInteger('PLC命令', '总数', 0);
    for i := 0 to Tot - 1 do begin
      S := MyIni.ReadString('PLC命令', '命令' + FormatCurr('#0', i + 1), '');
      PLCCommandList.Add(S);
    end;

  end;
  FreeAndNil(myIni);
end;





function EventUnitObj.TransStringToFloat(S: string): Real;
var
  rtn: Real;
begin
  if S = '' then
    rtn := 0
  else begin
    try
      rtn := StrToFloat(S);
    except
      rtn := 0;
    end;
  end;

  Result := rtn;
end;

function EventUnitObj.TransStringToInteger(S: string): Integer;
var
  rtn: Integer;
begin
  if S = '' then
    rtn := 0
  else begin
    try
      rtn := StrToInt(S);
    except
      rtn := 0;
    end;
  end;

  Result := rtn;
end;

end.

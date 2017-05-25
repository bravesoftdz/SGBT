unit strprocess;

interface

uses
  Classes, SysUtils, Graphics, dialogs;
const
  TooLong = ' is too long!';
  EmptyStr = ' is an empty string value!';
  EmptyHex = ' is an empty Hex value!';
  EmptyBinary = ' is an empty binary value!';
  InvalidHex = ' is invalid Hex value!';
  InvalidSize = ' is a invalid value with the binary size.';
  InvalidBinary = ' is invalid binary value!';
  LoopReplace1 = 'The string replaced and the string replacing with are the SAME!';
  LoopReplace2 = 'Case Sensitive is FALSE.' + LoopReplace1;
type
  EStrToCharError = class(exception);
  EHexToIntError = class(exception);
  EIntToBinError = class(exception);
  EBinToIntError = class(exception);
  EReplaceError = class(exception);
  TStrException = class of exception;

{ 数制转换}
function HexToInt(Hex: string): integer; //将一个十六进制的值转换成整型
function IntToBin(Int: LongInt; Size: Integer): string; //将一个十进制整型转换成二进制值
function BinToInt(Bin: string): LongInt; //将一个十进制整型转换成二进制值
function BinToHex(Bin: string; Size: integer): string; //将二进制转换成十六进制
function HexToBin(Hex: string; Size: integer): string; //将十六进制转换成二进制

{字符处理}
//字符的种类
function IsNumberic(Vaule: string): Boolean; ////判断一个字符串是否全部为数字
function IsNumber(Ch: char): boolean; //判断一个字符是否是一个数字
function IsLetter(Ch: char): boolean; //判断一个字符是否是一个字母
function IsSign(Ch: char): boolean; //判断一个字符是否是一些符号' '，'\' '>'等。
function IsPrint(Ch: char): boolean; //判断一个字符是否是可显示出来的字符
{字符串处理}

//串转换／转化
function StrToChar(Str: string): char; //将单个字符的串转换成字符
function IntToStrPad0(Digital, Size: integer; Before: boolean): string; //将一个整型数转换成一个在前／后添加若干个0的串
//字符数目
function GetMaxWordNumber(var MaxLineID: integer; List: TStringList): integer; //获取最大行的行号及字母数。
function GetChineseWordNumber(Str: string): integer; //获取一个串中汉字的个数
function GetEnglishWordNumber(Str: string): integer; //获取一个串中英文字母个数

//字符输出空间
function GetTextOutWidth(Canvas: TCanvas; Str: string; WordSpace: integer): integer; //获取一个串输出时的宽度(Pixel)
function GetTextOutHeight(Canvas: TCanvas; List: TStringList; LineSpace: integer): integer; //获取StringList输出时的高度。

//串的排列顺序
function Reversed(Str: string): string; //倒排字符串

//子串在串中的位置
function ReversedPos(SubStr, Str: string): integer; //查找最右边的SubStr在Str中的位置。与Pos相反。
function LeftLastPos(Str: string; FindChar: Char): integer; //查找某一个字符在串左边的最后的位置
function RightBeforePos(Str: string; FindChar: char): integer; //查早某一字符在右边最前的位置
function LastPos(Str: string; FindChar: char): integer; overload; //查找某一字符在串中最后的位置。返回０表示没有这样的字符
function LastPos(Str: string; FindStr: string): integer; overload; //查找某一字符在串中最后的位置。返回０表示没有这样的字符
function AnyPos(Str, FindStr: string; CaseSensitive: boolean): integer; //可以按是否区分大小写来查找第一个FindStr的位置，其余功能同Pos
function AnyLastPos(Str, FindStr: string; CaseSensitive: boolean): integer; //可以按是否区分大小写来查找最后一个FindStr的位置，其余功能同LastPos
procedure GetSubInfoInStr(Str, SubStr: string; CaseSensitive: boolean; var InfoList: TStringList); //获取一个串中所有子串在串中的位置

//字符串的替换

//字符串的替换--用RepStr代替SignChar位置前、后、之间的的串
function ReplaceLeft(Str, RepStr: string; SignChar: char): string; //RepStr替换SignChar前面的所有字符 。如果没有找到相应的字符就返回原串
function ReplaceMiddle(Str, RepStr: string; SignChar: char): string; //用RepStr替换第一个和最后一个SignChar 之间的所有字符
function ReplaceRight(Str, RepStr: string; SignChar: char): string; //用RepStr替换SignChar后面的所有字符.如果没有找到相应的字符就返回原串
function ReplaceBoth(Str, RepStr: string; SignChar: char): string; //用RepStr替换左边第一个前面和右边第一个后面的所有串
//字符串的替换--用SpecifiedChar代替SignChar位置前、后、之间的SignChar
function ReplaceLeftChar(Str: string; RepChar, SignChar: char): string; //用RepChar替换从左边到第一个不是SignChar之间的所有SignChar字符
function ReplaceMiddleChar(Str: string; RepChar, SignChar: char): string; //用RepChar替换从左边到第一个不是SignChar开始 到 从右边开始到第一个不是SignChar之间的所有SignChar
function ReplaceRightChar(Str: string; RepChar, SignChar: char): string; //用RepChar替换从最右边到第一个不是SignChar之间的所有SignChar字符
function ReplaceBothChar(Str: string; RepChar, SignChar: char): string; //用RepChar替换从左边到第一个不是SignChar之间以及从最右边到第一个不是SignChar之间的所有SignChar字符
function ReplaceAllChar(Str: string; RepChar, SignChar: char): string; //用RepChar代替串中所有的SignChar
//字符串的替换--用RepStr代替SignStr
function ReplaceFirstStr(Str, RepStr, SignStr: string; CaseSensitive: boolean): string; //用RepStr替换第一个SignStr
function ReplaceLastStr(Str, RepStr, SignStr: string; CaseSensitive: boolean): string; //用RepStr替换最后一个SignStr
function ReplaceBothStr(Str, RepStr, SignStr: string; CaseSensitive: boolean): string; //用RepStr替换最前面和最后面一个SignStr
function ReplaceAllStr(Str, RepStr, SignStr: string; CaseSensitive: boolean; var RepCount: integer): string; //用RepStr替换所有的SignStr
//字符串的删除
function TrimLeftChar(Str: string; DelChar: char): string; //删除Str中左边的指定字符
function TrimRightChar(Str: string; DelChar: char): string; //删除Str中右边的指定字符
function TrimBoth(Str: string; DelChar: char): string; //删除Str中左右边的指定字符
function TrimAll(Str: string; DelChar: char): string; //删除Str中所有的指定字符
function TrimMiddle(Str: string; DelChar: char): string; //删除中间的指定字符（从左边和右边第一个不是指定字符之间）

//获取字符串的子串
//字符串获取－获取某一字符的左、右、中间的字符串
function GetLeftStr(Str: string; SpecifiedChar: char): string; //获取字符串某一特定字符（第一个）左边的所有字符（不含该特定字符）
function GetMiddleStr(Str: string; SpecifiedChar: Char): string; //获取字符串某一特定字符（第一个和最后一个）之间的所有字符（不含该特定字符）
function GetRightStr(Str: string; SpecifiedChar: char): string; //获取字符串某一特定字符（第一个）右边的所有字符（不含该特定字符）
//字符串获取－获取某一字符串（该字符串由相同的字符组成）中间的字符串
function GetMiddleString(Str: string; SpecifiedChar: Char): string;
//字符串获取－获取两个字符串相同的部分
function GetLeftSameStr(Str1, Str2: string): string; //获取两字符串左边相同的部分
function GetRightSameStr(Str1, Str2: string): string; //获取两字符串右边相同的部分
//字符串获取－获取两个字符串不同的部分
procedure GetRightDiverse(var Str1, Str2: string); //获取两个字符串相同部分的右边不同部分
procedure GetLeftDiverse(var Str1, Str2: string); //获取两个字符串相同部分左边不同部分
//字符串的比较
function FindDiverseLeftPos(Str1, Str2: string): integer; //从左至右查找在字符串中不同的位置。空格忽略
function FindDiverseRightPos(Str1, Str2: string): integer; //从右至左查找在字符串中不同的位置。 空格忽略

//字符串的插入
function RepeatChar(ReChar: char; Count: integer): string; //将某一字符重复Count次;
implementation

procedure EStrProcess(ExceptType: TStrException; Value, ErrorInfo: string);
begin
  raise ExceptType.Create(Value + ErrorInfo); ;
end;

////////////////////////////////////////////////////////////////////////////////
{
  数制转换
}


function IsNumberic(Vaule: string): Boolean; //判断Vaule是不是数字
var
  i: integer;
begin
  result := true; //设置返回值为是（真）
  Vaule := trim(Vaule); //去空格
  for i := 1 to length(Vaule) do //准备循环
  begin
    if not (Vaule[i] in ['0'..'9']) then //如果Vaule的第i个字不是0-9中的任一个
    begin
      result := false; //返回值 不是（假）
      exit; //退出函数
    end;
  end;
end;



function HexToInt(Hex: string): integer; //将一个十六进制的值转换成整型 参数说明：Hex:被转换的十六进制值
var
  HexDigital: set of char;
  i: integer;
  Digital: string;
begin
  HexDigital := ['1', '2', '3', '4', '5', '6', '7', '8', '9', '0', 'A', 'B', 'C', 'D', 'E', 'F', 'a', 'b', 'c', 'd', 'e', 'f'];
  if Length(Hex) = 0 then EStrProcess(EHexToIntError, Hex, EmptyHex);
  for i := 1 to Length(Hex) do begin
    Digital := Copy(Hex, i, 1);
    if (i = 1) and (digital = '$') then Continue;
    if not (StrToChar(Digital) in HexDigital) then EStrProcess(EHexToIntError, Hex, InvalidHex);
  end;
  Digital := Copy(Hex, 1, 1);
  if Digital <> '$' then Hex := '$' + Hex;
  Result := StrToInt(Hex);
end;

function IntToBin(Int: LongInt; Size: Integer): string; //将一个十进制整型转换成二进制值 参数说明：Int:被转换的整型值  Size:转换后的宽度：4位 8位 或更大
var
  i: Integer;
begin
  if Size < 1 then EStrProcess(EIntToBinError, IntToStr(Size), InvalidSize);
  for i := Size downto 1 do begin
    if Int and (1 shl (Size - i)) <> 0 then Result := '1' + Result
    else Result := '0' + Result;
  end;
end;

function BinToInt(Bin: string): LongInt; //将一个十进制整型转换成二进制值  参数说明：Bin:被转换的二进制值串
var
  i, Size: Integer;
  Bit: string;
begin
  Result := 0;
  Size := Length(Bin);
  if Size = 0 then EStrProcess(EBinToIntError, Bin, EmptyBinary);
  for i := Size downto 1 do begin
    Bit := Copy(Bin, i, 1);
    if (Bit <> '1') and (Bit <> '0') then EStrProcess(EBinToIntError, Bin, InvalidBinary);
    if Bit = '1' then Result := Result + (1 shl (Size - i));
  end;
end;

function BinToHex(Bin: string; Size: integer): string; //将二进制转换成十六进制  Bin:被转换的二进制值  Size:转换成十六进制的宽度
begin
  Result := IntToHex(BinToInt(Bin), Size);
end;

function HexToBin(Hex: string; Size: integer): string; //将十六进制转换成二进制 Bin:被转换的十六进制值  Size:转换成二进制的宽度
begin
  Result := IntToBin(HexToInt(Hex), Size);
end;
/////////////////////////////////////////////////////////////////////////////////
{
 
  字符处理
 
}
//字符种类

function IsNumber(Ch: char): boolean; //判断一个字符是否是一个数字
begin
  Result := ((Ch >= '0') and (Ch <= '9'));
end;

function IsLetter(Ch: char): boolean; //判断一个字符是否是一个字母
begin
  Result := ((Ch >= 'a') and (Ch <= 'z')) or ((Ch >= 'A') and (Ch <= 'Z'));
end;

function IsSign(Ch: char): boolean; //判断一个字符是否是一些符号' '，'\' '>'等。
type
  TSign = set of Char;
var
  Sign: TSign;
begin
  Sign := [' ', '~', '`', '!', '@', '#', '$', '%', '^', '&', '*', '(', ')', '-', '_', '=', '+', '|', '\', '[', ']', '{', '}', ':', ';', '''', '"', '<', '>', ',', '.', '?', '/'];
  Result := Ch in Sign;
end;

function IsPrint(Ch: char): boolean; //判断一个字符是否是可显示出来的字符
begin
  Result := IsLetter(Ch) or IsNumber(Ch) or IsSign(Ch);
end;
//////////////////////////////////////////////////////////////////////////////////
{
  字符串处理
}

//串转换／转化

function StrToChar(Str: string): Char; //将单个字符的串转换成字符 参数说明：Str:被转换的串
begin
  if Length(Str) = 0 then EStrProcess(EStrToCharError, Str, EmptyStr);
  if Length(Str) > 1 then EStrProcess(EStrToCharError, Str, Toolong);
  Result := Str[1];
end;

function IntToStrPad0(Digital, Size: integer; Before: boolean): string; //将一个整型数转换成一个在前／后添加若干个0的串
var
  Len: integer;
begin
  Result := IntToStr(Digital);
  Len := Length(Result);
  while Len < Size do begin
    if Before then Result := '0' + Result
    else Result := Result + '0';
    Len := Length(Result);
  end;
end;

//字符数目

function GetMaxWordNumber(var MaxLineID: integer; List: TStringList): integer; //获取最大行的行号及字母数。
var
  i: integer;
  Len: integer;
begin
  Result := 0;
  if List.Count = 0 then Exit;
  for i := 0 to List.Count - 1 do begin
    Len := Length(List.strings[i]);
    if Len >= Result then begin
      Result := Len;
      MaxLineID := i;
    end;
  end;
end;

function GetChineseWordNumber(Str: string): integer; //获取一个串的汉字的个数
var
  i: integer;
  CurrentChar: char;
  CurrentStr: string;
begin
  Result := 0;
  if Length(Str) = 0 then Exit;
  for i := 1 to Length(Str) do begin
    CurrentStr := Copy(Str, i, 1);
    CurrentChar := CurrentStr[1];
    if Ord(CurrentChar) >= 127 then Result := Result + 1;
  end;
  Result := Result div 2;
end;

function GetEnglishWordNumber(Str: string): integer; //获取英文字母的个数
begin
  Result := Length(Str) - 2 * GetChineseWordNumber(Str);
end;

//字符输出空间 (图形模式)

function GetTextOutWidth(Canvas: TCanvas; Str: string; WordSpace: integer): integer; //获取一个串输出时的宽度(Pixel)
var
  i: integer;
  CurrentStr: string;
  CurrentChar: Char;
begin
  i := 1;
  Result := 0;
  if Length(Str) = 0 then Exit;
  while i <= Length(Str) do begin
    CurrentStr := Copy(Str, i, 1);
    CurrentChar := CurrentStr[1];
    if Ord(CurrentChar) >= 127 then begin
      CurrentStr := Copy(Str, i, 2);
      inc(i);
    end;
    Result := Result + Canvas.TextWidth(CurrentStr) + WordSpace;
    inc(i);
  end;
end;

function GetTextOutHeight(Canvas: TCanvas; List: TStringList; LineSpace: integer): integer; //获取StringList输出时的高度。
var
  i: integer;
begin
  Result := 0;
  if List.Count = 0 then Exit;
  for i := 0 to List.Count - 1 do begin
    if i <> List.Count - 1 then Result := Result + Canvas.TextHeight(List.Strings[i]) + LineSpace
    else Result := Result + Canvas.TextHeight(List.Strings[i]);
  end;
end;

//串的排列顺序

function Reversed(Str: string): string; //倒排字符串
var
  Len: integer;
  RevStr, temp: string;
  i: integer;
begin
  Result := Str;
  Len := Length(Str);
  if len = 0 then Exit;
  if Len = 1 then Exit;
  SetLength(RevStr, Len);
  for i := Len - 1 downto 0 do begin
    temp := Str[Len - i];
    RevStr[i + 1] := Str[Len - i];
  end;
  Result := RevStr;
end;

//子串在串中的位置

function ReversedPos(SubStr, Str: string): integer; //查找最右边的SubStr在Str中的位置。与Pos相反。
var
  Len: integer;
  Position: integer;
begin
  Len := Length(Str);
  Str := Reversed(Str);
  SubStr := Reversed(SubStr);
  Position := Pos(SubStr, Str);
  if Position <> 0 then Result := Len - Position + 1 - (Length(SubStr) - 1)
  else Result := 0;
end;

function LeftLastPos(Str: string; FindChar: Char): integer; //查找某一个字符在串左边的最后的位置 返回０表示没有这样的字符
var
  Len, i: integer;
begin
  Len := Length(Str);
  Result := 0;
  for i := 1 to Len do begin
    if Str[i] = FindChar then begin
      if i = Len then Result := Len;
      continue;
    end else begin
      Result := i - 1;
      Break;
    end;
  end;
end;

function RightBeforePos(Str: string; FindChar: char): integer; //查早某一字符在右边最前的位置  返回０表示没有这样的字符
var
  RevStr: string;
  RevPos, Len: integer;
begin
  Len := Length(Str);
  RevStr := Reversed(Str);
  RevPos := LeftLastPos(RevStr, FindChar);
  if Str <> '' then begin
    if Str[Len] <> FindChar then Result := 0
    else Result := Length(Str) - RevPos + 1;
  end else Result := 0;
end;

function LastPos(Str: string; FindChar: char): integer; //查找某一字符在串中最后的位置。返回０表示没有这样的字符
begin
  Result := ReversedPos(FindChar, Str);
end;

function LastPos(Str: string; FindStr: string): integer; //查找某一字符在串中最后的位置。返回０表示没有这样的字符
begin
  Result := ReversedPos(FindStr, Str);
end;

function AnyPos(Str, FindStr: string; CaseSensitive: boolean): integer; //可以按是否区分大小写来查找，其余功能同Pos
begin
  if CaseSensitive then Result := Pos(FindStr, Str)
  else begin
    Str := AnsiUpperCase(Str);
    FindStr := AnsiUpperCase(FindStr);
    Result := Pos(FindStr, Str);
  end;
end;

function AnyLastPos(Str, FindStr: string; CaseSensitive: boolean): integer; //可以按是否区分大小写来查找最后一个FindStr的位置，其余功能同LastPos
begin
  if CaseSensitive then Result := LastPos(Str, FindStr)
  else begin
    Str := AnsiUpperCase(Str);
    FindStr := AnsiUpperCase(FindStr);
    Result := LastPos(Str, FindStr);
  end;
end;

procedure GetSubInfoInStr(Str, SubStr: string; CaseSensitive: boolean; var InfoList: TStringList); //获取一个串中所有子串在串中的位置
var //InfoList返回的一些数字是SubStr在
  RelativePos, AbsolutePos: integer; //Str中的位置。
  CutLen, Len, SubLen: integer;
begin
  InfoList.Clear;
  SubLen := Length(SubStr);
  CutLen := 0;
  repeat
    Len := Length(Str);
    RelativePos := AnyPos(Str, SubStr, CaseSensitive);
    if RelativePos = 0 then begin
      if CutLen = 0 then InfoList := nil;
      Continue;
    end;
    Str := Copy(Str, RelativePos + SubLen, Len - RelativePos - SubLen + 1);
    AbsolutePos := CutLen + RelativePos;
    InfoList.Add(IntToStr(AbsolutePos));
    CutLen := CutLen + RelativePos + SubLen - 1;
  until ((Len < SubLen) or (RelativePos = 0));
end;
//字符串的替换

//字符串的替换--用String代替SignChar位置前、后、之间的的串

function ReplaceLeft(Str, RepStr: string; SignChar: char): string; //RepStr替换左边第一个SignChar前面的所有字符 。如果没有找到相应的字符就返回原串
var
  SignStr: string;
  Position, Len: integer;
begin
  SignStr := '1';
  SignStr[1] := SignChar;
  Result := Str;
  Len := Length(Str);
  Position := Pos(SignStr, Str);
  if Position <> 0 then begin //如果没有找到相应的字符就返回原串
    Str := Copy(Str, Position, Len - Position + 1);
    Result := RepStr + Str;
  end;
end;

function ReplaceMiddle(Str, RepStr: string; SignChar: char): string; //用RepStr替换第一个和最后一个SignChar 之间的所有字符
var
  LeftStr, MidStr, RightStr: string;
begin
  LeftStr := GetLeftStr(Str, SignChar);
  RightStr := GetRightStr(Str, SignChar);
  MidStr := GetMiddleStr(Str, SignChar);
  if MidStr = '' then begin
                          //当串中只有两个SignChar并且紧挨在一起
    Result := Str; //当串中没有SignChar字符时，
                          //当串中只有一个SignChar字符时，
                          //返回原串
  end else begin
    MidStr := RepStr;
    Result := LeftStr + SignChar + MidStr + SignChar + RightStr;
  end;
end;

function ReplaceRight(Str, RepStr: string; SignChar: char): string; //用RepStr替换右边第一个SignChar后面的所有字符 。如果没有找到相应的字符就返回原串
var
  Count: integer;
  SignStr: string;
begin
  SignStr := '1';
  SignStr[1] := SignChar;
  Result := Str;
  Count := ReversedPos(SignStr, Str);
  if Count <> 0 then begin //如果没有找到相应的字符就返回原串
    Str := Copy(Str, 1, Count);
    Result := Str + RepStr;
  end;
end;

function ReplaceBoth(Str, RepStr: string; SignChar: char): string; //用RepStr替换左边第一个SignChar前面和右边第一个SignChar后面的所有串
begin
  Result := ReplaceLeft(Str, RepStr, SignChar);
  Result := ReplaceRight(Result, RepStr, SignChar);
end;


//字符串的替换--用SpecifiedChar代替SignChar位置前、后、之间的SignChar

function ReplaceLeftChar(Str: string; RepChar, SignChar: char): string; //用RepChar替换从左边到第一个不是SignChar之间的所有SignChar字符
var
  LeftPos, i: integer;
begin
  LeftPos := LeftLastPos(Str, SignChar);
  for i := 1 to LeftPos do Str[i] := RepChar;
  Result := Str;
end;

function ReplaceMiddleChar(Str: string; RepChar, SignChar: char): string; //用RepChar替换从左边到第一个不是SignChar开始 到 从右边开始到第一个不是SignChar之间的所有SignChar
var
  LeftStr, RightStr, MidStr: string;
  LeftPos, RightPos, Len: integer;
begin
  Len := Length(Str);
  LeftPos := LeftLastPos(Str, SignChar);
  RightPos := RightBeforePos(Str, SignChar);
  LeftStr := Copy(Str, 1, LeftPos);
  if RightPos = 0 then RightStr := ''
  else RightStr := Copy(Str, RightPos, Len);
  MidStr := GetMiddleString(Str, SignChar);
  if MidStr = '' then Result := Str
  else begin
    MidStr := ReplaceAllChar(MidStr, RepChar, SignChar);
    Result := LeftStr + MidStr + RightStr;
  end;
end;

function ReplaceRightChar(Str: string; RepChar, SignChar: char): string; //用RepChar替换从最右边到第一个不是SignChar之间的所有SignChar字符
var
  RightPos, i: integer;
begin
  RightPos := RightBeforePos(Str, Signchar);
  if RightPos = 0 then begin
    Result := Str;
  end else begin
    for i := RightPos to Length(Str) do begin
      Str[i] := RepChar;
    end;
    Result := Str;
  end;
end;

function ReplaceBothChar(Str: string; RepChar, SignChar: char): string; //用RepChar替换从左边到第一个不是SignChar之间以及从最右边到第一个不是SignChar之间的所有SignChar字符
begin
  Result := ReplaceLeftChar(Str, RepChar, SignChar);
  Result := ReplaceRightChar(Result, RepChar, SignChar);
end;

function ReplaceAllChar(Str: string; RepChar, SignChar: char): string; //用RepChar代替串中所有的SignChar
var
  i: integer;
begin
  for i := 1 to Length(Str) do begin
    if Str[i] = SignChar then Str[i] := RepChar;
  end;
  Result := Str;
end;

//字符串的替换--用RepStr代替SignStr

function ReplaceFirstStr(Str, RepStr, SignStr: string; CaseSensitive: boolean): string; //用RepStr替换第一个SignStr
var
  FirstPos, Len, RepLen: integer;
  LeftStr, RightStr: string;
begin
  LeftStr := '';
  RightStr := '';
  RepLen := Length(SignStr);
  Len := Length(Str);
  FirstPos := AnyPos(Str, SignStr, CaseSensitive);
  if FirstPos = 0 then Result := Str
  else begin
    LeftStr := Copy(Str, 1, FirstPos - 1);
    RightStr := Copy(Str, FirstPos + RepLen, Len - FirstPos - RepLen + 1);
    Result := LeftStr + RepStr + RightStr;
  end;
end;

function ReplaceLastStr(Str, RepStr, SignStr: string; CaseSensitive: boolean): string; //用RepStr替换最后一个SignStr
var
  LastPos1, Len, RepLen: integer;
  LeftStr, RightStr: string;
begin
  LeftStr := '';
  RightStr := '';
  RepLen := Length(SignStr);
  Len := Length(Str);
  LastPos1 := AnyLastPos(Str, SignStr, CaseSensitive);
  if LastPos1 = 0 then Result := Str
  else begin
    LeftStr := Copy(Str, 1, LastPos1 - 1);
    RightStr := Copy(Str, LastPos1 + RepLen, Len - LastPos1 - RepLen + 1);
    Result := LeftStr + RepStr + RightStr;
  end;
end;

function ReplaceBothStr(Str, RepStr, SignStr: string; CaseSensitive: boolean): string; //用RepStr替换最前面和最后面一个SignStr
begin
  Result := ReplaceFirstStr(Str, RepStr, SignStr, CaseSensitive);
  Result := ReplaceLastStr(Result, RepStr, SignStr, CaseSensitive);
end;

function ReplaceAllStr(Str, RepStr, SignStr: string; CaseSensitive: boolean; var RepCount: integer): string; //用RepStr替换所有的SignStr
var
  FirstPos: integer;
  Len, SignLen: integer;
  LeftStr, RightStr: string;
  Tmp1, Tmp2: string;
begin
  RepCount := 0;
  SignLen := Length(SignStr);
  if CaseSensitive then begin
    if RepStr = SignStr then EStrProcess(EReplaceError, '', LoopReplace1);
  end else begin
    Tmp1 := AnsiUpperCase(RepStr);
    Tmp2 := AnsiUpperCase(SignStr);
    if Tmp1 = Tmp2 then EStrProcess(EReplaceError, '', LoopReplace2);
  end;
  repeat
    Len := Length(Str);
    FirstPos := AnyPos(Str, SignStr, CaseSensitive);
    if FirstPos = 0 then Continue;
    LeftStr := Copy(Str, 1, FirstPos - 1);
    RightStr := Copy(Str, FirstPos + SignLen, Len - FirstPos - SignLen + 1);
    Str := LeftStr + RepStr + RightStr;
    Inc(RepCount);
  until (FirstPos = 0);
  Result := Str;
end;


//字符串的删除

function TrimLeftChar(Str: string; DelChar: char): string; //删除Str中左边的指定字符
var
  Len, i: integer;
  Temp: string;
begin
  Temp := '';
  Len := Length(Str);
  for i := 1 to Len do begin
    if Temp = '' then begin
      if Str[i] <> DelChar then Temp := Temp + Str[i];
    end else Temp := Temp + Str[i];
  end;
  Result := Temp;
end;

function TrimRightChar(Str: string; DelChar: char): string; //删除Str中右边的指定字符
var
  ReverseStr: string;
begin
  ReverseStr := Reversed(Str);
  ReverseStr := TrimLeftChar(ReverseStr, DelChar);
  Result := Reversed(ReverseStr);
end;

function TrimBoth(Str: string; DelChar: char): string; //删除Str中左右边的指定字符
var
  Str1: string;
begin
  Str1 := TrimLeftChar(Str, DelChar);
  Str1 := TrimRightChar(Str1, DelChar);
  Result := Str1;
end;

function TrimAll(Str: string; DelChar: char): string; //删除Str中所有的指定字符
var
  Str1: string;
  i: integer;
begin
  Str1 := '';
  for i := 1 to Length(Str) do begin
    if Str[i] <> DelChar then begin
      Str1 := Str1 + Str[i];
    end;
  end;
  Result := Str1;
end;

function TrimMiddle(Str: string; DelChar: char): string; //删除中间的指定字符（从左边和右边第一个不是指定字符之间）
var //如果该串全部是由DelChar字符组成，则全部删除 ；DelChar:='*'
  LeftPos, RightPos, Len: integer; //eg:Str:='****dd**d***'; result:='dd**d';
  LeftStr, RightStr, MiddleStr: string; //eg:Str:='******';Result:='******';
begin //eg:Str:='ddd***';Result:='ddd';
  LeftStr := ''; //eg:Str:='****ddd';Result:='ddd';
  RightStr := ''; //eg:Str:='ddd';Result:='ddd';
  MiddleStr := ''; //eg:Str:='';Result:='';
  Len := Length(Str);
  LeftPos := LeftLastPos(Str, DelChar);
  RightPos := RightBeforePos(Str, DelChar);
  LeftStr := Copy(Str, 1, LeftPos);
  if RightPos = 0 then RightStr := ''
  else RightStr := Copy(Str, RightPos, Len - RightPos + 1);
  MiddleStr := GetMiddleString(Str, DelChar);
  if MiddleStr = '' then Result := MiddleStr //如果Str为空串－返回空串，Str全部是由指定字符组成，删除所有字符，返回空串
  else begin
    Result := LeftStr + TrimAll(MiddleStr, DelChar) + RightStr;
  end;
end;


//获取字符串的子串

//获取某一字符的左、右、中间的字符串

function GetLeftStr(Str: string; SpecifiedChar: char): string; //获取字符串某一特定字符（第一个）左边的所有字符（不含该特定字符）
var
  PosLeft: integer;
begin
  PosLeft := Pos(SpecifiedChar, Str);
  Result := Copy(Str, 1, PosLeft - 1);
end;

function GetMiddleStr(Str: string; SpecifiedChar: Char): string; //获取字符串某一特定字符（第一个和最后一个）
var //之间的所有字符（不含该两端的特定字符）e
  PosLeft, PosRight: integer; // eg:Str:=C:\llw\delphi MiddleStr:='llw'
begin // eg:Str:=C:\llw\delphi\Program MiddleStr:=llw\delphi
  PosLeft := Pos(SpecifiedChar, Str);
  PosRight := ReversedPos(SpecifiedChar, Str);
                                                  //当串中只有两个SpecifiedChar并且紧挨在一起
                                                  //当串中没有SpecifiedChar字符时，
  Result := Copy(Str, PosLeft + 1, PosRight - PosLeft - 1); //当串中只有一个SpecifiedChar字符时，
                                                  //返回空串

end;

function GetRightStr(Str: string; SpecifiedChar: char): string; //获取字符串某一特定字符（第一个）右边的所有字符（不含该特定字符）
var
  PosRight: integer;
begin
  PosRight := ReversedPos(SpecifiedChar, Str);
  if PosRight = 0 then Result := ''
  else Result := Copy(Str, PosRight + 1, Length(Str) - PosRight)
end;

//字符串获取－获取某一字符串（该字符串由相同的字符组成）中间的字符串

function GetMiddleString(Str: string; SpecifiedChar: Char): string; //获取字符串左右边之间（左边最后一个指定字符到
var //右边第一个指定字符之间不包括两端的指定字符）的串。SpecifiedChar:='*'
  LeftPos, RightPos, Len: integer; //eg Str:='***dkd***kdk****' ;MiddleString:='dkd***kdk';
begin //eg Str:='**ddd**';MiddleString:='ddd';
  Len := Length(Str); //eg Str:='ddd**';MiddleString:='ddd';
  LeftPos := LeftLastPos(Str, SpecifiedChar); //eg Str:='**ddd';MiddleString:='ddd';
  RightPos := RightBeforePos(Str, SpecifiedChar); //eg Str:='';middleString:='';
  if RightPos = 0 then begin //eg Str:='****';middleString:='';
    Result := Copy(Str, LeftPos + 1, Len - LeftPos); //eg Str:='dddd';middleString:='dddd';
  end else Result := Copy(Str, LeftPos + 1, RightPos - LeftPos - 1); //eg Str:='d*d*d';middleString:='d*d*d';
end;

//字符串获取－获取两个字符串相同的部分

function GetLeftSameStr(Str1, Str2: string): string; //获取两字符串左边相同的部分
var
  LeftPos: integer;
begin
  if Str1 = Str2 then begin
    Result := Str1;
    Exit;
  end;
  LeftPos := FindDiverseLeftPos(Str1, Str2);
  Result := Copy(Str1, 1, LeftPos - 1);
end;

function GetRightSameStr(Str1, Str2: string): string; //获取两字符串右边相同的部分
var
  RightPos, Len1, Len2: integer;
  Str: string;
begin
  Len1 := Length(Str1);
  Len2 := Length(Str2);
  if Len1 >= Len2 then Str := Str1
  else Str := Str2;
  RightPos := FindDiverseRightPos(Str1, Str2);
  Result := Copy(Str, RightPos + 1, Length(Str) - RightPos);
end;

//字符串获取－获取两个字符串不同的部分

procedure GetRightDiverse(var Str1, Str2: string); //获取两个字符串相同部分的右边不同部分
var
  LeftPos: integer;
  Len1, Len2: integer;
begin
  Str1 := TrimBoth(Str1, ' ');
  Str2 := TrimBoth(Str2, ' ');
  Len1 := Length(Str1);
  Len2 := Length(Str2);
  if Str1 = Str2 then begin
    Str1 := '';
    Str2 := '';
    Exit;
  end;
  LeftPos := FindDiverseLeftPos(Str1, Str2);
  Str1 := Copy(Str1, LeftPos, Len1 - LeftPos + 1);
  Str2 := Copy(Str2, LeftPos, Len2 - LeftPos + 1);
end;

procedure GetLeftDiverse(var Str1, Str2: string); //获取两个字符串相同部分左边不同部分
var
  RightPos: integer;
  Len1, Len2: integer;
begin
  Str1 := TrimBoth(Str1, ' ');
  Str2 := TrimBoth(Str2, ' ');
  Len1 := Length(Str1);
  Len2 := Length(Str2);
  RightPos := FindDiverseRightPos(Str1, Str2);
  if Len1 >= Len2 then begin
    Str1 := Copy(Str1, 1, RightPos);
    Str2 := Copy(Str2, 1, RightPos - (Len1 - Len2));
  end else begin
    Str1 := Copy(Str1, 1, RightPos - (Len2 - Len1));
    Str2 := Copy(Str2, 1, RightPos);
  end;
end;


//字符串的比较

function FindDiverseLeftPos(Str1, Str2: string): integer; //从左至右查找在字符串中不同的地方。空格忽略
var
  Len1, Len2, i, Count: integer;
begin
  Result := 0;
  Str1 := TrimBoth(Str1, ' ');
  Str2 := TrimBoth(Str2, ' ');
  Len1 := Length(Str1);
  Len2 := Length(Str2);
  if Str1 = Str2 then begin
    Result := 0;
    Exit;
  end;
  if Len1 >= Len2 then Count := Len2
  else Count := Len1;
  for i := 1 to Count do begin
    if Str1[i] <> Str2[i] then begin
      Result := i;
      Break;
    end;
    if i = Count then Result := i + 1;
  end;
end;

function FindDiverseRightPos(Str1, Str2: string): integer; //从右至左查找在字符串中不同的位置。空格忽略
var
  Len1, Len2, i, Count: integer;
begin
  Result := 0;
  Str1 := TrimBoth(Str1, ' ');
  Str2 := TrimBoth(Str2, ' ');
  Len1 := Length(Str1);
  Len2 := Length(Str2);
  if Str1 = Str2 then begin
    Result := 0;
    Exit;
  end;
  if Len1 >= Len2 then begin
    Count := Len1;
    Str2 := RepeatChar(' ', Len1 - Len2) + Str2;
  end else begin
    Count := Len2;
    Str1 := RepeatChar(' ', Len2 - Len1) + Str1;
  end;
  for i := Count downto 1 do begin
    if Str1[i] <> Str2[i] then begin
      Result := i;
      Break;
    end;
  end;
end;

//字符串的插入

function RepeatChar(ReChar: char; Count: integer): string; //将某一字符重复Count次;
var
  i: integer;
begin
  Result := '';
  for i := 1 to Count do begin
    Result := ReChar + Result;
  end;
end;

end.

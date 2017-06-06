unit DateProcess;
interface
uses DateUtils;

const
  DayOfWeekStrings: array[1..7] of string = ('SUNDAY', 'MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY');

//: English Calendar Months - used for Month2Int
const
  MonthStrings: array[1..12] of string = ('JANUARY', 'FEBRUARY', 'MARCH', 'APRIL', 'MAY', 'JUNE', 'JULY', 'AUGUST', 'SEPTEMBER', 'OCTOBER',
    'NOVEMBER', 'DECEMBER');
const
 //:中文显示星期─要用Week2CWeek()函数转换
  DayOfCWeekStrings: array[1..7] of string = ('星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六');
const
 //: 中文显示月份─要用Month2CMonth()函数转换
  MonthCStrings: array[1..12] of string = ('一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月');

const
  OneDay = 1.0;
  OneHour = OneDay / 24.0;
  OneMinute = OneHour / 60.0;
  OneSecond = OneMinute / 60.0;
  OneMillisecond = OneSecond / 1000.0;

//--- 年度函数 ---

//检查日期值是否是润年
function IsLeapYear(Year: Word): Boolean;

//传回日期值年度的第一天
function GetFirstDayOfYear(const Year: Word): TDateTime;

//传回日期值年度的最后一天
function GetLastDayOfYear(const Year: Word): TDateTime;

//传回日期值年度的第一星期天的日期
function GetFirstSundayOfYear(const Year: Word): TDateTime;

//传回西洋日期的格式MM/DD/YY
function GetMDY(const DT: TDateTime): string;

//--- 日期型的转换 ---

//日期转成字符串
//如果是错误将传一空值
function Date2Str(const DT: TDateTime): string;

//传回日期值的日期
function GetDay(const DT: TDateTime): Word;

//:传回日期值的月份
function GetMonth(const DT: TDateTime): Word;

//: 传回日期值的年份
function GetYear(const DT: TDateTime): Word;

//:将日期的值取出时间的值
function Time2Hr(const DT: TDateTime): Word;

//:将日期的值取出分锺的值
function Time2Min(const DT: TDateTime): Word;

//:将日期的值取出秒数的值
function Time2Sec(const DT: TDateTime): Word;

//:将日期的值取出微秒的值
function Time2MSec(const DT: TDateTime): Word;

//传回目前的年度
function ThisYear: Word;

//传回目前的月份
function ThisMonth: Word;

//传回目前的日期
function ThisDay: Word;

//传回目前的时间
function ThisHr: Word;

//传回目前的分锺
function ThisMin: Word;

//传回目前的秒数
function ThisSec: Word;

//将英文的星期转成整数值
//例如EDOWToInt(''SUNDAY')=1
function EDOWToInt(const DOW: string): Integer;

//将英文的月份转成整数值的月
//例如EMonthToInt('JANUARY')=1
function EMonthToInt(const Month: string): Integer;

function GetCMonth(const DT: TDateTime): string;
//传回中文显示的月份

function GetC_Today: string;
//传回中国的日期
//例如： GetC_Today传回值为89/08/11

//Function TransC_DateToE_Date(Const CDT :String) :TDateTime;
//将民国的年月日转换为公元的YYYY/MM/DD
//2001/02/02加入 例如：TransC_DateToE_Date('90年2月1日')传回值是2001/2/1

function GetCWeek(const DT: TDateTime): string;
//传回值为中文显示的星期  例如：GETCWeek(2000/08/31)=星期四

function GetLastDayForMonth(const DT: TDateTime): TDateTime;
//传回本月的最后一天

function GetFirstDayForMonth(const DT: TDateTime): TDateTime;
//取得月份的第一天

function GetLastDayForPeriorMonth(const DT: TDateTime): TDateTime;
//传回上个月的最后一天

function GetFirstDayForPeriorMonth(const DT: TDateTime): TDateTime;
//取得上个月份的第一天

function ROCDATE(DD: TDATETIME; P: integer): string;
{转换某日期为民国0YYMMDD 型式字符串，例如：ROCDATE(Now,0)='900304' }
{P=0 不加'年'+'月'+'日'}
{P=1 加'年'+'月'+'日'}

{------------------- 日期和时间的计算函数------------------}

//传回两个日期相减值的分锺数
function MinutesApart(const DT1, DT2: TDateTime): Word;

//调整年度的时间
//例如AdjustDateYear(Now,1998)传回值为'1998/02/25'
function AdjustDateYear(const D: TDateTime; const Year: Word): TDateTime;

//增加n个分钟的时间
function AddMins(const DT: TDateTime; const Mins: Extended): TDateTime;

//增加n个小时的时间
function AddHrs(const DT: TDateTime; const Hrs: Extended): TDateTime;

//可将日期加上欲增加的天数为得到的值   例如：AddDays(2000/08/31,10)=2000/09/10
function AddDays(const DT: TDateTime; const Days: Extended): TDateTime;

//增加n周的时间
//例如：AddWeeks(2001/01/21,2)传回值为'2001/02/4'
function AddWeeks(const DT: TDateTime; const Weeks: Extended): TDateTime;

//增加n个月的时间
function AddMonths(const DT: TDateTime; const Months: Extended): TDateTime;

//增加n个年的时间
function AddYrs(const DT: TDateTime; const Yrs: Extended): TDateTime;

//传回向前算的N个分锺
function SubtractMins(const DT: TDateTime; const Mins: Extended): TDateTime;

//传回向前算的N个小时
function SubtractHrs(const DT: TDateTime; const Hrs: Extended): TDateTime;

//传回向前算的N个天
function SubtractDays(const DT: TDateTime; const Days: Extended): TDateTime;

//传回向前算的N个周
function SubtractWeeks(const DT: TDateTime; const Weeks: Extended): TDateTime;

//传回向前算的N个月，例如：SubtractMonths('2000/11/21',3)传回'2000/08/22'
function SubtractMonths(const DT: TDateTime; const Months: Extended): TDateTime;

//传回日期值的本月份的最后一天
function GetLastDayOfMonth(const DT: TDateTime): TDateTime;

//传回日期值的本月份的第一天
function GetFirstDayOfMonth(const DT: TDateTime): TDateTime;

//传回年度第一周的第一个星期天的日期
function StartOfWeek(const DT: TDateTime): TDateTime;

//传回年度最后一周的最后一个星期天的日期
function EndOfWeek(const DT: TDateTime): TDateTime;

//将秒数转换为时分秒
function Hrs_Min_Sec(Secs: Extended): string;

//: 比较两的日期值是否是同月如果是为真
function DatesInSameMonth(const DT1, DT2: TDateTime): Boolean;

//: 比较两的日期值是否是同年如果是为真
function DatesInSameYear(const DT1, DT2: TDateTime): Boolean;

//: 比较两的日期值是否是同年和同月如果是为真
function DatesInSameMonthYear(const DT1, DT2: TDateTime): Boolean;

//:传回两个日期相减值的天数
//例如：DaysApart是DT2减DT1
function DaysApart(const DT1, DT2: TDateTime): LongInt;

//传回两个日期相减值的周数
//例如：ExactWeeksApart是DT2减DT1
function ExactWeeksApart(const DT1, DT2: TDateTime): Extended;

//传回两个日期相减值的周数
//例如：ExactWeeksApart是DT2减DT1
function WeeksApart(const DT1, DT2: TDateTime): LongInt;

//: 如果是真表示日期为润年
function DateIsLeapYear(const DT: TDateTime): Boolean;

//: 传回日期值本月份的天数
// DaysThisMonth(Now)= 31，三月有31天
function DaysThisMonth(const DT: TDateTime): Byte;

//: 传回日期值的本年度的月份中的日数，还有几天
//DaysLeftInMonth('2001/04/28')传回值2
function DaysLeftInMonth(const DT: TDateTime): Byte;

//: 传回日期值的本年度的月份中的日数，还有几天
function DaysInMonth(const DT: TDateTime): Byte;
//: 传回日期值的本年度的天数，如果是润年有366天；不是就有365天
function DaysInYear(const DT: TDateTime): Word;

//: 传回日期值中本年度已过了几天
//例如：DayOfYear(now)=119
function DayOfYear(const DT: TDateTime): Word;

//: 传回今天的日期在本年度过了几天
//例如: ThisDayOfYear=119
function ThisDayOfYear: Word;

//:传回今年度还有几天
function DaysLeftInYear(const DT: TDateTime): Word;

//传回日期值的季别
//例如：WhichQuarter(now)=2
function WhichQuarter(const DT: TDateTime): Byte;

//传回年龄，依现在其日期减出生的日期
function AgeAtDate(const DOB, DT: TDateTime): Integer;

//传回年龄，依现在其日期减出生的日期
function AgeNow(const DOB: TDateTime): Integer;

//传回年龄，依现在其日期减出生的日期
function AgeAtDateInMonths(const DOB, DT: TDateTime): Integer;

//传回年龄，依现在其日期减出生的日期
function AgeNowInMonths(const DOB: TDateTime): Integer;

//传回日期值已存活的周数
//例如 AgeAtDateInWeeks('1963/06/24',Now)=1975
function AgeAtDateInWeeks(const DOB, DT: TDateTime): Integer;

//传回日期值已存活的周数，不同的是此函数不用第二个参数是用上一个函数完成的
//例如 AgeNowInWeeks('1963/06/24')=1975
function AgeNowInWeeks(const DOB: TDateTime): Integer;

//可传回几岁几月几周的详细年龄
function AgeNowDescr(const DOB: TDateTime): string;

function CheckDate(const sCheckedDateString: string): boolean;
//检查是否是中华民国的日期格式
//例如：CheckDate(DatetoStr(Now))=89/08/29，传回值是Boolean

{----------------- 周数处理用函数 --------------------}

//将日期值转换成周数
function DateToWeekNo(const DT: TDateTime): Integer;

//比较两个日期值是否相同
function DatesInSameWeekNo(const DT1, DT2: TDateTime): Boolean;

//将两个日期相减后转成周数
function WeekNosApart(const DT1, DT2: TDateTime): Integer;

//传回目前日期的周数
function ThisWeekNo: Integer;

//传回在X的年度的第n周的时间
//例如：GetWeekNoToDate(28,2001)='2001/07/08'，取得值是从星期天开始
function GetWeekNoToDate_Sun(const WeekNo, Year: Word): TDateTime;

//传回在X的年度的第n周的时间
//例如：GetWeekNoToDate(28,2001)='2001/07/08'，取得值是从星期一开始
function GetWeekNoToDate_Mon(const WeekNo, Year: Word): TDateTime;

//传回在X的年度的第n周的时间
//例如：DWYToDate(3,28,2001)='2001/07/10'，取得值是强制从星期天开始的
function DWYToDate(const DOW, WeekNo, Year: Word): TDateTime;

//将周数转换成月日格式
//例如：WeekNoToDate(35)传回08/26
function WeekNoToDate(const Weekno: Word): TDateTime;

{--- 检查确定日期函数 ---}
//: 如果传回值是真表示目前是一月
function IsJanuary(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是二月
function IsFebruary(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是三月
function IsMarch(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是四月
function IsApril(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是五月
function IsMay(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是六月
function IsJune(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是七月
function IsJuly(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是八月
function IsAugust(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是九月
function IsSeptember(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是十月
function IsOctober(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是十一月
function IsNovember(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是十二月
function IsDecember(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是上午
function IsAM(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是下午
function IsPM(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是中午
function IsNoon(const DT: TDateTime): Boolean;

//:如果传回值是真表示目前是夜晚
function IsMidnight(const DT: TDateTime): Boolean;

//: 如果传回值是真表示目前是星期天
function IsSunday(const DT: TDateTime): Boolean;

//: 如果日期值是星期一即为真
function IsMonday(const DT: TDateTime): Boolean;

//: 如果日期值是星期二即为真
function IsTuesday(const DT: TDateTime): Boolean;

//: 如果日期值是星期三即为真
function IsWednesday(const DT: TDateTime): Boolean;

//: 如果日期值是星期四即为真
function IsThursday(const DT: TDateTime): Boolean;

//: 如果日期值是星期五即为真
function IsFriday(const DT: TDateTime): Boolean;

//: 如果日期值是星期六即为真
function IsSaturday(const DT: TDateTime): Boolean;

//:如果日期值是星期六或日即为真
function IsWeekend(const DT: TDateTime): Boolean;

//: 如果日期值是星期一至五即为真
function IsWorkDays(const DT: TDateTime): Boolean;

//function CheckLastDayOfMonth(DT : TDateTime) : Boolean;
//检查是否是本月的最后一天

 //返回北京时间戳
function getTimestamp(): string;


implementation

uses
  Windows, SysUtils, StrProcess;




function getTimestamp(): string;
begin
  result := inttostr(DateTimeToUnix(Now));
end;


function LInt2EStr(const L: LongInt): string;
begin
  try
    Result := IntToStr(L);
  except
    Result := '';
  end;
end;

function LeftStr(const S: string; const N: Integer): string;
begin
  Result := Copy(S, 1, N);
end;

function RightAfterStr(const S: string; const N: Integer): string;
begin
  Result := Copy(S, N + 1, Length(S) - N);
end;

function FillStr(const Ch: Char; const N: Integer): string;
begin
  SetLength(Result, N);
  FillChar(Result[1], N, Ch);
end;

function PadChLeftStr(const S: string; const Ch: Char; const Len: Integer): string;
var
  N: Integer;
begin
  N := Length(S);
  if N < Len then
    Result := FillStr(Ch, Len - N) + S
  else
    Result := S;
end;

function LInt2ZStr(const L: LongInt; const Len: Byte): string;
begin
  Result := LInt2EStr(L);
  Result := PadChLeftStr(LeftStr(Result, Len), '0', Len);
end;

function ReplaceChStr(const S: string;
  const OldCh, NewCh: Char): string;
var
  I: Integer;
begin
  Result := S;
  if OldCh = NewCh then
    Exit;
  for I := 1 to Length(S) do
    if S[I] = OldCh then
      Result[I] := NewCh;
end;

function Str2Ext(const S: string): Extended;
begin
  try
    Result := StrToFloat(S);
  except
    Result := 0;
  end;
end;

function Str2Lint(const S: string): LongInt;
begin
  try
    Result := StrToInt(S);
  except
    Result := 0;
  end;
end;

function IsLeapYear(Year: Word): Boolean;
begin
  Result := ((Year and 3) = 0) and ((Year mod 100 > 0) or (Year mod 400 = 0))
end;

function Date2Str(const DT: TDateTime): string;
begin
  try
    if abs(DT) < 0.000001 then
      Result := ''
    else
      Result := DateToStr(DT);
  except
    Result := '';
  end;
end;

function GetYear(const DT: TDateTime): Word;
var
  D, M: Word;
begin
  DecodeDate(DT, Result, M, D);
end;

function GetMonth(const DT: TDateTime): Word;
var
  D, Y: Word;
begin
  DecodeDate(DT, Y, Result, D);
end;

function GetDay(const DT: TDateTime): Word;
var
  M, Y: Word;
begin
  DecodeDate(DT, Y, M, Result);
end;

function Time2Hr(const DT: TDateTime): Word;
var
  Min, Sec, MSec: Word;
begin
  DecodeTime(DT, Result, Min, Sec, MSec);
end;

function Time2Min(const DT: TDateTime): Word;
var
  Hr, Sec, MSec: Word;
begin
  DecodeTime(DT, Hr, Result, Sec, MSec);
end;

function Time2Sec(const DT: TDateTime): Word;
var
  Hr, Min, MSec: Word;
begin
  DecodeTime(DT, Hr, Min, Result, MSec);
end;

function Time2MSec(const DT: TDateTime): Word;
var
  Hr, Min, Sec: Word;
begin
  DecodeTime(DT, Hr, Min, Sec, Result);
end;

function MinutesApart(const DT1, DT2: TDateTime): Word;
var
  Hr1, Min1, Sec1, MSec1: Word;
  Hr2, Min2, Sec2, MSec2: Word;
begin
  DecodeTime(DT1, Hr1, Min1, Sec1, MSec1);
  DecodeTime(DT2, Hr2, Min2, Sec2, MSec2);
  if Min2 < Min1 then
  begin
    Min2 := Min2 + 60;
    Dec(Hr2);
  end;
  if Hr1 > Hr2 then
    Hr2 := Hr2 + 24;
  Result := (Hr2 - Hr1) * 60 + (Min2 - Min1);
end;

function AdjustDateYear(const D: TDateTime; const Year: Word): TDateTime;
var
  Day, Month, OldYear: Word;
begin
  DecodeDate(D, OldYear, Month, Day);
  if Year = OldYear then
  begin
    Result := Int(D);
    Exit;
  end;
  if not IsLeapYear(Year) and (Month = 2) and (Day = 29) then
  begin
    Month := 3;
    Day := 1;
  end;
  Result := EncodeDate(Year, Month, Day);
end;

function AddMins(const DT: TDateTime; const Mins: Extended): TDateTime;
begin
  Result := DT + Mins / (60 * 24)
end;

function AddHrs(const DT: TDateTime; const Hrs: Extended): TDateTime;
begin
  Result := DT + Hrs / 24.0
end;

function AddWeeks(const DT: TDateTime; const Weeks: Extended): TDateTime;
begin
  Result := DT + Weeks * 7;
end;

function AddMonths(const DT: TDateTime; const Months: Extended): TDateTime;
var
  Day, Month, Year: Word;
  IMonth: Integer;
begin
  DecodeDate(DT, Year, Month, Day);
  IMonth := Month + Trunc(Months);

  if IMonth > 12 then
  begin
    Year := Year + (IMonth - 1) div 12;
    IMonth := IMonth mod 12;
    if IMonth = 0 then
      IMonth := 12;
  end
  else if IMonth < 1 then
  begin
    Year := Year + (IMonth div 12) - 1; // sub years;
    IMonth := 12 - abs(IMonth) mod 12;
  end;
  Month := IMonth;

// Ensure Day of Month is valid
  if Month = 2 then
  begin
    if IsLeapYear(Year) and (Day > 29) then
      Day := 29
    else if not IsLeapYear(Year) and (Day > 28) then
      Day := 28;
  end
  else if (Month in [9, 4, 6, 11]) and (Day = 31) then
    Day := 30;

  Result := EncodeDate(Year, Month, Day) + Frac(Months) * 30 +
    Frac(DT);
end;

function AddYrs(const DT: TDateTime; const Yrs: Extended): TDateTime;
var
  Day, Month, Year: Word;
begin
  DecodeDate(DT, Year, Month, Day);
  Year := Year + Trunc(Yrs);
  if not IsLeapYear(Year) and (Month = 2) and (Day = 29) then
    Day := 28;
  Result := EncodeDate(Year, Month, Day) + Frac(Yrs) * 365.25
    + Frac(DT);
end;

function GetLastDayofMonth(const DT: TDateTime): TDateTime;
var
  D, M, Y: Word;
begin
  DecodeDate(DT, Y, M, D);
  case M of
    2:
      begin
        if IsLeapYear(Y) then
          D := 29
        else
          D := 28;
      end;
    4, 6, 9, 11: D := 30
  else
    D := 31;
  end;
  Result := EncodeDate(Y, M, D) + Frac(DT);
end;

function GetFirstDayofMonth(const DT: TDateTime): TDateTime;
var
  D, M, Y: Word;
begin
  DecodeDate(DT, Y, M, D);
  Result := EncodeDate(Y, M, 1) + Frac(DT);
end;

function GMTStr2Value(const GMTStr: string): Extended;
var
  P: Integer;
begin
  P := Pos(GMTStr, '+');
  if P > 0 then
  begin
    Result := Str2Ext(Trim(Copy(GMTStr, P + 1, Length(GMTStr) - P)));
  end
  else
  begin
    P := Pos(GMTStr, '-');
    if P > 0 then
    begin
      Result := -1 * Str2Ext(Trim(Copy(GMTStr, P + 1, Length(GMTStr) - P)));
    end
    else
      Result := 0;
  end;
end;

function ConvertGMTStrTimes(const FromGMTStr: string; const FromDT: TDateTime;
  const ToGMTStr: string): TDateTime;
var
  GMT1, GMT2: Extended;
begin
  GMT1 := GMTStr2Value(FromGMTStr);
  GMT2 := GMTStr2Value(ToGMTStr);
  Result := FromDT + GMT2 - GMT1;
end;

function GetRFC822Difference: string;
var
  TZ: TTimeZoneInformation;
begin
  GetTimeZoneInformation(TZ);
  if TZ.Bias <= 0 then
  begin
    TZ.Bias := Abs(TZ.Bias);
    Result := '+' + LInt2ZStr(TZ.Bias div 60, 2)
      + LInt2ZStr(TZ.Bias mod 60, 2)
  end
  else
    Result := '-' + LInt2ZStr(TZ.Bias div 60, 2)
      + LInt2ZStr(TZ.Bias mod 60, 2)
end;

function StartOfWeek(const DT: TDateTime): TDateTime;
begin
  Result := DT - DayOfWeek(DT) + 1;
end;

function EndOfWeek(const DT: TDateTime): TDateTime;
begin
  Result := DT - DayOfWeek(DT) + 7;
end;

function ThisYear: Word;
var
  D, M: Word;
begin
  DeCodeDate(Now, Result, M, D);
end;

function ThisMonth: Word;
var
  D, Y: Word;
begin
  DeCodeDate(Now, Y, Result, D);
end;

function ThisDay: Word;
var
  M, Y: Word;
begin
  DeCodeDate(Now, Y, M, Result);
end;

function ThisHr: Word;
begin
  Result := Time2Hr(Time);
end;

function ThisMin: Word;
begin
  Result := Time2Min(Time);
end;

function ThisSec: Word;
begin
  Result := Time2Sec(Time);
end;

function IsJanuary(const DT: TDateTime): Boolean;
begin
  Result := GetMonth(DT) = 1;
end;

function IsFebruary(const DT: TDateTime): Boolean;
begin
  Result := GetMonth(DT) = 2;
end;

function IsMarch(const DT: TDateTime): Boolean;
begin
  Result := GetMonth(DT) = 3;
end;

function IsApril(const DT: TDateTime): Boolean;
begin
  Result := GetMonth(DT) = 4;
end;

function IsMay(const DT: TDateTime): Boolean;
begin
  Result := GetMonth(DT) = 5;
end;

function IsJune(const DT: TDateTime): Boolean;
begin
  Result := GetMonth(DT) = 6;
end;

function IsJuly(const DT: TDateTime): Boolean;
begin
  Result := GetMonth(DT) = 7;
end;

function IsAugust(const DT: TDateTime): Boolean;
begin
  Result := GetMonth(DT) = 8;
end;

function IsSeptember(const DT: TDateTime): Boolean;
begin
  Result := GetMonth(DT) = 9;
end;

function IsOctober(const DT: TDateTime): Boolean;
begin
  Result := GetMonth(DT) = 10;
end;

function IsNovember(const DT: TDateTime): Boolean;
begin
  Result := GetMonth(DT) = 11;
end;

function IsDecember(const DT: TDateTime): Boolean;
begin
  Result := GetMonth(DT) = 12;
end;

function Hrs_Min_Sec(Secs: Extended): string;
const
  OneSecond = 1 / 24 / 3600;
var
  Total: Extended;
begin
  Total := Secs * OneSecond;
  Result := Format('%1.0f 天%s', [Int(Total),
    FormatDateTime('hh:nn:ss', Frac(total))]);
end;

function DatesInSameMonth(const DT1, DT2: TDateTime): Boolean;
begin
  Result := GetMonth(DT1) = GetMonth(DT2);
end;

function DatesInSameYear(const DT1, DT2: TDateTime): Boolean;
begin
  Result := GetYear(DT1) = GetYear(DT2);
end;

function DatesInSameMonthYear(const DT1, DT2: TDateTime): Boolean;
begin
  Result := DatesInSameMonth(DT1, DT2) and DatesInSameYear(DT1, DT2);
end;

function AddDays(const DT: TDateTime; const Days: Extended): TDateTime;
begin
  Result := DT + Days;
end;

function IsAM(const DT: TDateTime): Boolean;
begin
  Result := Frac(DT) < 0.5
end;

function IsPM(const DT: TDateTime): Boolean;
begin
  Result := not IsAM(DT);
end;

function IsNoon(const DT: TDateTime): Boolean;
begin
  Result := Frac(DT) = 0.5;
end;

function IsMidnight(const DT: TDateTime): Boolean;
begin
  Result := Frac(DT) = 0.0;
end;

function IsSunday(const DT: TDateTime): Boolean;
begin
  Result := DayOfWeek(DT) = 1;
end;

function IsMonday(const DT: TDateTime): Boolean;
begin
  Result := DayOfWeek(DT) = 2;
end;

function IsTuesday(const DT: TDateTime): Boolean;
begin
  Result := DayOfWeek(DT) = 3;
end;

function IsWednesday(const DT: TDateTime): Boolean;
begin
  Result := DayOfWeek(DT) = 4;
end;

function IsThursday(const DT: TDateTime): Boolean;
begin
  Result := DayOfWeek(DT) = 5;
end;

function IsFriday(const DT: TDateTime): Boolean;
begin
  Result := DayOfWeek(DT) = 6;
end;

function IsSaturday(const DT: TDateTime): Boolean;
begin
  Result := DayOfWeek(DT) = 7;
end;

function IsWeekend(const DT: TDateTime): Boolean;
begin
  Result := DayOfWeek(DT) in [1, 7];
end;

function IsWorkDays(const DT: TDateTime): Boolean;
begin
  Result := DayOfWeek(DT) in [2..6];
end;

function DaysApart(const DT1, DT2: TDateTime): LongInt;
begin
  Result := Trunc(DT2) - Trunc(DT1);
end;

function DateIsLeapYear(const DT: TDateTime): Boolean;
begin
  Result := IsLeapYear(GetYear(DT));
end;

function DaysThisMonth(const DT: TDateTime): Byte;
begin
  case GetMonth(DT) of
    2: if DateIsLeapYear(DT) then
        Result := 29
      else
        Result := 28;
    4, 6, 9, 11: Result := 30;
  else
    Result := 31;
  end;
end;

function DaysInMonth(const DT: TDateTime): Byte;
begin case GetMonth(DT) of 2: if DateIsLeapYear(DT) then Result := 29 else Result := 28; 4, 6, 9, 11: Result := 30; else Result := 31; end; end;

function DaysLeftInMonth(const DT: TDateTime): Byte;
begin
  Result := DaysInMonth(DT) - GetDay(DT);
end;

function DaysInYear(const DT: TDateTime): Word;
begin
  if DateIsLeapYear(DT) then
    Result := 366
  else
    Result := 365;
end;

function DayOfYear(const DT: TDateTime): Word;
begin
  Result := Trunc(DT) - Trunc(EncodeDate(GetYear(DT), 1, 1)) + 1;
end;

function DaysLeftInYear(const DT: TDateTime): Word;
begin
  Result := DaysInYear(DT) - DayOfYear(DT);
end;

function ThisDayOfYear: Word;
begin
  Result := DayOfYear(Date);
end;

function WhichQuarter(const DT: TDateTime): Byte;
begin
  Result := (GetMonth(DT) - 1) div 3 + 1;
end;

function GetFirstDayOfYear(const Year: Word): TDateTime;
begin
  Result := EncodeDate(Year, 1, 1);
end;

function GetLastDayOfYear(const Year: Word): TDateTime;
begin
  Result := EncodeDate(Year, 12, 31);
end;

function SubtractMins(const DT: TDateTime; const Mins: Extended): TDateTime;
begin
  Result := AddMins(DT, -1 * Mins);
end;

function SubtractHrs(const DT: TDateTime; const Hrs: Extended): TDateTime;
begin
  Result := AddHrs(DT, -1 * Hrs);
end;

function SubtractWeeks(const DT: TDateTime; const Weeks: Extended): TDateTime;
begin
  Result := AddWeeks(DT, -1 * Weeks);
end;

function SubtractMonths(const DT: TDateTime; const Months: Extended): TDateTime;
begin
  Result := AddMonths(DT, -1 * Months);
end;

function SubtractDays(const DT: TDateTime; const Days: Extended): TDateTime;
begin
  Result := DT - Days;
end;

function AgeAtDate(const DOB, DT: TDateTime): Integer;
var
  D1, M1, Y1, D2, M2, Y2: Word;
begin
  if DT < DOB then
    Result := -1
  else
  begin
    DecodeDate(DOB, Y1, M1, D1);
    DecodeDate(DT, Y2, M2, D2);
    Result := Y2 - Y1;
    if (M2 < M1) or ((M2 = M1) and (D2 < D1)) then
      Dec(Result);
  end;
end;

function AgeNow(const DOB: TDateTime): Integer;
begin
  Result := AgeAtDate(DOB, Date);
end;

function EDOWToInt(const DOW: string): Integer;
var
  UCDOW: string;
  I, N: Integer;
begin
  Result := 0;
  UCDOW := UpperCase(DOW);
  N := Length(DOW);
  for I := 1 to 7 do
  begin
    if LeftStr(DayOfWeekStrings[I], N) = UCDOW then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function EMonthToInt(const Month: string): Integer;
var
  UCMonth: string;
  I, N: Integer;
begin
  Result := 0;
  UCMonth := UpperCase(Month);
  N := Length(Month);
  for I := 1 to 12 do
  begin
    if LeftStr(MonthStrings[I], N) = UCMonth then
    begin
      Result := I;
      Break;
    end;
  end;
end;

function GetCMonth(const DT: TDateTime): string;
begin
  Result := MonthCStrings[GetMonth(DT)];
end;

function GetC_Today: string;
var
  wYear, wMonth, wDay: Word;
  sYear, sMonth, sDay: string[2];
begin
  DecodeDate(Now, wYear, wMonth, wDay);
  wYear := wYear - 1911;
  sYear := Copy(IntToStr(wYear + 1000), 3, 2);
  sMonth := Copy(IntToStr(wMonth + 100), 2, 2);
  sDay := Copy(IntToStr(wDay + 100), 2, 2);
  Result := sYear + DateSeparator + sMonth + DateSeparator + sDay;
end;

{
Function TransC_DateToE_Date(Const CDT :String) :TDateTime;
Var  iYear,iMonth,iDay:Word;
Begin
  if Length(CDT) <> 12 then Exit;
if Pos(' ',CDT ) <> 0 then Exit;
  (* 民国日期 -> 公元日期 *)
iYear := StrToInt(Copy(CDT, 1, 2)) + 1911;
iMonth := StrToInt(Copy(CDT, 5, 2));
iDay:= StrToInt(Copy(CDT, 9, 2));
  Result:=EncodeDate(iYear,iMonth,iDay);
End;
   }

function GetCWeek(const DT: TDateTime): string;
begin
  Result := DayOfCWeekStrings[DayOfWeek(DT)];
end;

function GetLastDayForMonth(const DT: TDateTime): TDateTime;
var Y, M, D: Word;
begin
  DecodeDate(DT, Y, M, D);
  case M of
    2: begin
        if IsLeapYear(Y) then
          D := 29
        else
          D := 28;
      end;
    4, 6, 9, 11: D := 30
  else
    D := 31;
  end;
  Result := EnCodeDate(Y, M, D);
end;

function GetFirstDayForMonth(const DT: TDateTime): TDateTime;
var Y, M, D: Word;
begin
  DecodeDate(DT, Y, M, D);
//DecodeDate(DT,Y,M,1);
  Result := EncodeDate(Y, M, 1);
end;

function GetLastDayForPeriorMonth(const DT: TDateTime): TDateTime;
var Y, M, D: Word;
begin
  DecodeDate(DT, Y, M, D);
  M := M - 1;
  case M of
    2: begin
        if IsLeapYear(Y) then
          D := 29
        else
          D := 28;
      end;
    4, 6, 9, 11: D := 30
  else
    D := 31;
  end;
  Result := EnCodeDate(Y, M, D);
end;

function GetFirstDayForPeriorMonth(const DT: TDateTime): TDateTime;
var Y, M, D: Word;
begin
  DecodeDate(DT, Y, M, D);
  M := M - 1;
  Result := EncodeDate(Y, M, 1);
end;

function ROCDATE(DD: TDATETIME; P: integer): string; {转换某日期为民国0YYMMDD 型式字符串 }
var YEAR, MONTH, DAY: WORD; {P=0 不加'年'+'月'+'日'}
  CY, M, D: string; {P=1 加'年'+'月'+'日'}
  YY: integer;
begin
  DECODEDATE(DD, YEAR, MONTH, DAY);

  if (year = 0) and (month = 0) and (day = 0) then
  begin
    Result := '';
    exit;
  end;

  YY := YEAR - 1911;
  if YY > 0 then
  begin
    CY := inttostr(YY);
    if Length(CY) = 1 then CY := '00' + CY;
    if Length(CY) = 2 then CY := '0' + CY;
  end
  else
  begin
    YY := YEAR - 1912;
    CY := inttostr(YY);
//if Length(CY)=2 then CY:='-0'+RIGHT(CY,1);
    if Length(CY) = 2 then CY := '-0';
  end;

  if strtoint(CY) > 999 then
    CY := 'XXX';

  if (CY <> 'XXX') and (strtoint(CY) < -99) then
    CY := '-XX';

  M := inttostr(MONTH);
  if Length(M) = 1 then M := '0' + M;
  D := inttostr(DAY);
  if Length(D) = 1 then D := '0' + D;

  if P = 0 then
    Result := CY + DateSeparator + M + DateSeparator + D
  else
    Result := CY + '年' + M + '月' + D + '日';

end;

function ExactWeeksApart(const DT1, DT2: TDateTime): Extended;
begin
  Result := DaysApart(DT1, DT2) / 7;
end;

function WeeksApart(const DT1, DT2: TDateTime): Integer;
begin
  Result := DaysApart(DT1, DT2) div 7; ;
end;

function GetFirstSundayOfYear(const Year: Word): TDateTime;
var
  StartYear: TDateTime;
begin
  StartYear := GetFirstDayOfYear(Year);
  if DayOfWeek(StartYear) = 1 then
    Result := StartYear
  else
    Result := StartOfWeek(StartYear) + 7;
end;

function GetMDY(const DT: TDateTime): string;

begin
  Result := FormatDateTime('MM/DD/YY', DT);
end;

function DateToWeekNo(const DT: TDateTime): Integer;
var
  Year: Word;
  FirstSunday, StartYear: TDateTime;
  WeekOfs: Byte;
begin
  Year := GetYear(DT);
  StartYear := GetFirstDayOfYear(Year);
  if DayOfWeek(StartYear) = 0 then
  begin
    FirstSunday := StartYear;
    WeekOfs := 1;
  end
  else
  begin
    FirstSunday := StartOfWeek(StartYear) + 7;
    WeekOfs := 2;
    if DT < FirstSunday then
    begin
      Result := 1;
      Exit;
    end;
  end;
  Result := DaysApart(FirstSunday, StartofWeek(DT)) div 7 + WeekOfs;
end;

function DatesInSameWeekNo(const DT1, DT2: TDateTime): Boolean;
begin
  if GetYear(DT1) <> GetYear(DT2) then
    Result := False
  else
    Result := DateToWeekNo(DT1) = DateToWeekNo(DT2);
end;

function WeekNosApart(const DT1, DT2: TDateTime): Integer;
begin
  if GetYear(DT1) <> GetYear(DT2) then
    Result := -999
  else
    Result := DateToWeekNo(DT2) - DateToWeekNo(DT1);
end;

function ThisWeekNo: Integer;
begin
  Result := DateToWeekNo(Date);
end;

function GetWeekNoToDate_Sun(const WeekNo, Year: Word): TDateTime;
var
  FirstSunday: TDateTime;
begin
  FirstSunday := GetFirstSundayOfYear(Year);
  if GetDay(FirstSunday) = 1 then
    Result := AddWeeks(FirstSunday, WeekNo - 1)
  else
    Result := AddWeeks(FirstSunday, WeekNo - 2)
end;

function GetWeekNoToDate_Mon(const WeekNo, Year: Word): TDateTime;
begin
  Result := GetWeekNoToDate_Sun(WeekNo, Year) + 6;
end;

function DWYToDate(const DOW, WeekNo, Year: Word): TDateTime;
begin
  Result := GetWeekNoToDate_Sun(WeekNo, Year) + DOW - 1;
end;

function AgeAtDateInMonths(const DOB, DT: TDateTime): Integer;
var
  D1, D2: Word;
  M1, M2: Word;
  Y1, Y2: Word;
begin
  if DT < DOB then
    Result := -1
  else
  begin
    DecodeDate(DOB, Y1, M1, D1);
    DecodeDate(DT, Y2, M2, D2);
    if Y1 = Y2 then // Same Year
      Result := M2 - M1
    else // 不同年份
    begin
// 前12月的年龄
      Result := 12 * AgeAtDate(DOB, DT);
      if M1 > M2 then
        Result := Result + (12 - M1) + M2
      else if M1 < M2 then
        Result := Result + M2 - M1
      else if D1 > D2 then // Same Month
        Result := Result + 12;
    end;
    if D1 > D2 then // we have counted one month too many
      Dec(Result);
  end;
end;

function WeekNoToDate(const Weekno: Word): TDateTime;
begin
  Result := AddDays(GetWeekNoToDate_Sun(WeekNo, GetYear(Now)), 1);
end;

function AgeAtDateInWeeks(const DOB, DT: TDateTime): Integer;
begin
  if DT < DOB then
    Result := -1
  else
  begin
    Result := Trunc(DT - DOB) div 7;
  end;
end;

function AgeNowInMonths(const DOB: TDateTime): Integer;
begin
  Result := AgeAtDateInMonths(DOB, Date);
end;

function AgeNowInWeeks(const DOB: TDateTime): Integer;
begin
  Result := AgeAtDateInWeeks(DOB, Date);
end;

function AgeNowDescr(const DOB: TDateTime): string;
var
  Age: integer;
begin
  Age := AgeNow(DOB);
  if Age > 0 then
  begin
    if Age = 1 then
      Result := LInt2EStr(Age) + ' 岁'
    else
      Result := LInt2EStr(Age) + ' 岁';
  end
  else
  begin
    Age := AgeNowInMonths(DOB);
    if Age >= 2 then
      Result := LInt2EStr(Age) + ' 月'
    else
    begin
      Age := AgeNowInWeeks(DOB);
      if Age = 1 then
        Result := LInt2EStr(Age) + ' 周'
      else
        Result := LInt2EStr(Age) + ' 周';
    end;
  end;
end;

function CheckDate(const sCheckedDateString: string): boolean;
var
  iYear, iMonth, iDay: word;
begin
  Result := False;
(* 格式检查 *)
  if Length(sCheckedDateString) <> 8 then Exit;
  if Pos(' ', sCheckedDateString) <> 0 then Exit;
  if (sCheckedDateString[3] <> DateSeparator) or
    (sCheckedDateString[6] <> DateSeparator) then Exit;

(* 民国日期 -> 公元日期 *)
  iYear := StrToInt(Copy(sCheckedDateString, 1, 2)) + 1911;
  iMonth := StrToInt(Copy(sCheckedDateString, 4, 2));
  iDay := StrToInt(Copy(sCheckedDateString, 7, 2));

(* 日之判断 *)
//if iDay < 0 then Exit;
  case iMonth of
    1, 3, 5, 7, 8, 10, 12: Result := iDay <= 31; (* 大月 *)
    4, 6, 9, 11: Result := iDay <= 30; (* 小月 *)
    2: (* 依闰年计算法判断 *)
      if (iYear mod 400 = 0) or
        ((iYear mod 4 = 0) and (iYear mod 100 <> 0)) then
(* 闰年 *)
        Result := iDay <= 29
      else
        Result := iDay <= 28;
  end;
end;
{
function CheckLastDayOfMonth(DT : TDateTime) : Boolean;
var
D, M, Y: Word; Begin DecodeDate (DT, Y, M, D);
If M in [4,6,9,11]  then begin
If D = 30 then
Result:= True
Else
Result:= False;
End;
If M in [1,3,5,7,8,10,12]  then Begin
If D = 31 then
Result:= True
Else
Result:= False;
End;
if M=2 then begin
if IsLeapYear (Y) and (D=29) or Not IsLeapYear (Y) and (D=28) then
Begin
Result:= True; end else Begin Result:= False; end; End;end;
}
end.

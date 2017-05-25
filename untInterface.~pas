unit untInterface;

interface
uses Forms, Windows, SysUtils, Variants, Registry, Classes, Math, IniFiles, StdCtrls, StrUtils, Dialogs, IdHTTP, uLkJSON;

type
  TFordwardInterface = class


    function sendRequest(strRequestUrl: string): string;
    function dealResponse(strResponseStr: string): TlkJSONbase;
  private

    { Private declarations }
  public
    { Public declarations }

  end;

var
  ICInterface: TFordwardInterface;

implementation
uses ICCommunalConstUnit, ICCommunalVarUnit, ICFunctionUnit, dateProcess, strProcess, IdHashMessageDigest;




 //发送签到请求

function TFordwardInterface.sendRequest(strRequestUrl: string): string;
var
  strResponse: string;
  ResponseStream: TStringStream; //返回信息
  activeIdHTTP: TIdHTTP;
begin
  activeIdHTTP := TIdHTTP.Create(nil);
  ResponseStream := TStringStream.Create('');
  try
    activeIdHTTP.HandleRedirects := true;
    activeIdHTTP.Get(strRequestUrl, ResponseStream);
  except
    on e: Exception do
    begin
      showmessage('请检查网络是否正常，错误信息：' + e.message);
      exit;
    end;
  end;
    //获取网页返回的信息   网页中的存在中文时，需要进行UTF8解码
  strResponse := UTF8Decode(ResponseStream.DataString);

  result := strResponse;

end;

 //响应签到请求的回复  这个函数没必要

function TFordwardInterface.dealResponse(strResponseStr: string): TlkJSONbase;
var
  jsonResponse: TlkJSONbase;
  strResult: string;
begin
  //jsonResponse :=  TlkJSONbase.Create();
  jsonResponse := TlkJSON.ParseText(UTF8Encode(strResponseStr)) as TlkJSONobject; //UTF8编码
  //jsonResponse := TlkJSON.ParseText(UTF8Encode(strResponseStr)); //UTF8编码
  if jsonResponse = nil then
  begin
    Showmessage('跟后台通信繁忙,请联系技术人员');
    exit;
  end;

  if vartostr(jsonResponse.Field['code'].Value) <> '0' then
  begin
    Showmessage('错误码:' + vartostr(jsonResponse.Field['code'].Value) + ',' + vartostr(jsonResponse.Field['message'].Value) + ',请联系技术人员');
    exit;
  end;
  result := jsonResponse;
end;



end.


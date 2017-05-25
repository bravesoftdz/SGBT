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




 //����ǩ������

function TFordwardInterface.sendRequest(strRequestUrl: string): string;
var
  strResponse: string;
  ResponseStream: TStringStream; //������Ϣ
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
      showmessage('���������Ƿ�������������Ϣ��' + e.message);
      exit;
    end;
  end;
    //��ȡ��ҳ���ص���Ϣ   ��ҳ�еĴ�������ʱ����Ҫ����UTF8����
  strResponse := UTF8Decode(ResponseStream.DataString);

  result := strResponse;

end;

 //��Ӧǩ������Ļظ�  �������û��Ҫ

function TFordwardInterface.dealResponse(strResponseStr: string): TlkJSONbase;
var
  jsonResponse: TlkJSONbase;
  strResult: string;
begin
  //jsonResponse :=  TlkJSONbase.Create();
  jsonResponse := TlkJSON.ParseText(UTF8Encode(strResponseStr)) as TlkJSONobject; //UTF8����
  //jsonResponse := TlkJSON.ParseText(UTF8Encode(strResponseStr)); //UTF8����
  if jsonResponse = nil then
  begin
    Showmessage('����̨ͨ�ŷ�æ,����ϵ������Ա');
    exit;
  end;

  if vartostr(jsonResponse.Field['code'].Value) <> '0' then
  begin
    Showmessage('������:' + vartostr(jsonResponse.Field['code'].Value) + ',' + vartostr(jsonResponse.Field['message'].Value) + ',����ϵ������Ա');
    exit;
  end;
  result := jsonResponse;
end;



end.


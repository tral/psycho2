unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls;

type
  TForm1 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label166: TLabel;
    Label167: TLabel;
    Label168: TLabel;
    Label169: TLabel;
    Label170: TLabel;
    Label171: TLabel;
    Label172: TLabel;
    Label173: TLabel;
    Label174: TLabel;
    Label175: TLabel;
    Label176: TLabel;
    Label177: TLabel;
    Label178: TLabel;
    Label179: TLabel;
    Label180: TLabel;
    Label181: TLabel;
    Label182: TLabel;
    Label183: TLabel;
    Label184: TLabel;
    Label185: TLabel;
    Label186: TLabel;
    Label187: TLabel;
    Label188: TLabel;
    Label189: TLabel;
    Label190: TLabel;
    Label191: TLabel;
    Label192: TLabel;
    Label193: TLabel;
    Label194: TLabel;
    Label195: TLabel;
    Label196: TLabel;
    Label197: TLabel;
    Label198: TLabel;
    Label199: TLabel;
    Label200: TLabel;
    Label201: TLabel;
    Label202: TLabel;
    Label203: TLabel;
    Label204: TLabel;
    Label205: TLabel;
    Label206: TLabel;
    Label207: TLabel;
    Label208: TLabel;
    Label209: TLabel;
    Label210: TLabel;
    Label211: TLabel;
    Label212: TLabel;
    Label213: TLabel;
    Label214: TLabel;
    Label215: TLabel;
    Label216: TLabel;
    Label217: TLabel;
    Label218: TLabel;
    Label219: TLabel;
    Label220: TLabel;
    Label221: TLabel;
    Label222: TLabel;
    Label223: TLabel;
    Label224: TLabel;
    Label225: TLabel;
    Label226: TLabel;
    Label227: TLabel;
    Label228: TLabel;
    Label229: TLabel;
    Label230: TLabel;
    Label231: TLabel;
    Label232: TLabel;
    Label233: TLabel;
    Label234: TLabel;
    Label235: TLabel;
    Label236: TLabel;
    Label237: TLabel;
    Label238: TLabel;
    Label239: TLabel;
    Label240: TLabel;
    Label241: TLabel;
    Label242: TLabel;
    Label243: TLabel;
    Label244: TLabel;
    Label245: TLabel;
    Label246: TLabel;
    Label247: TLabel;
    Label248: TLabel;
    Label249: TLabel;
    Label250: TLabel;
    Label251: TLabel;
    Label252: TLabel;
    Label253: TLabel;
    Label254: TLabel;
    Label255: TLabel;
    Label256: TLabel;
    Label257: TLabel;
    Label258: TLabel;
    Label259: TLabel;
    Label260: TLabel;
    Label261: TLabel;
    Label262: TLabel;
    Label263: TLabel;
    Label264: TLabel;
    Label265: TLabel;
    Label266: TLabel;
    Label267: TLabel;
    Label268: TLabel;
    Label269: TLabel;
    Label270: TLabel;
    Label271: TLabel;
    Label272: TLabel;
    Label273: TLabel;
    Label274: TLabel;
    Label275: TLabel;
    Label276: TLabel;
    Label277: TLabel;
    Label278: TLabel;
    Label279: TLabel;
    Label280: TLabel;
    Label281: TLabel;
    Label282: TLabel;
    Label283: TLabel;
    Label284: TLabel;
    Label285: TLabel;
    Label286: TLabel;
    Label287: TLabel;
    Label288: TLabel;
    Label289: TLabel;
    Label290: TLabel;
    Label291: TLabel;
    Label292: TLabel;
    Label293: TLabel;
    Label294: TLabel;
    Label295: TLabel;
    Label296: TLabel;
    Label297: TLabel;
    Label298: TLabel;
    Label299: TLabel;
    Label300: TLabel;
    Label301: TLabel;
    Label302: TLabel;
    Label303: TLabel;
    Label304: TLabel;
    Label305: TLabel;
    Label306: TLabel;
    Label307: TLabel;
    Label308: TLabel;
    Label309: TLabel;
    Label310: TLabel;
    Label311: TLabel;
    Label312: TLabel;
    Label313: TLabel;
    Label314: TLabel;
    Label315: TLabel;
    Label316: TLabel;
    Label317: TLabel;
    Label318: TLabel;
    Label319: TLabel;
    Label320: TLabel;
    Label321: TLabel;
    Label322: TLabel;
    Label323: TLabel;
    Label324: TLabel;
    Label325: TLabel;
    Label326: TLabel;
    Label327: TLabel;
    Label328: TLabel;
    Label329: TLabel;
    Label330: TLabel;
    Label331: TLabel;
    Label332: TLabel;
    Label333: TLabel;
    Label334: TLabel;
    Label335: TLabel;
    Label336: TLabel;
    Label337: TLabel;
    Label338: TLabel;
    Label339: TLabel;
    Label340: TLabel;
    Label341: TLabel;
    Label342: TLabel;
    Label343: TLabel;
    Label344: TLabel;
    Label345: TLabel;
    Label346: TLabel;
    Label347: TLabel;
    Label348: TLabel;
    Label349: TLabel;
    Label350: TLabel;
    Label351: TLabel;
    Label352: TLabel;
    Label353: TLabel;
    Label354: TLabel;
    Label355: TLabel;
    Label356: TLabel;
    Label357: TLabel;
    Label358: TLabel;
    Label359: TLabel;
    Label360: TLabel;
    Label361: TLabel;
    Label362: TLabel;
    Label363: TLabel;
    Label364: TLabel;
    Label365: TLabel;
    Label366: TLabel;
    Label367: TLabel;
    Label368: TLabel;
    Label369: TLabel;
    Label370: TLabel;
    Label372: TLabel;
    Label373: TLabel;
    Label374: TLabel;
    Label375: TLabel;
    Label376: TLabel;
    Label377: TLabel;
    Label378: TLabel;
    Label379: TLabel;
    Label380: TLabel;
    Label381: TLabel;
    Label382: TLabel;
    Label383: TLabel;
    Label384: TLabel;
    Label385: TLabel;
    Label386: TLabel;
    Label387: TLabel;
    Label388: TLabel;
    Label389: TLabel;
    Label390: TLabel;
    Label391: TLabel;
    Label392: TLabel;
    Label393: TLabel;
    Label394: TLabel;
    Label395: TLabel;
    Label396: TLabel;
    Label397: TLabel;
    Label398: TLabel;
    Label399: TLabel;
    Label400: TLabel;
    Label401: TLabel;
    Label402: TLabel;
    Label403: TLabel;
    Label404: TLabel;
    Label405: TLabel;
    Label406: TLabel;
    Label407: TLabel;
    Label408: TLabel;
    Label409: TLabel;
    Label410: TLabel;
    Label411: TLabel;
    Label412: TLabel;
    Label413: TLabel;
    Label414: TLabel;
    Label415: TLabel;
    Label416: TLabel;
    Label417: TLabel;
    Label418: TLabel;
    Label419: TLabel;
    Label420: TLabel;
    Label421: TLabel;
    Label422: TLabel;
    Label423: TLabel;
    Label424: TLabel;
    Label425: TLabel;
    Label426: TLabel;
    Label427: TLabel;
    Label428: TLabel;
    Label429: TLabel;
    Label430: TLabel;
    Label431: TLabel;
    Label432: TLabel;
    Label433: TLabel;
    Label434: TLabel;
    Label435: TLabel;
    Label436: TLabel;
    Label437: TLabel;
    Label438: TLabel;
    Label439: TLabel;
    Label440: TLabel;
    Label441: TLabel;
    Label442: TLabel;
    Label443: TLabel;
    Label444: TLabel;
    Label445: TLabel;
    Label446: TLabel;
    Label447: TLabel;
    Label448: TLabel;
    Label449: TLabel;
    Label450: TLabel;
    Label451: TLabel;
    Label452: TLabel;
    Label453: TLabel;
    Label1: TLabel;
    Label454: TLabel;
    Label455: TLabel;
    Label456: TLabel;
    Label457: TLabel;
    Label458: TLabel;
    Label459: TLabel;
    Label460: TLabel;
    Label461: TLabel;
    Label462: TLabel;
    Label463: TLabel;
    Label464: TLabel;
    Label465: TLabel;
    Label466: TLabel;
    Label467: TLabel;
    Label468: TLabel;
    Label469: TLabel;
    Label470: TLabel;
    Label471: TLabel;
    Label472: TLabel;
    Label473: TLabel;
    Label474: TLabel;
    Label475: TLabel;
    Label476: TLabel;
    Label477: TLabel;
    Label478: TLabel;
    Label479: TLabel;
    Label480: TLabel;
    Label481: TLabel;
    Label482: TLabel;
    Label483: TLabel;
    Label484: TLabel;
    Label485: TLabel;
    Label486: TLabel;
    Label487: TLabel;
    Label488: TLabel;
    Label489: TLabel;
    Label490: TLabel;
    Label491: TLabel;
    Label492: TLabel;
    Label493: TLabel;
    Label494: TLabel;
    Label495: TLabel;
    Label496: TLabel;
    Label497: TLabel;
    Label498: TLabel;
    Label499: TLabel;
    Label500: TLabel;
    Label501: TLabel;
    Label502: TLabel;
    Label503: TLabel;
    Label504: TLabel;
    Label505: TLabel;
    Label506: TLabel;
    Label507: TLabel;
    Label508: TLabel;
    Label509: TLabel;
    Label510: TLabel;
    Label511: TLabel;
    Label512: TLabel;
    Label513: TLabel;
    Label514: TLabel;
    Label515: TLabel;
    Label516: TLabel;
    Label517: TLabel;
    Label518: TLabel;
    Label519: TLabel;
    Label520: TLabel;
    Label521: TLabel;
    Label522: TLabel;
    Label523: TLabel;
    Label524: TLabel;
    Label525: TLabel;
    Label526: TLabel;
    Label527: TLabel;
    Label528: TLabel;
    Label529: TLabel;
    Label530: TLabel;
    Label531: TLabel;
    Label532: TLabel;
    Label533: TLabel;
    Label534: TLabel;
    Label535: TLabel;
    Label536: TLabel;
    Label537: TLabel;
    Label538: TLabel;
    Label539: TLabel;
    Label540: TLabel;
    Label541: TLabel;
    Label542: TLabel;
    Label543: TLabel;
    Label544: TLabel;
    Label545: TLabel;
    Label546: TLabel;
    Label547: TLabel;
    Label548: TLabel;
    Label549: TLabel;
    Label550: TLabel;
    Label551: TLabel;
    Label552: TLabel;
    Label553: TLabel;
    Label554: TLabel;
    Label555: TLabel;
    Label556: TLabel;
    Label557: TLabel;
    Label558: TLabel;
    Label559: TLabel;
    Label560: TLabel;
    Label561: TLabel;
    Label562: TLabel;
    Label563: TLabel;
    Label564: TLabel;
    Label565: TLabel;
    Label566: TLabel;
    Label567: TLabel;
    Label568: TLabel;
    Label569: TLabel;
    Label570: TLabel;
    Label571: TLabel;
    Label572: TLabel;
    Label573: TLabel;
    Label574: TLabel;
    Label575: TLabel;
    Label576: TLabel;
    Label577: TLabel;
    Label578: TLabel;
    Label579: TLabel;
    Label580: TLabel;
    Label581: TLabel;
    Label582: TLabel;
    Label583: TLabel;
    Label584: TLabel;
    Label585: TLabel;
    Label586: TLabel;
    Label587: TLabel;
    Label588: TLabel;
    Label589: TLabel;
    Label590: TLabel;
    Label591: TLabel;
    Label592: TLabel;
    Label593: TLabel;
    Label594: TLabel;
    Label595: TLabel;
    Label596: TLabel;
    Label597: TLabel;
    Label598: TLabel;
    Label599: TLabel;
    Label600: TLabel;
    Label601: TLabel;
    Label602: TLabel;
    Label603: TLabel;
    Label604: TLabel;
    Label605: TLabel;
    Label606: TLabel;
    Label607: TLabel;
    Label608: TLabel;
    Label609: TLabel;
    Label610: TLabel;
    Label611: TLabel;
    Label612: TLabel;
    Label613: TLabel;
    Label614: TLabel;
    Label615: TLabel;
    Label616: TLabel;
    Label86: TLabel;
    Label87: TLabel;
    Label88: TLabel;
    Label89: TLabel;
    Label90: TLabel;
    Label91: TLabel;
    Label92: TLabel;
    Label93: TLabel;
    Label94: TLabel;
    Label95: TLabel;
    Label96: TLabel;
    Label97: TLabel;
    Label98: TLabel;
    Label99: TLabel;
    Label100: TLabel;
    Label101: TLabel;
    Label102: TLabel;
    Label103: TLabel;
    Label104: TLabel;
    Label105: TLabel;
    Label106: TLabel;
    Label107: TLabel;
    Label108: TLabel;
    Label109: TLabel;
    Label110: TLabel;
    Label111: TLabel;
    Label112: TLabel;
    Label113: TLabel;
    Label114: TLabel;
    Label115: TLabel;
    Label116: TLabel;
    Label117: TLabel;
    Label118: TLabel;
    Label119: TLabel;
    Label120: TLabel;
    Label121: TLabel;
    Label122: TLabel;
    Label123: TLabel;
    Label124: TLabel;
    Label125: TLabel;
    Label617: TLabel;
    Label126: TLabel;
    Label127: TLabel;
    Label128: TLabel;
    Label129: TLabel;
    Label130: TLabel;
    Label131: TLabel;
    Label132: TLabel;
    Label133: TLabel;
    Label134: TLabel;
    Label135: TLabel;
    Label136: TLabel;
    Label137: TLabel;
    Label138: TLabel;
    Label139: TLabel;
    Label140: TLabel;
    Label141: TLabel;
    Label142: TLabel;
    Label143: TLabel;
    Label144: TLabel;
    Label145: TLabel;
    Label146: TLabel;
    Label147: TLabel;
    Label148: TLabel;
    Label149: TLabel;
    Label150: TLabel;
    Label151: TLabel;
    Label152: TLabel;
    Label153: TLabel;
    Label154: TLabel;
    Label155: TLabel;
    Label156: TLabel;
    Label157: TLabel;
    Label158: TLabel;
    Label159: TLabel;
    Label160: TLabel;
    Label161: TLabel;
    Label162: TLabel;
    Label163: TLabel;
    Label164: TLabel;
    Label165: TLabel;
    Label371: TLabel;
    Label618: TLabel;
    Label619: TLabel;
    Label620: TLabel;
    Label621: TLabel;
    Label622: TLabel;
    Label623: TLabel;
    Label624: TLabel;
    Label625: TLabel;
    Label626: TLabel;
    Label627: TLabel;
    Label628: TLabel;
    Label629: TLabel;
    Label630: TLabel;
    Label631: TLabel;
    Label632: TLabel;
    Label633: TLabel;
    Label634: TLabel;
    Label635: TLabel;
    Label636: TLabel;
    Label637: TLabel;
    Label638: TLabel;
    Label639: TLabel;
    Label640: TLabel;
    Label641: TLabel;
    Label642: TLabel;
    Label643: TLabel;
    Label644: TLabel;
    Label645: TLabel;
    Label646: TLabel;
    Label647: TLabel;
    Label648: TLabel;
    Label649: TLabel;
    Label650: TLabel;
    Label651: TLabel;
    Label652: TLabel;
    Label653: TLabel;
    Label654: TLabel;
    Label655: TLabel;
    Label656: TLabel;
    Label657: TLabel;
    Label658: TLabel;
    procedure Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Label6MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  MyMouse: TMouse;
  oldX, oldY1, oldY2 : Integer;
  AllowMoveHandle:boolean;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  oldX := 175;
  oldY1 := 252;
  oldY2 := 287;
  AllowMoveHandle := true;
//  SetCursorPos (Form1.left+Panel1.Left,  Form1.top+Panel1.Top);
end;

procedure TForm1.Panel2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var point: Tpoint;
begin
  Label3.Caption := inttostr(MyMouse.CursorPos.x) + 'Х ' +  inttostr(MyMouse.CursorPos.y);
end;




procedure TForm1.Label6MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var point: Tpoint;
begin
{      GetCursorPos(point);
      Label2.Caption:=inttostr(point.x);
      Label3.Caption:=inttostr(point.y);
      Label4.Caption:=inttostr(x);
      Label5.Caption:=inttostr(y);}
      Label3.Caption := 'Х: ' + inttostr(MyMouse.CursorPos.x-Form1.Left-5) + ' Y: ' +  inttostr(MyMouse.CursorPos.y-Form1.Top-51);
end;

procedure TForm1.Panel1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var point: Tpoint;
begin
      GetCursorPos(point);
      Label2.Caption:=inttostr(point.x);
      Label3.Caption:=inttostr(point.y);
      Label4.Caption:=inttostr(x);
      Label5.Caption:=inttostr(y);


//  Label3.Caption := inttostr(MyMouse.CursorPos.x) + 'Х ' +  inttostr(MyMouse.CursorPos.y);

if AllowMoveHandle then
begin

//  GetCursorPos(point);


//  Label3.Caption := inttostr(MyMouse.CursorPos.x) + 'Х ' +  inttostr(MyMouse.CursorPos.y);

           {
  if ((point.x<oldX) and (point.y<oldY1)) then
  begin
    AllowMoveHandle := false; // Чтобы SetCursorPos не вызывал обработчик MouseMove
    SetCursorPos (oldX,  oldY1)
  end
  else
    if ((point.x<oldX) and (point.y>oldY2)) then
    begin
      AllowMoveHandle := false; // Чтобы SetCursorPos не вызывал обработчик MouseMove
      SetCursorPos (oldX,  oldY2)
    end
      else
      if (point.y<oldY1) then
      begin
        AllowMoveHandle := false; // Чтобы SetCursorPos не вызывал обработчик MouseMove
        SetCursorPos (point.x,  oldY1)
      end
      else
        if (point.y>oldY2) then
        begin
          AllowMoveHandle := false; // Чтобы SetCursorPos не вызывал обработчик MouseMove
          SetCursorPos (point.x,  oldY2)
        end
        else
          if (point.x<oldX) then
          begin
            AllowMoveHandle := false; // Чтобы SetCursorPos не вызывал обработчик MouseMove
            SetCursorPos (oldX,  point.y)
          end
    else
    begin
      oldX := point.x;

      Label2.Caption:=inttostr(point.x);
      Label3.Caption:=inttostr(point.y);
      Label4.Caption:=inttostr(x);
      Label5.Caption:=inttostr(y);
    end;
                }
  //SetCursorPos (point.x-1,  point.Y-1);
end
else AllowMoveHandle := true;


end;



end.

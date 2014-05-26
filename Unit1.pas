unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls, Registry;

const
 TasksCount = 6; // ������� ����� ������� (� �����, ����� �����)
 Intervals  = 4; // ������� ����� ��������� �������� ��� ��������� (������ ���� 5, � ��������� �� ����� 4, �.�. ������������ 4 ������)

 Version = '1.09';
 Title = '������������ ��������� ��������� (���)';
 IsDemoVersion = False; // ����� �������� ������� ����-��������, ����� �������� ������ (Version)

type
 TMatrix =  array [1..TasksCount] of array [1..Intervals] of Double;
 TMatrixI = array [1..TasksCount] of array [1..Intervals] of Integer;
 TVectorForIndT = array [1 .. TasksCount] of Double;

type
  TForm1 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    l1: TLabel;
    l2: TLabel;
    l3: TLabel;
    l4: TLabel;
    l5: TLabel;
    l6: TLabel;
    l7: TLabel;
    l8: TLabel;
    l9: TLabel;
    l10: TLabel;
    l11: TLabel;
    l12: TLabel;
    l13: TLabel;
    l14: TLabel;
    l15: TLabel;
    l16: TLabel;
    l17: TLabel;
    l18: TLabel;
    l19: TLabel;
    l20: TLabel;
    l21: TLabel;
    l22: TLabel;
    l23: TLabel;
    l24: TLabel;
    l25: TLabel;
    l26: TLabel;
    l27: TLabel;
    l28: TLabel;
    l29: TLabel;
    l30: TLabel;
    l31: TLabel;
    l32: TLabel;
    l33: TLabel;
    l34: TLabel;
    l35: TLabel;
    l36: TLabel;
    l37: TLabel;
    l38: TLabel;
    l39: TLabel;
    l40: TLabel;
    Button1: TButton;
    Label1: TLabel;
    Button3: TButton;
    Button4: TButton;
    Label6: TLabel;
    Timer1: TTimer;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Cursor1: TShape;
    l1_: TLabel;
    l2_: TLabel;
    l3_: TLabel;
    l4_: TLabel;
    l5_: TLabel;
    l6_: TLabel;
    l7_: TLabel;
    l8_: TLabel;
    l9_: TLabel;
    l10_: TLabel;
    l11_: TLabel;
    l12_: TLabel;
    l13_: TLabel;
    l14_: TLabel;
    l15_: TLabel;
    l16_: TLabel;
    l17_: TLabel;
    l18_: TLabel;
    l19_: TLabel;
    l20_: TLabel;
    l21_: TLabel;
    l22_: TLabel;
    l23_: TLabel;
    l24_: TLabel;
    l25_: TLabel;
    l26_: TLabel;
    l27_: TLabel;
    l28_: TLabel;
    l29_: TLabel;
    l30_: TLabel;
    l31_: TLabel;
    l32_: TLabel;
    l33_: TLabel;
    l34_: TLabel;
    l35_: TLabel;
    l36_: TLabel;
    l37_: TLabel;
    l38_: TLabel;
    l39_: TLabel;
    l40_: TLabel;
    l1__: TLabel;
    l2__: TLabel;
    l3__: TLabel;
    l4__: TLabel;
    l5__: TLabel;
    l6__: TLabel;
    l7__: TLabel;
    l8__: TLabel;
    l9__: TLabel;
    l10__: TLabel;
    l11__: TLabel;
    l12__: TLabel;
    l13__: TLabel;
    l14__: TLabel;
    l15__: TLabel;
    l16__: TLabel;
    l17__: TLabel;
    l18__: TLabel;
    l19__: TLabel;
    l20__: TLabel;
    l21__: TLabel;
    l22__: TLabel;
    l23__: TLabel;
    l24__: TLabel;
    l25__: TLabel;
    l26__: TLabel;
    l27__: TLabel;
    l28__: TLabel;
    l29__: TLabel;
    l30__: TLabel;
    l31__: TLabel;
    l32__: TLabel;
    l33__: TLabel;
    l34__: TLabel;
    l35__: TLabel;
    l36__: TLabel;
    l37__: TLabel;
    l38__: TLabel;
    l39__: TLabel;
    l40__: TLabel;
    Button2: TButton;
    btn1: TSpeedButton;
    procedure PrepareToStartTask();
    procedure StartTask();
    procedure StartTestTask();
    procedure FinishTask();
    procedure LettersVisibility(flag:boolean);
    procedure RenderNextRow();
    function GetLetterIndexByCoords(x:integer):integer;
    procedure RowGenerator(signalLetter, prefix:string; sgnCnt:integer);
    procedure ShiftRows(signalLetter, prefix:string; sgnCnt:integer);

    procedure FormCreate(Sender: TObject);

    procedure Label6MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure l1Click(Sender: TObject);
    procedure btn1Click(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure Button2Click(Sender: TObject);
    procedure ShowStartScreen;

    function MyRegReadInteger(dwRootKey: DWord;  const Key, Param: String): Integer;
    procedure MyRegWriteInteger(dwRootKey: DWord; const Key, Param: String; Val:Integer);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);

  private
      procedure WMNCLBUTTONDOWN(var Msg: TWMNCLButtonDown) ; message WM_NCLBUTTONDOWN;
      procedure WMNCLBUTTONUP(var Msg: TWMNCLButtonUp) ; message WM_NCLBUTTONUP;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  MyMouse: TMouse;
  oldX, oldY, minY, maxY, maxX : Integer;
  AllowMoveCursor : boolean;
  TestInProgress: boolean;
  IsTestTask: Boolean; // ���� �� �������� �������?

  // ������������� (���������) ����� �������
  TestTypes : array [1..TasksCount] of integer;

  // � ������� ����� (������ ������ - ������)
  aTime : Array of Array [1..40] of Int64; // ����� �������
  aClicks : Array of array [1..40] of int64; // ����� ����� (0 ��� ����� �������)
  aLetters : Array of Array [1..40] of string; // ��� ���� (��� ���� �����)
  aSignal : Array of array [1..40] of boolean; // ����� ���������� ���� (True/False)

  aX : Array of array of Integer; // ���������� x �������
  aY : Array of array of Integer; // ���������� y �������

  currLetters : array [1..40] of String; // ������� �����
  nextLetters : array [1..40] of String; // ������-������ (3-�)
  tmpLetters : array [1..40] of String; // ��������� ������ ��� ������ �����
  CurrSignalLetter : string; // ������� ���������� �����
  CurrPrefix : string; // ������� �������

  EmptyStringsInARow : byte; // ����� ��������������� ����� ��� ���������� ����� ������
  CurrRowNumber : Integer; // ������� ������ ������� (���������� �����)
  CurrTaskNumber : integer; // ����� �������� ������� �� 1 �� TasksCount
  TestType : byte; // ��� ����� 1 ��� 2
  TaskStartTime, TaskFinishTime : int64; // ����� ������ � ��������� �������

  user_name : string;
  user_gender:byte;
  user_age: string;

  // ��������� (������ ������ - ����� �������, ������ - ������)
  T : TVectorForIndT; // ����� 6.2.1
  KB : TMatrixI; // ����� 6.2.2
  PZ : TMatrixI; // ����� 6.2.3
  OZ : TMatrixI; // ����� 4 - �� ���� ������� KO
  ONZ : TMatrixI; // ����� 5 - �� ���� ������� KO
  KPZ : TMatrix; // ����� 6 PZ/KB
  KOZ : TMatrix; // ����� 7 OZ/KB
  KONZ : TMatrix; // ����� 8 ONZ/KB
  OZPZ : TMatrix; // ����� 9 OZ/PZ
  ONZPZ : TMatrix; // ����� 10 ONZ/PZ
  KO : TMatrix; // ����� 6.2.4 OZ+ONZ
  KT : TMatrix; // ����� 12 (PZ-OZ)/(PZ+ONZ)
  SDK : TMatrix; // ����� 13
  SDK1P : TMatrix; // ����� 14
  SPP : TMatrix; // ����� 6.2.5.2
  SPO : TMatrix; // ����� 6.2.5.3
  SOP : TMatrix; // ����� 6.2.5.4
  SOO : TMatrix; // ����� 6.2.5.5
  SDK1O : TMatrix; // ����� 15
  SDK2  : TMatrix; // ����� 16
  SDK3P : TMatrix; // ����� 17
  SDK3O : TMatrix; // ����� 18
  const aGl : array[1..8] of String = ('�', '�', '�', '�', '�', '�', '�', '�');
  const aSo : array[1..19] of String = ('�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�');
  const aAll : array[1..27] of String = ('�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�', '�');

implementation

uses ToolUnit, Analytics, UAuthForm;

{$R *.dfm}

procedure TForm1.PrepareToStartTask();
begin
  // ������� ��� ����������� ������������ �������
  SetLength(aTime, 0);
  SetLength(aX, 0);
  SetLength(aY, 0);
  SetLength(aClicks, 0);
  SetLength(aLetters, 0);
  SetLength(aSignal, 0);

  CurrRowNumber := 0;
  EmptyStringsInARow := 0;
  LettersVisibility (true);
  TestInProgress := true;
  AllowMoveCursor := True;
  TaskStartTime := GetTickCount;
end;

procedure TForm1.StartTestTask();
begin
  PrepareToStartTask();

  IsTestTask := True;
  RenderNextRow();
end;

procedure TForm1.StartTask();
begin
  PrepareToStartTask();

  IsTestTask := False;
  Timer1.Enabled := True;   // Timer start
  RenderNextRow();
end;

// ���������� �������
procedure TForm1.FinishTask();
begin

  Timer1.Enabled := false;
  LettersVisibility (false);
  TestInProgress := false;
  AllowMoveCursor := True;
  TaskFinishTime := GetTickCount;

  if (NOT IsTestTask) then
  begin

    Analytics.CountTask();

    if CurrTaskNumber = TasksCount then
      Analytics.ToCSV() //!!! ����������

  end;

  Form2.NextStep();
  Form2.ShowModal();

end;

procedure TForm1.ShowStartScreen;
begin
  btn1.Hide;
  Label9.Hide;
  Label10.Hide;
  Form1.BorderIcons := [biSystemMenu];

  CurrStep := 'personal';

  // DEBUG!!! DEL
//  CurrStep := 'next_test_info'; // !!!
//  Form2.NextStep;// !!!

  Form2.ShowModal;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  ShowStartScreen;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
//  StartTask();
end;

procedure TForm1.Button2Click(Sender: TObject);
var i,j,k : integer;
begin

  TestType := 2;
  for I := 1 to 1000 do
  begin

    SetLength(aLetters, 0);
    SetLength(aSignal, 0);
    SetLength(aClicks, 0);
    SetLength(aTime, 0);
    CurrSignalLetter := '�';
    CurrPrefix:='���';
    CurrRowNumber := 0;
    EmptyStringsInARow := 0;
    RenderNextRow();

    getFirstSignalIndex(0);

  end;

  // Test 1
  for I := 1 to 1000000 do
  begin
      k:= Random(6);
      ToolUnit.GenerateStringForTest2('�', k, '���');
       for j := 1 to 40 do
        if currLetters[j]='' then begin
        showmessage('gotcha!');
        end;

      ToolUnit.GenerateStringForTest1('�', k);
      for j := 1 to 40 do
        if currLetters[j]='' then begin
        showmessage('gotcha!');
        end;
  end;


end;

procedure TForm1.RenderNextRow();
//  var point: Tpoint;
begin

  if (IsTestTask)
  then  // �������� ������� !!!
    begin

      if (CurrRowNumber = 4)
      then
        begin
          FinishTask();
          Exit;
        end
      else
        Form1.ShiftRows(CurrSignalLetter, CurrPrefix, 2 {������ ��������������� ���� �����});

    end
  else // ������ ���� !!!
    begin
      Form1.ShiftRows(CurrSignalLetter, CurrPrefix, -1);
    end;

  Cursor1.Left := 56; // ������������� ������ � ������ ������

  // ������� ����� ������� ��������� ������� �� ������ ������
  aTime[High(aTime)][1] := GetTickCount;

end;


// �������� ������
procedure TForm1.ShiftRows(signalLetter, prefix:string; sgnCnt:integer);
var
  i:integer;
begin
  // ����������� �� 1 ����������� ��������� ��������
  SetLength(aLetters, Length(aLetters)+1);
  SetLength(aSignal, Length(aSignal)+1);
  SetLength(aClicks, Length(aClicks)+1);
  SetLength(aTime, Length(aTime)+1);
//  SetLength(aX, Length(aX)+1);
//  SetLength(aY, Length(aY)+1);

  // ������ ��������� ����� ������ ������ �������
  if (CurrRowNumber = 0) then
  begin
    inc(CurrRowNumber); // ���������� ����� ������� ������ � �������
    Form1.RowGenerator(signalLetter, prefix, sgnCnt); //  (����������� currLetters)
    for i := 1 to 40 do nextLetters[i] := currLetters[i];
    for i := 1 to 40 do currLetters[i]:='';
  end;

  for i:=1 to 40 do begin
    (FindComponent('l'+inttostr(i)+'_') as TLabel).Caption := currLetters[i];
     //Application.ProcessMessages;
  end;

  inc(CurrRowNumber); // ���������� ����� ������� ������ � �������
  if ((IsTestTask) and (CurrRowNumber=2)) then sgnCnt := 3; // ����� ��� ��������� ������� (3 ������ 2-3-2 ���������� �����)
  Form1.RowGenerator(signalLetter, prefix, sgnCnt); // ��������� ����� ���� (����������� currLetters)
  for i := 1 to 40 do tmpLetters[i] := currLetters[i];
  for i := 1 to 40 do currLetters[i] := nextLetters[i];
  for i := 1 to 40 do nextLetters[i] := tmpLetters[i];

  for i:=1 to 40 do
  begin
    (FindComponent('l'+inttostr(i)+'__') as TLabel).Caption := nextLetters[i];
    (FindComponent('l'+inttostr(i)) as TLabel).Caption := currLetters[i];
    //Application.ProcessMessages;
  end;


  // ��������� ��������� �������
  for i:=1 to 40 do begin
      aLetters[High(aLetters)][i] := currLetters[i];

      if TestType=1 then
      begin
        if (currLetters[i]=signalLetter) then aSignal[High(aSignal)][i] := true
                                         else aSignal[High(aSignal)][i] := false;
      end
      else
      begin
        aSignal[High(aSignal)][i] := false;
        if (i>=4) then
         begin
           if (currLetters[i]=signalLetter)
              and (currLetters[i-1]=prefix[3])
              and (currLetters[i-2]=prefix[2])
              and (currLetters[i-3]=prefix[1])
           then aSignal[High(aSignal)][i] := true
          end;
      end;
  end;

// del debug
//  for i:=1 to 40 do
//    if aSignal[High(aSignal)][i]=true then (FindComponent('l'+inttostr(i)) as TLabel).Color := clGreen
//                                      else (FindComponent('l'+inttostr(i)) as TLabel).Color := clWhite;

end;


// ��������� ������ currLetters
procedure TForm1.RowGenerator(signalLetter, prefix:string; sgnCnt:integer);
begin

    Randomize;

    if sgnCnt > 0 then sgnCnt := sgnCnt // ���� ������� ���� ������� ���� ���������� ���� ��������� - ������� � �������
      else if CurrRowNumber = 1 then sgnCnt:= 1 + Random(5) // ��������� ����� �� 1 �� 5 - � 1-� ������ ������ ���� ���� �� ���� ���������� �����
        else if EmptyStringsInARow >= 2 then sgnCnt:= 1 + Random(5) // ��������� ����� �� 1 �� 5 - �.�. ��� ���� 2 ������ ������ ��� ���������� ����
          else sgnCnt:= Random(6); // ����� ��������� ����� �� 0 �� 5 - ������� ���������

    if TestType = 1 then
      ToolUnit.GenerateStringForTest1(signalLetter, sgnCnt)
    else
    begin
      // ����� ��� ��������, ��� �������� ��������� ������� ���������� ����������: �������+�����,
      // ����� ����������� ������, ����� � ������� ������������ ��������� ������� 6 �������� ����� ����������� �������
      repeat
        ToolUnit.GenerateStringForTest2(signalLetter, sgnCnt, prefix);
      until signalLettersCount(signalLetter, prefix) <= sgnCnt; // �� ����� ���� ��������� ������ ���������� ����, ��� ���������!

    end;

    // �������� ���� �� ���� �� ���� ���������� ����� � ��������������� ������
    if ToolUnit.isWithoutSignal(signalLetter, prefix) then inc(EmptyStringsInARow)
                                                      else EmptyStringsInARow := 0;

end;

// ���������� � �������� ����� � ��������
procedure TForm1.LettersVisibility(flag:boolean);
  var i: integer;

begin
  for i:=1 to 40 do
  begin
   (FindComponent('l'+inttostr(i)) as TLabel).Visible := flag;
   (FindComponent('l'+inttostr(i)+'_') as TLabel).Visible := flag;
   (FindComponent('l'+inttostr(i)+'__') as TLabel).Visible := flag;
  end;
  Cursor1.Visible := flag;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
//showmessage ('timer!');
  FinishTask();
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
//  TestType := 1;
//  Form1.RowGenerator(RandomLetter(''), '');
end;

procedure TForm1.Button4Click(Sender: TObject);
//var signalLetter, prefix:String;
begin

//  TestType := 2;
//  signalLetter := RandomLetter('');

//  if ToolUnit.inArrayG(signalLetter) then
//    prefix := ToolUnit.RandomLetterS('')+ToolUnit.RandomLetterS('')+ToolUnit.RandomLetterS('')
//  else
//    prefix := ToolUnit.RandomLetterG('')+ToolUnit.RandomLetterG('')+ToolUnit.RandomLetterG('');

//  Form1.RowGenerator(signalLetter, prefix);

end;

procedure TForm1.FormCreate(Sender: TObject);
var lLaunches: Integer;
begin

  if IsDemoVersion then
  begin
    lLaunches := MyRegReadInteger(HKEY_CURRENT_USER, '\Software\Proj_PGAIK' ,  'Launches'+Version);

    if (lLaunches > 10) then
    begin
      showmessage('��������� ���������� ����� �������� ���������������� ������!');
      Application.Terminate;
    end;

    MyRegWriteInteger(HKEY_CURRENT_USER, '\Software\Proj_PGAIK', 'Launches'+Version, lLaunches+1);

  end;


  LettersVisibility (false);
  TestInProgress := false;
  CurrTaskNumber := 0;
//   TestType := 1; ������������ �������� �� ������� � �������
  multiplier := Round(Form1.Timer1.Interval/Intervals); // ������� ������� � �������������, ������� Intervals, � ����� ����� ����� ������ ������� (�� �� ������� 4 ������, ��������� �� 1 ������)

  Form1.Caption := Title + ' v' + Version;

  if IsDemoVersion then Form1.Caption := Form1.Caption + ' ���������������� ������ (�������� �������� �� ���� ����������: '+inttostr(10-lLaunches)+')';
  

end;


procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if TestInProgress then
  begin

    Case Key of
      VK_RIGHT :
        if AllowMoveCursor then
        begin
          // ���� ����� �� ����� ������
          if ((Cursor1.Left-56) div 24)+1 = 40 then
          begin
            TestInProgress := false;
            RenderNextRow();
            TestInProgress := true;
          end
          else
          begin
            // ���������� ������
            Cursor1.Left := Cursor1.Left + 24;

            // ������� ����� ������� ����� �����������
            // ����� ��� ������� ������� ������������ ��� ������� ����� ������
            aTime[High(aTime)][((Cursor1.Left-56) div 24)+1] := GetTickCount;
          end;
          AllowMoveCursor := False; // ������ �� ����������� ������� ���������� �������
          Exit;
        end;
     VK_SPACE : begin
                  if aClicks[High(aClicks)][((Cursor1.Left-56) div 24)+1] = 0 then
                      aClicks[High(aClicks)][((Cursor1.Left-56) div 24)+1] := GetTickCount;
                  Exit;
                end;

    End; // case

  end
  else
    if ((Key = 13) and (CurrTaskNumber=0)) then ShowStartScreen;

end;


procedure TForm1.FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
    if Key = VK_RIGHT then AllowMoveCursor := True;
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
//  var point, pointSet: TPoint;
begin
 {
 begin
   point := Form1.ScreenToClient(MyMouse.CursorPos);

   if  point.X > maxX then
   begin
     // ���� ������ ������ ������ ���� ������� - ������ ���������� �� �� ������������
     if Length(aX[High(aX)]) = 0 then
     begin
      //ShowMessage('haha! 0!');
      //
      SetLength(aLetters, Length(aLetters)-1);
      SetLength(aSignal, Length(aSignal)-1);
      SetLength(aClicks, Length(aClicks)-1);
      SetLength(aTime, Length(aTime)-1);
      SetLength(aX, Length(aX)-1);
      SetLength(aY, Length(aY)-1);

      dec(CurrRowNumber);
     end;
     TestInProgress := false;
     RenderNextRow();
     TestInProgress := true;
   end
   else
   begin
     AllowMoveHandle := false; // ����� SetCursorPos �� ������� ���������� MouseMove
     pointSet.X := oldX;
     pointSet.Y := oldY;
     pointSet:= Form1.ClientToScreen(pointSet);

     SetCursorPos (pointSet.x, pointSet.y);
   end;
}



end;

procedure TForm1.Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 // ����� ������� �� ������
{ if (TestInProgress) then
 begin
 if Length(aX[High(aX)]) = 0 then
   ShowMessage('haha! 0!');
   TestInProgress := false;
   RenderNextRow();
   TestInProgress := true;
 end;
 }
end;

// ���������� �� ����������� ��������� ������ �����
// x, y - ������������ �����
function TForm1.GetLetterIndexByCoords(x:integer):integer;
  var point: TPoint;
begin
  point.X := 0;
  point.y := 0;
  point:= l1.ClientToScreen(point);
  point:= Form1.ScreenToClient(point); // ���������� ������ �������� ���� 1-� ����� ������������ �����
  x := x - point.X;
  Result := (x Div 24)+1;

//  label6.caption := inttostr((x Div 24)+1)+ ' - ' + inttostr(x);

end;

procedure TForm1.l1Click(Sender: TObject);
begin
// if TestInProgress then
//   if aClicks[High(aClicks)][StrToInt(copy((Sender as TLabel).Name, 2, 2))] = 0 then
//     aClicks[High(aClicks)][StrToInt(copy((Sender as TLabel).Name, 2, 2))] := GetTickCount;
end;

procedure TForm1.Label6MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
//  var point: Tpoint;      pointSet: Tpoint;
begin
{
  if AllowMoveHandle and TestInProgress then
  begin

    point := Form1.ScreenToClient(MyMouse.CursorPos);

    if ((point.x>=oldX) and (point.y>=minY) and (point.y<=maxY)) then //and (point.X<=maxX)) then
    begin
      oldX := point.x;
      oldY := point.y;

      SetLength(aTime[High(aTime)], Length(aTime[High(aTime)])+1);
      SetLength(aX[High(aX)], Length(aX[High(aX)])+1);
      SetLength(aY[High(aY)], Length(aY[High(aY)])+1);
      aTime[High(aTime)][High(aTime[High(aTime)])] := GetTickCount;
      aX[High(aX)][High(aX[High(aX)])] := point.x;
      aY[High(aY)][High(aY[High(aY)])] := point.y;

    end
    else
      if (point.x<oldX) then
        begin
          AllowMoveHandle := false; // ����� SetCursorPos �� ������� ���������� MouseMove
          pointSet.X := oldX;
          pointSet.Y := point.y;
          pointSet:= Form1.ClientToScreen(pointSet);
          SetCursorPos (pointSet.x, pointSet.y);
        end
        else
          if (point.y<minY) then
          begin
            // c ������� ������� ���� ����� ������ �� ������ �� �������
            AllowMoveHandle := false; // ����� SetCursorPos �� ������� ���������� MouseMove
            pointSet.X := oldX;
            pointSet.Y := minY;
            pointSet:= Form1.ClientToScreen(pointSet);
            SetCursorPos (pointSet.x, pointSet.y);
          end
          else
            begin
              // c ������� ������� ���� ����� ������ �� ������ �� �������
              AllowMoveHandle := false; // ����� SetCursorPos �� ������� ���������� MouseMove
              pointSet.X := oldX;
              pointSet.Y := maxY;
              pointSet:= Form1.ClientToScreen(pointSet);
              SetCursorPos (pointSet.x, pointSet.y);
            end;

  end
  else AllowMoveHandle := true;
         }

end;

function TForm1.MyRegReadInteger(dwRootKey: DWord;
  const Key, Param: String): Integer;
var
  Res: Integer;
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := dwRootKey;
  Reg.OpenKey(Key, True);
  try
    Res := Reg.ReadInteger(Param);
  except
    Res := 0;
  end;
  Reg.Free;
  Result := Res;
end;

procedure TForm1.MyRegWriteInteger(dwRootKey: DWord;
  const Key, Param: String; Val:Integer);
var
  Reg: TRegistry;
begin
  Reg := TRegistry.Create;
  Reg.RootKey := dwRootKey;
  Reg.OpenKey(Key, True);
  Reg.WriteInteger(Param, Val);
  Reg.Free;
end;


procedure TForm1.WMNCLBUTTONDOWN(var Msg: TWMNCLButtonDown) ;
begin
  if Msg.HitTest = HTHELP then
    Msg.Result := 0 // "eat" the message
  else
    inherited;
end;

procedure TForm1.WMNCLBUTTONUP(var Msg: TWMNCLButtonUp) ;
begin
  if Msg.HitTest = HTHELP then
  begin
    Msg.Result := 0;
    ShowMessage('��� v'+Version+#13#10+
      '����� ������� (� ������������ �� ����� ������): '+inttostr(TasksCount)+#13#10+
      '����������������� ������ �������: '+inttostr(Round(Timer1.Interval/1000))+' ������'+#13#10+
      #13#10+
      '(C) ��������� �������, 2013-2014'+#13#10+
      'e-mail: tralmail@gmail.com'
      ) ;
  end
  else
    inherited;
end;

end.

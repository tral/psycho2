unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls;

const
 TasksCount = 6; // сколько всего заданий (в сумме, обоих типов)
 Intervals  = 4; // Сколько всего временных отрезков для аналитики (раньше было 5, в последнем ТЗ стало 4, т.к. длительность 4 минуты)

type
 TMatrix =  array [1..TasksCount] of array [1..Intervals] of Double;
 TMatrixI = array [1..TasksCount] of array [1..Intervals] of Integer;

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
    btn1: TButton;
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



  private
    { Private declarations }
  public
    { Public declarations }
  end;

  const Version = '1.01';
  const Title = 'КОМПЬЮТЕРНАЯ ПРОГРАММА «ВНИМАНИЕ» (КПВ)';

var
  Form1: TForm1;
  MyMouse: TMouse;
  oldX, oldY, minY, maxY, maxX : Integer;
  AllowMoveHandle: boolean;
  TestInProgress: boolean;
  IsTestTask: Boolean; // Идет ли тестовое задание?

  // в разрезе строк (первый индекс - строка)
  aTime : Array of Array [1..40] of Int64; // метки времени

  aX : Array of array of Integer; // координата x курсора
  aY : Array of array of Integer; // координата y курсора
  aClicks : Array of array [1..40] of int64; // клики юзера (0 или метка времени)
  aLetters : Array of Array [1..40] of string; // лог букв (там сами буквы)
  aSignal : Array of array [1..40] of boolean; // карта сигнальных букв (True/False)

  currLetters : array [1..40] of String; // текущие буквы
  nextLetters : array [1..40] of String; // строка-превью (3-я)
  tmpLetters : array [1..40] of String; // временная строка для обмена строк
  CurrSignalLetter : string; // Текущая сигнальная буква
  CurrPrefix : string; // Текущий префикс

  EmptyStringsInARow : byte; // число сгенерированных строк без сигнальной буквы подряд
  CurrRowNumber : Integer; // текущая строка задания (порядковый номер)
  CurrTaskNumber : integer; // номер текущего задания от 1 до 8
  TestType : byte; // тип теста 1 или 2
  TaskStartTime, TaskFinishTime : int64; // время старта и окончания задания

  user_name : string;
  user_gender:byte;
  user_age: string;

  // Аналитика (первый индекс - номер задания, второй - минута)
  T : array [1..TasksCount] of Double; // пункт 1
  KB : TMatrixI; // пункт 2
  PZ : TMatrixI; // пункт 3
  OZ : TMatrixI; // пункт 4
  ONZ : TMatrixI; // пункт 5
  KPZ : TMatrix; // пункт 6 PZ/KB
  KOZ : TMatrix; // пункт 7 OZ/KB
  KONZ : TMatrix; // пункт 8 ONZ/KB
  OZPZ : TMatrix; // пункт 9 OZ/PZ
  ONZPZ : TMatrix; // пункт 10 ONZ/PZ
  KO : TMatrix; // пункт 11 OZ+ONZ
  KT : TMatrix; // пункт 12 (PZ-OZ)/(PZ+ONZ)
  SDK : TMatrix; // пункт 13
  SDK1P : TMatrix; // пункт 14
  SDK1O : TMatrix; // пункт 15
  SDK2  : TMatrix; // пункт 16
  SDK3P : TMatrix; // пункт 17
  SDK3O : TMatrix; // пункт 18
  const aGl : array[1..8] of String = ('А', 'Е', 'И', 'О', 'У', 'Э', 'Ю', 'Я');
  const aSo : array[1..19] of String = ('Б', 'В', 'Г', 'Д', 'Ж', 'З', 'К', 'Л', 'М', 'Н', 'П', 'Р', 'С', 'Т', 'Ф', 'Х', 'Ц', 'Ч', 'Ш');
  const aAll : array[1..27] of String = ('А', 'Е', 'И', 'О', 'У', 'Э', 'Ю', 'Я', 'Б', 'В', 'Г', 'Д', 'Ж', 'З', 'К', 'Л', 'М', 'Н', 'П', 'Р', 'С', 'Т', 'Ф', 'Х', 'Ц', 'Ч', 'Ш');


implementation

uses ToolUnit, Analytics, UAuthForm;

{$R *.dfm}

procedure TForm1.PrepareToStartTask();
begin
  // Обнулим все оперативные динамические массивы
  SetLength(aTime, 0);
  SetLength(aX, 0);
  SetLength(aY, 0);
  SetLength(aClicks, 0);
  SetLength(aLetters, 0);
  SetLength(aSignal, 0);

  CurrRowNumber := 0;
  EmptyStringsInARow := 0;
  LettersVisibility (true);  //
  TestInProgress := true; //
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

procedure TForm1.FinishTask();
begin
  Timer1.Enabled := false;
  LettersVisibility (false);
  TestInProgress := false;
  AllowMoveHandle := true;
  TaskFinishTime := GetTickCount;

  if (NOT IsTestTask) then
  begin

    Analytics.CountTask();

    if CurrTaskNumber=8 then
      Analytics.ToCSV() //!!! усреднение

  end;

    Form2.NextStep();
    Form2.ShowModal();

end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  btn1.Hide;
  Label9.Hide;
  Label10.Hide;

  CurrStep := 'personal';


  // DEBUG!!! DEL
  CurrStep := 'next_test_info'; // !!!
  Form2.NextStep;// !!!



  Form2.ShowModal;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
//  StartTask();
end;

procedure TForm1.Button2Click(Sender: TObject);
var i,j,k : integer;
begin
  // Test 1
  for I := 1 to 1000000 do
  begin
      k:= Random(6);
      ToolUnit.GenerateStringForTest2('А', k, 'ЮЮЮ');
       for j := 1 to 40 do
        if currLetters[j]='' then begin
        showmessage('gotcha!');
        end;

      ToolUnit.GenerateStringForTest1('А', k);
      for j := 1 to 40 do
        if currLetters[j]='' then begin
        showmessage('gotcha!');
        end;
  end;

end;

procedure TForm1.RenderNextRow();
//  var point: Tpoint;
begin

  if (  IsTestTask ) then
  begin
   if (CurrRowNumber = 2) then
   begin
     FinishTask();
     Exit;
   end
   else Form1.ShiftRows(CurrSignalLetter, CurrPrefix, CurrRowNumber+2);

  end
  else Form1.ShiftRows(CurrSignalLetter, CurrPrefix, -1);

  // Устанавливаем курсов в начало строки
  Cursor1.Left := 56;

  // Запишем метку времени установки курсора на первый символ
  aTime[High(aTime)][1] := GetTickCount;

{
  point.X := 0;
  point.y := 0;
  point:= l1.ClientToScreen(point);
  AllowMoveHandle := false; // чтобы не учитывать последующее перемещение курсора
  SetCursorPos (point.x,  point.y+12); // поставим на середину буквы по вертикали
  point:= Form1.ScreenToClient(point);
  oldX := point.x; // относительно формы
  oldY := point.y;

  minY := point.y;
  maxY := point.y + l1.Height -1;
  maxX := point.x + 24*40; // Эта координата нужна для контроля ситуации, когда зажали кнопку мыши и ломимся вправо

}

end;


// Сдвигает строки
procedure TForm1.ShiftRows(signalLetter, prefix:string; sgnCnt:integer);
var
  i:integer;
begin
  // Увеличиваем на 1 размерность служебных массивов
  SetLength(aLetters, Length(aLetters)+1);
  SetLength(aSignal, Length(aSignal)+1);
  SetLength(aClicks, Length(aClicks)+1);
  SetLength(aTime, Length(aTime)+1);
//  SetLength(aX, Length(aX)+1);
//  SetLength(aY, Length(aY)+1);

  inc(CurrRowNumber); // порядковый номер текущей строки в задании



  // Случай генерации самой первой строки задания
  if ((nextLetters[1]='') and (nextLetters[32]='') and (nextLetters[40]='')) then
  begin
    Form1.RowGenerator(signalLetter, prefix, sgnCnt);
    for i := 1 to 40 do nextLetters[i] := currLetters[i];
  end
  else
  begin
    for i:=1 to 40 do (FindComponent('l'+inttostr(i)+'_') as TLabel).Caption := currLetters[i];
  end;

  Form1.RowGenerator(signalLetter, prefix, sgnCnt); // следующая через одну
  for i := 1 to 40 do tmpLetters[i] := currLetters[i];
  for i := 1 to 40 do currLetters[i] := nextLetters[i];
  for i := 1 to 40 do nextLetters[i] := tmpLetters[i];

  for i:=1 to 40 do
  begin
    (FindComponent('l'+inttostr(i)+'__') as TLabel).Caption := nextLetters[i];
    (FindComponent('l'+inttostr(i)) as TLabel).Caption := currLetters[i];
       //  if aSignal[High(aSignal)][i] then (c as TLabel).Color := clGreen
       //                             else (c as TLabel).Color := clWhite;
  end;


  // заполняем служебные массивы
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




end;


// Заполняет строку currLetters
procedure TForm1.RowGenerator(signalLetter, prefix:string; sgnCnt:integer);
begin

  // Не более 2-х строк без сигнальной буквы подряд,
  // в 1-й строке должна быть хотя бы одна сигнальная буква
  repeat

    if sgnCnt <= 0 then sgnCnt:= Random(6); // от 0 до 5

    if TestType = 1 then
      ToolUnit.GenerateStringForTest1(signalLetter, sgnCnt)
    else
    begin
      // Может так совпасть, что появится случайным образом сигнальная комбинация: префикс+буква,
      // тогда перегенерим строку, иначе с большой вероятностью нарушится правило 6 символов между сигнальными буквами
      repeat
        ToolUnit.GenerateStringForTest2(signalLetter, sgnCnt, prefix);
      until signalLettersCount(signalLetter, prefix) <= sgnCnt; // Не может быть сгенерено БОЛЬШЕ сигнальных букв, чем запрошено!

    end;

    // Проверим есть ли хотя бы одна сигнальная буква в сгенерированной строке
    if ToolUnit.isWithoutSignal(signalLetter, prefix) then inc(EmptyStringsInARow)
                                                      else EmptyStringsInARow := 0;

  until ((EmptyStringsInARow <= 2) and (CurrRowNumber<>1)) or ((CurrRowNumber=1) and (ToolUnit.isWithoutSignal(signalLetter, prefix) = False));




end;

// показывает и скрывает буквы с курсором
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
begin

  LettersVisibility (false);
  TestInProgress := false;
  CurrTaskNumber := 0;
//   TestType := 1; определяется рандомно от задания к заданию
  multiplier := Round(Form1.Timer1.Interval/Intervals); // отрезок времени в миллисекундах, которых Intervals, в сумме равны длине одного задания (по ТЗ 60000)

  Form1.Caption := Title + ' v.' + Version;


end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

 if Key = VK_RIGHT then
   if TestInProgress then
   begin
//     SetLength(aTime[High(aTime)], Length(aTime[High(aTime)])+1);

     // SetLength(aX[High(aX)], Length(aX[High(aX)])+1);

     // Если дошли до конца строки
     if ((Cursor1.Left-56) div 24)+1 = 40 then
     begin
       TestInProgress := false;
       RenderNextRow();
       TestInProgress := true;
     end
     else
     begin
       // переместим курсор
       Cursor1.Left := Cursor1.Left + 24;

       // Запишем метку времени этого перемещения
       // Метка для первого символа записывается при рендере новой строки
       aTime[High(aTime)][((Cursor1.Left-56) div 24)+1] := GetTickCount;
     end;


     //aX[High(aX)][High(aX[High(aX)])] := point.x;
     //aY[High(aY)][High(aY[High(aY)])] := point.y;
   end;



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
     // Если кривая пустая строка была прошлая - просто выкидываем ее из рассмотрения
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
     AllowMoveHandle := false; // Чтобы SetCursorPos не вызывал обработчик MouseMove
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
 // финиш прохода по строке
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

// Определяет по координатам указателя индекс буквы
// x, y - относительно формы
function TForm1.GetLetterIndexByCoords(x:integer):integer;
  var point: TPoint;
begin
  point.X := 0;
  point.y := 0;
  point:= l1.ClientToScreen(point);
  point:= Form1.ScreenToClient(point); // координаты левого верхнего угла 1-й буквы относительно формы
  x := x - point.X;
  Result := (x Div 24)+1;

//  label6.caption := inttostr((x Div 24)+1)+ ' - ' + inttostr(x);

end;

procedure TForm1.l1Click(Sender: TObject);
begin

 if TestInProgress then
   if aClicks[High(aClicks)][StrToInt(copy((Sender as TLabel).Name, 2, 2))] = 0 then
     aClicks[High(aClicks)][StrToInt(copy((Sender as TLabel).Name, 2, 2))] := GetTickCount;
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
          AllowMoveHandle := false; // Чтобы SetCursorPos не вызывал обработчик MouseMove
          pointSet.X := oldX;
          pointSet.Y := point.y;
          pointSet:= Form1.ClientToScreen(pointSet);
          SetCursorPos (pointSet.x, pointSet.y);
        end
        else
          if (point.y<minY) then
          begin
            // c зажатой кнопкой мыши чтобы курсор за предел не выходил
            AllowMoveHandle := false; // Чтобы SetCursorPos не вызывал обработчик MouseMove
            pointSet.X := oldX;
            pointSet.Y := minY;
            pointSet:= Form1.ClientToScreen(pointSet);
            SetCursorPos (pointSet.x, pointSet.y);
          end
          else
            begin
              // c зажатой кнопкой мыши чтобы курсор за предел не выходил
              AllowMoveHandle := false; // Чтобы SetCursorPos не вызывал обработчик MouseMove
              pointSet.X := oldX;
              pointSet.Y := maxY;
              pointSet:= Form1.ClientToScreen(pointSet);
              SetCursorPos (pointSet.x, pointSet.y);
            end;

  end
  else AllowMoveHandle := true;
         }

end;





end.

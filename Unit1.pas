unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Buttons, ExtCtrls, StdCtrls;

type
 TMatrix =  array [1..8] of array [1..5] of Double;
 TMatrixI = array [1..8] of array [1..5] of Integer;

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
    procedure PrepareToStartTask();
    procedure StartTask();
    procedure StartTestTask();
    procedure FinishTask();
    procedure LettersVisibility(flag:boolean);
    procedure RenderNextRow();
    function GetLetterIndexByCoords(x:integer):integer;
    procedure RowGenerator(signalLetter, prefix:string; sgnCnt:integer);

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



  private
    { Private declarations }
  public
    { Public declarations }
  end;

  const Version = '1.0';
  const Title = 'КОМПЬЮТЕРНАЯ ПРОГРАММА «ВНИМАНИЕ» (КПВ)';

var
  Form1: TForm1;
  MyMouse: TMouse;
  oldX, oldY, minY, maxY, maxX : Integer;
  AllowMoveHandle:boolean;
  TestInProgress:boolean;
  IsTestTask : Boolean; // Идет ли тестовое задание?

  // в разрезе строк (первый индекс - строка)
  aTime : Array of Array of Int64; // метки времени
  aX : Array of array of Integer; // координата x курсора
  aY : Array of array of Integer; // координата y курсора
  aClicks : Array of array [1..40] of int64; // клики юзера (0 или метка времени)
  aLetters : Array of Array [1..40] of string; // лог букв (там сами буквы)
  aSignal : Array of array [1..40] of boolean; // карта сигнальных букв (True/False)

  currLetters : array [1..40] of String; // текущие буквы
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
  T : array [1..8] of Double; // пункт 1
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
  Form2.ShowModal;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
//  StartTask();
end;

procedure TForm1.RenderNextRow();
  var point: Tpoint;
begin

  if (  IsTestTask ) then
  begin
   if (CurrRowNumber = 2) then
   begin
     FinishTask();
     Exit;
   end
   else Form1.RowGenerator(CurrSignalLetter, CurrPrefix, CurrRowNumber+2);

  end
  else Form1.RowGenerator(CurrSignalLetter, CurrPrefix, -1);

  point.X := 0;
  point.y := 0;
  point:= l1.ClientToScreen(point);
  AllowMoveHandle := false; // чтобы не учитывать последующее перемещение курсора
  SetCursorPos (point.x,  point.y+12); // поставим на середину буквы по вертикали
  point:= Form1.ScreenToClient(point);
  oldX := point.x; // относительно формы
  oldY := point.y;
//  label4.caption := 'oldX: ' + inttostr(oldX);
 // label5.caption := 'oldY: ' + inttostr(oldY);

  minY := point.y;
  maxY := point.y + l1.Height -1;
  maxX := point.x + 24*40; // Эта координата нужна для контроля ситуации, когда зажали кнопку мыши и ломимся вправо
//  label2.caption := 'minY: ' + inttostr(minY) + ', maxY: ' + inttostr(maxY);


end;




procedure TForm1.RowGenerator(signalLetter, prefix:string; sgnCnt:integer);
var i : integer;
    c : TComponent;
begin

  // Увеличиваем на 1 размерность служебных массивов
  SetLength(aLetters, Length(aLetters)+1);
  SetLength(aSignal, Length(aSignal)+1);
  SetLength(aClicks, Length(aClicks)+1);
  SetLength(aTime, Length(aTime)+1);
  SetLength(aX, Length(aX)+1);
  SetLength(aY, Length(aY)+1);

  inc(CurrRowNumber); // порядковый номер текущей строки в задании

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


  // Переносим сгенерированные буквы на VCL-компоненты
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

      c:= FindComponent('l'+inttostr(i));
      if c <> nil then
        begin
          (c as TLabel).Caption := currLetters[i];
        //  if aSignal[High(aSignal)][i] then (c as TLabel).Color := clGreen
          //                             else (c as TLabel).Color := clWhite;
        end;
  end;

end;

procedure TForm1.LettersVisibility(flag:boolean);
  var i: integer;
      c: TComponent;
begin
  for i:=1 to 40 do
  begin
    c:= FindComponent('l'+inttostr(i));
    if c <> nil then
        (c as TLabel).Visible := flag;
  end;
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
  TestType := 1;
  multiplier := Round(Form1.Timer1.Interval/5); // отрезок времени в миллисекундах, которых 5, в сумме равны длине одного задания (по ТЗ 60000)

  Form1.Caption := Title + ' v.' + Version;


end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
  var point, pointSet: TPoint;
begin
 if TestInProgress then
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


 end;

end;

procedure TForm1.Label1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
 // финиш прохода по строке
 if (TestInProgress) then
 begin
 if Length(aX[High(aX)]) = 0 then
   ShowMessage('haha! 0!');
   TestInProgress := false;
   RenderNextRow();
   TestInProgress := true;
 end;
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
  var point: Tpoint;
      pointSet: Tpoint;
begin

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

 //     Label4.Caption:='oldX: '+inttostr(oldX);
//      label5.caption := 'oldY: ' + inttostr(oldY);
  //    Label3.Caption := 'form_Х: ' + inttostr(point.x) + ' form_Y: ' +  inttostr(point.y);

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


end;





end.

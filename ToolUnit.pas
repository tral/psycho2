unit ToolUnit;

interface
  function CountPos(const subtext: string; Text: string): Integer;
  function GenerateStringForTest1(signalLetter: String; cnt: integer) : String;
  function GenerateStringForTest2(signalLetter: String; cnt: integer;prefix:string) : String;
  function InsertLetter(Letter: String; d1,d2:integer) : integer;
  function inArrayG(s:string) : boolean;
  function inArrayS(s:string) : boolean;
  procedure SurroundByLetters1(signalLetter:string; idx:integer);
  procedure SurroundByLetters2(signalLetter:string; idx:integer; prefix: String);
  function RandomLetterG(exclusion:string):string;
  function RandomLetterS(exclusion:string):string;
  function RandomLetter(exclusion:string):string;
  function isWithoutSignal(signalLetter, prefix:string):boolean;
  function signalLettersCount(signalLetter, prefix : string):integer;

implementation

uses Unit1, SysUtils;


// ���������� ��������� ��������� � ������
function CountPos(const subtext: string; Text: string): Integer;
begin
  if (Length(subtext) = 0) or (Length(Text) = 0) or (Pos(subtext, Text) = 0) then
    Result := 0
  else
    Result := (Length(Text) - Length(StringReplace(Text, subtext, '', [rfReplaceAll]))) div
      Length(subtext);
end;

// �������� �������� ����� � ������, ���� ������ ��� - ������ 0
function InsertLetter(Letter: String; d1,d2:integer) : integer;
  var i, idx: integer;
      foundPlace: boolean;
begin

  // ���� �� ���� ���� ���������?
  foundPlace := false;
  for i := d1 to 40 do
    if currLetters[i] = '' then
      begin
       foundPlace := true;
       break;
      end;

  // ���� ���� ���� ��������� - �������� ���� �� �������
  if foundPlace = False then
  begin
//    if idx=0 then raise Exception.Create('�� ���� �������� ���������� �����!');
    Result := 0;
    Exit;
  end;

  repeat
    idx := d1 + Random(d2);
  until (currLetters[idx] = '');

  currLetters[idx] := Letter;

  Result := idx;

end;

// ������� ����� ���������� ���� (���������� ���������� ��� ����� 2) � ������
function signalLettersCount(signalLetter, prefix : string):integer;
var i : integer;
    tmpstr : string;
begin
  for i := 1 to 40 do
    tmpstr := tmpstr + currLetters[i];

  Result := CountPos(prefix+signalLetter, tmpstr);

end;

// ������ True, ���� � ������ ��� �� ����� ���������� �����. ����� - False
function isWithoutSignal(signalLetter, prefix : string):boolean;
var i : integer;
    tmpstr : string;
begin
   for i := 1 to 40 do
    tmpstr := tmpstr + currLetters[i];

   if Pos(prefix+signalLetter, tmpstr) > 0 then Result := False
                                           else Result := True;
end;

function GenerateStringForTest1(signalLetter: String; cnt: integer) :String;
  var i, idx: integer;
begin

  for i := 1 to 40 do
    currLetters[i] := '';

  for i := 1 to cnt do
    begin

       idx := InsertLetter(signalLetter,1,40);

       // ���� ��� ������ ���������
       if idx=0 then Exit;

       // ������� ���������� ����� ������� �������
       SurroundByLetters1(signalLetter, idx);

    end; // for

  // �������� ������ ���������� �������, ���� �������� ��������� �����
  for i := 1 to 40 do
    if currLetters[i] = '' then currLetters[i] := RandomLetter(signalLetter);

end;

function GenerateStringForTest2(signalLetter: String; cnt: integer; prefix:string) :String;
  var i, idx: integer;
begin

  for i := 1 to 40 do
    currLetters[i] := '';

  for i := 1 to cnt do
    begin

       idx := InsertLetter(signalLetter, 4, 37); // � 4-� �� 40-� ������� ��� 4, 37

       // ���� ��� ������ ���������
       if idx=0 then Exit;

       // ������� ���������� ����� ������� �������
       SurroundByLetters2(signalLetter, idx, prefix);

    end; // for

  // �������� ������ ���������� �������, ���� �������� ��������� �����
  for i := 1 to 40 do
    if currLetters[i] = '' then currLetters[i] := RandomLetter(''); // ����� ����������! �.�. ��� ���������� ������ ���� � ���������!

end;

function RandomLetterS(exclusion:string):string;
  var idx: integer;
begin

   repeat
     idx := 1 + Random(19);
   until (aSo[idx]<>exclusion);

   Result := aSo[idx];

end;

function RandomLetterG(exclusion:string):string;
  var idx: integer;
begin

   repeat
     idx := 1 + Random(8);
   until (aGl[idx]<>exclusion);

   Result := aGl[idx];

end;

function RandomLetter(exclusion:string):string;
  var idx: integer;
begin

   repeat
     idx := 1 + Random(27);
   until (aAll[idx]<>exclusion);

   Result := aAll[idx];

end;

procedure SurroundByLetters1(signalLetter:string; idx:integer);
  var d1, d2, u1, u2, i : integer;
begin

   d1 := idx - 6;
   d2 := idx - 1;
   if d1<1 then d1:=1;
   if d2<1 then d2:=1;

   u1 := idx + 1;
   u2 := idx + 6;
   if u1>40 then u1:=40;
   if u2>40 then u2:=40;

   for i := d1 to d2 do
     if currLetters[i] = '' then currLetters[i] := RandomLetter(signalLetter);

   for i := u1 to u2 do
     if currLetters[i] = '' then currLetters[i] := RandomLetter(signalLetter);

end;

procedure SurroundByLetters2(signalLetter:string; idx:integer; prefix: String);
  var d1, d2, u1, u2, i : integer;
begin


  // �������� �������������� ���������� ����� ��� ����� (prefix)
  if idx >= 4 then
   begin
     currLetters[idx-1] := prefix[3];
     currLetters[idx-2] := prefix[2];
     currLetters[idx-3] := prefix[1];
   end;

   d1 := idx - 6;
   d2 := idx - 4;
   if d1<1 then d1:=1;
   if d2<1 then d2:=1;

   u1 := idx + 1;
   u2 := idx + 6;
   if u1>40 then u1:=40;
   if u2>40 then u2:=40;

   for i := d1 to d2 do
     if currLetters[i] = '' then currLetters[i] := RandomLetter(''); // ����� ����������! �.�. ��� ���������� ������ ���� � ���������!

   for i := u1 to u2 do
     if currLetters[i] = '' then currLetters[i] := RandomLetter(''); // ����� ����������! �.�. ��� ���������� ������ ���� � ���������!

end;

function inArrayG(s:string) : boolean;
var i:integer;
begin
  for i := 1 to 8 do
    if aGl[i] = s then
    begin
      Result := true;
      Exit;
    end;
  Result := false;
end;

function inArrayS(s:string) : boolean;
var i:integer;
begin
  for i := 1 to 19 do
    if aSo[i] = s then
    begin
      Result := true;
      Exit;
    end;
  Result := false;
end;

end.

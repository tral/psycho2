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
       if idx=0 then Break;

       // ������� ���������� ����� ������� �������
       SurroundByLetters1(signalLetter, idx);

    end; // for

  // �������� ������ ���������� �������, ���� �������� ��������� �����
  for i := 1 to 40 do
    if currLetters[i] = '' then currLetters[i] := RandomLetter(signalLetter);

end;


// ������� �������� ��������� ��� ����� 2
procedure InsertFakePrefix(cnt: integer; signalLetter, prefix:String);
var i, j, idx: integer;
    tmp: array [1..40] of String;
    isInserted : boolean;
begin

    for i := 1 to 40 do tmp[i] := '';

    // ���� ���� �� �������� ����� ���� �������� �������
    for i := 1 to 40 do
    begin

      if (i>=3) then // ���� ��� �������� 1 �������� �������
        begin
          if (currLetters[i]=prefix[3]) and (currLetters[i-1]=prefix[2]) and (currLetters[i-2]=prefix[1]) then
          begin
            tmp[i] := prefix[3];
            tmp[i-1] := prefix[2];
            tmp[i-2] := prefix[1];
          end;
        end;

      if (i>=4) then
        begin
          if (currLetters[i]=signalLetter) and (currLetters[i-1]=prefix[3]) and (currLetters[i-2]=prefix[2]) and (currLetters[i-3]=prefix[1]) then
          begin
            tmp[i] := currLetters[i];
            tmp[i-1] := currLetters[i-1];
            tmp[i-2] := currLetters[i-2];
            tmp[i-3] := currLetters[i-3];
          end;
        end;

    end;

    // �������� ������ tmp � ������� ������� ���� ����� �������� ����� (� �� �������, ��� ������ �����)
    // ��! ������ ���� �� ����� 3-� ������ ���� ������!
    // � ������ ���� ���� ����� - �������� �� ������� �������� ��������� ���, ���� �� ��������� - �� ��� � ����, �� ����� ���������
    j := 0;
    isInserted := False;

    repeat
      inc(j);
      idx := 1 + Random(38); // �� 1 �� 38 (��������� ����������� ��������: � ������� 38-39-40)

      if ((tmp[idx]='') and (tmp[idx+1]='') and (tmp[idx+2]='')) then
      begin
        isInserted := True;
        currLetters[idx] := prefix[1];
        currLetters[idx+1] := prefix[2];
        currLetters[idx+2] := prefix[3];
      end;

    until (j > 100) or isInserted;

end;

function GenerateStringForTest2(signalLetter: String; cnt: integer; prefix:string) :String;
  var i, idx, fakeCnt: integer;
begin

  for i := 1 to 40 do
    currLetters[i] := '';

  for i := 1 to cnt do
    begin

       idx := InsertLetter(signalLetter, 4, 37); // � 4-� �� 40-� ������� ��� 4, 37

       // ���� ��� ������ ���������
       if idx=0 then Break;

       // ������� ���������� ����� ������� �������
       SurroundByLetters2(signalLetter, idx, prefix);

    end; // for

  // �������� ������ ���������� �������, ���� �������� ��������� �����
  for i := 1 to 40 do
    if currLetters[i] = '' then currLetters[i] := RandomLetter(''); // ����� ����������! �.�. ��� ���������� ������ ���� � ���������!

  // ������ ����� ������� - ���-�� �������� ������ ��������:
  // ���� ���������� � ������ 0, �� ������ ������������ - ������������� 0,1,2
  // ���� ���������� � ������ 1,  �� ������ ������������ - ������������� 0,1,2
  // ���� ���������� � ������ 2, �� ������ ������������ - ������������� 0,1
  // ���� ���������� � ������ 3, �� ������ ������������ - ������������� 0,1
  // ���� ���������� � ������ 4 � �����, �� ������ ������������ - 0
  fakeCnt := -1;
  if ((cnt = 3) or (cnt = 2)) then fakeCnt := Random(2); // 0 ��� 1 ��.
  if ((cnt = 0) or (cnt = 1)) then fakeCnt := Random(3); // 0, 1 ��� 2 ��.

  // ��, �����������, ���-�� ������ ������, ���� ���� �������� 1 ��� 2 �����
  if fakeCnt > 0 then
    for i := 1 to fakeCnt do InsertFakePrefix(cnt, signalLetter, prefix);

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

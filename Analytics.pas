unit Analytics;

interface

type
  // TMatrix =  array [1..8] of array [1..5] of Double;
  TVector = array [1 .. 6] of Double;

procedure ToCSV();
function LinesCount(const Filename: string): Integer;
function GetFormrowFirstX(): Integer;
function GetFormrowLastX(): Integer;
function findAfterNearestCoordinat(row, index: Integer): Integer;
function findONNearestCoordinat(row, index: Integer): Integer;
function findCenterNearestCoordinat(row, index: Integer): Integer;
function findNearestCoordinatToCoordinat(row, x: Integer): Integer;
function findRowCoordinatTime(row, idx: Integer): Integer;
function findRowCoordinatX(row, idx: Integer): Integer;
function findRowCoordinatY(row, idx: Integer): Integer;
function getFirstSignalIndex(row: Integer): Integer;
procedure fillTargetLetters(row, s, f: Integer);
procedure CountTask();
procedure indT();
procedure indKB();
procedure indPZ();
procedure indOZ();
procedure indONZ();
procedure indKPZ(); // PZ/KB
procedure indKOZ(); // OZ/KB
procedure indKONZ(); // ONZ/KB
procedure indOZPZ();
procedure indONZPZ();
procedure indKO();
procedure indKT();
procedure indSDK();
procedure indSDK1P();
procedure indSDK1O();
procedure indSDK2();
procedure indSDK3P();

var
  targetLetters: array of Integer;
  avgSpeeds: array [1 .. 5] of array of Double;
  multiplier : Integer;
  // ������� �������� �� �������
  // var tmpTime: array of int64;
  // tmpX, tmpY : array of integer;



implementation

uses Unit1, SysUtils, Windows, Dialogs, Forms;

// indicator T
procedure indT();
begin
  Try
    T[CurrTaskNumber] := aTime[0][0] / 1000; // �.�. ����� ������� ��� �������. � ��������
  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;
end;

function getFirstSignalIndex(row: Integer): Integer;
var
  i, res: Integer;
begin

  res := -1;
  for i := 1 to 40 do
    if (aSignal[row][i]) then
    begin
      res := i;
      break;
    end;

  if res < 1 then
    raise Exception.Create
      ('getFirstSignalIndex �� ���� ����� ���������� �����!');
  Result := res;

end;

// ���������� ������ X ������ (������������ �����)
function GetFormrowFirstX(): Integer;
var
  point: TPoint;
begin
  point.x := 0;
  point.y := 0;
  point := Form1.l1.ClientToScreen(point);
  point := Form1.ScreenToClient(point); // ���������� ������ �������� ���� 1-� ����� ������������ �����
  Result := point.x;
end;

// ���������� ��������� X ������ (������������ �����)
function GetFormrowLastX(): Integer;
var
  point: TPoint;
begin
  point.x := 23;
  point.y := 0;
  point := Form1.l40.ClientToScreen(point);
  point := Form1.ScreenToClient(point); // ���������� ������� �������� ���� 40-� ����� ������������ �����
  Result := point.x;

  // point := form1.ClientToScreen(point);
  // SetCursorPos(point.X, point.Y)
end;

// indicator SDK
procedure indSDK();
var
  T, i, j: Integer;
  lastX, lastRow: Integer;
  firstX, firstRow: Integer;
  firstCoordIndex, firstSignalIndex: Integer;
  cnt: int64;
  firstTime, lastTime: int64;
  // _Z :string;
  // _p:integer;
begin

  Try

    for T := 1 to 5 do
    begin

      if T = 1 then
      begin
        firstRow := 0;
        // ������ ������ ������ ���������� ����� � 0-� ������ (����� ��� ������ ���� �� ��!)
        firstSignalIndex := getFirstSignalIndex(firstRow);
        // ������ ������ ����-����������, ��������� � 1-� ���������� ����� � ����� ������ ������
        firstCoordIndex := findONNearestCoordinat(firstRow, firstSignalIndex);
        firstTime := findRowCoordinatTime(firstRow, firstCoordIndex);
        // �����, �����-�� ���� ����������
        firstX := findRowCoordinatX(firstRow, firstCoordIndex);
        // X ���� ����������
      end
      else
      begin
        firstX := -1;
        firstRow := -1;
        firstTime := -1;
      end;

      lastX := -1;
      lastRow := -1;
      lastTime := -1;

      for i := 0 to High(aTime) do
        for j := 0 to High(aTime[i]) do
          if (aTime[i][j] >= (T - 1) * multiplier + 1) and
            (aTime[i][j] <= T * multiplier) then
          begin
            if (firstX < 0) and (T > 1) then // ��� t=1 ���������� ���
            begin
              firstX := aX[i][j];
              firstRow := i;
              firstTime := aTime[i][j];
            end;
            lastX := aX[i][j];
            lastRow := i;
            lastTime := aTime[i][j];
          end;

      //
      if (firstRow = lastRow) then
        cnt := lastX - firstX + 1
      else
        cnt := GetFormrowLastX() - firstX + lastX - GetFormrowFirstX() + 2 +
          (lastRow - firstRow - 1) * 24 * 40;

      if ((firstRow = -1) OR (lastRow = -1)) then
      begin
        ShowMessage(
          '��� ���������� �������� ������� ���������� �� ������ ������ ������ ������! ��������� ����� ���������, ���������� ������ ���� ��������!');
        Application.Terminate;
        Exit;
      end;

      // _Z := _Z + inttostr(cnt);
      // if (firstRow = lastRow) then _Z := _Z + '(=)'
      // else _Z := _Z + '(<>)';
      // _Z := _Z + ' | ';

      SDK[CurrTaskNumber][T] := cnt * 1000 / (lastTime - firstTime);
      // � �������/��������
    end;

    // showmessage( ' -> ' +  _Z);

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;

end;

// indicator KB
procedure indKB();
var
  T, i, j: Integer;
  lastX, lastRow: Integer;
  firstX, firstRow: Integer;
  cnt, tmpLRow, tmpLIndex: Integer;
  // _Z :string;
  // _p:integer;
begin

  Try

    tmpLRow := -1;
    tmpLIndex := -1;

    for T := 1 to 5 do
    begin

      firstX := -1;
      firstRow := -1;
      lastX := -1;
      lastRow := -1;

      for i := 0 to High(aTime) do
        for j := 0 to High(aTime[i]) do
          if (aTime[i][j] >= (T - 1) * multiplier + 1) and
            (aTime[i][j] <= T * multiplier) then
          begin
            if firstX < 0 then
            begin
              firstX := aX[i][j];
              firstRow := i;
            end;
            lastX := aX[i][j];
            lastRow := i;
          end;

      // �������� �� ���� ����� ��� ����� (����� ������ ������ ���������� ���������)
      if (firstRow = lastRow) then
        cnt := Form1.GetLetterIndexByCoords(lastX)
          - Form1.GetLetterIndexByCoords(firstX) + 1
      else
        cnt := 40 - Form1.GetLetterIndexByCoords(firstX)
          + 1 + Form1.GetLetterIndexByCoords(lastX) + (lastRow - firstRow - 1)
          * 40;

      // ������� �� ��������� �� ��������� ����� ������
      if ((tmpLRow = firstRow) AND (tmpLIndex = Form1.GetLetterIndexByCoords
            (firstX))) then
        dec(cnt);

      // ��������� ���������� ��������� �����
      tmpLRow := lastRow;
      tmpLIndex := Form1.GetLetterIndexByCoords(lastX);

      if ((firstRow = -1) OR (lastRow = -1)) then
      begin
        ShowMessage(
          '��� ���������� �������� ������� ���������� �� ������ ������ ������ ������! ��������� ����� ���������, ���������� ������ ���� ��������!');
        Application.Terminate;
        Exit;
      end;

      // _Z := _Z + inttostr(cnt);
      // if (firstRow = lastRow) then _Z := _Z + '(=)'
      // else _Z := _Z + '(<>)';
      // _Z := _Z + ' | ';

      KB[CurrTaskNumber][T] := cnt;
    end;

    // ����� ������������� ���� (�����)
    // _p := High(aTime)*40+ Form1.GetLetterIndexByCoords(aX[High(aX)][High(aX[High(aX)])], aY[High(aY)][High(aY[High(aY)])]);

    // showmessage(_Z + ' -> ' +  inttostr(_p));
    // i:=000;

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;

end;

// indicator PZ
procedure indPZ();
var
  T, i, j: Integer;
  cnt: Integer;
begin

  Try

    for T := 1 to 5 do
    begin

      cnt := 0;

      for i := 0 to High(aClicks) do
        for j := 1 to 40 do // !!!
          // ���� ����� ����� ������ � ������ ������
          if (aClicks[i][j] > 0) and
            (aClicks[i][j] >= (T - 1) * multiplier + 1) and
            (aClicks[i][j] <= T * multiplier) then
          begin
            if ((aSignal[i][j]) and (aClicks[i][j] > 0)) then
              inc(cnt);
          end;

      PZ[CurrTaskNumber][T] := cnt;

    end; // for t

    // ShowMessage(inttostr(PZ[CurrTaskNumber][1]) + '|' + inttostr
    // (PZ[CurrTaskNumber][2]) + '|' + inttostr(PZ[CurrTaskNumber][3])
    // + '|' + inttostr(PZ[CurrTaskNumber][4]) + '|' + inttostr
    // (PZ[CurrTaskNumber][5]));

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;

end;

// indicator KPZ
procedure indKPZ(); // PZ/KB
var
  T: byte;
begin
  Try
    for T := 1 to 5 do
      if (KB[CurrTaskNumber][T] = 0) then
      begin
        ShowMessage('���������� KB (��� t = ' + inttostr(T) +
            ') ����� ����! ��������� ����� ���������, ���������� ������ ���� ��������!');
        Application.Terminate;
        Exit;
      end
      else
        KPZ[CurrTaskNumber][T] := PZ[CurrTaskNumber][T] / KB[CurrTaskNumber][T];

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;
end;

// indicator KOZ
procedure indKOZ();
var
  T: byte;
begin
  Try
    for T := 1 to 5 do
      if (KB[CurrTaskNumber][T] = 0) then
      begin
        ShowMessage('���������� KB (��� t = ' + inttostr(T) +
            ') ����� ����! ��������� ����� ���������, ���������� ������ ���� ��������!');
        Application.Terminate;
        Exit;
      end
      else
        KOZ[CurrTaskNumber][T] := OZ[CurrTaskNumber][T] / KB[CurrTaskNumber][T];

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;
end;

// indicator KONZ
procedure indKONZ();
var
  T: byte;
begin
  Try
    for T := 1 to 5 do
      if (KB[CurrTaskNumber][T] = 0) then
      begin
        ShowMessage('���������� KB (��� t = ' + inttostr(T) +
            ') ����� ����! ��������� ����� ���������, ���������� ������ ���� ��������!');
        Application.Terminate;
        Exit;
      end
      else
        KONZ[CurrTaskNumber][T] := ONZ[CurrTaskNumber][T] / KB[CurrTaskNumber]
          [T];

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;
end;

// indicator OZPZ
procedure indOZPZ();
var
  T: byte;
begin
  try

    for T := 1 to 5 do
      if (PZ[CurrTaskNumber][T] = 0) then
        OZPZ[CurrTaskNumber][T] := -1
      else
        OZPZ[CurrTaskNumber][T] := OZ[CurrTaskNumber][T] / PZ[CurrTaskNumber]
          [T];

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;
end;

// indicator ONZPZ
procedure indONZPZ();
var
  T: byte;
begin
  try

    for T := 1 to 5 do
      if (PZ[CurrTaskNumber][T] = 0) then
        ONZPZ[CurrTaskNumber][T] := -1
      else
        ONZPZ[CurrTaskNumber][T] := ONZ[CurrTaskNumber][T] / PZ[CurrTaskNumber]
          [T];

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;
end;

// indicator KO
procedure indKO();
var
  T: byte;
begin
  try

    for T := 1 to 5 do
      KO[CurrTaskNumber][T] := OZ[CurrTaskNumber][T] + ONZ[CurrTaskNumber][T];

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;
end;

// indicator KT
procedure indKT();
var
  T: byte;
begin
  try

    for T := 1 to 5 do
      if (PZ[CurrTaskNumber][T] + ONZ[CurrTaskNumber][T] = 0) then
      begin
        ShowMessage('����� PZ+ONZ (��� t = ' + inttostr(T) +
            ') ����� ����! ��������� ����� ���������, ���������� ������ ���� ��������!');
        Application.Terminate;
        Exit;
      end
      else
        KT[CurrTaskNumber][T] :=
          (PZ[CurrTaskNumber][T] - OZ[CurrTaskNumber][T]) /
          (PZ[CurrTaskNumber][T] + ONZ[CurrTaskNumber][T]);

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;
end;

// indicator OZ
procedure indOZ();
var
  T, i, j: Integer;
  cnt: Integer;
begin

  Try

    for T := 1 to 5 do
    begin

      cnt := 0;

      for i := 0 to High(aClicks) do
        for j := 1 to 40 do // !!!
          // ���� ����� ����� ������ � ������ ������
          if (aClicks[i][j] > 0) and
            (aClicks[i][j] >= (T - 1) * multiplier + 1) and
            (aClicks[i][j] <= T * multiplier) then
          begin
            if ((aSignal[i][j] = False) and (aClicks[i][j] > 0)) then
              inc(cnt);
          end;

      OZ[CurrTaskNumber][T] := cnt;

    end; // for t

    // showmessage(inttostr( OZ[CurrTaskNumber][1])+'|' +inttostr( OZ[CurrTaskNumber][2])+'|'+inttostr( OZ[CurrTaskNumber][3])+'|'+inttostr( OZ[CurrTaskNumber][4])+'|'+inttostr( OZ[CurrTaskNumber][5])       );

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;

end;

// ������ �����-� ����� ������� �� ������ � ������� ����������
function findRowCoordinatTime(row, idx: Integer): Integer;
begin
  if idx > 0 then
    Result := aTime[row][idx]
  else
    Result := -1;
end;

// ������ X �� ������ � ������� ����������
function findRowCoordinatX(row, idx: Integer): Integer;
begin
  if idx > 0 then
    Result := aX[row][idx]
  else
    Result := -1;
end;

// ������ Y �� ������ � ������� ����������
function findRowCoordinatY(row, idx: Integer): Integer;
begin
  if idx > 0 then
    Result := aY[row][idx]
  else
    Result := -1;
end;

// ���� ��� ����� ������ ���������� �� ���� ������, ������� ����������� � �������� ��������� ����
function findAfterNearestCoordinat(row, index: Integer): Integer;
var
  point: TPoint;
  x, i, res, nearest: Integer;
begin
  if index < 1 then
    raise Exception.Create('findAfterNearestCoordinat index < 1!');

  // ��������� �������� ���������� �����
  point.x := 0;
  point.y := 0;
  point := Form1.l1.ClientToScreen(point);
  point := Form1.ScreenToClient(point); // ���������� ������ �������� ���� 1-� ����� ������������ �����
  x := point.x + index * 24; // ���������� ������� ������� ��������� �����

  if (Length(aX) < row + 1) then
    Result := -1
  else
  begin
    nearest := aX[row][ High(aX[row])];
    res := High(aX[row]);
    for i := High(aX[row]) downto 0 do
      if (aX[row][i] <= nearest) and (aX[row][i] >= x) then
      begin
        nearest := aX[row][i];
        res := i;
      end
      else
        break;

    Result := res;
  end;

end;

// ���� ��� ����� ������ ���������� �� ���� �����, ������� ����������� � �������� ��������� ����
function findONNearestCoordinat(row, index: Integer): Integer;
var
  point: TPoint;
  x, i, res, nearest: Integer;
begin
  if index < 1 then
    raise Exception.Create('findONNearestCoordinat index < 1!');

  // ��������� �������� ���������� �����
  point.x := 0;
  point.y := 0;
  point := Form1.l1.ClientToScreen(point);
  point := Form1.ScreenToClient(point); // ���������� ������ �������� ���� 1-� ����� ������������ �����
  x := point.x + (index - 1) * 24; // ���������� ������� ������� ���� �����

  if (Length(aX) < row + 1) then
    Result := -1
  else
  begin
    nearest := aX[row][ High(aX[row])];
    res := High(aX[row]);
    for i := High(aX[row]) downto 0 do
      if (aX[row][i] <= nearest) and (aX[row][i] >= x) then
      begin
        nearest := aX[row][i];
        res := i;
      end
      else
        break;

    Result := res;
  end;

end;

// ���� ��� ���������� ��������� ����������, ������� ����������� � �������� ��������� ����
// x - ���������� ������������ �����
function findNearestCoordinatToCoordinat(row, x: Integer): Integer;
var
  i, res, nearest: Integer;
begin

  nearest := aX[row][ High(aX[row])];
  res := High(aX[row]);
  for i := High(aX[row]) downto 0 do
    if (aX[row][i] <= nearest) and (aX[row][i] >= x) then
    begin
      nearest := aX[row][i];
      res := i;
    end
    else
      break;

  Result := res;

end;

// ���� ��� ����� ��������� ���������� � �������� ���� �����, ������� ����������� � �������� ��������� ����
function findCenterNearestCoordinat(row, index: Integer): Integer;
var
  point: TPoint;
  x, i, res, nearest: Integer;
begin
  if index < 1 then
    raise Exception.Create('findCenterNearestCoordinat index < 1!');

  // ��������� �������� ���������� �����
  point.x := 0;
  point.y := 0;
  point := Form1.l1.ClientToScreen(point);
  point := Form1.ScreenToClient(point); // ���������� ������ �������� ���� 1-� ����� ������������ �����
  x := point.x + (index - 1) * 24 + 11; // ���������� �������� ���� �����

  if (Length(aX) < row + 1) then
    Result := -1
  else
  begin
    nearest := aX[row][ High(aX[row])];
    res := High(aX[row]);
    for i := High(aX[row]) downto 0 do
      if (aX[row][i] <= nearest) and (aX[row][i] >= x) then
      begin
        nearest := aX[row][i];
        res := i;
      end
      else
        break;

    Result := res;
  end;

end;

// indicator ONZ
procedure indONZ();
var
  T, i, j: Integer;
  tmpTime: int64;
  rowMax, indexMax: Integer;
begin

  Try

    // for t := 1 to 5 do
    // begin
    // ��������� �� ����� ����� ����� ����
    rowMax := Length(aX) - 1;
    indexMax := Form1.GetLetterIndexByCoords(aX[rowMax][ High(aX[rowMax])]);

    // ���� �� ���� ���������� ������, ��� ������ ��������� ���� ��������� ���������� � �� ��� - �����
    for i := 0 to High(aSignal) do
      for j := 1 to 40 do // !!!
      begin

        if (i >= rowMax) and (j > indexMax) then
          break;

        //
        if (aSignal[i][j]) and (aClicks[i][j] = 0) then
        begin
          tmpTime := findRowCoordinatTime(i, findAfterNearestCoordinat(i, j));

          for T := 1 to 5 do
            if (tmpTime >= (T - 1) * multiplier + 1) and
              (tmpTime <= T * multiplier) then
              ONZ[CurrTaskNumber][T] := ONZ[CurrTaskNumber][T] + 1;
        end;
      end;

    // end; // for t

    // showmessage(inttostr( ONZ[CurrTaskNumber][1])+'|' +inttostr( ONZ[CurrTaskNumber][2])+'|'+inttostr( ONZ[CurrTaskNumber][3])+'|'+inttostr( ONZ[CurrTaskNumber][4])+'|'+inttostr( ONZ[CurrTaskNumber][5])       );

  except
    on E: Exception do
      ShowMessage('indONZ ' + E.ClassName +
          ' �������������� ������, � ���������� : ' + E.Message +
          '. �������� ������ ������ � ��������� ��� ������������');
  end;

end;

// �������� targetLetters ����������� ������� (������� � ������� s �� f ������������)
procedure fillTargetLetters(row, s, f: Integer);
var
  i: Integer;
begin
  for i := s to f do
    if aSignal[row][i] then
    begin
      SetLength(targetLetters, Length(targetLetters) + 1);
      targetLetters[ High(targetLetters)] := i;
    end;
end;

// indicator SDK1P
procedure indSDK1P();
var
  T, i, j, k, b, tmpIdx, coord1, coord2, time1, time2: Integer;
  firstX, lastX: Integer;
  sm: Double;
  delitel: Integer;
  // _Z :string;
  // _p:integer;
begin

  Try

    SetLength(targetLetters, 0);

    for T := 1 to 5 do
      SetLength(avgSpeeds[T], 0);

    for T := 1 to 5 do // �� ��������� �����������
    begin

      SetLength(avgSpeeds[T], 0); // ������������� �������� ���������������� ��������� � ������� ��������� �����������

      for i := 0 to High(aTime) do // �� ���� ������� ����-���������
      begin

        firstX := -1;
        lastX := -1;
        SetLength(targetLetters, 0);

        // ���� ���������� ����� � ������ ������, ������� �������� �� ��������� ����������
        // ������� ������ ����-����������, ������� �������� �� ��������� ����������

        for j := 0 to High(aTime[i]) do
          if (aTime[i][j] >= (T - 1) * multiplier + 1) and
            (aTime[i][j] <= T * multiplier) then
          begin
            if firstX < 0 then
              firstX := aX[i][j];
            lastX := aX[i][j];
          end;

        // ���� ����� ������ � ��������� ����-���������� � ���� ������, ���������� � ������ ��������� ����������
        // ��� ��������� �� ��� ������� ������ � ��������� ����� � ���� ������, ���������� � ������ ��������� ����������
        // �������� ������ targetLetters - � ��� ����� ������� ���� ���������� ���� ���� ������ ����� ���������
        if (firstX > 0) and (lastX > 0) then
          fillTargetLetters(i, Form1.GetLetterIndexByCoords(firstX),
            Form1.GetLetterIndexByCoords(lastX));

        // ���� ���������� ���� �� ����� 2, ���������� �������
        if Length(targetLetters) > 1 then
          for k := 0 to High(targetLetters) do
            // �� ���� ���������� ������ - ����������
            // ���� ���������� ����� ���� �������� � ��� �� ���������
            if (aClicks[i][targetLetters[k]] > 0) and
              (k <> High(targetLetters)) then
            begin
              tmpIdx := findCenterNearestCoordinat(i, targetLetters[k]);
              coord1 := findRowCoordinatX(i, tmpIdx); // ���������� ���������� �����, �� ������� ��������
              time1 := findRowCoordinatTime(i, tmpIdx);

              tmpIdx := findONNearestCoordinat(i, targetLetters[k + 1]);
              coord2 := findRowCoordinatX(i, tmpIdx);
              // ���������� ��������� ���������� �����

              // ��� ���� ���������  ������� �������� �� ������ 1/3 ����� ����������
              coord2 := round((coord2 - coord1) / 3) + coord1;
              // ��� ��������� ���������� ����� ������ 1/3-�

              // ����� ����� ��������� ����-���������� � ��������� coord2
              tmpIdx := findNearestCoordinatToCoordinat(i, coord2);
              coord2 := findRowCoordinatX(i, tmpIdx);
              time2 := findRowCoordinatTime(i, tmpIdx);

              // ������� ��������
              if (time2 - time1 > 0) then
              begin
                SetLength(avgSpeeds[T], Length(avgSpeeds[T]) + 1);
                avgSpeeds[T][ High(avgSpeeds[T])] := (coord2 - coord1) * 1000 /
                  (time2 - time1); // � ������/��������
              end;

            end; // if

      end; // for i

      // _Z := _Z + inttostr(cnt);
      // if (firstRow = lastRow) then _Z := _Z + '(=)'
      // else _Z := _Z + '(<>)';
      // _Z := _Z + ' | ';

      delitel := 0;
      sm := 0;
      for b := 0 to High(avgSpeeds[T]) do
      begin
        inc(delitel);
        sm := sm + avgSpeeds[T][b];
      end;

      if delitel > 0 then
        SDK1P[CurrTaskNumber][T] := sm / delitel
      else
        SDK1P[CurrTaskNumber][T] := -1;
    end; // for t

    // ����� ������������� ���� (�����)
    // _p := High(aTime)*40+ Form1.GetLetterIndexByCoords(aX[High(aX)][High(aX[High(aX)])], aY[High(aY)][High(aY[High(aY)])]);

    // showmessage(_Z + ' -> ' +  inttostr(_p));
    // i:=000;

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;

end;

// indicator SDK1O
procedure indSDK1O();
var
  T, i, j, k, b, tmpIdx, coord1, coord2, time1, time2: Integer;
  firstX, lastX: Integer;
  sm: Double;
  delitel: Integer;
  // _Z :string;
  // _p:integer;
begin

  Try

    SetLength(targetLetters, 0);

    for T := 1 to 5 do
      SetLength(avgSpeeds[T], 0);

    for T := 1 to 5 do // �� ��������� �����������
    begin

      SetLength(avgSpeeds[T], 0); // ������������� �������� ���������������� ��������� � ������� ��������� �����������

      for i := 0 to High(aTime) do // �� ���� ������� ����-���������
      begin

        firstX := -1;
        lastX := -1;
        SetLength(targetLetters, 0);

        // ���� ���������� ����� � ������ ������, ������� �������� �� ��������� ����������
        // ������� ������ ����-����������, ������� �������� �� ��������� ����������

        for j := 0 to High(aTime[i]) do
          if (aTime[i][j] >= (T - 1) * multiplier + 1) and
            (aTime[i][j] <= T * multiplier) then
          begin
            if firstX < 0 then
              firstX := aX[i][j];
            lastX := aX[i][j];
          end;

        // ���� ����� ������ � ��������� ����-���������� � ���� ������, ���������� � ������ ��������� ����������
        // ��� ��������� �� ��� ������� ������ � ��������� ����� � ���� ������, ���������� � ������ ��������� ����������
        // �������� ������ targetLetters - � ��� ����� ������� ���� ���������� ���� ���� ������ ����� ���������
        if (firstX > 0) and (lastX > 0) then
          fillTargetLetters(i, Form1.GetLetterIndexByCoords(firstX),
            Form1.GetLetterIndexByCoords(lastX));

        // ���� ���������� ���� �� ����� 2, ���������� �������
        if Length(targetLetters) > 1 then
          for k := 0 to High(targetLetters) do
            // �� ���� ���������� ������ - ����������
            // !!!       // ���� ���������� ����� �� ���� �������� � ��� �� ���������
            if (aClicks[i][targetLetters[k]] = 0) and
              (k <> High(targetLetters)) then
            begin
              tmpIdx := findCenterNearestCoordinat(i, targetLetters[k]);
              coord1 := findRowCoordinatX(i, tmpIdx); // ���������� ���������� �����, �� ������� �� ��������
              time1 := findRowCoordinatTime(i, tmpIdx);

              tmpIdx := findONNearestCoordinat(i, targetLetters[k + 1]);
              coord2 := findRowCoordinatX(i, tmpIdx);
              // ���������� ��������� ���������� �����

              // ��� ���� ���������  ������� �������� �� ������ 1/3 ����� ����������
              coord2 := round((coord2 - coord1) / 3) + coord1;
              // ��� ��������� ���������� ����� ������ 1/3-�

              // ����� ����� ��������� ����-���������� � ��������� coord2
              tmpIdx := findNearestCoordinatToCoordinat(i, coord2);
              coord2 := findRowCoordinatX(i, tmpIdx);
              time2 := findRowCoordinatTime(i, tmpIdx);

              // ������� ��������
              if (time2 - time1 > 0) then
              begin
                SetLength(avgSpeeds[T], Length(avgSpeeds[T]) + 1);
                avgSpeeds[T][ High(avgSpeeds[T])] := (coord2 - coord1) * 1000 /
                  (time2 - time1); // � ������/��������
              end;

            end; // if

      end; // for i

      // _Z := _Z + inttostr(cnt);
      // if (firstRow = lastRow) then _Z := _Z + '(=)'
      // else _Z := _Z + '(<>)';
      // _Z := _Z + ' | ';

      delitel := 0;
      sm := 0;
      for b := 0 to High(avgSpeeds[T]) do
      begin
        inc(delitel);
        sm := sm + avgSpeeds[T][b];
      end;

      if delitel > 0 then
        SDK1O[CurrTaskNumber][T] := sm / delitel
      else
        SDK1O[CurrTaskNumber][T] := -1;
    end; // for t

    // ����� ������������� ���� (�����)
    // _p := High(aTime)*40+ Form1.GetLetterIndexByCoords(aX[High(aX)][High(aX[High(aX)])], aY[High(aY)][High(aY[High(aY)])]);

    // showmessage(_Z + ' -> ' +  inttostr(_p));
    // i:=000;

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;

end;

// indicator SDK2
procedure indSDK2();
var
  T, i, j, k, b, tmpIdx, coord1, coord2, time1, time2, coord_t_1,
    coord_t_2: Integer;
  firstX, lastX: Integer;
  sm: Double;
  delitel: Integer;
  // _Z :string;
  // _p:integer;
begin

  Try

    SetLength(targetLetters, 0);

    for T := 1 to 5 do
      SetLength(avgSpeeds[T], 0);

    for T := 1 to 5 do // �� ��������� �����������
    begin

      SetLength(avgSpeeds[T], 0); // ������������� �������� ���������������� ��������� � ������� ��������� �����������

      for i := 0 to High(aTime) do // �� ���� ������� ����-���������
      begin

        firstX := -1;
        lastX := -1;
        SetLength(targetLetters, 0);

        // ���� ���������� ����� � ������ ������, ������� �������� �� ��������� ����������
        // ������� ������ ����-����������, ������� �������� �� ��������� ����������

        for j := 0 to High(aTime[i]) do
          if (aTime[i][j] >= (T - 1) * multiplier + 1) and
            (aTime[i][j] <= T * multiplier) then
          begin
            if firstX < 0 then
              firstX := aX[i][j];
            lastX := aX[i][j];
          end;

        // ���� ����� ������ � ��������� ����-���������� � ���� ������, ���������� � ������ ��������� ����������
        // ��� ��������� �� ��� ������� ������ � ��������� ����� � ���� ������, ���������� � ������ ��������� ����������
        // �������� ������ targetLetters - � ��� ����� ������� ���� ���������� ���� ���� ������ ����� ���������
        if (firstX > 0) and (lastX > 0) then
          fillTargetLetters(i, Form1.GetLetterIndexByCoords(firstX),
            Form1.GetLetterIndexByCoords(lastX));

        // ���� ���������� ���� �� ����� 2, ���������� �������
        if Length(targetLetters) > 1 then
          for k := 0 to High(targetLetters) do
            // �� ���� ���������� ������ - ����������
            // ���� ���������� ����� �� ���������
            if (k <> High(targetLetters)) then
            begin
              tmpIdx := findCenterNearestCoordinat(i, targetLetters[k]);
              coord1 := findRowCoordinatX(i, tmpIdx); // ���������� ���������� �����, �� ������� ��������

              // !!! (����� ���������� ����)
              tmpIdx := findCenterNearestCoordinat(i, targetLetters[k + 1]);
              coord2 := findRowCoordinatX(i, tmpIdx);
              // ���������� ��������� ���������� �����

              // ��� ���� ���������  ������� �������� �� 1/3 �� 2/3 ����� ����������
              coord_t_1 := round((coord2 - coord1) / 3) + coord1;
              // ��� ��������� ���������� ����� 1/3-�
              coord_t_2 := round((coord2 - coord1) * 2 / 3) + coord1;
              // ��� ��������� ���������� ����� 2/3-�

              // ����� ����� ��������� ����-���������� � ���������
              tmpIdx := findNearestCoordinatToCoordinat(i, coord_t_1);
              coord_t_1 := findRowCoordinatX(i, tmpIdx);
              time1 := findRowCoordinatTime(i, tmpIdx);
              tmpIdx := findNearestCoordinatToCoordinat(i, coord_t_2);
              coord_t_2 := findRowCoordinatX(i, tmpIdx);
              time2 := findRowCoordinatTime(i, tmpIdx);

              // ������� ��������
              if (time2 - time1 > 0) then
              begin
                SetLength(avgSpeeds[T], Length(avgSpeeds[T]) + 1);
                avgSpeeds[T][ High(avgSpeeds[T])] := (coord_t_2 - coord_t_1)
                  * 1000 / (time2 - time1); // � ������/��������
              end;

            end; // if

      end; // for i

      // _Z := _Z + inttostr(cnt);
      // if (firstRow = lastRow) then _Z := _Z + '(=)'
      // else _Z := _Z + '(<>)';
      // _Z := _Z + ' | ';

      delitel := 0;
      sm := 0;
      for b := 0 to High(avgSpeeds[T]) do
      begin
        inc(delitel);
        sm := sm + avgSpeeds[T][b];
      end;

      if delitel > 0 then
        SDK2[CurrTaskNumber][T] := sm / delitel
      else
        SDK2[CurrTaskNumber][T] := -1;
    end; // for t

    // ����� ������������� ���� (�����)
    // _p := High(aTime)*40+ Form1.GetLetterIndexByCoords(aX[High(aX)][High(aX[High(aX)])], aY[High(aY)][High(aY[High(aY)])]);

    // showmessage(_Z + ' -> ' +  inttostr(_p));
    // i:=000;

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;

end;

// indicator SDK3P
procedure indSDK3P();
var
  T, i, j, k, b, tmpIdx, coord1, coord2, time1, time2: Integer;
  firstX, lastX: Integer;
  sm: Double;
  delitel: Integer;
  // _Z :string;
  // _p:integer;
begin

  Try

    SetLength(targetLetters, 0);

    for T := 1 to 5 do
      SetLength(avgSpeeds[T], 0);

    for T := 1 to 5 do // �� ��������� �����������
    begin

      SetLength(avgSpeeds[T], 0); // ������������� �������� ���������������� ��������� � ������� ��������� �����������

      for i := 0 to High(aTime) do // �� ���� ������� ����-���������
      begin

        firstX := -1;
        lastX := -1;
        SetLength(targetLetters, 0);

        // ���� ���������� ����� � ������ ������, ������� �������� �� ��������� ����������
        // ������� ������ ����-����������, ������� �������� �� ��������� ����������

        for j := 0 to High(aTime[i]) do
          if (aTime[i][j] >= (T - 1) * multiplier + 1) and
            (aTime[i][j] <= T * multiplier) then
          begin
            if firstX < 0 then
              firstX := aX[i][j];
            lastX := aX[i][j];
          end;

        // ���� ����� ������ � ��������� ����-���������� � ���� ������, ���������� � ������ ��������� ����������
        // ��� ��������� �� ��� ������� ������ � ��������� ����� � ���� ������, ���������� � ������ ��������� ����������
        // �������� ������ targetLetters - � ��� ����� ������� ���� ���������� ���� ���� ������ ����� ���������
        if (firstX > 0) and (lastX > 0) then
          fillTargetLetters(i, Form1.GetLetterIndexByCoords(firstX),
            Form1.GetLetterIndexByCoords(lastX));

        // ���� ���������� ���� �� ����� 2, ���������� �������
        if Length(targetLetters) > 1 then
          // !!!
          for k := High(targetLetters) downto 0 do
            // �� ���� ���������� ������ - ����������
            // ���� ���������� ����� ���� �������� � ��� �� ������
            if (aClicks[i][targetLetters[k]] > 0) and (k <> 0) then
            begin
              tmpIdx := findCenterNearestCoordinat(i, targetLetters[k - 1]);
              coord1 := findRowCoordinatX(i, tmpIdx); // ���������� ���������� �����, �������������� ���, �� ������� ��������

              tmpIdx := findCenterNearestCoordinat(i, targetLetters[k]);
              coord2 := findRowCoordinatX(i, tmpIdx); // ���������� ���������� �����, �� ������� ��������
              time2 := findRowCoordinatTime(i, tmpIdx);

              // ��� ���� ���������  ������� �������� �� 1/3, ��������� � �����, �� ������� ��������
              coord1 := round((coord2 - coord1) * 2 / 3) + coord1;
              // ��� ��������� ���������� ����� 2/3-�

              // ����� ����� ��������� ����-���������� � ��������� coord1
              tmpIdx := findNearestCoordinatToCoordinat(i, coord1);
              coord1 := findRowCoordinatX(i, tmpIdx);
              time1 := findRowCoordinatTime(i, tmpIdx);

              // ������� ��������
              if (time2 - time1 > 0) then
              begin
                SetLength(avgSpeeds[T], Length(avgSpeeds[T]) + 1);
                avgSpeeds[T][ High(avgSpeeds[T])] := (coord2 - coord1) * 1000 /
                  (time2 - time1); // � ������/��������
              end;

            end; // if

      end; // for i

      // _Z := _Z + inttostr(cnt);
      // if (firstRow = lastRow) then _Z := _Z + '(=)'
      // else _Z := _Z + '(<>)';
      // _Z := _Z + ' | ';

      delitel := 0;
      sm := 0;
      for b := 0 to High(avgSpeeds[T]) do
      begin
        inc(delitel);
        sm := sm + avgSpeeds[T][b];
      end;

      if delitel > 0 then
        SDK3P[CurrTaskNumber][T] := sm / delitel
      else
        SDK3P[CurrTaskNumber][T] := -1;
    end; // for t

    // ����� ������������� ���� (�����)
    // _p := High(aTime)*40+ Form1.GetLetterIndexByCoords(aX[High(aX)][High(aX[High(aX)])], aY[High(aY)][High(aY[High(aY)])]);

    // showmessage(_Z + ' -> ' +  inttostr(_p));
    // i:=000;

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;

end;

// indicator SDK3O
procedure indSDK3O();
var
  T, i, j, k, b, tmpIdx, coord1, coord2, time1, time2: Integer;
  firstX, lastX: Integer;
  sm: Double;
  delitel: Integer;
  // _Z :string;
  // _p:integer;
begin

  Try

    SetLength(targetLetters, 0);

    for T := 1 to 5 do
      SetLength(avgSpeeds[T], 0);

    for T := 1 to 5 do // �� ��������� �����������
    begin

      SetLength(avgSpeeds[T], 0); // ������������� �������� ���������������� ��������� � ������� ��������� �����������

      for i := 0 to High(aTime) do // �� ���� ������� ����-���������
      begin

        firstX := -1;
        lastX := -1;
        SetLength(targetLetters, 0);

        // ���� ���������� ����� � ������ ������, ������� �������� �� ��������� ����������
        // ������� ������ ����-����������, ������� �������� �� ��������� ����������

        for j := 0 to High(aTime[i]) do
          if (aTime[i][j] >= (T - 1) * multiplier + 1) and
            (aTime[i][j] <= T * multiplier) then
          begin
            if firstX < 0 then
              firstX := aX[i][j];
            lastX := aX[i][j];
          end;

        // ���� ����� ������ � ��������� ����-���������� � ���� ������, ���������� � ������ ��������� ����������
        // ��� ��������� �� ��� ������� ������ � ��������� ����� � ���� ������, ���������� � ������ ��������� ����������
        // �������� ������ targetLetters - � ��� ����� ������� ���� ���������� ���� ���� ������ ����� ���������
        if (firstX > 0) and (lastX > 0) then
          fillTargetLetters(i, Form1.GetLetterIndexByCoords(firstX),
            Form1.GetLetterIndexByCoords(lastX));

        // ���� ���������� ���� �� ����� 2, ���������� �������
        if Length(targetLetters) > 1 then
          // !!!
          for k := High(targetLetters) downto 0 do
            // �� ���� ���������� ������ - ����������
            // ���� ���������� ����� �� ���� �������� � ��� �� ������
            if (aClicks[i][targetLetters[k]] = 0) and (k <> 0) then
            begin
              tmpIdx := findCenterNearestCoordinat(i, targetLetters[k - 1]);
              coord1 := findRowCoordinatX(i, tmpIdx); // ���������� ���������� �����, �������������� ���, �� ������� ��������

              tmpIdx := findCenterNearestCoordinat(i, targetLetters[k]);
              coord2 := findRowCoordinatX(i, tmpIdx); // ���������� ���������� �����, �� ������� ��������
              time2 := findRowCoordinatTime(i, tmpIdx);

              // ��� ���� ���������  ������� �������� �� 1/3, ��������� � �����, �� ������� ��������
              coord1 := round((coord2 - coord1) * 2 / 3) + coord1;
              // ��� ��������� ���������� ����� 2/3-�

              // ����� ����� ��������� ����-���������� � ��������� coord1
              tmpIdx := findNearestCoordinatToCoordinat(i, coord1);
              coord1 := findRowCoordinatX(i, tmpIdx);
              time1 := findRowCoordinatTime(i, tmpIdx);

              // ������� ��������
              if (time2 - time1 > 0) then
              begin
                SetLength(avgSpeeds[T], Length(avgSpeeds[T]) + 1);
                avgSpeeds[T][ High(avgSpeeds[T])] := (coord2 - coord1) * 1000 /
                  (time2 - time1); // � ������/��������
              end;

            end; // if

      end; // for i

      // _Z := _Z + inttostr(cnt);
      // if (firstRow = lastRow) then _Z := _Z + '(=)'
      // else _Z := _Z + '(<>)';
      // _Z := _Z + ' | ';

      delitel := 0;
      sm := 0;
      for b := 0 to High(avgSpeeds[T]) do
      begin
        inc(delitel);
        sm := sm + avgSpeeds[T][b];
      end;

      if delitel > 0 then
        SDK3O[CurrTaskNumber][T] := sm / delitel
      else
        SDK3O[CurrTaskNumber][T] := -1;
    end; // for t

    // ����� ������������� ���� (�����)
    // _p := High(aTime)*40+ Form1.GetLetterIndexByCoords(aX[High(aX)][High(aX[High(aX)])], aY[High(aY)][High(aY[High(aY)])]);

    // showmessage(_Z + ' -> ' +  inttostr(_p));
    // i:=000;

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;

end;

procedure CountTask();
var
  maxDimArr, i, j: Integer;
begin

  // �������� ������� �� �������
  if (Length(aTime[0]) = 0) OR (Length(aX[0]) = 0) OR (Length(aY[0]) = 0) then
  begin
    ShowMessage(
      '��� ���������� �������� ������� ���������� �� ���� �� ������� ������! ��������� ����� ���������, ���������� ������ ���� ��������!');
    Application.Terminate;
    Exit;
  end;

  // ��������� ����������� ��������
  maxDimArr := Length(aLetters);

  if maxDimArr < Length(aSignal) then
    maxDimArr := Length(aSignal);
  if maxDimArr < Length(aClicks) then
    maxDimArr := Length(aClicks);
  if maxDimArr < Length(aTime) then
    maxDimArr := Length(aTime);
  if maxDimArr < Length(aX) then
    maxDimArr := Length(aX);
  if maxDimArr < Length(aY) then
    maxDimArr := Length(aY);

  if Length(aLetters) < maxDimArr then
    ShowMessage('aLetters length problem! �������� ������������!');
  if Length(aSignal) < maxDimArr then
    ShowMessage('aSignal length problem! �������� ������������!');
  if Length(aClicks) < maxDimArr then
    ShowMessage('aClicks length problem! �������� ������������!');
  if Length(aTime) < maxDimArr then
    ShowMessage('aTime length problem! �������� ������������!');
  if Length(aX) < maxDimArr then
    ShowMessage('aX length problem! �������� ������������!');
  if Length(aY) < maxDimArr then
    ShowMessage('aY length problem! �������� ������������!');

  if (( High(aTime[ High(aTime)]) <> High(aX[ High(aX)])) OR
      ( High(aY[ High(aY)]) <> High(aX[ High(aX)])) OR
      ( High(aTime[ High(aTime)]) <> High(aY[ High(aY)]))) then
    ShowMessage('Triple aX, aY, aTime length problem! �������� ������������!');

  // ���� �� ������ ��� ������� �� ����� ������ � ���� �������� - � ������ ��������
  // ����� ������ ��������� - ���� ��� �������, ����� ������� �����������
  // ������� ��� �� � ������ ��������, ����� ��������� ���������� �����������
  if (Length(aX[ High(aX)]) = 0) then
  begin
    SetLength(aTime, Length(aTime) - 1);
    SetLength(aX, Length(aX) - 1);
    SetLength(aY, Length(aY) - 1);
    SetLength(aSignal, Length(aSignal) - 1);
    SetLength(aLetters, Length(aLetters) - 1);
    SetLength(aClicks, Length(aClicks) - 1);
  end;

  // �� ������ ���� �����, � ������� ��� �� ����� ����-����������
  for i := 0 to High(aX) do
    if (Length(aX[i]) = 0) then
    begin
      ShowMessage(
        '���������� ������ ��� ���������! ���� ���������� �����������! ��������� ����� ���������, ���������� ������ ���� ��������!');
      Application.Terminate;
      Exit;
    end;

  // �������� ����� ������� ���, ����� ������ ������� ���� �����
  for i := 0 to High(aTime) do
    for j := 0 to High(aTime[i]) do
      aTime[i][j] := aTime[i][j] - TaskStartTime;
  for i := 0 to High(aClicks) do
    for j := 1 to 40 do // !!! 1 to 40
      if (aClicks[i][j] > 0) then
        aClicks[i][j] := aClicks[i][j] - TaskStartTime;

  // T
  indT();
  // Form1.Label8.Caption := 'T: ' + inttostr(T[CurrTaskNumber]); // del

  // indicator KB
  indKB();

  // indicator PZ
  indPZ();

  // indicator OZ
  indOZ();

  // indicator ONZ
  indONZ();

  // indicator KPZ
  indKPZ();

  // indicator KOZ
  indKOZ();

  // indicator KONZ
  indKONZ();

  // indicator OZPZ
  indOZPZ();

  // indicator ONZPZ
  indONZPZ();

  // indicator KO
  indKO();

  // indicator KT
  indKT();

  // indicator SDK
  indSDK();

  // indicator SDK1P
  indSDK1P();

  // indicator SDK1O
  indSDK1O();

  // indicator SDK2
  indSDK2();

  // indicator SDK3P
  indSDK3P();

  // indicator SDK3O
  indSDK3O();

  {
    signalCorrect := 0;
    signalMiss := 0;
    signalWrong := 0;
    for i := 0 to High(aSignal) do
    begin

    if i <> High(aSignal) then
    lim1 := 40
    else
    begin
    // ��������� �� ����� ����� ����� ����
    lim1 := Form1.GetLetterIndexByCoords(aX[i][ High(aX[i])]);

    end;

    for j := 1 to lim1 do
    begin
    if ((aSignal[i][j]) and (aClicks[i][j] > 0)) then
    inc(signalCorrect);
    if ((aSignal[i][j]) and (aClicks[i][j] = 0)) then
    inc(signalMiss);
    if ((NOT aSignal[i][j]) and (aClicks[i][j] > 0)) then
    inc(signalWrong);
    end;
    end;
    Form1.Label7.Caption := '����� ���������� ������: ' + inttostr(signalCorrect)
    + ', ���������� ���������: ' + inttostr(signalMiss)
    + ', �������� �������: ' + inttostr(signalWrong);
    }

end;

function ArrayProccessingInteger(arr: TMatrixI; var fl: textfile;
  indName: string): TVector;
var
  m, ta: Integer;
  res: TVector;
begin

  for m := 1 to 6 do
    res[m] := 0;
  writeln(fl, '');
  writeln(fl, '');
  for ta := 1 to 8 do
    for m := 1 to 5 do
      res[m] := res[m] + arr[ta][m];
  for m := 1 to 5 do
    res[m] := res[m] / 8;
  for m := 1 to 5 do
    res[6] := res[6] + res[m];
  res[6] := res[6] / 5;

  write(fl, indName + ' �� �������: ');
  for ta := 1 to 8 do
  begin
    writeln(fl, '');
    write(fl, '������� ' + inttostr(ta) + ': ');
    for m := 1 to 5 do
      write(fl, inttostr(arr[ta][m]) + ' ');
  end;
  writeln(fl, '');
  write(fl, '�����������: ');
  for m := 1 to 6 do
  begin
    if m = 6 then
    begin
      writeln(fl, '');
      Write(fl, '�� 5 ����� � �����: ');
    end;
    if res[m] < 0 then
      write(fl, '�/� ')
    else
      write(fl, FormatFloat('######0.###', res[m]) + ' ');
  end;

  Result := res;

end;

function ArrayProccessingFloat(arr: TMatrix; var fl: textfile;
  indName: string): TVector;
var
  m, ta, dtmp: Integer;
  deli: array [1 .. 5] of byte;
  res: TVector;
begin

  for m := 1 to 6 do
    res[m] := 0;
  for m := 1 to 5 do
    deli[m] := 0;
  writeln(fl, '');
  writeln(fl, '');
  for ta := 1 to 8 do
    for m := 1 to 5 do
      if arr[ta][m] > -0.0001 then
      begin
        res[m] := res[m] + arr[ta][m];
        inc(deli[m]);
      end;
  // ������ �������� �� ������ ������ �� ��� �������
  for m := 1 to 5 do
    if deli[m] = 0 then
      res[m] := -1
    else
      res[m] := res[m] / deli[m];
  // ������ �������� �� ��� ������ �� ���� ��������
  dtmp := 0;
  for m := 1 to 5 do
    if res[m] > -0.0001 then
    begin
      inc(dtmp);
      res[6] := res[6] + res[m];
    end;
  if dtmp = 0 then
    res[6] := -1
  else
    res[6] := res[6] / dtmp;

  write(fl, indName + ' �� �������: ');
  for ta := 1 to 8 do
  begin
    writeln(fl, '');
    write(fl, '������� ' + inttostr(ta) + ': ');
    for m := 1 to 5 do
      if arr[ta][m] < 0 then
        write(fl, '�/� ')
      else
        write(fl, FormatFloat('######0.###', arr[ta][m]) + ' ');
  end;
  writeln(fl, '');
  write(fl, '�����������: ');
  for m := 1 to 6 do
  begin
    if m = 6 then
    begin
      writeln(fl, '');
      Write(fl, '�� 5 ����� � �����: ');
    end;
    if res[m] < 0 then
      write(fl, '�/� ')
    else
      write(fl, FormatFloat('######0.###', res[m]) + ' ');
  end;

  Result := res;

end;

function LinesCount(const Filename: string): Integer;
var
  HFile: THandle;
  FSize, WasRead, i: Cardinal;
  Buf: array [1 .. 4096] of byte;
begin
  Result := 0;
  HFile := CreateFile(Pchar(Filename), GENERIC_READ, FILE_SHARE_READ, nil,
    OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
  if HFile <> INVALID_HANDLE_VALUE then
  begin
    FSize := GetFileSize(HFile, nil);
    if FSize > 0 then
    begin
      inc(Result);
      ReadFile(HFile, Buf, 4096, WasRead, nil);
      repeat
        for i := WasRead downto 1 do
          if Buf[i] = 10 then
            inc(Result);
        ReadFile(HFile, Buf, 4096, WasRead, nil);
      until WasRead = 0;
    end;
  end;
  CloseHandle(HFile);
end;

procedure ToCSV();
var
  f, fl: textfile;
  ta: Integer;
  sumd: Double;
  rownum: Integer;
  _T: Double;
  _KB: TVector;
  _PZ: TVector;
  _OZ: TVector;
  _ONZ: TVector;
  _KPZ: TVector;
  _KOZ: TVector;
  _KONZ: TVector;
  _OZPZ: TVector;
  _ONZPZ: TVector;
  _KO: TVector;
  _KT: TVector;
  _SDK: TVector;
  _SDK1P: TVector;
  _SDK1O: TVector;
  _SDK2: TVector;
  _SDK3P: TVector;
  _SDK3O: TVector;
  CFile: THandle;
begin
  // today := Now;
  // AssignFile(f, ExtractfileDir(Application.ExeName) + '\' + FormatDateTime
  // ('yyyy_mm_dd_hh_nn_ss', today) + '_' + 'NAME' + '.csv');
  try

    AssignFile(f, ExtractfileDir(Application.ExeName) + '\' + 'results.csv');
    AssignFile(fl, ExtractfileDir(Application.ExeName) + '\' + 'last_log.txt');

    Rewrite(fl);

    if FileExists(ExtractfileDir(Application.ExeName) + '\' + 'results.csv')
      then
    begin
      CFile := CreateFile(Pchar(ExtractfileDir(Application.ExeName)
            + '\' + 'results.csv'), GENERIC_READ, FILE_SHARE_READ, nil,
        OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, 0);
      if CFile = INVALID_HANDLE_VALUE then
        ShowMessage(
          '�� ���� ������� ���� � ������������! ���� �� ������ ���� - �������� � ������� ������ ��, ����� ���������� �� ����������!');
      CloseHandle(CFile);
      rownum := LinesCount(ExtractfileDir(Application.ExeName)
          + '\' + 'results.csv') - 1;
      Append(f);
    end
    else
    begin
      rownum := 1;
      Rewrite(f);
      write(f, 'N;NAME;GEN;AGE;T;');
      write(f,
        'KB1;PZ1;OZ1;ONZ1;KPZ1;KOZ1;KONZ1;OZPZ1;ONZPZ1;KO1;KT1;SDK1;SDK1P1;SDK1O1;SDK21;SDK3P1;SDK3O1;');
      write(f,
        'KB2;PZ2;OZ2;ONZ2;KPZ2;KOZ2;KONZ2;OZPZ2;ONZPZ2;KO2;KT2;SDK2;SDK1P2;SDK1O2;SDK22;SDK3P2;SDK3O2;');
      write(f,
        'KB3;PZ3;OZ3;ONZ3;KPZ3;KOZ3;KONZ3;OZPZ3;ONZPZ3;KO3;KT3;SDK3;SDK1P3;SDK1O3;SDK23;SDK3P3;SDK3O3;');
      write(f,
        'KB4;PZ4;OZ4;ONZ4;KPZ4;KOZ4;KONZ4;OZPZ4;ONZPZ4;KO4;KT4;SDK4;SDK1P4;SDK1O4;SDK24;SDK3P4;SDK3O4;');
      write(f,
        'KB5;PZ5;OZ5;ONZ5;KPZ5;KOZ5;KONZ5;OZPZ5;ONZPZ5;KO5;KT5;SDK5;SDK1P5;SDK1O5;SDK25;SDK3P5;SDK3O5;');
      writeln(f,
        'KB;PZ;OZ;ONZ;KPZ;KOZ;KONZ;OZPZ;ONZPZ;KO;KT;SDK;SDK1P;SDK1O;SDK2;SDK3P;SDK3O;');
    end;

    write(f, inttostr(rownum) + ';' + user_name + ';' + inttostr(user_gender)
        + ';' + user_age + ';');

    // T
    sumd := 0;
    for ta := 1 to 8 do
      sumd := sumd + T[ta];
    _T := sumd / 8;
    write(fl, 'T �� ��������: ');
    for ta := 1 to 8 do
    begin
      writeln(fl, '');
      write(fl, '������� ' + inttostr(ta) + ': ' + FormatFloat('######0.###',
          T[ta]));
    end;
    writeln(fl, '');
    write(fl, '�����������: ' + FormatFloat('######0.###', _T));

    _KB := ArrayProccessingInteger(KB, fl, 'KB');
    _PZ := ArrayProccessingInteger(PZ, fl, 'PZ');
    _OZ := ArrayProccessingInteger(OZ, fl, 'OZ');
    _ONZ := ArrayProccessingInteger(ONZ, fl, 'ONZ');

    _KPZ := ArrayProccessingFloat(KPZ, fl, 'KPZ');
    _KOZ := ArrayProccessingFloat(KOZ, fl, 'KOZ');
    _KONZ := ArrayProccessingFloat(KONZ, fl, 'KONZ');
    _OZPZ := ArrayProccessingFloat(OZPZ, fl, 'OZPZ');
    _ONZPZ := ArrayProccessingFloat(ONZPZ, fl, 'ONZPZ');
    _KO := ArrayProccessingFloat(KO, fl, 'KO');
    _KT := ArrayProccessingFloat(KT, fl, 'KT');
    _SDK := ArrayProccessingFloat(SDK, fl, 'SDK');
    _SDK1P := ArrayProccessingFloat(SDK1P, fl, 'SDK1P');
    _SDK1O := ArrayProccessingFloat(SDK1O, fl, 'SDK1O');
    _SDK2 := ArrayProccessingFloat(SDK2, fl, 'SDK2');
    _SDK3P := ArrayProccessingFloat(SDK3P, fl, 'SDK3P');
    _SDK3O := ArrayProccessingFloat(SDK3O, fl, 'SDK3O');

    write(f, FormatFloat('######0.###', _T));
    write(f, ';');

    for ta := 1 to 6 do
    begin
      if _KB[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _KB[ta]));
      write(f, ';');
      if _PZ[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _PZ[ta]));
      write(f, ';');
      if _OZ[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _OZ[ta]));
      write(f, ';');
      if _ONZ[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _ONZ[ta]));
      write(f, ';');
      if _KPZ[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _KPZ[ta]));
      write(f, ';');
      if _KOZ[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _KOZ[ta]));
      write(f, ';');
      if _KONZ[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _KONZ[ta]));
      write(f, ';');
      if _OZPZ[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _OZPZ[ta]));
      write(f, ';');
      if _ONZPZ[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _ONZPZ[ta]));
      write(f, ';');
      if _KO[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _KO[ta]));
      write(f, ';');
      if _KT[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _KT[ta]));
      write(f, ';');
      if _SDK[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _SDK[ta]));
      write(f, ';');
      if _SDK1P[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _SDK1P[ta]));
      write(f, ';');
      if _SDK1O[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _SDK1O[ta]));
      write(f, ';');
      if _SDK2[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _SDK2[ta]));
      write(f, ';');
      if _SDK3P[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _SDK3P[ta]));
      write(f, ';');
      if _SDK3O[ta] > -0.0001 then
        write(f, FormatFloat('######0.###', _SDK3O[ta]));
      write(f, ';');
    end;
    writeln(f, '');

//    ShowMessage('�� ����� results.csv � last_log.txt � ���������� ���������!');
//    Application.Terminate;
//    Exit;

  finally
    closeFile(f);
    closeFile(fl);
  end;

end;

end.

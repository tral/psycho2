unit Analytics;

interface



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
procedure indSPP();
procedure indSPO();
procedure indSOP();
procedure indSOO();
procedure indSDK1O();
procedure indSDK2();
procedure indSDK3P();

var
  targetLetters: array of Integer;
  multiplier : Integer;

  // var tmpTime: array of int64;
  // tmpX, tmpY : array of integer;



implementation

uses Unit1, SysUtils, Windows, Dialogs, Forms;

var
  // ������� �������� �� �������
  avgSpeeds: array [1 .. Intervals] of array of Double;

type
  TVector = array [1 .. Intervals+1] of Double;

// indicator T
procedure indT();
begin
  Try
    T[CurrTaskNumber] := (aTime[0][2] - aTime[0][1]) / 1000; // �.�. ����� ������� ��� �������. � ��������
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
  firstSignalIndex: Integer;
  cnt: int64;
  firstTime, lastTime: int64;
  // _Z :string;
  // _p:integer;
begin

  Try

    for T := 1 to Intervals do
    begin

      if T = 1 then
      begin
        firstRow := 0;
        // ������ ������ ������ ���������� ����� � 0-� ������ (����� ��� ������ ���� �� ��!)
        firstSignalIndex := getFirstSignalIndex(firstRow);
        // ������ ������ ����-����������, ��������� � 1-� ���������� ����� � ����� ������ ������
//        firstCoordIndex := findONNearestCoordinat(firstRow, firstSignalIndex);
        // �����, �����-�� ������ ����-����������, ��������� � 1-� ���������� ����� � ����� ������ ������
        firstTime := aTime[firstRow][firstSignalIndex];
        // X ���� ����������
        firstX := firstSignalIndex;
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
        for j := 1 to 40 do
          if (aTime[i][j] >= (T - 1) * multiplier + 1) and
            (aTime[i][j] <= T * multiplier) then
          begin
            if (firstX < 0) and (T > 1) then // ��� t=1 ���������� ���
            begin
              firstX := j;
              firstRow := i;
              firstTime := aTime[i][j];
            end;
            lastX := j;
            lastRow := i;
            lastTime := aTime[i][j];
          end;

      // ������� ����
      if (firstRow = lastRow) then
        cnt := lastX - firstX + 1
      else
        cnt := 40 - firstX + 1 + lastX + (lastRow - firstRow - 1)  * 40;

      if ((firstRow = -1) OR (lastRow = -1)) then
      begin
        ShowMessage(
          '��� ���������� �������� ������� ���������� �� ������ ������ ������ ������! ���������� ���������� ����������! ��������� ����� ���������, ���������� ������ ���� ��������!');
        Application.Terminate;
        Exit;
      end;

      // _Z := _Z + inttostr(cnt);
      // if (firstRow = lastRow) then _Z := _Z + '(=)'
      // else _Z := _Z + '(<>)';
      // _Z := _Z + ' | ';

      if (lastTime - firstTime = 0)
        then SDK[CurrTaskNumber][T] := 0
        else SDK[CurrTaskNumber][T] := cnt * 60 * 1000 / (lastTime - firstTime); // ��������: ���� � ������

    end;

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

    for T := 1 to Intervals do
    begin

      firstX := -1;
      firstRow := -1;
      lastX := -1;
      lastRow := -1;

      for i := 0 to High(aTime) do
        for j := 1 to 40 do
          if (aTime[i][j] >= (T - 1) * multiplier + 1) and (aTime[i][j] <= T * multiplier) then
          begin
            if firstX < 0 then
            begin
              firstX := j; // ������ ������ � ������ firstRow, ������� �������� �� ��������� ��������
              firstRow := i;
            end;
            lastX := j;
            lastRow := i;
          end;

      // �������� �� ���� ����� ��� ����� (����� ������ ������ ���������� ���������)
      if (firstRow = lastRow) then
        cnt := lastX-firstX+1
      else
        cnt := 40 - firstX + 1 + lastX + (lastRow - firstRow - 1)  * 40;

      // ������� �� ��������� �� ��������� ����� ������
      if ((tmpLRow = firstRow) AND (tmpLIndex = firstX)) then dec(cnt);

      // ��������� ���������� ��������� �����
      tmpLRow := lastRow;
      tmpLIndex := lastX;

      if ((firstRow = -1) OR (lastRow = -1)) then
      begin
        ShowMessage(
          '��� ���������� �������� ������� ���������� �� ������ ������ ������ ������! ������� ����������� ����������! ��������� ����� ���������, ���������� ������ ���� ��������!');
        Application.Terminate;
        Exit;
      end;

      KB[CurrTaskNumber][T] := cnt;
    end;

    // ����� ������������� ���� (�����)
    // _p := High(aTime)*40+ Form1.GetLetterIndexByCoords(aX[High(aX)][High(aX[High(aX)])], aY[High(aY)][High(aY[High(aY)])]);

    // showmessage('!');
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

    for T := 1 to Intervals do
    begin

      cnt := 0;

      for i := 0 to High(aClicks) do
        for j := 1 to 40 do // !!!
          // ���� ����� ����� ������ � ������ ������
          if (aClicks[i][j] > 0) and
            (aClicks[i][j] >= (T - 1) * multiplier + 1) and (aClicks[i][j] <= T * multiplier) then
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
    for T := 1 to Intervals do
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
    for T := 1 to Intervals do
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
    for T := 1 to Intervals do
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

    for T := 1 to Intervals do
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

    for T := 1 to Intervals do
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

    for T := 1 to Intervals do
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

    for T := 1 to Intervals do
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

    for T := 1 to Intervals do
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

      // ��������� �� ����� ����� ����� ����
      indexMax := -1;
      rowMax := -1;
      for i := 0 to High(aTime) do
        for j := 1 to 40 do
          begin
            indexMax := j;
            rowMax := i;
          end;

      // ���� �� ���� ���������� ������, ��� ������ ��������� ���� ��������� ���������� � �� ��� - �����
      for i := 0 to High(aSignal) do
        for j := 1 to 40 do // !!!
        begin

          if (i >= rowMax) and (j > indexMax) then
            break;

          //
          if (aSignal[i][j]) and (aClicks[i][j] = 0) then
          begin

            // ���� ��� ��������� ����� �� ���� �������
            if (i >= rowMax) and (j = indexMax) then
            begin
              // �� �� ������� ��� ������� (������ �� ����� ������ ������ � ����� �����)
            end
            else
             begin
                // ����� ����� ����� ��������� ������� �� ��������� �����
                if j<40 then tmpTime := aTime[i][j+1]
                        else tmpTime := aTime[i+1][1];
                // ���������� � ����� ��������� �������� �������� ��� ������ (������� ���������� �����)
                for T := 1 to Intervals do
                  if (tmpTime >= (T - 1) * multiplier + 1) and
                    (tmpTime <= T * multiplier) then
                    ONZ[CurrTaskNumber][T] := ONZ[CurrTaskNumber][T] + 1;
             end;

          end;

        end; // for i j


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


    for T := 1 to Intervals do // �� ��������� �����������
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


// indicator SPP
procedure indSPP();
var
  T, i, j, k, b, time1, time2: Integer;
  firstX, lastX, delitel: Integer;
  sm: Double;
begin

  Try

    for T := 1 to Intervals do // �� ��������� �����������
    begin

      SetLength(avgSpeeds[T], 0); // ������������� �������� ���������������� ��������� � ������� ��������� �����������

      for i := 0 to High(aTime) do // �� ���� ������� ����-���������
      begin

        firstX := -1;
        lastX := -1;
        SetLength(targetLetters, 0);

        // ���� ���������� ����� � ������ ������, ������� �������� �� ��������� ����������

        for j := 1 to 40 do
          if (aTime[i][j] >= (T - 1) * multiplier + 1) and
            (aTime[i][j] <= T * multiplier) then
          begin
            if firstX < 0 then
              firstX := j;
            lastX := j;
          end;

        // ���� ����� ������ � ��������� ���������� ����� � ���� ������, ���������� � ������ ��������� ����������,
        // �������� ������ targetLetters - � ��� ����� ������� ���� ���������� ���� ���� ������ ����� ���������
        if (firstX > 0) and (lastX > 0) then fillTargetLetters(i, firstX, lastX);

        // ���� ���������� ���� �� ����� 2, ���������� �������
        if Length(targetLetters) > 1 then
          for k := 0 to High(targetLetters) do
            // �� ���� ���������� ������ - ����������
            // ���� ���������� ����� ���� �������� � ��� �� ���������
            if (aClicks[i][targetLetters[k]] > 0) and (k <> High(targetLetters)) then
            begin

              time1 := aClicks[i][targetLetters[k]]; // ����� ����� �� ���������� �����

              // ��������, ���� �� �������� ��������� ���������� �����
              // ����� ��� �������, �.�. ��������������� ���������� ����� �� �������� ��������� ���������� ������ � ������
              if (aClicks[i][targetLetters[k+1]] > 0) then
              begin
                time2 := aTime[i][targetLetters[k+1]]; // ����� ��������� ������� �� ��������� ���������� �����
                // ������� ��������
                if (time2 - time1 > 0) then
                begin
                  SetLength(avgSpeeds[T], Length(avgSpeeds[T]) + 1);
                  avgSpeeds[T][ High(avgSpeeds[T])] := (targetLetters[k+1] - targetLetters[k]-1) * 60 * 1000 /
                    (time2 - time1); // ����/������
                end;

              end;

            end; // if

      end; // for i


      delitel := 0;
      sm := 0;
      for b := 0 to High(avgSpeeds[T]) do
      begin
        inc(delitel);
        sm := sm + avgSpeeds[T][b];
      end;

      if delitel > 0 then
        SPP[CurrTaskNumber][T] := sm / delitel
      else
        SPP[CurrTaskNumber][T] := -1;
    end; // for t

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;

end;



// indicator SPO
procedure indSPO();
var
  T, i, j, k, b, time1, time2: Integer;
  firstX, lastX, delitel: Integer;
  sm: Double;
begin

  Try

    for T := 1 to Intervals do // �� ��������� �����������
    begin

      SetLength(avgSpeeds[T], 0); // ������������� �������� ���������������� ��������� � ������� ��������� �����������

      for i := 0 to High(aTime) do // �� ���� ������� ����-���������
      begin

        firstX := -1;
        lastX := -1;
        SetLength(targetLetters, 0);

        // ���� ���������� ����� � ������ ������, ������� �������� �� ��������� ����������

        for j := 1 to 40 do
          if (aTime[i][j] >= (T - 1) * multiplier + 1) and
            (aTime[i][j] <= T * multiplier) then
          begin
            if firstX < 0 then
              firstX := j;
            lastX := j;
          end;

        // ���� ����� ������ � ��������� ���������� ����� � ���� ������, ���������� � ������ ��������� ����������,
        // �������� ������ targetLetters - � ��� ����� ������� ���� ���������� ���� ���� ������ ����� ���������
        if (firstX > 0) and (lastX > 0) then fillTargetLetters(i, firstX, lastX);

        // ���� ���������� ���� �� ����� 2, ���������� �������
        if Length(targetLetters) > 1 then
          for k := 0 to High(targetLetters) do
            // �� ���� ���������� ������ - ����������
            // ���� ���������� ����� ���� �������� � ��� �� ���������
            if (aClicks[i][targetLetters[k]] > 0) and (k <> High(targetLetters)) then
            begin

              time1 := aClicks[i][targetLetters[k]]; // ����� ����� �� ���������� �����

              // ��������, ���� �� �������� ��������� ���������� �����
              // ����� ��� �������, �.�. ��������������� ���������� ����� �� �������� ��������� ���������� ������ � ������
              // ��� ��� ���� �����������
              if (aClicks[i][targetLetters[k+1]] = 0) then
              begin
                time2 := aTime[i][targetLetters[k+1]]; // ����� ��������� ������� �� ��������� ���������� �����
                // ������� ��������
                if (time2 - time1 > 0) then
                begin
                  SetLength(avgSpeeds[T], Length(avgSpeeds[T]) + 1);
                  avgSpeeds[T][ High(avgSpeeds[T])] := (targetLetters[k+1] - targetLetters[k] - 1) * 60 * 1000 /
                    (time2 - time1); // ����/������
                end;

              end;

            end; // if

      end; // for i


      delitel := 0;
      sm := 0;
      for b := 0 to High(avgSpeeds[T]) do
      begin
        inc(delitel);
        sm := sm + avgSpeeds[T][b];
      end;

      if delitel > 0 then
        SPO[CurrTaskNumber][T] := sm / delitel
      else
        SPO[CurrTaskNumber][T] := -1;
    end; // for t

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;

end;



// indicator SOP
procedure indSOP();
var
  T, i, j, k, b, time1, time2: Integer;
  firstX, lastX, delitel: Integer;
  sm: Double;
begin

  Try

    for T := 1 to Intervals do // �� ��������� �����������
    begin

      SetLength(avgSpeeds[T], 0); // ������������� �������� ���������������� ��������� � ������� ��������� �����������

      for i := 0 to High(aTime) do // �� ���� ������� ����-���������
      begin

        firstX := -1;
        lastX := -1;
        SetLength(targetLetters, 0);

        // ���� ���������� ����� � ������ ������, ������� �������� �� ��������� ����������

        for j := 1 to 40 do
          if (aTime[i][j] >= (T - 1) * multiplier + 1) and
            (aTime[i][j] <= T * multiplier) then
          begin
            if firstX < 0 then
              firstX := j;
            lastX := j;
          end;

        // ���� ����� ������ � ��������� ���������� ����� � ���� ������, ���������� � ������ ��������� ����������,
        // �������� ������ targetLetters - � ��� ����� ������� ���� ���������� ���� ���� ������ ����� ���������
        if (firstX > 0) and (lastX > 0) then fillTargetLetters(i, firstX, lastX);

        // ���� ���������� ���� �� ����� 2, ���������� �������
        if Length(targetLetters) > 1 then
          for k := 0 to High(targetLetters) do
            // �� ���� ���������� ������ - ����������
            // ���� ���������� ����� �� ���� �������� � ��� �� ���������
            if (aClicks[i][targetLetters[k]] = 0) and (k <> High(targetLetters)) then
            begin

              time1 := aTime[i][targetLetters[k]]; // ����� ��������� ������� �� ���������� �����

              // ��������, ���� �� �������� ��������� ���������� �����
              // ����� ��� �������, �.�. ��������������� ���������� ����� �� �������� ��������� ���������� ������ � ������
              if (aClicks[i][targetLetters[k+1]] > 0) then
              begin
                time2 := aTime[i][targetLetters[k+1]]; // ����� ��������� ������� �� ��������� ���������� �����
                // ������� ��������
                if (time2 - time1 > 0) then
                begin
                  SetLength(avgSpeeds[T], Length(avgSpeeds[T]) + 1);
                  avgSpeeds[T][ High(avgSpeeds[T])] := (targetLetters[k+1] - targetLetters[k]-1) * 60 * 1000 /
                    (time2 - time1); // ����/������
                end;

              end;

            end; // if

      end; // for i


      delitel := 0;
      sm := 0;
      for b := 0 to High(avgSpeeds[T]) do
      begin
        inc(delitel);
        sm := sm + avgSpeeds[T][b];
      end;

      if delitel > 0 then
        SOP[CurrTaskNumber][T] := sm / delitel
      else
        SOP[CurrTaskNumber][T] := -1;
    end; // for t

  except
    on E: Exception do
      ShowMessage(E.ClassName + ' �������������� ������, � ���������� : ' +
          E.Message + '. �������� ������ ������ � ��������� ��� ������������');
  end;

end;





// indicator SOO
procedure indSOO();
var
  T, i, j, k, b, time1, time2: Integer;
  firstX, lastX, delitel: Integer;
  sm: Double;
begin

  Try

    for T := 1 to Intervals do // �� ��������� �����������
    begin

      SetLength(avgSpeeds[T], 0); // ������������� �������� ���������������� ��������� � ������� ��������� �����������

      for i := 0 to High(aTime) do // �� ���� ������� ����-���������
      begin

        firstX := -1;
        lastX := -1;
        SetLength(targetLetters, 0);

        // ���� ���������� ����� � ������ ������, ������� �������� �� ��������� ����������

        for j := 1 to 40 do
          if (aTime[i][j] >= (T - 1) * multiplier + 1) and
            (aTime[i][j] <= T * multiplier) then
          begin
            if firstX < 0 then
              firstX := j;
            lastX := j;
          end;

        // ���� ����� ������ � ��������� ���������� ����� � ���� ������, ���������� � ������ ��������� ����������,
        // �������� ������ targetLetters - � ��� ����� ������� ���� ���������� ���� ���� ������ ����� ���������
        if (firstX > 0) and (lastX > 0) then fillTargetLetters(i, firstX, lastX);

        // ���� ���������� ���� �� ����� 2, ���������� �������
        if Length(targetLetters) > 1 then
          for k := 0 to High(targetLetters) do
            // �� ���� ���������� ������ - ����������
            // ���� ���������� ����� �� ���� �������� � ��� �� ���������
            if (aClicks[i][targetLetters[k]] = 0) and (k <> High(targetLetters)) then
            begin

              time1 := aTime[i][targetLetters[k]]; // ����� ��������� ������� �� ���������� �����

              // ��������, ���� �� �������� ��������� ���������� �����
              // ����� ��� �������, �.�. ��������������� ���������� ����� �� �������� ��������� ���������� ������ � ������
              // ��� ���� �����������
              if (aClicks[i][targetLetters[k+1]] = 0) then
              begin
                time2 := aTime[i][targetLetters[k+1]]; // ����� ��������� ������� �� ��������� ���������� �����
                // ������� ��������
                if (time2 - time1 > 0) then
                begin
                  SetLength(avgSpeeds[T], Length(avgSpeeds[T]) + 1);
                  avgSpeeds[T][ High(avgSpeeds[T])] := (targetLetters[k+1] - targetLetters[k]-1) * 60 * 1000 /
                    (time2 - time1); // ����/������
                end;

              end;

            end; // if

      end; // for i


      delitel := 0;
      sm := 0;
      for b := 0 to High(avgSpeeds[T]) do
      begin
        inc(delitel);
        sm := sm + avgSpeeds[T][b];
      end;

      if delitel > 0 then
        SOO[CurrTaskNumber][T] := sm / delitel
      else
        SOO[CurrTaskNumber][T] := -1;
    end; // for t

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

    for T := 1 to Intervals do
      SetLength(avgSpeeds[T], 0);

    for T := 1 to Intervals do // �� ��������� �����������
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

    for T := 1 to Intervals do
      SetLength(avgSpeeds[T], 0);

    for T := 1 to Intervals do // �� ��������� �����������
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

    for T := 1 to Intervals do
      SetLength(avgSpeeds[T], 0);

    for T := 1 to Intervals do // �� ��������� �����������
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

    for T := 1 to Intervals do
      SetLength(avgSpeeds[T], 0);

    for T := 1 to Intervals do // �� ��������� �����������
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


// ������� ������������� ���������� �� �������
procedure CountTask();
var
  maxDimArr, i, j: Integer;
begin

  // �������� ������� �� �������
  if (Length(aTime) < 2) then
  begin
    ShowMessage(
      '��� ���������� �������� ������� ���������� �� ���������� �� ����� ������! ��������� ����� ���������, ���������� ������ ���� ��������!');
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
//  if maxDimArr < Length(aX) then
//    maxDimArr := Length(aX);
//  if maxDimArr < Length(aY) then
//    maxDimArr := Length(aY);

  if Length(aLetters) < maxDimArr then
    ShowMessage('aLetters length problem! �������� ������������!');
  if Length(aSignal) < maxDimArr then
    ShowMessage('aSignal length problem! �������� ������������!');
  if Length(aClicks) < maxDimArr then
    ShowMessage('aClicks length problem! �������� ������������!');
  if Length(aTime) < maxDimArr then
    ShowMessage('aTime length problem! �������� ������������!');
//  if Length(aX) < maxDimArr then
//    ShowMessage('aX length problem! �������� ������������!');
//  if Length(aY) < maxDimArr then
//    ShowMessage('aY length problem! �������� ������������!');

//  if (( High(aTime[ High(aTime)]) <> High(aX[ High(aX)])) OR
//      ( High(aY[ High(aY)]) <> High(aX[ High(aX)])) OR
//      ( High(aTime[ High(aTime)]) <> High(aY[ High(aY)]))) then
//    ShowMessage('Triple aX, aY, aTime length problem! �������� ������������!');

  // ���� �� ������ ��� ������� �� ����� ������ � ���� �������� - ������ ��� ��������� ������ �� ������������
  // ������� ��� �� � ������ ��������, ����� ��������� ���������� �����������
  // ��������� �� 2-�� ��������, �.�. 1-� ������� ����������� ������������� ��� ��������� ������
  if (aTime[ High(aTime)][2] = 0) then
  begin
    SetLength(aTime, Length(aTime) - 1);
    SetLength(aSignal, Length(aSignal) - 1);
    SetLength(aLetters, Length(aLetters) - 1);
    SetLength(aClicks, Length(aClicks) - 1);
    // SetLength(aX, Length(aX) - 1);
    // SetLength(aY, Length(aY) - 1);
  end;

  // �� ������ ���� �����, � ������� ��� �� ����� ����-����������
  for i := 0 to High(aTime) do
    if (aTime[i][2] = 0) then
    begin
      ShowMessage(
        '���������� ������ ��� ���������! ���� ���������� �����������! ��������� ����� ���������, ���������� ������ ���� ��������!');
      Application.Terminate;
      Exit;
    end;

  // �������� ����� ������� ���, ����� ������ ������� ���� �����
  for i := 0 to High(aTime) do
    for j := 1 to 40 do
      aTime[i][j] := aTime[i][j] - TaskStartTime;
  for i := 0 to High(aClicks) do
    for j := 1 to 40 do
      if (aClicks[i][j] > 0) then
        aClicks[i][j] := aClicks[i][j] - TaskStartTime;

  // T
  indT();


  // indicator KB
  indKB();

  // indicator PZ
  indPZ();

  // indicator OZ - �� ���� ������� KO
  indOZ();

  // indicator ONZ - �� ���� ������� KO
  indONZ();

  // indicator KO
  indKO();

  // indicator SDK
  indSDK();

   // indicator SPP
//  indSDK1P();
  indSPP();

  // indicator SPO
  indSPO();

  // indicator SOP
  indSOP();

  // indicator SOO
  indSOO();

{


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



  // indicator KT
  indKT();



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
}


end;



function ArrayProccessingInteger(arr: TMatrixI; var fl: textfile;
  indName: string): TVector;
var
  m, ta: Integer;
  res: TVector;

begin

  for m := 1 to Intervals+1 do
    res[m] := 0;

  writeln(fl, '');
  writeln(fl, '');

  for ta := 1 to TasksCount do
    for m := 1 to Intervals do
      res[m] := res[m] + arr[ta][m];

  for m := 1 to Intervals do
    res[m] := res[m] / TasksCount;

  for m := 1 to Intervals do
    res[Intervals+1] := res[Intervals+1] + res[m];
  res[Intervals+1] := res[Intervals+1] / Intervals;

  write(fl, indName + ' �� ������� ���������� ��������: ');

  for ta := 1 to TasksCount do
  begin
    writeln(fl, '');
    write(fl, '������� ' + inttostr(ta) +' ('+inttostr(TestTypes[ta])+ '): ');
    for m := 1 to Intervals do
      write(fl, inttostr(arr[ta][m]) + ' ');
  end;
  writeln(fl, '');
  write(fl, '����������� �� �������: ');

  for m := 1 to Intervals+1 do
  begin
    if m = Intervals+1 then
    begin
      writeln(fl, '');
      Write(fl, '�� '+inttostr(Intervals)+' �����(�) � �������: ');
    end;
    if res[m] < 0 then
      write(fl, '�/� ')
    else
      write(fl, FormatFloat('######0.###', res[m]) + ' ');
  end;

  Result := res;

end;



// ��������� ����������� ���������� ��� ������� TVectorForIndT
function StdDev_Float_Vector(data: TVectorForIndT; lTestType:integer):Double;
var
  i, divider: integer;
  std, avg: Double;
begin

  avg := 0;
  for i := 1 to TasksCount do
    begin
      if ((TestTypes[i] = lTestType) or (lTestType < 1)) then avg := avg + data[i];
    end;

 if lTestType < 1 then divider := TasksCount
                  else divider := Round(TasksCount/2);

  avg := avg / divider;
  std := 0;

  for i := 1 to TasksCount do
     if (TestTypes[i] = lTestType) or (lTestType < 1) then
       std := std+(data[i]-avg)*(data[i]-avg);

 if lTestType < 1 then divider := TasksCount-1
                  else divider := Round(TasksCount/2)-1;

  if (divider = 0)
    then std := -1
    else std := std/divider;

  if std>=0 then Result := sqrt(std)
            else Result := -1;
end;


// ��������� ����������� ���������� ��� ���� �����
// �������� ��������� � ����� ���������
function StdDev_Float_Interval_All(data: TMatrix; lTestType:integer):Double;
var
  i, j, divider: integer;
  std, avg: Double;
begin

  avg := 0;
  for i := 1 to TasksCount do
    for j := 1 to Intervals do
    begin
      if ((TestTypes[i] = lTestType) or (lTestType < 1)) then avg := avg + data[i][j];
    end;

 if lTestType < 1 then divider := TasksCount * Intervals
                  else divider := Round(TasksCount * Intervals/2);

  avg := avg / divider;
  std := 0;

  for i := 1 to TasksCount do
    for j := 1 to Intervals do
     if (TestTypes[i] = lTestType) or (lTestType < 1) then
       std := std+(data[i][j]-avg)*(data[i][j]-avg);

 if lTestType < 1 then divider := TasksCount * Intervals-1
                  else divider := Round(TasksCount * Intervals/2)-1;

  if (divider = 0)
    then std := -1
    else std := std/divider;

  if std>=0 then Result := sqrt(std)
            else Result := -1;
end;


// ��������� ����������� ���������� ��� ������������ ������
// �������� ��������� � ����� ���������
function StdDev_Float_Interval(data: TMatrix; IntervalID: integer; lTestType:integer):Double;
var
  i, divider: integer;
  std, avg: Double;
begin

  avg := 0;
  for i := 1 to TasksCount do
    begin
      if ((TestTypes[i] = lTestType) or (lTestType < 1)) then avg := avg + data[i][IntervalID];
    end;

 if lTestType < 1 then divider := TasksCount
                  else divider := Round(TasksCount/2);

  avg := avg / divider;
  std := 0;

  for i := 1 to TasksCount do
     if (TestTypes[i] = lTestType) or (lTestType < 1) then
       std := std+(data[i][IntervalID]-avg)*(data[i][IntervalID]-avg);

 if lTestType < 1 then divider := TasksCount-1
                  else divider := Round(TasksCount/2)-1;

  if (divider = 0)
    then std := -1
    else std := std/divider;

  if std>=0 then Result := sqrt(std)
            else Result := -1;
end;




// ��������� ����������� ���������� ��� ���� �����
// �������� ��������� � ����� ���������
function StdDev_Int_Interval_All(data: TMatrixI; lTestType:integer):Double;
var
  i, j, divider: integer;
  std, avg: Double;
begin

  avg := 0;
  for i := 1 to TasksCount do
    for j := 1 to Intervals do
    begin
      if ((TestTypes[i] = lTestType) or (lTestType < 1)) then avg := avg + data[i][j];
    end;

 if lTestType < 1 then divider := TasksCount * Intervals
                  else divider := Round(TasksCount * Intervals/2);

  avg := avg / divider;
  std := 0;

  for i := 1 to TasksCount do
    for j := 1 to Intervals do
     if (TestTypes[i] = lTestType) or (lTestType < 1) then
       std := std+(data[i][j]-avg)*(data[i][j]-avg);

 if lTestType < 1 then divider := TasksCount * Intervals-1
                  else divider := Round(TasksCount * Intervals/2)-1;

  if (divider = 0)
    then std := -1
    else std := std/divider;

  if std>=0 then Result := sqrt(std)
            else Result := -1;
end;


// ��������� ����������� ���������� ��� ������������ ������
// �������� ��������� � ����� ���������
function StdDev_Int_Interval(data: TMatrixI; IntervalID: integer; lTestType:integer):Double;
var
  i, divider: integer;
  std, avg: Double;
begin

  avg := 0;
  for i := 1 to TasksCount do
    begin
      if ((TestTypes[i] = lTestType) or (lTestType < 1)) then avg := avg + data[i][IntervalID];
    end;

 if lTestType < 1 then divider := TasksCount
                  else divider := Round(TasksCount/2);

  avg := avg / divider;
  std := 0;

  for i := 1 to TasksCount do
     if (TestTypes[i] = lTestType) or (lTestType < 1) then
       std := std+(data[i][IntervalID]-avg)*(data[i][IntervalID]-avg);

 if lTestType < 1 then divider := TasksCount-1
                  else divider := Round(TasksCount/2)-1;

  if (divider = 0)
    then std := -1
    else std := std/divider;

  if std>=0 then Result := sqrt(std)
            else Result := -1;
end;




function ArrayOtkonenieInteger_for_TST(arr: TMatrixI; var fl: textfile;
  indName: string; lTestType: byte): TVector;
var
  m: Integer;
  res: TVector;
  str : string;
begin

  for m := 1 to Intervals+1 do
    res[m] := 0;

  for m := 1 to Intervals do
    res[m] := StdDev_Int_Interval(arr, m, lTestType);

  res[Intervals+1] := StdDev_Int_Interval_All(arr, lTestType);

  if (lTestType<1) then str := '������ 1 � 2'
                   else str := '����� '+inttostr(lTestType);

  writeln(fl, '');
  write(fl, '����������� ���������� �� ������� �� ���� �������� '+str+': ');

  for m := 1 to Intervals do
  begin
    if res[m] < 0 then
      write(fl, '�/� ')
    else
      write(fl, FormatFloat('######0.###', res[m]) + ' ');
  end;

  writeln(fl, '');
  write(fl, '����������� ���������� �� ��� ������ � ����� �� ���� �������� '+str+': ');
  if res[Intervals+1] < 0 then
    write(fl, '�/� ')
  else
    write(fl, FormatFloat('######0.###', res[Intervals+1]) + ' ');

  Result := res;

end;




function ArrayOtkonenieFloat_for_TST(arr: TMatrix; var fl: textfile;
  indName: string; lTestType: byte): TVector;
var
  m: Integer;
  res: TVector;
  str : string;
begin

  for m := 1 to Intervals+1 do
    res[m] := 0;

  for m := 1 to Intervals do
    res[m] := StdDev_Float_Interval(arr, m, lTestType);

  res[Intervals+1] := StdDev_Float_Interval_All(arr, lTestType);

  if (lTestType<1) then str := '������ 1 � 2'
                   else str := '����� '+inttostr(lTestType);

  writeln(fl, '');
  write(fl, '����������� ���������� �� ������� �� ���� �������� '+str+': ');

  for m := 1 to Intervals do
  begin
    if res[m] < 0 then
      write(fl, '�/� ')
    else
      write(fl, FormatFloat('######0.###', res[m]) + ' ');
  end;

  writeln(fl, '');
  write(fl, '����������� ���������� �� ��� ������ � ����� �� ���� �������� '+str+': ');
  if res[Intervals+1] < 0 then
    write(fl, '�/� ')
  else
    write(fl, FormatFloat('######0.###', res[Intervals+1]) + ' ');

  Result := res;

end;







function ArrayProccessingInteger_for_TST(arr: TMatrixI; var fl: textfile;
  indName: string; lTestType: byte): TVector;
var
  m, ta: Integer;
  res: TVector;
begin

  for m := 1 to Intervals+1 do
    res[m] := 0;

  for ta := 1 to TasksCount do
    for m := 1 to Intervals do
      if TestTypes[ta] = lTestType then
        begin
          res[m] := res[m] + arr[ta][m];
        end;

  for m := 1 to Intervals do
    res[m] := 2 * res[m] / TasksCount;

  for m := 1 to Intervals do
    res[Intervals+1] := res[Intervals+1] + res[m];

  res[Intervals+1] := res[Intervals+1] / Intervals;

  writeln(fl, '');
  write(fl, '������� �� ������� �� ���� �������� ����� '+inttostr(lTestType)+': ');

  for m := 1 to Intervals+1 do
  begin
    if m = Intervals+1 then
    begin
      writeln(fl, '');
      Write(fl, '�� '+inttostr(Intervals)+' �����(�) � ������� �� ���� �������� ����� '+inttostr(lTestType)+': ');
    end;
    if res[m] < 0 then
      write(fl, '�/� ')
    else
      write(fl, FormatFloat('######0.###', res[m]) + ' ');
  end;

  Result := res;

end;



function ArrayProccessingFloat_for_TST(arr: TMatrix; var fl: textfile;
  indName: string; lTestType: byte): TVector;
var
  m, ta, dtmp: Integer;
  deli_tst : array [1 .. Intervals] of byte;
  tst: TVector;
begin

  for m := 1 to Intervals do
    deli_tst[m] := 0;

  for m := 1 to Intervals+1 do tst[m] := 0;

 // ������ �� ����� 1 � 2 ���������
  for ta := 1 to TasksCount do
    for m := 1 to Intervals do
      if arr[ta][m] > -0.0001 then
        if TestTypes[ta] = lTestType then
          begin
            tst[m] := tst[m] + arr[ta][m];
            inc(deli_tst[m]);
          end;


  for m := 1 to Intervals do
    if deli_tst[m] = 0 then
      tst[m] := -1
    else
      tst[m] := tst[m] / deli_tst[m];


  dtmp := 0;
  for m := 1 to Intervals do
    if tst[m] > -0.0001 then
    begin
      inc(dtmp);
      tst[Intervals+1] := tst[Intervals+1] + tst[m];
    end;
  if dtmp = 0 then
    tst[Intervals+1] := -1
  else
    tst[Intervals+1] := tst[Intervals+1] / dtmp;


 // ����������� �� ������� � ������� ����� ������� (1-� ��� 2-� ���)
  writeln(fl, '');
  write(fl, '������� �� ������� �� ���� �������� ����� '+inttostr(lTestType)+': ');
  for m := 1 to Intervals+1 do
  begin
    if m = Intervals+1 then
    begin
      writeln(fl, '');
      Write(fl, '�� '+inttostr(Intervals)+' �����(�) � ������� �� ���� �������� ����� '+inttostr(lTestType)+': ');
    end;
    if tst[m] < 0 then
      write(fl, '�/� ')
    else
      write(fl, FormatFloat('######0.###', tst[m]) + ' ');
  end;

  Result := tst;

end;



function ArrayProccessingFloat(arr: TMatrix; var fl: textfile;
  indName: string): TVector;
var
  m, ta, dtmp: Integer;
  deli: array [1 .. Intervals] of byte;
  res: TVector;
begin

  for m := 1 to Intervals+1 do
    res[m] := 0;

  for m := 1 to Intervals do
    deli[m] := 0;

  writeln(fl, '');
  writeln(fl, '');

  for ta := 1 to TasksCount do
    for m := 1 to Intervals do
      if arr[ta][m] > -0.0001 then
      begin
        res[m] := res[m] + arr[ta][m];
        inc(deli[m]);
      end;

  // ������ �������� �� ������ ������ �� ��� �������
  for m := 1 to Intervals do
    if deli[m] = 0 then
      res[m] := -1
    else
      res[m] := res[m] / deli[m];

  // ������ �������� �� ��� ������ �� ���� ��������
  dtmp := 0;
  for m := 1 to Intervals do
    if res[m] > -0.0001 then
    begin
      inc(dtmp);
      res[Intervals+1] := res[Intervals+1] + res[m];
    end;
  if dtmp = 0 then
    res[Intervals+1] := -1
  else
    res[Intervals+1] := res[Intervals+1] / dtmp;

  // ����� � ����

  write(fl, indName + ' �� ������� ���������� ��������: ');
  for ta := 1 to TasksCount do
  begin
    writeln(fl, '');
    write(fl, '������� ' + inttostr(ta) +' ('+inttostr(TestTypes[ta])+ '): ');
    for m := 1 to Intervals do
      if arr[ta][m] < 0 then
        write(fl, '�/� ')
      else
        write(fl, FormatFloat('######0.###', arr[ta][m]) + ' ');
  end;

  // ����������� �� �������
  writeln(fl, '');
  write(fl, '����������� �� �������: ');
  for m := 1 to Intervals+1 do
  begin
    if m = Intervals+1 then
    begin
      writeln(fl, '');
      Write(fl, '�� '+inttostr(Intervals)+' �����(�) � �������: ');
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


procedure ExcelOneIndicator(var f:textfile; _IND_T1, IND_Otkl_T1, _IND_T2, IND_Otkl_T2, _IND_T, IND_Otkl_T: TVector);
var m: integer;
begin

    for m := 1 to Intervals+1 do
    begin
      if _IND_T1[m] > -0.0001 then write(f, FormatFloat('######0.###', _IND_T1[m]));
      write(f, ';'); // � ��������� ���������, ���� �����������, ���� ���� �������� ������������!
    end;
    for m := 1 to Intervals+1 do
    begin
      if IND_Otkl_T1[m] > -0.0001 then write(f, FormatFloat('######0.###', IND_Otkl_T1[m]));
      write(f, ';'); // � ��������� ���������, ���� �����������, ���� ���� �������� ������������!
    end;
    for m := 1 to Intervals+1 do
    begin
      if _IND_T2[m] > -0.0001 then write(f, FormatFloat('######0.###', _IND_T2[m]));
      write(f, ';'); // � ��������� ���������, ���� �����������, ���� ���� �������� ������������!
    end;
    for m := 1 to Intervals+1 do
    begin
      if IND_Otkl_T2[m] > -0.0001 then write(f, FormatFloat('######0.###', IND_Otkl_T2[m]));
      write(f, ';'); // � ��������� ���������, ���� �����������, ���� ���� �������� ������������!
    end;
    for m := 1 to Intervals+1 do
    begin
      if _IND_T[m] > -0.0001 then write(f, FormatFloat('######0.###', _IND_T[m]));
      write(f, ';'); // � ��������� ���������, ���� �����������, ���� ���� �������� ������������!
    end;
    for m := 1 to Intervals+1 do
    begin
      if IND_Otkl_T[m] > -0.0001 then write(f, FormatFloat('######0.###', IND_Otkl_T[m]));
      write(f, ';'); // � ��������� ���������, ���� �����������, ���� ���� �������� ������������!
    end;
end;

procedure ExcelAddHeader(var f:textfile; indname:string);
var m,i: integer;
begin

 for i := 1 to 2 do
 begin
   for m := 1 to Intervals+1 do
     write(f, inttostr(i)+indname+'_M'+inttostr(m)+';');
   for m := 1 to Intervals+1 do
     write(f, inttostr(i)+indname+'_SD'+inttostr(m)+';');
 end;

 for m := 1 to Intervals+1 do
   write(f, '12'+indname+'_M'+inttostr(m)+';');
 for m := 1 to Intervals+1 do
   write(f, '12'+indname+'_SD'+inttostr(m)+';');

end;



procedure ToCSV();
var
  f, fl: textfile;
  ta: Integer;
  sumd: Double;
  rownum: Integer;
  _T, _T_AVG_T1, _T_AVG_T2: Double;
  _T_Otkl, _T_Otkl_T1, _T_Otkl_T2: Double;
  _KB, _KB_T1, _KB_T2: TVector;
  _KB_Otkl, _KB_Otkl_T1, _KB_Otkl_T2: TVector;
  _PZ, _PZ_T1, _PZ_T2: TVector;
  _PZ_Otkl, _PZ_Otkl_T1, _PZ_Otkl_T2: TVector;
//  _OZ: TVector;
//  _ONZ: TVector;
  _KO, _KO_T1, _KO_T2: TVector;
  _KO_Otkl, _KO_Otkl_T1, _KO_Otkl_T2: TVector;
  _SDK, _SDK_T1, _SDK_T2: TVector;
  _SDK_Otkl, _SDK_Otkl_T1, _SDK_Otkl_T2: TVector;
  _SPP, _SPP_T1, _SPP_T2: TVector;
  _SPP_Otkl, _SPP_Otkl_T1, _SPP_Otkl_T2: TVector;
  _SPO, _SPO_T1, _SPO_T2: TVector;
  _SPO_Otkl, _SPO_Otkl_T1, _SPO_Otkl_T2: TVector;
  _SOP, _SOP_T1, _SOP_T2: TVector;
  _SOP_Otkl, _SOP_Otkl_T1, _SOP_Otkl_T2: TVector;
  _SOO, _SOO_T1, _SOO_T2: TVector;
  _SOO_Otkl, _SOO_Otkl_T1, _SOO_Otkl_T2: TVector;

  CFile: THandle;
begin

  try

    AssignFile(f, ExtractfileDir(Application.ExeName) + '\' + 'results.csv');
    AssignFile(fl, ExtractfileDir(Application.ExeName) + '\' + 'last_log_'+FormatDateTime('yyyy_mm_dd_hh_nn_ss', Now)+'.txt');

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
      write(f, 'N;NAME;GEN;AGE;1T_M;1T_SD;2�_M;2T_SD;12�_M;12T_SD;');

      ExcelAddHeader(f, 'KB');
      ExcelAddHeader(f, 'PZ');
      ExcelAddHeader(f, 'KO');
      ExcelAddHeader(f, 'S');
      ExcelAddHeader(f, 'SPP');
      ExcelAddHeader(f, 'SPO');
      ExcelAddHeader(f, 'SOP');
      ExcelAddHeader(f, 'SOO');
      writeln(f);// �� ���� ��� ����� � �������!

{      write(f,
        '1KB_M1;1KB_M2;1KB_M3;1KB_M4;1KB_M5;1KB_SD1;1KB_SD2;1KB_SD3;1KB_SD4;1KB_SD5;2KB_M1;2KB_M2;2KB_M3;2KB_M4;2KB_M5;2KB_SD1;2KB_SD2;2KB_SD3;2KB_SD4;2KB_SD5;12KB_M1;12KB_M2;12KB_M3;12KB_M4;12KB_M5;12KB_SD1;12KB_SD2;12KB_SD3;12KB_SD4;12KB_SD5;');
      write(f,
        '1PZ_M1;1PZ_M2;1PZ_M3;1PZ_M4;1PZ_M5;1PZ_SD1;1PZ_SD2;1PZ_SD3;1PZ_SD4;1PZ_SD5;2PZ_M1;2PZ_M2;2PZ_M3;2PZ_M4;2PZ_M5;2PZ_SD1;2PZ_SD2;2PZ_SD3;2PZ_SD4;2PZ_SD5;12PZ_M1;12PZ_M2;12PZ_M3;12PZ_M4;12PZ_M5;12PZ_SD1;12PZ_SD2;12PZ_SD3;12PZ_SD4;12PZ_SD5;');
      write(f,
        'KB3;PZ3;OZ3;ONZ3;KPZ3;KOZ3;KONZ3;OZPZ3;ONZPZ3;KO3;KT3;SDK3;SDK1P3;SDK1O3;SDK23;SDK3P3;SDK3O3;');
      write(f,
        'KB4;PZ4;OZ4;ONZ4;KPZ4;KOZ4;KONZ4;OZPZ4;ONZPZ4;KO4;KT4;SDK4;SDK1P4;SDK1O4;SDK24;SDK3P4;SDK3O4;');
      write(f,
        'KB5;PZ5;OZ5;ONZ5;KPZ5;KOZ5;KONZ5;OZPZ5;ONZPZ5;KO5;KT5;SDK5;SDK1P5;SDK1O5;SDK25;SDK3P5;SDK3O5;');
      writeln(f,
        'KB;PZ;OZ;ONZ;KPZ;KOZ;KONZ;OZPZ;ONZPZ;KO;KT;SDK;SDK1P;SDK1O;SDK2;SDK3P;SDK3O;');
}
    end;

    write(f, inttostr(rownum) + ';' + user_name + ';' + inttostr(user_gender)
        + ';' + user_age + ';');

    // T
    sumd := 0;
    for ta := 1 to TasksCount do
      sumd := sumd + T[ta];
    _T := sumd / TasksCount;

    _T_AVG_T1 := 0;
    for ta := 1 to TasksCount do
      if TestTypes[ta] = 1 then _T_AVG_T1 := _T_AVG_T1 + T[ta];
    _T_AVG_T1 := _T_AVG_T1 / Round(TasksCount/2);

    _T_AVG_T2 := 0;
    for ta := 1 to TasksCount do
      if TestTypes[ta] = 2 then _T_AVG_T2 := _T_AVG_T2 + T[ta];
    _T_AVG_T2 := _T_AVG_T2 / Round(TasksCount/2);

    _T_Otkl:= StdDev_Float_Vector(T, 0);
    _T_Otkl_T1:= StdDev_Float_Vector(T, 1);
    _T_Otkl_T2:= StdDev_Float_Vector(T, 2);

    write(fl, 'T �� ��������: ');
    for ta := 1 to TasksCount do
    begin
      writeln(fl, '');
      write(fl, '������� ' + inttostr(ta) +' ('+inttostr(TestTypes[ta])+ '): ' + FormatFloat('######0.###', T[ta]));
    end;
    writeln(fl, '');

    writeln(fl, '������� �������� �� ����� 1: ' + FormatFloat('######0.###', _T_AVG_T1));
    writeln(fl, '������� �������� �� ����� 2: ' + FormatFloat('######0.###', _T_AVG_T2));
    writeln(fl, '������� �������� �� ������ 1 � 2: ' + FormatFloat('######0.###', _T));

    if _T_Otkl_T1 > -0.0001
      then writeln(fl, '����������� ���������� �� ����� 1: ' + FormatFloat('######0.###', _T_Otkl_T1))
      else writeln(fl, '����������� ���������� �� ����� 1: �/�');

    if _T_Otkl_T2 > -0.0001
      then writeln(fl, '����������� ���������� �� ����� 2: ' + FormatFloat('######0.###', _T_Otkl_T2))
      else writeln(fl, '����������� ���������� �� ����� 2: �/�');

    if _T_Otkl > -0.0001
      then write(fl, '����������� ���������� �� ������ 1 � 2: ' + FormatFloat('######0.###', _T_Otkl))
      else writeln(fl, '����������� ���������� �� ������ 1 � 2: �/�');

    _KB := ArrayProccessingInteger(KB, fl, 'KB');
    _KB_T1 := ArrayProccessingInteger_for_TST(KB, fl, 'KB', 1);
    _KB_T2 := ArrayProccessingInteger_for_TST(KB, fl, 'KB', 2);
    _KB_Otkl_T1 := ArrayOtkonenieInteger_for_TST(KB, fl, 'KB', 1);
    _KB_Otkl_T2 := ArrayOtkonenieInteger_for_TST(KB, fl, 'KB', 2);
    _KB_Otkl := ArrayOtkonenieInteger_for_TST(KB, fl, 'KB', 0);

    _PZ := ArrayProccessingInteger(PZ, fl, 'PZ');
    _PZ_T1 := ArrayProccessingInteger_for_TST(PZ, fl, 'PZ', 1);
    _PZ_T2 := ArrayProccessingInteger_for_TST(PZ, fl, 'PZ', 2);
    _PZ_Otkl_T1 := ArrayOtkonenieInteger_for_TST(PZ, fl, 'PZ', 1);
    _PZ_Otkl_T2 := ArrayOtkonenieInteger_for_TST(PZ, fl, 'PZ', 2);
    _PZ_Otkl := ArrayOtkonenieInteger_for_TST(PZ, fl, 'PZ', 0);

//  _OZ := ArrayProccessingInteger(OZ, fl, 'OZ');
//  _ONZ := ArrayProccessingInteger(ONZ, fl, 'ONZ');

    _KO := ArrayProccessingFloat(KO, fl, 'KO');
    _KO_T1 := ArrayProccessingFloat_for_TST(KO, fl, 'KO', 1);
    _KO_T2 := ArrayProccessingFloat_for_TST(KO, fl, 'KO', 2);
    _KO_Otkl_T1 := ArrayOtkonenieFloat_for_TST(KO, fl, 'KO', 1);
    _KO_Otkl_T2 := ArrayOtkonenieFloat_for_TST(KO, fl, 'KO', 2);
    _KO_Otkl := ArrayOtkonenieFloat_for_TST(KO, fl, 'KO', 0);

    _SDK := ArrayProccessingFloat(SDK, fl, 'S'); // ��� ��������� S !
    _SDK_T1 := ArrayProccessingFloat_for_TST(SDK, fl, 'S', 1); // ��� ��������� S !
    _SDK_T2 := ArrayProccessingFloat_for_TST(SDK, fl, 'S', 2); // ��� ��������� S !
    _SDK_Otkl_T1 := ArrayOtkonenieFloat_for_TST(SDK, fl, 'S', 1);
    _SDK_Otkl_T2 := ArrayOtkonenieFloat_for_TST(SDK, fl, 'S', 2);
    _SDK_Otkl := ArrayOtkonenieFloat_for_TST(SDK, fl, 'S', 0);

    _SPP := ArrayProccessingFloat(SPP, fl, 'SPP');
    _SPP_T1 := ArrayProccessingFloat_for_TST(SPP, fl, 'SPP', 1);
    _SPP_T2 := ArrayProccessingFloat_for_TST(SPP, fl, 'SPP', 2);
    _SPP_Otkl_T1 := ArrayOtkonenieFloat_for_TST(SPP, fl, 'SPP', 1);
    _SPP_Otkl_T2 := ArrayOtkonenieFloat_for_TST(SPP, fl, 'SPP', 2);
    _SPP_Otkl := ArrayOtkonenieFloat_for_TST(SPP, fl, 'SPP', 0);

    _SPO := ArrayProccessingFloat(SPO, fl, 'SPO');
    _SPO_T1 := ArrayProccessingFloat_for_TST(SPO, fl, 'SPO', 1);
    _SPO_T2 := ArrayProccessingFloat_for_TST(SPO, fl, 'SPO', 2);
    _SPO_Otkl_T1 := ArrayOtkonenieFloat_for_TST(SPO, fl, 'SPO', 1);
    _SPO_Otkl_T2 := ArrayOtkonenieFloat_for_TST(SPO, fl, 'SPO', 2);
    _SPO_Otkl := ArrayOtkonenieFloat_for_TST(SPO, fl, 'SPO', 0);

    _SOP := ArrayProccessingFloat(SOP, fl, 'SOP');
    _SOP_T1 := ArrayProccessingFloat_for_TST(SOP, fl, 'SOP', 1);
    _SOP_T2 := ArrayProccessingFloat_for_TST(SOP, fl, 'SOP', 2);
    _SOP_Otkl_T1 := ArrayOtkonenieFloat_for_TST(SOP, fl, 'SOP', 1);
    _SOP_Otkl_T2 := ArrayOtkonenieFloat_for_TST(SOP, fl, 'SOP', 2);
    _SOP_Otkl := ArrayOtkonenieFloat_for_TST(SOP, fl, 'SOP', 0);

    _SOO := ArrayProccessingFloat(SOO, fl, 'SOO');
    _SOO_T1 := ArrayProccessingFloat_for_TST(SOO, fl, 'SOO', 1);
    _SOO_T2 := ArrayProccessingFloat_for_TST(SOO, fl, 'SOO', 2);
    _SOO_Otkl_T1 := ArrayOtkonenieFloat_for_TST(SOO, fl, 'SOO', 1);
    _SOO_Otkl_T2 := ArrayOtkonenieFloat_for_TST(SOO, fl, 'SOO', 2);
    _SOO_Otkl := ArrayOtkonenieFloat_for_TST(SOO, fl, 'SOO', 0);

    // ����� � CSV

    // T
    if _T_AVG_T1 > -0.0001 then write(f, FormatFloat('######0.###', _T_AVG_T1));
    write(f, ';');
    if _T_Otkl_T1 > -0.0001 then write(f, FormatFloat('######0.###', _T_Otkl_T1));
    write(f, ';');
    if _T_AVG_T2 > -0.0001 then write(f, FormatFloat('######0.###', _T_AVG_T2));
    write(f, ';');
    if _T_Otkl_T2 > -0.0001 then write(f, FormatFloat('######0.###', _T_Otkl_T2));
    write(f, ';');
    if _T > -0.0001 then write(f, FormatFloat('######0.###', _T));
    write(f, ';');
    if _T_Otkl > -0.0001 then write(f, FormatFloat('######0.###', _T_Otkl));
    write(f, ';');

    // ��������� ���������� � CSV
    ExcelOneIndicator(f, _KB_T1, _KB_Otkl_T1, _KB_T2, _KB_Otkl_T2, _KB, _KB_Otkl);
    ExcelOneIndicator(f, _PZ_T1, _PZ_Otkl_T1, _PZ_T2, _PZ_Otkl_T2, _PZ, _PZ_Otkl);
    ExcelOneIndicator(f, _KO_T1, _KO_Otkl_T1, _KO_T2, _KO_Otkl_T2, _KO, _KO_Otkl);
    ExcelOneIndicator(f, _SDK_T1, _SDK_Otkl_T1, _SDK_T2, _SDK_Otkl_T2, _SDK, _SDK_Otkl);
    ExcelOneIndicator(f, _SPP_T1, _SPP_Otkl_T1, _SPP_T2, _SPP_Otkl_T2, _SPP, _SPP_Otkl);
    ExcelOneIndicator(f, _SPO_T1, _SPO_Otkl_T1, _SPO_T2, _SPO_Otkl_T2, _SPO, _SPO_Otkl);
    ExcelOneIndicator(f, _SOP_T1, _SOP_Otkl_T1, _SOP_T2, _SOP_Otkl_T2, _SOP, _SOP_Otkl);
    ExcelOneIndicator(f, _SOO_T1, _SOO_Otkl_T1, _SOO_T2, _SOO_Otkl_T2, _SOO, _SOO_Otkl);

  finally
    closeFile(f);
    closeFile(fl);
  end;

end;

end.

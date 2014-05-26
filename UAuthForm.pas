unit UAuthForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, Buttons;

type
  TForm2 = class(TForm)
    Edit1: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    timer5sec: TTimer;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    btn1: TSpeedButton;
    procedure NextStep();
    procedure HideAll();
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure timer5secTimer(Sender: TObject);
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


var
  Form2: TForm2;
  CurrStep: string;

implementation

uses Unit1, ToolUnit;
{$R *.dfm}

var
  // ��������� ���������� ����� - �� ����� ������� �����
  AvailSignalLetters : array [1..TasksCount] of string;

procedure TForm2.NextStep();
  var i: integer;
  wasError : boolean;
begin

  if (CurrStep = 'personal') then
  begin

    wasError := false;

    if (Length(Edit1.Text) < 3) OR (ComboBox1.ItemIndex < 0) OR
      (ComboBox2.ItemIndex < 0) then wasError := true;

    for i:= 1 to length(Edit1.Text) do
      if Edit1.Text[i]=';' then
      begin
        wasError := true;
        Break;
      end;

    if (wasError) then
    begin
      Label7.Show;
    end
    else
    begin
      user_name := Edit1.Text;
      user_age := ComboBox2.Items[ComboBox2.ItemIndex];
      if ComboBox1.ItemIndex = 0 then
        user_gender := 2
      else
        user_gender := 1;

      HideAll();
      CurrStep := 'training_info';
      Label8.show;
      Label9.show;
      timer5sec.Enabled:=true;
      btn1.Show;

    end;

      Exit;
  end;

  if (CurrStep = 'training_info') then
  begin
      timer5sec.Enabled:=false;
      CurrStep := 'training_instruction1';
      NextStep();
      Exit;
  end;

  if (CurrStep = 'training_instruction1') then
  begin
    CurrStep := 'training_test1';
    HideAll();
    TestType := 1; // �� ����� �������������� �������
    CurrSignalLetter := '�';
    CurrPrefix :='';
    Label10.Caption:='����������� �������������� ����� �������� ���� � ����� ������� ������ �� �������. ����� ����� �'+CurrSignalLetter+'�. ������ ���, ����� �� �������� ����� �'+CurrSignalLetter+'�, �������������� �� ��� ������ � ��������� �� ������� ������˻.';
    Label10.Show;
    Label11.Caption := '������������� ���� 1';
    Label11.Show;
    btn1.Show;
    Exit;
  end;

  if (CurrStep = 'training_instruction2') then
  begin
    CurrStep := 'training_test2';
    HideAll();
    TestType := 2; // �� ����� �������������� �������
    CurrSignalLetter := '�';
    CurrPrefix := RandomLetterG('')+RandomLetterG('')+RandomLetterG('');
    Label10.Caption:='����������� �������������� ����� �������� ���� � ����� ������� ������ �� �������. ����� ����� �'+CurrSignalLetter+'�, ������� ����� ����� ������ ����� ���� �'+CurrPrefix+'�. ���� �� �������� ����� �'+CurrSignalLetter+'�, ������� ����� ����� ��������� ����, �������������� �� ��� ������ � ��������� �� ������� ������˻. ���� ����� ������ �'+CurrSignalLetter+'� ����� ������ ��������� ����, �� �������������� �� ��� ������ � �� ��������� �� ������� ������˻.';
    Label10.Show;
    Label11.Caption := '������������� ���� 2';
    Label11.Show;
    btn1.Show;
    Exit;
  end;

  if (CurrStep = 'training_test1') then
  begin
    CurrStep := 'training_instruction2';
    HideAll();
    Form2.Close;
    Form1.StartTestTask();
    Exit;
  end;

  if (CurrStep = 'training_test2') then
  begin
    CurrStep := 'next_test_info';
    HideAll();
    Form2.Close;
    Form1.StartTestTask();
    Exit;
  end;

  if (CurrStep = 'next_test_info') then
  begin
    CurrStep := 'next_test';
    HideAll();
    //Label11.Left:=Label11.Left+75;

    inc(CurrTaskNumber);
    TestType := TestTypes[CurrTaskNumber]; // ������������ � ��� ������ ���� ����� ������� - ������� ��� �������

    // ��������� ���������� �����
    repeat
      i:= 1+Random(TasksCount);
      CurrSignalLetter := AvailSignalLetters[i];
    until CurrSignalLetter<>'';
    AvailSignalLetters[i] := '';

    if TestType=1 then
    begin
      CurrPrefix :='';
      Label10.Caption:='����������� �������������� ����� �������� � ����� ������� ������ �� �������. ����� ����� �'+CurrSignalLetter+'�. ������ ���, ����� �� �������� ����� �'+CurrSignalLetter+'�, �������������� �� ��� ������ � ��������� �� ������� ������˻. '
    end
    else
    begin
      if (i mod 2 = 0) then CurrPrefix := RandomLetterG('')+RandomLetterG('')+RandomLetterG('')
                       else CurrPrefix := RandomLetterS('')+RandomLetterS('')+RandomLetterS('');
      Label10.Caption:='����������� �������������� ����� �������� � ����� ������� ������ �� �������. ����� ����� �'+CurrSignalLetter+'�, ������� ����� ����� ������ ����� ���� �'+CurrPrefix+'�. ���� �� �������� ����� �'+CurrSignalLetter+'�, ������� ����� ����� ��������� ����, �������������� �� ��� ������ � ��������� �� ������� ������˻. ���� ����� ������ �'+CurrSignalLetter+'� ����� ������ ��������� ����, �� �������������� �� ��� ������ � �� ��������� �� ������� ������˻. ';
    end;

    Label10.Caption := Label10.Caption + '���������� ������� ��� ����� �������. ����������������� ������� � 4 ������.';
    Label11.Caption:='������� '+inttostr(CurrTaskNumber);
    Label10.Show;
    Label11.Show;
    btn1.Show;
    Exit;
  end;

  if (CurrStep = 'next_test') then
  begin
    CurrStep := 'next_test_success';
    HideAll();
    Form2.Close;
    Form1.StartTask();
    Exit;
  end;

  if (CurrStep = 'next_test_success') then
  begin
    HideAll();

    if CurrTaskNumber = TasksCount then
    begin
      Label12.Caption := '�� ������� ���������� �� ����� ���������.';
      btn1.Caption := '��� ������ �� ��������� ������� Enter';
      CurrStep := 'exit_to_windows';
    end
    else
    begin
      Label12.Caption := '�� ������� ��������� ������� '+inttostr(CurrTaskNumber)+'.';
      CurrStep := 'next_test_info';
    end;

    Label12.Show;
    Label13.Show;
    btn1.Show;
    Exit;
  end;

  if (CurrStep = 'exit_to_windows') then
  begin
    Application.Terminate;
    Exit;
  end;

  // showmessage('s');
end;

procedure TForm2.timer5secTimer(Sender: TObject);
begin
  timer5sec.Enabled:=false;
  CurrStep := 'training_instruction1';
  NextStep();
end;

function NoDoublucatesInAvailArr():Boolean;
var i,j:Integer;
res:Boolean;
begin
  res := true;
  for i := 1 to TasksCount do
   for j := 1 to TasksCount do
    if (AvailSignalLetters[i] = AvailSignalLetters[j]) and (i<>j) and (AvailSignalLetters[i] <> '') then
    begin
      res :=false;
      Break;
    end;
  Result := res;

end;


procedure TForm2.btn1Click(Sender: TObject);
begin
  NextStep();
end;


procedure TForm2.FormCreate(Sender: TObject);
  var i:integer;
      test1fnd, test2fnd : byte;
begin

  Form2.Caption := Title + ' v' + Version;

  if TasksCount mod 2 > 0 then
  begin
    showmessage('TasksCount �� ����� ���� ��������!');
    Application.Terminate;
  end;

  // �������� ������ ������������� ���������� ���� (�� �������������!) �� ����� �������
  // ������� � ��������� �������
  for i := 1 to round(TasksCount/2) do
    repeat
      AvailSignalLetters[i] := RandomLetterG('');
    until NoDoublucatesInAvailArr();

  for i := Round(TasksCount/2)+1 to TasksCount do
    repeat
      AvailSignalLetters[i] := RandomLetterS('');
    until NoDoublucatesInAvailArr();

  test1fnd := 0;
  test2fnd := 0;
  for i := 1 to TasksCount do
  begin

    if (test1fnd >= round(TasksCount/2)) then TestTypes[i] := 2;
    if (test2fnd >= round(TasksCount/2)) then TestTypes[i] := 1;
    if ((test1fnd < round(TasksCount/2)) and (test2fnd < round(TasksCount/2))) then TestTypes[i] := 1+Random(2);

    if (TestTypes[i] = 1) then inc(test1fnd);
    if (TestTypes[i] = 2) then inc(test2fnd);

  end;

end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    NextStep();
end;

procedure TForm2.HideAll;
begin
//  Label1.Visible := false;
//  Label2.Visible := false;
  btn1.Visible := false;
  Label4.Visible := false;
  Label5.Visible := false;
  Label6.Visible := false;
  Label7.Visible := false;
  Label8.Visible := false;
  Label9.Visible := false;
  Label10.Visible := false;
  Label11.Visible := false;
  Label12.Visible := false;
  Label13.Visible := false;
  ComboBox1.Hide;
  ComboBox2.Hide;
  Edit1.Hide;
end;

end.

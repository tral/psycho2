unit UAuthForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
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
    procedure NextStep();
    procedure HideAll();
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure timer5secTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;
  CurrStep: string;
  AvailSignalLetters : array [1..8] of string;

implementation

uses Unit1, ToolUnit;
{$R *.dfm}

procedure TForm2.NextStep();
  var i: integer;
  wasError : boolean;
begin
  if (CurrStep = 'welcome') then
  begin
    CurrStep := 'personal';
    HideAll();
    Label3.Show;
    Label4.Show;
    Label5.Show;
    Label6.Show;
    ComboBox1.Show;
    ComboBox2.Show;
    Edit1.Show;
    Edit1.setfocus;
    Exit;
  end;

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

    // CurrStep := 'personal';
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

    end;

      Exit;
  end;

  if (CurrStep = 'training_info') then
  begin
      timer5sec.Enabled:=false;
      CurrStep := 'training_instruction';
      NextStep();
      Exit;
  end;

  if (CurrStep = 'training_instruction') then
  begin
    CurrStep := 'training_test';
    HideAll();
    CurrSignalLetter := 'Н';
    if TestType=1 then CurrPrefix :=''
                  else CurrPrefix := RandomLetterG('')+RandomLetterG('')+RandomLetterG('');

    if TestType=1 then
      Label10.Caption:='Внимательно просматривайте буквы курсором мыши – слева направо строка за строкой. Ищите букву «Н». Всякий раз, когда Вы находите букву «Н», останавливайте на ней курсор и нажимайте на левую кнопку мыши. '
      else
      Label10.Caption:='Внимательно просматривайте буквы курсором мыши – слева направо строка за строкой. Ищите букву «Н», которая стоит после идущих рядом букв «'+CurrPrefix+'». Если Вы находите букву «Н», стоящую после этого сочетания букв, останавливайте на ней курсор и нажимайте на левую кнопку мыши. Если перед буквой «Н» стоит другое сочетание букв, не останавливайте на ней курсор и не нажимайте на левую кнопку мыши.';
    Label10.Show;
    Label11.Show;
    Label3.Show;
    Exit;
  end;

  if (CurrStep = 'training_test') then
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

    // Определим сигнальную букву
    repeat
      i:= 1+Random(8);
      CurrSignalLetter := AvailSignalLetters[i];
    until CurrSignalLetter<>'';
    AvailSignalLetters[i] := '';

    if TestType=1 then
    begin
      CurrPrefix :='';
      Label10.Caption:='Внимательно просматривайте буквы курсором мыши – слева направо строка за строкой. Ищите букву «'+CurrSignalLetter+'». Всякий раз, когда Вы находите букву «'+CurrSignalLetter+'», останавливайте на ней курсор и нажимайте на левую кнопку мыши. '
    end
    else
    begin
      if (i mod 2 = 0) then CurrPrefix := RandomLetterG('')+RandomLetterG('')+RandomLetterG('')
                       else CurrPrefix := RandomLetterS('')+RandomLetterS('')+RandomLetterS('');
      Label10.Caption:='Внимательно просматривайте буквы курсором мыши – слева направо строка за строкой. Ищите букву «'+CurrSignalLetter+'», которая стоит после идущих рядом букв «'+CurrPrefix+'». Если Вы находите букву «'+CurrSignalLetter+'», стоящую после этого сочетания букв, останавливайте на ней курсор и нажимайте на левую кнопку мыши. Если перед буквой «'+CurrSignalLetter+'» стоит другое сочетание букв, не останавливайте на ней курсор и не нажимайте на левую кнопку мыши. ';
    end;

    Label10.Caption := Label10.Caption + 'Выполняйте задание как можно быстрее. Продолжительность задания – 5 минут.';
    Label11.Caption:='Задание '+inttostr(CurrTaskNumber);
    Label10.Show;
    Label11.Show;
    Label3.Show;
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

    if CurrTaskNumber = 8 then
    begin
      Label12.Caption := 'Вы успешно справились со всеми заданиями.';
      Label3.Caption := 'Для выхода из программы нажмите Enter';
      CurrStep := 'exit_to_windows';
    end
    else
    begin
      Label12.Caption := 'Вы успешно завершили задание '+inttostr(CurrTaskNumber)+'.';
      CurrStep := 'next_test_info';
    end;

    Label12.Show;
    Label13.Show;
    Label3.Show;
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
  CurrStep := 'training_instruction';
  NextStep();
end;

function NoDoublucatesInAvailArr():Boolean;
var i,j:Integer;
res:Boolean;
begin
  res := true;
  for i := 1 to 8 do
   for j := 1 to 8 do
    if (AvailSignalLetters[i] = AvailSignalLetters[j]) and (i<>j) and (AvailSignalLetters[i] <> '') then
    begin
      res :=false;
      Break;
    end;
  Result := res;

end;



procedure TForm2.FormCreate(Sender: TObject);
  var i:integer;
begin
  Form2.Caption := Title + ' v.' + Version;
//  CurrStep := 'next_test_info';
  CurrStep := 'welcome';

  for i := 1 to 4 do
    repeat
      AvailSignalLetters[i] := RandomLetterG('');
    until NoDoublucatesInAvailArr();

  for i := 5 to 8 do
    repeat
      AvailSignalLetters[i] := RandomLetterS('');
    until NoDoublucatesInAvailArr();

end;

procedure TForm2.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = 13 then
    NextStep();
end;

procedure TForm2.HideAll;
begin
  Label1.Visible := false;
  Label2.Visible := false;
  Label3.Visible := false;
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

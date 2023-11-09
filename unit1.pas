unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ComCtrls, ExtCtrls, Menus, Process, Unit2;
var
      Elf2nso: string;
      HacBrew: string;
      Proceso: TProcess;
      Proceso2: Tprocess;
type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    ProgressBar1: TProgressBar;
    procedure Button1Click(Sender: TObject);
    procedure Button1Enter(Sender: TObject);
    procedure Edit1KeyPress(Sender: TObject; var Key: char);
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;
implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.Edit1KeyPress(Sender: TObject; var Key: char);
begin
    if not (Key in ['0'..'9', #8, #9, #13, #27, #127, #22, #24]) then
  begin
    Key := #0; // Bloquea la entrada de cualquier otro carácter.
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    if FileExists('bin/prod.keys')then
    begin
  // Mostrar un mensaje
  MessageDlg('To add an icon to your NSP, copy your 256x256 image named icon_AmericanEnglish.dat into the control folder', mtInformation, [mbOK], 0);
  end
     else
     begin
   MessageDlg('The prod.keys file does not exist', mtWarning, [mbOK], 0);
   Halt;
end;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
var Form2: TForm2;
begin

  Form2 := TForm2.Create(nil);
  Form2.Show;
end;

procedure Elf2nsoMake;
begin
    chdir('bin');
    Proceso := TProcess.Create(nil);
    try
        Proceso.CommandLine := 'elf2nso'+' '+'bgdi.elf'+' '+'main.nso';
        Proceso.ShowWindow := swoHide;
        Proceso.Execute;
    Finally
        Proceso.WaitOnExit;
        Proceso.Free;
        CopyFile('main.nso','exefs/main');
        Proceso.WaitOnExit;
        ExitCode := Proceso.ExitStatus;
    end;

end;

procedure NspMake(const Edit1Text, Edit2Text, Edit3Text: AnsiString);
var
  Proceso2: TProcess;
begin
  Proceso2 := TProcess.Create(nil);
  try
    Proceso2.CommandLine := 'hacbrewpack' + ' ' +
      '--titleid' + ' ' + Edit1Text + ' ' +
      '--titlename' + ' ' + Edit2Text + ' ' +
      '--titlepublisher' + ' ' + Edit3Text + ' ' +
      '--nspdir' + ' ' + 'NSP' + ' ' +
      '-k' + ' ' + './prod.keys';
    Proceso2.ShowWindow := swoHide;
    Proceso2.Execute;
  finally
    Proceso2.WaitOnExit;
    Proceso2.Free;
    ExitCode := Proceso2.ExitStatus;
    Deletefile('main.nso');
    chdir('..');
  end;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  Proceso3: TProcess;
begin
  ProgressBar1.Position := 10;
  Label4.Caption :=IntToStr(10)+'%';
  Application.ProcessMessages;
  Elf2nsoMake;
  ProgressBar1.Position := 20;
  Label4.Caption :=IntToStr(20)+'%';
  Application.ProcessMessages;
  Sleep(5000);
  ProgressBar1.Position := 50;
  Label4.Caption :=IntToStr(50)+'%';
  Application.ProcessMessages;
  NspMake(Edit1.Text, Edit2.Text, Edit3.Text);
  ProgressBar1.Position := 100;
  Label4.Caption := IntToStr(100)+'%';
  Application.ProcessMessages;
  DeleteFile('exefs/main.nso');
  MessageDlg('Se ha creado el Archivo:'+' '+Edit1.Text+'.nsp'+' '+'en la carpeta NSP', mtConfirmation, [mbOK], 0)
end;

procedure TForm1.Button1Enter(Sender: TObject);
begin

end;



end.


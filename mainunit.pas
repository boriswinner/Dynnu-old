unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, StdCtrls;

type
    TPolyline = array of TPoint;

  { TMainForm }

  TMainForm = class(TForm)
    Label1: TLabel;
    MainMenu: TMainMenu;
    FileSubMenu: TMenuItem;
    HelpSubMenu: TMenuItem;
    ExitMenuItem: TMenuItem;
    AboutMenuItem: TMenuItem;
    MainPaintBox: TPaintBox;
    procedure MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MainPaintBoxPaint(Sender: TObject);
  private
    { private declarations }
    Polylines: array of TPolyline;
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  //if (ssLeft in Shift) then
  begin
    setlength(Polylines,length(Polylines)+1);
    setlength(Polylines[high(Polylines)],length(Polylines[high(Polylines)])+1);
    Polylines[high(Polylines)][high(Polylines[high(Polylines)])] := Point(X,Y);
    Invalidate;
  end;
end;

procedure TMainForm.MainPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (ssLeft in Shift) then
  begin
    setlength(Polylines[high(Polylines)],length(Polylines[high(Polylines)])+1);
    Polylines[high(Polylines)][high(Polylines[high(Polylines)])] := Point(X,Y);
    Invalidate;
  end;
end;

procedure TMainForm.MainPaintBoxPaint(Sender: TObject);
var
  i,j: integer;
begin
  label1.Caption:=IntToStr(length(Polylines));
  for i := 0 to high(Polylines) do
  begin
    for j := 0 to high(Polylines[i])-1 do
    begin
      MainPaintBox.Canvas.Line(Polylines[i][j],Polylines[i][j+1]);
    end;
  end;
end;

end.


unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, StdCtrls, ColorPalette;

type
    TPolyline = record
      Points: array of TPoint;
      Color: TColor;
    end;

  { TMainForm }

  TMainForm = class(TForm)
    MainColorPalette: TColorPalette;
    MainMenu: TMainMenu;
    FileSubMenu: TMenuItem;
    HelpSubMenu: TMenuItem;
    ExitMenuItem: TMenuItem;
    AboutMenuItem: TMenuItem;
    MainPaintBox: TPaintBox;
    procedure AboutMenuItemClick(Sender: TObject);
    procedure ExitMenuItemClick(Sender: TObject);
    procedure MainColorPaletteColorPick(Sender: TObject; AColor: TColor;
      Shift: TShiftState);
    procedure MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MainPaintBoxPaint(Sender: TObject);
  private
    { private declarations }
    Polylines: array of TPolyline;
    ColorWasChanged: boolean;
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
  begin
    if (ColorWasChanged = false) then
    begin
      setlength(Polylines,length(Polylines)+1);
      Polylines[high(Polylines)].Color := Polylines[high(Polylines)-1].Color;
    end;
    ColorWasChanged := false;
    setlength(Polylines[high(Polylines)].Points,length(Polylines[high(Polylines)].Points)+1);
    Polylines[high(Polylines)].Points[high(Polylines[high(Polylines)].Points)] := Point(X,Y);
    Invalidate;
  end;
end;

procedure TMainForm.MainColorPaletteColorPick(Sender: TObject; AColor: TColor;
  Shift: TShiftState);
begin
  if (ColorWasChanged = false) then setlength(Polylines,length(Polylines)+1);
  Polylines[high(Polylines)].Color := AColor;
  //MainPaintBox.Canvas.Pen.Color := AColor;
  ColorWasChanged := true;
end;

procedure TMainForm.ExitMenuItemClick(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TMainForm.AboutMenuItemClick(Sender: TObject);
begin
  ShowMessage('Boris Timofeenko, b8103a');
end;

procedure TMainForm.MainPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (ssLeft in Shift) then
  begin
    setlength(Polylines[high(Polylines)].Points,length(Polylines[high(Polylines)].Points)+1);
    Polylines[high(Polylines)].Points[high(Polylines[high(Polylines)].Points)] := Point(X,Y);
    Invalidate;
  end;
end;

procedure TMainForm.MainPaintBoxPaint(Sender: TObject);
var
  i,j: integer;
begin
  for i := 0 to high(Polylines) do
  begin
    for j := 0 to high(Polylines[i].Points)-1 do
    begin
      MainPaintBox.Canvas.Pen.Color := Polylines[i].Color;
      MainPaintBox.Canvas.Line(Polylines[i].Points[j],Polylines[i].Points[j+1]);
    end;
  end;
end;

end.


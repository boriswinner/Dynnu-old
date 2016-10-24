unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, StdCtrls, ColorPalette,AboutUnit;

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
    PaintPanel: TPanel;
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
      SetLength(Polylines,length(Polylines)+1);
      Polylines[high(Polylines)].Color := Polylines[high(Polylines)-1].Color;
    end;
    ColorWasChanged := false;
    with Polylines[high(Polylines)] do begin
      SetLength(Points,length(Points)+1);
      Points[high(Points)] := Point(X,Y);
    end;
    Invalidate;
  end;
end;

procedure TMainForm.MainColorPaletteColorPick(Sender: TObject; AColor: TColor;
  Shift: TShiftState);
begin
  if (ColorWasChanged = false) then setlength(Polylines,length(Polylines)+1);
  Polylines[high(Polylines)].Color := AColor;
  ColorWasChanged := true;
end;

procedure TMainForm.ExitMenuItemClick(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TMainForm.AboutMenuItemClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.MainPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (ssLeft in Shift) then
  begin
    with Polylines[high(Polylines)] do begin
      SetLength(Points,length(Points)+1);
      Points[high(Points)] := Point(X,Y);
    end;
    Invalidate;
  end;
end;

procedure TMainForm.MainPaintBoxPaint(Sender: TObject);
var
  i,j: integer;
begin
  for i := 0 to high(Polylines) do
  begin
    MainPaintBox.Canvas.Pen.Color := Polylines[i].Color;
    MainPaintBox.Canvas.Polyline(Polylines[i].Points,0,high(Polylines[i].Points)-1);
  end;
end;

end.
//Pascal тип Polyline
//улучшить код

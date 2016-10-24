unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, StdCtrls, ColorPalette,AboutUnit,FiguresUnit,ToolsUnit;

type
    {TPolyline = record
      Points: array of TPoint;
      Color: TColor;
    end;}

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
    InstrumentsRadioGroup: TRadioGroup;
    PolylineToolButton: TRadioButton;
    RectangleToolButton: TRadioButton;
    procedure AboutMenuItemClick(Sender: TObject);
    procedure ExitMenuItemClick(Sender: TObject);
    procedure MainColorPaletteColorPick(Sender: TObject; AColor: TColor;
      Shift: TShiftState);
    procedure MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MainPaintBoxPaint(Sender: TObject);
    procedure PolylineToolButtonClick(Sender: TObject);
    procedure RectangleToolButtonChange(Sender: TObject);
  private
    { private declarations }
    Tools: array of TTool;
    CurrentTool: TTool;
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  Figures: array of TFigure;
  ColorWasChanged: boolean;
implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  begin
    SetLength(Figures,length(Figures)+1);
    Figures[high(Figures)] := TPolyline.Create;
    if (length(Figures) >= 2) then Figures[high(Figures)].Color := Figures[high(Figures)-1].Color;
    ColorWasChanged := false;
    with Figures[high(Figures)] do begin
      SetLength(Points,length(Points)+1);
      Points[high(Points)] := Point(X,Y);
    end;
    Invalidate;
  end;
end;

procedure TMainForm.MainColorPaletteColorPick(Sender: TObject; AColor: TColor;
  Shift: TShiftState);
begin
  if (ColorWasChanged = false) then
  begin
    setlength(Figures,length(Figures)+1);
    Figures[high(Figures)] := TPolyline.Create;
  end;
  Figures[high(Figures)].Color := AColor;
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
    with Figures[high(Figures)] do begin
      SetLength(Points,length(Points)+1);
      Points[high(Points)] := Point(X,Y);
    end;
    Invalidate;
  end;
end;

procedure TMainForm.MainPaintBoxPaint(Sender: TObject);
var
  i: integer;
begin
  for i := 0 to high(Figures) do
  begin
    Figures[i].Draw(MainPaintBox.Canvas);
  end;
end;

procedure TMainForm.PolylineToolButtonClick(Sender: TObject);
begin
  CurrentTool := TPolylineTool.Create;
end;

procedure TMainForm.RectangleToolButtonChange(Sender: TObject);
begin
  CurrentTool := TRectangleTool.Create;
end;

end.
//улучшить код

unit mainunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, StdCtrls, ColorPalette,
  aboutunit,figuresunit,toolsunit;

type
  TFigureClass = toolsunit.TFigureClass;

  { TMainForm }

  TMainForm = class(TForm)
    ColorLabel1: TLabel;
    ColorLabel2: TLabel;
    MainColorPalette: TColorPalette;
    MainMenu: TMainMenu;
    FileSubMenu: TMenuItem;
    HelpSubMenu: TMenuItem;
    ExitMenuItem: TMenuItem;
    AboutMenuItem: TMenuItem;
    MainPaintBox: TPaintBox;
    PaintPanel: TPanel;
    InstrumentsRadioGroup: TRadioGroup;
    ColorsPanel: TPanel;
    PolylineToolButton: TRadioButton;
    LineToolButton: TRadioButton;
    EllipseToolButton: TRadioButton;
    RectangleToolButton: TRadioButton;
    procedure AboutMenuItemClick(Sender: TObject);
    procedure EllipseToolButtonChange(Sender: TObject);
    procedure ExitMenuItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure LineToolButtonChange(Sender: TObject);
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
    CurrentFigure: TFigureClass;
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  Figures: array of TFigure;
  PenColor,BrushColor: TColor;
implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  begin
    CurrentTool.FigureCreate(CurrentFigure,Point(X,Y),PenColor,BrushColor);
    Invalidate;
  end;
end;

procedure TMainForm.MainColorPaletteColorPick(Sender: TObject; AColor: TColor;
  Shift: TShiftState);
begin
  if (ssLeft in Shift) then PenColor := AColor;
  if (ssRight in Shift) then BrushColor := AColor;
  ColorLabel1.Color := PenColor;
  ColorLabel2.Color := BrushColor;
end;

procedure TMainForm.ExitMenuItemClick(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  PolylineToolButtonClick(self);
  PolylineToolButton.Checked := true;
  ColorLabel1.Color := PenColor;
  ColorLabel2.Color := BrushColor;
end;

procedure TMainForm.LineToolButtonChange(Sender: TObject);
begin
  CurrentTool := TLineTool.Create;
  CurrentFigure := TLine;
end;

procedure TMainForm.AboutMenuItemClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.EllipseToolButtonChange(Sender: TObject);
begin
  CurrentTool := TEllipseTool.Create;
  CurrentFigure := TEllipse;
end;

procedure TMainForm.MainPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if (ssLeft in Shift) then
  begin
    CurrentTool.AddPoint(Point(X,Y));
  end;
  Invalidate;
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
  CurrentFigure := TPolyline;
end;

procedure TMainForm.RectangleToolButtonChange(Sender: TObject);
begin
  CurrentTool := TRectangleTool.Create;
  CurrentFigure := TRectangle;
end;

end.
//улучшить код

unit MainUnit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, StdCtrls, ColorPalette,AboutUnit,FiguresUnit,ToolsUnit;

type

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
  public
    { public declarations }
  end;

var
  MainForm: TMainForm;
  Figures: array of TFigure;
  Color1,Color2: TColor;
implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  begin
    CurrentTool.FigureCreate(Point(X,Y));
    Invalidate;
  end;
end;

procedure TMainForm.MainColorPaletteColorPick(Sender: TObject; AColor: TColor;
  Shift: TShiftState);
begin
  if (ssLeft in Shift) then color1 := AColor;
  if (ssRight in Shift) then color2 := AColor;
  ColorLabel1.Color := color1;
  ColorLabel2.Color := color2;
end;

procedure TMainForm.ExitMenuItemClick(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  PolylineToolButtonClick(self);
  PolylineToolButton.Checked := true;
  ColorLabel1.Color := color1;
  ColorLabel2.Color := color2;
end;

procedure TMainForm.LineToolButtonChange(Sender: TObject);
begin
  CurrentTool := TLineTool.Create;
end;

procedure TMainForm.AboutMenuItemClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.EllipseToolButtonChange(Sender: TObject);
begin
  CurrentTool := TEllipseTool.Create;
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
end;

procedure TMainForm.RectangleToolButtonChange(Sender: TObject);
begin
  CurrentTool := TRectangleTool.Create;
end;

end.
//улучшить код

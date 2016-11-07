unit mainunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, StdCtrls, Grids, LCLIntf, LCLType, Buttons, GraphMath,
  Spin, aboutunit, figuresunit, toolsunit, scalesunit;

type
  TFigureClass = figuresunit.TFigureClass;

  { TMainForm }

  TMainForm = class(TForm)
    ColorsGridColorDialog: TColorDialog;
    ColorLabel1: TLabel;
    ColorLabel2: TLabel;
    ColorsGrid: TDrawGrid;
    MainMenu: TMainMenu;
    FileSubMenu: TMenuItem;
    HelpSubMenu: TMenuItem;
    ExitMenuItem: TMenuItem;
    AboutMenuItem: TMenuItem;
    MainPaintBox: TPaintBox;
    PaintPanel: TPanel;
    ColorsPanel: TPanel;
    HorizontalScrollBar: TScrollBar;
    ShowAllButton: TButton;
    VerticalScrollBar: TScrollBar;
    ZoomSpinEdit: TSpinEdit;
    ToolsPanel: TPanel;
    procedure AboutMenuItemClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure MainPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainPaintBoxResize(Sender: TObject);
    procedure ShowAllButtonClick(Sender: TObject);
    procedure ToolButtonClick(Sender: TObject);
    procedure ColorsGridDblClick(Sender: TObject);
    procedure ColorsGridDrawCell(Sender: TObject; aCol, aRow: Integer;
      aRect: TRect; aState: TGridDrawState);
    procedure ColorsGridMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ExitMenuItemClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure MainPaintBoxMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure MainPaintBoxMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure MainPaintBoxPaint(Sender: TObject);
    procedure ScrollBarChange(Sender: TObject);
    procedure ZoomSpinEditChange(Sender: TObject);
  private
    { private declarations }
    CurrentTool: TTool;
    Colors: array of TColor;
    ColorsFile: text;
    BotScrollCent,RightScrollCent: integer;
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
    CurrentTool.FigureCreate(CurrentTool.FigureClass,Point(X,Y),PenColor,BrushColor);
    Invalidate;
  end;
end;

procedure TMainForm.ExitMenuItemClick(Sender: TObject);
begin
  MainForm.Close;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  i: integer;
  b: TBitBtn;
begin
  Zoom                        := 1;
  scalesunit.CenterDisplace.X := MainPaintBox.Width/2;
  scalesunit.CenterDisplace.Y := MainPaintBox.Height/2;
  scalesunit.PaintBoxSize.x   := MainPaintBox.Width;
  scalesunit.PaintBoxSize.y   := MainPaintBox.Height;

  CurrentTool       := ToolsRegister[0];
  ColorLabel1.Color := PenColor;
  ColorLabel2.Color := BrushColor;
  ColorsGrid.Width  := ColorsGrid.DefaultColWidth*ColorsGrid.ColCount+4;
  ColorsPanel.Width := ColorsGrid.Width;

  AssignFile(ColorsFile,'colors.txt');
  reset(ColorsFile);
  while not eof(ColorsFile) do
  begin
    setlength(Colors,length(Colors)+1);
    readln(ColorsFile,Colors[high(Colors)]);
  end;
  CloseFile(ColorsFile);

  ColorsGrid.RowCount := length(Colors) div 3;
  ToolsPanel.Width    := 5 + 4*32 + 5;
  for i := low(ToolsRegister) to high(ToolsRegister) do
  begin
    b         := TBitBtn.Create(MainForm);
    b.Parent  := ToolsPanel;
    b.name    := 'ToolButton'+IntToStr(i+1);
    b.Caption := '';
    b.Tag     := Integer(i);
    b.Left    := 5 + (i mod 4)*32;
    b.Top     := 5 + (i div 4)*32;
    b.Width   := 32;
    b.Height  := 32;
    b.Glyph   := ToolsRegister[i].Bitmap;
    b.OnClick := @ToolButtonClick;
  end;

  HorizontalScrollBar.max:=round(MainPaintBox.Width*scalesunit.Zoom);
  HorizontalScrollBar.PageSize := MainPaintBox.ClientWidth;
  HorizontalScrollBar.Position:=round(HorizontalScrollBar.max/2);
  VerticalScrollBar.max:=round(MainPaintBox.Height*scalesunit.Zoom);
  VerticalScrollBar.PageSize := MainPaintBox.ClientHeight;
  VerticalScrollBar.Position:=round(VerticalScrollBar.max/2);
end;

procedure TMainForm.AboutMenuItemClick(Sender: TObject);
begin
  AboutForm.ShowModal;
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  CurrentTool := TRectangleTool.Create;
  CurrentTool.FigureCreate(TRectangle,Point(0,0),clBlack,clWhite);
  CurrentTool.AddPoint(Point(MainPaintBox.Width,MainPaintBox.Height));
  CurrentTool := ToolsRegister[0];
  Invalidate;
  {ShowMessage(IntToStr(WorldToScreen(MaxFloatPoint).x));
  ShowMessage(IntToStr(WorldToScreen(MaxFloatPoint).y));
  ShowMessage(IntToStr(WorldToScreen(MinFloatPoint).x));
  ShowMessage(IntToStr(WorldToScreen(MinFloatPoint).y));}
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_ADD) or (key=VK_OEM_PLUS) then
    ZoomSpinEdit.Value := ZoomSpinEdit.Value + 10;
  if (key=VK_SUBTRACT) or (key=VK_OEM_MINUS) then
    ZoomSpinEdit.Value := ZoomSpinEdit.Value - 10;
end;

procedure TMainForm.MainPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (CurrentTool.ClassName = 'THandTool') then setlength(Figures,length(Figures)-1);
  Invalidate;
end;

procedure TMainForm.MainPaintBoxResize(Sender: TObject);
begin
  scalesunit.ToShift(FloatPoint((MainPaintBox.Width -PaintBoxSize.x)/2,
                                (MainPaintBox.Height-PaintBoxSize.y)/2));
  scalesunit.PaintBoxSize.y   := MainPaintBox.Height;
  scalesunit.PaintBoxSize.x   := MainPaintBox.Width;
end;

procedure TMainForm.ShowAllButtonClick(Sender: TObject);
begin
  scalesunit.ShowAll;
  ZoomSpinEdit.Value := round(Zoom*100);
  ShowMessage(FloatToStr(zoom));
  Invalidate;
end;

procedure TMainForm.ToolButtonClick(Sender: TObject);
var
  atag: integer;
begin
  atag := Integer((Sender as TBitBtn).Tag);
  CurrentTool := ToolsRegister[atag];
end;

procedure TMainForm.ColorsGridDblClick(Sender: TObject);
var
  aState: TGridDrawState;
begin
  if ColorsGridColorDialog.Execute then
  begin
    PenColor := ColorsGridColorDialog.Color;
    Colors[ColorsGrid.ColCount*((Sender as TDrawGrid).Row)+(Sender as TDrawGrid).Col] :=
    ColorsGridColorDialog.Color;
    ColorsGridDrawCell(Sender,(Sender as TDrawGrid).Col,(Sender as TDrawGrid).Row,Rect(1,1,1,1),aState);
    ColorLabel1.Color := PenColor;
  end;
end;

procedure TMainForm.ColorsGridDrawCell(Sender: TObject; aCol, aRow: Integer;
  aRect: TRect; aState: TGridDrawState);
begin
  ColorsGrid.Canvas.Brush.Color := Colors[ColorsGrid.ColCount*(aRow)+aCol];
  ColorsGrid.Canvas.FillRect(aRect);
end;

procedure TMainForm.ColorsGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Col,Row: integer;
begin
  ColorsGrid.MouseToCell(X,Y,Col,Row);
  if (ssLeft in Shift) then PenColor := Colors[ColorsGrid.ColCount*Row+Col];
  if (ssRight in Shift) then BrushColor := Colors[ColorsGrid.ColCount*Row+Col];
  ColorLabel1.Color := PenColor;
  ColorLabel2.Color := BrushColor;
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

procedure TMainForm.ScrollBarChange(Sender: TObject);
begin
  //сдвигаем картинку
  scalesunit.ToShift(FloatPoint(BotScrollCent-HorizontalScrollBar.Position,
  RightScrollCent-VerticalScrollBar.Position));

  //запоминаем прошлое положение
  BotScrollCent:=HorizontalScrollBar.Position;
  RightScrollCent:=VerticalScrollBar.Position;

  Invalidate;
end;

procedure TMainForm.ZoomSpinEditChange(Sender: TObject);
begin
  scalesunit.DoZoom(ZoomSpinEdit.Value);
  //scalesunit.SetCenterDisplace(MainPaintBox);
  //SetCenterDisplace()
  Invalidate;
end;

procedure SetScrollBarPositions;
begin

end;

end.

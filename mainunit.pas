unit mainunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, StdCtrls, Grids, LCLIntf, LCLType, Buttons, GraphMath, Math,
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
    procedure ScrollBarScroll(Sender: TObject;
      ScrollCode: TScrollCode; var ScrollPos: Integer);
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
    ScrollBool,RBtn: boolean;
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
  if (ssRight in Shift) then RBtn := true;
  CurrentTool.FigureCreate(CurrentTool.FigureClass,Point(X,Y),PenColor,BrushColor);
  Invalidate;
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
  Zoom                        := 100;
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

  HorizontalScrollBar.max := MainPaintBox.Width;
  VerticalScrollBar.max   := MainPaintBox.Height;
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
  VerticalScrollBar.Max   := round(WorldToScreen(MaxFloatPoint).y);
  VerticalScrollBar.Min   := round(WorldToScreen(MinFloatPoint).y);
  HorizontalScrollBar.Max := round(WorldToScreen(MaxFloatPoint).x);
  HorizontalScrollBar.Min := round(WorldToScreen(MinFloatPoint).x);
end;

procedure TMainForm.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=VK_ADD)      or (key=VK_OEM_PLUS)  then
    ZoomSpinEdit.Value := ZoomSpinEdit.Value + 10;
  if (key=VK_SUBTRACT) or (key=VK_OEM_MINUS) then
    ZoomSpinEdit.Value := ZoomSpinEdit.Value - 10;
end;

procedure TMainForm.ScrollBarScroll(Sender: TObject;
  ScrollCode: TScrollCode; var ScrollPos: Integer);
begin
  if not ScrollBool then
    begin
      SetOffset(Point(HorizontalScrollBar.Position,VerticalScrollBar.Position));
      Invalidate;
    end;
  ScrollBool:=false;
end;

procedure TMainForm.MainPaintBoxMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if (CurrentTool.ClassName = 'TMagnifierTool') then
  begin
    with Figures[high(Figures)] do begin
      if(Points[low(Points)].x+5>Points[high(Points)].x) then
      begin
        if (not RBtn) then ZoomSpinEdit.Value := ZoomSpinEdit.Value*2 else
          ZoomSpinEdit.Value := ZoomSpinEdit.Value div 2;
        RBtn := false;
      end else begin
        RectZoom(MainPaintBox.Height,
        MainPaintBox.Width,
        Figures[high(Figures)].Points[0],
        Figures[high(Figures)].Points[1]);
      end;
    end;
  end;
  if (CurrentTool.ClassName = 'THandTool') or
  (CurrentTool.ClassName = 'TMagnifierTool') then
    setlength(Figures,length(Figures)-1);
  ZoomSpinEdit.Value := scalesunit.Zoom;
  Invalidate;
end;

procedure TMainForm.MainPaintBoxResize(Sender: TObject);
begin
  scalesunit.PaintBoxSize.x   := MainPaintBox.Width;
  scalesunit.PaintBoxSize.y   := MainPaintBox.Height;
end;

procedure TMainForm.ShowAllButtonClick(Sender: TObject);
begin
  RectZoom(MainPaintBox.Height,MainPaintBox.Width,MinFloatPoint,MaxFloatPoint);
  ZoomSpinEdit.Value:=round(Zoom);
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
    CurrentTool.AddPoint(Point(X,Y));
  Invalidate;
end;

procedure TMainForm.MainPaintBoxPaint(Sender: TObject);
var
  i: integer;
begin
  for i := low(Figures) to high(Figures) do
  begin
    Figures[i].Draw(MainPaintBox.Canvas);
  end;

  if round(MinFloatPoint.X*Zoom/100)<HorizontalScrollBar.Min then
    HorizontalScrollBar.Min:=round(MinFloatPoint.X*Zoom/100);
  if HorizontalScrollBar.Max<round(MaxFloatPoint.X*Zoom/100) then
    HorizontalScrollBar.Max:=round(MaxFloatPoint.X*Zoom/100);
  if round(MinFloatPoint.Y*Zoom/100)<VerticalScrollBar.Min then
    VerticalScrollBar.Min:=round(MinFloatPoint.Y*Zoom/100);
  if VerticalScrollBar.Max<round(MaxFloatPoint.Y*Zoom/100) then
    VerticalScrollBar.Max:=round(MaxFloatPoint.Y*Zoom/100);

  if Offset.x+MainPaintBox.Width>HorizontalScrollBar.Max then
    HorizontalScrollBar.Max:=Offset.x+MainPaintBox.Width;
  if Offset.x<HorizontalScrollBar.Min then
    HorizontalScrollBar.Min:=Offset.x;
  if Offset.y+MainPaintBox.Height>VerticalScrollBar.Max then
    VerticalScrollBar.Max:=Offset.y+MainPaintBox.Height;
  if Offset.y<VerticalScrollBar.Min then
    VerticalScrollBar.Min:=Offset.y;

  ScrollBool:=true;
  HorizontalScrollBar.Position:=Offset.x;
  ScrollBool:=true;
  VerticalScrollBar.Position:=Offset.y;
end;

procedure TMainForm.ScrollBarChange(Sender: TObject);
begin
  //сдвигаем картинку
  scalesunit.SetOffset(FloatPoint(BotScrollCent-HorizontalScrollBar.Position,
  RightScrollCent-VerticalScrollBar.Position));

  //запоминаем прошлое положение
  BotScrollCent   := HorizontalScrollBar.Position;
  RightScrollCent := VerticalScrollBar.Position;

  VerticalScrollBar.Max   := round(WorldToScreen(MaxFloatPoint).y);
  VerticalScrollBar.Min   := round(WorldToScreen(MinFloatPoint).y);
  HorizontalScrollBar.Max := round(WorldToScreen(MaxFloatPoint).x);
  HorizontalScrollBar.Min := round(WorldToScreen(MinFloatPoint).x);

  Invalidate;
end;

procedure TMainForm.ZoomSpinEditChange(Sender: TObject);
var
  oldzoom:double;
begin
  oldzoom := Zoom;
  Zoom := ZoomSpinEdit.Value;
  CenterZoom(MainPaintBox.Width,MainPaintBox.Height,oldzoom);
  Invalidate;
end;

end.

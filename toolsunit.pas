unit toolsunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Menus,
  ExtCtrls, StdCtrls, Grids, LCLIntf, LCLType, Buttons, GraphMath, Math, Spin, FPCanvas, TypInfo,
  figuresunit,scalesunit;

type

  TFigureClass = figuresunit.TFigureClass;
  TToolClass   = class of TTool;

  TTool = class
      Bitmap: TBitmap;
      FigureClass: class of TFigure;
  public
    procedure Initialize(APanel: TPanel); virtual;
    procedure CreateLineWidthSpinEdit(APanel: TPanel);
    procedure CreateLineStyleComboBox(APanel: TPanel);
    procedure CreateFillStyleComboBox(APanel: TPanel);
    procedure FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
      APenColor,ABrushColor: TColor; APenStyle: TPenStyle;
      ABrushStyle: TBrushStyle; APenWidth: integer); virtual;
    procedure AddPoint(APoint: TPoint); virtual;
    procedure StopDraw(X,Y, AHeight, AWidth: integer; RBtn: boolean); virtual;
    procedure PenStyleComboBoxSelect(Sender: TObject);
    procedure FillStyleComboBoxSelect(Sender: TObject);
    procedure LineWidthSpinEditSelect (Sender: TObject);
  end;

  TTwoPointsTools = class(TTool)
  public
    procedure AddPoint(APoint: TPoint); override;
    procedure Initialize(APanel: TPanel); override;
  end;

  TSpecificTools = class(TTool)
  public
    procedure Initialize(APanel: TPanel); override;
  end;

  THandTool       = class(TSpecificTools)
  public
    Figure: THandFigure;
  public
    procedure FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
      APenColor,ABrushColor: TColor; APenStyle: TPenStyle;
      ABrushStyle: TBrushStyle; APenWidth: integer); override;
    procedure AddPoint(APoint: TPoint); override;
    procedure StopDraw(X,Y, AHeight, AWidth: integer; RBtn: boolean); override;
  end;

  TPolylineTool   = class(TTool)
    Figure: TPolyline;
  public
    procedure FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
      APenColor,ABrushColor: TColor; APenStyle: TPenStyle;
      ABrushStyle: TBrushStyle; APenWidth: integer); override;
  end;

  TRectangleTool  = class(TTwoPointsTools)
    Figure: TRectangle;
  public
    procedure FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
      APenColor,ABrushColor: TColor; APenStyle: TPenStyle;
      ABrushStyle: TBrushStyle; APenWidth: integer); override;
  end;

  TEllipseTool    = class(TTwoPointsTools)
    Figure: TEllipse;
  public
    procedure FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
      APenColor,ABrushColor: TColor; APenStyle: TPenStyle;
      ABrushStyle: TBrushStyle; APenWidth: integer); override;
  end;

  TLineTool       = class(TTwoPointsTools)
    Figure: TLine;
  public
    procedure FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
      APenColor,ABrushColor: TColor; APenStyle: TPenStyle;
      ABrushStyle: TBrushStyle; APenWidth: integer); override;
    procedure Initialize(APanel: TPanel); override;
  end;

  TMagnifierTool  = class(TTwoPointsTools)
  public
    Figure: TRectangle;
  public
    procedure FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
      APenColor,ABrushColor: TColor; APenStyle: TPenStyle;
      ABrushStyle: TBrushStyle; APenWidth: integer); override;
    procedure StopDraw(X,Y, AHeight, AWidth: integer; RBtn: boolean); override;
    procedure Initialize(APanel: TPanel); override;
  end;

var
  ToolsRegister: array of TTool;
  OffsetFirstPoint: TPoint;
implementation

procedure TTool.FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
  APenColor,ABrushColor: TColor; APenStyle: TPenStyle; ABrushStyle: TBrushStyle;
  APenWidth: integer);
begin
  SetLength(Figures,length(Figures)+1);
  Figures[high(Figures)] := AFigureClass.Create;
  with Figures[high(Figures)] do begin
    FigurePenColor := APenColor;
    FigureBrushColor := ABrushColor;
    SetLength(Points,1);
    Points[high(Points)] := scalesunit.ScreenToWorld(APoint);
  end;
  if AFigureClass = THandFigure then
  begin
    OffsetFirstPoint.x:=Offset.x+APoint.x;
    OffsetFirstPoint.y:=Offset.y+APoint.y;
  end;
  if (AFigureClass <> THandFigure) and (AFigureClass <> TMagnifierFrame) then
        SetMaxMinFloatPoints(ScreenToWorld(APoint));
end;
procedure TPolylineTool.FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
  APenColor,ABrushColor: TColor; APenStyle: TPenStyle;
  ABrushStyle: TBrushStyle; APenWidth: integer);
begin
  Inherited;
  (Figures[high(Figures)] as TPolyline).FigurePenStyle := APenStyle;
  (Figures[high(Figures)] as TPolyline).FigurePenWidth := APenWidth;
end;

procedure THandTool.FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
  APenColor,ABrushColor: TColor; APenStyle: TPenStyle;
  ABrushStyle: TBrushStyle; APenWidth: integer);
begin
  Inherited;
end;

procedure TRectangleTool.FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
  APenColor,ABrushColor: TColor; APenStyle: TPenStyle;
  ABrushStyle: TBrushStyle; APenWidth: integer);
begin
  Inherited;
  (Figures[high(Figures)] as TRectangle).FigurePenStyle := APenStyle;
  (Figures[high(Figures)] as TRectangle).FigureBrushStyle := ABrushStyle;
  (Figures[high(Figures)] as TRectangle).FigurePenWidth := APenWidth;
end;

procedure TEllipseTool.FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
  APenColor,ABrushColor: TColor; APenStyle: TPenStyle;
  ABrushStyle: TBrushStyle; APenWidth: integer);
begin
  Inherited;
  (Figures[high(Figures)] as TEllipse).FigurePenStyle := APenStyle;
  (Figures[high(Figures)] as TEllipse).FigureBrushStyle := ABrushStyle;
  (Figures[high(Figures)] as TEllipse).FigurePenWidth := APenWidth;
end;

procedure TLineTool.FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
  APenColor,ABrushColor: TColor; APenStyle: TPenStyle;
  ABrushStyle: TBrushStyle; APenWidth: integer);
begin
  Inherited;
  (Figures[high(Figures)] as TLine).FigurePenStyle := APenStyle;
  (Figures[high(Figures)] as TLine).FigurePenWidth := APenWidth;
end;

procedure TMagnifierTool.FigureCreate(AFigureClass: TFigureClass; APoint: TPoint;
  APenColor,ABrushColor: TColor; APenStyle: TPenStyle;
  ABrushStyle: TBrushStyle; APenWidth: integer);
begin
  Inherited;
end;

procedure TTool.AddPoint(APoint: TPoint);
begin
  with Figures[high(Figures)] do begin
    SetLength(Points,length(Points)+1);
    Points[high(Points)] := scalesunit.ScreenToWorld(APoint);
  end;
  SetMaxMinFloatPoints(ScreenToWorld(APoint));
end;

procedure TTwoPointsTools.AddPoint(APoint: TPoint);
begin
  with Figures[high(Figures)] do begin
    SetLength(Points,2);
    Points[high(Points)] := scalesunit.ScreenToWorld(APoint);
  end;
  if (ClassName <> 'TMagnifierTool') then
        SetMaxMinFloatPoints(ScreenToWorld(APoint));
end;

procedure THandTool.AddPoint(APoint: TPoint);
begin
  with Figures[high(Figures)] do begin
    SetLength(Points,2);
    Points[high(Points)].x := scalesunit.ScreenToWorld(APoint).x -
      Points[low(Points)].x;
    Points[high(Points)].y := scalesunit.ScreenToWorld(APoint).y -
      Points[low(Points)].y;
    Offset.x := OffsetFirstPoint.x-APoint.x;
    Offset.y := OffsetFirstPoint.y-APoint.y;
  end;
end;

procedure RegisterTool(ATool: TTool; AFigureClass: TFigureClass; ABitmapFile: string);
begin
  setlength(ToolsRegister,length(ToolsRegister)+1);
  ToolsRegister[high(ToolsRegister)] := ATool;
  with ToolsRegister[high(ToolsRegister)] do begin
    Bitmap := TBitmap.Create;
    Bitmap.LoadFromFile(ABitmapFile);
    FigureClass := AFigureClass;
  end;
end;

procedure TTool.StopDraw(X,Y, AHeight, AWidth: integer; RBtn: boolean);
begin
end;

procedure TMagnifierTool.StopDraw(X,Y, AHeight, AWidth: integer; RBtn: boolean);
var
  t: double;
begin
    with Figures[high(Figures)] do begin
      if(Points[low(Points)].x+5>Points[high(Points)].x) then
      begin
        if (not RBtn) then t := Zoom*2 else t := Zoom / 2;
        if (t>800) then
        begin
          setlength(Figures,length(Figures)-1);
          exit;
        end;
        Zoom := t;
        scalesunit.ToPointZoom(FloatPoint(X,Y));
        RBtn := false;
      end else begin
        RectZoom(AHeight, AWidth, Points[0], Points[1]);
      end;
    setlength(Figures,length(Figures)-1);
  end;
end;

procedure THandTool.StopDraw(X,Y, AHeight, AWidth: integer; RBtn: boolean);
begin
  setlength(Figures,length(Figures)-1);
end;

procedure TTool.PenStyleComboBoxSelect(Sender: TObject);
begin
  figuresunit.PenStyle := TFPPenStyle(GetEnumValue(TypeInfo(TFPPenStyle),
  (Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]));
end;

procedure TTool.FillStyleComboBoxSelect(Sender: TObject);
begin
  figuresunit.BrushStyle := TBrushStyle(GetEnumValue(TypeInfo(TBrushStyle),
  (Sender as TComboBox).Items[(Sender as TComboBox).ItemIndex]));
end;

procedure TTool.LineWidthSpinEditSelect (Sender: TObject);
begin
  PenWidth := (Sender as TSpinEdit).Value;
end;
procedure TTool.CreateLineWidthSpinEdit(APanel: TPanel);
var
  LineWidthSpinEdit: TSpinEdit;
begin
  LineWidthSpinEdit := TSpinEdit.Create(APanel);
  LineWidthSpinEdit.Name := 'LineWidthSpinEdit';
  LineWidthSpinEdit.Parent := APanel;
  LineWidthSpinEdit.Align := alBottom;
  LineWidthSpinEdit.MaxValue := 100;
  LineWidthSpinEdit.MinValue := 1;
  LineWidthSpinEdit.Value := PenWidth;
  LineWidthSpinEdit.OnChange := @LineWidthSpinEditSelect;
end;
procedure TTool.CreateLineStyleComboBox(APanel: TPanel);
var
  LineStyleComboBox: TComboBox;
  i: integer;
begin
  LineStyleComboBox := TComboBox.Create(APanel);
  LineStyleComboBox.Name := ('LineStyleComboBox');
  LineStyleComboBox.Parent := APanel;
  LineStyleComboBox.Align := alBottom;
  for i := ord(low(TFPPenStyle)) to ord(high(TFPPenStyle)) do
  begin
    LineStyleComboBox.Items.Add(GetEnumName(TypeInfo(TFPPenStyle),i));
  end;
  LineStyleComboBox.ItemIndex := ord(PenStyle);
  LineStyleComboBox.OnSelect  := @PenStyleComboBoxSelect;
end;
procedure TTool.CreateFillStyleComboBox(APanel: TPanel);
var
  FillStyleComboBox: TComboBox;
  i: integer;
begin
  FillStyleComboBox := TComboBox.Create(APanel);
  FillStyleComboBox.Name := ('FillStyleComboBox');
  FillStyleComboBox.Parent := APanel;
  FillStyleComboBox.Align := alBottom;
  for i := ord(low(TBrushStyle)) to ord(high(TBrushStyle)) do
  begin
    FillStyleComboBox.Items.Add(GetEnumName(TypeInfo(TBrushStyle),i));
  end;
  FillStyleComboBox.ItemIndex := ord(BrushStyle);
  FillStyleComboBox.OnSelect  := @FillStyleComboBoxSelect;
end;

procedure TTool.Initialize(APanel: TPanel);
begin
  CreateLineWidthSpinEdit(APanel);
end;

procedure TTwoPointsTools.Initialize(APanel: TPanel);
begin
  CreateLineWidthSpinEdit(APanel);
  CreateLineStyleComboBox(APanel);
  CreateFillStyleComboBox(APanel);
end;

procedure TSpecificTools.Initialize(APanel: TPanel);
begin
end;
procedure TMagnifierTool.Initialize(APanel: TPanel);
begin
end;
procedure TLineTool.Initialize(APanel: TPanel);
begin
  CreateLineWidthSpinEdit(APanel);
  CreateLineStyleComboBox(APanel);
end;

initialization
RegisterTool (TPolylineTool.Create, TPolyline, 'Pencil.bmp');
RegisterTool (TRectangleTool.Create, TRectangle, 'Rectangle.bmp');
RegisterTool (TEllipseTool.Create, TEllipse, 'Ellipse.bmp');
RegisterTool (TLineTool.Create, TLine, 'Line.bmp');
RegisterTool (TMagnifierTool.Create, TMagnifierFrame, 'Magnifier.bmp');
RegisterTool (THandTool.Create, THandFigure, 'Hand.bmp');
end.


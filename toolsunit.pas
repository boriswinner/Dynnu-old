unit toolsunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics,
  figuresunit,scalesunit;

type

  TFigureClass = figuresunit.TFigureClass;
  TToolClass   = class of TTool;

  TTool = class
      Bitmap: TBitmap;
      FigureClass: class of TFigure;
  public
    procedure FigureCreate(AFigureClass: TFigureClass; APoint: TPoint; APenColor,ABrushColor: TColor);
    procedure AddPoint(APoint: TPoint); virtual;
  end;

  TTwoPointsTools = class(TTool)
  public
    procedure AddPoint(APoint: TPoint); override;
  end;

  THandTool       = class(TTool)
  public
    Figure: THandFigure;
  public
    procedure AddPoint(APoint: TPoint); override;
  end;

  TPolylineTool   = class(TTool)
    Figure: TPolyline;
  end;

  TRectangleTool  = class(TTwoPointsTools)
    Figure: TRectangle;
  end;

  TEllipseTool    = class(TTwoPointsTools)
    Figure: TEllipse;
  end;

  TLineTool       = class(TTwoPointsTools)
    Figure: TLine;
  end;

  TMagnifierTool  = class(TTwoPointsTools)
    Figure: TRectangle;
  end;

var
  ToolsRegister: array of TTool;
  OffsetFirstPoint: TPoint;
implementation
uses Controls;

procedure TTool.FigureCreate(AFigureClass: TFigureClass; APoint: TPoint; APenColor,ABrushColor: TColor);
begin
  SetLength(Figures,length(Figures)+1);
  Figures[high(Figures)] := AFigureClass.Create;
  with Figures[high(Figures)] do begin
    FigurePenColor := APenColor;
    FigureBrushColor := ABrushColor;
    SetLength(Points,1);
    Points[high(Points)] := scalesunit.ScreenToWorld(APoint);
    SetMaxMinFloatPoints(ScreenToWorld(APoint));
  end;
  if AFigureClass = THandFigure then
  begin
    OffsetFirstPoint.x:=Offset.x+APoint.x;
    OffsetFirstPoint.y:=Offset.y+APoint.y;
  end;
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

initialization
RegisterTool (TPolylineTool.Create, TPolyline, 'Pencil.bmp');
RegisterTool (TRectangleTool.Create, TRectangle, 'Rectangle.bmp');
RegisterTool (TEllipseTool.Create, TEllipse, 'Ellipse.bmp');
RegisterTool (TLineTool.Create, TLine, 'Line.bmp');
RegisterTool (TMagnifierTool.Create, TMagnifierFrame, 'Magnifier.bmp');
RegisterTool (THandTool.Create, THandFigure, 'Hand.bmp');
end.


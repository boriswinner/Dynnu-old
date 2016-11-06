unit toolsunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics,
  figuresunit,scalesunit;

type

  TFigureClass = figuresunit.TFigureClass;
  TToolClass =  class of TTool;

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

  TPolylineTool = class(TTool)
    Figure: TPolyline;
  end;

  TRectangleTool = class(TTwoPointsTools)
    Figure: TRectangle;
  end;

  TEllipseTool = class(TTwoPointsTools)
    Figure: TEllipse;
  end;

  TLineTool = class(TTwoPointsTools)
    Figure: TLine;
  end;
var
  ToolsRegister: array of TTool;
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
end.


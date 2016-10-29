unit toolsunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, FiguresUnit;

type

  TTool = class
  public
    procedure FigureCreate(AFigure: TFigure; APoint: TPoint; APenColor,ABrushColor: TColor);
    procedure AddPoint(Point: TPoint); virtual;
  end;

  TTwoPointsTools = class(TTool)
  public
    procedure AddPoint(Point: TPoint); override;
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
implementation
uses MainUnit, Controls;

procedure TTool.FigureCreate(AFigure: TFigure; APoint: TPoint; APenColor,ABrushColor: TColor);
begin
  SetLength(Figures,length(Figures)+1);
  Figures[high(Figures)] := AFigure.Create;
  Figures[high(Figures)].FigurePenColor := APenColor;
  Figures[high(Figures)].FigureBrushColor := ABrushColor;
  with Figures[high(Figures)] do begin
    SetLength(Points,1);
    Points[high(Points)] := APoint;
  end;
end;

procedure TTool.AddPoint(APoint: TPoint);
begin
  with Figures[high(Figures)] do begin
    SetLength(Points,length(Points)+1);
    Points[high(Points)] := APoint;
  end;
end;

procedure TTwoPointsTools.AddPoint(APoint: TPoint);
begin
  with Figures[high(Figures)] do begin
    SetLength(Points,2);
    Points[high(Points)] := APoint;
  end;
end;
end.


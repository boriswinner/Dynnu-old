unit toolsunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, FiguresUnit;

type
  TFigureClass = class  of TFigure;

  TTool = class
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
implementation
uses MainUnit, Controls;

procedure TTool.FigureCreate(AFigureClass: TFigureClass; APoint: TPoint; APenColor,ABrushColor: TColor);
begin
  SetLength(Figures,length(Figures)+1);
  Figures[high(Figures)] := AFigureClass.Create;
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

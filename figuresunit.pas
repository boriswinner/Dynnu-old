unit figuresunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;
type
  TFigureClass = class  of TFigure;

  TFigure = class
  public
    procedure Draw(Canvas: TCanvas); virtual; abstract;
  public
    Points: array of TPoint;
    FigurePenColor,FigureBrushColor: TColor;
  end;

  TPolyline = class(TFigure)
  public
    procedure Draw(Canvas:TCanvas); override;
  end;

  TRectangle = class(TFigure)
  public
    procedure Draw(Canvas:TCanvas); override;
  end;

  TEllipse = class(TFigure)
  public
    procedure Draw(Canvas:TCanvas); override;
  end;

  TLine = class(TFigure)
  public
    procedure Draw(Canvas:TCanvas); override;
  end;
var
  Figures: array of TFigure;
  PenColor,BrushColor: TColor;
  FiguresRegister: array of TFigureClass;
implementation

procedure TPolyline.Draw(Canvas: TCanvas);
begin
  Canvas.Pen.Color := FigurePenColor;
  Canvas.Polyline(Points,0,high(Points)-1);
end;

procedure TRectangle.Draw(Canvas: TCanvas);
begin
  Canvas.Pen.Color := FigurePenColor;
  Canvas.Brush.Color := FigureBrushColor;
  Canvas.Rectangle(Points[low(Points)].x,Points[low(Points)].y,Points[high(Points)].x,Points[high(Points)].y);
end;

procedure TEllipse.Draw(Canvas: TCanvas);
begin
  Canvas.Pen.Color := FigurePenColor;
  Canvas.Brush.Color := FigureBrushColor;
  Canvas.Ellipse(Points[low(Points)].x,Points[low(Points)].y,Points[high(Points)].x,Points[high(Points)].y);
end;

procedure TLine.Draw(Canvas: TCanvas);
begin
  Canvas.Pen.Color := FigurePenColor;
  Canvas.Line(Points[low(Points)].x,Points[low(Points)].y,Points[high(Points)].x,Points[high(Points)].y);
end;

initialization
end.


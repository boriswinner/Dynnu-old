unit figuresunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;
type

  TFigure = class
  public
    procedure Draw(Canvas: TCanvas); virtual; abstract;
  public
    Points: array of TPoint;
    Color: TColor;
  end;

  TPolyline = class(TFigure)
  public
    procedure Draw(Canvas:TCanvas); override;
  end;

  TRectangle = class(TFigure)
  public
    procedure Draw(Canvas:TCanvas); override;
  end;

implementation

procedure TPolyline.Draw(Canvas: TCanvas);
begin
    Canvas.Pen.Color := Color;
    Canvas.Polyline(Points,0,high(Points)-1);
end;

procedure TRectangle.Draw(Canvas: TCanvas);
begin
    Canvas.Brush.Color := clRed;
    Canvas.Pen.Color := clBlack;
    Canvas.Rectangle(Points[low(Points)].x,Points[low(Points)].y,Points[high(Points)].x,Points[high(Points)].y);
end;


initialization
end.


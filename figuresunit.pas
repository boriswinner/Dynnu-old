unit figuresunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;
type

  TFigure = class
    //procedure Draw(Canvas: TCanvas); virtual;
    public
      Points: array of TPoint;
      Color: TColor;
  end;

  TPolyline = class(TFigure)
    procedure Draw(Canvas:TCanvas); //override;
    private
    protected
    public
  end;

  TRectangle = class(TFigure)
    private
    protected
    public
  end;

implementation


procedure TPolyline.Draw(Canvas: TCanvas);
var
  i,j: integer;
begin
    Canvas.Pen.Color := Color;
    Canvas.Polyline(Points,0,high(Points)-1);
end;
initialization
end.


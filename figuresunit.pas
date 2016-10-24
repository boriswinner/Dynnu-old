unit figuresunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics;

type

  TFigure = class(TPersistent)
    //procedure Draw(Canvas: TCanvas); virtual;
  public
    Points: array of TPoint;
  end;

  TPolyline = class(TFigure)
    //procedure Draw(Canvas:TCanvas); override;
  private
  protected
  public
    //Points: array of TPoint;
    Color: TColor;
  end;

var
  Figures: array of TFigure;
implementation

//procedure TPolyline.Draw(Canvas: TCanvas);
{var
  i,j: integer;
begin
  for i := 0 to high(Polylines) do
  begin
    Canvas.Pen.Color := Polylines[i].Color;
    Canvas.Polyline(Polylines[i].Points,0,high(Polylines[i].Points)-1);
  end;}
//end;

end.


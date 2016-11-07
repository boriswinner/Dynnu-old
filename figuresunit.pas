unit figuresunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, GraphMath, Forms, Dialogs,
  scalesunit;
type
  TFigureClass = class  of TFigure;

  TFigure = class
  public
    procedure Draw(Canvas: TCanvas); virtual; abstract;
  public
    Points: array of TFloatPoint;
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

  THandFigure = class(TFigure)
  public
    procedure Draw(Canvas: TCanvas); override;
  end;

var
  Figures: array of TFigure;
  PenColor,BrushColor: TColor;
  FiguresRegister: array of TFigureClass;
  HandPrevCent: TPoint;
implementation

procedure TPolyline.Draw(Canvas: TCanvas);
var i: integer;
begin
  Canvas.Pen.Color := FigurePenColor;
  for i := low(Points) to high(Points)-1 do
  begin
    Canvas.Line(scalesunit.WorldToScreen(Points[i]).x,
                scalesunit.WorldToScreen(Points[i]).y,
                scalesunit.WorldToScreen(Points[i+1]).x,
                scalesunit.WorldToScreen(Points[i+1]).y);
  end;
end;

procedure TRectangle.Draw(Canvas: TCanvas);
begin
  Canvas.Pen.Color := FigurePenColor;
  Canvas.Brush.Color := FigureBrushColor;
  Canvas.Rectangle(scalesunit.WorldToScreen(Points[low(Points)]).x,
                   scalesunit.WorldToScreen(Points[low(Points)]).y,
                   scalesunit.WorldToScreen(Points[high(Points)]).x,
                   scalesunit.WorldToScreen(Points[high(Points)]).y);
end;

procedure TEllipse.Draw(Canvas: TCanvas);
begin
  Canvas.Pen.Color := FigurePenColor;
  Canvas.Brush.Color := FigureBrushColor;
  Canvas.Ellipse(scalesunit.WorldToScreen(Points[low(Points)]).x,
                   scalesunit.WorldToScreen(Points[low(Points)]).y,
                   scalesunit.WorldToScreen(Points[high(Points)]).x,
                   scalesunit.WorldToScreen(Points[high(Points)]).y);
end;

procedure TLine.Draw(Canvas: TCanvas);
begin
  Canvas.Pen.Color := FigurePenColor;
  Canvas.Line(scalesunit.WorldToScreen(Points[low(Points)]).x,
              scalesunit.WorldToScreen(Points[low(Points)]).y,
              scalesunit.WorldToScreen(Points[high(Points)]).x,
              scalesunit.WorldToScreen(Points[high(Points)]).y);
end;

procedure THandFigure.Draw(Canvas: TCanvas);
begin
  Canvas.Brush.Color := clWhite;
  Canvas.Pen.Color := clBlack;
  Canvas.Ellipse(scalesunit.WorldToScreen(Points[low(Points)]).x-5,
                 scalesunit.WorldToScreen(Points[low(Points)]).y-5,
                 scalesunit.WorldToScreen(Points[low(Points)]).x+5,
                 scalesunit.WorldToScreen(Points[low(Points)]).y+5);
  ToShift(Points[low(Points)]);
  HandPrevCent := Points[low(Points)];
end;

initialization
end.


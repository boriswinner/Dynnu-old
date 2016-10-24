unit toolsunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  TTool = class
  procedure FigureCreate(Point: TPoint); virtual; abstract;
  procedure AddPoint(Point: TPoint); virtual; abstract;
    public
  end;

  TPolylineTool = class(TTool)
  procedure FigureCreate(Point: TPoint); override;
  procedure AddPoint(Point: TPoint); override;
    public
  end;

  TRectangleTool = class(TTool)
  procedure FigureCreate(Point: TPoint); override;
  procedure AddPoint(Point: TPoint); override;
    public
  end;

implementation
uses MainUnit, FiguresUnit, Controls;

procedure TPolylineTool.FigureCreate(Point: TPoint);
begin
  SetLength(Figures,length(Figures)+1);
  Figures[high(Figures)] := TPolyline.Create;
  if (length(Figures) >= 2) then Figures[high(Figures)].Color := Figures[high(Figures)-1].Color;
  ColorWasChanged := false;
  with Figures[high(Figures)] do begin
    SetLength(Points,length(Points)+1);
    Points[high(Points)] := Point;
  end;
end;

procedure TPolylineTool.AddPoint(Point: TPoint);
begin
  with Figures[high(Figures)] do begin
    SetLength(Points,length(Points)+1);
    Points[high(Points)] := Point;
  end;
end;

procedure TRectangleTool.FigureCreate(Point: TPoint);
begin
  SetLength(Figures,length(Figures)+2);
  Figures[high(Figures)] := TRectangle.Create;
  if (length(Figures) >= 2) then Figures[high(Figures)].Color := Figures[high(Figures)-1].Color;
  ColorWasChanged := false;
  with Figures[high(Figures)] do begin
    SetLength(Points,length(Points)+1);
    Points[high(Points)] := Point;
  end;
end;

procedure TRectangleTool.AddPoint(Point: TPoint);
begin
  with Figures[high(Figures)] do begin
    Points[high(Points)] := Point;
  end;
end;

end.


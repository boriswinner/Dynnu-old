unit toolsunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type

  TTool = class
  public
    procedure FigureCreate(Point: TPoint); virtual; abstract;
    procedure AddPoint(Point: TPoint); virtual; abstract;
  end;

  TPolylineTool = class(TTool)
  public
    procedure FigureCreate(Point: TPoint); override;
    procedure AddPoint(Point: TPoint); override;
  end;

  TRectangleTool = class(TTool)
  public
    procedure FigureCreate(Point: TPoint); override;
    procedure AddPoint(Point: TPoint); override;
  end;

  TEllipseTool = class(TTool)
  public
    procedure FigureCreate(Point: TPoint); override;
    procedure AddPoint(Point: TPoint); override;
  end;

  TLineTool = class(TTool)
  public
    procedure FigureCreate(Point: TPoint); override;
    procedure AddPoint(Point: TPoint); override;
  end;
implementation
uses MainUnit, FiguresUnit, Controls;

procedure TPolylineTool.FigureCreate(Point: TPoint);
begin
  SetLength(Figures,length(Figures)+1);
  Figures[high(Figures)] := TPolyline.Create;
  Figures[high(Figures)].Color1 := Color1;
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
  SetLength(Figures,length(Figures)+1);
  Figures[high(Figures)] := TRectangle.Create;
  Figures[high(Figures)].Color1 := Color1;
  Figures[high(Figures)].Color2 := Color2;
  with Figures[high(Figures)] do begin
    SetLength(Points,length(Points)+2); //сразу ставим длину в 2 элемента
    Points[low(Points)] := Point;
    Points[high(Points)] := Point;
  end;
end;

procedure TRectangleTool.AddPoint(Point: TPoint);
begin
  with Figures[high(Figures)] do begin
    Points[high(Points)] := Point;
  end;
end;

procedure TEllipseTool.FigureCreate(Point: TPoint);
begin
  SetLength(Figures,length(Figures)+1);
  Figures[high(Figures)] := TEllipse.Create;
  Figures[high(Figures)].Color1 := Color1;
  Figures[high(Figures)].Color2 := Color2;
  with Figures[high(Figures)] do begin
    SetLength(Points,length(Points)+2); //сразу ставим длину в 2 элемента
    Points[low(Points)] := Point;
    Points[high(Points)] := Point;
  end;
end;

procedure TEllipseTool.AddPoint(Point: TPoint);
begin
  with Figures[high(Figures)] do begin
    Points[high(Points)] := Point;
  end;
end;

procedure TLineTool.FigureCreate(Point: TPoint);
begin
  SetLength(Figures,length(Figures)+1);
  Figures[high(Figures)] := TLine.Create;
  Figures[high(Figures)].Color1 := Color1;
  with Figures[high(Figures)] do begin
    SetLength(Points,length(Points)+2); //сразу ставим длину в 2 элемента
    Points[low(Points)] := Point;
    Points[high(Points)] := Point;
  end;
end;

procedure TLineTool.AddPoint(Point: TPoint);
begin
  with Figures[high(Figures)] do begin
    Points[high(Points)] := Point;
  end;
end;
end.


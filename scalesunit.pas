unit scalesunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphMath, ExtCtrls, Controls, Math;

function WorldToScreen         (APoint: TFloatPoint): TPoint;
function ScreenToWorld         (APoint: TPoint):      TFloatPoint;
procedure ToShift              (APoint: TFloatPoint);
procedure SetMaxMinFloatPoints (APoint: TFloatPoint);
procedure CenterZoom(AWidth,AHeight:integer;OldZoom:Double);
procedure RectZoom(AHeight,AWidth:Integer;AMin,AMax:TFloatPoint);

var
  Zoom: double;
  MaxFloatPoint, MinFloatPoint: TFloatPoint;//мировые
  Offset: TPoint;
  PaintBoxSize: TPoint;
implementation

function WorldToScreen (APoint: TFloatPoint): TPoint;
begin
  WorldToScreen.X:=round(APoint.X*Zoom/100)-Offset.x;
  WorldToScreen.y:=round(APoint.Y*Zoom/100)-Offset.y;
end;

function ScreenToWorld (APoint: TPoint): TFloatPoint;
begin
  ScreenToWorld.X := (APoint.x+Offset.x)/Zoom*100;
  ScreenToWorld.Y := (APoint.y+Offset.y)/Zoom*100;
end;

//обновление смещения
procedure ToShift (APoint: TFloatPoint);
begin
  Offset := APoint;
end;

procedure SetMaxMinFloatPoints (APoint: TFloatPoint);
begin
  if (APoint.x > MaxFloatPoint.x) then
     MaxFloatPoint.x := APoint.x;
  if (APoint.y > MaxFloatPoint.y) then
     MaxFloatPoint.y := APoint.y;
  if (APoint.x < MinFloatPoint.x) then
     MinFloatPoint.x := APoint.x;
  if (APoint.y < MinFloatPoint.y) then
     MinFloatPoint.y := APoint.y;
end;

procedure CenterZoom(AWidth,AHeight:integer;OldZoom:Double);
begin
  if Zoom>oldzoom then
    begin
      Offset.x:=Offset.x+round(AWidth*(Zoom-oldzoom)/200);
      Offset.y:=Offset.y+round(AHeight*(Zoom-oldzoom)/200);
    end
  else
    begin
      Offset.x:=Offset.x-round(AWidth*(oldzoom-Zoom)/200);
      Offset.y:=Offset.y-round(AHeight*(oldzoom-Zoom)/200);
    end;
end;

procedure RectZoom(AHeight,AWidth:Integer;AMin,AMax:TFloatPoint);
begin
  //AWidth:=AWidth+10;
  //AHeight:=AHeight+10;
  if (Awidth/(AMax.X-AMin.X))>(AHeight/(AMax.Y-AMin.Y)) then
    Zoom:=AHeight/(AMax.Y-AMin.Y)*100
  else
    Zoom:=AWidth/(AMax.X-AMin.X)*100;
  Offset.x:=round(AMin.X*Zoom/100);
  Offset.y:=round(AMin.Y*Zoom/100);
end;

initialization
  MinFloatPoint := FloatPoint(0,0);
  MaxFloatPoint := (PaintBoxSize);
end.


unit scalesunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphMath, ExtCtrls, Controls, Math;

function WorldToScreen         (APoint: TFloatPoint): TPoint;
function ScreenToWorld         (APoint: TPoint):      TFloatPoint;
procedure SetCenterDisplace    (APoint: TPoint);
procedure SetMaxMinFloatPoints (APoint: TFloatPoint);
procedure DoZoom               (AZoom: Double);
procedure ShowAll;

var
  Zoom: double;
  MaxFloatPoint, MinFloatPoint: TFloatPoint;//мировые
  CenterDisplace: TFloatPoint;
  PaintBoxSize: TPoint;
implementation

function WorldToScreen (APoint: TFloatPoint): TPoint;
begin
  WorldToScreen.X := round((APoint.X - CenterDisplace.X)*Zoom+PaintBoxSize.x/2);
  WorldToScreen.Y := round((APoint.Y - CenterDisplace.Y)*Zoom+PaintBoxSize.y/2);
end;

function ScreenToWorld (APoint: TPoint): TFloatPoint;
begin
  ScreenToWorld.X := (APoint.X - PaintBoxSize.x/2)/Zoom + CenterDisplace.X;
  ScreenToWorld.Y := (APoint.Y - PaintBoxSize.y/2)/Zoom + CenterDisplace.Y;
end;

procedure SetCenterDisplace (APoint: TPoint);
begin
  CenterDisplace.X := CenterDisplace.X - APoint.x;
  CenterDisplace.Y := CenterDisplace.Y - APoint.y;
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

procedure ShowAll;
begin
  Zoom := min(PaintBoxSize.x / (MaxFloatPoint.x - MinFloatPoint.x), PaintBoxSize.y /
    (MaxFloatPoint.y - MinFloatPoint.y))*100;
end;

procedure DoZoom(AZoom: Double);
begin
  Zoom := AZoom / 100;
  //SetCenterDisplace(FloatPoint(CenterDisplace.x - (MaxFloatPoint.x + MinFloatPoint.x) / 2,
  // CenterDisplace.y - (MaxFloatPoint.y + MinFloatPoint.y) / 2));
end;

initialization
  MaxFloatPoint := Point(0,0);
  MinFloatPoint := Point(0,0);
end.


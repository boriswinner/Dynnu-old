unit scalesunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, GraphMath, ExtCtrls, Controls, Math;

function WorldToScreen         (APoint: TFloatPoint): TPoint;
function ScreenToWorld         (APoint: TPoint):      TFloatPoint;
procedure ToShift              (APoint: TFloatPoint);
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
  WorldToScreen.X := round((Apoint.X - CenterDisplace.X) * Zoom + PaintBoxSize.X/2);
  WorldToScreen.Y := round((Apoint.Y - CenterDisplace.Y) * Zoom + PaintBoxSize.Y/2);
end;

function ScreenToWorld (APoint: TPoint): TFloatPoint;
begin
  ScreenToWorld.X := (Apoint.X - PaintBoxSize.X/2) / Zoom + CenterDisplace.X;
  ScreenToWorld.Y := (Apoint.Y - PaintBoxSize.Y/2) / Zoom + CenterDisplace.y;
end;

//обновление смещения
procedure ToShift (APoint: TFloatPoint);
begin
  CenterDisplace := CenterDisplace - APoint;
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
  ToShift(FloatPoint(CenterDisplace.x - (MaxFloatPoint.x + MinFloatPoint.x) / 2,
    CenterDisplace.y - (MaxFloatPoint.y + MinFloatPoint.y) / 2));
  Zoom := min(PaintBoxSize.x / (MaxFloatPoint.x - MinFloatPoint.x), PaintBoxSize.y /
    (MaxFloatPoint.y - MinFloatPoint.y));
end;

procedure DoZoom(AZoom: Double);
begin
  Zoom := AZoom / 100;
  ToShift(FloatPoint(CenterDisplace.x - (MaxFloatPoint.x + MinFloatPoint.x) / 2,
   CenterDisplace.y - (MaxFloatPoint.y + MinFloatPoint.y) / 2));
  {ToShift(FloatPoint(CenterDisplace.X - (PaintBoxSize.x / 2),
          CenterDisplace.Y - (PaintBoxSize.y/ 2)));}
  //SetCenterDisplace(FloatPoint(CenterDisplace.x - (MaxFloatPoint.x + MinFloatPoint.x) / 2,
  // CenterDisplace.y - (MaxFloatPoint.y + MinFloatPoint.y) / 2));
end;

initialization
  MinFloatPoint := FloatPoint(0,0);
  MaxFloatPoint := (PaintBoxSize);
end.


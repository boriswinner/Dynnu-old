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
  WorldToScreen.X := round((APoint.X)*Zoom+CenterDisplace.X);
  WorldToScreen.Y := round((APoint.Y)*Zoom+CenterDisplace.Y);
end;

function ScreenToWorld (APoint: TPoint): TFloatPoint;
begin
  ScreenToWorld.X := (APoint.X - CenterDisplace.X)/Zoom;
  ScreenToWorld.Y := (APoint.Y - CenterDisplace.Y)/Zoom;
end;

//обновление смещения
procedure ToShift (APoint: TFloatPoint);
begin
  CenterDisplace := CenterDisplace + APoint;
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
    +(MaxFloatPoint.y - MinFloatPoint.y));

  ToShift(FloatPoint(CenterDisplace.x/2 - (MaxFloatPoint.x + MinFloatPoint.x)/2,
            CenterDisplace.y/2 - (MaxFloatPoint.y + MinFloatPoint.y))/2);
end;

procedure DoZoom(AZoom: Double);
begin
  Zoom := AZoom / 100;
  {ToShift(FloatPoint(CenterDisplace.X - (PaintBoxSize.x / 2),
          CenterDisplace.Y - (PaintBoxSize.y/ 2)));}
  //SetCenterDisplace(FloatPoint(CenterDisplace.x - (MaxFloatPoint.x + MinFloatPoint.x) / 2,
  // CenterDisplace.y - (MaxFloatPoint.y + MinFloatPoint.y) / 2));
end;

initialization
  MinFloatPoint := FloatPoint(0,0);
  MaxFloatPoint := (PaintBoxSize);
end.


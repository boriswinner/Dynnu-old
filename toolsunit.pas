unit toolsunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics,
  figuresunit;

type

  TToolClass =  class of TTool;

  TTool = class
      Bitmap: TBitmap;
  public
    procedure FigureCreate(AFigureClass: TFigureClass; APoint: TPoint; APenColor,ABrushColor: TColor);
    procedure AddPoint(APoint: TPoint); virtual;
    procedure AddBitmap(s: string; AtoolClass: TToolClass);
  end;

  TTwoPointsTools = class(TTool)
  public
    procedure AddPoint(APoint: TPoint); override;
  end;

  TPolylineTool = class(TTool)
    Figure: TPolyline;
  end;

  TRectangleTool = class(TTwoPointsTools)
    Figure: TRectangle;
  end;

  TEllipseTool = class(TTwoPointsTools)
    Figure: TEllipse;
  end;

  TLineTool = class(TTwoPointsTools)
    Figure: TLine;
  end;
var
  BitmapFiles: array of string;
  ToolBitmapsFile: text;
  ToolsRegister: array of TTool;
implementation
uses Controls;

procedure TTool.FigureCreate(AFigureClass: TFigureClass; APoint: TPoint; APenColor,ABrushColor: TColor);
begin
  SetLength(Figures,length(Figures)+1);
  Figures[high(Figures)] := AFigureClass.Create;
  with Figures[high(Figures)] do begin
    FigurePenColor := APenColor;
    FigureBrushColor := ABrushColor;
    SetLength(Points,1);
    Points[high(Points)] := APoint;
  end;
end;

procedure TTool.AddPoint(APoint: TPoint);
begin
  with Figures[high(Figures)] do begin
    SetLength(Points,length(Points)+1);
    Points[high(Points)] := APoint;
  end;
end;

procedure TTwoPointsTools.AddPoint(APoint: TPoint);
begin
  with Figures[high(Figures)] do begin
    SetLength(Points,2);
    Points[high(Points)] := APoint;
  end;
end;

procedure RegisterTool(ATool: TTool);
begin
  setlength(ToolsRegister,length(ToolsRegister)+1);
  ToolsRegister[high(ToolsRegister)] := ATool;
  ToolsRegister[high(ToolsRegister)].Bitmap := TBitmap.Create;
  ToolsRegister[high(ToolsRegister)].Bitmap.LoadFromFile(BitmapFiles[high(ToolsRegister)]);
end;

procedure TTool.AddBitmap(s: string; AtoolClass: TToolClass);
var
  tool: TTool;
begin
  tool := AToolClass.Create;
  tool.Bitmap := TBitmap.Create;
  tool.Bitmap.LoadFromFile(s);
end;

initialization
AssignFile(ToolBitmapsFile,'bitmaps.txt');
reset(ToolBitmapsFile);
while not eof(ToolBitmapsFile) do
begin
  setlength(BitmapFiles,length(BitmapFiles)+1);
  readln(ToolBitmapsFile,BitmapFiles[high(BitmapFiles)]);
end;
CloseFile(ToolBitmapsFile);
RegisterTool (TPolylineTool.Create);
RegisterTool (TRectangleTool.Create);
RegisterTool (TEllipseTool.Create);
RegisterTool (TLineTool.Create);
end.


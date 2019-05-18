unit UBrowsebySector;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, Grids, StdCtrls, Spin;

type
  TBrows_Sect_Form = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Label1: TLabel;
    Panel3: TPanel;
    SpinEdit1: TSpinEdit;
    Button1: TButton;
    ComboBox1: TComboBox;
    DrawGrid1: TDrawGrid;
    procedure FormCreate(Sender: TObject);
    procedure SpinEdit1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure DrawGrid1DrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure DrawGrid1SelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
  private
    { Private declarations }
    Descriptor : Cardinal;
    GBuffer    : Pointer;
    TmpHi      : Cardinal;
    BPS        : integer;
  public
    { Public declarations }
     Procedure SectorView(HFile : Cardinal; Buffer : Pointer; BytePerSect : integer);
  end;

var
  Brows_Sect_Form: TBrows_Sect_Form;

implementation

{$R *.dfm}
 Procedure TBrows_Sect_Form.SectorView(HFile : Cardinal; Buffer : Pointer; BytePerSect : integer);
   var
     i, row, col : integer;
 begin
   BPS                  := BytePerSect;
   GBuffer              := Buffer;
   Descriptor           := HFile;
   DrawGrid1.RowCount   := (BytePerSect div 16) + 1;
   DrawGrid1.ColCount   := 16 + DrawGrid1.FixedCols;
   DrawGrid1.Canvas.Font.Color := clblack;
   DrawGrid1.Canvas.Pen.Color  := clblack;
   DrawGrid1.Repaint;
  (* for I := 1 to 16 do
    begin
      DrawGrid1.Canvas.Brush.Color := clbtnface;
      DrawGrid1.Canvas.Rectangle(DrawGrid1.CellRect(DrawGrid1.FixedCols + (i-1), 0));
      DrawGrid1.Canvas.TextOut(
       DrawGrid1.CellRect(DrawGrid1.FixedCols + (i-1), 0).Left + 2,
       DrawGrid1.CellRect(DrawGrid1.FixedCols + (i-1), 0).Top + 2,
       inttohex(i-1, 2));
    end;
   for I := 1 to DrawGrid1.RowCount do
    begin
       DrawGrid1.Canvas.TextOut(
       DrawGrid1.CellRect(0, DrawGrid1.FixedRows + (i-1)).Left,
       DrawGrid1.CellRect(0, DrawGrid1.FixedRows + (i-1)).Top,
       inttohex((i-1)*16, 2));
    end;

   For I := 1 to BytePerSect do
     begin
       Col := (I mod 16);
       if Col = 0 then Col := 16;
       Row := (I div 16) + 1;
       if I mod 16 = 0 then Row := Row - 1;
       if ComboBox1.ItemIndex = 0 then
         begin
           DrawGrid1.Canvas.Brush.Color := clbtnface;
           DrawGrid1.Canvas.Rectangle(DrawGrid1.CellRect(Col, Row));
           //
           DrawGrid1.Canvas.TextOut(
            DrawGrid1.CellRect(Col, Row).Left,
            DrawGrid1.CellRect(Col, Row).Top,
            IntToHex(Byte(Pointer(DWORD(Buffer) + (i-1))^), 2));
         end;
       if ComboBox1.ItemIndex = 1 then
         begin
           DrawGrid1.Canvas.Brush.Color := clbtnface;
           DrawGrid1.Canvas.Rectangle(
             DrawGrid1.CellRect(Col, Row).Left + 1,
             DrawGrid1.CellRect(Col, Row).TOP + 1,
             DrawGrid1.CellRect(Col, Row).Right - 1,
             DrawGrid1.CellRect(Col, Row).Bottom - 1
             );
           //
           DrawGrid1.Canvas.TextOut(
            DrawGrid1.CellRect(Col, Row).Left,
            DrawGrid1.CellRect(Col, Row).Top,
             CHR(BYTE(Pointer(
             DWORD(Buffer) + (i-1)
             )^)));
         end;
     end; *)
   exit;
 end;


procedure TBrows_Sect_Form.FormCreate(Sender: TObject);
begin
  Descriptor := INVALID_HANDLE_VALUE;
end;

procedure TBrows_Sect_Form.SpinEdit1Change(Sender: TObject);
begin
 if Length(SpinEdit1.Text) <= 0 then exit;
 if StrToIntDef(SpinEdit1.Text, -1) = -1 then
  SpinEdit1.Value := 0;
 if SpinEdit1.Value > SpinEdit1.MaxValue then
  SpinEdit1.Value := SpinEdit1.MaxValue;
  button1.Click;
end;

function __Mul(a,b: DWORD; var HiDWORD: DWORD): DWORD; // Result = LoDWORD
asm
   // EAX = a
   // EDX = b
    mul edx        // EDX = EDX * EAX
    mov [ecx],edx  // RESULT = EDX
end;

procedure TBrows_Sect_Form.Button1Click(Sender: TObject);
  Var
    numb : Cardinal;
    ofs  : Cardinal;
begin
 numb := SpinEdit1.Value;
 numb := __Mul(numb, bps, TmpHi);
 ofs  := SetFilePointer(Descriptor, numb, @TmpHi, FILE_BEGIN);
 if ofs = numb
 then
   begin
     ReadFile(Descriptor, GBuffer^, BPS, numb, nil);
     if numb <> BPS then
      begin
        exit;
      end;
     SectorView(Descriptor, GBuffer, BPS);
   end;    //
end;

procedure TBrows_Sect_Form.DrawGrid1DrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  i : integer;
begin
 i := ((ARow - 1) * 16) + ACol;
 if ACol = 0 then
 begin
   DrawGrid1.Canvas.Brush.Color := clWhite;
   DrawGrid1.Canvas.Rectangle(Rect);
   if ARow <> 0 then
   DrawGrid1.Canvas.TextOut(
            Rect.Left + 2,
            Rect.Top + 2,
            inttohex((ARow - 1) * 16, 2)); 
   exit;
 end;
 if ARow = 0 then
 begin
   DrawGrid1.Canvas.Brush.Color := clbtnface;
   DrawGrid1.Canvas.Rectangle(Rect);
   exit;
 end;
 DrawGrid1.Canvas.Brush.Color := clbtnface;
 if ACol > DrawGrid1.fixedCols - 1 then
 begin
   DrawGrid1.Font.Color := clBlack;
   if Byte(Pointer(DWORD(GBuffer) + (i-1))^) = $55 then
     DrawGrid1.Canvas.Brush.Color := clyellow;
   if Byte(Pointer(DWORD(GBuffer) + (i-1))^) = $CD then
     DrawGrid1.Canvas.Brush.Color := clred;
   if Byte(Pointer(DWORD(GBuffer) + (i-1))^) = $00 then
     DrawGrid1.Canvas.Brush.Color := clwhite;
   if Byte(Pointer(DWORD(GBuffer) + (i-1))^) = $30 then
     DrawGrid1.Canvas.Brush.Color := clGreen;
 end;

 DrawGrid1.Canvas.Rectangle(Rect);

       if ComboBox1.ItemIndex = 0 then
         begin
           //
           DrawGrid1.Canvas.TextOut(
            Rect.Left + 2,
            Rect.Top + 2,
            IntToHex(Byte(Pointer(DWORD(GBuffer) + (i-1))^), 2));
         end;
       if ComboBox1.ItemIndex = 1 then
         begin
           //
           DrawGrid1.Canvas.TextOut(
            Rect.Left + 2,
            Rect.Top + 2,
            CHR(BYTE(Pointer(DWORD(GBuffer) + (i-1))^)));
         end;
       if ComboBox1.ItemIndex = 2 then
         begin
           //
           if (ACol > 1)
           then
           begin
             if (BYTE(Pointer(DWORD(GBuffer) + (i-1))^) = $04) then
               begin
                DrawGrid1.Canvas.TextOut(
                  Rect.Left + 2,
                  Rect.Top + 2,
                  WideChar(Word(Pointer(DWORD(GBuffer) + (i-2))^)));
              end;
           end;
         end;
end;

procedure TBrows_Sect_Form.DrawGrid1SelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  CanSelect := true;
  DrawGrid1.DefaultDrawing := false;
  DrawGrid1.Repaint;
  DrawGrid1.Canvas.brush.Color := clGreen;
  DrawGrid1.Canvas.Rectangle(DrawGrid1.CellRect(0, ARow));
  DrawGrid1.Canvas.Font.Color  := clblack;
  DrawGrid1.Canvas.TextOut(
             DrawGrid1.CellRect(0, ARow).Left + 2,
             DrawGrid1.CellRect(0, ARow).Top + 2,
             inttohex((ARow - 1) * 16, 2));


//  DrawGrid1.Canvas.TextOut(
//    DrawGrid1.CellRect(0, ARow).Left,
//    DrawGrid1.CellRect(0, ARow).Top,
//    ACol
end;

end.

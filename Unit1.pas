unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  buf : array[0..512] of byte;
begin
  // .MODEL  tiny
  // .DATA

// ; �����, � ������� ����� �������� ������ ����� buf db 512 dup (?)

//  .CODE
//  .STARTUP
exit;
asm

  mov   ch, 00h   //; ����� �������
  mov   cl, 01h   //; ����� �������

  mov   dh, 00h   //; ����� �������  (������� �����)
  mov   dl, 00h   //; ����� ����, ������������
                  //; ���������� �:

//; ������� ����� ������ � ES:BX
  mov   ax, cs
  mov   es, ax

  mov   bx, OFFSET buf

//; ������� ��� �������
  mov   ah, 02h   //; ��� ������� - ������ �������
  mov   al, 01h   //; ������ 1 ������

//; �������� ����������
  //int   13h

  //.EXIT   0
END;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
form1.Caption := inttohex(ord('E'), 2);
 asm
   mov ah, $0A //; ��� ������������� ������� BIOS
   mov al, $0C4 //; ��� ASCII ������� "-"
   mov cx, 1 //; ����� ���������� �������
 end;
end;

end.

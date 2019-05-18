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

// ; Буфер, в который будет прочитан сектор диска buf db 512 dup (?)

//  .CODE
//  .STARTUP
exit;
asm

  mov   ch, 00h   //; номер дорожки
  mov   cl, 01h   //; номер сектора

  mov   dh, 00h   //; номер головки  (стороны диска)
  mov   dl, 00h   //; номер НГМД, соответсвует
                  //; устройству А:

//; Готовим адрес буфера в ES:BX
  mov   ax, cs
  mov   es, ax

  mov   bx, OFFSET buf

//; Готовим код функции
  mov   ah, 02h   //; код функции - чтение сектора
  mov   al, 01h   //; читаем 1 сектор

//; Вызываем прерывание
  //int   13h

  //.EXIT   0
END;

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
form1.Caption := inttohex(ord('E'), 2);
 asm
   mov ah, $0A //; код запрашиваемой функции BIOS
   mov al, $0C4 //; код ASCII символа "-"
   mov cx, 1 //; число повторений символа
 end;
end;

end.

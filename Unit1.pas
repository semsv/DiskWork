unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls, Spin;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ProgressBar1: TProgressBar;
    Label5: TLabel;
    Button2: TButton;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Memo1: TMemo;
    Label9: TLabel;
    Button3: TButton;
    OpenDialog1: TOpenDialog;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    SpinEdit1: TSpinEdit;
    SpinEdit2: TSpinEdit;
    SpinEdit3: TSpinEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure USB_ATTACH(var Msg : Cardinal);
      message WM_DEVICECHANGE;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
const
  SE_CREATE_TOKEN_NAME = 'SeCreateTokenPrivilege';
  SE_ASSIGNPRIMARYTOKEN_NAME = 'SeAssignPrimaryTokenPrivilege';
  SE_LOCK_MEMORY_NAME = 'SeLockMemoryPrivilege';
  SE_INCREASE_QUOTA_NAME = 'SeIncreaseQuotaPrivilege';
  SE_UNSOLICITED_INPUT_NAME = 'SeUnsolicitedInputPrivilege';
  SE_MACHINE_ACCOUNT_NAME = 'SeMachineAccountPrivilege';
  SE_TCB_NAME = 'SeTcbPrivilege';
  SE_SECURITY_NAME = 'SeSecurityPrivilege';
  SE_TAKE_OWNERSHIP_NAME = 'SeTakeOwnershipPrivilege';
  SE_LOAD_DRIVER_NAME = 'SeLoadDriverPrivilege';
  SE_SYSTEM_PROFILE_NAME = 'SeSystemProfilePrivilege';
  SE_SYSTEMTIME_NAME = 'SeSystemtimePrivilege';
  SE_PROF_SINGLE_PROCESS_NAME = 'SeProfileSingleProcessPrivilege';
  SE_INC_BASE_PRIORITY_NAME = 'SeIncreaseBasePriorityPrivilege';
  SE_CREATE_PAGEFILE_NAME = 'SeCreatePagefilePrivilege';
  SE_CREATE_PERMANENT_NAME = 'SeCreatePermanentPrivilege';
  SE_BACKUP_NAME = 'SeBackupPrivilege';
  SE_RESTORE_NAME = 'SeRestorePrivilege';
  SE_SHUTDOWN_NAME = 'SeShutdownPrivilege';
  SE_DEBUG_NAME = 'SeDebugPrivilege';
  SE_AUDIT_NAME = 'SeAuditPrivilege';
  SE_SYSTEM_ENVIRONMENT_NAME = 'SeSystemEnvironmentPrivilege';
  SE_CHANGE_NOTIFY_NAME = 'SeChangeNotifyPrivilege';
  SE_REMOTE_SHUTDOWN_NAME = 'SeRemoteShutdownPrivilege';

function AdjustPriviliges(const PrivelegStr: string): Bool; forward;
implementation
  uses UBrowsebySector, shellApi;
{$R *.dfm}
 Var
  secperclu,         // кол-во секторов в кластере
  bpersec,           // кол-во байт в секторе
  freeclu,
  numclu : Cardinal; // общее число кластеров

  Stop_find    : Boolean = false;
  Break_find   : Boolean = false;
  Stop_sectors : Cardinal = 0;
  FlashHandle  : array ['A'..'Z'] of cardinal;
  GBuffer      : Pointer;
 function AdjustPriviliges(const PrivelegStr: string): Bool;
var
  hTok: THandle;
  tp: TTokenPrivileges;
begin
  Result := False;
  // Get the current process token handle so we can get privilege.
  if OpenProcessToken(GetCurrentProcess, TOKEN_ADJUST_PRIVILEGES + TOKEN_QUERY,
    hTok) then
  try
    // Get the LUID for privilege.
    if LookupPrivilegeValue(nil, PChar(PrivelegStr), tp.Privileges[0].Luid) then
    begin
      tp.PrivilegeCount := 1; // one privilege to set
      tp.Privileges[0].Attributes := tp.Privileges[0].Attributes or SE_PRIVILEGE_ENABLED;
      // Get privilege for this process.
      Result := AdjustTokenPrivileges(hTok, False, tp, 0,
        PTokenPrivileges(nil)^, PDWord(nil)^)
    end
  finally
    // Cannot test the return value of AdjustTokenPrivileges.
   // if (GetLastError <> ERROR_SUCCESS) then
   //   raise Exception.Create('AdjustTokenPrivileges enable failed');
    CloseHandle(hTok)
  end
  else
    raise Exception.Create('OpenProcessToken failed');
end;

 function __Mul(a,b: DWORD; var HiDWORD: DWORD): DWORD; // Result = LoDWORD
  asm
   // EAX = a
   // EDX = b
    mul edx        // EDX = EDX * EAX
    mov [ecx],edx  // RESULT = EDX
  end;

procedure TForm1.USB_ATTACH(var Msg : Cardinal);
  var
    hFile : Cardinal;
    Drive : Char;
begin
  for Drive := 'A' to 'Z' do
  begin
    if FlashHandle[Drive] = INVALID_HANDLE_VALUE then
    begin
      hFile := CreateFile(PChar('\\.\' + Drive + ':'),
        GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ, nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL, 0);
      if hFile <> INVALID_HANDLE_VALUE then
        FlashHandle[Drive] := hFile;
    end;
  end;
  sleep(0);
end;

Function GET_DISK_STRUCTURE(p : pointer) : String;
  Var
    S : String[8];
    i : integer;
    b : Byte;
begin
  for i := 0 to 7 do
  begin
    b := Byte(POINTER(DWORD(p)+ $52 + i)^);
    if  b = 13  then break;
    if  b = 10  then break;
    if  not
       ((b in [ord('a')..ord('z')]) or
       (b in [ord('A')..ord('Z')]) or
       (b in [ord('0')..ord('9')]) or
       (b in [ord(' '), ord('\')])) then break;
      s :=  s + CHAR(POINTER(DWORD(p)+ $52 + i)^) ;
  end;



  result :=
  Inttohex(BYTE(POINTER(DWORD(p)+ 0)^), 1) +
      Inttohex(BYTE(POINTER(DWORD(p)+ 1)^), 1) +
      Inttohex(BYTE(POINTER(DWORD(p)+ 2)^), 1) + ' ' + #13#10 + #13#10 +
      CHR(BYTE(POINTER(DWORD(p)+ 3)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ 4)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ 5)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ 6)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ 7)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ 8)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ 9)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ 10)^)) + #13#10 +
      ' byte per sector=' +
      inttostr(WORD(POINTER(DWORD(p) + $0b)^)) + ' ' + #13#10 +
      ' sector per cluster=' +
      inttostr(byte(POINTER(DWORD(p) + $0d)^)) + '  ' + #13#10 +
      ' Reserved Sectors=' +
      inttostr(WORD(POINTER(DWORD(p) + $0e)^)) + '  ' + #13#10 +
      ' Number of Copies of FAT=' +
      inttostr(byte(POINTER(DWORD(p) + $10)^)) + '  ' + #13#10 +
      ' Maximum Root Directory Entries (N/A for FAT32)=' +
      inttostr(WORD(POINTER(DWORD(p) + $11)^)) + '  ' + #13#10 +
      ' Number of Sectors in Partition Smaller than 32MB (N/A for FAT32)=' +
      inttostr(WORD(POINTER(DWORD(p) + $13)^)) + '  ' + #13#10 +
      ' Media Descriptor (F8h for Hard Disks)=$' +
      inttohex(byte(POINTER(DWORD(p) + $15)^), 2) + '  ' + #13#10 +
      ' Sectors Per FAT in Older FAT Systems (N/A for FAT32)=' +
      inttostr(WORD(POINTER(DWORD(p) + $16)^)) + '  ' + #13#10 +
      ' Sectors Per Track=' +
      inttostr(WORD(POINTER(DWORD(p) + $18)^)) + '  ' + #13#10 +
      ' Number of Heads=' +
      inttostr(WORD(POINTER(DWORD(p) + $1A)^)) + '  ' + #13#10 +
      ' Number of Hidden Sectors in Partition='  +
      inttostr(DWORD(POINTER(DWORD(p) + $1C)^)) + '  ' + #13#10 +
      ' Number of Sectors in Partition=' +
      inttostr(DWORD(POINTER(DWORD(p) + $20)^)) + '  ' + #13#10 +
      ' Number of Sectors Per FAT=' +
      inttostr(DWORD(POINTER(DWORD(p) + $24)^)) + '  ' + #13#10 +
      ' Cluster Number of the Start of the Root Directory='+
      inttostr(DWORD(POINTER(DWORD(p) + $2C)^)) + '  ' + #13#10 +
      ' Logical Drive Number of Partition=' +
      inttostr(byte(POINTER(DWORD(p) + $40)^)) + '  ' + #13#10 +
      ' Serial Number of Partition=' +
      inttohex(DWORD(POINTER(DWORD(p) + $43)^), 4) + '  ' + #13#10 +
      CHR(BYTE(POINTER(DWORD(p)+ $47)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ $48)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ $49)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ $4A)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ $4B)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ $4C)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ $4D)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ $4E)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ $4F)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ $50)^)) +
      CHR(BYTE(POINTER(DWORD(p)+ $51)^)) + #13#10 +
      s + #13#10;
end;

function FindMarkerW(ID : WORD; Buf : POINTER; Len : Cardinal) : boolean;
  Var
    I : Integer;
begin
  result := false;
  For I := 1 to Len-1 do
    begin
      if WORD(POINTER(DWORD(Buf) + I)^) = ID then
       begin
         result := true;
         exit;
       end;  
    end;
end;

procedure TForm1.Button1Click(Sender: TObject);
 Var
  hFile    : Cardinal;
//  Drive    : Byte;
  S        : String;
//  FileSize : comp;
  numb     : Cardinal;
  TmpLo    : Cardinal;
  TmpHi    : Cardinal;
  Buffer   : Pointer;
{}
  _CurSectors : DWORD;
  i, j        : integer;
  p           : pointer;
  sec_offset  : cardinal;
  name_tmp1   : String;
  i_tmp1      : Integer;
  itmopen     : boolean;
  f           : File;
{}
begin
{}
 i_tmp1     := 1;
 itmopen    := false;
 sec_offset := Stop_sectors + 3380240;
 S          := Copy(Edit1.Text, 1, 2);
{}
// FileSize := 0;
 if (SpinEdit1.Value = 0) or
    (SpinEdit2.Value = 0) or
    (SpinEdit3.Value = 0) then
 GetDiskFreeSpace(PChar(S), secperclu, bpersec, freeclu, numclu)
 else
 begin
   secperclu  := SpinEdit1.Value;
   bpersec    := SpinEdit2.Value;
   numclu     := SpinEdit3.Value;
 end;
 Label4.Caption := inttostr(bpersec) + '*' + inttostr(secperclu) + '*' + inttostr(numclu);
{}
 hFile := CreateFile(PChar('\\.\' + S),
    GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
 Label2.Caption := 'Нет дескриптора !';
  if hFile = INVALID_HANDLE_VALUE then Exit;
 Label2.Caption := 'Дескриптор получен !';
 sleep(0);
{}
 Buffer := AllocMem(bpersec);
 Stop_find := false;
{}
 Label8.Caption := inttostr(numclu*secperclu);
{}
 Memo1.Lines.Add('--- Поиск копий загрузочных областей на диске (' + S +') ' + 'начат: ' + timetostr(time) + ' ---');
{}
 try
 Button1.Enabled := false;
 Button6.Enabled := false;
 Button2.Enabled := true;
 Button7.Enabled := true;
{}
 ProgressBar1.Position := 0;
 ProgressBar1.Min := 0;
 ProgressBar1.Max := numclu;
 Application.ProcessMessages;
{}                      // 414E204F
 For J := 1 to numclu do       // Цикл по кластерам
 For i := 1 to secperclu do    // Цикл считывает один кластер
  begin
  {}
   _CurSectors  := sec_offset + (i-1)+((j-1)*Integer(secperclu));
   Stop_sectors := _CurSectors;
   TmpLo := __Mul(_CurSectors, bpersec, TmpHi);
   if SetFilePointer(hFile,TmpLo,@TmpHi,FILE_BEGIN) = TmpLo then
    begin
     ReadFile(hFile, Buffer^, bpersec, numb, nil);
     Label9.Caption := 'Считано байт из текущего сектора: ' + inttostr(numb);

  {}if (_CurSectors = 0) then begin
     Buffer := POINTER(DWORD(Buffer) +  0);
     p      := POINTER(DWORD(Buffer) +  0);
     memo1.Lines.Add(GET_DISK_STRUCTURE(p));
     Memo1.Lines.add('');
     {}
     end;
     if (WORD(Buffer^)<>$0000) then
       begin
        // Memo1.Lines.add('Найдены данные в секторe: ' + inttostr(_CurSectors));
        // messagebox(form1.Handle, '', '', 0);
         {}
       end;

     if itmopen then
      begin
        BlockWrite(F, Buffer^, numb);
      end;

     if FindMarkerW($D9FF, Buffer, numb) then
     begin
       if itmopen then
         begin
           CloseFile(f);
           itmopen := false;
         end;
      // exit;
     end;

     if (DWORD(POINTER(DWORD(Buffer) + 0)^)=$E1FFD8FF) or
        (DWORD(POINTER(DWORD(Buffer) + 0)^)=$E0FFD8FF) then
       begin
         Memo1.Lines.add('Найден файл картинка, сектор: ' + inttostr(_CurSectors));
         if itmopen then
           begin
             CloseFile(f);
             itmopen := false;
           end;
         name_tmp1  := 'F:\recover_jpg\' + inttostr(i_tmp1) + '.jpg';
         AssignFile(f, name_tmp1);
         Rewrite(F, 1);
         BlockWrite(F, Buffer^, numb);
         i_tmp1 := i_tmp1 + 1;
         itmopen := true;
       end;

     if (WORD(POINTER(DWORD(Buffer) + 0)^)=$5D4A) then
       begin
         Memo1.Lines.add('Найден Exe файл, сектор: ' + inttostr(_CurSectors));
      //   Memo1.Lines.add('Найдена загрузочная запись, сектор: ' + inttostr(_CurSectors));
      //   messagebox(form1.Handle, '', '', 0);
       end;

     Buffer := POINTER(DWORD(Buffer) -  0);
    end;
  {}
   if (ProgressBar1.Position <> J) then
    begin
    {}
     ProgressBar1.Position := J;
     Application.ProcessMessages;
     Label5.Caption := inttostr(_CurSectors);
    {}
    end;
  {}
   if Stop_find then begin  Stop_sectors := 0; exit; end;
   if Break_find then begin exit; end;
  {}
  end;
{}
 finally
{}
 CloseHandle(hFile);
 if itmopen then CloseFile(F);
 FreeMem(Buffer);
{}
 if not Break_find then
   begin
     Button1.Enabled := true;
     Button2.Enabled := false;
   end;  
 Button7.Enabled := false;
{}
 Memo1.Lines.Add('--- Поиск копий загрузочных областей на диске (' + S +') ' + 'закончен: ' + timetostr(time) + ' ---'); 
{}
 end;
{} 
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
{}
 Button1.Enabled := true;
 Button6.Enabled := false;
 Button7.Enabled := false;
 Button2.Enabled := false;
 if Break_find then Stop_sectors := 0;
 Break_find   := false;
 Stop_find    := true;
 application.ProcessMessages;
{}
end;

procedure TForm1.Button3Click(Sender: TObject);
var
   hFile,
   sourceFile :cardinal;
   S          : String;
   numb     : Cardinal;
   Buffer   : Pointer;
{}
   fs       : integer;
   TmpLo    : Cardinal;
   TmpHi    : Cardinal;
   ovr      : _OVERLAPPED;
   hackbuf  : pointer;
   a        : pbyte;
   i        : integer;
   offsetcode : dword;
   JumpF      : dword;
   chr_       :char;
{}
begin
 S     := Copy(Edit1.Text, 1, 2);
 GetDiskFreeSpace(PChar(S), secperclu, bpersec, freeclu, numclu);
 hFile := CreateFile(PChar('\\.\' + s),
    GENERIC_READ or GENERIC_WRITE, FILE_SHARE_READ, nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL, 0);
 Label2.Caption := 'Нет дескриптора !';
  if hFile = INVALID_HANDLE_VALUE then
    begin
      chr_ := Copy(S, 1, 1)[1];
      if ORD(UpperCase(chr_)[1]) in [ORD('A')..Ord('Z')] then
      if FlashHandle[UpperCase(Copy(S, 1, 1))[1]] = INVALID_HANDLE_VALUE then Exit;
        hFile := FlashHandle[UpperCase(Copy(S, 1, 1))[1]];
    end;
 Label2.Caption := 'Дескриптор получен !';
 sleep(0);
 {}
  if not  OpenDialog1.Execute then
    begin
      Application.ProcessMessages;
      if hFile <> INVALID_HANDLE_VALUE then
      CloseHandle(hFile);
      exit;
    end;
 {}
 s  := OpenDialog1.FileName;

 sourceFile := CreateFile(PChar(s),
 GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_EXISTING,0,0);

 Label2.Caption := 'Нет дескриптора файла источника!';
  if sourceFile = INVALID_HANDLE_VALUE then Exit;
 Label2.Caption := 'Дескриптор файла источника получен !';
 {}
   fs     := windows.GetFileSize(sourceFile, nil);
   Buffer := AllocMem(fs);
   form1.Caption := inttostr(WORD(Buffer^));
   ReadFile(sourceFile, Buffer^, fs, numb, nil);
   form1.Caption := inttohex(WORD(Buffer^), 4);
   Buffer := POINTER(DWORD(Buffer) +  2);
   form1.Caption := inttohex(WORD(Buffer^), 4);
   Buffer := POINTER(DWORD(Buffer) -  2);
   hackbuf := AllocMem(512);
   if numb <> 0 then
   begin
      TmpLo := __Mul(0, bpersec, TmpHi);
      if SetFilePointer(hFile,TmpLo,@TmpHi,FILE_BEGIN) = TmpLo then
        begin
          numb := 0;
          // Читаем загрузочный сектор
          readFile(hFile, hackbuf^, bpersec, numb, nil);
          // Проверяем типичный джамп на начало кода
          JumpF := Byte(Pointer(DWORD(hackbuf) + 0)^) or
                   Byte(Pointer(DWORD(hackbuf) + 2)^) shl 8;
          form1.Caption := inttohex(JumpF, 4);
       //
       if JumpF = $90EB then
       begin
         offsetcode := Byte(Pointer(DWORD(hackbuf) + 1)^);
       end else
       begin
         messageBox(Form1.Handle, 'Неудалось определить смещения начала кода загрузчика', 'Ошибка', MB_ICONERROR);
         CloseHandle(hFile);
         CloseHandle(sourceFile);
         FreeMem(Buffer);
         FreeMem(hackbuf);
         exit;
       end;

       if fs + offsetcode >= 512-2 then
       begin
         messageBox(Form1.Handle, 'Файл кода загрузчика слишком большой!', 'Ошибка', MB_ICONERROR);
         CloseHandle(hFile);
         CloseHandle(sourceFile);
         FreeMem(Buffer);
         FreeMem(hackbuf);
         exit;
       end;

       for i := 1 to fs do
         begin
           a  := Pointer(DWORD(hackbuf) + offsetcode + (i-1));
           a^ := Byte(Pointer(DWORD(Buffer) + 0 + (i-1))^);
         end;

      if SetFilePointer(hFile,TmpLo,@TmpHi,FILE_BEGIN) = TmpLo then
        begin
          Application.ProcessMessages;
          WriteFile(hFile, hackbuf^, 512, numb, nil); // запись загрузочной программы
          messagebox(form1.Handle, Pchar('File Successed ' + inttostr(numb) + 'bytes write!'), 'Message', 0);
        end;
        end;
   end;
(* For J := 1 to numclu do       // Цикл по кластерам
   For i := 1 to secperclu do    // Цикл считывает один кластер
     begin
     {}
      _CurSectors := (i-1)+((j-1)*Integer(secperclu));
      TmpLo := __Mul(_CurSectors, bpersec, TmpHi);
      if SetFilePointer(hFile,TmpLo,@TmpHi,FILE_BEGIN) = TmpLo then
        begin
        end;
     end; *)
 {}
 CloseHandle(hFile);
 CloseHandle(sourceFile);
 FreeMem(Buffer);
 FreeMem(hackbuf);
end;

Procedure CylSecDecode(Var Cylinder, Sector : Word; CylSec : Word); Begin Cylinder := Hi(CylSec) or ((Lo(CylSec) and $C0) shl 2); Sector := (CylSec and $3F); End;

procedure TForm1.Button4Click(Sender: TObject);
  var
   S     : String;
   hFile : Cardinal;
   numb  : Cardinal;
begin
// $2104 $3504
//  asm
//    add dl, cl
//  end;
//    DB $EB
//    DB $3C
//    DB $90
//  end;
//  CylSecDecode(C, S, $3b29);
//  form1.Caption := inttohex(ORD('E') ,2) + inttohex(c, 4) + ' ' + inttohex(s, 4);


 S          := Copy(Edit1.Text, 1, 2);
  if (SpinEdit1.Value = 0) or
    (SpinEdit2.Value = 0) or
    (SpinEdit3.Value = 0) then
 begin
   if not GetDiskFreeSpace(PChar(S), secperclu, bpersec, freeclu, numclu) then
    begin
      messageBox(handle, 'Не удалось определить размер диска! Вы можете задать его самостоятельно', 'Ошибка', MB_ICONERROR);
    end;
 end
 else
 begin
   secperclu  := SpinEdit1.Value;
   bpersec    := SpinEdit2.Value;
   numclu     := SpinEdit3.Value;
 end;
   hFile := CreateFile(PChar('\\.\' + S),
      GENERIC_READ, FILE_SHARE_READ or FILE_SHARE_WRITE,nil,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
 if not Assigned(GBuffer) then
 GBuffer := allocmem(bpersec);
 ReadFile(hFile, GBuffer^, bpersec, numb, nil);
 if numb = 0 then exit;
 Brows_Sect_Form.SpinEdit1.MaxValue := numclu * secperclu;
 Brows_Sect_Form.Label1.Caption     := GET_DISK_STRUCTURE(GBuffer);
 Brows_Sect_Form.SectorView(HFile, GBuffer, bpersec);
 Brows_Sect_Form.ShowModal;
 CloseHandle(hFile);
 FreeMem(GBuffer);
 GBuffer := nil;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  memo1.Clear;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  Button1.Enabled := false;
  Button2.Enabled := true;
  Button6.Enabled := true;
  Button7.Enabled := false;
  Break_find := true;
  application.ProcessMessages;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
 Break_find := false;
 button1.Click;
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
  Button7.Click;
end;

procedure TForm1.FormCreate(Sender: TObject);
 const GlobMapID = 'DiskWork_kiberdog_001_tmp';
 type
 TShareInf = record
   Field : DWORD;
 end;
 PShareInf  = ^TShareInf;
 var
 Drive       : Char;
 SEI         : TShellExecuteInfo;
 lpExitCode  : DWORD;
 hMapping    : Cardinal;
 numb        : Cardinal;
 ShareInf    : PShareInf;
begin
 //exit;
 // Создаем файловый маппинг и проецируем его
 // По сути это некая область оперативной памяти доступная любому приложению
 // которое знает идентификатор (GlobMapID) и
 // откроет этот файловый маппинг след двумя строками кода
 hMapping  := windows.CreateFileMapping(INVALID_HANDLE_VALUE, nil, PAGE_READWRITE, 0, SizeOf(TShareInf), GlobMapID);
 ShareInf  := MapViewOfFile(hMapping, FILE_MAP_ALL_ACCESS, 0, 0, SizeOf(TShareInf));
 // Теперь если все успешно выполнилось любая запись информации
 // в ShareInf будет в оперативной памяти и будет доступна любому приложению
 if hMapping <> INVALID_HANDLE_VALUE then
 begin
  form1.Caption := inttostr(ShareInf^.Field);
  if ShareInf^.Field <> $4D5A4D5A then
  begin
   ShareInf^.Field := $4D5A4D5A;
   ZeroMemory(@SEI, SizeOf(SEI));
   SEI.cbSize := SizeOf(TShellExecuteInfo);
   SEI.Wnd := Handle;
   SEI.fMask := SEE_MASK_FLAG_DDEWAIT or SEE_MASK_FLAG_NO_UI;
   SEI.lpVerb := PChar('runas');
   SEI.lpFile := PChar(Application.ExeName);
   SEI.nShow := SW_SHOWNORMAL;
   SEI.lpParameters:= 'Для доступа к некоторым дискам нужны права администратора!';
   if ShellExecuteEx(@SEI) then
     begin
       Application.Terminate;
     end;
  end;
 end;
  // след 3 строки кода = По сути лишние действия которые на функциональность пока не влияют   
  AdjustPriviliges(SE_SHUTDOWN_NAME);
  AdjustPriviliges(SE_LOAD_DRIVER_NAME);
  AdjustPriviliges(SE_LOCK_MEMORY_NAME);
  // Здесь идет инициализация массива для перехвата событий горячего подключения устройств
  for Drive := 'A' to 'Z' do
    FlashHandle[Drive] := INVALID_HANDLE_VALUE;
  form1.Close;
end;

end.

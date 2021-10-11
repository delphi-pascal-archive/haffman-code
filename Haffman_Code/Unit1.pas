unit Unit1;

{$H+}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Grids, XPMan, Math;

type
  TForm1 = class(TForm)
    Button1: TButton;
    OpenDialog1: TOpenDialog;
    SG1: TStringGrid;
    Button2: TButton;
    StringGrid1: TStringGrid;
    Button3: TButton;
    SaveDialog1: TSaveDialog;
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

TStr = string[20];
TKey = string[1];
TStack = array[0..65000] of TKey;

TPElSp = ^TElSp;
TElSp = record
  key: byte;
  cnt: cardinal;
  next: TPElSp;
  end;

TPArNode = ^TArNode;
TArNode = record
  value: real;
  kod: TKey;
  left: TPArNode;
  right: TPArNode;
  parent: TPArNode;
  symb: byte;
  end;

TTree = record
  key: byte;
  cnt: cardinal;
  huff: TStr;
  n0: extended;
  deep: boolean;
  st_tree: TPArNode;
  end;

TArTree = array of TTree;

TFileRec = record
  key: byte;
  kod: byte;
  size_kod: byte;
  end;

TGetFile = record
  key: byte;
  kod: string[16];
  size_kod: byte;
  end;

TArFRec = array of TGetFile;

var
  stack: TStack;
  PBS: integer;
  Form1: TForm1;
  head_lsp: TPElSp;
  f, fo: file;
  size, tmpi, cnti: byte;
  a, atmp: TArTree;
  n: int64;
  head_tree: TPArNode;
  okk: boolean;
implementation

{$R *.dfm}

procedure Push(key: TKey);
begin
 stack[PBS]:= key;
 inc(PBS);
end;

procedure Pop(var key: TKey);
begin
 dec(PBS);
 key:= stack[PBS];
end;

procedure AddEl(var start: TPElSp; PNew: TPElSp);
var
 WP: TPElSp;
begin
 PNew^.next:= nil;
 if start = nil then start:= PNew
 else
  begin
  WP:= start;
  while WP^.next <> nil do
   WP:= WP^.next;
  WP^.next:= PNew;
end;
end;

function FindEl(start: TPElSp; key: byte; var FindPoint: TPElSp): boolean;
begin
 if start = nil then
 begin
  result:= false;
  exit;
 end;
 result:= false;
 FindPoint:= start;
 while (FindPoint <> nil) and (FindPoint^.key <> key) do
  begin
  findpoint:= findpoint^.next;
  end;
  if (findpoint <> nil) then result:= true;
end;

function FindElMax(start: TPElSp; var FindPoint: TPElSp): boolean;
var
 PrevPoint: TPElSp;
begin
 if start = nil then
 begin
  result:= false;
  exit;
 end;
 FindPoint:= start;
 PrevPoint:= start^.next;
 while (PrevPoint <> nil) do
  begin
  if PrevPoint^.cnt > FindPoint^.cnt then
   FindPoint:= PrevPoint;
  Prevpoint:= PrevPoint^.next;
  end;
  result:= true;
end;

procedure DelEl(var start: TPElSp; key: byte);
var
PrevPoint, WPoint: TPElSp;
begin
if start = nil then exit;
 prevpoint:= nil;
 wpoint:= start;
 while (wpoint <> nil) and (wpoint^.key <> key) do
 begin
  prevpoint:= wpoint;
  wpoint:= wpoint^.next;
 end;
 if (wpoint = nil) or (wpoint^.key > ord(key)) then
 exit;
 if prevpoint = nil then
  start:= start^.next
 else
  prevpoint^.next:= wpoint^.next;
  Dispose(Wpoint);
end;

procedure DelSp(var head: TPElSp);
var
 w: TPElSp;
begin
  if head = nil then exit;
  while (head <> nil) do
  begin
  w:= head;
  head:= head^.next;
  Dispose(w);
  end;
end;

function FindMin(a: TArTree; size: integer): integer;
var
 z, i: integer; min: extended; ok: boolean;
begin
 ok:= false;
 for z:= size-1 downto 0 do
 begin
  if a[z].deep <> true then
  begin
  min:= a[z].n0;
  result:= z;
  ok:= true;
  i:= z-1;
  end;
  if ok = true then
   break;
 end;
  for z:= i downto 0 do
   if (a[z].n0 < min) and (a[z].deep <> true) then
   begin
    min:= a[z].n0;
    result:= z;
   end;
end;

function StrBToInt(bin: string): byte;
var
i: integer; v: byte;
begin
  v:= 0;
  result:= 0;
  for i:=length(bin) downto 1 do
  begin
    result:= result + StrToInt(bin[i]) * StrToInt(FloatToStr(exp(ln(2)*v)));
    inc(v);
  end;
end;

function IntToStrB(in_int: byte): string;
var
 k: TKey;
 t1, t2: byte;
begin
  PBS:= 0;
  t1:= in_int;
  t2:= in_int;
  result:= '';
  while (t2 <> 1) and (t2 <> 0) do
  begin
   t1:= t2 mod 2;
   k:= IntToStr(t1);
   push(k);
   t2:= t2 div 2;
  end;
   k:= IntToStr(t2);
   push(k);
  while (PBS <> 0) do
  begin
   pop(k);
   result:= result + k;
  end;
end;

function FindElAr(ar: TArTree; size: byte; key: byte): byte;
var
 i: integer;
begin
 for i:= 0 to size-1 do
  if ar[i].key = key then
  begin
   result:= i;
   exit;
  end;
end;

function FindElArF(ar: TArFRec; size: byte; key: byte): byte;
var
 i: integer;
begin
 for i:= 0 to size-1 do
  if ar[i].key = key then
  begin
   result:= i;
   exit;
  end;
end;


procedure reverse(var pesn: TStr);
var
 i: integer; tmp: char;
begin
for i:=1 to (length(pesn) div 2) do
begin
    tmp:=pesn[i];
    pesn[i]:=pesn[length(pesn)-i+1];
    pesn[length(pesn)-i+1]:= tmp;
end;
end;

procedure CreateKod(head: TPArNode; var ar: TArTree; size: byte);
var
 k: TKey;
begin
 if (head = nil) then exit;
   push(head^.kod);
   CreateKod(head^.left, ar, size);
   tmpi:= FindElAr(ar, size, head^.symb);
   cnti:=0;
   while (PBS<>0) do
   begin
    inc(cnti);
    pop(k);
    ar[tmpi].huff:= ar[tmpi].huff + k;
   end;
   reverse(ar[tmpi].huff);
   PBS:= PBS + cnti;
   CreateKod(head^.right, ar, size);
   dec(PBS);
end;

procedure GetNode(a: TArTree; size: integer);
var
 tmp: TPArNode;
begin
 tmp:= a[size-1].st_tree;
 while (tmp^.parent <> nil) do
  tmp:= tmp^.parent;
 head_tree:= tmp;
end;

function EndHaffman(a: TArTree; size: integer): extended;
var
 tmp: TPArNode;
begin
 tmp:= a[size-1].st_tree;
 while (tmp^.parent <> nil) do
  tmp:= tmp^.parent;
 result:= tmp^.value;
end;

procedure OptimizeKod(var ar: TArTree; size: byte);
var
 i, j: integer; ok: boolean; str: string; news, tmp: string[1];
begin
 for i:= 0 to size-1 do
 begin
  ok:= true;
  SetLength(str, length(ar[i].huff));
  str:= ar[i].huff;
  tmp:= str[1];
  if tmp = '0' then
  begin
   for j:=1 to length(str) do
    if (str[j] <> '0') then
     ok:= false;
   end else
     ok:= false;
   if ok then
   begin
   SetLength(news, length(ar[i].huff));
   for j:=1 to length(ar[i].huff) do
    news[j]:= '1';
    ar[i].huff:= news;
   end;
 end;
end;

function GetText(ar: TArTree; size: byte): widestring;
var
 i: byte;
begin
result:= '';
 for i:= 0 to size-1 do
  result:= result + a[i].huff;
end;

procedure Countall(a: TArTree; size: byte);
var
 i: integer;
 H, Hmax, LiPi, Kss, Koe: real;
begin
  Hmax:= log2(size);
  H:= 0;
  LiPi:= 0;
  for i:= 0 to size - 1 do
  begin
   H:= H + a[i].n0 * log2(a[i].n0);
   LiPi:= LiPi + length(a[i].huff) * a[i].n0;
  end;
  H:= (-1)*H;
  liPi:= log2(LiPi);
  Kss:= Hmax / LiPi;
  Koe:= H / LiPi;
  Form1.StringGrid1.Cells[1,0]:= FloatToStr(Hmax);
  Form1.StringGrid1.Cells[1,1]:= FloatToStr(H);
  Form1.StringGrid1.Cells[1,2]:= FloatToStr(LiPi);
  Form1.StringGrid1.Cells[1,3]:= FloatToStr(Kss);
  Form1.StringGrid1.Cells[1,4]:= FloatToStr(Koe);
end;

procedure TForm1.Button1Click(Sender: TObject);
var
 s, tmps: string;
 tmp: char;
 i, i1, i2, j: cardinal;
 tpos: integer;
 El, tel: TPElSp;
 ElTree, tmp1, tmp2: TPArNode;
 lvl, outkod, inkod: word;
 f1, H, LiPi: extended;
 rec: TFileRec;
 res: widestring;
 str: string;
 chk: byte;
begin
  Opendialog1.FilterIndex:= 1;
  head_lsp:= nil;
  head_tree:= nil;
  size:= 0;
  n:= 0;
  PBS:= 0;
  SetLength(a, 0);
  OpenDialog1.Execute;
  if OpenDialog1.FileName = '' then
  begin
    ShowMessage('Не выбран файл!');
    exit;
  end;
  AssignFile(f, OpenDialog1.FileName);
  Reset(f, 1);
  while not eof(f) do
  begin
   BlockRead(f, tmp, 1);
   if FindEl(head_lsp, ord(tmp), tel) = false then
   begin
   New(El);
   El^.key:= ord(tmp);
   El^.cnt:= 1;
   AddEl(head_lsp, El);
   inc(size);
   inc(n);
   end else
   begin
   inc(tel^.cnt);
   inc(n);
   end;
  end;
  SetLength(a, size);
  i:= 0;
  while (head_lsp <> nil) do
  begin
    FindElMax(head_lsp, tel);
    a[i].key:= tel^.key;
    a[i].cnt:= tel^.cnt;
    a[i].n0:= a[i].cnt / n;
    a[i].deep:= false;
    a[i].huff:='';
    new(ElTree);
    ElTree^.value:= 0;
    ElTree^.left:= nil;
    ElTree^.right:= nil;
    ElTree^.parent:= nil;
    ElTree^.kod:= '';
    ElTree^.symb:= a[i].key;
    a[i].st_tree:= ElTree;
    inc(i);
    DelEl(head_lsp, tel^.key);
  end;
 while (EndHaffman(a, size) <> 1) do
  begin
    i1:= FindMin(a, size);
    a[i1].deep:= true;
    i2:= FindMin(a, size);
    a[i2].n0:= a[i2].n0 + a[i1].n0;
    new(ElTree);
    ElTree^.value:= a[i2].n0;
    ElTree^.parent:= nil;
    ElTree^.kod:='';
    tmp1:= a[i1].st_tree;
    while (tmp1^.parent <> nil) do
     tmp1:= tmp1^.parent;
    tmp2:= a[i2].st_tree;
    while (tmp2^.parent <> nil) do
     tmp2:= tmp2^.parent;
    ElTree^.left:= tmp1;
    ElTree^.right:= tmp2;
    tmp1^.parent:= ElTree;
    tmp1^.kod:= '0';
    tmp2^.kod:= '1';
    tmp2^.parent:= ElTree;
  end;
  GetNode(a, size);
  CreateKod(head_tree, a, size);
  seek(f, 0);
  assignfile(fo, 'test.asd');
  rewrite(fo, 1);
  BlockWrite(fo, size, 1);
  BlockWrite(fo, size, 1);
  for i:=0 to size-1 do
  begin
   rec.key:= a[i].key;
   rec.kod:= StrBToInt(a[i].huff);
   rec.size_kod:= length(a[i].huff);
   BlockWrite(fo, rec, sizeof(TFileRec));
  end;
  j:= 0;
   res:= '';
   while (not eof(f)) do
   begin
     tpos:= filepos(f);
     BlockRead(f, inkod, 1);
     i:= FindElAr(a, size, inkod);
     res:= res + a[i].huff;
     inc(j);
   end;
   while length(res)<>0 do
   begin
    i:= 0;
    str:= '';
    while (i<>8) and (i<>length(res)) do
    begin
     inc(i);
     str:= str + res[i];
    end;
    delete(res, 1, i);
    outkod:= StrBToInt(str);
    BlockWrite(fo, outkod, 1);
   end;
    seek(fo, 1);
    chk:= length(str);
    BlockWrite(fo, chk, 1);
  Countall(a, size);
  for i:=0 to size-1 do
  begin
    SG1.Cells[0,i+1]:= IntToStr(a[i].key);
    SG1.Cells[1,i+1]:= chr(a[i].key);
    SG1.Cells[2,i+1]:= IntToStr(a[i].cnt);
    SG1.Cells[3,i+1]:= IntToStr(length(a[i].huff));
    SG1.Cells[4,i+1]:= a[i].huff;
    SG1.RowCount:= SG1.RowCount + 1;
  end;
    SG1.RowCount:= SG1.RowCount - 1;
    closefile(f);
    closefile(fo);
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 DelSp(head_lsp);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  PBS:= 0;
  SG1.Cells[0,0]:= 'Код';
  SG1.Cells[1,0]:= 'Символ';
  SG1.Cells[2,0]:= 'Частота';
  SG1.Cells[3,0]:= 'Длина';
  SG1.Cells[4,0]:= 'Код Хаффмана';
  StringGrid1.Cells[0,0]:= 'H';
  StringGrid1.Cells[0,1]:= 'Hmax';
  StringGrid1.Cells[0,2]:= 'Lcp';
  StringGrid1.Cells[0,3]:= 'Кс.с.';
  StringGrid1.Cells[0,4]:= 'Ко.э.';
end;

function GetFromKod(a: TArFRec; size: byte; key: string; var pos: byte): boolean;
var
 i: byte;
begin
 result:= false;
 pos:= 0;
 for i:=0 to size-1 do
  if a[i].kod = key then
  begin
   result:= true;
   pos:= i;
   exit;
  end;
end;

function CorrectKod(str: string; itSize: byte): string;
var
 i, j, k: integer; tmp: string[16];
begin
  if length(str) = itSize then
  begin
   result:= str;
   exit;
  end;
  tmp:= '00000000000000000';
  i:= itSize - length(str);
  delete(tmp, itSize+1, 16);
  k:= 1;
  for j:=i+1  to itSize do
  begin
    tmp[j]:= str[k];
    inc(k);
  end;
  result:= tmp;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
fin, fout: file; arr: TArFRec; i, j, ind:integer;
 size1, pos, tmp, chk: byte;
rec: TFileRec; data: byte; res, str: widestring;
tmps: string;
begin
  Opendialog1.FilterIndex:= 2;
  size1:= 0;
  OpenDialog1.Execute;
  if OpenDialog1.FileName = '' then
  begin
    ShowMessage('Не выбран исходный файл!');
    exit;
  end;
  AssignFile(fin, OpenDialog1.FileName);
  Reset(fin, 1);
  SaveDialog1.Execute;
  if SaveDialog1.FileName = '' then
  begin
    ShowMessage('Не выбран целевой файл!');
    exit;
  end;
  AssignFile(fout, SaveDialog1.FileName);
  rewrite(fout, 1);
  BlockRead(fin, size1, 1);
  BlockRead(fin, chk, 1);
  SetLength(arr, size1);
  for i:= 0 to size1-1 do
  begin
   BlockRead(fin, rec, sizeof(TFileRec));
   arr[i].key:= rec.key;
   arr[i].kod:= CorrectKod(IntToStrB(rec.kod), rec.size_kod);
   arr[i].size_kod:= rec.size_kod;
  end;
   res:= '';
   while (not eof(fin)) do
   begin
     if ((filepos(fin) + 1) <> filesize(fin)) then
     begin
      BlockRead(fin, data, 1);
      tmps:= CorrectKod(IntToStrB(data), 8);
      res:= res + tmps;
      inc(j);
     end else
     begin
      BlockRead(fin, data, 1);
      tmps:= CorrectKod(IntToStrB(data), chk);
      res:= res + tmps;
     end;
   end;
   while length(res)<>0 do
   begin
    i:= 0;
    str:= '';
    while (GetFromKod(arr, size1, str, pos)=false) and (i<>length(res)) do
    begin
     inc(i);
     str:= str + res[i];
    end;
    delete(res, 1, i);
    BlockWrite(fout, arr[pos], 1);
  end;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
 mes: string;
begin
 mes:= 'Построение ОНК методикой Хаффмана'+ #13+'      Автор: Коновалов В.О. КС-062'+
       #13+ '                       ЧДТУ-2007';
 ShowMessage(mes);
end;

end.

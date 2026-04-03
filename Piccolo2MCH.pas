unit Piccolo2MCH;

interface

  function Piccolo(fn: string; ras: Boolean): string;


implementation

uses SysUtils, Messages, Windows, Classes, Controls, Forms;

type
     raster = record
                cod, arg: byte;
               end;

     araster = array [0..27] of raster;

const

 Bajt = 40;

var

 a, edit1text: string;

 tab: array [0..$ffff] of byte;
 tmp: array [0..10*1024-1] of byte;
 scr: array [0..30*40-1] of byte;

 tPMG: array [0..13*$100-1] of Byte;
 pmg: array [0..$600] of byte;

 tabKolor: array [0..$900] of byte;

 traster: array [0..239] of araster;

 tgtia: record
          hposp0, hposp1, hposp2, hposp3: byte;
          hposm0, hposm1, hposm2, hposm3: byte;
          sizep0, sizep1, sizep2, sizep3: byte;
          sizem: byte;
          grafp0, grafp1, grafp2, grafp3: byte;
          grafm: byte;
          colpm0, colpm1, colpm2, colpm3: byte;
          color0, color1, color2, color3: byte;
          colbak: byte;
          gtictl: byte;
          pmcntl: byte;
          regA, regX, regY: byte;
        end;


procedure CustomMessage(const zm: string; const info: PWideChar);
begin

 Application.MessageBox(PWideChar(zm),info, MB_ICONINFORMATION);

end;


procedure SaveMCH(fn: string);
(*----------------------------------------------------------------------------*)
(* SAVE MIC CHAR                                                              *)
(*----------------------------------------------------------------------------*)
var i, j, k, f: integer;
    v, y: byte;
    head: Boolean;
    bf: array [0..255] of Byte;

begin

 f:=FileCreate(fn);

 head:=false;

 for i:=0 to 29 do
  for k:=0 to Bajt-1 do begin

   if scr[k+i*Bajt] > 127 then
    v:=$80
   else
    v:=$00;

   if not(head) then begin

    v:=v or 5;   // DLI=5, PGR=3

    v:=v or (1 shl 2) or (0 shl 4);

    head:=true;
   end;

   FileWrite(f, v, 1);

   for j:=0 to 7 do FileWrite(f,tab[(i*8+j)*Bajt+k],1);

  end;


  for i := 0 to 8 do
   FileWrite(f, tabKolor[i * $100], 240);

  for y := 0 to 7 do FileWrite(f, tPMG[y*256], 240);   // PM HPOS


  for y := 0 to 239 do bf[y]:=(tPMG[$800+y] and 3) or ((tPMG[$900+y] and 3) shl 2) or ((tPMG[$a00+y] and 3) shl 4) or ((tPMG[$b00+y] and 3) shl 6);
  FileWrite(f, bf, 240);               // Player Size
  FileWrite(f, tPMG[$c00], 240);       // Missile Size

  fillchar(bf, $100, tgtia.gtictl);    // Prior
  FileWrite(f, bf, 240);

  FileWrite(f, pmg[16], $500);


 for j := 0 to 239 do begin
  tab[0] := 0;
  tab[1] := 0;

  FileWrite(f, tab, 2);

  FileWrite(f, traster[j], sizeof(traster[0]));
 end;

 v:=24-13;

 FileWrite(f, v, 1);

 FileWrite(f, tgtia, sizeof(tgtia));

 FileClose(f);
end;      


procedure readPiccoloKernel(ln: Integer; pgr: Boolean);
var i,err: integer;
    a,x,y, idx, cyc, v, ras: Byte;
    w: word;
    yes: Boolean;
    t: textfile;
    s: string;


 procedure fillColor(c, a: Byte);
 var i: Byte;
 begin

  if pgr and (idx > 0) then exit;

  for i:=idx to 255 do tabKolor[c shl 8+i] := a;

 end;

 procedure fillPMG(c, a: Byte);
 var i: Byte;
 begin

  if pgr and (idx > 0) then exit;

  for i:=idx to 255 do tPMG[c shl 8+i] := a;

 end;


 procedure savReg(w: word; a: byte);                 // when read binary '.Kernal'
 begin

  case w of
    $d000: begin fillPMG(0, a); tgtia.hposp0:=a end;
    $d001: begin fillPMG(1, a); tgtia.hposp1:=a end;
    $d002: begin fillPMG(2, a); tgtia.hposp2:=a end;
    $d003: begin fillPMG(3, a); tgtia.hposp3:=a end;

    $d004: begin fillPMG(4, a); tgtia.hposm0:=a end;
    $d005: begin fillPMG(5, a); tgtia.hposm1:=a end;
    $d006: begin fillPMG(6, a); tgtia.hposm2:=a end;
    $d007: begin fillPMG(7, a); tgtia.hposm3:=a end;

    $d008: begin fillPMG(8, a); tgtia.sizep0:=a end;
    $d009: begin fillPMG(9, a); tgtia.sizep1:=a end;
    $d00a: begin fillPMG(10, a); tgtia.sizep2:=a end;
    $d00b: begin fillPMG(11, a); tgtia.sizep3:=a end;
    $d00c: begin fillPMG(12, a); tgtia.sizem :=a end;

    $d012: begin fillColor(5, a); tgtia.colpm0:=a end;
    $d013: begin fillColor(6, a); tgtia.colpm1:=a end;
    $d014: begin fillColor(7, a); tgtia.colpm2:=a end;
    $d015: begin fillColor(8, a); tgtia.colpm3:=a end;

    $d016: begin fillColor(1, a); tgtia.color0:=a end;
    $d017: begin fillColor(2, a); tgtia.color1:=a end;
    $d018: begin fillColor(3, a); tgtia.color2:=a end;
    $d019: begin fillColor(4, a); tgtia.color3:=a end;
    $d01a: begin fillColor(0, a); tgtia.colbak:=a end;

    $d01b: tgtia.gtictl := a;
  end;

 end;


 function cmd: byte;
 begin

  Result := tmp[i];

  case Result of

   $a9: begin            // LDA #
         a:=tmp[i+1];

         Inc(i, 2);
        end;

   $a2: begin            // LDX #
         x:=tmp[i+1];

         Inc(i, 2);
        end;

   $a0: begin            // LDY #
         y:=tmp[i+1];

         Inc(i, 2);
        end;


   $8d: begin            // STA
         w:=tmp[i+1] + tmp[i+2] * 256;

         savReg(w, a);

         inc(i, 3);
        end;


   $8e: begin            // STX
         w:=tmp[i+1] + tmp[i+2] * 256;

         savReg(w, x);

         inc(i, 3);
        end;


   $8c: begin            // STY
         w:=tmp[i+1] + tmp[i+2] * 256;

         savReg(w, y);

         inc(i, 3);
        end;


   $ea: begin
         Inc(i);          // NOP
        end;

  end;

 end;


 function saveReg(v: Byte): byte;                             // when read listing '.Kernel.asm'
 begin

  Result:=Lo($d01e);

  if Pos(#9'COLBK', s) > 0 then begin fillColor(0, v); Result:=Lo($d01a) end;
  if Pos(#9'COLPF0', s) > 0 then begin fillColor(1, v); Result:=Lo($d016) end;
  if Pos(#9'COLPF1', s) > 0 then begin fillColor(2, v); Result:=Lo($d017) end;
  if Pos(#9'COLPF2', s) > 0 then begin fillColor(3, v); Result:=Lo($d018) end;
  if Pos(#9'COLPF3', s) > 0 then begin fillColor(4, v); Result:=Lo($d019) end;

  if Pos(#9'COLPM0', s) > 0 then begin fillColor(5, v); Result:=Lo($d012) end;
  if Pos(#9'COLPM1', s) > 0 then begin fillColor(6, v); Result:=Lo($d013) end;
  if Pos(#9'COLPM2', s) > 0 then begin fillColor(7, v); Result:=Lo($d014) end;
  if Pos(#9'COLPM3', s) > 0 then begin fillColor(8, v); Result:=Lo($d015) end;

  if Pos(#9'HPOSP0', s) > 0 then begin fillPMG(0, v); Result:=Lo($d000) end;
  if Pos(#9'HPOSP1', s) > 0 then begin fillPMG(1, v); Result:=Lo($d001) end;
  if Pos(#9'HPOSP2', s) > 0 then begin fillPMG(2, v); Result:=Lo($d002) end;
  if Pos(#9'HPOSP3', s) > 0 then begin fillPMG(3, v); Result:=Lo($d003) end;

  if Pos(#9'HPOSM0', s) > 0 then begin fillPMG(4, v); Result:=Lo($d004) end;
  if Pos(#9'HPOSM1', s) > 0 then begin fillPMG(5, v); Result:=Lo($d005) end;
  if Pos(#9'HPOSM2', s) > 0 then begin fillPMG(6, v); Result:=Lo($d006) end;
  if Pos(#9'HPOSM3', s) > 0 then begin fillPMG(7, v); Result:=Lo($d007) end;

  if Pos(#9'SIZEP0', s) > 0 then begin fillPMG(8, v); Result:=Lo($d008) end;
  if Pos(#9'SIZEP1', s) > 0 then begin fillPMG(9, v); Result:=Lo($d009) end;
  if Pos(#9'SIZEP2', s) > 0 then begin fillPMG(10, v); Result:=Lo($d00a) end;
  if Pos(#9'SIZEP3', s) > 0 then begin fillPMG(11, v); Result:=Lo($d00b) end;
  if Pos(#9'SIZEM', s) > 0 then begin fillPMG(12, v); Result:=Lo($d00c) end;

  if Pos(#9'CHBASE', s) > 0 then Result:=Lo($d01e);

 end;


 procedure subRaster(v: Byte);
 var i: integer;
 begin

  i:=ras - 1;

  while (i>=0) and (tRaster[idx, i].cod <> 0) do Dec(i);

  if (traster[idx, i].cod = 0) and (traster[idx, i].arg - v >= 0) and (traster[idx, i].arg - v <> 1) then Dec(tRaster[idx, i].arg, v);

 end;


 procedure oneRaster;
 var i: byte;
 begin

  i:=ras - 1;

  while (i>=0) and (tRaster[idx, i].cod <> 0) do Dec(i);

  if (traster[idx, i].cod = 0) then inc(tRaster[idx, i].arg);

 end;



 procedure addRaster(c,v: Byte);
 begin

  if pgr then begin

   if (c = 0) and (ras > 0) and (tRaster[idx, ras-1].cod = 0) then begin     // laczenie NOP-ow (maks 36 cykli)

     if v + traster[idx, ras-1].arg > 36 then begin
      tRaster[idx, ras].cod := c;
      tRaster[idx, ras].arg := v;
     end else begin

      Inc(tRaster[idx, ras-1].arg, v);

      Dec(ras);
     end;


   end else begin
    tRaster[idx, ras].cod := c;
    tRaster[idx, ras].arg := v;
   end;

   Inc(ras);

  end;
  
 end;
             

begin

 a:=0;
 x:=0;
 y:=0;

 idx:=0;

 i:=0;
 while (i < ln) and (cmd <> $cd) do ;

 if tmp[i] <> $cd then BEGIN
   CustomMessage('Unknown command: ' + IntToHex(tmp[i], 2), 'Kernel');

   Exit;
 end;

 tgtia.regA:=a;
 tgtia.regX:=x;
 tgtia.regY:=y;

 tgtia.pmcntl:=3;


 {
 inc(i, 3 + 2);                      // CMP VCOUNT \ BNE

 while tab[i] = $8d do inc(i, 3);    // STA WSYNC
 while tab[i] = $ea do inc(i);       // NOP
  }

// form1.Caption:=inttostr(Tab[i]) + ',' + inttostr(Tab[i+1]) + ',' + inttostr(Tab[i+2]);


 Assign(t, ChangeFileExt(edit1text, '.Kernel.asm')); Reset(t);

 yes:=false;

 ras:=0;
 cyc:=0;

 while not Eof(t) do begin

  readln(t, s);

  if Pos('Scanline', s) = 1 then begin

    if pgr then
     while (ras>0) and (tRaster[idx, ras].cod = 0) do begin
       tRaster[idx, ras].arg := 0;

       dec(ras);
     end;

    val( Copy(s, 9, 255), idx, Err);
    Inc(idx, 8);

    if (idx > 0) and (idx mod 24=0) then begin
     ras:=2;
     cyc:=6;
    end else begin
     ras:=0;
     cyc:=0;
    end;

    yes:=true;
  end;

  if yes then begin

    if Pos(#9'lda'#9'#.HI(', s) = 1 then s:='';      // CHBASE
    if Pos(#9'sta'#9'CHBASE', s) = 1 then s:='';     // CHBASE


    if Pos(#9'lda'#9'#$', s) = 1 then begin val( Copy(s, 7, 3), a, Err); addRaster($01, a); inc(cyc, 2) end;
    if Pos(#9'ldx'#9'#$', s) = 1 then begin val( Copy(s, 7, 3), x, Err); addRaster($02, x); inc(cyc, 2) end;
    if Pos(#9'ldy'#9'#$', s) = 1 then begin val( Copy(s, 7, 3), y, Err); addRaster($03, y); inc(cyc, 2) end;

    if Pos(#9'sta'#9, s) = 1 then begin v:=saveReg(a); addRaster($81, v); inc(cyc, 4) end;
    if Pos(#9'stx'#9, s) = 1 then begin v:=saveReg(x); addRaster($82, v); inc(cyc, 4) end;
    if Pos(#9'sty'#9, s) = 1 then begin v:=saveReg(y); addRaster($83, v); inc(cyc, 4) end;

    if Pos(#9'jsr'#9'DummyJSR'#9, s) = 1 then begin addRaster($00, 12); inc(cyc, 12) end;
    if Pos(#9'jsr'#9'DummyJSRx2'#9, s) = 1 then begin addRaster($00, 24); inc(cyc, 24) end;
    if Pos(#9'jsr'#9'DummyJSRx4'#9, s) = 1 then begin addRaster($00, 24); addRaster($00, 24); inc(cyc, 48) end;

    if Pos(#9'pha'#9, s) = 1 then begin addRaster($00, 3); inc(cyc, 3) end;
    if Pos(#9'pla'#9, s) = 1 then begin addRaster($00, 4); inc(cyc, 4) end;
    if Pos(#9'nop'#9, s) = 1 then begin addRaster($00, 2); inc(cyc, 2) end;
    if Pos(#9'cmp'#9'$0'#9, s) = 1 then begin addRaster($00, 3); inc(cyc, 3) end;
    if Pos(#9'cmp'#9'($0,x)'#9, s) = 1 then begin addRaster($00, 6); inc(cyc, 6) end;

  end;


  if (idx mod 8 = 0) and (cyc > 27) then begin subRaster(cyc-27); cyc:=cyc-(cyc-27) end else
   if (cyc > 60) then begin subRaster(cyc-60); cyc:=cyc-(cyc-60) end;

  if (idx mod 8 = 0) and (cyc = 26) then begin oneRaster; Inc(cyc) end else
   if (cyc = 59) then begin oneRaster; Inc(cyc) end;


  if ras > 26 then begin
   CustomMessage('Program raster too long (' + IntToStr(idx) + ' line)', 'asm.Kernel');

   Break;
  end;

 end;

 close(t);

end;

 //RASTER_PROGRAM
//--------------
//bit 0-7		Code:
//
//		$00-NOP				(0,2,3,4..36 cycle)
//		$01-LDA#, $02-LDX#, $03-LDY#	(2 cycle)
//		$41-LDA0, $42-LDX0, $43-LDY0	(3 cycle)
//		$61-LDA, $62-LDX, $63-LDY	(4 cycle)
//		$81-STA, $82-STX, $83-STY)	(4 cycle)
//
//bit 8-15	Value (0..255)


function GetTempName: string;
var Buffer: array[0..MAX_PATH] of Char;
begin
 GetTempPath(SizeOf(Buffer) - 1, Buffer);
 GetTempFileName(Buffer, '~', 0, Buffer);

 Result:=Buffer;
end;


function Piccolo(fn: string; ras: Boolean): string;
(*----------------------------------------------------------------------------*)
(* pliki FNT (1024 b)                                                         *)
(*----------------------------------------------------------------------------*)
var plik, ln, k, i, j,y: integer;
    table: array [0..29] of Byte;
begin

 Result:='';

 edit1text := fn;

 fillchar(tab, SizeOf(tab), 0);
 fillchar(tmp, SizeOf(tmp), 0);
 fillchar(scr, SizeOf(scr), 0);
 fillchar(tPMG, SizeOf(tPMG), 0);
 fillchar(pmg, SizeOf(pmg), 0);
 fillchar(tabKolor, SizeOf(tabKolor), 0);

 fillchar(tRaster, SizeOf(tRaster), 0);

  for y:=0 to 239 do
  if ras and (y > 0) and (y mod 24 = 0) then begin
   tRaster[y, 0].cod:=$01;  // lda #
   tRaster[y, 0].arg:=y div 24;

   tRaster[y, 1].cod:=$81;  // sta
   tRaster[y, 1].arg:=$1e;  // -> CHBASE
  end;


 // -----------------------------
 // *.CHSet
 //------------------------------

 if not FileExists(ChangeFileExt(edit1text,'.CHSet')) then begin
   CustomMessage('File not found'#13#10 + ChangeFileExt(edit1text, '.CHSet'), 'CHSet');

   Exit;
  end;


 plik:= FileOpen(ChangeFileExt(edit1text, '.CHSet'), fmOpenRead);
 ln:=FileSeek(plik, 0, 2);
 FileSeek(plik, 0, 0);

 FileRead(plik, tmp, SizeOf(tmp));
 FileClose(plik);

 table[0]:=9;
 table[1]:=0;
 table[2]:=0;
 table[3]:=0;

 table[4]:=1;
 table[5]:=1;
 table[6]:=1;

 table[7]:=2;
 table[8]:=2;
 table[9]:=2;

 table[10]:=3;
 table[11]:=3;
 table[12]:=3;

 table[13]:=4;
 table[14]:=4;
 table[15]:=4;

 table[16]:=5;
 table[17]:=5;
 table[18]:=5;

 table[19]:=6;
 table[20]:=6;
 table[21]:=6;

 table[22]:=7;
 table[23]:=7;
 table[24]:=7;

 table[25]:=8;
 table[26]:=8;
 table[27]:=8;

 table[28]:=9;
 table[29]:=9;

 j:=80;

 for k := 0 to 29 do begin

    for i := 0 to Bajt - 1 do begin

     for y := 0 to 7 do
      tab[k*(8*Bajt)+y*Bajt+i] := tmp[table[k] * 1024 + j*8 + y];

     Inc(j); if j>119 then j:=0;

    end;


 end;


 // -----------------------------
 // *.CHName
 //------------------------------

 if not FileExists(ChangeFileExt(edit1text,'.CHName')) then begin
   CustomMessage('File not found'#13#10 + ChangeFileExt(edit1text, '.CHName'), 'CHName');

   Exit;
  end;


 plik:= FileOpen(ChangeFileExt(edit1text,'.CHName'), fmOpenRead);
 FileSeek(plik, 0, 0);

 FileRead(plik, scr[Bajt], SizeOf(scr));

 FileClose(plik);


 // -----------------------------
 // *.PMG
 //------------------------------

  if not FileExists(ChangeFileExt(edit1text,'.PMG')) then begin
   CustomMessage('File not found'#13#10 + ChangeFileExt(edit1text, '.PMG'), 'PMG');

   Exit;
  end;


 plik:= FileOpen(ChangeFileExt(edit1text,'.PMG'), fmOpenRead);
 FileSeek(plik, 0, 0);

 FileRead(plik, pmg, SizeOf(pmg));

 FileClose(plik);


 // -----------------------------
 // *.Kernel
 //------------------------------

 if not FileExists(ChangeFileExt(edit1text,'.Kernel')) then begin
   CustomMessage('File not found'#13#10 + ChangeFileExt(edit1text, '.Kernel'), 'Kernel');

   Exit;
  end;

 if not FileExists(ChangeFileExt(edit1text,'.Kernel.asm')) then begin
   CustomMessage('File not found'#13#10 + ChangeFileExt(edit1text, '.Kernel.asm'), 'Kernel.asm');

   Exit;
  end;

 plik:= FileOpen(ChangeFileExt(edit1text, '.Kernel'), fmOpenRead);
 ln:=FileSeek(plik, 0, 2);
 FileSeek(plik, 0, 0);
 FileRead(plik,tmp,ln);
 FileClose(plik);

 readPiccoloKernel(ln, ras);

//------------------------------
// Done.
//------------------------------

 Result:=GetTempName;

 SaveMCH( Result );

end;


end.

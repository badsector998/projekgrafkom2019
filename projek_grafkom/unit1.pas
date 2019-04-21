unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, StdCtrls, Spin, ComCtrls, Menus;

type
  Elemen=record
     x,y: integer;
     a,b,k: Integer;
     c: TColor;
  end;

  { TProjek }

  TProjek = class(TForm)
    Atas: TBitBtn;
    Bawah: TBitBtn;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    ColorButton2: TColorButton;
    ColorDialog1: TColorDialog;
    Edit1: TEdit;
    Edit2: TEdit;
    Image2: TImage;
    Kanan: TBitBtn;
    Kiri: TBitBtn;
    Label15: TLabel;
    Label3: TLabel;
    Panel4: TPanel;
    Panel5: TPanel;
    Label9: TLabel;
    Pentagon: TBitBtn;
    Label5: TLabel;
    Label6: TLabel;
    SerongKananA: TBitBtn;
    SerongKananB: TBitBtn;
    SerongKiriA: TBitBtn;
    SerongKiriB: TBitBtn;
    SpeedButton1: TSpeedButton;
    spdfree: TSpeedButton;
    spdrec: TSpeedButton;
    spdcrl: TSpeedButton;
    spd4: TSpeedButton;
    spdErase: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpinEdit1: TSpinEdit;
    tebalskala: TSpinEdit;
    ZoomIn: TBitBtn;
    ZoomOut: TBitBtn;
    RotasiKiri: TBitBtn;
    RotasiKanan: TBitBtn;
    Label4: TLabel;
    Panel2: TPanel;
    Label2: TLabel;
    Panel1: TPanel;
    Sudut: TRadioGroup;
    TebalGaris: TSpinEdit;
    Warna: TLabel;
    TipeGaris: TComboBox;
    Label1: TLabel;
    JajarGenjang: TBitBtn;
    Segitiga: TBitBtn;
    PersegiPanjang: TBitBtn;
    Image1: TImage;
    Bentuk: TListBox;
    Persegi: TBitBtn;
    procedure AtasClick(Sender: TObject);
    procedure BawahClick(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure ColorButton2Click(Sender: TObject);
    procedure ColorBox1Change(Sender: TObject);
    procedure ColorButton1Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure HapusClick(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1Paint(Sender: TObject);
    procedure Image2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure JajarGenjangClick(Sender: TObject);
    procedure KananClick(Sender: TObject);
    procedure KiriClick(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure PencilClick(Sender: TObject);
    procedure PentagonClick(Sender: TObject);
    procedure PersegiClick(Sender: TObject);
    procedure PersegiPanjangClick(Sender: TObject);
    procedure RotasiKananClick(Sender: TObject);
    procedure RotasiKiriClick(Sender: TObject);
    procedure SegitigaClick(Sender: TObject);
    procedure SerongKananAClick(Sender: TObject);
    procedure SerongKananBClick(Sender: TObject);
    procedure SerongKiriAClick(Sender: TObject);
    procedure SerongKiriBClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure spdfreeClick(Sender: TObject);
    procedure SudutClick(Sender: TObject);
    procedure TitikTengahObjek(Sender: TObject);
    procedure TebalGarisChange(Sender: TObject);
    procedure TipeGarisChange(Sender: TObject);
    procedure BoundaryFill(x,y,fill,boundary:Integer);
    procedure ZoomInClick(Sender: TObject);
    procedure ZoomOutClick(Sender: TObject);

  private

  public
   DrawColor,colorbrush,colorpen:TColor;
   PenW:Integer;
  end;

var
  Projek: TProjek;
  objek : array[1..20] of Elemen;
  i,x,y,XCenter,YCenter,titik : Integer;
  StartX,StartY,EndX,EndY : Integer;
  a,b,k : Integer;
  tob : Elemen;
  sdt : real;
  bangun: String;
  State,Fungsi: Integer;
  Drawing, msDown : Boolean;
  prevX,prevY : integer;
  srcRect, dstRect : TRect;
  cropRect, dstCrop : TRect;

implementation

{$R *.lfm}

{ TProjek }

procedure TProjek.BoundaryFill(x,y,fill,boundary :Integer);
var
  current:Integer;
begin
  current:=Image1.Canvas.Pixels[x,y];
    if ((current<>boundary) and (current<>fill)) then
      begin
        Image1.Canvas.Pixels[x,y]:=fill;
        BoundaryFill(x+1,y,fill,boundary);
        BoundaryFill(x-1,y,fill,boundary);
        BoundaryFill(x,y+1,fill,boundary);
        BoundaryFill(x,y-1,fill,boundary);
      end;
end;

procedure TProjek.TitikTengahObjek(Sender: TObject);
begin
   tob.x:=0;
   tob.y:=0;
    for i:=1 to titik do
        begin
        tob.x:=tob.x+objek[i].x;
        tob.y:=tob.y+objek[i].y;
        end;
    tob.x:=tob.x div titik;
    tob.y:=tob.y div titik;
end;

procedure TProjek.FormActivate(Sender: TObject);
begin
 Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);
 Image2.Canvas.Rectangle(0,0,Image2.Width,Image2.Height);
 Image1.Canvas.Clear;
 srcRect := Rect(0,0,Image1.Width,Image1.Height);
 dstRect := Rect(0,0,Image2.Width,Image2.Height);
end;

procedure TProjek.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  Destroy;
end;


procedure TProjek.BawahClick(Sender: TObject);
begin
  for i:=1 to 20 do
  objek[i].y:=objek[i].y+SpinEdit1.value;
  FormShow(Sender);
  for i:=1 to k do
  begin
    objek[i].b:=objek[i].b+SpinEdit1.value;
    BoundaryFill(objek[i].a,objek[i].b,objek[i].c,Image1.Canvas.Pen.Color);
  end;
end;

procedure TProjek.BitBtn1Click(Sender: TObject);
begin
  titik:=9; bangun:='Heksagon';
  objek[1].x:= 120;                    objek[1].y:= 150;
  objek[2].x:= 280;                    objek[2].y:= 150;
  objek[3].x:= 350;                    objek[3].y:= 250;
  objek[4].x:= 280;                    objek[4].y:= 350;
  objek[5].x:= 120;                    objek[5].y:= 350;
  objek[6].x:= 50;                     objek[6].y:= 250;
  objek[7].x:= 120;                    objek[7].y:= 150;
  objek[8].x:= 120;                    objek[8].y:= 150;
  objek[9].x:= 120;                    objek[9].y:= 150;
  TitikTengahObjek(Sender);
  FormShow(Sender);
end;

procedure TProjek.ColorButton2Click(Sender: TObject);
begin
  Image1.Canvas.Pen.Color:=ColorButton2.ButtonColor;
end;

procedure TProjek.ColorBox1Change(Sender: TObject);
begin
  Fungsi:=1;
  State:=3;
end;

procedure TProjek.ColorButton1Click(Sender: TObject);
begin
  Fungsi:=1;
end;

procedure TProjek.AtasClick(Sender: TObject);
begin
    for i:=1 to 20 do
    objek[i].y:=objek[i].y-SpinEdit1.value;
       FormShow(Sender);
    for i:=1 to k do
    begin
    objek[i].b:=objek[i].b-SpinEdit1.value;
    BoundaryFill(objek[i].a,objek[i].b,objek[i].c,Image1.Canvas.Pen.Color);
    end;
end;

procedure TProjek.FormShow(Sender: TObject);
begin
  Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);
  Image1.Canvas.Clear;

  if bangun='lain' then
  begin
   Image1.Canvas.MoveTo(objek[5].x,objek[5].y);
  begin
  for i:=1 to 5 do
      Image1.Canvas.LineTo(objek[i].x,objek[i].y);
  end; end;

  if bangun='Heksagon' then
  begin
   Image1.Canvas.MoveTo(objek[9].x,objek[9].y);
  begin
  for i:=1 to 9 do
  Image1.Canvas.LineTo(objek[i].x,objek[i].y);
  end;
  end;
end;

procedure TProjek.HapusClick(Sender: TObject);
begin
 Fungsi:=3;
end;

procedure TProjek.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  if Fungsi=1 then //warna
  begin
  k:=k+1;
  Drawing:=true;
  XCenter:=X;
  YCenter:=Y;
  BoundaryFill(XCenter,YCenter,ColorDialog1.Color,Image1.Canvas.Pen.Color);

  objek[k].a:= XCenter; objek[k].b:= YCenter;
  end;

  //if CheckBox1.Checked=true then
  //begin
  //if Fungsi=2 then   //pensil
  //begin
  //Drawing:=True;
  //StartX:=X; StartY:=Y;
  //EndX:=X; EndY:=Y;
  //if State=4 then
  //begin
  //  Image1.Canvas.Pen.Color:=ColorButton2.ButtonColor;
  //  Image1.Canvas.Pen.Width:=TebalGaris.Value;
  //  Image1.Canvas.PenPos:=Point(X,Y);
  //end;
  //end;
  //end;

  prevX := X;
  prevY := Y;
  msDown := true;
  if spd4.Down = true then
  begin
   Image1.Canvas.MoveTo(prevX,prevY);
  end else if spdErase.Down = true then
  begin
   Image1.Canvas.MoveTo(prevX,prevY);
  end;
end;


procedure TProjek.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  a,b : string;
begin
  a := IntToStr(X);
  b := IntToStr(Y);
  //Edit1.Caption:=IntToStr(X);
  //Edit2.Caption:=IntToStr(Y);
  Label5.Caption := a+','+b;
//  if Fungsi=2 then
//  begin
//  if Drawing=true then begin
//  if State=4 then begin
//  with Image1.Canvas do
//   begin
//  LineTo(X,Y);
//end;
//end;
//  end;
//  end;

//  if CheckBox2.Checked=true then
//  begin
//  if Fungsi=3 then    //penghapus
//  begin
//  colorbrush:=Image1.Canvas.Brush.Color;
//  colorpen:=Image1.Canvas.Pen.Color;
//  Image1.Canvas.Brush.Color:=clWhite;
//  Image1.Canvas.Pen.Color:=clWhite;
//  Image1.Canvas.Rectangle(x, y, x+5*tebalskala.value,y+5*tebalskala.value);
//  Image1.Canvas.Brush.Color:=colorbrush;
//  Image1.Canvas.Pen.Color:=colorpen;
//  end;
//end;

  if msDown = true then
  begin
   if spdfree.Down = true then
   begin
    Image1Paint(Sender);
    Image2.Canvas.Line(prevX,prevY,X,Y);
   end else if spdcrl.Down = true then
   begin
     Image1Paint(Sender);
     Image2.Canvas.Ellipse(prevX,prevY,X,Y);
   end else if spdrec.Down = true then
   begin
     Image1Paint(Sender);
     Image2.Canvas.Rectangle(prevX,prevY,X,Y);
   end else if spd4.Down = true then
   begin
     Image1.Visible:=true;
     Image1.Canvas.LineTo(X,Y);
   end else if spdErase.Down = true then
   begin
     Image1.Visible:=true;
     Image1.Canvas.Pen.Color:=clWhite;
     Image1.Canvas.Pen.Width:=10;
     Image1.Canvas.LineTo(X,Y);
   end else if SpeedButton2.Down = true then
   begin
     Image1Paint(Sender);
     cropRect := Rect(prevX,prevY,X,Y);
   end;
  end;
end;

procedure TProjek.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Drawing:=False;

  if msDown = true then
  begin
   if spdfree.Down = true then
   begin
    Image1.Canvas.Line(prevX,prevY,X,Y);
   end else if spdcrl.Down = true then
   begin
    Image1.Canvas.Ellipse(prevX,prevY,X,Y);
   end else if spdrec.Down = true then
   begin
    Image1.Canvas.Rectangle(prevX,prevY,X,Y);
   end else if spd4.Down = true then
   begin
    Image1.Canvas.LineTo(X,Y);
   end else if spdErase.Down = true then
   begin
    Image1.Canvas.LineTo(X,Y);
   end else if SpeedButton2.Down = true then
   begin
    dstCrop := Rect(0,0,X-prevX,Y-prevY);
    Image1.Canvas.Rectangle(0,0,Image1.Width,Image1.Height);
    Image1.Canvas.CopyRect(dstCrop,Image2.Canvas,cropRect);
   end;
   Image1.Canvas.Pen.Color:=clBlack;
   Image1.Canvas.Pen.Width:=1;
   Image1.Visible:=true;
   msDown := false;
  end;
end;

procedure TProjek.Image1Paint(Sender: TObject);
begin
  With Image2.Canvas do
  begin
    CopyMode:=cmSrcCopy;
    CopyRect(dstRect,Image1.Canvas,srcRect);
  end;
  if msDown = true then
  begin
    Image1.Visible:=false;
  end;
end;

procedure TProjek.Image2MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  Edit1.Caption:=IntToStr(X);
  Edit2.Caption:=IntToStr(Y);
end;

procedure TProjek.JajarGenjangClick(Sender: TObject);
begin
  titik:=5; k:=0; bangun:='lain';
    objek[1].x:=130;        objek[1].y:=178;
    objek[2].x:=230;        objek[2].y:=178;
    objek[3].x:=270;        objek[3].y:=110;
    objek[4].x:=170;        objek[4].y:=110;
    objek[5].x:=130;        objek[5].y:=178;
    objek[6].x:=200;        objek[6].y:=140;
    FormShow(Sender);
end;

procedure TProjek.KananClick(Sender: TObject);
begin
  for i:=1 to 20 do
  objek[i].x:=objek[i].x+SpinEdit1.value;
  FormShow(Sender);
   for i:=1 to k do
    begin
    objek[i].a:=objek[i].a+SpinEdit1.value;
    BoundaryFill(objek[i].a,objek[i].b,objek[i].c,Image1.Canvas.Pen.Color);
    end;
end;

procedure TProjek.KiriClick(Sender: TObject);
begin
  for i:=1 to 20 do
  objek[i].x:=objek[i].x-SpinEdit1.value;
   FormShow(Sender);
   for i:=1 to k do
    begin
    objek[i].a:=objek[i].a-SpinEdit1.value;
    BoundaryFill(objek[i].a,objek[i].b,objek[i].c,Image1.Canvas.Pen.Color);
    end;
end;

procedure TProjek.BitBtn2Click(Sender: TObject);
begin
  titik:=5;  k:=0;  bangun:='lain';
  objek[1].x := 200;    objek[1].y := 200;
  objek[2].x := 350;    objek[2].y := 200;
  objek[3].x := 200;    objek[3].y := 50;
  objek[4].x := 200;    objek[4].y := 200;
  objek[5].x := 200;    objek[5].y := 200;
  objek[6].x := 240;    objek[6].y := 140;

  FormShow(Sender);
end;

procedure TProjek.PencilClick(Sender: TObject);
begin
  State:=4;
  Fungsi:=2;
end;

procedure TProjek.PentagonClick(Sender: TObject);
begin
  titik:=5; k:=0;  bangun:='lain';
  objek[1].x:=120;        objek[1].y:=100;
  objek[2].x:=190;        objek[2].y:=150;
  objek[3].x:=165;        objek[3].y:=220;
  objek[4].x:=75;         objek[4].y:=220;
  objek[5].x:=50;         objek[5].y:=150;
  objek[6].x:=117;        objek[6].y:=161;
  FormShow(Sender);
end;

procedure TProjek.PersegiClick(Sender: TObject);
begin
    titik:=5; k:=0; bangun:='lain';
    objek[1].x:=100;        objek[1].y:=100;
    objek[2].x:=200;        objek[2].y:=100;
    objek[3].x:=200;        objek[3].y:=200;
    objek[4].x:=100;        objek[4].y:=200;
    objek[5].x:=100;        objek[5].y:=100;
    objek[6].x:=147;        objek[6].y:=145;
    FormShow(Sender);
end;

procedure TProjek.PersegiPanjangClick(Sender: TObject);
begin
    titik:=5; k:=0;  bangun:='lain';
    objek[1].x:=100;        objek[1].y:=100;
    objek[2].x:=300;        objek[2].y:=100;
    objek[3].x:=300;        objek[3].y:=200;
    objek[4].x:=100;        objek[4].y:=200;
    objek[5].x:=100;        objek[5].y:=100;
    objek[6].x:=197;        objek[6].y:=142;
    FormShow(Sender);
end;

procedure TProjek.RotasiKananClick(Sender: TObject);
var
   temp :array[1..10] of Elemen;
   r, t : integer;
begin
    for i:=1 to titik do
      begin
        r := objek[6].x;
        t := objek[6].y;
        objek[i].x:=objek[i].x-r;
        objek[i].y:=objek[i].y-t;
        temp[i].x:= round(objek[i].x*cos(sdt)-objek[i].y*sin(sdt));
        temp[i].y:= round(objek[i].x*sin(sdt)+objek[i].y*cos(sdt));
        objek[i]:=temp[i];
        objek[i].x:=objek[i].x+r;
        objek[i].y:=objek[i].y+t;
      end;
  FormShow(Sender);
end;

procedure TProjek.RotasiKiriClick(Sender: TObject);
var
 temp :array[1..10] of Elemen;
 r, t : integer;
begin
  for i:=1 to titik do
    begin
      r := objek[6].x;
      t := objek[6].y;
      objek[i].x:=objek[i].x - r;
      objek[i].y:=objek[i].y - t;
      temp[i].y := round(objek[i].y*cos(sdt)-objek[i].x*sin(sdt));
      temp[i].x := round(objek[i].y*sin(sdt)+objek[i].x*cos(sdt));
      objek[i]:=temp[i];
      objek[i].x:=objek[i].x + r;
      objek[i].y:=objek[i].y + t;
  end;
  FormShow(Sender);
end;

procedure TProjek.SegitigaClick(Sender: TObject);
begin
  titik:=5;  k:=0;  bangun:='lain';
    objek[1].x:=100;        objek[1].y:=100;
    objek[2].x:=150;        objek[2].y:=200;
    objek[3].x:=50;         objek[3].y:=200;
    objek[4].x:=100;        objek[4].y:=100;
    objek[5].x:=100;        objek[5].y:=100;
    objek[6].x:=100;        objek[6].y:=100;
    FormShow(Sender);
    TitikTengahObjek(Sender);
end;

procedure TProjek.SerongKananAClick(Sender: TObject);
begin
  for i:= 1 to 6 do
  begin
     objek[i].x:=objek[i].x+SpinEdit1.value;
     objek[i].y:=objek[i].y-SpinEdit1.value;
  end;
   FormShow(Sender);
  for i:=1 to k do
    begin
    objek[i].a:=objek[i].a+SpinEdit1.value;
    objek[i].b:=objek[i].b-SpinEdit1.value;
    BoundaryFill(objek[i].a,objek[i].b,objek[i].c,Image1.Canvas.Pen.Color);
    end;
end;

procedure TProjek.SerongKananBClick(Sender: TObject);
begin
     for i:= 1 to 20 do
  begin
     objek[i].x:=objek[i].x+SpinEdit1.value;
     objek[i].y:=objek[i].y+SpinEdit1.value;
  end;
      FormShow(Sender);
     for i:=1 to k do
    begin
    objek[i].a:=objek[i].a+SpinEdit1.value;
    objek[i].b:=objek[i].b+SpinEdit1.value;
    BoundaryFill(objek[i].a,objek[i].b,objek[i].c,Image1.Canvas.Pen.Color);
end;
end;

procedure TProjek.SerongKiriAClick(Sender: TObject);
begin
    for i:= 1 to 20 do
  begin
     objek[i].y:=objek[i].y-SpinEdit1.value;
     objek[i].x:=objek[i].x-SpinEdit1.value;
  end;
     FormShow(Sender);
    for i:=1 to k do
    begin
    objek[i].a:=objek[i].a-SpinEdit1.value;
    objek[i].b:=objek[i].b-SpinEdit1.value;
    BoundaryFill(objek[i].a,objek[i].b,objek[i].c,Image1.Canvas.Pen.Color);
    end;
end;

procedure TProjek.SerongKiriBClick(Sender: TObject);
begin
    for i:= 1 to 20 do
  begin
     objek[i].x:=objek[i].x-SpinEdit1.value;
     objek[i].y:=objek[i].y+SpinEdit1.value;
  end;
     FormShow(Sender);
  for i:=1 to k do
    begin
    objek[i].a:=objek[i].a-SpinEdit1.value;
    objek[i].b:=objek[i].b+SpinEdit1.value;
    BoundaryFill(objek[i].a,objek[i].b,objek[i].c,Image1.Canvas.Pen.Color);
    end;
end;

procedure TProjek.SpeedButton1Click(Sender: TObject);
begin
  ColorDialog1.Execute;
  Panel4.Color:= ColorDialog1.Color;
  Fungsi:=1
end;

procedure TProjek.spdfreeClick(Sender: TObject);
begin

end;

procedure TProjek.SudutClick(Sender: TObject);
begin
  if Sudut.ItemIndex=0 then
  sdt := 45*pi/180;
  if Sudut.ItemIndex=1 then
  sdt := 60*pi/180;
  if Sudut.ItemIndex=2 then
  sdt := 90*pi/180;
  if Sudut.ItemIndex=3 then
  sdt := 180*pi/180;
end;

procedure TProjek.TebalGarisChange(Sender: TObject);
begin
  if(TebalGaris.Value=1) then
  Image1.Canvas.Pen.Width := 1
  else if(TebalGaris.Value=2) then
  Image1.Canvas.Pen.Width := 2
  else if(TebalGaris.Value=3) then
  Image1.Canvas.Pen.Width := 3
  else if(TebalGaris.Value=4) then
  Image1.Canvas.Pen.Width := 4
  else if(TebalGaris.Value=5) then
  Image1.Canvas.Pen.Width := 5;

  FormShow(Sender);
end;

procedure TProjek.TipeGarisChange(Sender: TObject);
begin
    if(TipeGaris.ItemIndex=0) then
    Image1.Canvas.Pen.Style := psSolid
    else if(TipeGaris.ItemIndex=1) then
    Image1.Canvas.Pen.Style := psDash
    else if(TipeGaris.ItemIndex=2) then
    Image1.Canvas.Pen.Style := psDot
    else if(TipeGaris.ItemIndex=3) then
    Image1.Canvas.Pen.Style := psDashDot
    else if(TipeGaris.ItemIndex=4) then
    Image1.Canvas.Pen.Style := psDashDotDot;
    FormShow(Sender);
end;

procedure TProjek.ZoomInClick(Sender: TObject);
var
  temp: array[1..20] of Elemen;
  a, b: integer;
begin
   begin
     for i:=1 to 20 do
     begin
        a:= objek[6].x;
        b:= objek[6].y;
        objek[i].x:=objek[i].x-a;
        objek[i].y:=objek[i].y-b;
        temp[i].x:=round(objek[i].x*tebalskala.Value);
        temp[i].y:=round(objek[i].y*tebalskala.Value);
        objek[i]:=temp[i];
        objek[i].x:= objek[i].x+a;
        objek[i].y:= objek[i].y+b;
     end;
     FormShow(Sender);
     end;
end;

procedure TProjek.ZoomOutClick(Sender: TObject);
var
    temp: array[1..20] of Elemen;
    n, m : integer;
begin
     for i:=1 to 20 do
     begin
        n:= objek[6].x;
        m:= objek[6].y;
        objek[i].x:=objek[i].x-n;
        objek[i].y:=objek[i].y-m;
        temp[i].x:=round(objek[i].x div tebalskala.Value);
        temp[i].y:=round(objek[i].y div tebalskala.Value);
        objek[i]:=Temp[i];
        objek[i].x:= objek[i].x+n;
        objek[i].y:= objek[i].y+m;
     end;
     FormShow(Sender);
end;

end.


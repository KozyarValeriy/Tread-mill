﻿unit Unit3;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series, Vcl.ExtCtrls,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.Menus, unit1,  Math, Vcl.Grids;

type
  TForm3 = class(TForm)
    BitBtn1: TBitBtn;
    ProgressBar1: TProgressBar;
    Chart1: TChart;
    Series1: TFastLineSeries;
    Edit1: TEdit;
    Label1: TLabel;
    MainMenu1: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    Image1: TImage;
    Label2: TLabel;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Edit4: TEdit;
    Label5: TLabel;
    Edit5: TEdit;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Edit6: TEdit;
    Label9: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    Label10: TLabel;
    Edit7: TEdit;
    Label11: TLabel;
    Edit8: TEdit;
    Label12: TLabel;
    Edit9: TEdit;
    Label13: TLabel;
    Edit10: TEdit;
    Label14: TLabel;
    Edit11: TEdit;
    Series2: TPointSeries;
    StatusBar1: TStatusBar;
    BitBtn2: TBitBtn;
    SaveDialog1: TSaveDialog;
    StringGrid1: TStringGrid;
    Edit12: TEdit;
    Edit13: TEdit;
    Label15: TLabel;
    Label16: TLabel;
    Edit14: TEdit;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Edit15: TEdit;
    procedure BitBtn1Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N3Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;
  R,r0,r1,r2,Rb,Cmax,eps,delta,alpha,alpha1,alpha2,b,K,A:real;  
  p:integer;
  Ya,Za,Ym,Zm:array of real;
implementation

{$R *.dfm}

function Rgrid(CCi: real): real;
  begin
    if abs(r0) < 10e-8 then
      begin
        if CCi < (Cmax - b - 2 * r1 * cos(alpha1)) / 2 then
          Rgrid := R - ((Cmax - b - 2 * r1 * cos(alpha1)) / 2) / 
                        tan(alpha1) - r1 * (1 - sin(alpha1)) + CCi / tan(alpha1)
        else if (CCi >= (Cmax - b - 2 * r1 * cos(alpha1)) / 2) and 
                (CCi < (Cmax - b) / 2) then
          Rgrid := sqrt(r1 * r1 - (Cmax - b - 2 * CCi)  * 
                        (Cmax - b - 2 * CCi) / 4) + R - r1
        else if (CCi >=(Cmax-b)/2) and (CCi<(Cmax+b)/2) then
          Rgrid := R
        else if (CCi >= (Cmax + b) / 2) and 
                (CCi < (Cmax + b + 2 * r2 * cos(alpha2)) / 2)  then
          Rgrid := sqrt(r2 * r2 - (Cmax + b - 2 * CCi) * 
                        (Cmax + b - 2 * CCi) / 4) + R - r2
        else if CCi >= (Cmax + b + 2 * r2 * cos(alpha2)) / 2 then
          Rgrid := R - r2 * (1 - sin(alpha2)) - ((2 * CCi - 
                    (Cmax + b + 2 * r2 * cos(alpha2))) / 2) / tan(alpha2)
        else Rgrid := 0;
      end;
    if (b = 0) and (r0 > 0) then
      begin
        if CCi < ((Cmax - 2 * r0 * cos(alpha1)) / 2) then
          Rgrid := R - ((Cmax - 2 * r0 * cos(alpha1)) / 2) / 
                        tan(alpha1) - r0 * (1 - sin(alpha1)) + CCi / tan(alpha1)
        else if (CCi >= ((Cmax - 2 * r0 * cos(alpha1)) / 2)) and 
                (CCi < ((Cmax + 2 * r0 * cos(alpha2)) / 2)) then
          Rgrid := sqrt(r0 * r0 - (Cmax - 2 * CCi) * (Cmax - 2 * CCi) / 4) + R - r0
        else if CCi >= ((Cmax + 2 * r0 * cos(alpha2)) / 2) then
          Rgrid := R - r0 * (1 - sin(alpha2)) - 
                    (CCi - ((Cmax + 2 * r0 * cos(alpha2)) / 2)) / tan(alpha2)
        else Rgrid := 0;
      end;
  end;

function parX(tettax, dKx, Cix, psix: real): real;
  begin
   // parX:=(A+r0-dKx-R+(R-r0)*cos(delta)+((b-Cmax)*sin(delta)/2)+Rgrid(Cix)*cos(psix)*cos(delta)+Cix*cos(eps)*sin(delta)+Rgrid(Cix)*sin(eps)*sin(psix)*sin(delta))*cos(tettax)+(Rgrid(Cix)*cos(eps)*sin(psix)-Cix*sin(eps))*sin(tettax);
    parX := (A - dKx - R + R * cos(delta) + ((-Cmax) * sin(delta) / 2) + 
             Rgrid(Cix) * cos(psix) * cos(delta) + Cix * cos(eps) * sin(delta) +
             Rgrid(Cix) * sin(eps) * sin(psix) * sin(delta)) * cos(tettax) + 
            (Rgrid(Cix) * cos(eps) * sin(psix) - Cix * sin(eps)) * sin(tettax);
  end;

function parY(tettay, dKy, Ciy, psiy: real): real;
  begin 
    //parY:=(A+r0-dKy-R+(R-r0)*cos(delta)+((b-Cmax)*sin(delta)/2)+Rgrid(Ciy)*cos(psiy)*cos(delta)+Ciy*cos(eps)*sin(delta)+Rgrid(Ciy)*sin(eps)*sin(psiy)*sin(delta))*sin(tettay)+(Ciy*sin(eps)-Rgrid(Ciy)*cos(eps)*sin(psiy))*cos(tettay);
    parY := (A - dKy - R + R * cos(delta) + ((-Cmax) * sin(delta) / 2) + 
             Rgrid(Ciy) * cos(psiy) * cos(delta) + Ciy * cos(eps) * sin(delta) + 
             Rgrid(Ciy) * sin(eps) * sin(psiy) * sin(delta)) * sin(tettay) + 
            (Ciy * sin(eps) - Rgrid(Ciy) * cos(eps) * sin(psiy)) * cos(tettay);
  end;

function parZ(Ciz, psiz: real):real;
  begin
    //parZ:=Cmax/2+b*(cos(delta)-1)/2-Cmax*cos(delta)/2+(r0-R)*sin(delta)+Ciz*cos(eps)*cos(delta)-Rgrid(Ciz)*cos(psiz)*sin(delta)+Rgrid(Ciz)*cos(delta)*sin(eps)*sin(psiz);
    parZ := Cmax / 2 - Cmax * cos(delta) / 2 + (-R) * sin(delta) + 
            Ciz * cos(eps) * cos(delta) - Rgrid(Ciz) * cos(psiz) * sin(delta) + 
            Rgrid(Ciz) * cos(delta) * sin(eps) * sin(psiz);
  end;

procedure GivenFind3(tettag, dKg, Cig, psig, ztg, mistg: real; var psigf: real);
  var dpsig: real;
    begin
      if parY(tettag, dKg, Cig, psig) / parX(tettag, dKg, Cig, psig) <
              tan(PI / ztg) then
        dpsig := 0.01
      else if parY(tettag, dKg, Cig, psig) / parX(tettag, dKg, Cig, psig) > 
              tan(PI / ztg) then
        dpsig := -0.01
      else
        dpsig := 0;

      if dpsig > 0  then
        repeat
          if parY(tettag, dKg, Cig, psig) / parX(tettag, dKg, Cig, psig) < 
              tan(PI / ztg)  then
            psig := psig + dpsig
          else
            begin
              psig := psig - dpsig;
              dpsig := dpsig / 10;
            end;
        until abs((parY(tettag, dKg, Cig, psig) / 
              parX(tettag, dKg, Cig, psig)) - tan(PI / ztg)) <= mistg;
      if dpsig < 0  then
        repeat
          If parY(tettag, dKg, Cig, psig) / parX(tettag, dKg, Cig, psig) > 
              tan(PI / ztg)  then
            psig := psig + dpsig
          else
            begin
              psig := psig - dpsig;
              dpsig := dpsig / 10;
            end;
        until abs((parY(tettag, dKg, Cig, psig) / 
              parX(tettag, dKg, Cig, psig))  - tan(PI / ztg)) <= mistg;
      psigf := psig;
    end;

procedure GivenFind2(tettag, dKg, Cig, psig, ztg, mistg: real; var psigf: real);
  var dpsig: real;
    begin
       if parX(tettag, dKg, Cig, psig) > 0 then
          dpsig := 0.01
       else if parX(tettag, dKg, Cig, psig) < 0 then
          dpsig := -0.01
       else
          dpsig := 0;
     if dpsig > 0  then
        repeat
         if parX(tettag, dKg, Cig, psig) > 0 then
           psig := psig + dpsig
         else
           begin
             psig := psig - dpsig;
             dpsig := dpsig / 10;
           end;
         until abs(parX(tettag, dKg, Cig, psig)) <= mistg;

     if dpsig < 0  then
        repeat
         if parX(tettag, dKg, Cig, psig) < 0 then
           psig := psig + dpsig
         else
           begin
             psig := psig - dpsig;
             dpsig := dpsig / 10;
           end;
        until abs(parX(tettag, dKg, Cig, psig)) <= mistg;
       psigf := psig;
    end;

procedure TForm3.BitBtn1Click(Sender: TObject);
  Var Ci, tetta, dK, psi, psi1, dtetta, X, Y, Z, 
      mistake, mistake1, Ymin, Zmin, Xmin: real;
      i, j, n, zt, h, q, w: integer;
      F: textfile;
    begin
      chart1.Series[0].Clear;
      chart1.Series[1].Clear;

      R := strtofloat(edit1.text);        // Радиус шлифовального круга
      Cmax := strtofloat(edit2.text);     // Высота круга
      Alpha1 := strtofloat(edit3.text) * PI / 180;  // Левый угол
      // edit4.text := floattostr(Alpha1 * 180 / PI);
      Alpha2 := strtofloat(edit4.text) * PI / 180;  // Правый угол
      b := strtofloat(edit5.text); // Перемычка
      r1 := strtofloat(edit12.text);
      r2 := strtofloat(edit13.text);
      r0 := 0;
      Rb := strtofloat(edit6.text);  // Радиус заготовки
      delta := strtofloat(edit7.text) * PI / 180;
      eps := strtofloat(edit8.text) * PI / 180; // Угол наклона круга
      alpha := strtofloat(edit9.text) * PI / 180; // Задний угол
      zt := strtoint(edit10.text); // Кол-во зубьев
      n := strtoint(edit11.text); // Кол-во разбиений шлифовалього круга
      q := strtoint(edit14.text);
      K := PI * Rb * 2 * Tan(alpha) / zt; // Падения затылка
      dtetta := 0.2 * PI / 180;
      A := R + Rb;
      mistake := 0.001;  // Погрешность при нахождении траектори
      mistake1 := strtofloat(edit15.text); // Погрешность при нахождении минимальных точек

      progressbar1.Position := 0;
      Chart1.LeftAxis.SetMinMax(round(Rb - 4), round(Rb + Cmax - 4));
      chart1.BottomAxis.SetMinMax(0, Cmax);
      series1.AddXY(-1, Rb);
      series1.AddXY(Cmax + 1, Rb);
      psi1 := 0;
      h := 0;

      if radiobutton1.Checked then // сохранение в файл
        if savedialog1.Execute then
          begin;
            h := 1;
            assignfile(F, savedialog1.FileName + '.txt'); // открытие файла
            rewrite(F);
          end;
      j := 1;
      p := 0; // Первоначальная длина динамического массива
      w := 0;
      for i := 0 to n-1 do
        begin
          Xmin := 0;
          Ymin := Rb + 1;
          Zmin := 0;
          tetta := PI / zt - 20 * PI / 180;
          while (tetta <= PI / zt + 20 * PI / 180) do
            begin
              dK := (K * tetta * zt) / (2 * PI);
              Ci := i * Cmax / n;
              progressbar1.Position := i * round(100 / (n - 1));
              psi := PI;
              psi1 := psi;
              if zt <= 2 then
                begin
                  GivenFind2(tetta, dK, Ci, psi, zt, mistake, psi1);
                  X := parX(tetta, dK, Ci, psi1);
                  Y := parY(tetta, dK, Ci, psi1);
                  Z := parZ(Ci, psi1);
                end
              else
                begin
                  GivenFind3(tetta,dK,Ci,psi,zt,mistake,psi1);
                  X:=parX(tetta,dK,Ci,psi)*sin(PI/zt)-parY(tetta,dK,Ci,psi)*cos(PI/zt);
                  Y:=parX(tetta,dK,Ci,psi1)*cos(PI/zt)+parY(tetta,dK,Ci,psi1)*sin(PI/zt);
                  Z:=parZ(Ci,psi1);
                end;
              if eps = 0 then
                if Y < Ymin then
                  begin
                    Ymin := Y;
                    Zmin := Z;
                  end;
              p := p + 1;
              setlength(Ya, p);
              setlength(Za, p);
              Ya[p - 1] := Y;
              Za[p - 1] := Z;
              X := 0;
              Z := 0;
              Y := 0;
              psi1 := 0;
              tetta := tetta + dtetta;
            end;
           if eps = 0 then // поиск минимальных точек при eps = 0
            begin
              if Zmin > 0 then
                begin
                  setlength(Ym, w + 1); // Задание длины динамического массива
                  setlength(Zm, w + 1);
                  Ym[w] := Ymin;
                  Zm[w] := Zmin;
                  w := w + 1;
                end;
            end;
         end;

        progressbar1.Position := 0;
        if (eps  > 0) or (eps < 0) then
        for i := 0 to n - 1 do // Поиск минимальных точек профиля
          begin
            Zmin := 0;
            Ymin := Rb + 1;
            progressbar1.Position := i * round(100 / (n - 1));
            for j := 0 to p - 1 do
              begin
                if abs(Za[j] - 1.1 * Cmax * (1 - (n - i) / n)) < mistake1 then
                  if Ya[j] < Ymin then
                    begin
                      Ymin := Ya[j];
                      Zmin := Za[j];
                    end;
              end;
            if Zmin > 0 then
              begin
                setlength(Ym, w + 1);
                setlength(Zm, w + 1);
                Ym[w] := Ymin;
                Zm[w] := Zmin;
                w := w + 1;
              end;
          end;
        progressbar1.Position := 0;
        StringGrid1.Cells[0, 0] := '№';
        StringGrid1.Cells[1, 0] := 'Z';
        StringGrid1.Cells[2, 0] := 'Y';
        StringGrid1.RowCount := round((w) / q) + 1;
        i := 0;
        j := 0;
        repeat
          i := i + q;
          j := j + 1;
          progressbar1.Position := i * round(100 / (w));
          StringGrid1.Cells[1, j] := floattostr(roundto(Zm[i - 1], -2));
          StringGrid1.Cells[2, j] := floattostr(roundto(Ym[i - 1], -2));
          StringGrid1.Cells[0, j] := inttostr(i);
          if h = 1 then writeln(F, Zm[i - 1]:4:2, ' ', Ym[i - 1]:4:2);
            series2.addXY(Zm[i - 1], Ym[i - 1]);
        until i >= w;
        progressbar1.Position := 0;
        Chart1.AddSeries(series1);
        Chart1.AddSeries(series2);
        if h = 1 then
          closefile(F);
    end;

procedure TForm3.BitBtn2Click(Sender: TObject);
  begin
    form2.Show;
  end;

procedure TForm3.N2Click(Sender: TObject);
  begin
    ShowMessage('Программа создана для получения профиля формооразующей части резьбофрез');
  end;

procedure TForm3.N3Click(Sender: TObject);
  begin
    Close;
  end;
end.
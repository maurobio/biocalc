unit Main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons, LCLType, ExtCtrls, Math;

type

  { TMainForm }

  TMainForm = class(TForm)
    a1Edit: TEdit;
    AreaValueLabel: TLabel;
    cEdit: TEdit;
    c1Edit: TEdit;
    b1Edit: TEdit;
    CalcBtn: TBitBtn;
    a2Edit: TEdit;
    aEdit: TEdit;
    b3Edit: TEdit;
    a3Edit: TEdit;
    b2Edit: TEdit;
    SpeciesEdit: TEdit;
    Image: TImage;
    b4Edit: TEdit;
    bEdit: TEdit;
    b4Label: TLabel;
    b2Label: TLabel;
    a3Label: TLabel;
    b3Label: TLabel;
    SpeciesLabel: TLabel;
    MorphotypeLabel: TLabel;
    a4Edit: TEdit;
    AddSpeedButton: TSpeedButton;
    bLabel: TLabel;
    AboutSpeedButton: TSpeedButton;
    VolumeValueLabel: TLabel;
    VolumeLabel: TLabel;
    AreaLabel: TLabel;
    dLabel: TLabel;
    cLabel: TLabel;
    a1Label: TLabel;
    b1Label: TLabel;
    c1Label: TLabel;
    a2Label: TLabel;
    a4Label: TLabel;
    NumberLabel: TLabel;
    ShapesComboBox: TComboBox;
    CloseButton: TButton;
    RecordLabel: TLabel;
    procedure AboutSpeedButtonClick(Sender: TObject);
    procedure AddSpeedButtonClick(Sender: TObject);
    procedure CalcBtnClick(Sender: TObject);
    procedure CloseButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ShapesComboBoxChange(Sender: TObject);
  private
    { private declarations }
    procedure AddRecord;
    procedure EmptyRecord;
    procedure CargaJPGProporcionado(Fichero: string; const QueImage: TImage);
  public
    { public declarations }
  end;

const
  PI: extended = 3.1415926535897932385;
  VERSION = '0.0.4';

var
  MainForm: TMainForm;
  Outfile: TextFile;
  RecordCount: integer;

implementation

{$R *.lfm}

{ TMainForm }

procedure TMainForm.CargaJPGProporcionado(Fichero: string; const QueImage: TImage);
var
  ElJPG: TJpegImage;
  Rectangulo: TRect;
  EscalaX, EscalaY, Escala: single;

begin
  ElJPG := TJPegImage.Create;
  try
    ElJPG.LoadFromFile(Fichero);

    //Por defecto, escala 1:1
    EscalaX := 1.0;
    EscalaY := 1.0;

    //Hallamos la escala de reduccin Horizontal
    if QueImage.Width = ElJPG.Width then
      EscalaX := QueImage.Width / ElJPG.Width;

    //La escala vertical
    if QueImage.Height = ElJPG.Height then
      EscalaY := QueImage.Height / ElJPG.Height;

    //Escogemos la menor de las 2
    if EscalaY < EscalaX then
      Escala := EscalaY
    else
      Escala := EscalaX;

    //Y la usamos para reducir el rectangulo destino
    with Rectangulo do
    begin
      Right := Trunc(ElJPG.Width * Escala);
      Bottom := Trunc(ElJPG.Height * Escala);
      Left := 0;
      Top := 0;
    end;

    //Dibujamos el bitmap con el nuevo tamao en el TImage destino
    with QueImage.Picture.Bitmap do
    begin
      Width := Rectangulo.Right;
      Height := Rectangulo.Bottom;
      Canvas.StretchDraw(Rectangulo, ElJPG);
    end;

  finally
    ElJPG.Free;
  end;
end; {De CargaJPGProporcionado}

procedure TMainForm.EmptyRecord;
begin
  Image.Picture := nil;
  SpeciesEdit.Text := '';
  ShapesComboBox.Text := '';
  aEdit.Text := '0.0';
  aEdit.Enabled := False;
  bEdit.Text := '0.0';
  bEdit.Enabled := False;
  cEdit.Text := '0.0';
  cEdit.Enabled := False;
  a1Edit.Text := '0.0';
  a1Edit.Enabled := False;
  b1Edit.Text := '0.0';
  b1Edit.Enabled := False;
  c1Edit.Text := '0.0';
  c1Edit.Enabled := False;
  a2Edit.Text := '0.0';
  a2Edit.Enabled := False;
  b2Edit.Text := '0.0';
  b2Edit.Enabled := False;
  a3Edit.Text := '0.0';
  a3Edit.Enabled := False;
  b3Edit.Text := '0.0';
  b3Edit.Enabled := False;
  a4Edit.Text := '0.0';
  a4Edit.Enabled := False;
  b4Edit.Text := '0.0';
  b4Edit.Enabled := False;
  VolumeValueLabel.Caption := '0.0';
  AreaValueLabel.Caption := '0.0';
  CalcBtn.Enabled := False;
end;

procedure TMainForm.AddRecord;
begin
  AssignFile(Outfile, 'biovolume.csv');
  Append(Outfile);
  with MainForm do
  begin
    Write(Outfile, IntToStr(RecordCount) + ';');
    Write(Outfile, SpeciesEdit.Text + ';');
    Write(Outfile, ShapesComboBox.Text + ';');
    Write(Outfile, aEdit.Text + ';');
    Write(Outfile, bEdit.Text + ';');
    Write(Outfile, cEdit.Text + ';');
    Write(Outfile, a1Edit.Text + ';');
    Write(Outfile, b1Edit.Text + ';');
    Write(Outfile, c1Edit.Text + ';');
    Write(Outfile, a2Edit.Text + ';');
    Write(Outfile, b2Edit.Text + ';');
    Write(Outfile, a3Edit.Text + ';');
    Write(Outfile, b3Edit.Text + ';');
    Write(Outfile, a4Edit.Text + ';');
    Write(Outfile, b4Edit.Text + ';');
    Write(Outfile, VolumeValueLabel.Caption + ';');
    Write(Outfile, AreaValueLabel.Caption);
  end;
  WriteLn(Outfile);
  CloseFile(Outfile);
  Inc(RecordCount);
  NumberLabel.Caption := IntToStr(RecordCount);
end;

procedure TMainForm.CloseButtonClick(Sender: TObject);
begin
  Close;
end;

procedure TMainForm.AboutSpeedButtonClick(Sender: TObject);
begin
  Application.MessageBox('BioCalc v' + VERSION + sLineBreak +
    'A software tool for calculating biovolume of phytoplankton samples' +
    sLineBreak + '(c) 2017-2019 Mauro J. Cavalcanti' + sLineBreak +
    'maurobio@gmail.com', 'Information', MB_ICONINFORMATION);
end;

procedure TMainForm.AddSpeedButtonClick(Sender: TObject);
begin
  //if ((StrToFloat(VolumeValueLabel.Caption) = 0.0) and (StrToFloat(AreaValueLabel.Caption) = 0.0)) then
  //   Application.MessageBox('Results not computed!', 'Warning', MB_ICONWARNING)
  //else begin
  //   AddRecord;
  //   EmptyRecord;
  //end;
  EmptyRecord;
end;

procedure TMainForm.CalcBtnClick(Sender: TObject);
var
  a, b, c, a1, b1, c1, a2, b2, a3, b3, a4, b4, Vol, Area: Float;
begin
  DecimalSeparator := '.';
  Vol := 0.0;
  Area := 0.0;
  case ShapesComboBox.ItemIndex of
    0: { sphere }
    begin
      if TryStrToFloat(aEdit.Text, a) then
      begin
        Vol := PI / 6 * Power(a, 3);
        Area := PI * Sqr(a);
      end;
    end;
    1: { prolate spheroid }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) then
      begin
        Vol := PI / 6 * Sqr(b) * a;
        Area := PI * b / 2 * (b + Sqr(a) / Sqrt(Sqr(a) - Sqr(b)) *
          Power(Sin(Sqrt(Sqr(a) - Sqr(b)) / a), -1));
      end;
    end;
    2: { ellipsoid }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) and
        (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := PI / 6 * a * b * c;
        Area := PI / 4 * (b + c) * ((b + c / 2) + 2 * Sqr(a) /
          Sqrt(4 * Sqr(a) - Sqr(b + c)) * Power(Sqrt(4 * Sqr(a) - Sqr(b + c) / 2 * a), -1));
      end;
    end;
    3: { cylinder }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := PI / 4 * Sqr(a) * c;
        Area := PI * a * (a / 2 + c);
      end;
    end;
    4: { cylinder + 2 half spheres }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) then
      begin
        Vol := PI * Sqr(b) * (a / 4 - b / 12);
        Area := PI * a * b;
      end;
    end;
    5: { cylinder + 2 cones }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) then
      begin
        Vol := PI / 4 * Sqr(b) * (a - b / 3);
        Area := PI * b * (a - 4 - Sqrt(3) / 4 * b);
      end;
    end;
    6: { cone }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) then
      begin
        Vol := PI / 12 * a * Sqr(b);
        Area := PI / 4 * b * (b + Sqrt(4 * Sqr(a) + Sqr(b)));
      end;
    end;
    7: { double cone }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) then
      begin
        Vol := PI / 12 * a * Sqr(b);
        Area := PI / 2 * b * Sqrt(Sqr(a) + Sqr(b));
      end;
    end;
    8: { cone + half sphere }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) then
      begin
        Vol := PI / 4 * a * Sqr(b);
        Area := PI / 2 * Sqr(b) * (b + Sqrt(2 * Sqr(a) - a * b + Sqr(b) / 2));
      end;
    end;
    9: { rectangular box }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) and
        (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := a * b * c;
        Area := 2 * a * b + 2 * b * c + 2 * a * c;
      end;
    end;
    10: { prism on elliptic base }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) and
        (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := PI / 4 * a * b * c;
        Area := PI / 2 * (a * b + b * c + a * c);
      end;
    end;
    11: { elliptic prism with transapical constriction }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) and
        (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := PI / 4 * a * b * c;
        Area := PI / 2 * (a * b + b * c + a * c);
      end;
    end;
    12: { prism on parallelogram-base }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) and
        (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := 0.5 * a * b * c;
        Area := a * b + Sqrt(Sqr(a) + Sqr(b)) / 4 * c;
      end;
    end;
    13: { half-elliptic prism }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) and
        (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := PI / 4 * a * b * c;
        Area := PI / 4 * (a * b + b * c + a * c) + a * c;
      end;
    end;
    14: { sickle-shaped prism }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) and
        (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := PI / 4 * a * b * c;
        Area := PI / 4 * (a * b + b * c + a * c) + a * c;
      end;
    end;
    15: { sickle-shaped cylinder }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) then
      begin
        Vol := PI / 6 * a * Sqr(b);
        Area := PI / 2 * b * Sqrt(Sqr(a) + Sqr(b));
      end;
    end;
    16: { cymbelloid }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) and
        (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := 2 / 3 * a * Sqr(c) * Arcsin(b / 2 * c);
        Area := PI / 2 * a * c + b * (c + Sqr(a) / 2 *
          Sqrt(Sqr(a) - 4 * Sqr(c)) * Power(Sin(Sqrt(Sqr(a) - 4 * Sqr(c)) / a), -1));
      end;
    end;
    17: { prism on triangle-base }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := Sqrt(3) / 4 * c * Sqr(a);
        Area := 3 * a * c + Sqrt(3) / 2 * Sqr(a);
      end;
    end;
    18: { pyramid }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := 1 / 6 + Sqr(a) * c;
        Area := 0.5 * Sqr(a) + a * Sqrt(Sqr(a) + 8 * Sqr(c));
      end;
    end;
    19: { elliptic prism with transapical inflation }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) and
        (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := PI / 4 * a * b * c;
        Area := PI / 2 * (a * b + b * c + a * c);
      end;
    end;
    20: { gomphonemoid }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) and
        (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := a * b / 4 * (a + (PI / 4 - 1) * b) * Arcsin(c / 2 * a);
        Area := b / 2 * (2 * a + PI * a * Arcsin(c / 2 * a) + (PI / 2 - 2) * b);
      end;
    end;
    21: { cone + half sphere + cylinder }
    begin
      if (TryStrToFloat(a1Edit.Text, a1)) and (TryStrToFloat(a2Edit.Text, a2)) and
        (TryStrToFloat(b1Edit.Text, b1)) and (TryStrToFloat(b2Edit.Text, b2)) then
      begin
        Vol := PI / 3 + (a1 + a2) * Sqr(b1) + PI / 4 * (a2 + b2) +
          Sqr(b2) + PI / 12 + a2 + b1 * b2;
        Area := PI * a1 * b1 + PI / 4 + Sqr(b1) + PI / 2 *
          Sqr(b2) + PI / 2 * Sqr(b2) * Sqrt(Sqr((a1 / b1)) + 1 / 4) - PI / 2 *
          b1 * Sqrt(Sqr((a1 * b2 / b1 - a1)) + Sqr(b1) / 4);
      end;
    end;
    22: { elliptic prism + 4 cone }
    begin
      if (TryStrToFloat(a1Edit.Text, a1)) and (TryStrToFloat(a2Edit.Text, a2)) and
        (TryStrToFloat(b1Edit.Text, b1)) and (TryStrToFloat(b2Edit.Text, b2)) and
        (TryStrToFloat(c1Edit.Text, c1)) then
      begin
        Vol := PI / 4 + a1 * b1 * c1 + PI / 3 * a2 * Sqr(b2);
        Area := PI / 2 * a1 * b1 + PI / 2 * b1 * c1 * PI / 2 *
          a1 * c1 + PI * b2 * (Sqrt(4 * Sqr(a2) + Sqr(b2)) - b2);
      end;
    end;
    23: { 2 cylinder + elliptic prism }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) and
        (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := PI / 4 * a * b * c;
        Area := PI / 2 * (a * b + b * c + a * c);
      end;
    end;
    24: { ellipsoid + 2 cones + cylinder }
    begin
      if (TryStrToFloat(a1Edit.Text, a1)) and (TryStrToFloat(a2Edit.Text, a2)) and
        (TryStrToFloat(a3Edit.Text, a3)) and (TryStrToFloat(a4Edit.Text, a4)) and
        (TryStrToFloat(b1Edit.Text, b1)) and (TryStrToFloat(b2Edit.Text, b2)) then
      begin
        Vol := PI / 4 * a2 * Sqr(b2) + PI / 12 * (a3 + a4) *
          Sqr(b2) + PI / 6 * a1 * b1 * b2;
        Area := PI / 4 * (b1 + b2) * (b1 + b2 / 2 + Sqr(a1) /
          Sqrt(Sqr(a1) - Sqr((b1 + b2) / 2)) *
          Power(Sin(Sqrt(Sqr(a1) - Sqr((b1 + b2)) / 2) / a1), -1));
      end;
    end;
    25: { half sphere }
    begin
      if (TryStrToFloat(aEdit.Text, a)) then
      begin
        Vol := PI / 12 * Power(a, 3);
        Area := 3 * PI / 4 * Sqr(a);
      end;
    end;
    26: { cone + 3 cylinder }
    begin
      if (TryStrToFloat(a1Edit.Text, a1)) and (TryStrToFloat(a2Edit.Text, a2)) and
        (TryStrToFloat(a3Edit.Text, a3)) and (TryStrToFloat(b1Edit.Text, b1)) and
        (TryStrToFloat(b2Edit.Text, b2)) and (TryStrToFloat(b3Edit.Text, b3)) then
      begin
        Vol := PI / 2 * a2 * Sqr(b2) + PI / 2 * a3 * Sqr(b3) +
          PI / 12 * a1 * (Sqr(b1) + b1 * b2 + Sqr(b2));
        Area := PI / 2 * (b1 + b2) * Sqrt(Sqr(a1) + Sqr((b1 - b2) / 2)) +
          PI / 4 * (Sqr(b1) + Sqr(b2)) + 2 * PI * (a2 * b2 + a3 * b3);
      end;
    end;
    27: { cylinder girdle view }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(cEdit.Text, b)) then
      begin
        Vol := PI / 4 * Sqr(b) * a;
        Area := PI * b * (b / 2 + a);
      end;
    end;
    28: { prism on elliptic base girdle view }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(bEdit.Text, b)) and
        (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := PI / 4 * a * b * c;
        Area := PI / 2 * (a * b + b * c + a * c);
      end;
    end;
    29: { prism on triangle-base girdle view }
    begin
      if (TryStrToFloat(aEdit.Text, a)) and (TryStrToFloat(cEdit.Text, b)) then
      begin
        Vol := Sqrt(3) / 4 + a * Sqr(b);
        Area := 3 * a * b + Sqrt(3) / 2 * Sqr(b);
      end;
    end;
    30: { box + elliptic prism }
    begin
      if (TryStrToFloat(a1Edit.Text, a1)) and (TryStrToFloat(a2Edit.Text, a2)) and
        (TryStrToFloat(b1Edit.Text, b1)) and (TryStrToFloat(b2Edit.Text, b2)) and
        (TryStrToFloat(cEdit.Text, c)) then
      begin
        Vol := c * (a1 * b1 + PI / 4 + a2 * b2);
        Area := c * (2 * a1 + b1 + PI / 2 * a2 + PI / 2 * b2) +
          2 * a1 * b1 + PI / 2 * a2 * b2;
      end;
    end;
  end;
  VolumeValueLabel.Caption := FloatToStrF(Vol, ffFixed, 7, 5);
  AreaValueLabel.Caption := FloatToStrF(Area, ffFixed, 7, 5);
  AddRecord;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  DataList: TStringList;
begin
  if not FileExists('biovolume.csv') then
  begin
    AssignFile(Outfile, 'biovolume.csv');
    Rewrite(Outfile);
    Write(Outfile, '#;');
    Write(Outfile, 'species;');
    Write(Outfile, 'shape;');
    Write(Outfile, 'a;');
    Write(Outfile, 'b;');
    Write(Outfile, 'c;');
    Write(Outfile, 'a1;');
    Write(Outfile, 'b1;');
    Write(Outfile, 'c1;');
    Write(Outfile, 'a2;');
    Write(Outfile, 'b2;');
    Write(Outfile, 'a3;');
    Write(Outfile, 'b3;');
    Write(Outfile, 'a4;');
    Write(Outfile, 'b4;');
    Write(Outfile, 'V;');
    Write(Outfile, 'A');
    WriteLn(Outfile);
    CloseFile(Outfile);
  end;
  DataList := TStringList.Create;
  DataList.LoadFromFile('biovolume.csv');
  RecordCount := DataList.Count - 1;
  NumberLabel.Caption := IntToStr(RecordCount);
  DataList.Free;
end;

procedure TMainForm.ShapesComboBoxChange(Sender: TObject);
var
  aPath: string;
begin
  aPath := ExtractFilePath(Application.ExeName);
  CargaJPGProporcionado(aPath + 'images\' + IntToStr(ShapesComboBox.ItemIndex) + '.jpg', Image);
  case ShapesComboBox.ItemIndex of
    0: { sphere }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := False;
      cEdit.Enabled := False;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    1: { prolate spheroid }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := False;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    2: { ellipsoid }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    3: { cylinder }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := False;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    4: { cylinder + 2 half spheres }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := False;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    5: { cylinder + 2 cones }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := False;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    6: { cone }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := False;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    7: { double cone }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := False;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    8: { cone + half sphere }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := False;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    9: { rectangular box }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    10: { prism on elliptic base }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := True;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    11: { elliptic prism with transapical constriction }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    12: { prism on parallelogram-base }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    13: { half-elliptic prism }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    14: { sickle-shaped prism }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    15: { sickle-shaped cylinder }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := False;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    16: { cymbelloid }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    17: { prism on triangle-base }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := False;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    18: { pyramid }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := False;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    19: { elliptic prism with transapical inflation }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    20: { gomphonemoid }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    21: { cone + half sphere + cylinder }
    begin
      aEdit.Enabled := False;
      bEdit.Enabled := False;
      cEdit.Enabled := False;
      a1Edit.Enabled := True;
      b1Edit.Enabled := True;
      c1Edit.Enabled := False;
      a2Edit.Enabled := True;
      b2Edit.Enabled := True;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    22: { elliptic prism + 4 cone }
    begin
      aEdit.Enabled := False;
      bEdit.Enabled := False;
      cEdit.Enabled := False;
      a1Edit.Enabled := True;
      b1Edit.Enabled := True;
      c1Edit.Enabled := True;
      a2Edit.Enabled := True;
      b2Edit.Enabled := True;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    23: { 2 cylinder + elliptic prism }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    24: { ellipsoid + 2 cones + cylinder }
    begin
      aEdit.Enabled := False;
      bEdit.Enabled := False;
      cEdit.Enabled := False;
      a1Edit.Enabled := True;
      b1Edit.Enabled := True;
      c1Edit.Enabled := False;
      a2Edit.Enabled := True;
      b2Edit.Enabled := True;
      a3Edit.Enabled := True;
      b3Edit.Enabled := False;
      a4Edit.Enabled := True;
      b4Edit.Enabled := False;
    end;
    25: { half sphere }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := False;
      cEdit.Enabled := False;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    26: { cone + 3 cylinder }
    begin
      aEdit.Enabled := False;
      bEdit.Enabled := False;
      cEdit.Enabled := False;
      a1Edit.Enabled := True;
      b1Edit.Enabled := True;
      c1Edit.Enabled := False;
      a2Edit.Enabled := True;
      b2Edit.Enabled := True;
      a3Edit.Enabled := True;
      b3Edit.Enabled := True;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    27: { cylinder girdle view }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := False;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    28: { prism on elliptic base girdle view }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := True;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    29: { prism on triangle-base girdle view }
    begin
      aEdit.Enabled := True;
      bEdit.Enabled := True;
      cEdit.Enabled := False;
      a1Edit.Enabled := False;
      b1Edit.Enabled := False;
      c1Edit.Enabled := False;
      a2Edit.Enabled := False;
      b2Edit.Enabled := False;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
    30: { box + elliptic prism }
    begin
      aEdit.Enabled := False;
      bEdit.Enabled := False;
      cEdit.Enabled := True;
      a1Edit.Enabled := True;
      b1Edit.Enabled := True;
      c1Edit.Enabled := False;
      a2Edit.Enabled := True;
      b2Edit.Enabled := True;
      a3Edit.Enabled := False;
      b3Edit.Enabled := False;
      a4Edit.Enabled := False;
      b4Edit.Enabled := False;
    end;
  end;
  CalcBtn.Enabled := True;
end;

end.

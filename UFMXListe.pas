unit UFMXListe;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  System.Rtti, System.Bindings.Outputs, Fmx.Bind.Editors, Data.Bind.EngExt,
  Fmx.Bind.DBEngExt, Data.Bind.Components, Data.Bind.DBScope, FMX.ListView,
  Data.DB, Datasnap.DBClient, FMX.Controls.Presentation, FMX.StdCtrls;

type
  TForm13 = class(TForm)
    ClientDataSet1: TClientDataSet;
    SwitchOpen: TSwitch;
    ListView1: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    Label1: TLabel;
    SwitchSize: TSwitch;
    Label2: TLabel;
    SwitchAddImage: TSwitch;
    Label3: TLabel;
    ClientDataSet1SpeciesNo: TFloatField;
    ClientDataSet1Category: TStringField;
    ClientDataSet1Common_Name: TStringField;
    ClientDataSet1SpeciesName: TStringField;
    ClientDataSet1Lengthcm: TFloatField;
    ClientDataSet1Length_In: TFloatField;
    ClientDataSet1Notes: TMemoField;
    ClientDataSet1Graphic: TGraphicField;
    Link2ListView: TLinkFillControlToField;
    procedure ListView1UpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure SwitchOpenSwitch(Sender: TObject);
    procedure SwitchAddImageSwitch(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  Form13: TForm13;

implementation

{$R *.fmx}
uses FMX.TextLayout, System.Math;

function GetTextHeight(const D: TListItemText; const Width: single): Integer;
    var  Layout: TTextLayout;
         Hauteur : Single;
    begin
      // Creer un TTextLayout pour obtenir les dimensions du texte
      Layout := TTextLayoutManager.DefaultTextLayout.Create;
      try
        Layout.BeginUpdate;
        try
          // Initialiser les paramètre du layout avec ceux de l'élément (stylé)
          Layout.Font.Assign(D.Font);
{$IFDEF ANDROID}
// bogue android RSP-14628,
// la taille de fonte par défaut (18) n'est pas toujours trouvée !
          if D.Font.IsSizeStored=false then  Layout.Font.Size:= 18;
{$ENDIF}
          Layout.VerticalAlign := D.TextVertAlign;
          Layout.HorizontalAlign := D.TextAlign;
          Layout.WordWrap := D.WordWrap;
          Layout.Trimming := D.Trimming;
          Layout.MaxSize := TPointF.Create(Width, TTextLayout.MaxLayoutSize.Y);
          Layout.Text := D.Text;
        finally
          Layout.EndUpdate;
        end;
        Hauteur:=Layout.Height; // obtention d'un single
        // petit gap supplémentaire, la hauteur d'un 'm'
        if D.Wordwrap then begin
          Layout.Text := 'm';
          Hauteur:=Hauteur+Layout.Height;
        end;
        Result := Round(Hauteur);
      finally
        Layout.Free;
      end;
    end;


procedure TForm13.ListView1UpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
  Element: TListItemDrawable;
  PositionDebut, LargeurImage, LargeurDispo : Single;
  Hauteur : Integer;
  Coche : String;
begin

 if (AItem.Purpose<>TListItemPurpose.None) then Exit;
 if not SwitchSize.IsChecked then Exit;


if SwitchAddImage.ischecked then
 begin
   Element:=AItem.View.FindDrawable('Image');
   LargeurImage:=Element.width;
 end;
 Element:=AItem.View.FindDrawable('Text3');
 LargeurDispo:=ListView1.Width - ListView1.ItemSpaces.Left
                - ListView1.ItemSpaces.Right - Element.PlaceOffset.X;
 Hauteur:= GetTextHeight(TListItemText(Element), LargeurDispo);

 PositionDebut:=Element.PlaceOffset.Y;
 Element.Height:= Hauteur ;
 Element.Width := LargeurDispo;
 AItem.Height := Hauteur + Ceil(PositionDebut);
end;

procedure TForm13.SwitchAddImageSwitch(Sender: TObject);
 procedure addimage;
 var ABind : TFormatExpressionItem;
 begin
   aBind:=Link2ListView.FillExpressions.AddExpression;
   aBind.ControlMemberName:='Image';
   aBind.SourceMemberName:='Graphic';
//   Showmessage(aBind.Index.ToString); ok c'est bien 2
 end;
 procedure dropimage;
 begin
   Link2ListView.FillExpressions.Delete(2);
 end;

begin
 Link2ListView.Active:=False;
 if SwitchAddImage.ischecked then addimage else dropimage;
 Link2ListView.Active:=ClientDataset1.Active;
 SwitchOpenSwitch(Sender);
// Listview1.EndUpdate;
end;

procedure TForm13.SwitchOpenSwitch(Sender: TObject);
begin
 ListView1.BeginUpdate;
 ClientDataset1.Active:=False;
 ClientDataset1.Active:=SwitchOpen.IsChecked;
 ListView1.EndUpdate;
end;


end.

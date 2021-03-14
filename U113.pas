unit U113;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  Data.Bind.EngExt, Fmx.Bind.DBEngExt, System.Rtti, System.Bindings.Outputs,
  Fmx.Bind.Editors, Data.Bind.Components, Data.Bind.DBScope, FMX.ListView,
  Data.DB, Datasnap.DBClient, FMX.Controls.Presentation, FMX.StdCtrls;

type
  Tumain = class(TForm)
    ClientDataSet1: TClientDataSet;
    ListView1: TListView;
    BindSourceDB1: TBindSourceDB;
    BindingsList1: TBindingsList;
    LinkListControlToField1: TLinkListControlToField;
    Switch1: TSwitch;
    StyleBook1: TStyleBook;
    procedure ListView1UpdateObjects(const Sender: TObject;
      const AItem: TListViewItem);
    procedure Switch1Switch(Sender: TObject);
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  umain: Tumain;

implementation

{$R *.fmx}

uses System.Math, FMX.TextLayout;

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



procedure Tumain.ListView1UpdateObjects(const Sender: TObject;
  const AItem: TListViewItem);
var
  Element: TListItemDrawable;
  LargeurDispo : Single;
  Hauteur : Integer;
begin

 if AItem.Purpose<>TListItemPurpose.None then  exit;

 Element:=AItem.View.FindDrawable('Text2');
 LargeurDispo:=ListView1.Width - ListView1.ItemSpaces.Left
                - ListView1.ItemSpaces.Right - Element.PlaceOffset.X;
 Hauteur:= GetTextHeight(TListItemText(Element), LargeurDispo);

 Element.Height:= Hauteur ;
 Element.Width := LargeurDispo;
 AItem.Height := Hauteur + Ceil(Element.PlaceOffset.Y);

end;

procedure Tumain.Switch1Switch(Sender: TObject);
begin
 ClientDataset1.Active:=Switch1.IsChecked;
end;

end.

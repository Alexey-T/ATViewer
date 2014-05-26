unit Unit2;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TFormDeb = class(TForm)
    ListBox3: TListBox;
    ListBox1: TListBox;
    ListBox2: TListBox;
    Memo1: TMemo;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  FormDeb: TFormDeb;

implementation

{$R *.dfm}

procedure TFormDeb.Button1Click(Sender: TObject);
begin
  Listbox1.Items.Clear;
  Listbox2.Items.Clear;
  Listbox3.Items.Clear;
  Memo1.Lines.Clear;
end;

end.

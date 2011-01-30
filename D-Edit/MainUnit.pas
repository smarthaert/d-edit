unit MainUnit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, Menus, StdActns, ExtActns, ToolWin, ActnMan,
  ActnCtrls, XPStyleActnCtrls, ExtCtrls, ImgList;

type
  TMainForm = class(TForm)
		MainMenu: TMainMenu;
    mFile: TMenuItem;
    mNewFile: TMenuItem;
    mFileOpen: TMenuItem;
    mFileSave: TMenuItem;
    mFileSaveAs: TMenuItem;
    mEdit: TMenuItem;
    mUndo: TMenuItem;
    ActionList: TActionList;
    EditCut: TEditCut;
    EditCopy: TEditCopy;
    EditPaste: TEditPaste;
    EditSelectAll: TEditSelectAll;
    EditUndo: TEditUndo;
    EditDelete: TEditDelete;
    FilePrintSetup: TFilePrintSetup;
    FilePageSetup: TFilePageSetup;
    FileExit: TFileExit;
    ActionManager: TActionManager;
    LeftToolBar: TActionToolBar;
    FileNew: TAction;
		Image: TImage;
    mFilePageSetup: TMenuItem;
    mFilePrintSetup: TMenuItem;
    mFileExit: TMenuItem;
    mEditCopy: TMenuItem;
    mEditPaste: TMenuItem;
    mEditSelectAll: TMenuItem;
    mEditDelete: TMenuItem;
    EditRepeat: TAction;
    mEditRepeat: TMenuItem;
    m1: TMenuItem;
    mEditCut: TMenuItem;
    FileOpen: TOpenPicture;
    FileSaveAs: TSavePicture;
    ColorSelect: TColorSelect;
    FontEdit: TFontEdit;
    PrintDlg: TPrintDlg;
    FileSave: TAction;
    m2: TMenuItem;
    m3: TMenuItem;
    ToolbarImageList: TImageList;
    procedure FileNewExecute(Sender: TObject);
    procedure FileSaveExecute(Sender: TObject);
    procedure FileSaveAsAccept(Sender: TObject);
    procedure EditUndoExecute(Sender: TObject);
    procedure EditCutExecute(Sender: TObject);
    procedure EditCopyExecute(Sender: TObject);
    procedure mEditRepeatClick(Sender: TObject);
    procedure FileOpenAccept(Sender: TObject);
  private
    { Private declarations }
	public
		FileName : string;
		procedure ToDo( msg:string );
	end;

var
	MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.ToDo(msg: string);
begin
	ShowMessage('Не реализовано: '+msg);
end;

procedure TMainForm.FileNewExecute(Sender: TObject);
begin
	ToDo('Создать новый (чистый) файл.');
end;

procedure TMainForm.FileSaveExecute(Sender: TObject);
begin
	Image.Picture.SaveToFile(FileName);
	ToDo('Вывести сообщение, что файл сохранён.');
end;

procedure TMainForm.FileSaveAsAccept(Sender: TObject);
begin
	FileName := FileOpen.Dialog.FileName;
	Image.Picture.SaveToFile(FileName);
end;

procedure TMainForm.EditUndoExecute(Sender: TObject);
begin
	ToDo('Откат последнего действия.');
end;

procedure TMainForm.EditCutExecute(Sender: TObject);
begin
	ToDo('Вырезать выделенные объекты в буфер обмена.');
end;

procedure TMainForm.EditCopyExecute(Sender: TObject);
begin
	ToDo('Скопировать выделенные объекты в буфер обмена.');
end;

procedure TMainForm.mEditRepeatClick(Sender: TObject);
begin
	ToDo('Повторение отмененного действия.');
end;

procedure TMainForm.FileOpenAccept(Sender: TObject);
begin
	FileName := FileOpen.Dialog.FileName;
	Image.Picture.LoadFromFile(FileName);
end;

end.

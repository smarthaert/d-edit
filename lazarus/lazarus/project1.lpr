program project1;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms
  { you can add units after this }, unit1, unit2;

begin
  Application.Title:='Записная книга на основе TreeView';
  Application.Initialize;
  Application.CreateForm(Tmain_frm, main_frm);
  Application.CreateForm(Tedit_new_frm, edit_new_frm);
  Application.Run;
end.


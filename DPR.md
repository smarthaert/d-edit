
```
program D_Edit;

uses
  Forms,
  MainUnit in 'MainUnit.pas' {MainForm}; { Подключение модуля с основной формой }

{$R *.res}

begin
  { Application = объект - приложение Windows }
  Application.Initialize; 
  { Добавляем одну форму - главную форму }
  Application.CreateForm(TMainForm, MainForm); 
  { Запускаем приложение }
  Application.Run;
end.
```
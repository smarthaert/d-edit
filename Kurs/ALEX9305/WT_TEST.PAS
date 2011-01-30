Uses WT_Lib;

{ ---=== Тестирующая программа ===--- }
Var Test : TDictionary;
Begin
 { Создаем словарь }
  Test.New('TEST.DIC');
 { Добавляем в него слова }
  Test.Add('ABCDEF');
  Test.Add('ABD');
 { Hаходим нужное слово }
  Writeln(Test.Find('ABC'));
 { Удаляем ненужное слово ;) }
{  Test.Del('ABCDEF');}
 { Сохраняем изменения и закрываем файл }
  Test.Done;
End.
@ECHO OFF
REM 1. OneStr - Одна строка (первая в файле)
BPC -B OneStr.pas
REM 2. TwoStr - Две строки (в начале файла)
BPC -B TwoStr.pas
REM 3. Numbers - Hабор целых чисел типа LongInt
REM  (В конце входных файлов должен стоять перевод каретки !!!)
BPC -B Numbers.pas
REM 4. Test0102 - Специальный тестер для задачи 0102
BPC -B Test0102.pas
REM 5. ThreeStr - Проверка ответов - Три строки (в начале файла)
BPC -B ThreeStr.pas
DEL *.TPU


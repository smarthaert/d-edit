@ECHO OFF
REM 1. OneStr - ���� ��ப� (��ࢠ� � 䠩��)
BPC -B OneStr.pas
REM 2. TwoStr - ��� ��ப� (� ��砫� 䠩��)
BPC -B TwoStr.pas
REM 3. Numbers - H���� 楫�� �ᥫ ⨯� LongInt
REM  (� ���� �室��� 䠩��� ������ ����� ��ॢ�� ���⪨ !!!)
BPC -B Numbers.pas
REM 4. Test0102 - ���樠��� ���� ��� ����� 0102
BPC -B Test0102.pas
REM 5. ThreeStr - �஢�ઠ �⢥⮢ - �� ��ப� (� ��砫� 䠩��)
BPC -B ThreeStr.pas
DEL *.TPU


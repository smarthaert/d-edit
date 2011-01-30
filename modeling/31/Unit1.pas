unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Log: TListBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

uses Math;

{$R *.dfm}

function Gen( Srednee, Razbros : integer ):integer;
begin
  Gen := Random(Razbros*2+1) + Srednee - Razbros;  // Получаем случайную величину X в диапазоне 0..1
end;

type
  Zad = class // Данные об одном задании
    No : Integer; // Номер задачи
    // Состояние задания
    Sost : (Nachalnoe,PunktPriema,NaPervoiObrabotke,Zavershena,VOcherediNaKorrect,Kerrectiruetsa);
    PostPunktPriema : integer; // Время поступления в пункт приёма (оно же время возникновения сообщения)
    ZaverPunktPriema : integer; // Завершена обработка в пункте приёма
    PostNaEVM : integer; // Время поступления на одну из свободных ЭВМ
    noEVM : integer; // На какую именно ЭВМ задание поступило
    OshVvoda : boolean; // Обнаружены ли ошибки ввода при первом поступлении на ЭВМ
    PolzNaIspravlenie : integer; // Время, когда задание отправляется пользователю на исправление
    PostNaEVNPovtorno : integer; // Время поступления на ЭВМ повторно
    ZaverZadachi : integer; // Время завершения задачи
  end;
  EVM = record // Запись содержащая данные об одной ЭВМ
    Zadacha : Zad; // Задача на этой ЭВМ
    SvobodnoeVremya, ZanatoyeVremya : integer; // Свободное время и занятое время
  end;

procedure TForm1.Button1Click(Sender: TObject);
var
  E : array [1..3] of EVM; // 3 ЭВМ
  Z : array [1..100+1] of Zad; // 100 заданий
  V : integer; // Текущее время
  i,j : integer; // Вспомогательные переменные циклов
  MestoKorrectSvobodno : boolean; // Свободно ли место для корректировки
  sum : integer; // Суммарное время ожидания всеми задачами в очереди на ЭВМ
  S : string;

// Количество завершенных задач
function ZaversennihZadach : integer;
var i:integer;
begin
  Result := 0;
  for i:=1 to 100 do
    if (Z[i].Sost = Zavershena) and (Z[i].ZaverZadachi <= V) then
      Inc( Result );
end;

function EVM_Sost( q : integer ):string;
begin
  if E[q].Zadacha = nil then
    Result := '   ЭВМ'+IntToStr(q)+' св.'
  else
    Result := '   ЭВМ'+IntToStr(q)+' занята зад. '+IntToStr(E[q].Zadacha.No);
end;

begin
  // Устанавливаем систему моделирования в начальное состояние
  randomize(); // Инициализируем генератор случайных чисел от таймера, чтобы каждый запуск получать разные результаты
  v := 0; // Время равно 0
  for i:=1 to 100 do begin
    Z[i] := Zad.Create;
    Z[i].No := i;
    Z[i].Sost := Nachalnoe;
    // Следующая задача должна поступить ещё через 20+-5 минут
    v := v + Gen( 20, 5 );
    Z[i].PostPunktPriema := V;
  end;
  v := 0;

  for i:=1 to 3 do
    with E[i] do begin
      Zadacha := nil;
      SvobodnoeVremya := 0;
      ZanatoyeVremya := 0;
    end;
  MestoKorrectSvobodno := true;

  // Общий цикл моделирования, пока не обработаем 100 задач
  // На каждом шаге этого цикла мы будем моделировать v-ую минуту работы системы
  while ZaversennihZadach < 100 do begin
    Log.Items.Add('Секунда '+IntToStr(V)+'  '+EVM_Sost(1)+' '+EVM_Sost(2)+' '+
      EVM_Sost(3));
    // Пробегаем все 3 ЭВМ
    for j:=1 to 3 do
      with E[j] do
        // Если ЭВМ свободна
        if Zadacha = nil then
          Inc( SvobodnoeVremya ) // Тогда увеличиваем свободное время
        else
          inc( ZanatoyeVremya ); // Иначе увеличиваем занятое время

    for i:=1 to 100 do begin
      // Проверки, что у нас всё задано
//      case Z[i].Sost of

  //    end;
      // Если у задачи состояние начальное и пришло время отправится в пункт приёма
      if (Z[i].Sost = Nachalnoe) and (Z[i].PostPunktPriema = v) then begin
        // Эта задача теперь в пункте приёма
        Z[i].Sost := PunktPriema;
        // И через 12+-3 можно будет отправить
        Z[i].ZaverPunktPriema := V + Gen(12,3);
        Log.Items.Add('Задача '+IntToStr(i)+
          ' возникла и поступила в пункт приёма до '+IntToStr(Z[i].ZaverPunktPriema));
      end;
      // Если задача была в пункте приёма, с ней всё что нужно сделали и отправили на ЭВМ
      if (Z[i].Sost = PunktPriema) and (Z[i].ZaverPunktPriema = v) then begin
        // Ищем первую свободную ЭВМ
        for j:=1 to 3 do
          if E[j].Zadacha = nil then begin
            // Занимаем ЭВМ
            Log.Items.Add('Задача '+IntToStr(i)+' на ЭВМ '+IntToStr(j) + ' на первой обработке');
            Z[i].Sost := NaPervoiObrabotke;
            Z[i].PostNaEVM := V; // Записываем время поступления на ЭВМ
            Z[i].noEVM := j; // Записываем, какая ЭВМ выполняет данную задачу
            Z[i].OshVvoda := Random(100) < 70; // Ошибка ввода в 70% случаев
            // Если ошибка ввода есть
            if Z[i].OshVvoda then begin
              Log.Items.Add('Ошибка ввода в задаче '+IntToStr(i)+'. Планируем исправление оператором');
              // Планируем исправление ошибок оператором
              Z[i].Sost := VOcherediNaKorrect;
            end else begin
              // Планируем завершение задачи
              Z[i].ZaverZadachi := V + Gen(10,5); // 10+-5 минут до завершения
              Log.Items.Add('Задача '+IntToStr(i)+' будет завершена '+IntToStr(Z[i].ZaverZadachi));
              Z[i].Sost := Zavershena;
            end;
            E[j].Zadacha := Z[i];
            break; // Прерываемся, чтобы не занять сразу одной задачей все свободные ЭВМ
          end;
      end;
      // Если задача сейчас завершается, то она освобождает ЭВМ
      if (Z[i].Sost = Zavershena) and (Z[i].ZaverZadachi = V) then begin
        E[Z[i].noEVM].Zadacha := nil;
        Log.Items.Add('Задача '+IntToStr(i)+' завершена!');
      end;
      // Если задача в очереди на корректировку исходных данных
      if (Z[i].Sost = VOcherediNaKorrect) and MestoKorrectSvobodno then begin
        // Мы занимаем своей задачей место корректировки
        MestoKorrectSvobodno := false;
        // Исходные данные корректируются
        Z[i].Sost := Kerrectiruetsa;
        // Записываем время когда отправили на исправление
        Z[i].PolzNaIspravlenie := V;
        // Задача поступит на ЭВМ повторно через 3+-2 минуты
        Z[i].PostNaEVNPovtorno := V + Gen(3,2);
      end;
      // Если задача корректируется и время корректировки закончилось
      if (Z[i].Sost = Kerrectiruetsa) and (Z[i].PostNaEVNPovtorno = V) then begin
        // Освобождаем место корректировки для других задач
        MestoKorrectSvobodno := true;
        // Отправляем задачу на ту же ЭВМ обратно
        // Мы это можем сделать потому что задача i не освобождала ЭВМ
        Z[i].ZaverZadachi := V + Gen(10,5); // Завершение задачи произойдёт через 10+-5 минут
        Z[i].Sost := Zavershena;
      end;
    end;
    // Увеличиваем время,
    v := v + 1;
  end;

  // Вычисление ответов на поставленные вопросы
  // Среднее время ожидания в очереди
  sum := 0;
  for i:=1 to 100 do
    sum := sum + Z[i].PostNaEVM - Z[i].PostPunktPriema;

  S := '';  
  for j:=1 to 3 do
    S := S + #13#10 + 'ЭВМ ' + IntToStr(j) + ' свободна ' +
      IntToStr(E[j].SvobodnoeVremya) + ' сек. из ' +
      IntToStr(E[j].SvobodnoeVremya + E[j].ZanatoyeVremya);

  Label1.Caption:='Среднее время ожидание в очереди:'+#13#10+
    FloatToStr(sum / 100) + ' ' + S;
end;

end.

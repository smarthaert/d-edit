{
Version.PAS, adjuster.
Copyright by Leonid Youriev CCTsoft 1993


*** Для получения требуемой конфигурации ВКЛЮЧИТЕ или ВЫКЛЮЧИТЕ
        соответствующие DEFINE.
        Пример:
        {$DEFINE StackTest - включит контроль стека внутри кода, а
        {/$DEFINE StackTest - выключит.
}


{/$DEFINE       Turbo6}      {Для Turbo Pascal 6.0}
{$DEFINE        Turbo7}      {Для Turbo Pascal 7.0}

{/$DEFINE       RangeTest}   {Контроль диаппазонов значений переменных}
{$DEFINE        StackTest}   {Контроль переполнения стека}
{/$DEFINE       OverTest}    {Контроль переполнения при вычислениях}
{                    ^Внимание! контроль переполнения дает
                     "Runtime error 215" во многих модулях, это не есть ошибки}

{/$DEFINE       WordAlign}   {Выравнивание данных на границу слова

{/$DEFINE       FarCall}     {Дальние вызовы порцедур и функций
{/$DEFINE       Overlays}    {Поддержка оверлеев}
{$DEFINE        use286}      {Использование инструкций INTEL 80286}
{/$DEFIN        use8087}     {Использование мат. сопроцессора}
{/$DEFINE       Emulator}    {Эмуляция мат.сопроцессора при его отсутствии}
{/$DEFINE       DoubleReal}  {Real для точных вычислений}

{/$DEFINE       EventMultiHandlers}     {Допускает выход TEvent за пределы
                                         модальной группы}
{/$DEFINE       KillLostEvents}         {Уничтожение необработанных событий}
{$DEFINE        NortonButtons}          {Выделение активной TButton  и }
{$DEFINE        CollectionCheckRange}   {Проверка состяния coIndexError}
{$DEFINE        StreamDestCheck}        {Проверка адресов на NIL в
                                         ?Stream.Read}
{$DEFINE        SupportMasterFont}      {Поддержка [X] и () в стиле Windows}
{$DEFINE        SupportMasterMouse}     {Поддержка "графческой мыши"}
{$DEFINE        AutoMasterFont}         {Автоустановка стиля прорисовки [X] и
                                         ()}
{/$DEFINE       UsePortTalk}            {Использование SYSVARS.PortTalk}
{$DEFINE        useINT0}                {Использование INT0 для переключения
                                         параллельных процессов, деление на 0
                                         обрабатывается корректно}
{/$DEFINE       useINT3}                {Использование INT3 для переключение
                                         параллельных процессов, работа
                                         отладчика невозможна}
{/$DEFINE       AntiCopy}               {Задействование МИНИМАЛЬНОЙ защиты от
                                         копирования}
{$DEFINE        UseDark}                {Поддержка разделения времени}

{
************>>>>      Изменять что-либо ниже не рекомендую...  <<<<**********
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
}

{$IFDEF Pass2}

const   {!Здесь может возникать " Error 129: ENDIF directive missing."
         ── это ошибка предкомпилятора (или "сюрприз" ── срабатывает
         на 13! модуле в чепочке компиляций), бейте борландов и канов ──
         я не виноват.
         Если достанет выход такой
              Вместо BUILD (tpc /B) удаляйте все TPU и делайте два-три...
              раза MAKE (tpc /M)                      }

{$IFDEF Turbo6}
{$IFDEF Turbo7
{$ERROR Либо для Turbo 6.0, либо для Turbo 7.0}
{$ENDIF}
        vmtHeaderSize   = 4;
{$UNDEF OverTest}
{$ELSE}
{$IFDEF Turbo7}
        vmtHeaderSize   = 8;
{$ELSE}
{$ERROR Либо для Turbo 6.0, либо для Turbo 7.0}
{$ENDIF}
{$ENDIF}

{$IFDEF useINT0}
{$IFDEF useINT3}
{$ERROR INT0 либо INT3, либо вообще не использовать прерывания}
{$ENDIF}
{$ENDIF}

{$IFDEF DoubleReal}
type
        Real    = Extendet;
{$ENDIF}

{$IFDEF OverTest}
{$Q+}
{$ELSE}
{$Q-}
{$ENDIF}

{$IFDEF StackTest}
{$S+}
{$ELSE}
{$S-}
{$ENDIF}

{$IFDEF RangeTest}
{$R+}
{$ELSE}
{$R-}
{$ENDIF}

{$UNDEF Pass2}

{$ELSE}

{$IFDEF Overlays}
{$DEFINE FarCall}
{$ENDIF}

{$IFDEF FarCall}
{$F+}
{$ELSE}
{$F+}
{$ENDIF}

{$IFDEF Overlays}
{$O+}
{$ELSE}
{$O+}
{$ENDIF}

{$IFDEF use286}
{$G+}
{$ELSE}
{$G-}
{$ENDIF}

{$IFDEF WordAlign}
{$A+}
{$ELSE}
{$A-}
{$ENDIF}

{$D+,X+,I-,B-,V-,L-}

{$IFNDEF Turbo6}
{$T-,P-}
{$ENDIF}

{$IFDEF use8087}
{$N+}
{$ELSE}
{$UNDEF DoubleReal}
{$N-}
{$ENDIF}

{$DEFINE Pass2}
{$ENDIF}



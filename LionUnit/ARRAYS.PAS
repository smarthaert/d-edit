{ * ARRAYS.PAS - Массивы * }
Unit Arrays;

Interface

{ - Целочисленные типы - }
{ Shortint   -128..127                 Signed 8-bit }
{ Integer    -32768..32767             Signed 16-bit }
{ Longint    -2147483648..2147483647   Signed 32-bit }
{ Byte       0..255                    Unsigned 8-bit }
{ Word       0..65535                  Unsigned 16-bit }
Const MaxByteArray = 65534;
Type TByteArray = Array [0..MaxByteArray] of Byte;
     PByteArray = ^TByteArray;
Const MaxLongIntArray = 16382;
Type TLongIntArray = Array [0..MaxLongIntArray] of LongInt;
     PLongIntArray = ^TLongIntArray;
{ - Символьный тип - }
Const MaxCharArray = 65534;
Type TCharArray = Array [0..MaxCharArray] of Char;
     PCharArray = ^TCharArray;

Implementation

End.
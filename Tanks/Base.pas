unit Base;

interface

Uses DXDraws;

Const
  MESize=4;
  NRPixelSize=32 Div MESize;

{ Ќаправлени€ и спрайты дл€ разных направлений }
type
  TDir = (_Up,_Down,_Left,_Right);
  TDirImages=Array[TDir]Of TPictureCollectionItem;

  TMENotRazed=Array[1..MESize,1..MESize]of Byte;
  //TypeMapElement
  TME=(meSpace,meDWall,meSlow,meWater,meStart,meWall,meDiagUL,meDiagUR,meBase,meBaseRazed);

implementation

end.

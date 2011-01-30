Type
  Point3D = Record
    X,Y,Z : Real;
  End;

Var Tau,R:Real;
Begin
  Tau:=(1+sqrt(5))/2;
  r:=Tau-0.5;
  Writeln(sqrt(sqr(1)+sqr(0.5)));
  Writeln(r:0:6);
(*  for (i=0;i<5;i++){
          I3[i+1][0] = int(20*cos(i*pi/2.5));
          I3[i+1][1] = int(20*sin(i*pi/2.5));
          I3[i+1][2] = +10;
          I3[i+6][0] = int(20*cos((i+0.5)*pi/2.5));
          I3[i+6][1] = int(20*sin((i+0.5)*pi/2.5));
          I3[i+6][2] = -10;
        };
{  I3[0][0]  = 0; I3[0][1]  = 0; I3[0][2] = int(20*r);
  I3[11][0] = 0; I3[11][1] = 0; I3[11][2] = -int(20*r);}*)
End.
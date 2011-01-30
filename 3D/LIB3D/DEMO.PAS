uses graph,Library3D,crt;
const
	Nm=10;
var
	gd,gm:integer;
	ts:TScreen;
    T3D:T3DMatric;
    T3DO:T3DObject;
	tz:single;
	KubKrd:^TKord;
	KubSoed:^TSoed;
    i,j:word;
begin
    GetMem(KubKrd,60000);
    GetMem(KubSoed,60000);
    for i:=1 to Nm do
    	for j:=1 to Nm do begin
			KubKrd^[i*Nm+j-Nm,1]:=sin(pi/Nm*2*j)*cos(pi/Nm*(integer(i)-Nm/2-0.5))*3;
			KubKrd^[i*Nm+j-Nm,2]:=cos(pi/Nm*2*j)*cos(pi/Nm*(integer(i)-Nm/2-0.5))*3;
			KubKrd^[i*Nm+j-Nm,3]:=sin(pi/Nm*(integer(i)-Nm/7-0.5))*8;
        end;
    for i:=1 to Nm do
     	for j:=1 to Nm do begin
			KubSoed^[Nm*Nm+i*Nm+j-Nm,1]:=i*Nm+j-Nm;
			KubSoed^[Nm*Nm+i*Nm+j-Nm,2]:=i*Nm+j
		end;
    for i:=1 to Nm do
		for j:=1 to Nm do begin
			KubSoed^[i*Nm+j-Nm,1]:=j*Nm+i-Nm;
			if i<Nm then
			KubSoed^[i*Nm+j-Nm,2]:=j*Nm+i-Nm+1
			else
			KubSoed^[i*Nm+j-Nm,2]:=j*Nm+1-Nm;
		end;
	initgraph(gd,gm,'');
	T3D.init;
	TS.init(32,20,16,10);
	t3d.look(0,2,-9,0,0,0);
	T3DO.init(Nm*Nm,Nm*Nm*2-Nm,KubKrd,KubSoed,@TS,@T3D);
	T3DO.Rotation(0,0,0,1,pi/2);
	T3DO.Transporent(0.5,-1,0);
	T3DO.Draw;
	i:=0;
	repeat
		delay(300);
		T3DO.Rotation(0,0,0,3,pi/100);
		T3DO.Rotation(0,0,0,2,pi/50);
		T3D.Rotation(3,0.01);
		T3DO.Rotation(0,0,0,1,0.06);
		clearDevice;
		T3DO.Draw;
	until KeyPressed;
	FreeMem(KubKrd,60000);
	FreeMem(KubSoed,60000);
end.
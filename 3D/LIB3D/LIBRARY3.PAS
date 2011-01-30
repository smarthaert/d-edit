unit Library3D;
								INTERFACE
uses graph;
type
	TMatric=array[1..4,1..4] of single;
type
	P3DMatric=^T3DMatric;
	T3DMatric=object
		Matric:TMatric;
        constructor Init;
        procedure Rotation(axis:byte;Theta:single);
        procedure Transporent(x,y,z:single);
        procedure Look(ex,ey,ez,dx,dy,dz:single);
        function PX(x,y,z:single):single;
        function PY(x,y,z:single):single;
        function PZ(x,y,z:single):single;
    end;

type
    PScreen=^TScreen;
    TScreen=object
        XPen,YPen,XOrig,YOrig,Horiz,Vert:integer;
        XScale,YScale:single;
		constructor Init(AHoriz,AVert,XMove,YMove:integer);
        procedure MoveTo(x,y:single);
        procedure LineTo(x,y:single);
        function FnX(x:single):integer;
        function FnY(y:single):integer;
    end;

type
    T2DKord=array[1..5461,1..2] of single;
	TKord=array[1..5461,1..3] of single;
	TSoed=array[1..5461,1..2] of word;

	P3DObject=^T3DObject;
	T3DObject=object
        KolK,KolS:word;
        Kord,Soed:pointer;
        TS:PScreen;
        T3D:P3DMatric;
        constructor Init(AKolK,AKolS:word;AKord,ASoed:pointer;ATS:PScreen;AT3D:P3DMatric);
    	procedure Draw;
        procedure PM(mt:T3DMatric);
        procedure Rotation(x,y,z:single;axis:byte;theta:single);
        procedure Transporent(x,y,z:single);
    end;



								IMPLEMENTATION
const
	PPD=10;
procedure Multiple(var m1:TMatric;m2:TMatric);
var
	i,j,k:byte;
	ar:single;
	b:TMatric;
begin
	for i:=1 to 4 do
    	for j:=1 to 4 do begin
        	ar:=0;
            for k:=1 to 4 do
            	ar:=ar+m2[i,k]*m1[k,j];
            b[i,j]:=ar;
        end;
	for i:=1 to 4 do
    	for j:=1 to 4 do
        	m1[i,j]:=b[i,j];
end;

function Angle(ax,ay:single):single;
begin
	if not (Abs(ax)>=0.00001) then begin
    	Angle:=Pi/2;
        if ay<0.00001 then Angle:=Pi/2*3;
        if Abs(ay)<0.00001 then Angle:=0;
    end else begin
        if ax<0 then Angle:=ArcTan(ay/ax)+Pi
    		else Angle:=ArcTan(ay/ax);
    end;
end;

constructor T3DMatric.Init;
var
	i,j:byte;
begin
	for i:=1 to 4 do begin
    	for j:=1 to 4 do
         	Matric[i,j]:=0;
       	Matric[i,i]:=1;
    end;
end;

procedure T3DMatric.Rotation(axis:byte;Theta:single);
var
	a:TMatric;
    i,j:byte;
    ax1,ax2:byte;
	ct,st:single;
begin
	for i:=1 to 4 do
		for j:=1 to 4 do
            a[i,j]:=0;
    a[4,4]:=1;
    a[axis,axis]:=1;
    ax1:=axis+1;
    if ax1=4 then ax1:=1;
    ax2:=ax1+1;
    if ax2=4 then ax2:=1;
	ct:=cos(Theta);st:=sin(Theta);
    a[ax1,ax1]:=ct;
    a[ax2,ax2]:=ct;
    a[ax1,ax2]:=-st;
    a[ax2,ax1]:=st;
    Multiple(Matric,a);
end;

procedure T3DMatric.Transporent(x,y,z:single);
var
	i,j:byte;
    a:TMatric;
begin
	for i:=1 to 4 do begin
    	for j:=1 to 4 do
         	a[i,j]:=0;
       	a[i,i]:=1;
    end;
	a[1,4]:=x;
	a[2,4]:=y;
	a[3,4]:=z;
    Multiple(Matric,a);
end;

procedure T3DMatric.Look(ex,ey,ez,dx,dy,dz:single);
var
	fx,fy,fz,tz:single;
begin
	Transporent(dz,dy,dz);
    fx:=ex-dx;
    fy:=ey-dy;
    fz:=ez-dz;
	Rotation(3,-Angle(fx,fy));
    Rotation(2,Pi-Angle(fz,Sqrt(fx*fx+fy*fy)));
    tz:=Sqrt(fx*fx+fy*fy+fz*fz);
    Rotation(3,Angle(tz*fx,-fz*fy));
    Transporent(0,0,tz);
end;

function T3DMatric.PX(x,y,z:single):single;
begin
	PX:=x*Matric[1,1]+y*Matric[1,2]+z*Matric[1,3]+Matric[1,4];
end;

function T3DMatric.PY(x,y,z:single):single;
begin
	PY:=x*Matric[2,1]+y*Matric[2,2]+z*Matric[2,3]+Matric[2,4];
end;

function T3DMatric.PZ(x,y,z:single):single;
begin
	PZ:=x*Matric[3,1]+y*Matric[3,2]+z*Matric[3,3]+Matric[3,4];
end;

constructor TScreen.Init(AHoriz,AVert,XMove,YMove:integer);
begin
    Horiz:=AHoriz;
    Vert:=AVert;
	XScale:=640/Horiz;
	YScale:=480/Vert;
    XOrig:=XMove;
    YOrig:=YMove;
	XPen:=FnX(0);
	YPen:=FnY(0);
end;

procedure TScreen.MoveTo(x,y:single);
begin
	XPen:=FnX(x);
	YPen:=FnY(y);
end;

procedure TScreen.LineTo(x,y:single);
var
	ox,oy:integer;
begin
	ox:=XPen;
	oy:=YPen;
	XPen:=FnX(x);
	YPen:=FnY(y);
    Line(ox,oy,XPen,YPen);
end;

function TScreen.FnX(x:single):integer;
var
	l:single;
begin
    l:=(XOrig+x)*XScale;
    if abs(l)<32000 then FnX:=Round(l) else
		if l>0 then FnX:=32000 else FnX:=-32000;
end;

function TScreen.FnY(y:single):integer;
var
	l:single;
begin
	l:=(Vert-(YOrig+y))*YScale;
    if abs(l)<32000 then FnY:=Round(l) else
		if l>0 then FnY:=32000 else FnY:=-32000;
end;

constructor T3DObject.Init(AKolK,AKolS:word;AKord,ASoed:pointer;ATS:PScreen;AT3D:P3DMatric);
begin
	Kord:=AKord;
	Soed:=ASoed;
	KolK:=AKolK;
	KolS:=AKolS;
	TS:=ATS;
    T3D:=AT3D;
end;

procedure T3DObject.Draw;
var
	KordIn2D:^TKord;
	Tz:single;
	i:word;
begin
    GetMem(KordIn2D,KolK*8);
	for i:=1 to KolK do begin
        tz:=T3D^.PZ(TKord(Kord^)[i,1],TKord(Kord^)[i,2],TKord(Kord^)[i,3]);
    	KordIn2D^[i,1]:=T3D^.PX(TKord(Kord^)[i,1],TKord(Kord^)[i,2],TKord(Kord^)[i,3])/tz*PPD;
    	KordIn2D^[i,2]:=T3D^.PY(TKord(Kord^)[i,1],TKord(Kord^)[i,2],TKord(Kord^)[i,3])/tz*PPD;
        KordIn2D^[i,3]:=tz;
	end;
    for i:=1 to KolS do begin
       if (KordIn2D^[TSoed(Soed^)[i,1],3]>0) and (KordIn2D^[TSoed(Soed^)[i,2],3]>0) then begin
        TS^.MoveTo(KordIn2D^[TSoed(Soed^)[i,1],1],KordIn2D^[TSoed(Soed^)[i,1],2]);
        TS^.LineTo(KordIn2D^[TSoed(Soed^)[i,2],1],KordIn2D^[TSoed(Soed^)[i,2],2]);end;
    end;
    FreeMem(KordIn2D,KolK*8);
end;

procedure T3DObject.PM(mt:T3DMatric);
var
	nx,ny,nz:single;
	i:word;
begin
    for i:=1 to KolK do begin
		nx:=TKord(Kord^)[i,1];
		ny:=TKord(Kord^)[i,2];
		nz:=TKord(Kord^)[i,3];
		TKord(Kord^)[i,1]:=mt.PX(nx,ny,nz);
		TKord(Kord^)[i,2]:=mt.PY(nx,ny,nz);
		TKord(Kord^)[i,3]:=mt.PZ(nx,ny,nz);
    end;
end;

procedure T3DObject.Rotation(x,y,z:single;Axis:byte;Theta:single);
var
	mt:T3DMatric;
begin
	mt.Init;
    mt.Transporent(-x,-y,-z);
    mt.Rotation(Axis,Theta);
    mt.Transporent(x,y,z);
	PM(mt);
end;

procedure T3DObject.Transporent(x,y,z:single);
var
	mt:T3DMatric;
begin
	mt.Init;
    mt.Transporent(x,y,z);
	PM(mt);
end;

end.
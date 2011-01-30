unit valuegrabber;

interface
type
tvaluetype=(TString,TInteger);

tp2rec=^trec;


tpair=record
str:string;
valtype:tvaluetype;
end;

trec=record
p2next:tp2rec;
pair:tpair;
end;

valueaccumulator=object
p2first:tp2rec;
p2last:tp2rec;
function empty:boolean;
function get:tpair;
procedure put(str:string);
constructor init;
destructor done;
end;

implementation

constructor valueaccumulator.init;
//конструктор
begin
p2first:=nil;
p2last:=nil;
end;

procedure valueaccumulator.put(str:string);
var
p:tp2rec;valcheck:longint;valcode:word;
begin
	new(p);
	p^.pair.str:=str;

	val(str,valcheck,valcode);

	if valcode=0 then p^.pair.valtype:=TInteger else p^.pair.valtype:=TString;


	if empty then
	begin
		p2first:=p;
		p2last:=p;
		p^.p2next:=nil;
	end
else
	begin
		p2last^.p2next:=p;
		p^.p2next:=nil;
		p2last:=p;
	end;
end;

function valueaccumulator.get:tpair;
var p:tp2rec;
begin
	if empty then  begin get.valtype:=TString;get.str:=''; end else
		begin
		p:=p2first;
		get:=p^.pair;
		p2first:=p^.p2next;
		dispose(p);
		if p2first=nil then p2last:=nil;
		end;
end;

function valueaccumulator.empty:boolean;
	begin
	empty:=(p2first=nil);
	end;

destructor valueaccumulator.done;
var p:tp2rec;
	begin
		while p2first<>nil do
			begin
				p:=p2first;
				p2first:=p^.p2next;
				dispose(p);
			end;
	end;

end.

//TODO создать наследника от парсящего класса прямо в визуальном проекте
//TODO понять почему происходит из-за этого ошибка
//TODO сделать функцию для обратного расконвертирования переменных или переделать список под указатели,мдя
//TODO написать хотя бы одну тестовую функцию

unit Parslib;

interface
uses  sysutils;
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

valueaccumulator=class
p2first:tp2rec;
p2last:tp2rec;
function empty:boolean;
function get:tpair;
procedure put(str:string);
constructor init;
destructor done;
end;

TInterpreter=class
function parse(inputstr:string;var identifier,cerror:string;var valuecontainer:valueaccumulator):boolean;
procedure execute(identifier:string;valuecontainer:valueaccumulator);virtual;
DebugPos:longint;
end;

implementation

type
TState=(start,outlexem,ident,leftbr,value,separator,rightbr,cend);
const
SEPCONST=',';
ENDCONST=';';

//описание сборщика параметров
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
//конец  описания

//описание парсера

procedure TInterpreter.execute(identifier:string;valuecontainer:valueaccumulator);
begin

end;

function TInterpreter.parse(inputstr:string;var identifier,cerror:string;var valuecontainer:valueaccumulator):boolean;

var state:TState;i:integer;
	gleft,gright,paramcount:integer;
	//identifier:string;
begin

paramcount:=0;
state:=start;

for i:=1 to length(inputstr) do
	begin

	case state of
		start://начало ^_^
			case inputstr[i] of
				'A'..'Z','a'..'z':
					begin
					state:=ident;
					gleft:=i;
					end;
				//' ':state=outlexem;
				else
					begin
					cerror:='syntax error';
					exit;
					end;
			end;
		ident://идентификатор команды
			case inputstr[i] of
				'A'..'Z','a'..'z','0'..'9','_':;
				'(':
					begin
						state:=leftbr;//забирание имени идента
						gright:=i;
						identifier:=trim(copy(inputstr,gleft-1,gright-gleft));
					end;
				' '://идент должен быть непрерывным и без пропуска перед скобкой
				begin
				cerror:='syntax error';
				exit;
				end;
			end;
		leftbr://левая скобка
			case inputstr[i] of
			        'A'..'Z','a'..'z','0'..'9':
					begin
						state:=value;
						gleft:=i;
						inc(paramcount);
					end;
				' ':state:=leftbr;
				else
					begin
					cerror:='syntax error';
					exit;
					end;
			end;
		value://начать отсчитывать позицию параметра и их количество
			case inputstr[i] of
				'A'..'Z','a'..'z','0'..'9':;
				',':
					begin
						state:=separator;
						gright:=i;
						//передача в аккумулятор
						valuecontainer.put(trim(copy(inputstr,gleft,gright-gleft)))
						//copy(inputstr,gleft,gright-gleft+1) поместить это куданить(это параметр), может в динамический массив

					end;
				')':state:=rightbr;
				' ':
					begin
						state:=outlexem;
						gright:=i;
						//передача в аккумулятор
						valuecontainer.put(trim(copy(inputstr,gleft,gright-gleft)))
						//поместить это куданить(это параметр), может в динамический массив
					end;
				';':
					begin
					cerror:='syntax error';
					exit;
					end;
			end;
		outlexem://пустое пространство после параметра перед разделителем
			case inputstr[i] of
				',':state:=separator;
				' ':;
				else
					begin
						cerror:='syntax error';
						exit;
					end;
			end;
		separator://разделитель
			case inputstr[i] of
				'A'..'Z','a'..'z','0'..'9':
					begin
						state:=value;
						gleft:=i;
						inc(paramcount);
					end;
				')',';':
					begin
						cerror:='syntax error';
						exit;
					end;
				' ':;
				else
					begin
					cerror:='syntax error';
					exit;
					end;
			end;
		rightbr://правая скобка
			case inputstr[i] of
				';':state:=cend;
				else
					begin
					cerror:='syntax error';
					exit;
					end;
			end;
		cend://разделитель команд
			begin
			DebugPos:=i;
			state:=start;//вообще-то после cend должна выпоняться команда
			
			//execute(identifier,valuecontainer);
			end;

	end;
end;
end;
//конец описания
end.

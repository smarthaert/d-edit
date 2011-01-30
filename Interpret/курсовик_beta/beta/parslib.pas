unit Parslib;

interface
uses  sysutils;
type


TInterpreter=object
Constructor Init;
Destructor done;
procedure parsefirst;
procedure parse;
procedure execute;virtual;abstract;
procedure executeall;
inputstr:ansistring;
ident:ansistring;
cerror:ansistring;
valparr: array of longint;
DebugPos:longint;
procedure showerror();virtual;abstract;
end;

implementation

type
TState=(start,outlexem,identifier,leftbr,value,separator,rightbr,cend);
const
SEPCONST=',';
ENDCONST=';';


constructor TInterpreter.Init;
begin
debugpos:=1;
end;

destructor TInterpreter.done;
begin
end;

procedure TInterpreter.parsefirst;
begin
debugpos:=1;
end;

procedure TInterpreter.parse();

var state:TState;i:integer;

	valueagg:string;

begin
cerror:='';
if inputstr[length(inputstr)]<>' ' then inputstr:=inputstr+' ';
state:=start;
ident:='';
valueagg:='';
setlength(valparr,0);
if debugpos>=length(inputstr) then exit;
for i:=debugpos to length(inputstr) do
	begin

	case state of
		start://начало ^_^
			case inputstr[i] of
                                ' ',#13,#10:;
				'A'..'Z','a'..'z','а'..'я','А'..'Я':
					begin
					state:=identifier;
					ident:=ident+inputstr[i];
					end;
				//' ':state=outlexem;
				else
					begin
					cerror:='syntax error';
                                        showerror;
                                        debugpos:=i;
					exit;
					end;
			end;
		identifier://идентификатор команды
			case inputstr[i] of
				'A'..'Z','a'..'z','а'..'я','А'..'Я','0'..'9','_':ident:=ident+inputstr[i];
				'(':
					begin
						state:=leftbr;//забирание имени идента

						ident:=trim(ident);

					end;
				' '://идент должен быть непрерывным и без пропуска перед скобкой
				begin
				cerror:='wait "(" but "'+inputstr[i]+'" found';
                                debugpos:=i;
                                showerror;
                                exit;
				end;
			end;
		leftbr://левая скобка
			case inputstr[i] of
			        '0'..'9':
					begin
						setlength(valparr,1);
						state:=value;
						valueagg:='';
						valueagg:=valueagg+inputstr[i];
					end;
				' ':state:=leftbr;
				else
					begin
					cerror:='wait value, but "'+inputstr[i]+'" found';
                                        debugpos:=i;
                                        showerror;
                                        exit;
					end;
			end;
		value://начать отсчитывать позицию параметра и их количество
			case inputstr[i] of
				'0'..'9':valueagg:=valueagg+inputstr[i];
				',':
					begin
						state:=separator;
						valparr[length(valparr)-1]:=strtoint(trim(valueagg));//забор параметра в динамический массив
						valueagg:='';

						//copy(inputstr,gleft,gright-gleft+1) поместить это куданить(это параметр), может в динамический массив

					end;
				')':
                                      begin
						state:=rightbr;
						valparr[length(valparr)-1]:=strtoint(trim(valueagg));//забор параметра в динамический массив
						valueagg:='';
                                      end;

				' ':
					begin
						state:=outlexem;
						//valparr[length(valparr)]:=strtoint(valueagg);//забор параметра в динамический массив
						//valueagg:='';
						//поместить это куданить(это параметр), может в динамический массив
					end;
				';':
					begin
					cerror:='wait value or delimiter, but "'+inputstr[i]+' found';
                                        debugpos:=i;
                                        showerror;
					exit;
					end;
			end;
		outlexem://пустое пространство после параметра перед разделителем
			case inputstr[i] of
				',':
					begin
					state:=separator;
					valparr[length(valparr)]:=strtoint(trim(valueagg));//забор параметра в динамический массив
					valueagg:='';
					end;
				' ':
					begin
					state:=outlexem;
					valparr[length(valparr)]:=strtoint(trim(valueagg));//забор параметра в динамический массив
					valueagg:='';
					end;
				else
					begin
						cerror:='wait delimiter or brace, but "'+inputstr[i]+'" found';
                                                debugpos:=i;
                                                showerror;
						exit;
					end;
			end;
		separator://разделитель
			case inputstr[i] of
				'0'..'9':
					begin
						state:=value;
						setlength(valparr,length(valparr)+1);
						valueagg:=valueagg+inputstr[i];
					end;
				')',';':
					begin
						cerror:='wait value, but "'+inputstr[i]+'" found';
                                                debugpos:=i;
                                                showerror;
						exit;
					end;
				' ':;
				else
					begin
					cerror:='wait value or whitespace, but "'+inputstr[i]+'" found';
                                        debugpos:=i;
                                        showerror;
					exit;
					end;
			end;
		rightbr://правая скобка
			case inputstr[i] of
				';':state:=cend;
				else
					begin
					cerror:='wait ";" but "'+inputstr[i]+'" found';
                                        debugpos:=i;
                                        showerror;
					exit;
					end;
			end;
		cend://разделитель команд
			begin
			DebugPos:=i;
                          state:=start;//возврат в начальное состояние
                exit;

			end;

	end;
end;
end;

procedure TInterpreter.executeall;
begin
while debugpos<length(inputstr) do
begin
parse;
execute;
end;
end;
//конец описания
end.

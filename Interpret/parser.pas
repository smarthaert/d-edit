//TODO параметры помещать в строковое FIFO, при выполнении выпарсенной функции забирать из него параметры
unit parser;

interface
uses valuegrabber,sysutils;

const
  DigitOrChar = ['A'..'Z','a'..'z','0'..'9'];


type


TInterpreter=object
function parse(inputstr:string;var identifier,cerror:string;var valuecontainer:valueaccumulator):boolean;
function execute(identifier:string,valuecontainer:valueaccumulator,debug:boolean);
DebugPos:longint;
end;


implementation

type
TState=(start,outlexem,ident,leftbr,value,separator,rightbr,cend);
const
SEPCONST=',';
ENDCONST=';';

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



end.

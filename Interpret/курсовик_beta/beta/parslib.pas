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
		start://������ ^_^
			case inputstr[i] of
                                ' ',#13,#10:;
				'A'..'Z','a'..'z','�'..'�','�'..'�':
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
		identifier://������������� �������
			case inputstr[i] of
				'A'..'Z','a'..'z','�'..'�','�'..'�','0'..'9','_':ident:=ident+inputstr[i];
				'(':
					begin
						state:=leftbr;//��������� ����� ������

						ident:=trim(ident);

					end;
				' '://����� ������ ���� ����������� � ��� �������� ����� �������
				begin
				cerror:='wait "(" but "'+inputstr[i]+'" found';
                                debugpos:=i;
                                showerror;
                                exit;
				end;
			end;
		leftbr://����� ������
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
		value://������ ����������� ������� ��������� � �� ����������
			case inputstr[i] of
				'0'..'9':valueagg:=valueagg+inputstr[i];
				',':
					begin
						state:=separator;
						valparr[length(valparr)-1]:=strtoint(trim(valueagg));//����� ��������� � ������������ ������
						valueagg:='';

						//copy(inputstr,gleft,gright-gleft+1) ��������� ��� ��������(��� ��������), ����� � ������������ ������

					end;
				')':
                                      begin
						state:=rightbr;
						valparr[length(valparr)-1]:=strtoint(trim(valueagg));//����� ��������� � ������������ ������
						valueagg:='';
                                      end;

				' ':
					begin
						state:=outlexem;
						//valparr[length(valparr)]:=strtoint(valueagg);//����� ��������� � ������������ ������
						//valueagg:='';
						//��������� ��� ��������(��� ��������), ����� � ������������ ������
					end;
				';':
					begin
					cerror:='wait value or delimiter, but "'+inputstr[i]+' found';
                                        debugpos:=i;
                                        showerror;
					exit;
					end;
			end;
		outlexem://������ ������������ ����� ��������� ����� ������������
			case inputstr[i] of
				',':
					begin
					state:=separator;
					valparr[length(valparr)]:=strtoint(trim(valueagg));//����� ��������� � ������������ ������
					valueagg:='';
					end;
				' ':
					begin
					state:=outlexem;
					valparr[length(valparr)]:=strtoint(trim(valueagg));//����� ��������� � ������������ ������
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
		separator://�����������
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
		rightbr://������ ������
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
		cend://����������� ������
			begin
			DebugPos:=i;
                          state:=start;//������� � ��������� ���������
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
//����� ��������
end.

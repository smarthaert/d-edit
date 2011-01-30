//TODO ��������� �������� � ��������� FIFO, ��� ���������� ����������� ������� �������� �� ���� ���������
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
		start://������ ^_^
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
		ident://������������� �������
			case inputstr[i] of
				'A'..'Z','a'..'z','0'..'9','_':;
				'(':
					begin
						state:=leftbr;//��������� ����� ������
						gright:=i;
						identifier:=trim(copy(inputstr,gleft-1,gright-gleft));
					end;
				' '://����� ������ ���� ����������� � ��� �������� ����� �������
				begin
				cerror:='syntax error';
				exit;
				end;
			end;
		leftbr://����� ������
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
		value://������ ����������� ������� ��������� � �� ����������
			case inputstr[i] of
				'A'..'Z','a'..'z','0'..'9':;
				',':
					begin
						state:=separator;
						gright:=i;
						//�������� � �����������
						valuecontainer.put(trim(copy(inputstr,gleft,gright-gleft)))
						//copy(inputstr,gleft,gright-gleft+1) ��������� ��� ��������(��� ��������), ����� � ������������ ������

					end;
				')':state:=rightbr;
				' ':
					begin
						state:=outlexem;
						gright:=i;
						//�������� � �����������
						valuecontainer.put(trim(copy(inputstr,gleft,gright-gleft)))
						//��������� ��� ��������(��� ��������), ����� � ������������ ������
					end;
				';':
					begin
					cerror:='syntax error';
					exit;
					end;
			end;
		outlexem://������ ������������ ����� ��������� ����� ������������
			case inputstr[i] of
				',':state:=separator;
				' ':;
				else
					begin
						cerror:='syntax error';
						exit;
					end;
			end;
		separator://�����������
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
		rightbr://������ ������
			case inputstr[i] of
				';':state:=cend;
				else
					begin
					cerror:='syntax error';
					exit;
					end;
			end;
		cend://����������� ������
			begin
			DebugPos:=i;
			state:=start;//������-�� ����� cend ������ ���������� �������
			
			//execute(identifier,valuecontainer);
			end;

	end;
end;
end;



end.

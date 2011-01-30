#if 0
	������� ����, ����������� ��������� ������� ���������
 
	����������, ���������� ������� ������:

	RANDOM_VECTOR 	- ��������� �������.
		��������� � ������������� ����� ����������� ������
		� ���� ������, ����� ������ ����� 0 ��-�� ����������.
		���� ���������������� ���������� - ����� �������������
		"������" ��� ������� ���/��� ������� � ������������� �������.

	MAX_VECTOR	- ������� �� ����� �������, ������� BASE-1.
		����� ������ ������ ��� �������� ���/���-���������

	MAX_SIZE	- ������� ������� ������������� �����
	MIN_SIZE 	- ����������� ����� ������������� �����

	MUL_COMPARE 	- ����������������� ��� ��������� � ������� ����������

	NTEST		- ���������� ��������� �� ����, ������� ���
			  ������������ �������� ��� ������ �������


#endif

#include <ctime>
#include <cstdlib>
#include "BigInt.h"
   

#define RANDOM_VECTOR

#define MAX_SIZE 2097152*2

#define MIN_SIZE 4

//#define MUL_COMPARE	

#define NTEST 	1


extern real MaxError;	// ������ �������� ���������
extern real *LongNum1;
extern real *LongNum2;

extern void FastMulInit(ulong MaxLen);
extern void FastMul(const BigInt &A,const BigInt &B, BigInt &C);
extern void FastMulDeInit();

int main() {
	ulong i, curlen;
	long tm;
	BigInt A(MAX_SIZE), B(MAX_SIZE), C(MAX_SIZE*2);

#ifdef MUL_COMPARE
	BigInt D(MAX_SIZE*2);
#endif


#ifdef RANDOM_VECTOR
	for(i=0; i<MAX_SIZE; i++) A.Coef[i]=rand() % BASE;
	for(i=0; i<MAX_SIZE; i++) B.Coef[i]=rand() % BASE;
#else
	for(i=0; i<MAX_SIZE; i++) A.Coef[i]=MAX_DIG;
	for(i=0; i<MAX_SIZE; i++) B.Coef[i]=MAX_DIG;
#endif

	cout << "������� ��������� ����� ���.\n";
	cout << "����� ������������� " << NTEST << " ����������.\n"; 

	FastMulInit(2*MAX_SIZE); 	// ������������ ������ ����������

	for(curlen=MIN_SIZE; curlen<=MAX_SIZE; curlen*=2) {
		cout << "\n�����: " << curlen << "\t���������� ����: " << BASE_DIG*curlen << "\n";
		A.Size=curlen;
		B.Size=curlen;
	
		start();
		for (i=0; i<NTEST; i++) FastMul(A,B,C);
		tm = finish();
		cout << "FastMul\t�����: " << tm << "\t������: " << MaxError << "\n";
	
#ifdef MUL_COMPARE
		start();
		for (i=0; i<NTEST; i++) Mul(A,B,D);
		tm = finish();
		cout << "Mul\t�����: " << tm << "\n";

		// ���������� ������� ?
		for(ulong l=0; l<C.Size || l<D.Size; l++) if (C.Coef[l] != D.Coef[l]) { cout << "�� ������� " << l << " " << C.Coef[l] << "=/=" << D.Coef[l] << "\n"; exit(1); }
#endif

	}
	FastMulDeInit();	
	return 0;
}

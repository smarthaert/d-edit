#if 0
	Главный файл, тестирующий различные способы умножения
 
	Объявления, касающиеся входных данных:

	RANDOM_VECTOR 	- случайные векторы.
		Умножение с балансировкой можно тестировать только
		с этим флагом, иначе ошибки равны 0 из-за сокращений.
		Если закомментировать объявление - будут перемножаться
		"плохие" для чистого БПФ/БПХ векторы с максимальными цифрами.

	MAX_VECTOR	- векторы со всеми цифрами, равными BASE-1.
		Очень плохой случай для обычного БПФ/БПХ-умножения

	MAX_SIZE	- верхняя граница перемножаемых чисел
	MIN_SIZE 	- минимальная длина перемножаемых чисел

	MUL_COMPARE 	- раскомментировать для сравнения с обычным умножением

	NTEST		- количество умножений на тест, полезно для
			  исследования операций над малыми числами


#endif

#include <ctime>
#include <cstdlib>
#include "BigInt.h"
   

#define RANDOM_VECTOR

#define MAX_SIZE 2097152*2

#define MIN_SIZE 4

//#define MUL_COMPARE	

#define NTEST 	1


extern real MaxError;	// ошибка быстрого умножения
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

	cout << "Быстрое умножение через БПХ.\n";
	cout << "Время соответствует " << NTEST << " умножениям.\n"; 

	FastMulInit(2*MAX_SIZE); 	// максимальный размер результата

	for(curlen=MIN_SIZE; curlen<=MAX_SIZE; curlen*=2) {
		cout << "\nДлина: " << curlen << "\tДесятичных цифр: " << BASE_DIG*curlen << "\n";
		A.Size=curlen;
		B.Size=curlen;
	
		start();
		for (i=0; i<NTEST; i++) FastMul(A,B,C);
		tm = finish();
		cout << "FastMul\tВремя: " << tm << "\tОшибка: " << MaxError << "\n";
	
#ifdef MUL_COMPARE
		start();
		for (i=0; i<NTEST; i++) Mul(A,B,D);
		tm = finish();
		cout << "Mul\tВремя: " << tm << "\n";

		// результаты совпали ?
		for(ulong l=0; l<C.Size || l<D.Size; l++) if (C.Coef[l] != D.Coef[l]) { cout << "На позиции " << l << " " << C.Coef[l] << "=/=" << D.Coef[l] << "\n"; exit(1); }
#endif

	}
	FastMulDeInit();	
	return 0;
}

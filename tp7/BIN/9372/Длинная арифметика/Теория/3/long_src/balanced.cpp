#if 0

	БПХ-умножение с балансировкой.

	Сама балансировка осуществляется функцией BalanceData().
	Обратное преобразование данных заложено в функцию CarryNormalize().

	В остальном - полностью совпадает с обычным БПХ-умножением,
	причем та же балансировка может быть без изменений перенесена на
	БПФ-умножение.	

#endif


#include <cmath>
#include "general.h"
#include "BigInt.h"

real MaxError;
real *LongNum1=NULL, *LongNum2=NULL;

extern void FHT_F(real*, ulong);
extern void FHT_T(real*, ulong);
extern void CreateSineTable(ulong);


void FHTConvolution(real *LongNum1, const real *LongNum2, ulong Len) {
	ulong Step=2, Step2=Step*2;
	ulong x,y;

	LongNum1[0]   = LongNum1[0] * 2.0 * LongNum2[0];
	LongNum1[1]   = LongNum1[1] * 2.0 * LongNum2[1];

	while (Step < Len) {
		for (x=Step,y=Step2-1;x<Step2;x+=2,y-=2) {
			real h1p,h1m,h2p,h2m;
			real s1,d1;
			h1p=LongNum1[x];
			h1m=LongNum1[y];
			s1=h1p+h1m;
			d1=h1p-h1m;
			h2p=LongNum2[x];
			h2m=LongNum2[y];
			LongNum1[x]=(h2p*s1+h2m*d1);
			LongNum1[y]=(h2m*s1-h2p*d1);
		}
		Step*=2;
		Step2*=2;
	}

}


// Балансировка данных
void BalanceData(real *Num, ulong Len) {
	real Carry=0;
	ulong x;

	for (x = 0; x < Len; x++) {
		Num[x]+=Carry;
		Carry=0;
		if (Num[x] >= (BASE/2)) {
			Carry=1;
			Num[x]-=BASE;
		}
	}
	if (Carry > 0)
		Num[0]-=Carry;
}


// Только для балансированных данных 
void CarryNormalize(real *Num,ulong Len, BigInt &C) {
	real Borrow=0, Dig;
	real RawPyramid,Pyramid,PyramidError;
	ulong x;
	real inv = 0.5/ Len;
	ushort *c = C.Coef;

	MaxError=0;


	for (x=0;x<Len;x++) {
		RawPyramid=Num[x]*inv;

		// округлить и посчитать ошибку

		if (RawPyramid < 0) Pyramid=-floor((-RawPyramid)+0.5);
		else Pyramid= floor(RawPyramid+0.5);

		PyramidError=fabs(RawPyramid-Pyramid);
		if (PyramidError > MaxError) MaxError=PyramidError;

		// сделать переносы
		Dig=Pyramid+Borrow;
		Borrow=0;

		Borrow=floor(Dig/BASE);
		Dig=Dig-Borrow*BASE;
		if (Dig < 0) {Dig+=BASE;Borrow--;}

		c[x] = (short)Dig;
	}


	// учесть последний перенос
	x=0;
	short Carry = (short)Borrow;

	while (Carry) {
		c[x]+=Carry;
		Carry=0;
		if (c[x] >= BASE) {c[x]-=BASE;Carry=1;}
		x++;
		if (x >= Len) break;
	}

	// обновить размер результата
	do { x--; } while (c[x]==0); 
	C.Size = x+1;

}



void FastMul(const BigInt &A,const BigInt &B, BigInt &C) {
	ulong Len = 2;
	while ( Len <  A.Size + B.Size ) Len *=2;

	ulong x;
	const ushort *a=A.Coef, *b=B.Coef;

	for (x = 0; x < A.Size; x++)    LongNum1[x] = a[x];
	for (; x < Len; x++) 		LongNum1[x] = 0.0;

	BalanceData(LongNum1,Len);

	FHT_F(LongNum1,Len);

	if (a == b) {
		FHTConvolution(LongNum1,LongNum1,Len);
	} else {
		for (x = 0; x < B.Size; x++)    LongNum2[x] = b[x];
		for (; x < Len; x++) 		LongNum2[x] = 0.0;
		BalanceData(LongNum2,Len);
		FHT_F(LongNum2,Len);
		FHTConvolution(LongNum1,LongNum2,Len);
	 }

	FHT_T(LongNum1,Len);

	CarryNormalize(LongNum1,Len,C);

}


void FastMulInit(ulong Len) {
	ulong MaxLen;
	if ((Len & -Len) == Len)
		MaxLen = Len;
	else {
		MaxLen = 2;
		do MaxLen*=2; while (MaxLen < Len);
	}
	LongNum1 = new real[MaxLen];
	LongNum2 = new real[MaxLen];
	CreateSineTable(MaxLen);
}

void FastMulDeInit() {
	delete LongNum1;
	delete LongNum2;
}






#include <cmath>
#include "general.h"
#include "BigInt.h"

real MaxError;
real *LongNum1=NULL, *LongNum2=NULL;

extern void FHT_F(real*, ulong);
extern void FHT_T(real*, ulong);
extern void CreateSineTable(ulong);


void CarryNormalize(real *Convolution, ulong Len, BigInt &C) {
	real inv = 0.5 / Len;
	real RawPyramid, Pyramid, PyramidError, Carry = 0;
	ulong x;
	ushort *c = C.Coef;

	if ( Len > C.SizeMax ) Len=C.SizeMax;

	MaxError = 0;

	for (x = 0; x < Len; x++) {
		RawPyramid = Convolution[x] * inv + Carry;
		Pyramid = floor(RawPyramid + 0.5); 
		PyramidError = fabs(RawPyramid - Pyramid);
		if (PyramidError > MaxError)
			MaxError = PyramidError;
		Carry = floor(Pyramid / BASE);
		c[x] = (short)(Pyramid - Carry * BASE);
	}

	do { x--; } while (c[x]==0); 
	C.Size = x+1;
}





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

void FastMul(const BigInt &A,const BigInt &B, BigInt &C) {
	ulong Len = 2;
	while ( Len <  A.Size + B.Size ) Len *=2;

	if ( Len < 40 ) {
		BigInt Atmp(A), Btmp(B);
		Mul(Atmp,Btmp,C);
		return;
	}

	ulong x;
	const ushort *a=A.Coef, *b=B.Coef;

	for (x = 0; x < A.Size; x++)    LongNum1[x] = a[x];
	for (; x < Len; x++) 		LongNum1[x] = 0.0;

	FHT_F(LongNum1,Len);

	if (a == b) {
		FHTConvolution(LongNum1,LongNum1,Len);
	} else {
		for (x = 0; x < B.Size; x++)    LongNum2[x] = b[x];
		for (; x < Len; x++) 		LongNum2[x] = 0.0;
		FHT_F(LongNum2,Len);
		FHTConvolution(LongNum1,LongNum2,Len);
	 }

	FHT_T(LongNum1,Len);

	CarryNormalize(LongNum1, Len, C);
}


void FastMulInit(ulong Len) {
	ulong MaxLen;
	if ((Len & -Len) == Len)
		MaxLen = Len;
	else {
		MaxLen = 2;
		while (MaxLen < Len) MaxLen*=2;
	}
	LongNum1 = new real[MaxLen];
	LongNum2 = new real[MaxLen];
	CreateSineTable(MaxLen);
}

void FastMulDeInit() {
	delete LongNum1;
	delete LongNum2;
}






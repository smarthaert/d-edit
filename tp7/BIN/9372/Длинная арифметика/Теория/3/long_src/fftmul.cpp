#include <math.h>
#include "general.h"
#include "Complex.h"
#include "BigInt.h"

real MaxError;
real *LongNum1=NULL, *LongNum2=NULL;

extern void RealFFT(real*, ulong, int);


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
}


void FastMulDeInit() {
	delete LongNum1;
	delete LongNum2;
}


void CarryNormalize(real *Convolution, ulong Len, BigInt &C) {
	real inv = 1.0 / (Len/2);
	real RawPyramid, Pyramid, PyramidError, Carry = 0;
	ushort *c = C.Coef;
	ulong x;

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



void RealFFTScalar(real *LongNum1, const real *LongNum2, ulong Len) {
	Complex *CF1=(Complex*)LongNum1;
	const Complex *CF2=(Complex*)LongNum2;

	LongNum1[0] = LongNum1[0] * LongNum2[0];
	LongNum1[1] = LongNum1[1] * LongNum2[1];

	for (ulong x = 1; x < Len/2; x++)
		CF1[x] = CF1[x]*CF2[x];
}


void FastMul(const BigInt &A,const BigInt &B, BigInt &C) {
	ulong x;
	const ushort *a=A.Coef, *b=B.Coef;

	if (!LongNum1 || !LongNum2) error("FastMul not initalized.");

	ulong Len = 2;
	while ( Len <  A.Size + B.Size ) Len *=2;

	for (x = 0; x < A.Size; x++)	LongNum1[x] = a[x];
	for (; x < Len; x++) 		LongNum1[x] = 0.;
	
	RealFFT(LongNum1, Len, 1);

	if (&A == &B) {
		RealFFTScalar ( LongNum1, LongNum1, Len );
	} else {
		for (x = 0; x < B.Size; x++)    LongNum2[x] = b[x];
		for (; x < Len; x++)		LongNum2[x] = 0.;

		RealFFT(LongNum2, Len, 1);
		RealFFTScalar ( LongNum1, LongNum2, Len );
	} 

	RealFFT(LongNum1, Len, -1);

	CarryNormalize(LongNum1, Len, C);
}

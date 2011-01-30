#if 0

	Большие числа. Основные операции.

#endif



#include "BigInt.h"
#include "general.h"
#include <cmath>


BigInt::BigInt() {
	SizeMax = Size = 0;
	Coef = NULL;
}


BigInt::BigInt(ulong MaxLen) {
	Coef = new ushort[MaxLen];
	SizeMax = MaxLen;
}


BigInt::BigInt(const BigInt &A) {
	SizeMax = A.SizeMax;
	Size = A.Size;
	Coef = new ushort[SizeMax];
	for(ulong i=0; i<SizeMax; i++) Coef[i] = A.Coef[i];
}

BigInt::~BigInt() {
	delete Coef;
}

void BigInt::zero() {
	for(ulong i=0; i<SizeMax; i++) Coef[i]=0;
	Size=1;
}    


BigInt::operator long() {
	long tmp=0;
	// warning: overflow possible !
	for(ushort i=0; i<Size; i++) tmp += Coef[i]*(long)pow( BASE, (real)i);
	return tmp;
}

	

inline BigInt& BigInt::operator=(const BigInt &A) {
	const ushort *a = A.Coef;
	if (this == &A) return *this;
	if ( SizeMax < A.Size ) {
		delete Coef;
		Coef = new ushort[A.Size];
		SizeMax = Size = A.Size;
	} else Size = A.Size;
	for(ulong l=0; l<Size; l++)
		Coef[l] = a[l];
	return *this;
}


void Add(const BigInt &A, const BigInt &B, BigInt &C) {
	ulong i;
	long temp;
	const ushort *a=A.Coef, *b=B.Coef;
	ushort *c=C.Coef, carry = 0;

	if ( A.Size < B.Size ) {
		Add(B,A,C);
		return;
	}

	for (i=0; i<B.Size; i++) {
		temp = a[i] + b[i] + carry;
		if (temp >= BASE) {
			c[i] = temp - BASE;
			carry = 1;
		} else {
			c[i] = temp;
			carry = 0;
		}
	}

	for (; i < A.Size; i++) {
		temp = a[i] + carry;
		if (temp >= BASE) {
			c[i] = temp - BASE;
			carry = 1;
		} else {
			c[i] = temp;
			carry = 0;
		}
	}
	if (carry) {
		c[i] = carry;
		C.Size = A.Size+1;
	} 
	else C.Size = A.Size;
}



int Sub (const BigInt& A, const BigInt& B, BigInt& C) {
	const ushort *a=A.Coef, *b=B.Coef;
	ushort *c=C.Coef;
	ulong i;
	long temp;
	short carry=0;
	if ( A.Size < B.Size ) error ("BigSub: size error");

	for (i=0; i<B.Size; i++) {
		temp = a[i] - b[i] + carry;
		if (temp < 0) {
			c[i] = temp + BASE;
			carry = -1;
		} else {
			c[i] = temp;
			carry = 0;
		}
	}

	for (; i<A.Size; i++) {
		temp = a[i] + carry;
		if (temp < 0) {
			c[i] = temp + BASE;
			carry = -1;
		} else {
			c[i] = temp;
			carry = 0;
		}
	}

	i = A.Size-1;
	while ( (i>0) && (c[i]==0) ) i--;
	C.Size = i+1;
	return carry;
}


void SMul(const BigInt &A, const ushort B, BigInt &C) {
	ulong i, temp;
	const ushort *a=A.Coef;
	ushort *c=C.Coef, carry=0; 

	for (i=0; i<A.Size;i++) {
		temp = a[i]*B + carry;
		carry = temp / BASE;
		c[i] = temp - carry*BASE;
	}

	if (carry) {
		c[i] = carry;
		C.Size = A.Size+1;
	} 
	else C.Size = A.Size;

}



void Mul(const BigInt &A, const BigInt &B, BigInt &C) {
	ulong i, j;
	const ushort *a=A.Coef, *b=B.Coef;
	ushort *c=C.Coef;
	ulong temp, carry;

	for ( i=0; i <= A.Size+B.Size; i++ ) c[i]=0;

	for ( i = 0; i < A.Size; i++) {
		carry = 0;
		for (j = 0; j < B.Size; j++) {
			temp = a[i] * b[j] + c[i+j] + carry;
			carry = temp/BASE;
			c[i+j] = temp - carry*BASE;
		}
		c[i+j] = carry;
	}
	i = A.Size + B.Size - 1;
	if ( c[i] == 0 ) i--;
	C.Size = i+1;
} 

void SDiv(const BigInt &A, const ushort B, BigInt &Q, ushort &R) {
	short r=0;
	ushort *q=Q.Coef;
	const ushort *a=A.Coef;
	long i, temp;

	for ( i=A.Size-1; i>=0; i--) {
		temp = r*BASE + a[i]; // вначале r=0
		q[i] = temp / B;
		r = temp - q[i]*B;
	}

	R = r;

	i = A.Size-1;
	while ( (i>0) && (q[i]==0) ) i--;
	Q.Size = i+1;

}


void Div(const BigInt &A, BigInt &B, BigInt &Q, BigInt &R) {
	if ( A.Size < B.Size ) {	
		Q.zero();
		R=A;
		return;
	}
	if ( B.Size == 1) {		
		SDiv ( A, B.Coef[0], Q, R.Coef[0]);
		R.Size = 1;
		return;
	}

	BigInt U(A.Size+1); U = A; U.Coef[A.Size]=0; 

	ushort *b=B.Coef, *u=U.Coef, *q=Q.Coef;
	long n=B.Size, m=U.Size-B.Size;

	long uJ, vJ, i;		
	long temp1, temp2, temp;

	ushort scale;	
	ushort qGuess, r;
	short borrow, carry;

	scale = BASE / ( b[n-1] + 1 );

	if (scale > 1) {		
		SMul (U, scale, U);
		SMul (B, scale, B);
	}


	for (vJ = m, uJ=n+vJ; vJ>=0; --vJ, --uJ) {

		qGuess = (u[uJ]*BASE + u[uJ-1]) / b[n-1];
		r = (u[uJ]*BASE + u[uJ-1]) % b[n-1];

		while ( r < BASE) {	
			temp2 = b[n-2]*qGuess;
			temp1 = r*BASE + u[uJ-2];

			if ( (temp2 > temp1) || (qGuess==BASE) ) {
				--qGuess;
				r += b[n-1];
			} else break;
		}

		carry = 0; borrow = 0; 
		ushort *uShift = u + vJ;

		for (i=0; i<n;i++) {
			temp1 = b[i]*qGuess + carry;  
			carry = temp1 / BASE;
			temp1 -= carry*BASE;       

			temp2 = uShift[i] - temp1 + borrow;	
			if (temp2 < 0) {
				uShift[i] = temp2 + BASE;
				borrow = -1;
			} else {
				uShift[i] = temp2;
				borrow = 0;
			}
		}

		temp2 = uShift[i] - carry + borrow;
		if (temp2 < 0) {
			uShift[i] = temp2 + BASE;
			borrow = -1;
		} else {
			uShift[i] = temp2;
			borrow = 0;
		}
		

		if (borrow == 0) {
			q[vJ] = qGuess;
		} else {
			q[vJ] = qGuess-1;

			carry = 0;
			for (i=0; i<n; i++) {
				temp = uShift[i] + b[i] + carry;
				if (temp >= BASE) {
					uShift[i] = temp - BASE;
					carry = 1;
				} else {
					uShift[i] = temp;
					carry = 0;
				}
			}
			uShift[i] = uShift[i] + carry - BASE;
		}
		i = U.Size-1;
		while ( (i>0) && (u[i]==0) ) i--;
		U.Size = i+1;

	}
	while ( (m>0) && (q[m]==0) ) m--;
	Q.Size = m+1;
	
	if (scale > 1) {
		ushort junk;
		SDiv ( B, scale, B, junk);
		SDiv ( U, scale, R, junk);
	} else R=U;	
}
		

ostream& operator<<(ostream& os, const BigInt& A) {
	long j, Digit=0;
	short Pow, Dec, Coef;

	os << A.Coef[A.Size-1];

	for (long i=A.Size-2; i>=0; i--) {
		Pow = BASE/10;
		Coef = A.Coef[i];
		for (j=0; j<BASE_DIG; j++) {
			Dec = Coef/Pow;
			Coef -= Dec*Pow;
			Pow /= 10;
			os << Dec;
			Digit++;
			if (Digit%1000==0) os << "\n\n";
			else if (Digit%50==0) os << "\t: " << Digit << "\n";
		}
	}
	return os;
}





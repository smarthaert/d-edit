#if 0

	Большие числа. Основные операции. 
	Выбор основания BASE.

#endif

#ifndef BIGINT_H_INCLUDED_
#define BIGINT_H_INCLUDED_


// В одном из трех #if должна стоять единица...
#if 1
#define BASE 10000	// Основание
#define MAX_DIG 9999	// Максимальная цифра
#define BASE_DIG 4	// Количество десятичных цифр в разряде(для печати)
#endif

#if 0
#define BASE 60000    	// Печать числа будет работать неверно
#define MAX_DIG 59999  
#define BASE_DIG 4
#endif


#if 0
#define BASE 10
#define MAX_DIG 9
#define BASE_DIG 1
#endif


#include <iostream>
#include "general.h"

class BigInt {
public:
	ulong Size, SizeMax;
	ushort *Coef;

	BigInt();
	BigInt(ulong);
	BigInt(const BigInt&);
	virtual ~BigInt();

	void zero();

	BigInt& operator=(const BigInt&);
	operator long();
};

void Add(const BigInt&, const BigInt&, BigInt&);
int  Sub(const BigInt&, const BigInt&, BigInt&);
void Div(const BigInt&, BigInt&, BigInt&, BigInt&);
void SMul(const BigInt&, const ushort B, BigInt&);
void Mul(const BigInt&, const BigInt&, BigInt&);
void SDiv(const BigInt &A, const ushort B, BigInt &Q, ushort &R);
void Div(const BigInt &A, const BigInt &V, BigInt &Q, BigInt &R);
ostream& operator<<(ostream& os, const BigInt& A);

#endif


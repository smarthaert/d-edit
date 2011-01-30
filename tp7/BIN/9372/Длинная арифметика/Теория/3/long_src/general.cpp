#if 0

	Функции и объявления общего назначения.

#endif

#include "general.h"
#include <iostream>

clock_t	time_global;

void error(char *error_text) {
	std::cout << "Run-time error...\n" << error_text << "\n";
	exit(0);
}

template<class T>
inline void swap(T& a, T& b) {
	T temp = a;
	b = a;
	a = temp;
}

void start() {
	time_global = clock();
}

clock_t finish() {
	return (clock() - time_global);
}


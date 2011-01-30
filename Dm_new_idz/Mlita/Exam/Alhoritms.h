#include "Graph.h"
#include "Stack.h"
#include "Query.h"

#if !defined _ALHORITMS_H_
#define _ALHORITMS_H_
#define LARGE 32000

void Search_Into_Deep(CGraph* Graph, CQuery* PathQuery,int* X,int Source);
void Search_Into_Width(CGraph* Graph,CQuery* PathQuery,int* X, int Source);
void Dejikstra(CGraph* Graph, CStack* PathStack, int* X, int* H, int* T, int Source, int Destination, int& Price);
void Floyd(CGraph* Graph, CQuery* PathQuery,int* T, int* H,int Source,int Destination,int& Price);
void Kraskal(CGraph* Graph, CStack* Stack);
#endif
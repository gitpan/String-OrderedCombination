#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define LIMIT 1000000000	/* Theorical Limit */

#ifdef WIN32
typedef _int64 int_; /* Support Type */
#else
typedef long long int int_; /* Support Type */
#endif

/*
	Dynamic Programming
	binomial(n, k) = binomial(n-1, k-1) + binomial(n-1, k)
*/
 
int_ binomial_coeff(int n,int k) {
	int_ *table;
	int_ result;
	int i, j;
	
	table = (int_ *) malloc(sizeof(int_)*(n+1)*(k+1));
	
	for(i=1;i<=k;i++)
		*(table+i)=0;
	for(i=0;i<=n;i++)
		*(table+(i*(k+1)))=1;
	for(i=1;i<=n;i++)
		for(j=1;j<=k;j++)
			*(table+(i*(k+1))+j)=*(table+((i-1)*(k+1))+j-1)+*(table+((i-1)*(k+1))+j);
	result=*(table+(n*(k+1))+k);
	free(table);
	return result;
 }

/*
	 Factorial
*/
int_ factorial(int n) {
	int_ fact;
	for(fact=1; n>0; n--)
		fact*=n;
	return fact;	
} 
 
/*
	To calculate Permutation	
*/
void permutation(char *str, int_ perm_n, char *per) {
	int_ i;
	int len, j;
	char tmp;
	len=strlen(str);	
	i=0;
	while(i<perm_n) 
		for(j=0;j<len-1;j++,i++) {
			tmp=*(str+j);
			*(str+j)=*(str+j+1);
			*(str+j+1)=tmp;		
			memcpy(per+i*len,str,len);
		}
}
 
 /*
 	To find all space base vectors
 */
void base_vector(char *str, int n, int k,int ind, char *result, int K, int *cls) {
	int_ l, m;
	int i;
	/* if ( n < k || k <= 0) { */
	if ( k <= 0) {
		(*cls)++;
		return;
	}
	for(i=0;n-i>=k && i < n;i++) {
		l=binomial_coeff(strlen(str+i+1),k-1);
		for(m=0;m<l;m++)
			*(result+ind+(K*(m+(*cls))))=*(str+i);
		base_vector(str+i+1,n-i-1,k-1,ind+1, result,K,cls);	
	}
}


/*
 	To calculate combination
 */
int_ _combination(char *str, int k, char **comb) {
	int_ i, perm_n, result;
	int cls, n;
	char *base, *perm;
	cls=0;
	n=strlen(str);
		
	if (!n) {
		return 0;
	} else if (!k || k<0) {
		return -1;
	} else if (n<k) {
		return -2;
	}
	result=binomial_coeff(n,k);
	perm_n=factorial(k);
	if ( result*perm_n > LIMIT) {
		return -3;
	}	
	base = (char*) malloc(sizeof(char)*(result*k+1));
	if (base==NULL) {
		return -4;
	}	
	memset(base,'\0',result*k+1);
	base_vector(str,n,k,0,base,k,&cls);
	perm = (char*) malloc(sizeof(char)*(k+1));		
	if (perm==NULL) {
		free(base);
		return -5;
	}	
	memset(perm,'\0',k+1);			
	*comb = (char *) malloc(sizeof(char)*(k*result*perm_n+1));
	if (*comb==NULL) {
		free(perm);	
		free(base);		
		return -6;
	}
	memset(*comb,'\0',k*result*perm_n+1);
	switch(k) {
		case 1 : {		/* particular case : k = 1 */
			for(i=0;i<result;i++)
				memcpy((*comb)+i,base+i,k);
			break;
			}
		default : {		/* default case : k > 1 */
			for(i=0;i<result;i++) {
				memcpy(perm,base+(i*k),k);
				permutation(perm,perm_n,(*comb)+i*(perm_n*k));
			}	
		}
	}
	free(perm);	
	free(base);
	return (result*perm_n);

}

MODULE = String::OrderedCombination		PACKAGE = String::OrderedCombination

void
ocombination(s,k)
		char * s
		int k
PPCODE:
	char *comb=NULL;	
	int len=0;
	int i=0;

	len=_combination(s,k,&comb);
	if (len<1) {
		SV* err;
		free(comb);
		err = get_sv("String::OrderedCombination::err", 0);
		switch(len) {
			case 0 : {
				if(err != NULL) sv_setpv(err, "length(string) must be an integer greater than 0");
				break;
			}
			case -1 : {
				if(err != NULL) sv_setpv(err, "k must be an integer greater than 0");
				break;
			}
			case -2 : {
				if(err != NULL) sv_setpv(err, "k must be less than or equal to length(string)");
				break;
			}
			case -3 : {
				if(err != NULL) sv_setpv(err, "Iteration Limit reached");
				break;
			}
			case -4 : {
				if(err != NULL) sv_setpvf(err, "Base Vector: %s\n",strerror(errno));
				break;
			}
			case -5 : {
				if(err != NULL) sv_setpvf(err,"Support Vector: %s\n",strerror(errno));
				break;
			}
			case -6 : {
				if(err != NULL) sv_setpvf(err, "Combination Vector: %s\n",strerror(errno));
				break;
			}
			default : {
				if(err != NULL) sv_setpv(err, "Unknown error");
				break;
			}
		}
		XSRETURN(0);
	}
	EXTEND(SP,len);
	for(i=0;i<len;i++) {
		PUSHs(sv_2mortal(newSVpvn(comb+(i*k), k)));
	}
	free(comb);
	XSRETURN(len);

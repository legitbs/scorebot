#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Largest int allowed is 999
int readint( char **equation, int *value )
{
    char *teq = NULL;
    int v = 0;
    char val[4];
    int index = 0;
    int vi = 0;

    if ( equation == NULL || value == NULL ) {
        return 0;
    }

    /// Pull out the pointer
    teq = *equation;

    if ( teq == NULL ) {
        return 0;

    }

    memset( val, 0, 4 );    

    // skip any space
    while ( teq[index] == ' ') {
        index++;
    }

    while ( ( teq[index] >= '0' && teq[index] <= '9' ) && vi < 4 ) {
        val[vi] = teq[index];
        vi++;
        index++;
    }

    /// Time to check for error conditions
    switch (teq[index] ) {
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        case ' ':
        case '\x00':
        case '+':
        case '*':
        case '/':
        case '-':
            break;
        default:
            return 0;
    };

    v = atoi(val);

    /// Set the correct value
    *value = v;

    /// Update the equation pointer
    *equation = teq + index;

    return 1;
}

// Returns 0 on failure 1 for '+', 2 for '-', 3 for '*', 4 for '/' and 5 for NULL
int readop( char **equation )
{
    char operation = '\x00';
    char *teq = NULL;

    if ( equation == NULL ) {
        return 0;
    }

    teq = *equation;

    if ( teq == NULL ) {
        return 0;
    }

    while ( *teq == ' ' ) {
        teq++;
    }

    operation = *teq;

    teq++;

    *equation = teq;

    switch (operation) {
        case '+':
            return 1;
            break;
        case '-':
            return 2;
            break;
        case '*':
            return 3;
            break;
        case '/':
            return 4;
            break;
        case '\x00':
            return 5;
            break;
        default:
            return 0;
            break;
    };

    return 0;
} 

int isop( char *equation)
{
    if ( equation == NULL ) {
        return 0;
    }

    // Skip spaces
    while ( *equation == ' ' ) {
        equation++;
    }

    switch (*equation ) {
        case '+':
        case '-':
        case '/':
        case '*':
            return 1;
        default:
            return 0;
    }

    return 0;
}

// Returns 1 on success 0 on failure.
// Failure occurs is the format is invalid
// The solution is returned in the solution pointer
int solve( char **equation, int *solution )
{
    int total = 0;
    int numone = 0;
    int numtwo = 0;
    int op = 0;
    int length = 0;
    char *end = NULL;

    if ( equation == NULL || solution == NULL ) {
        return 0;
    }

    end = *equation;

    if ( end == NULL ) {
        return 0;
    }

    // Read the operation
    op = readop( &end );

    if ( op == 5 ) {
        *solution = 0;
        *equation = end;
        return 1;
    } else if ( op == 0 ) {
        return 0;
    }

    /// If the next section is an operation then solve that first
    if ( isop( end ) ) {
        if ( solve( &end, &numone ) == 0 ) {
            return 0;
        }
    } else {
        if ( readint( &end, &numone) == 0 ) {
            return 0;
        }
    }

    if ( isop( end ) ) {
        if ( solve( &end, &numtwo ) == 0 ) {
            return 0;
        }
    } else {
        if ( readint( &end, &numtwo) == 0 ) {
            return 0;
        }
    }

    switch( op ) {
        case 1: // +
            total = numone + numtwo;
            break;
        case 2: // -
            total = numone - numtwo;
            break;
        case 3: // *
            total = numone * numtwo;
            break;
        case 4: // /
            total = numone / numtwo;
            break;
    };

    *equation = end;
    *solution = total;

    return 1;
}

int main( int argc, char **argv )
{
    int total = 0;
    char *e = argv[1];

    //printf("Equation: %s\n", e);
    //printf("%x %x %x %x %x\n", e[0], e[1], e[2], e[3], e[4]);

    if ( solve( &e, &total) == 0 ) {
	printf("error\n");
        exit(-1);
    }

    printf("solution: %d\n", total);

    exit(0);
}


#include "stdio.h"

extern int testRedZone();

int main () {
	if (testRedZone() == 0) {
		printf("nothing to worry about.\n");
		return 0;
	}

	printf("DANGER: kernel touched beyond RSP!!\n");
	return 1;
}

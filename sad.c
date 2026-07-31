#include <stdio.h>
#include <stdlib.h>
#include <string.h>
struct l {int z; char *t; struct l *n;} *b, *w, *c;
char *i; size_t L; FILE *f; int j;
int main(void) {
	b = malloc(sizeof(struct l));
	b->n = NULL;
	b->z = 1;
	c = b;
	while (1) {
		getline(&i, &L, stdin);
		switch (i[0]) {
			case 'g': // go
				int x = atoi(i + 1);
				c = b;
				for (j = 0; j < x && !c->z; j++) {
					c = c->n;
				}
				continue;
			case '=': // tally
				w = b;
				for (j = 0; w && !w->z; j++) {
					w = w->n;
				}
				printf("%i\n", j);
				continue;
			case 'n': // number
				w = b;
				for (j = 0; w && w != c && !w->z; j++) {
					w = w->n;
				}
				printf("%i\n", j);
				continue;
			case '\n': // nextline
				c = c->n;
			case 'p':
				puts(c->t);
				continue;
			case 'a': // append
				if (c->z) {
					w = c;
				} else {
					w = malloc(sizeof(struct l));
					w->n = c->n;
					c->n = w;
				}
				w->t = strdup(i + 1);
				w->z = 0;
				continue;
			case 'd': // delete
				w = c->n;
				if (!w || w->z) {
					free(w);
					c->n = NULL;
					c->z = 1;
					free(c->t);
					c = b;
				} else {
					c->n = w->n;
					c->t = w->t;
				}
				continue;
			case 'e': // edit
				while (b) {
					c = b->n;
					free(b->t);
					free(b);
					b = c;
				}
				w = malloc(sizeof(struct l));
				b = w;
				c = w;
				i[strlen(i) - 1] = '\0';
				f = fopen(i + 1, "r");
				getline(&i, &L, f);
				while (feof(f) == 0) {
					w->z = 0;
					w->t = strdup(i);
					w = malloc(sizeof(struct l));
					c->n = w;
					c = c->n;
					getline(&i, &L, f);
				}
				w->z = 1;
				c = b;
				fclose(f);
				continue;
			case 'w': // write
				i[strlen(i) - 1] = '\0';
				f = fopen(i + 1, "w");
				w = b;
				while (w && !w->z) {
					fwrite(w->t, sizeof(char), strlen(w->t), f);
					w = w->n;
				}
				fclose(f);
				continue;
			case 'q': // quit
				exit(0);
			default:
				puts("i am SAD (not ed)");
		}
	}
}

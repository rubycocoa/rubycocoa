/* Area:	ffi_call
   Purpose:	Check different structures.
   Limitations:	none.
   PR:		none.
   Originator:	Ronald Oussoren <oussoren@cistron.nl> 20030824	*/

/* { dg-do run } */
#include "ffitest.h"

typedef struct Point {
	float x;
	float y;
} Point;

typedef struct Size {
	float h;
	float w;
} Size;

typedef struct Rect {
	Point o;
	Size  s;
} Rect;

int doit(Rect r, Rect r2)
{
	printf("CALLED WITH {{%f %f} {%f %f}} {{%f %f} {%f %f}}\n",
		r.o.x, r.o.y, r.s.h, r.s.w,
		r2.o.x, r2.o.y, r2.s.h, r2.s.w);
	return 42;
}


int main(void)
{
	ffi_type point_type;
	ffi_type size_type;
	ffi_type rect_type;
	ffi_cif cif;
	ffi_type* arglist[6];
	void **values;
  int ret;

  values = (void **)alloca(sizeof(void *) * 6);

	/*
	 *  First set up FFI types for the 3 struct types
	 */

	point_type.size = 0; /*sizeof(Point);*/
	point_type.alignment = 0; /*__alignof__(Point);*/
	point_type.type = FFI_TYPE_STRUCT;
	point_type.elements = malloc(3 * sizeof(ffi_type*));
	point_type.elements[0] = &ffi_type_float;
	point_type.elements[1] = &ffi_type_float;
	point_type.elements[2] = NULL;

	size_type.size = 0;/* sizeof(Size);*/
	size_type.alignment = 0;/* __alignof__(Size);*/
	size_type.type = FFI_TYPE_STRUCT;
	size_type.elements = malloc(3 * sizeof(ffi_type*));
	size_type.elements[0] = &ffi_type_float;
	size_type.elements[1] = &ffi_type_float;
	size_type.elements[2] = NULL;

	rect_type.size = 0;/*sizeof(Rect);*/
	rect_type.alignment =0;/* __alignof__(Rect);*/
	rect_type.type = FFI_TYPE_STRUCT;
	rect_type.elements = malloc(3 * sizeof(ffi_type*));
	rect_type.elements[0] = &point_type;
	rect_type.elements[1] = &size_type;
	rect_type.elements[2] = NULL;

	/*
	 * Create a CIF
	 */
	arglist[0] = &rect_type;
	arglist[1] = &rect_type;
	arglist[2] = NULL;


	/* And call the function through the CIF */

	{
	Point p = { 1.0, 2.0 };
	Rect  r = { { 9.0, 10.0}, { -1.0, -2.0 } };
	Rect  r2 = { { 9.0, 10.0}, { -1.0, -2.0 } };
	int   o = 0;
	int   l = 42;
	char* m = "myMethod";
	ffi_arg result;

  Point *pp = (Point *)alloca(sizeof(Point));
  memcpy(pp, &p, sizeof(Point));
  Rect *pr = (Rect *)alloca(sizeof(Rect));
  memcpy(pr, &r, sizeof(Rect));
  Rect *pr2 = (Rect *)alloca(sizeof(Rect));
  memcpy(pr2, &r2, sizeof(Rect));

	values[0] = pr;
	values[1] = pr2;
	values[3] = NULL;

	ret = ffi_prep_cif(&cif, FFI_DEFAULT_ABI,
			2, &ffi_type_sint, arglist);
	if (ret != FFI_OK) {
		abort();
	}

	ffi_call(&cif, FFI_FN(doit), &result, values);

	printf ("The result is %d\n", result);

	}
	exit(0);
}

*&---------------------------------------------------------------------*
*& Report Z_ELSON_T7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t7.

"Complete types
"Date type
DATA lv_date    TYPE d.
"Time type
DATA lv_time    TYPE t.
"Integer
DATA lv_int     TYPE i.
"Float
DATA lv_float   TYPE f.
"String and Xstring
DATA lv_string  TYPE string.
DATA lv_xstring TYPE xstring.

"Incomplete types
"Character type
DATA lv_char TYPE c LENGTH 30.
"Numerical Character type
DATA lv_numc TYPE n LENGTH 10.
"Hexadecimal
DATA lv_hexa TYPE x LENGTH 6.
"Pack number
DATA lv_pack TYPE p LENGTH 6 DECIMALS 2.

lv_date = sy-datum.
WRITE: 'Date:', lv_date.

DATA lv_date2 TYPE c LENGTH 30.
WRITE lv_date TO lv_date2 DD/MM/YYYY.
WRITE: / 'Date with format:', lv_date2.

lv_time = sy-uzeit.
WRITE: / 'Time:', lv_time.

DATA lv_time2 TYPE c LENGTH 30.
WRITE lv_time TO lv_time2 USING EDIT MASK '__:__:__'.
WRITE: / 'Time with format:', lv_time2.

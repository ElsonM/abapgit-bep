*&---------------------------------------------------------------------*
*& Report Z_ABAP101_069
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT z_abap101_069.

TYPES: BEGIN OF ty_line,
         id   TYPE n LENGTH 8,
         name TYPE c LENGTH 20,
         age  TYPE i,
       END OF ty_line.

DATA it_without_hat TYPE TABLE OF ty_line.
DATA it_with_hat    TYPE TABLE OF ty_line WITH HEADER LINE. "Debug me to understand my name

*Populating the internal table WITHOUT HEADER LINE (hat)
DATA wa_line TYPE ty_line.

wa_line-id   = 1.
wa_line-name = 'The One'.
wa_line-age  = 10.
APPEND wa_line TO it_without_hat.

wa_line-id   = 2.
wa_line-name = 'Bob'.
wa_line-age  = 20.
APPEND wa_line TO it_without_hat.

wa_line-id   = 3.
wa_line-name = 'Mary'.
wa_line-age  = 30.
APPEND wa_line TO it_without_hat.

wa_line-id   = 4.
wa_line-name = 'Chris'.
wa_line-age  = 40.
APPEND wa_line TO it_without_hat.

wa_line-id   = 5.
wa_line-name = 'Janet'.
wa_line-age  = 50.
APPEND wa_line TO it_without_hat.

* Populating the internal table WITH HEADER LINE (hat)
it_with_hat-id   = 1.
it_with_hat-name = 'The One'.
it_with_hat-age  = 10.
APPEND it_with_hat.

it_with_hat-id   = 2.
it_with_hat-name = 'Bob'.
it_with_hat-age  = 20.
APPEND it_with_hat.

it_with_hat-id   = 3.
it_with_hat-name = 'Mary'.
it_with_hat-age  = 30.
APPEND it_with_hat.

it_with_hat-id   = 4.
it_with_hat-name = 'Chris'.
it_with_hat-age  = 40.
APPEND it_with_hat.

it_with_hat-id   = 5.
it_with_hat-name = 'Janet'.
it_with_hat-age  = 50.
APPEND it_with_hat.

*Printing table WITHOUT header line
LOOP AT it_without_hat INTO wa_line.

  WRITE: wa_line-id, wa_line-name, wa_line-age.
  NEW-LINE.

ENDLOOP.

*Printing table WITH header line
LOOP AT it_with_hat.

  WRITE: it_with_hat-id, it_with_hat-name, it_with_hat-age.
  NEW-LINE.

ENDLOOP.

*IF it_without_hat = it_with_hat. " Try to uncomment this IF
* WRITE 'Maybe the tables are not so equal because...'.
* NEW-LINE.
*ENDIF.

IF it_without_hat = it_with_hat[].

  WRITE ' ... without using []s we are using the work area and not the internal table'.

ENDIF.

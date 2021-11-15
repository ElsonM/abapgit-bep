*&---------------------------------------------------------------------*
*& Report ZTEST_STRUCT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest_struct.

FIELD-SYMBOLS <fs_att>  TYPE any.

DATA: BEGIN OF wa,
        field1(10),
        field2(10),
        field3(10),
      END OF wa.

DATA it LIKE TABLE OF wa.

DATA: r_descr TYPE REF TO cl_abap_structdescr,
      wa_comp TYPE abap_compdescr.

DATA: len TYPE i.

wa-field1 = '0001;'.
wa-field2 = '0002;'.
wa-field3 = '0003;'.

WRITE: wa-field1, wa-field2, wa-field3.


*wa-field1 = '0002'.
*wa-field2 = '0002'.
*wa-field3 = '0002'.
*APPEND wa TO it.
*
*wa-field1 = '0003'.
*wa-field2 = '0003'.
*wa-field3 = '0003'.
*APPEND wa TO it.

r_descr ?= cl_abap_typedescr=>describe_by_data( wa ).

LOOP AT r_descr->components INTO wa_comp.

  ASSIGN COMPONENT wa_comp-name OF STRUCTURE wa TO <fs_att>.

  len = strlen( <fs_att> ) - 1.
  <fs_att> = <fs_att>(len).

ENDLOOP.

WRITE:/ wa-field1, wa-field2, wa-field3.

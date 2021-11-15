*&---------------------------------------------------------------------*
*& Report ZAOI_REPORT1
*&
*&---------------------------------------------------------------------*
*& Introduction to ABAP Objects: Demo report 1.
*&
*& Using objects provides more stringent design-time checks.
*&
*& Introduce deliberate errors to function call and method call;
*& compare the level of checking done by the compiler.
*&---------------------------------------------------------------------*

REPORT zaoi_report1.

DATA: gv_value TYPE text25.

CONSTANTS: gc_input1 TYPE text10 VALUE 'Mytext',
           gc_input2 TYPE int1   VALUE 123.

CALL FUNCTION 'Z_AOI_DEMO1'
  EXPORTING
    iv_text   = gc_input1
    iv_number = gc_input2
  IMPORTING
    ev_output = gv_value.

zcl_aoi_demo1=>demo1(
  EXPORTING
    iv_text   = gc_input1
    iv_number = gc_input2
  IMPORTING
    ev_output = gv_value ).

WRITE: / 'Output is', gv_value.

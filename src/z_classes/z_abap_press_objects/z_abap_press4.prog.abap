*&---------------------------------------------------------------------*
*& Report Z_ABAP_PRESS4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap_press4.

CLASS lcl_string DEFINITION.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING iv_string TYPE csequence,
      trim RETURNING VALUE(ro_string) TYPE REF TO lcl_string,
      upper RETURNING VALUE(ro_string)
                        TYPE REF TO lcl_string,
      replace IMPORTING iv_pattern       TYPE string
                        iv_replace       TYPE string
              RETURNING VALUE(ro_string)
                          TYPE REF TO lcl_string,
      get_value RETURNING VALUE(rv_value) TYPE string.

  PRIVATE SECTION.
    DATA mv_string TYPE string.
ENDCLASS.

DATA lo_string TYPE REF TO lcl_string.
DATA lv_new_value TYPE string.

CREATE OBJECT lo_string
  EXPORTING
    iv_string = ' Paige A Pumpkin '.

*lv_new_value =
*  lo_string->trim( )->upper( )->replace( iv_pattern = '\s' iv_replace = '_' )->get_value( ).

lo_string = lo_string->trim( ).
lo_string = lo_string->upper( ).
lo_string = lo_string->replace( iv_pattern = '\s' iv_replace = '_' ).

lv_new_value = lo_string->get_value( ).

WRITE:/ lv_new_value.

CLASS lcl_string IMPLEMENTATION.
  METHOD constructor.
    me->mv_string = iv_string.
  ENDMETHOD.

  METHOD trim.
    me->mv_string =
      condense( val = me->mv_string from = '' ).
    ro_string = me.
  ENDMETHOD.

  METHOD upper.
    me->mv_string = to_upper( val = me->mv_string ).
    ro_string = me.
  ENDMETHOD.

  METHOD replace.
    REPLACE ALL OCCURRENCES OF REGEX iv_pattern
      IN me->mv_string WITH iv_replace.
    ro_string = me.
  ENDMETHOD.

  METHOD get_value.
    rv_value = me->mv_string.
  ENDMETHOD.
ENDCLASS.

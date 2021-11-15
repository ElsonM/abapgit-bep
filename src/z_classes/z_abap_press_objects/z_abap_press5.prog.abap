*&---------------------------------------------------------------------*
*& Report Z_ABAP_PRESS5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap_press5.

CLASS lcl_number_gen DEFINITION CREATE PRIVATE.
  PUBLIC SECTION.
    CLASS-METHODS:
      get_instance RETURNING VALUE(ro_generator)
                     TYPE REF TO lcl_number_gen.
    METHODS:
      get_next RETURNING VALUE(rv_number) TYPE i.

  PRIVATE SECTION.
    CLASS-DATA so_instance TYPE REF TO lcl_number_gen.
    DATA mv_current_num TYPE i.
    METHODS:
      constructor.
ENDCLASS.

DATA lo_generator TYPE REF TO lcl_number_gen.
DATA lv_number TYPE i.

DATA lo_gen2 TYPE REF TO lcl_number_gen.

*CREATE OBJECT lo_generator. "Syntax error...
lo_generator = lcl_number_gen=>get_instance( ).

DO 5 TIMES.
  lv_number = lo_generator->get_next( ).
  WRITE:/ 'Number #', lv_number.
ENDDO.

FREE lo_generator.

*CREATE OBJECT lo_generator. "Syntax error...
lo_gen2 = lcl_number_gen=>get_instance( ).

DO 5 TIMES.
  lv_number = lo_gen2->get_next( ).
  WRITE:/ 'Number #', lv_number.
ENDDO.


*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_number_gen
*&---------------------------------------------------------------------*
*  Text
*----------------------------------------------------------------------*
CLASS lcl_number_gen IMPLEMENTATION.
  METHOD get_instance.
    IF so_instance IS NOT BOUND.
      CREATE OBJECT so_instance.
    ENDIF.
    ro_generator = so_instance.
  ENDMETHOD.

  METHOD constructor.
    me->mv_current_num = 0.
  ENDMETHOD.

  METHOD get_next.
    me->mv_current_num = me->mv_current_num + 1.
    rv_number = me->mv_current_num.
  ENDMETHOD.
ENDCLASS.               "lcl_number_gen

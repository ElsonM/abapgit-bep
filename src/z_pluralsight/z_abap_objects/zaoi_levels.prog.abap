*&---------------------------------------------------------------------*
*& Report ZAOI_LEVELS
*&---------------------------------------------------------------------*
*& Introduction to ABAP Objects: Demo of static & instance levels
*&                               of class components.
*&---------------------------------------------------------------------*

REPORT zaoi_levels.
*********************************************************************
* CLASS DEFINITION
*********************************************************************
CLASS lcl_demo DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS:
*     Static method
      show_static_value.

    METHODS:
*     Instance methods
      constructor,
      show_final_values.

  PROTECTED SECTION.
    CLASS-DATA:
*     Static attribute
      mv_stat_val TYPE subrc.

    DATA:
*     Instance attribute
      mv_inst_val TYPE subrc.

ENDCLASS.


*********************************************************************
* PROGRAM STARTS HERE
*********************************************************************
START-OF-SELECTION.
  DATA:
    gv_counter TYPE subrc,
    go_demo TYPE REF TO lcl_demo.

  DO 3 TIMES.
*   Output loop iteration count
    gv_counter = sy-index.
    WRITE:
      / 'Iteration ', gv_counter.

*   Call static method
    lcl_demo=>show_static_value( ).

*   Create object
    CREATE OBJECT go_demo.

*   Call instance method
    go_demo->show_final_values( ).

*   Destroy the object
    FREE go_demo.
  ENDDO.


*********************************************************************
* CLASS IMPLEMENTATION
*********************************************************************
CLASS lcl_demo IMPLEMENTATION.

  METHOD constructor.
*   Increment each value by 1.
    mv_stat_val = mv_stat_val + 1.
    mv_inst_val = mv_inst_val + 1.
  ENDMETHOD.

  METHOD show_final_values.
    WRITE:
      / 'Final static value = ', mv_stat_val,
      / 'Final instance value = ', mv_inst_val.
    ULINE /1(30).
  ENDMETHOD.

  METHOD show_static_value.
    WRITE:
      / 'Initial static value = ', mv_stat_val.
  ENDMETHOD.

ENDCLASS.

*&---------------------------------------------------------------------*
*& Report ZAOA_DEMO1
*&---------------------------------------------------------------------*
*& ABAP Objects Advanced Programming: Demo report 1
*&
*& Sample report showing framework for OO programming
*&---------------------------------------------------------------------*

REPORT zaoa_demo1.
************************************************************************
* Selection screen definition
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK input
  WITH FRAME
  TITLE TEXT-s01.
*       --> Enter values to be added

PARAMETERS:
  p_int1 TYPE int4,
  p_int2 TYPE int4.

SELECTION-SCREEN END OF BLOCK input.

*********************************************************************
* Startup class definition
*********************************************************************
CLASS lcl_start DEFINITION FINAL.

  PUBLIC SECTION.

    CLASS-METHODS:
*     Startup method
      run.

ENDCLASS.

*********************************************************************
* Main processing class definition
*********************************************************************
CLASS lcl_main DEFINITION FINAL.

  PUBLIC SECTION.

    METHODS:
*     Constructor method
      constructor
        IMPORTING
          iv_value1 TYPE int4
          iv_value2 TYPE int4.

  PRIVATE SECTION.

    DATA:
*     Calculation result
      mv_result TYPE int4.

ENDCLASS.

*********************************************************************
* Program starts here
*********************************************************************
START-OF-SELECTION.
* Execute startup class static method
  lcl_start=>run( ).

*********************************************************************
* Startup class implementation
*********************************************************************
CLASS lcl_start IMPLEMENTATION.

* -------------------------------------------------------------------
* Startup method
* -------------------------------------------------------------------
  METHOD run.

    DATA:
*     Main processing object
      lo_main TYPE REF TO lcl_main.

*   Create instance of main object passing screen
*   field values as parameters
    CREATE OBJECT lo_main
      EXPORTING
        iv_value1 = p_int1
        iv_value2 = p_int2.

*    DATA(lo_main) = NEW lcl_main( iv_value1 = p_int1
*                                  iv_value2 = p_int2 ).

*    NEW lcl_main( iv_value1 = p_int1
*                  iv_value2 = p_int2 ).

  ENDMETHOD.

ENDCLASS.

*********************************************************************
* Main processing class implementation
*********************************************************************
CLASS lcl_main IMPLEMENTATION.

* -------------------------------------------------------------------
* Constructor method
* -------------------------------------------------------------------
  METHOD constructor.

*   Add parameters together
    mv_result = iv_value1 + iv_value2.

*   And write the result
    WRITE:
      / 'Total =',
        mv_result LEFT-JUSTIFIED.

  ENDMETHOD.

ENDCLASS.

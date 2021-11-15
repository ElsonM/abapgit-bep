*&---------------------------------------------------------------------*
*& Report ZAOA_DEMO9
*&
*&---------------------------------------------------------------------*
*& ABAP Objects Advanced Programming: Demo report 9.
*&
*& Dynamic programming: Data objects.
*&---------------------------------------------------------------------*

REPORT zaoa_demo9.
************************************************************************
* Selection screen definition
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK main
  WITH FRAME
  TITLE TEXT-s01.
*       --> Select object and action

PARAMETERS:
  p_table TYPE tabname OBLIGATORY MATCHCODE OBJECT mhdbtab.

SELECTION-SCREEN SKIP 1.

PARAMETERS:
  p_desc RADIOBUTTON GROUP act,
  p_cont RADIOBUTTON GROUP act.

SELECTION-SCREEN END OF BLOCK main.

************************************************************************
* Startup class definition
************************************************************************
CLASS lcl_start DEFINITION FINAL.

  PUBLIC SECTION.

*   Startup method
    CLASS-METHODS:
      run
        RAISING zcx_aoa.

ENDCLASS.

************************************************************************
* Program starts here
************************************************************************
START-OF-SELECTION.
* Execute startup class static method
  TRY.
      lcl_start=>run( ).
    CATCH cx_root INTO DATA(gr_error).
      DATA(gv_error) = gr_error->get_text( ).
      MESSAGE gv_error
        TYPE 'S'
        DISPLAY LIKE 'E'.
  ENDTRY.

************************************************************************
* Startup class implementation
************************************************************************
CLASS lcl_start IMPLEMENTATION.

* ----------------------------------------------------------------------
* Startup method
* ----------------------------------------------------------------------
  METHOD run.

    DATA(lo_main) = NEW zcl_aoa_demo9(
      iv_table       = p_table
      iv_description = p_desc
      iv_contents    = p_cont ).

  ENDMETHOD.

ENDCLASS.

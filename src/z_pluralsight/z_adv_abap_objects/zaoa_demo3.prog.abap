*&---------------------------------------------------------------------*
*& Report ZAOA_DEMO3
*&---------------------------------------------------------------------*
*& ABAP Objects Advanced Programming: Demo report 3.
*&
*& Employee processing using classes & interfaces.
*&---------------------------------------------------------------------*

REPORT zaoa_demo3.
*********************************************************************
* Selection screen definition
*********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK main WITH FRAME TITLE TEXT-s01.
* --> Select proccesing option

PARAMETERS:
  p_hours RADIOBUTTON GROUP opt,
  p_emp_id TYPE zif_aoa_employee=>employee_id,
  p_wrk_hr TYPE zif_aoa_employee=>work_hours.

SELECTION-SCREEN SKIP 1.

PARAMETERS:
  p_calc RADIOBUTTON GROUP opt.

SELECTION-SCREEN SKIP 1.

PARAMETERS:
  p_write RADIOBUTTON GROUP opt.

SELECTION-SCREEN SKIP 1.

PARAMETERS:
  p_exit RADIOBUTTON GROUP opt.

SELECTION-SCREEN END OF BLOCK main.

*********************************************************************
* Startup class definition
*********************************************************************
CLASS lcl_start DEFINITION FINAL.

  PUBLIC SECTION.

    CLASS-METHODS:
*     Startup method
      run RAISING zcx_aoa.

ENDCLASS.

*********************************************************************
* Global data definitions
*********************************************************************
DATA:
* Exception objects
  gr_error TYPE REF TO cx_root,
  gv_error TYPE string.

*********************************************************************
* Program starts here
*********************************************************************
START-OF-SELECTION.
* Execute startup class static method
  TRY.
      lcl_start=>run( ).
    CATCH cx_root INTO gr_error.
      gv_error = gr_error->get_text( ).
      MESSAGE gv_error
        TYPE 'S'
        DISPLAY LIKE 'E'.
  ENDTRY.

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
      lo_main TYPE REF TO zcl_aoa_demo3,
*     Exception objects
      lo_error TYPE REF TO zcx_aoa,
      lv_error TYPE string.

    DO.
*     Check for exit
      IF p_exit IS NOT INITIAL.
        MESSAGE TEXT-m01
*               --> Proccesing complete
          TYPE 'A'
          DISPLAY LIKE 'I'.
      ENDIF.

*     Create instance of main object passing screen
*     field values as parameters
      TRY.
          CREATE OBJECT lo_main            "The exception can be propagated (No TRY / CHATCH block)
            EXPORTING
              iv_action_hours = p_hours
              iv_action_calc  = p_calc
              iv_action_write = p_write
              iv_employee_id  = p_emp_id
              iv_work_hours   = p_wrk_hr.
        CATCH zcx_aoa INTO lo_error.
          lv_error = lo_error->get_text( ).
          MESSAGE lv_error
            TYPE 'S'
            DISPLAY LIKE 'E'.
      ENDTRY.

*     Reload selection screen
      CALL SELECTION-SCREEN 1000.
    ENDDO.

  ENDMETHOD.

ENDCLASS.

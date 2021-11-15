*&---------------------------------------------------------------------*
*& Report Z23_ALV_AUTOMATIC_REFRESH
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z23_ALV_AUTOMATIC_REFRESH NO STANDARD PAGE HEADING.

CLASS lcl_timer DEFINITION DEFERRED.

DATA: mesg     TYPE char50,
      lv_uzeit TYPE char8,

      wa_tab   TYPE          zdbtablog,
      it_tab   TYPE TABLE OF zdbtablog.

DATA: ob_grid  TYPE REF TO cl_gui_alv_grid,
      ob_timer TYPE REF TO cl_gui_timer,
      ob_recev TYPE REF TO lcl_timer.

CLASS lcl_timer DEFINITION.
  PUBLIC SECTION.
    METHODS:
      handle_finished FOR EVENT finished OF cl_gui_timer.
ENDCLASS.

CLASS lcl_timer IMPLEMENTATION.
  METHOD handle_finished.
    PERFORM refresh_data.
    CONCATENATE sy-uzeit+0(2) ':'
                sy-uzeit+2(2) ':'
                sy-uzeit+4(2)
      INTO lv_uzeit.
    CONCATENATE 'Last Update at' lv_uzeit
      INTO mesg SEPARATED BY space.
    MESSAGE mesg TYPE 'S'.
    CALL METHOD ob_timer->run.
  ENDMETHOD.                    "handle_finished
ENDCLASS.

START-OF-SELECTION.
  PERFORM select_data.

END-OF-SELECTION.
  CREATE OBJECT ob_timer.
  CREATE OBJECT ob_recev.
  SET HANDLER ob_recev->handle_finished FOR ob_timer.
  ob_timer->interval = 30.
  CALL METHOD ob_timer->run.
  PERFORM display_data.
*&---------------------------------------------------------------------*
*&      Form  SELECT_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM select_data.
  SELECT * FROM zdbtablog INTO TABLE it_tab.
  IF sy-subrc = 0.
    SORT it_tab BY zmatnr.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  REFRESH_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM refresh_data.
  IF ob_grid IS INITIAL .
    CALL FUNCTION 'GET_GLOBALS_FROM_SLVC_FULLSCR'
      IMPORTING
        e_grid = ob_grid.
  ENDIF.

  IF ob_grid IS NOT INITIAL.
    PERFORM select_data.
    CALL METHOD ob_grid->refresh_table_display.
  ENDIF.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM display_data.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY_LVC'
    EXPORTING
      i_callback_program = sy-repid
      i_structure_name   = 'ZDBTABLOG'
    TABLES
      t_outtab           = it_tab
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
ENDFORM.

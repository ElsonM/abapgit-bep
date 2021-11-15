*&---------------------------------------------------------------------*
*& Report ZAOI_REPORT2
*&
*&---------------------------------------------------------------------*
*& Introduction to ABAP Objects: Demo report 2.
*&
*& Sample report to demonstrate use of local class.
*&
*& Report is incrementally built from skeleton consisting
*& of the generic local class template.
*&---------------------------------------------------------------------*
REPORT zaoi_report2.

*********************************************************************
* SELECTION SCREEN DEFINITIONS
*********************************************************************
SELECTION-SCREEN BEGIN OF BLOCK main
  WITH FRAME
  TITLE TEXT-t01.
* --> Enter file names

PARAMETERS:
  p_input  TYPE string,
  p_output TYPE string.

SELECTION-SCREEN END OF BLOCK main.

*********************************************************************
* PROGRAM STARTS HERE
*********************************************************************
DATA:
  go_error TYPE REF TO cx_root,
  gv_error TYPE        string,
  go_main  TYPE REF TO zcl_aoi_demo3.

START-OF-SELECTION.
  TRY.
      CREATE OBJECT go_main
        EXPORTING
          iv_infile  = p_input
          iv_outfile = p_output.

      go_main->xfer( ).
      go_main->show_line( ).
    CATCH cx_root INTO go_error.

      gv_error = go_error->get_text( ).
      WRITE:
        / gv_error.
  ENDTRY.

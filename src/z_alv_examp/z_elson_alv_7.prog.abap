*&---------------------------------------------------------------------*
*& Report Z_ELSON_ALV_7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_alv_7.

DATA: it_mara TYPE TABLE OF mara, "Declare internal table for mara
      wa_mara TYPE          mara. "Declare working area

SELECT-OPTIONS s_matnr FOR wa_mara-matnr. "Display SELECT-OPTIONS for matnr

START-OF-SELECTION.
  PERFORM get_mara_data.

END-OF-SELECTION.
  PERFORM disp_mara_alv.

*&---------------------------------------------------------------------*
*&      Form  GET_MARA_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_mara_data.

  SELECT * FROM mara
    INTO TABLE it_mara
    WHERE matnr IN s_matnr.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  DISP_MARA_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM disp_mara_alv.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY' "Call function module to display ALV Grid
    EXPORTING
      i_callback_program = sy-repid      "sy-repid is a system variable which stores current program name
      i_structure_name   = 'MARA'
    TABLES
      t_outtab           = it_mara.      "Pass internal table to display ALV format
ENDFORM.

*&---------------------------------------------------------------------*
*& Report Z12_SEARCH_HELP_FILE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z12_search_help_file.

** ---> Using Function Module
**----------------------------------------------------------------------*
**     SELECTION-SCREEN
**----------------------------------------------------------------------*
*PARAMETERS: p_file TYPE ibipparms-path OBLIGATORY.
*
**----------------------------------------------------------------------*
**     AT SELECTION-SCREEN ON VALUE-REQUEST
**----------------------------------------------------------------------*
*AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.
*
*  CALL FUNCTION 'F4_FILENAME'
**   EXPORTING
**     PROGRAM_NAME       =
**     DYNPRO_NUMBER      =
**     FIELD_NAME         =
*   IMPORTING
*     file_name           = p_file.
*
**----------------------------------------------------------------------*
**     START-OF-SELECTION
**----------------------------------------------------------------------*
*START-OF-SELECTION.
*  WRITE:/ 'Filename : ', p_file.
** <---

* ---> Using Classes
*----------------------------------------------------------------------*
*     DATA DECLARATION
*----------------------------------------------------------------------*
DATA: gv_rc TYPE i.

DATA: gt_file_table  TYPE filetable,
      gwa_file_table TYPE file_table.

*----------------------------------------------------------------------*
*     SELECTION-SCREEN
*----------------------------------------------------------------------*
PARAMETERS: p_file TYPE ibipparms-path OBLIGATORY.

*----------------------------------------------------------------------*
*     AT SELECTION-SCREEN ON VALUE-REQUEST
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_file.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    EXPORTING
      window_title = 'Select a file'
    CHANGING
      file_table   = gt_file_table
      rc           = gv_rc.

  IF sy-subrc = 0.
    READ TABLE gt_file_table INTO gwa_file_table INDEX 1.
    p_file = gwa_file_table-filename.
  ENDIF.

*----------------------------------------------------------------------*
*     START-OF-SELECTION
*----------------------------------------------------------------------*
START-OF-SELECTION.
  WRITE:/ 'Filename : ', p_file.
* <---

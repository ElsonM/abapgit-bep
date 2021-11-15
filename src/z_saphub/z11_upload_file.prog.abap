*&---------------------------------------------------------------------*
*& Report Z11_UPLOAD_FILE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z11_upload_file.

*----------------------------------------------------------------------*
*     Data Decalaration
*----------------------------------------------------------------------*
DATA: gt_spfli  TYPE TABLE OF spfli,
      gwa_spfli TYPE          spfli.

DATA: gv_filename TYPE string,
      gv_filetype TYPE char10.

*----------------------------------------------------------------------*
*     START-OF-SELECTION
*----------------------------------------------------------------------*
PERFORM read_file.
PERFORM process_data.

*&---------------------------------------------------------------------*
*&      Form  read_file
*&---------------------------------------------------------------------*
FORM read_file.
* Move complete file path to file name
  gv_filename = 'C:\test\data.txt'.

* Upload the data from a file in SAP presentation server to internal
* table
  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename            = gv_filename
      filetype            = 'ASC'
      has_field_separator = 'X'
    TABLES
      data_tab            = gt_spfli.

ENDFORM.                    " read_file

*&---------------------------------------------------------------------*
*&      Form  process_data
*&---------------------------------------------------------------------*
FORM process_data.
* Display the internal table data
  LOOP AT gt_spfli INTO gwa_spfli.
    WRITE:/ gwa_spfli-carrid,
            gwa_spfli-connid,
            gwa_spfli-countryfr,
            gwa_spfli-cityfrom,
            gwa_spfli-airpfrom,
            gwa_spfli-countryto,
            gwa_spfli-cityto,
            gwa_spfli-airpto,
            gwa_spfli-arrtime.
    CLEAR: gwa_spfli.
  ENDLOOP.
ENDFORM.                    " process_data

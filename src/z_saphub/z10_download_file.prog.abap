*&---------------------------------------------------------------------*
*& Report Z10_DOWNLOAD_FILE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z10_download_file.

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
PERFORM get_data.

IF NOT gt_spfli IS INITIAL.
  PERFORM save_file.
ELSE.
  MESSAGE 'No data found' TYPE 'I'.
ENDIF.

*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
FORM get_data.
* Get data from table SPFLI
  SELECT * FROM spfli INTO TABLE gt_spfli.
ENDFORM.                    " get_data

*&---------------------------------------------------------------------*
*&      Form  save_file
*&---------------------------------------------------------------------*
FORM save_file.
* Move complete file path to file name
  gv_filename = 'C:\test\data.txt'.

* Download the internal table data into a file in SAP presentation server
  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
      filename                = gv_filename
      filetype                = 'ASC'
      write_field_separator   = 'X'
    TABLES
      data_tab                = gt_spfli.

ENDFORM.                    " save_file

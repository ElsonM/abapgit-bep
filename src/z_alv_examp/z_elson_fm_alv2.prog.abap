*&---------------------------------------------------------------------*
*& Report Z_ELSON_FM_ALV2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_fm_alv2.

*&---------------------------------------------------------------------*
*& Data Declaration
*&---------------------------------------------------------------------*
DATA: BEGIN OF wa_sbook,
        status(4).
        INCLUDE STRUCTURE sbook.
DATA: END OF wa_sbook.

DATA: it_sbook LIKE TABLE OF wa_sbook.

DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.

*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.

* Fetch data from the database
  SELECT * UP TO 10 ROWS FROM sbook INTO CORRESPONDING FIELDS OF TABLE it_sbook.

* Build field catalog
  wa_fieldcat-fieldname = 'STATUS'. "Fieldname in the data table
  wa_fieldcat-seltext_m = 'Status'. "Column description in the output
  APPEND wa_fieldcat TO it_fieldcat.

* Merge field catalog
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'SBOOK'
    CHANGING
      ct_fieldcat            = it_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

* Pass data and field catalog to ALV function module to display ALV list
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat   = it_fieldcat "MANDT field is not displayed because it has the value TECH = 'X'
    TABLES
      t_outtab      = it_sbook
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.

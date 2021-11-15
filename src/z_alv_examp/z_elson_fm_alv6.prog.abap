*&---------------------------------------------------------------------*
*& Report Z_ELSON_FM_ALV6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_fm_alv6.

*&---------------------------------------------------------------------*
*& Data Declaration
*&---------------------------------------------------------------------*
DATA: it_sbook     TYPE TABLE OF sbook.

DATA: it_fieldcat  TYPE slis_t_fieldcat_alv,
      wa_fieldcat  TYPE slis_fieldcat_alv.

DATA: g_repid      TYPE sy-repid.
*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  g_repid = sy-repid.

* Fetch data from the database
  SELECT * UP TO 20 ROWS FROM sbook INTO TABLE it_sbook.

* Build field catalog
  wa_fieldcat-fieldname  = 'CARRID'.    "Fieldname in the data table
  wa_fieldcat-seltext_m  = 'Airline'.   "Column description in the output
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'CONNID'.
  wa_fieldcat-seltext_m  = 'Con. No.'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'FLDATE'.
  wa_fieldcat-seltext_m  = 'Date'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'BOOKID'.
  wa_fieldcat-seltext_m  = 'Book. ID'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'FORCURAM'.
  wa_fieldcat-seltext_m  = 'Price'.
  wa_fieldcat-do_sum     = 'X'.
  wa_fieldcat-cfieldname = 'FORCURKEY'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'FORCURKEY'.
  wa_fieldcat-seltext_m  = 'Currency'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'LUGGWEIGHT'.
  wa_fieldcat-seltext_m  = 'Weight'.
  wa_fieldcat-do_sum     = 'X'.
  wa_fieldcat-qfieldname = 'WUNIT'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'WUNIT'.
  wa_fieldcat-seltext_m  = 'Unit'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

* Pass data and field catalog to ALV function module to display ALV list
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = g_repid
      it_fieldcat        = it_fieldcat
    TABLES
      t_outtab           = it_sbook
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

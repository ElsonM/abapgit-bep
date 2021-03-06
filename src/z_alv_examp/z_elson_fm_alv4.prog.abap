*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR6
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_fm_alv4.

*&---------------------------------------------------------------------*
*& Data Declaration
*&---------------------------------------------------------------------*
DATA: it_sbook    TYPE TABLE OF sbook.

DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.
*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.

* Fetch data from the database
  SELECT * FROM sbook INTO TABLE it_sbook.

* Build field catalog
  wa_fieldcat-fieldname  = 'CARRID'.    " Fieldname in the data table
  wa_fieldcat-seltext_m  = 'Airline'.   " Column description in the output
  APPEND wa_fieldcat TO it_fieldcat.

  wa_fieldcat-fieldname  = 'CONNID'.
  wa_fieldcat-seltext_m  = 'Con. No.'.
  APPEND wa_fieldcat TO it_fieldcat.

  wa_fieldcat-fieldname  = 'FLDATE'.
  wa_fieldcat-seltext_m  = 'Date'.
  APPEND wa_fieldcat TO it_fieldcat.

  wa_fieldcat-fieldname  = 'BOOKID'.
  wa_fieldcat-seltext_m  = 'Book. ID'.
  APPEND wa_fieldcat TO it_fieldcat.

  wa_fieldcat-fieldname  = 'PASSNAME'.
  wa_fieldcat-seltext_m  = 'Passenger Name'.
  APPEND wa_fieldcat TO it_fieldcat.

  wa_fieldcat-fieldname  = 'LOCCURAM'.
  wa_fieldcat-seltext_m  = 'Price'.
  wa_fieldcat-do_sum     = 'X'.           " Calculate Total for Price
  APPEND wa_fieldcat TO it_fieldcat.

  wa_fieldcat-fieldname  = 'LOCCURKEY'.
  wa_fieldcat-seltext_m  = 'Currency'.
  APPEND wa_fieldcat TO it_fieldcat.

* Pass data and field catalog to ALV function module to display ALV list
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      it_fieldcat   = it_fieldcat
    TABLES
      t_outtab      = it_sbook
    EXCEPTIONS
      program_error = 1
      OTHERS        = 2.

*&---------------------------------------------------------------------*
*& Report Z_ELSON_FM_ALV7
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_fm_alv7.

*&---------------------------------------------------------------------*
*& Data Declaration
*&---------------------------------------------------------------------*
DATA: BEGIN OF wa_sbook,
        icon TYPE c.
        INCLUDE STRUCTURE sbook.
DATA: END OF wa_sbook.

DATA: it_sbook LIKE TABLE OF wa_sbook.

DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      wa_fieldcat TYPE slis_fieldcat_alv.

DATA: is_layout   TYPE slis_layout_alv.

DATA: g_repid     TYPE sy-repid.

*&---------------------------------------------------------------------*
*& START-OF-SELECTION
*&---------------------------------------------------------------------*
START-OF-SELECTION.
  g_repid = sy-repid.

* Fetch data from the database
  SELECT * UP TO 20 ROWS FROM sbook INTO CORRESPONDING FIELDS OF TABLE it_sbook.

* Assign different traffic lights to each row based on condition
  LOOP AT it_sbook INTO wa_sbook.
    IF wa_sbook-luggweight LE 0.
      wa_sbook-icon = 1.  "Red Traffic Light
    ELSEIF wa_sbook-luggweight LE 20.
      wa_sbook-icon = 2.  "Yellow Traffic Light
    ELSE.
      wa_sbook-icon = 3.  "Green Traffic Light
    ENDIF.
    MODIFY it_sbook FROM wa_sbook TRANSPORTING icon.
    CLEAR wa_sbook.
  ENDLOOP.

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
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'FORCURKEY'.
  wa_fieldcat-seltext_m  = 'Currency'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'LUGGWEIGHT'.
  wa_fieldcat-seltext_m  = 'Weight'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-fieldname  = 'WUNIT'.
  wa_fieldcat-seltext_m  = 'Unit'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

** Fill layout info.
** Fill traffic lights field name in the ALV layout
  is_layout-lights_fieldname = 'ICON'.

*Pass data and field catalog to ALV function module to display ALV list
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = g_repid
      is_layout          = is_layout
      it_fieldcat        = it_fieldcat
    TABLES
      t_outtab           = it_sbook
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.

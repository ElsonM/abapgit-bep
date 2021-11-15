*&---------------------------------------------------------------------*
*& Report Z_ELSON_EX2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_ex4.

*Local Variables
DATA: it_bkpf TYPE TABLE OF bkpf,
      wa_bkpf TYPE          bkpf,
      it_bseg TYPE TABLE OF bseg,
      wa_bseg TYPE          bseg.

*Input Parameters
PARAMETERS p_blart TYPE bkpf-blart.

*ALV variables
DATA: BEGIN OF wa_alv,
        bukrs LIKE bseg-bukrs,
        belnr LIKE bseg-belnr,
        gjahr LIKE bseg-gjahr,
        bschl LIKE bseg-bschl,
        koart LIKE bseg-koart,
        bktxt LIKE bkpf-bktxt,
        awkey LIKE bkpf-awkey,
      END OF wa_alv.

DATA: it_alv   LIKE TABLE OF wa_alv,
      fieldcat TYPE          slis_t_fieldcat_alv.

SELECT * FROM bkpf INTO TABLE it_bkpf WHERE blart = p_blart.

IF sy-subrc = 0.

  SELECT * FROM bseg INTO TABLE it_bseg FOR ALL ENTRIES IN it_bkpf
    WHERE belnr = it_bkpf-belnr.

  LOOP AT it_bseg INTO wa_bseg.

    READ TABLE it_bkpf WITH KEY belnr = wa_bseg-belnr INTO wa_bkpf.
*   WRITE: / ls_bseg-bukrs, ls_bseg-belnr, ls_bseg-gjahr,
*            ls_bseg-bschl, ls_bseg-koart, ls_bkpf-bktxt, ls_bkpf-awkey.
    MOVE-CORRESPONDING: wa_bkpf TO wa_alv,
                        wa_bseg TO wa_alv.
    APPEND wa_alv TO it_alv.
    CLEAR wa_alv.

  ENDLOOP.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name         = sy-repid
      i_internal_tabname     = 'WA_ALV'
      i_client_never_display = 'X'
      i_inclname             = sy-repid
    CHANGING
      ct_fieldcat            = fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program      = sy-repid
      i_structure_name        = 'WA_ALV'
      i_callback_user_command = 'ALV_USER_COMMAND'
      it_fieldcat             = fieldcat
    TABLES
      t_outtab                = it_alv
    EXCEPTIONS
      program_error           = 1
      OTHERS                  = 2.

ELSE.
  MESSAGE TEXT-e01 TYPE 'E'.

ENDIF.

*ABAP 7.4 New Syntax ---

*TYPES :BEGIN OF ty_makt,
*         matnr TYPE matnr,
*         spras TYPE spras,
*         maktx TYPE maktx,
*       END OF ty_makt.
*
*DATA it_makt TYPE STANDARD TABLE OF ty_makt.
*DATA wa_makt TYPE                   ty_makt.
*PARAMETERS p_matnr TYPE matnr.
*SELECT matnr spras maktx FROM makt
*  INTO TABLE it_makt
*  WHERE matnr EQ p_matnr.
*
*LOOP AT it_makt INTO wa_makt.
*  WRITE:/ wa_makt-matnr, wa_makt-spras, wa_makt-maktx.
*ENDLOOP.

*TYPES: BEGIN OF ty_sflight,
*         carrid TYPE s_carr_id,  "sflight-carrid
*         connid TYPE s_conn_id,  "sflight-connid
*         fldate TYPE s_date,     "sflight-fldate
*       END OF ty_sflight.
*
*DATA: wa_sflight TYPE          ty_sflight,
*      it_sflight TYPE TABLE OF ty_sflight.
*
*PARAMETERS p_carrid TYPE s_carr_id.
*
*SELECT carrid connid fldate FROM sflight
*  INTO TABLE it_sflight
*  WHERE carrid EQ p_carrid.
*
*LOOP AT it_sflight INTO wa_sflight).
*  WRITE:/ wa_sflight-carrid, wa_sflight-connid, wa_sflight-fldate.
*ENDLOOP.

*PARAMETERS p_carrid TYPE s_carr_id.
*
*SELECT carrid, connid, fldate FROM sflight
*  WHERE carrid EQ @p_carrid
*  INTO TABLE @DATA(it_sflight).
*
*LOOP AT it_sflight INTO DATA(wa_sflight).
*  WRITE:/ wa_sflight-carrid, wa_sflight-connid, wa_sflight-fldate.
*ENDLOOP.

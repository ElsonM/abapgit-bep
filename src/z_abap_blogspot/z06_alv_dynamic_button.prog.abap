*&---------------------------------------------------------------------*
*& Report Z06_ALV_DYNAMIC_BUTTON
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z06_alv_dynamic_button.

TABLES: ekko, ekpo.

TYPES: BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         lifnr TYPE ekko-lifnr,
       END OF ty_ekko,

       BEGIN OF ty_out_ekko,
         sel,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         lifnr TYPE ekko-lifnr,
       END OF ty_out_ekko,

       BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         werks TYPE ekpo-werks,
         lgort TYPE ekpo-lgort,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
       END OF ty_ekpo,

       BEGIN OF ty_out_ekpo,
         sel,
         ebeln TYPE ekko-ebeln,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         werks TYPE ekpo-werks,
         lgort TYPE ekpo-lgort,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
       END OF ty_out_ekpo,

       BEGIN OF ty_ebeln,
         ebeln TYPE ekpo-ebeln,
       END OF ty_ebeln.

DATA: wa_ekko       TYPE                   ty_ekko,
      wa_ekpo       TYPE                   ty_ekpo,
      it_ekko       TYPE STANDARD TABLE OF ty_ekko,
      it_ekpo       TYPE STANDARD TABLE OF ty_ekpo,

      wa_out_ekko   TYPE                   ty_out_ekko,
      wa_out_ekpo   TYPE                   ty_out_ekpo,
      wa_ebeln      TYPE                   ty_ebeln,
      it_out_ekko   TYPE STANDARD TABLE OF ty_out_ekko,
      it_out_ekpo   TYPE STANDARD TABLE OF ty_out_ekpo,
      it_ebeln      TYPE STANDARD TABLE OF ty_ebeln,

      wa_fcat_ekko  TYPE slis_fieldcat_alv,
      wa_fcat_ekpo  TYPE slis_fieldcat_alv,
      it_fcat_ekko  TYPE slis_t_fieldcat_alv,
      it_fcat_ekpo  TYPE slis_t_fieldcat_alv,

      wa_layout     TYPE slis_layout_alv,

      wa_top_ekko   TYPE slis_listheader,
      wa_top_ekpo   TYPE slis_listheader,
      it_top_ekko   TYPE slis_t_listheader,
      it_top_ekpo   TYPE slis_t_listheader,

      wa_event      TYPE slis_alv_event,
      wa_event_ekpo TYPE slis_alv_event,
      it_event      TYPE slis_t_event,
      it_event_ekpo TYPE slis_t_event,

      r_ucomm       TYPE sy-ucomm,
      rs_selfield   TYPE slis_selfield,
      v_selfield    TYPE slis_selfield-value,
      v_ebeln       TYPE ekko-ebeln,
      v_prog        TYPE sy-repid,
      v_name        TYPE sy-uname.

INITIALIZATION.
  v_prog = sy-repid.
  v_name = sy-uname.

  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
    SELECT-OPTIONS s_ebeln FOR ekko-ebeln OBLIGATORY.
  SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  PERFORM get_ekko.
  PERFORM fieldcat_ekko.
  PERFORM layout.
  PERFORM event_ekko.
  PERFORM grid_ekko.
  PERFORM ucomm_ekko USING    r_ucomm
                     CHANGING rs_selfield.

*&---------------------------------------------------------------------*
*&      Form  GET_EKKO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_ekko.

  REFRESH it_ekko.

  SELECT ebeln bukrs lifnr
    FROM ekko INTO TABLE it_ekko
    WHERE ebeln IN s_ebeln.

  IF sy-subrc = 0.
    SORT it_ekko BY ebeln.
    REFRESH it_out_ekko.

    LOOP AT it_ekko INTO wa_ekko.
      wa_out_ekko-ebeln = wa_ekko-ebeln.
      wa_out_ekko-bukrs = wa_ekko-bukrs.
      wa_out_ekko-lifnr = wa_ekko-lifnr.
      APPEND wa_out_ekko TO it_out_ekko.
      CLEAR: wa_out_ekko, wa_ekko.
    ENDLOOP.

  ELSE.
    MESSAGE 'Purchase Order doesn''t exist' TYPE 'I'.
  ENDIF.

ENDFORM.                    " GET_EKKO

*&---------------------------------------------------------------------*
*&      Form  FIELDCAT_EKKO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fieldcat_ekko.

  CLEAR   wa_fcat_ekko.
  REFRESH it_fcat_ekko.

  IF it_out_ekko IS NOT INITIAL.

    DATA lv_col TYPE i VALUE 0.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekko-col_pos   = lv_col.
    wa_fcat_ekko-fieldname = 'EBELN'.
    wa_fcat_ekko-tabname   = 'IT_OUT_EKKO'.
    wa_fcat_ekko-seltext_l = 'Purchase Order'.
    APPEND wa_fcat_ekko TO it_fcat_ekko.
    CLEAR wa_fcat_ekko.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekko-col_pos   = lv_col.
    wa_fcat_ekko-fieldname = 'BUKRS'.
    wa_fcat_ekko-tabname   = 'IT_OUT_EKKO'.
    wa_fcat_ekko-seltext_l = 'Company Code'.
    APPEND wa_fcat_ekko TO it_fcat_ekko.
    CLEAR wa_fcat_ekko.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekko-col_pos   = lv_col.
    wa_fcat_ekko-fieldname = 'LIFNR'.
    wa_fcat_ekko-tabname   = 'IT_OUT_EKKO'.
    wa_fcat_ekko-seltext_l = 'Vendor'.
    APPEND wa_fcat_ekko TO it_fcat_ekko.
    CLEAR wa_fcat_ekko.

  ENDIF.

ENDFORM.                    " FIELDCAT_EKKO

*&---------------------------------------------------------------------*
*&      Form  LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM layout.

  wa_layout-zebra = 'X'.
  wa_layout-colwidth_optimize = 'X'.
  wa_layout-box_fieldname = 'SEL'.

ENDFORM.                    " LAYOUT

*&---------------------------------------------------------------------*
*&      Form  EVENT_EKKO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM event_ekko.

  REFRESH it_event.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    IMPORTING
      et_events       = it_event
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.

  IF it_event IS NOT INITIAL.
    CLEAR wa_event.
    READ TABLE it_event INTO wa_event
      WITH KEY name = 'USER_COMMAND'.

    IF sy-subrc = 0.
      wa_event-form = 'UCOMM_EKKO'.
      MODIFY it_event FROM wa_event
        INDEX sy-tabix TRANSPORTING form.
    ENDIF.
  ENDIF.

ENDFORM.                    " EVENT_EKKO

*&---------------------------------------------------------------------*
*&      Form  GRID_EKKO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM grid_ekko.

  IF    it_out_ekko  IS NOT INITIAL
    AND it_fcat_ekko IS NOT INITIAL.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program       = v_prog
        i_callback_pf_status_set = 'PF_STATUS1'
        i_callback_user_command  = 'UCOMM_EKKO'
        i_callback_top_of_page   = 'TOP_EKKO'
        is_layout                = wa_layout
        it_fieldcat              = it_fcat_ekko
        it_events                = it_event
      TABLES
        t_outtab                 = it_out_ekko
      EXCEPTIONS
        program_error            = 1
        OTHERS                   = 2.
  ENDIF.

ENDFORM.                    " GRID_EKKO

*&---------------------------------------------------------------------*
*&      Form  pf_status
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM pf_status1 USING ut_extab TYPE slis_t_extab.
  SET PF-STATUS 'PF_EKKO'.
ENDFORM.                    "pf_status


*&---------------------------------------------------------------------*
*&      Form  top_ekko
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM top_ekko.

  CLEAR wa_top_ekko.
  REFRESH it_top_ekko.

  DATA date TYPE char12.

  CALL FUNCTION 'CONVERT_DATE_TO_EXTERNAL'
    EXPORTING
      date_internal            = sy-datum
    IMPORTING
      date_external            = date
    EXCEPTIONS
      date_internal_is_invalid = 1
      OTHERS                   = 2.

  wa_top_ekko-typ = 'H'.
  wa_top_ekko-info = 'Purchase Order Header'.
  APPEND wa_top_ekko TO it_top_ekko.
  CLEAR wa_top_ekko.

  wa_top_ekko-typ = 'S'.
  wa_top_ekko-info = 'Report: '.
  CONCATENATE wa_top_ekko-info v_prog
  INTO wa_top_ekko-info.
  APPEND wa_top_ekko TO it_top_ekko.
  CLEAR wa_top_ekko.

  wa_top_ekko-typ = 'S'.
  wa_top_ekko-info = 'User Name: '.
  CONCATENATE wa_top_ekko-info v_name
  INTO wa_top_ekko-info.
  APPEND wa_top_ekko TO it_top_ekko.
  CLEAR wa_top_ekko.

  wa_top_ekko-typ = 'S'.
  wa_top_ekko-info = 'Date: '.
  CONCATENATE wa_top_ekko-info date
  INTO wa_top_ekko-info.
  APPEND wa_top_ekko TO it_top_ekko.
  CLEAR wa_top_ekko.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_top_ekko
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

ENDFORM.                    "top_ekko
*&---------------------------------------------------------------------*
*&      Form  UCOMM_EKKO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_R_UCOMM  text
*      <--P_RS_SELFIELD  text
*----------------------------------------------------------------------*
FORM ucomm_ekko USING    r_ucomm_ekko     TYPE sy-ucomm
                CHANGING rs_selfield_ekko TYPE slis_selfield.

  CASE r_ucomm_ekko.
    WHEN 'DISP'.
      REFRESH: it_out_ekpo, it_ebeln.
      LOOP AT it_out_ekko INTO wa_out_ekko
        WHERE sel = 'X'.

        wa_ebeln-ebeln = wa_out_ekko-ebeln.
        APPEND wa_ebeln TO it_ebeln.
        CLEAR wa_ebeln.
      ENDLOOP.

      PERFORM get_ekpo.
      PERFORM fieldcat_ekpo.
      PERFORM layout.
      PERFORM grid_ekpo.

    WHEN 'BACK' OR 'EXIT' OR 'CANCEL' OR 'E'.
      REFRESH it_out_ekko.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDFORM.                    " UCOMM_EKKO
*&---------------------------------------------------------------------*
*&      Form  GET_EKPO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_ekpo.

  IF it_ebeln IS NOT INITIAL.
    REFRESH it_ekpo.

    SELECT ebeln ebelp matnr werks
           lgort menge meins
      FROM ekpo INTO TABLE it_ekpo
      FOR ALL ENTRIES IN it_ebeln
      WHERE ebeln = it_ebeln-ebeln.

    IF sy-subrc = 0.
      SORT it_ekpo BY ebeln.

      LOOP AT it_ekpo INTO wa_ekpo.
        AT NEW ebeln.
          wa_out_ekpo-ebeln = wa_ekpo-ebeln.
        ENDAT.
        wa_out_ekpo-ebelp = wa_ekpo-ebelp.
        wa_out_ekpo-matnr = wa_ekpo-matnr.
        wa_out_ekpo-werks = wa_ekpo-werks.
        wa_out_ekpo-lgort = wa_ekpo-lgort.
        wa_out_ekpo-menge = wa_ekpo-menge.
        wa_out_ekpo-meins = wa_ekpo-meins.
        APPEND wa_out_ekpo TO it_out_ekpo.
        CLEAR: wa_out_ekpo, wa_ekpo.
      ENDLOOP.
    ENDIF.
  ENDIF.

ENDFORM.                    " GET_EKPO
*&---------------------------------------------------------------------*
*&      Form  FIELDCAT_EKPO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fieldcat_ekpo.

  CLEAR wa_fcat_ekpo.
  REFRESH it_fcat_ekpo.

  IF it_out_ekpo IS NOT INITIAL.
    DATA lv_col TYPE i VALUE 0.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekpo-col_pos   = lv_col.
    wa_fcat_ekpo-fieldname = 'EBELN'.
    wa_fcat_ekpo-tabname   = 'IT_OUT_EKPO'.
    wa_fcat_ekpo-seltext_l = 'Purchase Order'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR wa_fcat_ekpo.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekpo-col_pos   = lv_col.
    wa_fcat_ekpo-fieldname = 'EBELP'.
    wa_fcat_ekpo-tabname   = 'IT_OUT_EKPO'.
    wa_fcat_ekpo-seltext_l = 'PO Item'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR wa_fcat_ekpo.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekpo-col_pos   = lv_col.
    wa_fcat_ekpo-fieldname = 'MATNR'.
    wa_fcat_ekpo-tabname   = 'IT_OUT_EKPO'.
    wa_fcat_ekpo-seltext_l = 'Material'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR wa_fcat_ekpo.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekpo-col_pos   = lv_col.
    wa_fcat_ekpo-fieldname = 'WERKS'.
    wa_fcat_ekpo-tabname   = 'IT_OUT_EKPO'.
    wa_fcat_ekpo-seltext_l = 'Plant'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR wa_fcat_ekpo.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekpo-col_pos   = lv_col.
    wa_fcat_ekpo-fieldname = 'LGORT'.
    wa_fcat_ekpo-tabname   = 'IT_OUT_EKPO'.
    wa_fcat_ekpo-seltext_l = 'Storage Location'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR wa_fcat_ekpo.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekpo-col_pos   = lv_col.
    wa_fcat_ekpo-fieldname = 'MENGE'.
    wa_fcat_ekpo-tabname   = 'IT_OUT_EKPO'.
    wa_fcat_ekpo-seltext_l = 'Quantity'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR wa_fcat_ekpo.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekpo-col_pos   = lv_col.
    wa_fcat_ekpo-fieldname = 'MEINS'.
    wa_fcat_ekpo-tabname   = 'IT_OUT_EKPO'.
    wa_fcat_ekpo-seltext_l = 'Unit'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR wa_fcat_ekpo.
  ENDIF.

ENDFORM.                    " FIELDCAT_EKPO
*&---------------------------------------------------------------------*
*&      Form  GRID_EKPO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM grid_ekpo.

  IF    it_out_ekpo  IS NOT INITIAL
    AND it_fcat_ekpo IS NOT INITIAL.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_callback_program     = v_prog
        i_callback_top_of_page = 'TOP_EKPO'
        is_layout              = wa_layout
        it_fieldcat            = it_fcat_ekpo
      TABLES
        t_outtab               = it_out_ekpo
      EXCEPTIONS
        program_error          = 1
        OTHERS                 = 2.
  ENDIF.

ENDFORM.                    " GRID_EKPO
*&---------------------------------------------------------------------*
*&      Form  top_ekpo
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM top_ekpo.

  CLEAR wa_top_ekpo.
  REFRESH it_top_ekpo.

  wa_top_ekpo-typ = 'H'.
  wa_top_ekpo-info = 'Purchase Order Item Display'.
  APPEND wa_top_ekpo TO it_top_ekpo.
  CLEAR wa_top_ekpo.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_top_ekpo.

ENDFORM.                    "top_ekpo

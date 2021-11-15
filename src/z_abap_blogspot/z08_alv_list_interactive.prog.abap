*&---------------------------------------------------------------------*
*& Report Z08_ALV_LIST_INTERACTIVE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z08_alv_list_interactive.

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
       END OF ty_out_ekpo.

DATA: wa_ekko       TYPE                   ty_ekko,
      wa_ekpo       TYPE                   ty_ekpo,
      it_ekko       TYPE STANDARD TABLE OF ty_ekko,
      it_ekpo       TYPE STANDARD TABLE OF ty_ekpo,

      wa_out_ekko   TYPE                   ty_out_ekko,
      wa_out_ekpo   TYPE                   ty_out_ekpo,
      it_out_ekko   TYPE STANDARD TABLE OF ty_out_ekko,
      it_out_ekpo   TYPE STANDARD TABLE OF ty_out_ekpo,

      wa_fcat_ekko  TYPE slis_fieldcat_alv,
      wa_fcat_ekpo  TYPE slis_fieldcat_alv,
      it_fcat_ekko  TYPE slis_t_fieldcat_alv,
      it_fcat_ekpo  TYPE slis_t_fieldcat_alv,

      wa_layout     TYPE slis_layout_alv,

      wa_top_ekko   TYPE slis_listheader,
      wa_top_ekpo   TYPE slis_listheader,
      it_top_ekko   TYPE slis_t_listheader,
      it_top_ekpo   TYPE slis_t_listheader,

      wa_event_ekko TYPE slis_alv_event,
      wa_event_ekpo TYPE slis_alv_event,
      it_event_ekko TYPE slis_t_event,
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
  PERFORM ucomm_ekko USING r_ucomm
                     CHANGING rs_selfield.

TOP-OF-PAGE.
  PERFORM top_ekko.

TOP-OF-PAGE DURING LINE-SELECTION.
  PERFORM top_ekpo.

*&---------------------------------------------------------------------*
*&      Form  ucomm_ekko
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->R_UCOMM      text
*      -->RS_ESLFIELD  text
*----------------------------------------------------------------------*
FORM ucomm_ekko USING    r_ucomm_ekko     TYPE sy-ucomm
                CHANGING rs_selfield_ekko TYPE slis_selfield.

  CASE r_ucomm_ekko.
    WHEN '&IC1'.
      IF rs_selfield_ekko-fieldname = 'EBELN'.
        CLEAR v_selfield.
        v_selfield = rs_selfield_ekko-value.
        PERFORM conversion_po.
        PERFORM get_ekpo.
        PERFORM fieldcat_ekpo.
        PERFORM layout.
        PERFORM event_ekpo.
        PERFORM grid_ekpo.
        PERFORM ucomm_ekpo USING r_ucomm
                           CHANGING rs_selfield.
      ELSE.
        MESSAGE 'Invalid Field' TYPE 'S'.
      ENDIF.
  ENDCASE.
ENDFORM.                    "ucomm_ekko

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

  CLEAR wa_fcat_ekko.
  REFRESH it_fcat_ekko.

  IF it_out_ekko IS NOT INITIAL.

    DATA lv_col TYPE i VALUE 0.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekko-col_pos   = lv_col.
    wa_fcat_ekko-fieldname = 'EBELN'.
    wa_fcat_ekko-tabname   = 'IT_OUT_EKKO'.
    wa_fcat_ekko-seltext_l = 'Purchase Order'.
    APPEND wa_fcat_ekko TO it_fcat_ekko.
    CLEAR  wa_fcat_ekko.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekko-col_pos   = lv_col.
    wa_fcat_ekko-fieldname = 'BUKRS'.
    wa_fcat_ekko-tabname   = 'IT_OUT_EKKO'.
    wa_fcat_ekko-seltext_l = 'Company Code'.
    APPEND wa_fcat_ekko TO it_fcat_ekko.
    CLEAR  wa_fcat_ekko.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekko-col_pos   = lv_col.
    wa_fcat_ekko-fieldname = 'LIFNR'.
    wa_fcat_ekko-tabname   = 'IT_OUT_EKKO'.
    wa_fcat_ekko-seltext_l = 'Vendor'.
    APPEND wa_fcat_ekko TO it_fcat_ekko.
    CLEAR  wa_fcat_ekko.
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

  wa_layout-zebra             = 'X'.
  wa_layout-colwidth_optimize = 'X'.
  wa_layout-box_fieldname     = 'SEL'.

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

  REFRESH it_event_ekko.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    IMPORTING
      et_events       = it_event_ekko
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.

  IF it_event_ekko IS NOT INITIAL.
    CLEAR wa_event_ekko.
    READ TABLE it_event_ekko INTO wa_event_ekko
      WITH KEY name = 'USER_COMMAND'.

    IF sy-subrc = 0.
      wa_event_ekko-form = 'UCOMM_EKKO'.
      MODIFY it_event_ekko FROM wa_event_ekko
        INDEX sy-tabix TRANSPORTING form.
    ENDIF.

    CLEAR wa_event_ekko.
    READ TABLE it_event_ekko INTO wa_event_ekko
    WITH KEY name = 'TOP_OF_PAGE'.

    IF sy-subrc = 0.
      wa_event_ekko-form = 'TOP_EKKO'.
      MODIFY it_event_ekko FROM wa_event_ekko
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
FORM grid_ekko .

  IF    it_out_ekko IS NOT INITIAL
    AND it_fcat_ekko IS NOT INITIAL.

    CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
      EXPORTING
*       I_INTERFACE_CHECK       = ' '
*       I_BYPASSING_BUFFER      =
*       I_BUFFER_ACTIVE         = ' '
        i_callback_program      = v_prog
*       i_callback_pf_status_set       = ' '
        i_callback_user_command = 'UCOMM_EKKO'
*       I_STRUCTURE_NAME        =
        is_layout               = wa_layout
        it_fieldcat             = it_fcat_ekko
*       IT_EXCLUDING            =
*       IT_SPECIAL_GROUPS       =
*       IT_SORT                 =
*       IT_FILTER               =
*       IS_SEL_HIDE             =
*       I_DEFAULT               = 'X'
*       I_SAVE                  = ' '
*       IS_VARIANT              =
        it_events               = it_event_ekko
*       IT_EVENT_EXIT           =
*       IS_PRINT                =
*       IS_REPREP_ID            =
*       I_SCREEN_START_COLUMN   = 0
*       I_SCREEN_START_LINE     = 0
*       I_SCREEN_END_COLUMN     = 0
*       I_SCREEN_END_LINE       = 0
*       IR_SALV_LIST_ADAPTER    =
*       IT_EXCEPT_QINFO         =
*       I_SUPPRESS_EMPTY_DATA   = ABAP_FALSE
*    IMPORTING
*       E_EXIT_CAUSED_BY_CALLER =
*       ES_EXIT_CAUSED_BY_USER  =
      TABLES
        t_outtab                = it_out_ekko
      EXCEPTIONS
        program_error           = 1
        OTHERS                  = 2.

  ENDIF.

ENDFORM.                    " GRID_EKKO

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
*&      Form  CONVERSION_PO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM conversion_po.

  CLEAR v_ebeln.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = v_selfield
    IMPORTING
      output = v_ebeln.

ENDFORM.                    " CONVERSION_PO

*&---------------------------------------------------------------------*
*&      Form  GET_EKPO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_ekpo.

  IF v_ebeln IS NOT INITIAL.
    REFRESH it_ekpo.
    SELECT ebeln ebelp matnr werks lgort menge meins
      FROM ekpo INTO TABLE it_ekpo
      WHERE ebeln = v_ebeln.

    IF sy-subrc = 0.
      SORT it_ekpo BY ebelp.
      REFRESH it_out_ekpo.

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
    wa_fcat_ekpo-seltext_l = 'PO Quantity'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR wa_fcat_ekpo.

    lv_col                 = 1 + lv_col.
    wa_fcat_ekpo-col_pos   = lv_col.
    wa_fcat_ekpo-fieldname = 'MEINS'.
    wa_fcat_ekpo-tabname   = 'IT_OUT_EKPO'.
    wa_fcat_ekpo-seltext_l = 'Unit of Measure'.
    APPEND wa_fcat_ekpo TO it_fcat_ekpo.
    CLEAR wa_fcat_ekpo.
  ENDIF.

ENDFORM.                    " FIELDCAT_EKPO

*&---------------------------------------------------------------------*
*&      Form  EVENT_EKPO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM event_ekpo .

  REFRESH it_event_ekpo.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
* EXPORTING
*   I_LIST_TYPE           = 0
    IMPORTING
      et_events       = it_event_ekpo
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.

  IF it_event_ekpo IS NOT INITIAL.
    CLEAR wa_event_ekpo.
    READ TABLE it_event_ekpo INTO wa_event_ekpo
    WITH KEY name = 'USER_COMMAND'.

    IF sy-subrc = 0.
      wa_event_ekpo-form = 'UCOMM_EKPO'.
      MODIFY it_event_ekpo FROM wa_event_ekpo
      INDEX sy-tabix TRANSPORTING form.
    ENDIF.

    CLEAR wa_event_ekpo.
    READ TABLE it_event_ekpo INTO wa_event_ekpo
    WITH KEY name = 'TOP_OF_PAGE'.

    IF sy-subrc = 0.
      wa_event_ekpo-form = 'TOP_EKPO'.
      MODIFY it_event_ekpo FROM wa_event_ekpo
      INDEX sy-tabix TRANSPORTING form.
    ENDIF.
  ENDIF.

ENDFORM.                    " EVENT_EKPO

*&---------------------------------------------------------------------*
*&      Form  GRID_EKPO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM grid_ekpo .

  IF    it_out_ekpo IS NOT INITIAL
    AND it_fcat_ekpo IS NOT INITIAL.

    CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
      EXPORTING
*       I_INTERFACE_CHECK       = ' '
*       I_BYPASSING_BUFFER      =
*       I_BUFFER_ACTIVE         = ' '
        i_callback_program      = v_prog
*       I_CALLBACK_PF_STATUS_SET       = ' '
        i_callback_user_command = 'UCOMM_EKPO'
*       I_STRUCTURE_NAME        =
        is_layout               = wa_layout
        it_fieldcat             = it_fcat_ekpo
*       IT_EXCLUDING            =
*       IT_SPECIAL_GROUPS       =
*       IT_SORT                 =
*       IT_FILTER               =
*       IS_SEL_HIDE             =
*       I_DEFAULT               = 'X'
*       I_SAVE                  = ' '
*       IS_VARIANT              =
        it_events               = it_event_ekpo
*       IT_EVENT_EXIT           =
*       IS_PRINT                =
*       IS_REPREP_ID            =
*       I_SCREEN_START_COLUMN   = 0
*       I_SCREEN_START_LINE     = 0
*       I_SCREEN_END_COLUMN     = 0
*       I_SCREEN_END_LINE       = 0
*       IR_SALV_LIST_ADAPTER    =
*       IT_EXCEPT_QINFO         =
*       I_SUPPRESS_EMPTY_DATA   = ABAP_FALSE
*    IMPORTING
*       E_EXIT_CAUSED_BY_CALLER =
*       ES_EXIT_CAUSED_BY_USER  =
      TABLES
        t_outtab                = it_out_ekpo
      EXCEPTIONS
        program_error           = 1
        OTHERS                  = 2.
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
  wa_top_ekpo-info = 'Purchase Order Item wise Display'.
  APPEND wa_top_ekpo TO it_top_ekpo.
  CLEAR wa_top_ekpo.

  CALL FUNCTION 'REUSE_ALV_COMMENTARY_WRITE'
    EXPORTING
      it_list_commentary = it_top_ekpo
*     I_LOGO             =
*     I_END_OF_LIST_GRID =
*     I_ALV_FORM         =
    .

ENDFORM.                    "top_ekpo
*&---------------------------------------------------------------------*
*&      Form  UCOMM_EKPO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_R_UCOM  text
*      <--P_RS_SELFIELD  text
*----------------------------------------------------------------------*
FORM ucomm_ekpo  USING    r_ucomm_ekpo      TYPE sy-ucomm
                 CHANGING rs_selfield_ekpo  TYPE slis_selfield.

  CASE r_ucomm_ekpo.
    WHEN '&IC1'.
      IF rs_selfield_ekpo-fieldname = 'EBELN'.

        SET PARAMETER ID 'BES' FIELD v_ebeln.
        CALL TRANSACTION 'ME23N'.

      ELSE.
        MESSAGE 'Invalid Field' TYPE 'S'.
      ENDIF.
  ENDCASE.


ENDFORM.                    " UCOMM_EKPO

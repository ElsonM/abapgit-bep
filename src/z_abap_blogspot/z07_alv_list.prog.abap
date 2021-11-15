*&---------------------------------------------------------------------*
*& Report Z07_ALV_LIST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z07_alv_list.

TABLES: mara, marc, mard, makt.

TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         ersda TYPE mara-ersda,
         ernam TYPE mara-ernam,
         mtart TYPE mara-mtart,
       END OF ty_mara,

       BEGIN OF ty_marc,
         matnr TYPE marc-matnr,
         werks TYPE marc-werks,
         xchar TYPE marc-xchar,
       END OF ty_marc,

       BEGIN OF ty_mard,
         matnr TYPE mard-matnr,
         werks TYPE mard-werks,
         lgort TYPE mard-lgort,
       END OF ty_mard,

       BEGIN OF ty_makt,
         matnr TYPE makt-matnr,
         spras TYPE makt-spras,
         maktx TYPE makt-maktx,
       END OF ty_makt,

       BEGIN OF ty_out,
         sel,
         matnr TYPE mara-matnr,
         werks TYPE marc-werks,
         lgort TYPE mard-lgort,
         mtart TYPE mara-mtart,
         ersda TYPE mara-ersda,
         ernam TYPE mara-ernam,
         xchar TYPE marc-xchar,
         maktx TYPE makt-maktx,
       END OF ty_out.

DATA: wa_mara TYPE                   ty_mara,
      wa_marc TYPE                   ty_marc,
      wa_mard TYPE                   ty_mard,
      wa_makt TYPE                   ty_makt,
      wa_out  TYPE                   ty_out,
      it_mara TYPE STANDARD TABLE OF ty_mara,
      it_marc TYPE STANDARD TABLE OF ty_marc,
      it_mard TYPE STANDARD TABLE OF ty_mard,
      it_makt TYPE STANDARD TABLE OF ty_makt,
      it_out  TYPE STANDARD TABLE OF ty_out.

DATA: wa_fcat_out TYPE slis_fieldcat_alv,
      it_fcat_out TYPE slis_t_fieldcat_alv,
      wa_layout   TYPE slis_layout_alv,
      wa_top      TYPE slis_listheader,
      it_top      TYPE slis_t_listheader,
      wa_event    TYPE slis_alv_event,
      it_event    TYPE slis_t_event.

DATA: v_prog TYPE sy-repid,
      v_name TYPE sy-uname,
      v_date TYPE sy-datum,
      v_time TYPE sy-uzeit.

INITIALIZATION.
  v_prog = sy-repid.
  v_name = sy-uname.
  v_date = sy-datum.
  v_time = sy-uzeit.

  SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
    PARAMETERS     p_mtart TYPE mtart OBLIGATORY.
    SELECT-OPTIONS s_matnr FOR  mara-matnr.
  SELECTION-SCREEN END OF BLOCK b1.

START-OF-SELECTION.
  PERFORM get_material.
  PERFORM get_plant.
  PERFORM get_storage.
  PERFORM get_description.
  PERFORM prepare_output.

END-OF-SELECTION.
  PERFORM prepare_fieldcat.
  PERFORM prepare_layout.
  PERFORM declare_event.
  PERFORM alv_list_display.

TOP-OF-PAGE.
  PERFORM top_of_page.

*&---------------------------------------------------------------------*
*&      Form  GET_MATERIAL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_material.

  SELECT matnr ersda ernam mtart
    FROM mara INTO TABLE it_mara
    WHERE matnr IN s_matnr
      AND mtart = p_mtart.

  IF sy-subrc = 0.
    SORT it_mara BY matnr.
  ELSE.
    MESSAGE 'Material doesn''t exist' TYPE 'I'.
  ENDIF.

ENDFORM.                    " GET_MATERIAL

*&---------------------------------------------------------------------*
*&      Form  GET_PLANT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_plant.

  IF it_mara IS NOT INITIAL.
    SELECT matnr werks xchar
      FROM marc INTO TABLE it_marc
      FOR ALL ENTRIES IN it_mara
      WHERE matnr = it_mara-matnr.

    IF sy-subrc = 0.
      SORT it_marc BY matnr.
    ENDIF.
  ENDIF.

ENDFORM.                    " GET_PLANT

*&---------------------------------------------------------------------*
*&      Form  GET_STORAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_storage.

  IF it_marc IS NOT INITIAL.
    SELECT matnr werks lgort
      FROM mard INTO TABLE it_mard
      FOR ALL ENTRIES IN it_marc
      WHERE matnr = it_marc-matnr
        AND werks = it_marc-werks.

    IF sy-subrc = 0.
      SORT it_mard BY matnr.
    ENDIF.
  ENDIF.

ENDFORM.                    " GET_STORAGE

*&---------------------------------------------------------------------*
*&      Form  GET_DESCRIPTION
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_description.

  IF it_mara IS NOT INITIAL.
    SELECT matnr spras maktx
      FROM makt INTO TABLE it_makt
      FOR ALL ENTRIES IN it_mara
      WHERE matnr = it_mara-matnr
        AND spras = sy-langu.

    IF sy-subrc = 0.
      SORT it_makt BY matnr.
    ENDIF.
  ENDIF.

ENDFORM.                    " GET_DESCRIPTION

*&---------------------------------------------------------------------*
*&      Form  PREPARE_OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prepare_output.

  IF    it_mara IS NOT INITIAL
    AND it_marc IS NOT INITIAL
    AND it_mard IS NOT INITIAL.

    LOOP AT it_mara INTO wa_mara.
      wa_out-matnr = wa_mara-matnr.
      wa_out-ersda = wa_mara-ersda.
      wa_out-ernam = wa_mara-ernam.
      wa_out-mtart = wa_mara-mtart.

      READ TABLE it_makt INTO wa_makt
        WITH KEY matnr = wa_mara-matnr BINARY SEARCH.
      IF sy-subrc = 0.
        wa_out-maktx = wa_makt-maktx.
      ENDIF.

      LOOP AT it_marc INTO wa_marc
        WHERE matnr = wa_mara-matnr.

        wa_out-werks = wa_marc-werks.
        wa_out-xchar = wa_marc-xchar.

        LOOP AT it_mard INTO wa_mard
          WHERE matnr = wa_marc-matnr
            AND werks = wa_marc-werks.

          wa_out-lgort = wa_mard-lgort.
          APPEND wa_out TO it_out.
          CLEAR: wa_out, wa_mara, wa_makt.
          CLEAR wa_mard.

        ENDLOOP.

        CLEAR wa_marc.

      ENDLOOP.

    ENDLOOP.

  ENDIF.

ENDFORM.                    " PREPARE_OUTPUT

*&---------------------------------------------------------------------*
*&      Form  PREPARE_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prepare_fieldcat.

  CLEAR   wa_fcat_out.
  REFRESH it_fcat_out.

  IF it_out IS NOT INITIAL.

    DATA: lv_col TYPE i VALUE 0.

    lv_col                = 1 + lv_col.
    wa_fcat_out-col_pos   = lv_col.
    wa_fcat_out-fieldname = 'MATNR'.
    wa_fcat_out-tabname   = 'IT_OUT'.
    wa_fcat_out-seltext_l = 'Material No.'.
    APPEND wa_fcat_out TO it_fcat_out.
    CLEAR  wa_fcat_out.

    lv_col                = 1 + lv_col.
    wa_fcat_out-col_pos   = lv_col.
    wa_fcat_out-fieldname = 'WERKS'.
    wa_fcat_out-tabname   = 'IT_OUT'.
    wa_fcat_out-seltext_l = 'Plant'.
    APPEND wa_fcat_out TO it_fcat_out.
    CLEAR  wa_fcat_out.

    lv_col                = 1 + lv_col.
    wa_fcat_out-col_pos   = lv_col.
    wa_fcat_out-fieldname = 'LGORT'.
    wa_fcat_out-tabname   = 'IT_OUT'.
    wa_fcat_out-seltext_l = 'Storage Location'.
    APPEND wa_fcat_out TO it_fcat_out.
    CLEAR  wa_fcat_out.

    lv_col                = 1 + lv_col.
    wa_fcat_out-col_pos   = lv_col.
    wa_fcat_out-fieldname = 'MTART'.
    wa_fcat_out-tabname   = 'IT_OUT'.
    wa_fcat_out-seltext_l = 'Material Type'.
    APPEND wa_fcat_out TO it_fcat_out.
    CLEAR  wa_fcat_out.

    lv_col                = 1 + lv_col.
    wa_fcat_out-col_pos   = lv_col.
    wa_fcat_out-fieldname = 'ERSDA'.
    wa_fcat_out-tabname   = 'IT_OUT'.
    wa_fcat_out-seltext_l = 'Date'.
    APPEND wa_fcat_out TO it_fcat_out.
    CLEAR  wa_fcat_out.

    lv_col                = 1 + lv_col.
    wa_fcat_out-col_pos   = lv_col.
    wa_fcat_out-fieldname = 'ERNAM'.
    wa_fcat_out-tabname   = 'IT_OUT'.
    wa_fcat_out-seltext_l = 'Name'.
    APPEND wa_fcat_out TO it_fcat_out.
    CLEAR  wa_fcat_out.

    lv_col                = 1 + lv_col.
    wa_fcat_out-col_pos   = lv_col.
    wa_fcat_out-fieldname = 'XCHAR'.
    wa_fcat_out-tabname   = 'IT_OUT'.
    wa_fcat_out-seltext_l = 'Batch No.'.
    APPEND wa_fcat_out TO it_fcat_out.
    CLEAR  wa_fcat_out.

    lv_col                = 1 + lv_col.
    wa_fcat_out-col_pos   = lv_col.
    wa_fcat_out-fieldname = 'MAKTX'.
    wa_fcat_out-tabname   = 'IT_OUT'.
    wa_fcat_out-seltext_l = 'Material Description'.
    APPEND wa_fcat_out TO it_fcat_out.
    CLEAR  wa_fcat_out.

  ENDIF.

ENDFORM.                    " PREPARE_FIELDCAT

*&---------------------------------------------------------------------*
*&      Form  DECLARE_EVENT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM declare_event.

  CLEAR wa_event.
  REFRESH it_event.

  CALL FUNCTION 'REUSE_ALV_EVENTS_GET'
    IMPORTING
      et_events       = it_event
    EXCEPTIONS
      list_type_wrong = 1
      OTHERS          = 2.

  IF it_event IS NOT INITIAL.
    READ TABLE it_event INTO wa_event
      WITH KEY name = 'TOP_OF_PAGE'.

    IF sy-subrc = 0.
      wa_event-form = 'TOP_OF_PAGE'.
      MODIFY it_event FROM wa_event
        INDEX sy-tabix TRANSPORTING form.
    ENDIF.
  ENDIF.

ENDFORM.                    " DECLARE_EVENT

*&---------------------------------------------------------------------*
*&      Form  ALV_LIST_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_list_display .

  IF    it_out      IS NOT INITIAL
    AND it_fcat_out IS NOT INITIAL
    AND it_event    IS NOT INITIAL.

    CALL FUNCTION 'REUSE_ALV_LIST_DISPLAY'
      EXPORTING
        i_callback_program = v_prog
        is_layout          = wa_layout
        it_fieldcat        = it_fcat_out
        it_events          = it_event
      TABLES
        t_outtab           = it_out
      EXCEPTIONS
        program_error      = 1
        OTHERS             = 2.
  ENDIF.

ENDFORM.                    " ALV_LIST_DISPLAY

*&---------------------------------------------------------------------*
*&      Form  TOP_OF_PAGE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM top_of_page.

  WRITE: / 'Material Details List',
         / 'Report:', v_prog,
         / 'User  :', v_name,
         / 'Date  :', v_date DD/MM/YYYY,
         / 'Time  :', v_time.
  SKIP.

ENDFORM.                    " TOP_OF_PAGE

*&---------------------------------------------------------------------*
*&      Form  PREPARE_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM prepare_layout.

  wa_layout-zebra             = 'X'.
  wa_layout-colwidth_optimize = 'X'.
  wa_layout-box_fieldname     = 'SEL'.


ENDFORM.                    " PREPARE_LAYOUT

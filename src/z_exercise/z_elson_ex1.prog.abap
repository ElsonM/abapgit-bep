*&---------------------------------------------------------------------*
*& Report Z_ELSON_EX1
*&---------------------------------------------------------------------*
REPORT z_elson_ex1.

*TABLES vbak.
*
**Global variables
**DATA: it_vbak  TYPE TABLE OF vbak,
**      it_vbap  TYPE TABLE OF vbap,
**      it_vbap2 TYPE TABLE OF vbap, "Perdoret per versionin me 2 Loop
**
**      wa_vbak  TYPE vbak,
**      wa_vbap  TYPE vbap.
*
**Input parameters
*SELECT-OPTIONS so_auart FOR vbak-auart. "wa_vbak-auart
*
**---> Used if we want to disable EXECUTE option
**DATA: gv_ucomm TYPE          sy-ucomm.
**DATA: gt_ucomm TYPE TABLE OF sy-ucomm.
**
**AT SELECTION-SCREEN OUTPUT.
**  gv_ucomm = 'ONLI'.
**  APPEND gv_ucomm TO gt_ucomm.
**  CLEAR gv_ucomm.
**
**  CALL FUNCTION 'RS_SET_SELSCREEN_STATUS'
**    EXPORTING
**      p_status        = sy-pfkey
**    TABLES
**      p_exclude       = gt_ucomm.
*
**Start of calculations
*START-OF-SELECTION.
*  SELECT vbeln
*    FROM vbak
*    INTO TABLE @DATA(it_vbak)
*    WHERE auart IN @so_auart.
*
**  Version me loop brenda loop - JO I PERDORSHEM
**
**  IF sy-subrc = 0.
**
**    LOOP AT lt_vbak INTO ls_vbak.
**
**      SELECT * FROM vbap INTO TABLE lt_vbap WHERE vbeln = ls_vbak-vbeln.
**      APPEND LINES OF lt_vbap TO lt_vbap2.
**
**      LOOP AT lt_vbap INTO ls_vbap.
**        APPEND ls_vbap TO lt_vbap2. "Ruan te tere rezultatet
**        WRITE: / ls_vbap-vbeln, ls_vbap-posnr, ls_vbap-matnr, ls_vbap-matkl, ls_vbap-arktx.
**        CLEAR ls_vbap.
**      ENDLOOP.
**
**    ENDLOOP.
**
**  ELSE.
**
**    MESSAGE TEXT-e01 TYPE 'E'.
**
**  ENDIF.
*
** Nese perdoret APPEND LINES OF ---
**  LOOP AT lt_vbap2 INTO ls_vbap.
**
**    WRITE: / ls_vbap-vbeln, ls_vbap-posnr, ls_vbap-matnr, ls_vbap-matkl, ls_vbap-arktx.
**    CLEAR ls_vbap.
**
**  ENDLOOP.
*
** Version me vetem 1 loop
*  IF sy-subrc = 0.
*    SELECT vbeln, posnr, matnr, matkl, arktx
*      FROM vbap
*      INTO TABLE @DATA(it_vbap)
*      FOR ALL ENTRIES IN @it_vbak
*      WHERE vbeln = @it_vbak-vbeln.
*
*    LOOP AT it_vbap INTO DATA(wa_vbap).
*      AT FIRST.
*        WRITE: / 'Sales Document'  COLOR 5, 16 'Sales Document Item' COLOR 5,
*              36 'Material Number' COLOR 5, 52 'Material Group'      COLOR 5, 67 'Short text for sales order item' COLOR 5.
*        ULINE.
*      ENDAT.
*      WRITE: / wa_vbap-vbeln, 16 wa_vbap-posnr, 36 wa_vbap-matnr, 52 wa_vbap-matkl, 67 wa_vbap-arktx.
*      CLEAR: wa_vbap.
*    ENDLOOP.
*  ELSE.
*    MESSAGE TEXT-e01 TYPE 'S'.
*  ENDIF.

NODES: spfli, sflight.

*DATA: gr_table TYPE REF TO cl_salv_hierseq_table.
DATA: it_spfli TYPE TABLE OF spfli.
DATA: it_sflight TYPE TABLE OF sflight.
*DATA: it_binding TYPE salv_t_hierseq_binding.
*DATA: wa_binding LIKE LINE OF it_binding.

GET spfli.
  APPEND spfli TO it_spfli.

GET sflight.
  APPEND sflight TO it_sflight.

END-OF-SELECTION.
*  wa_binding-master = 'CARRID'.
*  wa_binding-slave  = 'CARRID'.
*  APPEND wa_binding TO it_binding.
*
*  wa_binding-master = 'CONNID'.
*  wa_binding-slave  = 'CONNID'.
*  APPEND wa_binding TO it_binding.

  cl_salv_hierseq_table=>factory(
    EXPORTING
      t_binding_level1_level2 =
        VALUE #( ( master = 'CARRID' slave = 'CARRID' )
                 ( master = 'CONNID' slave = 'CONNID' ) )
    IMPORTING
      r_hierseq = DATA(gr_table)
    CHANGING
      t_table_level1 = it_spfli
      t_table_level2 = it_sflight ).

  gr_table->display( ).

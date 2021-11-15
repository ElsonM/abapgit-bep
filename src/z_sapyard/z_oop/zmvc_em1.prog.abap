REPORT zmvc_em1.

*** SELECTION SCREEN *****************************************
DATA gv_vbeln TYPE vbap-vbeln.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS p_werks TYPE vbap-werks.
SELECT-OPTIONS s_vbeln FOR gv_vbeln.
SELECTION-SCREEN END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-002.
PARAMETERS: p_var LIKE disvariant-variant.
SELECTION-SCREEN END OF BLOCK b2.
**************************************************************

*** GLOBAL DATA **********************************************
CLASS: cl_sel DEFINITION DEFERRED,
       cl_variant DEFINITION DEFERRED,
       cl_fetch DEFINITION DEFERRED,
       cl_alv DEFINITION DEFERRED.

DATA: o_sel     TYPE REF TO cl_sel,
      o_var     TYPE REF TO cl_variant,
      o_fetch   TYPE REF TO cl_fetch,
      o_display TYPE REF TO cl_alv.
**************************************************************

CLASS cl_variant DEFINITION FINAL.
  PUBLIC SECTION.
    TYPES: ty_var TYPE disvariant-variant,
           ty_repid TYPE sy-repid.

    DATA mv_layout TYPE disvariant-variant.

    METHODS
      f4_variant
        CHANGING
          cv_layout TYPE disvariant-variant.

    CLASS-METHODS
      get_default
        CHANGING cv_layout TYPE disvariant-variant.
ENDCLASS.

*&---------------------------------------------------------------------*
*& Class (Implementation) CL_VARIANT
*&---------------------------------------------------------------------*
*  Text
*----------------------------------------------------------------------*
CLASS cl_variant IMPLEMENTATION.

  METHOD f4_variant.
    DATA: ls_layout TYPE salv_s_layout_info,
          ls_key TYPE salv_s_layout_key.

    ls_key-report = sy-repid.
    ls_layout = cl_salv_layout_service=>f4_layouts(
                  s_key    = ls_key
                  restrict = if_salv_c_layout=>restrict_none  ).
    cv_layout = ls_layout-layout.
    mv_layout = cv_layout.
  ENDMETHOD.

  METHOD get_default.
    DATA: ls_layout TYPE salv_s_layout_info,
          ls_key TYPE salv_s_layout_key.

    ls_key-report = sy-repid.
    ls_layout = cl_salv_layout_service=>get_default_layout(
                  s_key    = ls_key
                  restrict = if_salv_c_layout=>restrict_none  ).
    cv_layout = ls_layout-layout.
  ENDMETHOD.

ENDCLASS. "CL_VARIANT

****** SEL CLASS FOR SELECTING FIELDS *********************************
CLASS cl_sel DEFINITION FINAL.
  PUBLIC SECTION .
    TYPES: ty_vbeln TYPE RANGE OF vbeln.

    DATA: mr_vbeln TYPE ty_vbeln,
          mv_werks TYPE werks_ext.

    METHODS
      check_plant
        IMPORTING
          iv_werks TYPE werks_ext.

    METHODS
      get_screen
        IMPORTING
          iv_werks TYPE werks_ext
          ir_vbeln TYPE ty_vbeln.
ENDCLASS.

*&---------------------------------------------------------------------*
*&       CLASS (IMPLEMENTATION)  SEL
*&---------------------------------------------------------------------*
*        TEXT
*----------------------------------------------------------------------*
CLASS cl_sel IMPLEMENTATION.
  METHOD check_plant .
    IF iv_werks IS NOT INITIAL .
      SELECT COUNT(*) UP TO 1 ROWS
        FROM t001w
        WHERE werks = iv_werks.
      IF sy-subrc NE 0.
        MESSAGE 'PLEASE ENTER A VALID WERKS' TYPE 'E'.
      ENDIF.
    ENDIF .
  ENDMETHOD.

  METHOD get_screen.
    me->mv_werks = iv_werks.
    me->mr_vbeln = ir_vbeln.
  ENDMETHOD.
ENDCLASS.               "SEL

******* FETCH CLASS FOR DATA FETCH ***********************************
CLASS cl_fetch DEFINITION.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_final,
             vbeln   TYPE vbeln_va,
             posnr   TYPE posnr_va,
             vkorg   TYPE vkorg,
             spart   TYPE spart,
             vkgrp   TYPE vkgrp,
             matnr   TYPE matnr,
             arktx   TYPE arktx,
             pstyv   TYPE pstyv,
             sp_name TYPE ad_name1,
             sh_name TYPE ad_name1,
           END OF ty_final.
    TYPES : BEGIN OF ty_vbak,
              vbeln TYPE vbeln_va,
              vkorg TYPE vkorg,
              spart TYPE spart,
              vkgrp TYPE vkgrp,
            END OF ty_vbak.
    TYPES : BEGIN OF ty_vbpa,
              vbeln TYPE vbeln_va,
              posnr TYPE posnr_va,
              parvw TYPE parvw,
              kunnr TYPE kunnr,
              adrnr TYPE adrnr,
            END OF ty_vbpa .
    TYPES : BEGIN OF ty_adrc,
              addrnumber TYPE ad_addrnum,
              name1      TYPE ad_name1,
            END OF ty_adrc .
    DATA : it_final TYPE STANDARD TABLE OF ty_final.
    DATA : wa_final TYPE ty_final .

    DATA : it_vbak TYPE STANDARD TABLE OF ty_vbak,
           wa_vbak TYPE ty_vbak.

    DATA : it_vbpa TYPE STANDARD TABLE OF ty_vbpa,
           wa_vbpa TYPE ty_vbpa.

    DATA : it_adrc TYPE STANDARD TABLE OF ty_adrc,
           wa_adrc TYPE ty_adrc.

    DATA : it_vbap TYPE STANDARD TABLE OF vbap,
           wa_vbap TYPE vbap.

    DATA : sel_obj TYPE REF TO cl_sel .
    METHODS : constructor IMPORTING ref_sel TYPE REF TO cl_sel .
    METHODS : fetch_data .
    METHODS : arrange_data .
ENDCLASS .
*&---------------------------------------------------------------------*
*&       CLASS (IMPLEMENTATION)  FETCH
*&---------------------------------------------------------------------*
*        TEXT
*----------------------------------------------------------------------*
CLASS cl_fetch IMPLEMENTATION.

  METHOD constructor.
    me->sel_obj = ref_sel.
  ENDMETHOD.

  METHOD fetch_data.
    SELECT * FROM vbap INTO TABLE me->it_vbap UP TO 100 ROWS
      WHERE vbeln IN me->sel_obj->mr_vbeln
        AND werks EQ me->sel_obj->mv_werks.

    SORT me->it_vbap BY vbeln posnr.
    IF me->it_vbap IS NOT INITIAL.
      SELECT vbeln
             vkorg
             spart
             vkgrp FROM vbak INTO TABLE me->it_vbak
        FOR ALL ENTRIES IN  me->it_vbap
        WHERE vbeln = me->it_vbap-vbeln.

      SELECT vbeln
             posnr
             parvw
             kunnr
             adrnr
        FROM vbpa INTO TABLE me->it_vbpa
        FOR ALL ENTRIES IN me->it_vbap
        WHERE vbeln = me->it_vbap-vbeln
          AND parvw IN ('AG','WE').

      SELECT addrnumber name1 FROM adrc INTO TABLE me->it_adrc
        FOR ALL ENTRIES IN me->it_vbpa
        WHERE addrnumber = me->it_vbpa-adrnr.
    ENDIF.
  ENDMETHOD.

  METHOD arrange_data.

    me->fetch_data( ).

    LOOP AT me->it_vbap INTO DATA(ls_vbap).
      me->wa_final-vbeln = ls_vbap-vbeln.
      me->wa_final-posnr = ls_vbap-posnr.
      me->wa_final-matnr = ls_vbap-matnr.
      me->wa_final-arktx = ls_vbap-arktx.
      me->wa_final-pstyv = ls_vbap-pstyv.

      READ TABLE me->it_vbak INTO me->wa_vbak
        WITH KEY vbeln = ls_vbap-vbeln.
      IF sy-subrc EQ 0.
        me->wa_final-vkorg = me->wa_vbak-vkorg.
        me->wa_final-spart = me->wa_vbak-spart.
        me->wa_final-vkgrp = me->wa_vbak-vkgrp.
      ENDIF .

      READ TABLE me->it_vbpa INTO me->wa_vbpa WITH KEY
      vbeln = ls_vbap-vbeln  parvw = 'AG'.
      IF sy-subrc EQ 0.
        READ TABLE me->it_adrc INTO me->wa_adrc WITH KEY
        addrnumber = me->wa_vbpa-adrnr .
        me->wa_final-sp_name = me->wa_adrc-name1 .
      ENDIF.

      READ TABLE me->it_vbpa INTO me->wa_vbpa WITH KEY
      vbeln = ls_vbap-vbeln  parvw = 'WE'.
      IF sy-subrc EQ 0.
        READ TABLE me->it_adrc INTO me->wa_adrc WITH KEY
        addrnumber = me->wa_vbpa-adrnr .
        me->wa_final-sh_name = me->wa_adrc-name1 .
      ENDIF.
      APPEND me->wa_final TO me->it_final .
    ENDLOOP.
  ENDMETHOD .
ENDCLASS.               "FETCH

*******************************DISPLAY DATA ******************************
CLASS cl_alv DEFINITION .
  PUBLIC SECTION .
    DATA : fetch_obj  TYPE REF TO cl_fetch .
    DATA : variant_obj TYPE REF TO cl_variant .
    DATA : o_alv TYPE REF TO cl_salv_table.
    METHODS : constructor IMPORTING ref_fetch TYPE REF TO cl_fetch
                                    ref_var   TYPE REF TO cl_variant.
    METHODS : get_object .
    METHODS : layout_dis .
    METHODS : display_alv .

ENDCLASS .
*&---------------------------------------------------------------------*
*&       Class (Implementation)  CL_ALV
*&---------------------------------------------------------------------*
*        Text
*----------------------------------------------------------------------*
CLASS cl_alv IMPLEMENTATION.
  METHOD constructor .
    me->fetch_obj = ref_fetch .
    me->variant_obj = ref_var.
  ENDMETHOD .
  METHOD get_object .
    DATA: lx_msg TYPE REF TO cx_salv_msg.
    TRY.
        cl_salv_table=>factory(
        IMPORTING
        r_salv_table = me->o_alv
        CHANGING
        t_table      = me->fetch_obj->it_final ).
      CATCH cx_salv_msg INTO lx_msg.
    ENDTRY.
  ENDMETHOD .
  METHOD layout_dis.
    DATA : ls_key    TYPE salv_s_layout_key,
           lo_layout TYPE REF TO cl_salv_layout.
    DATA: lo_functions TYPE REF TO cl_salv_functions_list.
    ls_key-report = sy-repid .
*  GET DEFAULT TOOLBAR ICONS
    lo_functions = me->o_alv->get_functions( ).
    lo_functions->set_default( abap_true ).
* GET LAYOUT OBUJECT
    lo_layout = me->o_alv->get_layout( ).
* ALLOW SAVING LAYOUT
    lo_layout->set_save_restriction( if_salv_c_layout=>restrict_none ).
    lo_layout->set_key( ls_key ).
* Allow default layout check box
    lo_layout->set_default( abap_true ).
*setting the layout from my class CL_VARIANT
    IF me->variant_obj->mv_layout IS NOT INITIAL .
      lo_layout->set_initial_layout( me->variant_obj->mv_layout  ) .
    ENDIF .

  ENDMETHOD .

  METHOD display_alv.
    me->get_object( ).
    me->layout_dis( ).

    me->o_alv->display( ).
  ENDMETHOD.

ENDCLASS.               "CL_ALV

INITIALIZATION.
  CREATE OBJECT: o_sel,
                 o_var,
                 o_fetch
                   EXPORTING ref_sel = o_sel,
                 o_display
                   EXPORTING ref_fetch = o_fetch
                             ref_var   = o_var.

  cl_variant=>get_default( CHANGING cv_layout = p_var ).

AT SELECTION-SCREEN .
  o_sel->check_plant( p_werks ).

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_var.
  o_var->f4_variant( CHANGING cv_layout = p_var ).

START-OF-SELECTION.
  o_sel->get_screen(
    iv_werks = p_werks
    ir_vbeln = s_vbeln[] ).

  o_fetch->arrange_data( ) .

END-OF-SELECTION .
  o_display->display_alv( ).

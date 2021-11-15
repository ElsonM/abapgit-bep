*&---------------------------------------------------------------------*
*& Report Z_ELSON_T21_UPDATE_ALV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t21_update_alv.

TYPES: BEGIN OF ty_mod,
         row TYPE i,
       END OF ty_mod.

CONSTANTS g_container TYPE scrfname VALUE 'CUSTOM_CONTAINER'.

DATA: grid1              TYPE REF TO cl_gui_alv_grid,
      g_custom_container TYPE REF TO cl_gui_custom_container.

DATA: i_table TYPE REF TO data,
      wa_all  TYPE REF TO data.

DATA: org_crit_inst     TYPE vimty_oc_type,
      old_rc            LIKE sy-subrc,
      act_level         LIKE authb-actvt,
      only_show_allowed TYPE c,
      i_exclude         TYPE ui_functions.

DATA: i_mod TYPE STANDARD TABLE OF ty_mod,
      i_del TYPE STANDARD TABLE OF ty_mod.

FIELD-SYMBOLS: <i_itab> TYPE table,
               <wa_tab> TYPE any.

DATA: BEGIN OF header OCCURS 1.
    INCLUDE STRUCTURE vimdesc.
DATA: END OF header.

DATA: BEGIN OF namtab OCCURS 50.
    INCLUDE STRUCTURE vimnamtab.
DATA: END OF namtab.

DATA: vim_wheretab LIKE vimwheretb OCCURS 10.

DATA: dba_sellist LIKE vimsellist OCCURS 10.

DATA: lh_norec     TYPE i,
      lh_total(5)  TYPE c,
      lh_succ(40)  TYPE c,
      lwa_del      TYPE ty_mod,
      lwa_mod      TYPE ty_mod,
      lh_totdel    TYPE i,
      lh_flag      TYPE c,
      li_fieldcat  TYPE lvc_t_fcat,
      lwa_fieldcat TYPE lvc_s_fcat.


"Selection Screen
SELECTION-SCREEN BEGIN OF BLOCK bb WITH FRAME TITLE TEXT-100.
  PARAMETERS: viewname TYPE tvdir-tabname.
  SELECTION-SCREEN SKIP 2.
  SELECTION-SCREEN BEGIN OF LINE.
  SELECTION-SCREEN PUSHBUTTON 20(10) TEXT-101 USER-COMMAND b1. "Display
  SELECTION-SCREEN PUSHBUTTON 36(10) TEXT-102 USER-COMMAND b2. "Change / Modify
  SELECTION-SCREEN END OF LINE.
SELECTION-SCREEN END OF BLOCK bb.

AT SELECTION-SCREEN.
  CASE sy-ucomm.
    WHEN 'B1'.
      SET PF-STATUS 'ALV'.
      CALL SCREEN 9001.
    WHEN 'B2'.
      SET PF-STATUS 'ALV1'.
      CALL SCREEN 9001.
    WHEN OTHERS.
  ENDCASE.

CLASS lcl_event_handler DEFINITION.
  PUBLIC SECTION.
    METHODS: handle_data_changed
                  FOR EVENT data_changed OF cl_gui_alv_grid
      IMPORTING er_data_changed.
ENDCLASS.

CLASS lcl_event_handler IMPLEMENTATION.
  METHOD handle_data_changed.
    PERFORM handle_data_changed USING er_data_changed.
  ENDMETHOD.
ENDCLASS.

*&---------------------------------------------------------------------*
*&      Form  HANDLE_DATA_CHANGED
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_ER_DATA_CHANGED  text
*----------------------------------------------------------------------*
FORM handle_data_changed  USING p_er_data_changed TYPE REF TO cl_alv_changed_data_protocol.
  DATA: lwa_mod_cell TYPE lvc_s_modi,
        lwa_mod      TYPE ty_mod.
  LOOP AT p_er_data_changed->mt_good_cells INTO lwa_mod_cell.
    lwa_mod-row  = lwa_mod_cell-row_id.
    APPEND lwa_mod TO i_mod.
  ENDLOOP.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  EXCLUDE_TB_FUNCTIONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_I_EXCLUDE  text
*----------------------------------------------------------------------*
FORM exclude_tb_functions CHANGING pt_exclude TYPE ui_functions.

  DATA: lwa_exclude TYPE ui_func.

  lwa_exclude = cl_gui_alv_grid=>mc_fc_loc_append_row.
  APPEND lwa_exclude TO pt_exclude.

  lwa_exclude = cl_gui_alv_grid=>mc_fc_loc_copy.
  APPEND lwa_exclude TO pt_exclude.

  lwa_exclude = cl_gui_alv_grid=>mc_fc_loc_copy_row.
  APPEND lwa_exclude TO pt_exclude.

  lwa_exclude = cl_gui_alv_grid=>mc_fc_loc_cut.
  APPEND lwa_exclude TO pt_exclude.

  lwa_exclude = cl_gui_alv_grid=>mc_fc_loc_delete_row.
  APPEND lwa_exclude TO pt_exclude.

  lwa_exclude = cl_gui_alv_grid=>mc_fc_loc_insert_row.
  APPEND lwa_exclude TO pt_exclude.

  lwa_exclude = cl_gui_alv_grid=>mc_fc_loc_move_row.
  APPEND lwa_exclude TO pt_exclude.

  lwa_exclude = cl_gui_alv_grid=>mc_fc_loc_paste.
  APPEND lwa_exclude TO pt_exclude.

  lwa_exclude = cl_gui_alv_grid=>mc_fc_loc_paste_new_row.
  APPEND lwa_exclude TO pt_exclude.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  HANDLE_USER_COMMAND
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_SY_UCOMM  text
*----------------------------------------------------------------------*
FORM handle_user_command  USING    p_sy_ucomm.
  DATA: i_selected_rows  TYPE lvc_t_roid .
  DATA: lwa_selected_row TYPE lvc_s_roid,
        lwa_del          TYPE ty_mod.
  CALL METHOD grid1->get_selected_rows
    IMPORTING
      et_row_no = i_selected_rows.
  LOOP AT i_selected_rows INTO lwa_selected_row.
    lwa_del-row = lwa_selected_row-row_id.
    APPEND lwa_del TO i_del.
  ENDLOOP.
ENDFORM.

INCLUDE zupdate_alv_status_9001_pbo.

INCLUDE zupdate_alv_user_command_9001.

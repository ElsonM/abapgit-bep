*&---------------------------------------------------------------------*
*&  Include           Z_ELSON_ALV_2_TOP
*&---------------------------------------------------------------------*

DATA: grid1 TYPE REF TO cl_gui_alv_grid,
      grid2 TYPE REF TO cl_gui_alv_grid.

DATA: es_row_no TYPE lvc_s_roid,
      ls_row_id TYPE lvc_s_row,
      ls_col_id TYPE lvc_s_col,
      ls_row    TYPE i,
      ls_value  TYPE c,
      ls_col    TYPE i,
      ls_row_no TYPE lvc_s_roid.

DATA: it_rows TYPE lvc_t_roid,
      wa_rows TYPE lvc_s_roid.

*TYPES: row_table TYPE TABLE OF lvc_s_roid.

*DATA it_rows TYPE row_table.
*
*DATA: BEGIN OF wa_rows,
*        row_id     TYPE int4,
*        sub_row_id TYPE int4,
*      END OF wa_rows.

DATA: t_index TYPE int4.
DATA: t_size  TYPE int4.

CLASS lcl_event_handler DEFINITION.

  PUBLIC SECTION.
    METHODS:

      "Hotspot Handler
      handle_hotspot_click FOR EVENT hotspot_click OF cl_gui_alv_grid
        IMPORTING e_row_id e_column_id es_row_no,

      "Double Click Handler
      handle_double_click FOR EVENT double_click OF cl_gui_alv_grid
        IMPORTING e_row e_column es_row_no,

      "Toolbar handler
      handle_toolbar FOR EVENT toolbar OF cl_gui_alv_grid
        IMPORTING e_object e_interactive,

      "Button press
      handle_user_command FOR EVENT user_command OF cl_gui_alv_grid
        IMPORTING e_ucomm,

      "Data changed
      handle_data_changed FOR EVENT data_changed OF cl_gui_alv_grid
        IMPORTING er_data_changed,

      "Data changed finished
      handle_data_changed_finished FOR EVENT data_changed OF cl_gui_alv_grid.

ENDCLASS.                    "lcl_event_handler DEFINITION


CLASS lcl_event_handler IMPLEMENTATION.

*Handle Hotspot Click
  METHOD handle_hotspot_click .
    PERFORM mouse_click
      USING e_row_id
            e_column_id.
    CALL METHOD grid1->get_current_cell
      IMPORTING
        e_row     = ls_row
        e_value   = ls_value
        e_col     = ls_col
        es_row_id = ls_row_id
        es_col_id = ls_col_id
        es_row_no = es_row_no.


    CALL METHOD grid1->refresh_table_display.
    CALL METHOD grid1->set_current_cell_via_id
      EXPORTING
        is_column_id = e_column_id
        is_row_no    = es_row_no.

  ENDMETHOD.                    "lcl_event_handler

*Handle Double Click
  METHOD  handle_double_click.

    PERFORM double_click
       USING e_row
       e_column.

    CALL METHOD grid1->get_current_cell
      IMPORTING
        e_row     = ls_row
        e_value   = ls_value
        e_col     = ls_col
        es_row_id = ls_row_id
        es_col_id = ls_col_id
        es_row_no = es_row_no.

    CALL METHOD grid1->refresh_table_display.

    CALL METHOD grid1->set_current_cell_via_id
      EXPORTING
        is_column_id = ls_col_id
        is_row_no    = es_row_no.



  ENDMETHOD.

  METHOD handle_toolbar.

    DATA: ls_toolbar TYPE stb_button.

    "Append a separator to normal toolbar
    CLEAR ls_toolbar.
    MOVE 3 TO ls_toolbar-butn_type.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    "Append an icon for your function
    CLEAR ls_toolbar.
    MOVE 'FUNC'               TO ls_toolbar-function.
    MOVE icon_railway         TO ls_toolbar-icon.
    MOVE 'Your Function'      TO ls_toolbar-quickinfo.
    MOVE 'Your user function' TO ls_toolbar-text.
    MOVE ' '                  TO ls_toolbar-disabled.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    "Select All Rows
    MOVE 'SELE'               TO ls_toolbar-function.
    MOVE icon_select_all      TO ls_toolbar-icon.
    MOVE 'Select all'         TO ls_toolbar-quickinfo.
    MOVE 'Select entire Grid' TO ls_toolbar-text.
    MOVE ' '                  TO ls_toolbar-disabled.
    APPEND ls_toolbar TO e_object->mt_toolbar.

    "Deselect all Rows.
    MOVE 'DSEL'                 TO ls_toolbar-function.
    MOVE icon_deselect_all      TO ls_toolbar-icon.
    MOVE 'Deselect all'         TO ls_toolbar-quickinfo.
    MOVE 'Deselect entire Grid' TO ls_toolbar-text.
    MOVE ' ' TO ls_toolbar-disabled.
    APPEND ls_toolbar TO e_object->mt_toolbar.

  ENDMETHOD.

  METHOD handle_user_command.

    CASE e_ucomm.
      WHEN 'FUNC'.    "Your button
        "Perform what you need to do.
      WHEN 'SELE'.
        PERFORM select_all_rows.
      WHEN 'DSEL'.
        PERFORM deselect_all_rows.
      WHEN OTHERS.
    ENDCASE.

  ENDMETHOD.

  METHOD handle_data_changed.
    PERFORM data_changed USING er_data_changed.

  ENDMETHOD.                    "data_changed

  METHOD handle_data_changed_finished.
    PERFORM data_changed_finished.
  ENDMETHOD.                    "data_changed_finished

ENDCLASS.

* Define any structure
TYPES: BEGIN OF s_elements,
         vbeln  TYPE vapma-vbeln,
         posnr  TYPE vapma-posnr,
         matnr  TYPE vapma-matnr,
         kunnr  TYPE vapma-kunnr,
         werks  TYPE vapma-werks,
         vkorg  TYPE vapma-vkorg,
         vkbur  TYPE vapma-vkbur,
         status TYPE c,
       END OF  s_elements.

DATA: wa_elements TYPE s_elements.

DATA: ord_nr TYPE vapma-vbeln,
      mat_nr TYPE vapma-matnr,
      cus_nr TYPE vapma-kunnr.

DATA lr_rtti_struc TYPE REF TO cl_abap_structdescr .

DATA: zog          LIKE LINE OF  lr_rtti_struc->components,
      zogt         LIKE TABLE OF zog,

      wa_it_fldcat TYPE lvc_s_fcat,
      it_fldcat    TYPE lvc_t_fcat,

      dy_line      TYPE REF TO data,
      dy_table     TYPE REF TO data.

DATA: dref TYPE REF TO data.

FIELD-SYMBOLS: <fs>        TYPE any,
               <dyn_table> TYPE  STANDARD TABLE,
               <dyn_wa>.

DATA: grid_container1 TYPE REF TO cl_gui_custom_container,
      grid_container2 TYPE REF TO cl_gui_custom_container.

DATA: g_handler TYPE REF TO lcl_event_handler. "handler

DATA: ok_code TYPE sy-ucomm.
DATA: struct_grid_lset TYPE lvc_s_layo.

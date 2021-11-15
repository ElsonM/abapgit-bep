*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_23
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_23.

TABLES: ekko.

SELECT-OPTIONS: s_ebeln FOR ekko-ebeln. "PO number input

TYPES: BEGIN OF ty_ekpo, "User defined types
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         matnr TYPE ekpo-matnr,
         bukrs TYPE ekpo-bukrs,
         menge TYPE ekpo-menge,
       END OF ty_ekpo.

DATA: it_ekpo TYPE TABLE OF ty_ekpo,              "Internal table
      wa_ekpo TYPE          ty_ekpo.              "Work area

DATA: lr_alv         TYPE REF TO cl_salv_table,            "ALV reference
      lo_aggrs       TYPE REF TO cl_salv_aggregations,     "ALV aggregation
      lr_sort        TYPE REF TO cl_salv_sorts,            "ALV sorts
      lr_sort_column TYPE REF TO cl_salv_sort,             "Column sort
      lr_header      TYPE REF TO cl_salv_form_element,
      lr_grid_layout TYPE REF TO cl_salv_form_layout_grid,
      lr_label       TYPE REF TO cl_salv_form_label,
      lr_text        TYPE REF TO cl_salv_form_text,
      lr_footer      TYPE REF TO cl_salv_form_header_info.

DATA: l_text TYPE string,
      lv_cnt TYPE i.

START-OF-SELECTION.

  SELECT ebeln ebelp matnr bukrs menge
    FROM ekpo INTO TABLE it_ekpo WHERE ebeln IN s_ebeln. "Get PO data

  DESCRIBE TABLE it_ekpo LINES lv_cnt.

  CALL METHOD cl_salv_table=>factory "Load factory instance
    IMPORTING
      r_salv_table = lr_alv
    CHANGING
      t_table      = it_ekpo.

  lo_aggrs = lr_alv->get_aggregations( ). "Get aggregations

* Add total for column MENGE
  TRY.
      CALL METHOD lo_aggrs->add_aggregation             " Add aggregation
        EXPORTING
          columnname  = 'MENGE'                         " Aggregation column name
          aggregation = if_salv_c_aggregation=>total.   " Aggregation type
    CATCH cx_salv_data_error.                           " #EC NO_HANDLER
    CATCH cx_salv_not_found.                            " #EC NO_HANDLER
    CATCH cx_salv_existing.                             " #EC NO_HANDLER
  ENDTRY.

  CALL METHOD lr_alv->get_sorts "Get sorts
    RECEIVING
      value = lr_sort.

  CALL METHOD lr_sort->add_sort "Add column sort
    EXPORTING
      columnname = 'EBELN' "Sort column always keyfield
    RECEIVING
      value      = lr_sort_column.

  CALL METHOD lr_sort_column->set_subtotal "Add subtotal
    EXPORTING
      value = if_salv_c_bool_sap=>true.

  CREATE OBJECT lr_grid_layout.
  l_text = 'Purchase Order Report'.

  lr_grid_layout->create_header_information(
    row = 1
    column = 3
    text = l_text
    tooltip = l_text ).

  lr_grid_layout->add_row( ).

  lr_label = lr_grid_layout->create_label(
    row     = 2
    column  = 1
    text    = 'Number of records found: '
    tooltip = 'Number of records found for your query' ).

  lr_text = lr_grid_layout->create_text(
    row     = 2
    column  = 2
    text    = lv_cnt
    tooltip = lv_cnt ).

  lr_label->set_label_for( lr_text ).

  lr_label = lr_grid_layout->create_label(
    row    = 3
    column = 1
    text    = 'Date : '
    tooltip = 'Date' ).
  l_text = sy-datum.

  lr_text = lr_grid_layout->create_text(
    row    = 3
    column = 2
    text    = l_text
    tooltip = l_text ).

  lr_label->set_label_for( lr_text ).

  lr_header = lr_grid_layout.

  CALL METHOD lr_alv->set_top_of_list
    EXPORTING
      value = lr_header.

  CLEAR l_text.
  l_text = 'End of List as Footer'.
  CREATE OBJECT lr_footer
    EXPORTING
      text    = l_text
      tooltip = l_text.
  lr_alv->set_end_of_list( lr_footer ).

  lr_alv->display( ). "Display ALV

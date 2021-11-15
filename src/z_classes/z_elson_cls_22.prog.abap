*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_22
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_22.
CLASS lcl_handle_events DEFINITION DEFERRED. "Class definition deferred

TYPES: BEGIN OF ty_mara,                     "MARA internal table
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         mbrsh TYPE mara-mbrsh,
         matkl TYPE mara-matkl,
         meins TYPE mara-meins,
       END OF ty_mara.

DATA: it_mara TYPE TABLE OF ty_mara,
      wa_mara TYPE          ty_mara.

DATA: lr_alv     TYPE REF TO cl_salv_table.         "SALV table instance
DATA: lr_columns TYPE REF TO cl_salv_columns_table. "Columns instance
DATA: lr_col     TYPE REF TO cl_salv_column_table.  "Column  instance
DATA: lr_events  TYPE REF TO cl_salv_events_table.  "Events instance
DATA: gr_events  TYPE REF TO lcl_handle_events.     "Instance of local class

SELECT matnr mtart mbrsh matkl meins FROM mara INTO TABLE it_mara UP TO 50 ROWS. "Fetch data

CALL METHOD cl_salv_table=>factory "Get SALV factory instance
  IMPORTING
    r_salv_table = lr_alv
  CHANGING
    t_table      = it_mara.

* Get ALV columns
CALL METHOD lr_alv->get_columns  "Get all columns
  RECEIVING
    value = lr_columns.
IF lr_columns IS NOT INITIAL.
  TRY.
      lr_col ?= lr_columns->get_column( 'MATNR' ). "Get MATNR columns to insert hotspot
    CATCH cx_salv_not_found.
  ENDTRY.
* Set the Hotspot for MATNR Column
  TRY.
      CALL METHOD lr_col->set_cell_type "Set cell type hotspot
        EXPORTING
          value = if_salv_c_cell_type=>hotspot.
    CATCH cx_salv_data_error.
  ENDTRY.
ENDIF.

CLASS lcl_handle_events DEFINITION.
  PUBLIC SECTION.
    METHODS: on_line_click FOR EVENT link_click OF cl_salv_events_table
      IMPORTING row column. "Event handler method, imports row and column of clicked value
ENDCLASS.

lr_events = lr_alv->get_event( ). "Get event
CREATE OBJECT gr_events.
SET HANDLER gr_events->on_line_click FOR lr_events. "Register event handler method

* Set standard ALV functions visible
lr_alv->set_screen_status(
  pfstatus      = 'SALV_STANDARD'
  report        = 'SALV_TEST_FUNCTIONS'
  set_functions = lr_alv->c_functions_all ).

lr_alv->display( ). "Display grid

CLASS lcl_handle_events IMPLEMENTATION.
  METHOD on_line_click. "Double click implementation
* Handle double click here
    READ TABLE it_mara INTO wa_mara INDEX row.
    IF sy-subrc EQ 0.
      SET  PARAMETER ID 'MAT'  FIELD wa_mara-matnr.
      CALL TRANSACTION  'MM03' AND SKIP FIRST SCREEN.
    ENDIF.
  ENDMETHOD.                    "on_link_click
ENDCLASS.                    "lcl_events IMPLEMENTATION

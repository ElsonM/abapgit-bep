*&---------------------------------------------------------------------*
*& Report Z08_FIELD_SYMBOL_DYNAMIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z08_field_symbol_dynamic.

CLASS lcl_event_handler DEFINITION DEFERRED.

DATA: custom_container TYPE REF TO cl_gui_custom_container,
      splitter         TYPE REF TO cl_gui_splitter_container,
      container_1      TYPE REF TO cl_gui_container,
      so_alv           TYPE REF TO cl_salv_table,
      mo_alv           TYPE REF TO cl_salv_table,
      gr_event_handler TYPE REF TO lcl_event_handler,
      gr_event         TYPE REF TO cl_salv_events_table,
      ok_code          TYPE sy-ucomm.

TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         ersda TYPE ersda,
         ernam TYPE ernam,
         laeda TYPE laeda,
         mtart TYPE mtart,
       END OF ty_mara.

DATA: it_mara  TYPE STANDARD TABLE OF ty_mara,
      gv_matnr TYPE matnr.

SELECT-OPTIONS: s_matnr FOR gv_matnr.

*&--------------------------------------------------------------*
*& Class LCL_EVENT_HANDLER
*&--------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.

  PUBLIC SECTION.
    METHODS: on_double_click FOR EVENT double_click OF
               cl_salv_events_table IMPORTING row column.

ENDCLASS. "LCL_EVENT_HANDLER

*&---------------------------------------------------------------------*
*& Class LCL_EVENT_HANDLER IMPLEMENTATION
*&---------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_double_click.

    FIELD-SYMBOLS: <field> TYPE any.

    DATA: lo_sel      TYPE REF TO cl_salv_selections,
          ls_cell     TYPE salv_s_cell,
          container_2 TYPE REF TO cl_gui_container,
          lt_mara     TYPE STANDARD TABLE OF ty_mara,
          lw_mara     TYPE ty_mara.

* Get reference to the user selection.
    lo_sel = mo_alv->get_selections( ).

* Get the value of the cell
    ls_cell = lo_sel->get_current_cell( ).

* Logic to filter records (Static)
*    IF ls_cell-columnname EQ 'MATNR'.
*
*      LOOP AT it_mara INTO lw_mara WHERE matnr EQ ls_cell-value.
*        APPEND lw_mara TO lt_mara.
*      ENDLOOP.
*
*    ELSEIF ls_cell-columnname EQ 'ERSDA'.
*
*      LOOP AT it_mara INTO lw_mara WHERE ersda EQ ls_cell-value.
*        APPEND lw_mara TO lt_mara.
*      ENDLOOP.
*
*    ELSEIF ls_cell-columnname EQ 'ERNAM'.
*
*      LOOP AT it_mara INTO lw_mara WHERE ernam EQ ls_cell-value.
*        APPEND lw_mara TO lt_mara.
*      ENDLOOP.
*
*    ELSEIF ls_cell-columnname EQ 'LAEDA'.
*
*      LOOP AT it_mara INTO lw_mara WHERE laeda EQ ls_cell-value.
*        APPEND lw_mara TO lt_mara.
*      ENDLOOP.
*
*    ELSEIF ls_cell-columnname EQ 'MTART'.
*
*      LOOP AT it_mara INTO lw_mara WHERE mtart EQ ls_cell-value.
*        APPEND lw_mara TO lt_mara.
*      ENDLOOP.
*
*    ENDIF.

* Logic to filter records (Dynamic)
    ASSIGN COMPONENT ls_cell-columnname OF STRUCTURE lw_mara
        TO <field>.

    LOOP AT it_mara INTO lw_mara.
      IF <field> IS ASSIGNED.
        IF <field> EQ ls_cell-value.
          APPEND lw_mara TO lt_mara.
        ENDIF.
      ENDIF.
    ENDLOOP.

    CALL METHOD splitter->get_container
      EXPORTING
        row       = 2
        column    = 1
      RECEIVING
        container = container_2.

    TRY.
        IF so_alv IS BOUND.
          so_alv->set_data( CHANGING t_table = lt_mara ).
        ELSE.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              list_display = if_salv_c_bool_sap=>false
              r_container  = container_2
            IMPORTING
              r_salv_table = so_alv
            CHANGING
              t_table      = lt_mara.
        ENDIF.
      CATCH cx_salv_no_new_data_allowed.
      CATCH cx_salv_msg .
    ENDTRY.

    so_alv->display( ).

  ENDMETHOD. "on_double_click

ENDCLASS. "lcl_event_handler

START-OF-SELECTION.
  PERFORM fill_table.
  CALL SCREEN 100.

*&--------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&--------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'GUI_0100'.

* Create Container Object
  CREATE OBJECT custom_container
    EXPORTING
      container_name = 'CONTAINER'.

* Create splitter Object
  CREATE OBJECT splitter
    EXPORTING
      parent  = custom_container
      rows    = 2
      columns = 1.

* Split the container
  CALL METHOD splitter->get_container
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = container_1.

* Get ALV Object reference
  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
          r_container  = container_1
        IMPORTING
          r_salv_table = mo_alv
        CHANGING
          t_table      = it_mara.
    CATCH cx_salv_msg .
  ENDTRY.

* Set the event handler here
  gr_event = mo_alv->get_event( ).
  CREATE OBJECT gr_event_handler.
  SET HANDLER gr_event_handler->on_double_click FOR gr_event.

* Display Output
  mo_alv->display( ).

ENDMODULE. " STATUS_100 OUTPUT

*&--------------------------------------------------------------*
*& Form FILL_TABLE
*&--------------------------------------------------------------*
FORM fill_table.

  SELECT matnr ersda ernam laeda mtart FROM mara
    INTO TABLE it_mara
      WHERE matnr IN s_matnr.

ENDFORM. " FILL_TABLE

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

  CASE ok_code.
    WHEN 'BACK'.
      LEAVE TO SCREEN 0.
  ENDCASE.

ENDMODULE.

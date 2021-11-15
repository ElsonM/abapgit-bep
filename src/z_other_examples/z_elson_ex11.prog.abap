*&---------------------------------------------------------------------*
*& Report Z_ELSON_EX11 - SALV Table, editable checkbox
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_ex11.

*----------------------------------------------------------------------*
* CLASS lcl_report DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_report DEFINITION.

  PUBLIC SECTION.

*   Final output table
    TYPES: BEGIN OF ty_vbak,
             vbeln TYPE vbak-vbeln,
             erdat TYPE vbak-erdat,
             auart TYPE vbak-auart,
             kunnr TYPE vbak-kunnr,
             check TYPE flag,
           END OF ty_vbak.

    DATA: t_vbak TYPE STANDARD TABLE OF ty_vbak.

*   ALV reference
    DATA: o_alv TYPE REF TO cl_salv_table.
*
    METHODS:

*     Data selection
      get_data,

*     Generating output
      generate_output.

ENDCLASS.                    "lcl_report DEFINITION

*----------------------------------------------------------------------*
* CLASS lcl_event_handler DEFINITION
*----------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.

  PUBLIC SECTION.
    METHODS:
      on_link_click FOR EVENT link_click OF cl_salv_events_table
        IMPORTING row column.

ENDCLASS.                    "lcl_event_handler DEFINITION

START-OF-SELECTION.

  DATA: lo_report TYPE REF TO lcl_report.
  CREATE OBJECT lo_report.

  lo_report->get_data( ).
  lo_report->generate_output( ).

*----------------------------------------------------------------------*
*       CLASS lcl_report IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_report IMPLEMENTATION.

  METHOD get_data.

*   data selection
    SELECT vbeln erdat auart kunnr INTO TABLE t_vbak
      FROM vbak UP TO 20 ROWS.

  ENDMETHOD.                    "get_data

  METHOD generate_output.

* exception class
    DATA: lx_msg TYPE REF TO cx_salv_msg.

    TRY.
        cl_salv_table=>factory(
          IMPORTING
            r_salv_table = o_alv
          CHANGING
            t_table      = t_vbak ).
      CATCH cx_salv_msg INTO lx_msg.
    ENDTRY.

*   Get all the Columns
    DATA: lo_cols TYPE REF TO cl_salv_columns.
    lo_cols = o_alv->get_columns( ).

*   set the Column optimization
    lo_cols->set_optimize( 'X' ).

*...Process individual columns
    DATA: lo_column TYPE REF TO cl_salv_column_list.

*   Change the properties of the Column CHECK
    TRY.
        lo_column ?= lo_cols->get_column( 'CHECK' ).
        lo_column->set_cell_type( if_salv_c_cell_type=>checkbox_hotspot ).
        lo_column->set_output_length( 10 ).
      CATCH cx_salv_not_found.                          "#EC NO_HANDLER
    ENDTRY.

*   Get the event object
    DATA: lo_events TYPE REF TO cl_salv_events_table.
    lo_events = o_alv->get_event( ).

*   Instantiate the event handler object
    DATA: lo_event_handler TYPE REF TO lcl_event_handler.
    CREATE OBJECT lo_event_handler.

*   event handler
    SET HANDLER lo_event_handler->on_link_click FOR lo_events.

*   Displaying the ALV
*   Here we will call the DISPLAY method to get the output on the screen
    o_alv->display( ).

  ENDMETHOD.                    "generate_output
*
ENDCLASS.                    "lcl_report IMPLEMENTATION

*----------------------------------------------------------------------*
* CLASS lcl_event_handler IMPLEMENTATION
*----------------------------------------------------------------------*
CLASS lcl_event_handler IMPLEMENTATION.

  METHOD on_link_click.

*   Get the value of the checkbox and set the value accordingly
*   Refresh the table
    FIELD-SYMBOLS: <lfa_data> LIKE LINE OF lo_report->t_vbak.
    READ TABLE lo_report->t_vbak ASSIGNING <lfa_data> INDEX row.
    CHECK sy-subrc IS INITIAL.
    IF <lfa_data>-check IS INITIAL.
      <lfa_data>-check = 'X'.
    ELSE.
      CLEAR <lfa_data>-check.
    ENDIF.
    lo_report->o_alv->refresh( ).

  ENDMETHOD.                    "on_link_click

ENDCLASS.                    "lcl_event_handler IMPLEMENTATION

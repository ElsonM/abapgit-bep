*&---------------------------------------------------------------------*
*& Report Z_COMP_ABAP_3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_comp_abap_3.

CLASS cl_events_demo DEFINITION.
  PUBLIC SECTION.
    EVENTS double_click
      EXPORTING
        VALUE(column) TYPE i
        VALUE(row)    TYPE i.
    CLASS-EVENTS right_click.
    METHODS trigger_event.
    METHODS on_double_click FOR EVENT double_click OF cl_events_demo
      IMPORTING
          column
          row.
    METHODS on_right_click FOR EVENT right_click OF cl_events_demo.
ENDCLASS.
CLASS cl_events_demo IMPLEMENTATION.
  METHOD trigger_event.
    RAISE EVENT double_click
      EXPORTING
        column = 4
        row    = 5.
    RAISE EVENT right_click.
  ENDMETHOD.

  METHOD on_double_click.
    WRITE: / 'Double click event triggered at column', column,
             'and row', row.
  ENDMETHOD.

  METHOD on_right_click.
    WRITE: / 'Right click event triggered'.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  DATA(oref) = NEW cl_events_demo( ).
  SET HANDLER oref->on_double_click FOR oref. "handler for instance event
  SET HANDLER oref->on_right_click.           "handler for static event
  oref->trigger_event( ).

*&---------------------------------------------------------------------*
*& Report Z_COMP_ABAP_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_comp_abap_1.

CLASS printer DEFINITION.
  PUBLIC SECTION.
    METHODS print.
ENDCLASS.

CLASS printer IMPLEMENTATION.
  METHOD print.
    WRITE / 'Document printed.'.
  ENDMETHOD.
ENDCLASS.

CLASS printer_with_counter DEFINITION INHERITING FROM printer.
  PUBLIC SECTION.
    METHODS constructor IMPORTING count TYPE i.
    METHODS print REDEFINITION.

  PROTECTED SECTION.
    DATA counter TYPE i.
ENDCLASS.

CLASS printer_with_counter IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    counter = count.
  ENDMETHOD.

  METHOD print.
    counter = counter + 1.
    super->print( ).
  ENDMETHOD.
ENDCLASS.

CLASS multi_copy_printer DEFINITION INHERITING FROM printer_with_counter.
  PUBLIC SECTION.
    METHODS set_copies IMPORTING copies TYPE i.
    METHODS print REDEFINITION.

  PRIVATE SECTION.
    DATA copies TYPE i.
ENDCLASS.

CLASS multi_copy_printer IMPLEMENTATION.
  METHOD set_copies.
    me->copies = copies.
  ENDMETHOD.

  METHOD print.
    DO copies TIMES.
      super->print( ).
    ENDDO.
  ENDMETHOD.

ENDCLASS.

START-OF-SELECTION.
  DATA(oref) = NEW multi_copy_printer( count = 0 ).
  oref->set_copies( 5 ).
  oref->print( ).

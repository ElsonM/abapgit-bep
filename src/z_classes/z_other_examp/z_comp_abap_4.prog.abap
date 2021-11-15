*&---------------------------------------------------------------------*
*& Report Z_COMP_ABAP_4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_comp_abap_4.

CLASS cl_parent DEFINITION.
  PUBLIC SECTION.
    METHODS constructor.
  PROTECTED SECTION.
    METHODS meth.
ENDCLASS.
CLASS cl_parent IMPLEMENTATION.
  METHOD constructor.
    me->meth( ).
  ENDMETHOD.
  METHOD meth.
    WRITE / 'I''m in parent class'.
  ENDMETHOD.
ENDCLASS.

CLASS cl_child DEFINITION INHERITING FROM cl_parent.
  PUBLIC SECTION.
    METHODS constructor.
  PROTECTED SECTION.
    METHODS meth REDEFINITION.
ENDCLASS.
CLASS cl_child IMPLEMENTATION.
  METHOD constructor.
    super->constructor( ).
    me->meth( ).
  ENDMETHOD.
  METHOD meth.
    WRITE / 'I''m in child class'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA(child) = NEW cl_child( ).

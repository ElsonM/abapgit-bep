*&---------------------------------------------------------------------*
*& Report Z_COMP_ABAP_5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_comp_abap_5.

CLASS cl_parent DEFINITION.
  PUBLIC SECTION.
    METHODS meth1.
    METHODS meth2.
ENDCLASS.
CLASS cl_parent IMPLEMENTATION.
  METHOD meth1.
    WRITE / 'In method 1 of parent'.
  ENDMETHOD.
  METHOD meth2.
    WRITE / 'In method 2 of parent'.
  ENDMETHOD.
ENDCLASS.

CLASS cl_child DEFINITION INHERITING FROM cl_parent.
  PUBLIC SECTION.
    METHODS meth2 REDEFINITION.
    METHODS meth3.
ENDCLASS.
CLASS cl_child IMPLEMENTATION.
  METHOD meth2.
    WRITE / 'In method 2 of child'.
  ENDMETHOD.
  METHOD meth3.
    WRITE / 'In method 3 of child'.
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA(parent) = NEW cl_parent( ).
  DATA(child) = NEW cl_child( ).
  parent->meth2( ).
  parent = child.
  parent->meth2( ).

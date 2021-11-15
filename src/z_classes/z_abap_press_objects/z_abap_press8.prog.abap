*&---------------------------------------------------------------------*
*& Report Z_ABAP_PRESS8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap_press8.

CLASS lcl_parent DEFINITION.
  PUBLIC SECTION.
    METHODS: a,
             b.
ENDCLASS.

CLASS lcl_child DEFINITION
                  INHERITING FROM lcl_parent.
  PUBLIC SECTION.
    METHODS: c.
ENDCLASS.

*** 1. Method
*DATA: lo_parent TYPE REF TO lcl_parent,
*      lo_child  TYPE REF TO lcl_child.
*
*CREATE OBJECT lo_child.

"a > First option
*CREATE OBJECT lo_parent.
*lo_parent = lo_child.     "Narrowing Cast

"b > Second option
*CREATE OBJECT lo_parent TYPE lcl_child. "Narrowing Cast

*lo_child ?= lo_parent. "Widening Cast

*** 2. Method
DATA(lo_child) = NEW lcl_child( ).
DATA(lo_parent) = CAST lcl_parent( lo_child ). "Narrowing Cast

lo_child = CAST lcl_child( lo_parent ). "Widening Cast

CLASS lcl_parent IMPLEMENTATION.
  METHOD a.
    WRITE:/ 'In method a.'.
  ENDMETHOD.

  METHOD b.
    WRITE:/ 'In method b.'.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_child IMPLEMENTATION.
  METHOD c.
    WRITE:/ 'In method c.'.
  ENDMETHOD.
ENDCLASS.

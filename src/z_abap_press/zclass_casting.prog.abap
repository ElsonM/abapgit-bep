*&---------------------------------------------------------------------*
*& Report ZCLASS_CASTING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zclass_casting.

CLASS cl_parent DEFINITION.
  PUBLIC SECTION.
    METHODS meth1.
    METHODS meth2.
ENDCLASS.

CLASS cl_parent IMPLEMENTATION.
  METHOD meth1.
    WRITE 'In method1 of parent'.
  ENDMETHOD.

  METHOD meth2.
    WRITE 'In method2 of parent'.
  ENDMETHOD.
ENDCLASS.

CLASS cl_child1 DEFINITION INHERITING FROM cl_parent.
  PUBLIC SECTION.
    METHODS meth2 REDEFINITION.
    METHODS meth3.
ENDCLASS.

CLASS cl_child1 IMPLEMENTATION.
  METHOD meth2.
    WRITE 'In method2 of child1'.
  ENDMETHOD.

  METHOD meth3.
    WRITE 'In method3 of child1'.
  ENDMETHOD.
ENDCLASS.

CLASS cl_child2 DEFINITION INHERITING FROM cl_child1.
  PUBLIC SECTION.
    METHODS meth2 REDEFINITION.
    METHODS meth3 REDEFINITION.
    METHODS meth4.
ENDCLASS.

CLASS cl_child2 IMPLEMENTATION.
  METHOD meth2.
    WRITE 'In method2 of child2'.
  ENDMETHOD.

  METHOD meth3.
    WRITE 'In method3 of child2'.
  ENDMETHOD.

  METHOD meth4.
    WRITE 'In method4 of child2'.
  ENDMETHOD.
ENDCLASS.

DATA parent TYPE REF TO cl_parent.
DATA child1 TYPE REF TO cl_child1.
DATA child2 TYPE REF TO cl_child2.

START-OF-SELECTION.

  CREATE OBJECT parent.
  CREATE OBJECT child1.
  CREATE OBJECT child2.

  parent = child2.
  child1 ?= parent.

  child1->meth2( ).

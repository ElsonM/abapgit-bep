*&---------------------------------------------------------------------*
*& Report Z_ABAP101_035
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_035.

CONSTANTS: BEGIN OF c_primitives,
             char   TYPE c LENGTH 4 VALUE 'CHAR',
             int    TYPE i          VALUE 101,
             date   TYPE d          VALUE '20141225',
             time   TYPE t          VALUE '112359',
             string TYPE string     VALUE 'STRING',
           END OF c_primitives.

*&---------------------------------------------------------------------*
*& Report Z_ABAP101_083
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_083.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME.

PARAMETER p_text TYPE string.
PARAMETER p_char TYPE c LENGTH 10.

SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME.

PARAMETER p_int TYPE i.
PARAMETER p_p   TYPE p LENGTH 10.

SELECTION-SCREEN END OF BLOCK b02.

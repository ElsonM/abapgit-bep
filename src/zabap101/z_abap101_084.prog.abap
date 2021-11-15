*&---------------------------------------------------------------------*
*& Report Z_ABAP101_084
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_084.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-b01. " Define in text
                                                               " elements
PARAMETER p_text TYPE string.      " Define in text elements
PARAMETER p_char TYPE c LENGTH 10. " Define in text elements

SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE TEXT-b02. " Define in text
                                                               " elements
PARAMETER p_int TYPE i.           " Define in text elements
PARAMETER p_p   TYPE p LENGTH 10. " Define in text elements
SELECTION-SCREEN END OF BLOCK b02.

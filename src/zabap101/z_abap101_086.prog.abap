*&---------------------------------------------------------------------*
*& Report Z_ABAP101_086
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_086.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME.

SELECTION-SCREEN BEGIN OF LINE.
POSITION 1.
PARAMETERS p_check AS CHECKBOX.
SELECTION-SCREEN COMMENT 3(4) TEXT-001 FOR FIELD p_text.
POSITION 10.
PARAMETERS p_text TYPE string.
SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b01.

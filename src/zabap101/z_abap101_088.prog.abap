*&---------------------------------------------------------------------*
*& Report Z_ABAP101_088
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_088.

SELECTION-SCREEN BEGIN OF SCREEN 1 AS SUBSCREEN.
PARAMETER p_1 TYPE string.
SELECTION-SCREEN END OF SCREEN 1.

SELECTION-SCREEN BEGIN OF SCREEN 2 AS SUBSCREEN.
PARAMETER p_2 TYPE d.
SELECTION-SCREEN END OF SCREEN 2.

SELECTION-SCREEN BEGIN OF SCREEN 3 AS SUBSCREEN.
PARAMETER p_3 TYPE t.
SELECTION-SCREEN END OF SCREEN 3.

SELECTION-SCREEN: BEGIN OF TABBED BLOCK tb FOR 10 LINES,
                    TAB (10) tab1 USER-COMMAND tab1_pressed DEFAULT SCREEN 1,
                    TAB (10) tab2 USER-COMMAND tab2_pressed DEFAULT SCREEN 2,
                    TAB (10) tab3 USER-COMMAND tab3_pressed DEFAULT PROGRAM z_abap101_088 SCREEN 3,
                  END OF BLOCK tb.

INITIALIZATION.
  tab1 = 'String'.
  tab2 = 'Date'.
  tab3 = 'Time'.

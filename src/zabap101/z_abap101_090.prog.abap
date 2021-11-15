*&---------------------------------------------------------------------*
*& Report Z_ABAP101_090
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_090.

DATA v_luck      TYPE i.
DATA v_bad_luck  TYPE i.
DATA v_favourite TYPE p LENGTH 10.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE v_person.

  PARAMETERS: p_name TYPE string LOWER CASE,
              p_born TYPE d,
              p_last TYPE t.

  SELECTION-SCREEN SKIP 1.

  PARAMETERS: p_male   RADIOBUTTON GROUP gend,
              p_female RADIOBUTTON GROUP gend.

SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK b02 WITH FRAME TITLE v_autho.

  PARAMETER p_admin AS CHECKBOX.
  PARAMETER p_user  AS CHECKBOX.
  PARAMETER p_guest AS CHECKBOX.

SELECTION-SCREEN END OF BLOCK b02.

SELECTION-SCREEN SKIP 1.

SELECTION-SCREEN BEGIN OF BLOCK b03 WITH FRAME TITLE v_number.

  SELECT-OPTIONS: s_luck FOR v_luck,
                  s_bad  FOR v_bad_luck  NO INTERVALS,
                  s_favo FOR v_favourite NO-EXTENSION.

SELECTION-SCREEN END OF BLOCK b03.

INITIALIZATION.
  v_person = 'Personal Data'.
  v_autho  = 'Authorization'.
  v_number = 'Numbers'.

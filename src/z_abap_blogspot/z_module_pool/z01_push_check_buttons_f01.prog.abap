*&---------------------------------------------------------------------*
*& Include Z01_PUSH_CHECK_BUTTONS_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*& Form LEAVE1
*&---------------------------------------------------------------------*
*  text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM leave1.

  LEAVE PROGRAM.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form DISPLAY
*&---------------------------------------------------------------------*
*  text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display.

  IF kna1-kunnr IS NOT INITIAL.

    SELECT SINGLE kunnr land1 name1 ort01
      FROM kna1 INTO wa_kna1
      WHERE kunnr = kna1-kunnr.

    IF sy-subrc = 0.
      CALL SCREEN 9002.
    ELSE.
      MESSAGE 'Customer Number doesn''t Exist' TYPE 'I'.
    ENDIF.

  ELSE.

    MESSAGE 'Please enter Customer Number' TYPE 'I'.

  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form CLEAR
*&---------------------------------------------------------------------*
*  text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM clear.

  CLEAR: kna1-kunnr, country, name, city.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form LEAVE2
*&---------------------------------------------------------------------*
*  text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM leave2.

  CLEAR: kna1-land1, kna1-name1, kna1-ort01.
  LEAVE TO SCREEN 0.

ENDFORM.

*&---------------------------------------------------------------------*
*& Form PROCESS_LIST
*&---------------------------------------------------------------------*
*  text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM process_list.

  IF name = 'X'.
    kna1-name1 = wa_kna1-name1.
  ENDIF.

  IF country = 'X'.
    kna1-land1 = wa_kna1-land1.
  ENDIF.

  IF city = 'X'.
    kna1-ort01 = wa_kna1-ort01.
  ENDIF.

ENDFORM.

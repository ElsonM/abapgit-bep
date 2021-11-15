*&---------------------------------------------------------------------*
*& Report Z_ELSON_T20_ADV_SCREEN
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t20_adv_screen.

TABLES: pgmi, sscrfields.

DATA: BEGIN OF ipgmi OCCURS 0,
        werks TYPE pgmi-werks,
        prgrp TYPE pgmi-prgrp,
        nrmit TYPE pgmi-nrmit,
      END OF ipgmi.
DATA: wpgmi LIKE LINE OF ipgmi.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-t01.
"Select option with obligatory parameters
SELECT-OPTIONS: prgrp FOR pgmi-prgrp OBLIGATORY MODIF ID ob.
PARAMETERS: werks LIKE marc-werks DEFAULT '2000',
            "Define radionbuttons
            s1    RADIOBUTTON GROUP gr1,
            s2    RADIOBUTTON GROUP gr1,
            s3    RADIOBUTTON GROUP gr1.
SELECTION-SCREEN: END OF BLOCK b1.

SELECTION-SCREEN BEGIN OF BLOCK b2 WITH FRAME TITLE TEXT-t02.
"Define radionbuttons
PARAMETERS: s4 RADIOBUTTON GROUP gr2,
            s5 RADIOBUTTON GROUP gr2.
SELECTION-SCREEN END OF BLOCK b2.

SELECTION-SCREEN BEGIN OF BLOCK b3 WITH FRAME TITLE TEXT-t03.
"Define radionbuttons
PARAMETERS: s6 RADIOBUTTON GROUP gr3,
            s7 RADIOBUTTON GROUP gr3.

"Define checkboxes
SELECTION-SCREEN BEGIN OF LINE.
PARAMETERS p_ch1 AS CHECKBOX MODIF ID sl.

"Define screen text
SELECTION-SCREEN COMMENT 3(20) TEXT-001 MODIF ID sl.

PARAMETERS p_ch2 AS CHECKBOX MODIF ID sl.
SELECTION-SCREEN COMMENT 27(20) TEXT-002 MODIF ID sl.

PARAMETERS p_ch3 AS CHECKBOX MODIF ID sl.
SELECTION-SCREEN COMMENT 51(20) TEXT-003 MODIF ID sl.

SELECTION-SCREEN END OF LINE.

SELECTION-SCREEN END OF BLOCK b3.

TYPE-POOLS icon.
DATA functxt TYPE smp_dyntxt.

"Add buttons to screen
SELECTION-SCREEN: FUNCTION KEY 1,
                  FUNCTION KEY 2.

INITIALIZATION.
  s7 = 'X'.
  functxt-icon_id = icon_alarm.
  functxt-quickinfo = 'Alarm'.
  functxt-icon_text = 'Alarm'.
  sscrfields-functxt_01 = functxt.
  sscrfields-functxt_02 = 'Button 2'.

AT SELECTION-SCREEN.
  CASE sscrfields-ucomm.
    WHEN 'FC01'.
      MESSAGE 'Alarm Button' TYPE 'I'.
    WHEN 'FC02'.
      MESSAGE 'Button 2' TYPE 'I'.
    WHEN OTHERS.
  ENDCASE.

AT SELECTION-SCREEN OUTPUT.
  PERFORM checkradio.

START-OF-SELECTION.
  PERFORM getdata.

*&---------------------------------------------------------------------*
*&      Form  CHECKRADIO
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM checkradio .
  LOOP AT SCREEN.

    "Hide or Show an Object
    IF s6 = 'X'.
      IF screen-group1 = 'SL'.
        screen-active = 1.
      ENDIF.
    ELSEIF s7 = 'X'.
      IF screen-group1 = 'SL'.
        screen-active = 0.
      ENDIF.
    ENDIF.

    "Display blue colored parameters
    IF screen-group1 = 'OB'.
      screen-intensified = '1'.
    ENDIF.

    "Disable an object
    IF screen-name = 'S5'.
      screen-input = 0.
    ENDIF.

    MODIFY SCREEN.

  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GETDATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM getdata .
  " Add code to select data
ENDFORM.

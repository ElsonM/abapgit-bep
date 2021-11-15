*&---------------------------------------------------------------------*
*& Report Z01_CHECKBUTTONS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_checkbuttons.

*----------------------------------------------------------------------*
* Constants
*----------------------------------------------------------------------*
CONSTANTS: c_title(10) VALUE 'Options'.

*----------------------------------------------------------------------*
* Selection Screen
*----------------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE v_name.
SELECTION-SCREEN: SKIP.
PARAMETERS: cb_all AS CHECKBOX USER-COMMAND uc.
SELECTION-SCREEN: SKIP.
PARAMETERS: cb_a AS CHECKBOX,
            cb_b AS CHECKBOX,
            cb_c AS CHECKBOX,
            cb_d AS CHECKBOX,
            cb_e AS CHECKBOX.
SELECTION-SCREEN: END OF BLOCK b1.

*----------------------------------------------------------------------*
* At Selection Screen Event
*----------------------------------------------------------------------*
AT SELECTION-SCREEN.
  IF sy-ucomm = 'UC'.
    IF cb_all = 'X'.
      cb_a = cb_b = cb_c = cb_d = cb_e = 'X'.
    ELSE.
      CLEAR: cb_a, cb_b, cb_c, cb_d, cb_e.
    ENDIF.
  ENDIF.

*----------------------------------------------------------------------*
* Initialization
*----------------------------------------------------------------------*
INITIALIZATION.
  v_name = c_title.

**------Declaring local structure for work area & table-----------------*
*TYPES: BEGIN OF ty_ekpo,
*         ebeln TYPE ekpo-ebeln,
*         ebelp TYPE ekpo-ebelp,
*         menge TYPE ekpo-menge,
*         meins TYPE ekpo-meins,
*         netpr TYPE ekpo-netpr,
*       END OF ty_ekpo.
*
**-----Declaration of work area & internal table------------------------*
*DATA: it_ekpo TYPE TABLE OF ty_ekpo,
*      wa_ekpo TYPE          ty_ekpo,
*      v_flag  TYPE c.
*
**----------------------------------------------------------------------*
** Initialization
**----------------------------------------------------------------------*
*INITIALIZATION.
*  v_name = c_title.
*  SELECT-OPTIONS: s_ebeln FOR wa_ekpo-ebeln.
*
**-----Event Start of Selection-----------------------------------------*
*START-OF-SELECTION.
*
*  SELECT ebeln ebelp menge meins netpr
*    FROM ekpo INTO TABLE it_ekpo
*    WHERE ebeln IN s_ebeln.
*
*  IF sy-subrc = 0.
*
*    "Table needs to be sorted.
*    "Otherwise AT NEW & AT END OF will operate data wrongly
*    SORT it_ekpo.
*    LOOP AT it_ekpo INTO wa_ekpo.
*
*      "Triggers at the first loop iteration only
*      AT FIRST.
*        WRITE:    'Purchase Order' COLOR 3,
*               20 'Item' COLOR 3,
*               35 'Quantity' COLOR 3,
*               45 'Unit' COLOR 3,
*               54 'Net Price' COLOR 3.
*        ULINE.
*      ENDAT.
*
*      "Triggers when new PO will come into the loop
*      AT NEW ebeln.
*        v_flag = 'X'.
*      ENDAT.
*
*      IF v_flag = 'X'.
*        WRITE:   / wa_ekpo-ebeln,
*                20 wa_ekpo-ebelp,
*                27 wa_ekpo-menge,
*                45 wa_ekpo-meins,
*                50 wa_ekpo-netpr.
*      ELSE.
*        WRITE: /20 wa_ekpo-ebelp,
*                27 wa_ekpo-menge,
*                45 wa_ekpo-meins,
*                50 wa_ekpo-netpr.
*      ENDIF.
*
*      "Triggers at the last occurrence of PO in the loop
*      AT END OF ebeln.
*        WRITE: /27 '=================',
*                50 '=============='.
*        SUM. "SUM adds & holds all the I/P/F data
*        "Here it holds for this control range
*
*        WRITE: / 'Sub Total: ' COLOR 5,
*                27 wa_ekpo-menge,
*                50 wa_ekpo-netpr.
*        SKIP.
*      ENDAT.
*
*      "Triggers at the last loop iteration only
*      AT LAST.
*        ULINE.
*        SUM. "SUM adds & holds all the I/P/F data
*        "Here it holds the total of loop range
*
*        WRITE: / 'Quantity & Net Price' COLOR 4,
*               / 'Grand Total: ' COLOR 4,
*               27 wa_ekpo-menge,
*               50 wa_ekpo-netpr.
*      ENDAT.
*      CLEAR: wa_ekpo, v_flag.
*    ENDLOOP.
*  ENDIF.

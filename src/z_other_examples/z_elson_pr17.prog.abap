*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR17
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_pr17.

*------Declaring local structure for work area & table-----------------*
TYPES: BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
         netpr TYPE ekpo-netpr,
       END OF ty_ekpo.

*-----Declaration of work area & internal table------------------------*
DATA: wa_ekpo TYPE ty_ekpo,
      it_ekpo TYPE TABLE OF ty_ekpo,
      v_flag  TYPE c.

*-----Event Initialization---------------------------------------------*
INITIALIZATION.
  SELECT-OPTIONS: s_ebeln FOR wa_ekpo-ebeln.

*-----Event Start of Selection-----------------------------------------*
START-OF-SELECTION.

  SELECT ebeln ebelp menge meins netpr
    FROM ekpo INTO TABLE it_ekpo
    WHERE ebeln IN s_ebeln.

  IF sy-subrc = 0.

    "Table needs to be sorted.
    "Otherwise AT NEW & AT END OF will operate data wrongly
    SORT it_ekpo.
    LOOP AT it_ekpo INTO wa_ekpo.

      "Triggers at the first loop iteration only
      AT FIRST.
        WRITE:    'Purchase Order' COLOR 3,
               20 'Item'           COLOR 3,
               35 'Quantity'       COLOR 3,
               45 'Unit'           COLOR 3,
               54 'Net Price'      COLOR 3.
        ULINE.
      ENDAT.

      "Triggers when new PO will come into the loop
      AT NEW ebeln.
        v_flag = 'X'.
      ENDAT.

      IF v_flag = 'X'.
        WRITE:  /5 wa_ekpo-ebeln,
                19 wa_ekpo-ebelp,
                27 wa_ekpo-menge,
                47 wa_ekpo-meins,
                50 wa_ekpo-netpr.
      ELSE.
        WRITE: /19 wa_ekpo-ebelp,
                27 wa_ekpo-menge,
                47 wa_ekpo-meins,
                50 wa_ekpo-netpr.
      ENDIF.

      "Triggers at the last occurrence of PO in the loop
      AT END OF ebeln.
        WRITE: /26 '=================',
                51 '============'.
        SUM. "SUM adds & holds all the I/P/F data
        "Here it holds for this control range

        WRITE:  / 'Sub Total:    ' COLOR 5,
                27 wa_ekpo-menge,
                50 wa_ekpo-netpr.
        SKIP.
      ENDAT.

      "Triggers at the last loop iteration only
      AT LAST.
        ULINE.
        SUM. "SUM adds & holds all the I/P/F data
        "Here it holds the total of loop range

        WRITE: / 'Quantity & Net Price' COLOR 4,
               / 'Grand Total: ' COLOR 4,
               27 wa_ekpo-menge,
               50 wa_ekpo-netpr.
      ENDAT.
      CLEAR: wa_ekpo, v_flag.
    ENDLOOP.
  ENDIF.

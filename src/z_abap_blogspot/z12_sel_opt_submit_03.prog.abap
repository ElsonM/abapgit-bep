*&---------------------------------------------------------------------*
*& Report Z12_SEL_OPT_SUBMIT_03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z12_sel_opt_submit_03 NO STANDARD PAGE HEADING.

TABLES ekpo.

TYPES: BEGIN OF ty_ekpo,
         ebeln TYPE ekpo-ebeln,
         ebelp TYPE ekpo-ebelp,
         menge TYPE ekpo-menge,
         meins TYPE ekpo-meins,
         netpr TYPE ekpo-netpr,
         peinh TYPE ekpo-peinh,
       END OF ty_ekpo.

DATA: wa_ekpo TYPE          ty_ekpo,
      it_ekpo TYPE TABLE OF ty_ekpo.

INITIALIZATION.
  PARAMETERS p_ebeln TYPE ekpo-ebeln.

START-OF-SELECTION.
  PERFORM get_po_item.

*&---------------------------------------------------------------------*
*&      Form  GET_PO_ITEM
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM get_po_item.
  IF p_ebeln IS NOT INITIAL.
    SELECT ebeln ebelp menge meins netpr peinh
      FROM ekpo INTO TABLE it_ekpo
      WHERE ebeln = p_ebeln.

    IF sy-subrc = 0.
      SORT it_ekpo.
      LOOP AT it_ekpo INTO wa_ekpo.
        AT FIRST.
          WRITE: /3 'Purchase Order',
                 20 'Item',
                 30 'PO Quantity',
                 44 'Unit',
                 49 'Net Price',
                 63 'Currency'.
          ULINE.
          SKIP.
        ENDAT.

        WRITE: /3 wa_ekpo-ebeln,
               20 wa_ekpo-ebelp,
               27 wa_ekpo-menge,
               44 wa_ekpo-meins,
               49 wa_ekpo-netpr,
               63 wa_ekpo-peinh.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.                    " GET_PO_ITEM

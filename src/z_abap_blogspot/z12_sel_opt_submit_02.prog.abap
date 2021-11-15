*&---------------------------------------------------------------------*
*& Report Z12_SEL_OPT_SUBMIT_02
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z12_sel_opt_submit_02 NO STANDARD PAGE HEADING.

TABLES ekko.

TYPES: BEGIN OF ty_ekko,
         ebeln TYPE ekko-ebeln,
         bukrs TYPE ekko-bukrs,
         ernam TYPE ekko-ernam,
         lifnr TYPE ekko-lifnr,
       END OF ty_ekko.

DATA: wa_ekko TYPE          ty_ekko,
      it_ekko TYPE TABLE OF ty_ekko,
      v_field TYPE          char40,
      v_value TYPE          char10.

INITIALIZATION.
  SELECT-OPTIONS s_ebeln1 FOR ekko-ebeln.

START-OF-SELECTION.
  PERFORM po_header.

AT LINE-SELECTION.
  GET CURSOR FIELD v_field VALUE v_value.
  CASE v_field.
    WHEN 'WA_EKKO-EBELN'.
      SUBMIT Z12_SEL_OPT_SUBMIT_03 WITH p_ebeln EQ v_value
        AND RETURN.
  ENDCASE.

*&---------------------------------------------------------------------*
*&      Form  PO_HEADER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM po_header.
  IF s_ebeln1[] IS NOT INITIAL.
    SELECT ebeln bukrs ernam lifnr
      FROM ekko INTO TABLE it_ekko
      WHERE ebeln IN s_ebeln1.

    IF sy-subrc = 0.
      SORT it_ekko.
      LOOP AT it_ekko INTO wa_ekko.
        AT FIRST.
          WRITE: /3 'Purchase Order',
                 20 'Company',
                 30 'Creator',
                 45 'Vendor'.
          ULINE.
          SKIP.
        ENDAT.

        WRITE: /3 wa_ekko-ebeln,
               20 wa_ekko-bukrs,
               30 wa_ekko-ernam,
               45 wa_ekko-lifnr.
      ENDLOOP.
    ENDIF.
  ENDIF.
ENDFORM.                    " PO_HEADER

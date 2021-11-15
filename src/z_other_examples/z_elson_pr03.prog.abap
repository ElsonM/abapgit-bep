*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR03
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_pr03.

*Billing document header structure
TYPES: BEGIN OF ty_vbrk,
         vbeln TYPE vbeln_vf, "Document Number
         fkdat TYPE fkdat,    "Bill Date
         netwr TYPE netwr,    "Net Value
         kunrg TYPE kunrg,    "Payer
       END OF ty_vbrk.

*Billing document item structure
TYPES: BEGIN OF ty_vbrp,
         vbeln TYPE vbeln_vf, "Document Number
         posnr TYPE posnr_vf, "Item Number
         arktx TYPE arktx,    "Description
         fkimg TYPE fkimg,    "Qty
         vrkme TYPE vrkme,    "Sales Unit
         netwr TYPE netwr_fp, "Net Value
         matnr TYPE matnr,    "Material Num
         mwsbp TYPE mwsbp,    "Tax amt
       END OF ty_vbrp.

DATA: it_vbrp TYPE TABLE OF ty_vbrp,
      it_vbrk TYPE TABLE OF ty_vbrk,
      wa_vbrk TYPE ty_vbrk,
      wa_vbrp TYPE ty_vbrp.

*Selection screen declaration for user selection criteria
SELECT-OPTIONS: s_vbeln FOR wa_vbrp-vbeln.

START-OF-SELECTION.
  "Select Header Data
  SELECT vbeln fkdat netwr kunrg FROM vbrk
  INTO TABLE it_vbrk
  WHERE vbeln IN s_vbeln.

  "Select Item Data
  SELECT vbeln posnr arktx fkimg vrkme netwr matnr mwsbp FROM vbrp
  INTO TABLE it_vbrp
  WHERE vbeln IN s_vbeln.

END-OF-SELECTION.
  "The SORT statement ensures the control break is consistent if
  "the table is not a sorted table.
  SORT it_vbrp BY vbeln.

  LOOP AT it_vbrp INTO wa_vbrp.

    AT FIRST. "Print Column Headings
      WRITE AT: /05 'ITEM',
                 15 'DESCRIPTION',
                 60 'BILLED QUANTITY',
                 80 'UNITS',
                 105 'NET VALUE',
                 130 'MATERIAL NUMBER',
                 150 'TAX AMOUNT'.
      WRITE sy-uline.
    ENDAT.

    AT NEW vbeln. "To print header data once per new document
      READ TABLE it_vbrk INTO wa_vbrk WITH KEY
        vbeln = wa_vbrp-vbeln.
      WRITE AT: /5 'Billing Document' LEFT-JUSTIFIED.
      WRITE AT: 30 wa_vbrk-vbeln      LEFT-JUSTIFIED COLOR 2.
      WRITE AT: /5 'Payer'            LEFT-JUSTIFIED.
      WRITE AT: 30 wa_vbrk-kunrg      LEFT-JUSTIFIED COLOR 3.
      WRITE AT: /5 'BILLING DATE'     LEFT-JUSTIFIED.
      WRITE AT: 30 wa_vbrk-fkdat      LEFT-JUSTIFIED COLOR 5.
      WRITE AT: /5 'NET VALUE'        LEFT-JUSTIFIED.
      WRITE AT: 30 wa_vbrk-netwr      LEFT-JUSTIFIED COLOR 6.
    ENDAT.

    "Print Item details
    WRITE : /5  wa_vbrp-posnr LEFT-JUSTIFIED,
            15  wa_vbrp-arktx LEFT-JUSTIFIED,
            60  wa_vbrp-fkimg LEFT-JUSTIFIED,
            80  wa_vbrp-vrkme LEFT-JUSTIFIED,
            105 wa_vbrp-netwr LEFT-JUSTIFIED,
            130 wa_vbrp-matnr LEFT-JUSTIFIED,
            150 wa_vbrp-mwsbp LEFT-JUSTIFIED.

    "To print document total netvalue at the end of last item in the
    "document. The code in AT END OF will execute before the next new
    "document.
    AT END OF vbeln.
      "The keyword SUM can be used within a control break to
      "automatically add up the column.
      SUM.
      "Prints total Sum for document
      WRITE: /105 wa_vbrp-netwr LEFT-JUSTIFIED.
    ENDAT.

    "To identify the last record in the table
    AT LAST.
      WRITE: / 'END OF REPORT'.
    ENDAT.
  ENDLOOP.

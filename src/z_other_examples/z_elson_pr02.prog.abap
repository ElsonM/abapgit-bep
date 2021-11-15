*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_pr02.

*DATA lt_spfli TYPE TABLE OF spfli.
*
*SELECT * FROM spfli INTO TABLE lt_spfli.
*
*CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
*  EXPORTING
*    i_structure_name = 'SPFLI'
*  TABLES
*    t_outtab         = lt_spfli.

*WRITE:/ 'ABAP System Variables', /.
*WRITE:/ 'Client :', sy-mandt.
*WRITE:/ 'User   :', sy-uname.
*WRITE:/ 'Date   :', sy-datum.
*WRITE:/ 'Time   :', sy-uzeit.

DATA: ebeln  TYPE ekpo-ebeln,
      po_max TYPE p DECIMALS 2,
      po_min TYPE p DECIMALS 2,
      tq_max TYPE p DECIMALS 2,
      tq_min TYPE p DECIMALS 2.

WRITE:/    'PO No'           COLOR 1,
        15 'Max PO Quantity' COLOR 1,
        35 'Min PO Quantity' COLOR 1,
        55 'Max Target'      COLOR 1,
        70 'Min Target'      COLOR 1.

SELECT ebeln
       MAX( menge ) MIN( menge )
       MAX( ktmng ) MIN( ktmng )
  FROM ekpo
  INTO (ebeln,
        po_max, po_min,
        tq_max, tq_min)
  GROUP BY ebeln
  ORDER BY ebeln.

  WRITE:/   ebeln,
         15 po_max LEFT-JUSTIFIED,
         35 po_min LEFT-JUSTIFIED,
         55 tq_max LEFT-JUSTIFIED,
         70 tq_min LEFT-JUSTIFIED.

ENDSELECT.

*&---------------------------------------------------------------------*
*&  Include           Z_ALV_INT_TABLE_TOP
*&---------------------------------------------------------------------*

*DATA: BEGIN OF wa_data,
*        vbeln LIKE vbak-vbeln,
*        matnr LIKE mara-matnr,
*      END OF wa_data.
*DATA: it_data LIKE TABLE OF wa_data WITH HEADER LINE.

DATA: BEGIN OF wa_data,
        test TYPE mara-matnr.
        INCLUDE STRUCTURE kna1.
DATA: END OF wa_data.
DATA: it_data LIKE TABLE OF wa_data WITH HEADER LINE.

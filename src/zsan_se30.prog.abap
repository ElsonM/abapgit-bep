*&---------------------------------------------------------------------*
*& Report ZSAN_SE30
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsan_se30.

*DATA: it_mara TYPE TABLE OF mara.
*DATA: wa_mara TYPE mara.
*
*SELECT * FROM mara INTO TABLE it_mara UP TO 500 ROWS.
*
*LOOP AT it_mara INTO wa_mara.
*  WRITE:/ wa_mara-matnr, wa_mara-mtart, wa_mara-mbrsh, wa_mara-matkl, wa_mara-meins.
*ENDLOOP.

TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr,
         mtart TYPE mara-mtart,
         mbrsh TYPE mara-mbrsh,
         matkl TYPE mara-matkl,
         meins TYPE mara-meins,
       END OF ty_mara.

**Runtime analysis using SE30
DATA: it_mara TYPE TABLE OF ty_mara.
DATA: wa_mara TYPE ty_mara.

SELECT matnr mtart mbrsh matkl meins FROM mara INTO TABLE it_mara UP TO 500 ROWS.

LOOP AT it_mara INTO wa_mara.
  WRITE:/ wa_mara-matnr, wa_mara-mtart, wa_mara-mbrsh, wa_mara-matkl, wa_mara-meins.
ENDLOOP.

*SELECT matnr, mtart, mbrsh, matkl, meins
*  FROM mara INTO TABLE @DATA(it_mara) UP TO 500 ROWS.
*
*LOOP AT it_mara INTO DATA(wa_mara).
*  WRITE:/ wa_mara-matnr, wa_mara-mtart, wa_mara-mbrsh, wa_mara-matkl, wa_mara-meins.
*ENDLOOP.

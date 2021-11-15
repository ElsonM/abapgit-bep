*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR12
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_pr12.

FIELD-SYMBOLS: <fs_tab> TYPE STANDARD TABLE,
               <fs_wa>  TYPE mara.

DATA: itab_mara TYPE mara OCCURS 0 WITH HEADER LINE.

SELECT * FROM mara UP TO 10 ROWS INTO TABLE itab_mara.

ASSIGN: itab_mara[] TO <fs_tab>.

LOOP AT <fs_tab> ASSIGNING <fs_wa>.
  <fs_wa>-matnr = 'NEW CHANGE MATERIAL'.
ENDLOOP.

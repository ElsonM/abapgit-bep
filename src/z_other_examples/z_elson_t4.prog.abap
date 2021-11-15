*&---------------------------------------------------------------------*
*& Report Z_ELSON_T4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t4.

*TABLES: spfli.

DATA: t_spfli LIKE spfli OCCURS 0 WITH HEADER LINE.

SELECT * FROM spfli
  INTO TABLE t_spfli
    %_HINTS ORACLE 'INDEX("SPFLI" "SPFLI~001")'.

LOOP AT t_spfli.
  WRITE: / t_spfli-carrid.
ENDLOOP.

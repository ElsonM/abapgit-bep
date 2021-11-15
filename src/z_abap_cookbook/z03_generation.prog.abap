*&---------------------------------------------------------------------*
*& Report YTEST_GENERATION
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z03_generation. "Program removes all comments and white lines

* Try programs Z_ELSON_EX1 and Z_ELSON_EX1_NEW

PARAMETERS origprog TYPE sy-repid.
PARAMETERS newprog  TYPE sy-repid.

DATA: itab  TYPE TABLE OF string.
DATA: itab2 TYPE TABLE OF string.

DATA: wa     TYPE string.
DATA: tempwa TYPE string.

START-OF-SELECTION.
  READ REPORT origprog INTO itab.
  LOOP AT itab INTO wa.
    IF NOT wa IS INITIAL AND wa(1) NE '*'.
      SPLIT wa AT '"' INTO wa tempwa.
      APPEND wa TO itab2.
    ENDIF.
  ENDLOOP.

  TRY.
      SELECT SINGLE @abap_true FROM trdir
        WHERE name EQ @newprog INTO @DATA(result).

      IF result NE abap_true.
        INSERT REPORT newprog FROM itab2. "Exception can be thrown if program to be inserted is too long
        IF sy-subrc EQ 0.
          WRITE: / 'Program converted to: ', newprog.
        ELSE.
          WRITE: / 'Program convertion failed'.
        ENDIF.
      ELSE.
        WRITE : / 'Program not converted since destination program already exists'.
      ENDIF.

    CATCH cx_sy_write_src_line_too_long.
      WRITE / 'Error: Program line too long'.
  ENDTRY.

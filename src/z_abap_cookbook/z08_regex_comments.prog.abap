
*&---------------------------------------------------------------------*
*& Report Z08_REGEX_COMMENTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z08_regex_comments.

PARAMETERS origprog TYPE sy-repid.
PARAMETERS newprog TYPE  sy-repid.

DATA: itab TYPE TABLE OF string.

TABLES: trdir.

START-OF-SELECTION.

  READ REPORT origprog INTO itab.

  REPLACE ALL OCCURRENCES OF REGEX '(^\*.*)|([^\"]*)(\"*.*)'
   IN TABLE itab WITH '$2' IGNORING CASE.
  DELETE itab WHERE table_line IS INITIAL.

  SELECT SINGLE * FROM trdir WHERE name EQ newprog.
  IF sy-subrc NE 0.
    INSERT REPORT newprog FROM itab.
    IF sy-subrc EQ 0.
      WRITE : / ' Program Converted by Name ', newprog.
    ENDIF.
  ELSE.
    WRITE : / 'Program not converted'.
  ENDIF.

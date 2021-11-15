*&---------------------------------------------------------------------*
*& Report Z09_REGEX_HTML
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z09_regex_html.

DATA: htmlstream  TYPE string,
      tagcontents TYPE string,
      tagname     TYPE string.

htmlstream = '<html><h1>This is heading 1</h1> <h2>This is heading 2</h2></html>'.

DO.
  FIND REGEX '<(\u\w*)[^>]*>(.*)</\1>' IN htmlstream IGNORING CASE
    SUBMATCHES tagname tagcontents.
  REPLACE ALL OCCURRENCES OF tagname IN htmlstream WITH '$$$'.
  IF sy-subrc NE 0.
    EXIT.
  ENDIF.
  WRITE :/ tagname ,' --->' ,  tagcontents .
ENDDO.

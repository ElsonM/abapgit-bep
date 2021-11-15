*&---------------------------------------------------------------------*
*& Report Z07_REGEX
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z07_regex.

PARAMETERS field1 TYPE c LENGTH 3 LOWER CASE.
PARAMETERS number TYPE c LENGTH 20.
PARAMETERS tel_no TYPE c LENGTH 8.
PARAMETERS amount TYPE c LENGTH 10.


*IF field1 EQ 'ABC' OR field1 EQ 'CDE' OR field1 EQ 'DEF'.  "Without using regex
*  WRITE:/ 'Field Value in Range'.
*ELSE.
*  WRITE:/ 'Wrong Field Value'.
*ENDIF.

START-OF-SELECTION.

  FIND REGEX '[ABC|CDE|DEF]' IN field1. "We can add -- IGNORING CASE
  IF sy-subrc EQ 0.
    WRITE:/ 'Field Value in Range'.
  ELSE.
    WRITE:/ 'Wrong Field Value'.
  ENDIF.

  REPLACE ALL OCCURRENCES OF REGEX '[^\d]' IN number WITH ''. " Removes all non digit characters
  " [^0-9] can be used instead of [^\d]
  WRITE:/ number.

  DATA mydate(10) VALUE '20171005'.
  REPLACE FIRST OCCURRENCE OF REGEX '(\d{4})(\d{2})(\d{2})' IN mydate WITH '$3/$2/$1'.
  WRITE:/ 'Converted date is', mydate.

  FIND REGEX '([1-9])\1[0-9]{6}' IN tel_no. " 1st character ([1-9]),
  " 2nd character '\1' matches first group
  IF sy-subrc EQ 0.
    WRITE:/ 'Number is Valid'.
  ELSE.
    WRITE:/ 'Number is Invalid'.
  ENDIF.

  DATA textstream TYPE string VALUE 'this this is a repeated text text 11 11'. "Remove duplicate words
  REPLACE ALL OCCURRENCES OF REGEX '(\<\w+\>) \1' IN textstream
    WITH '$1' IGNORING CASE.
  WRITE:/ textstream.

  REPLACE ALL OCCURRENCES OF REGEX '(\d)(?=(\d{3})+(?!\d))' IN amount WITH '$1,'.
  WRITE:/ 'Amount with added commas is' , amount.

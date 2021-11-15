*&---------------------------------------------------------------------*
*& Report Z_ABAP101_059
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_059.

TYPES: BEGIN OF ty_char_and_numeric,
         char_comp1 TYPE string,
         char_comp2 TYPE c LENGTH 3,
         char_comp3 TYPE n LENGTH 10,
         num_comp1  TYPE i,
         num_comp2  TYPE f,
         num_comp3  TYPE decfloat16,
       END OF ty_char_and_numeric.

*&---------------------------------------------------------------------*
*& Form clear_char_or_numeric
*&---------------------------------------------------------------------*
*  This routine clears some component values according to
*  the following rules:
*  a. Clear char components only if the sum of the numeric components
*     is odd (ignoring possible decimal places)
*  b. Clear numeric components only if the sum of vowels in the three
*     char components is even (ignoring lower/upper case)
*----------------------------------------------------------------------*
* --> US_WA_CHAR_AND_NUMERIC text
*----------------------------------------------------------------------*
FORM clear_char_or_numeric
    USING us_wa_char_and_numeric TYPE ty_char_and_numeric.

  DATA lv_mod_result  TYPE i.
  DATA lv_sum_numeric TYPE i.

  lv_sum_numeric =
    us_wa_char_and_numeric-num_comp1 +
    us_wa_char_and_numeric-num_comp2 +
    us_wa_char_and_numeric-num_comp3.

  lv_mod_result = lv_sum_numeric MOD 2.

  IF lv_mod_result <> 0.
    CLEAR: us_wa_char_and_numeric-char_comp1,
           us_wa_char_and_numeric-char_comp2,
           us_wa_char_and_numeric-char_comp3.
    RETURN.
  ENDIF.

  DATA lv_vowel_count         TYPE i.
  DATA lv_current_vowel_count TYPE i.

  FIND ALL OCCURRENCES OF REGEX 'a|e|i|o|u|A|E|I|O|U' IN
    us_wa_char_and_numeric-char_comp1 MATCH COUNT lv_current_vowel_count.
  lv_vowel_count = lv_vowel_count + lv_current_vowel_count.

  FIND ALL OCCURRENCES OF REGEX 'a|e|i|o|u|A|E|I|O|U' IN
    us_wa_char_and_numeric-char_comp2 MATCH COUNT lv_current_vowel_count.
  lv_vowel_count = lv_vowel_count + lv_current_vowel_count.

  FIND ALL OCCURRENCES OF REGEX 'a|e|i|o|u|A|E|I|O|U' IN
    us_wa_char_and_numeric-char_comp3 MATCH COUNT lv_current_vowel_count.
  lv_vowel_count = lv_vowel_count + lv_current_vowel_count.

  lv_mod_result = lv_vowel_count MOD 2.

  IF lv_mod_result = 0.
    CLEAR: us_wa_char_and_numeric-num_comp1,
           us_wa_char_and_numeric-num_comp2,
           us_wa_char_and_numeric-num_comp3.
    RETURN.
  ENDIF.
ENDFORM. " clear_char_or_numeric

START-OF-SELECTION.

  DATA wa_char_cleared    TYPE ty_char_and_numeric.
  DATA wa_numeric_cleared TYPE ty_char_and_numeric.

  wa_char_cleared-char_comp1 = 'This should be clea'.
  wa_char_cleared-char_comp2 = 'red'.
  wa_char_cleared-char_comp3 = '0123456789'.
  wa_char_cleared-num_comp1 = 1.
  wa_char_cleared-num_comp2 = 10.
  wa_char_cleared-num_comp3 = 100.

  WRITE: wa_char_cleared-char_comp1,
         wa_char_cleared-char_comp2,
         wa_char_cleared-char_comp3,
         wa_char_cleared-num_comp1,
         wa_char_cleared-num_comp2,
         wa_char_cleared-num_comp3.
  ULINE.

  PERFORM clear_char_or_numeric USING wa_char_cleared.

  WRITE: wa_char_cleared-char_comp1,
         wa_char_cleared-char_comp2,
         wa_char_cleared-char_comp3,
         wa_char_cleared-num_comp1,
         wa_char_cleared-num_comp2,
         wa_char_cleared-num_comp3.
  ULINE.

  wa_numeric_cleared-char_comp1 = 'aeiouAEIOU'.
  wa_numeric_cleared-char_comp2 = 'BCD'.
  wa_numeric_cleared-char_comp3 = '0123456789'.
  wa_numeric_cleared-num_comp1 = 2. " even
  wa_numeric_cleared-num_comp2 = 10.
  wa_numeric_cleared-num_comp3 = 100.

  WRITE: wa_numeric_cleared-char_comp1,
         wa_numeric_cleared-char_comp2,
         wa_numeric_cleared-char_comp3,
         wa_numeric_cleared-num_comp1,
         wa_numeric_cleared-num_comp2,
         wa_numeric_cleared-num_comp3.
  ULINE.

  PERFORM clear_char_or_numeric USING wa_numeric_cleared.

  WRITE: wa_numeric_cleared-char_comp1,
         wa_numeric_cleared-char_comp2,
         wa_numeric_cleared-char_comp3,
         wa_numeric_cleared-num_comp1,
         wa_numeric_cleared-num_comp2,
         wa_numeric_cleared-num_comp3.
  ULINE.

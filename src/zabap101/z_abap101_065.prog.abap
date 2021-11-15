*&---------------------------------------------------------------------*
*& Report Z_ABAP101_065
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_065.

*& Form concatenate_strings
*&---------------------------------------------------------------------*
*  Concatenate strings from an internal table
*----------------------------------------------------------------------*
* --> US_ITAB Internal table of strings
* --> CH_CONCATENATED_STRING Result
*----------------------------------------------------------------------*
FORM concatenate_strings
    USING
      us_t_strings           TYPE table_of_strings
    CHANGING
      ch_concatenated_string TYPE string.

  DATA t_copied_strings LIKE us_t_strings.
  t_copied_strings = us_t_strings.

  FIELD-SYMBOLS <string_line> TYPE string.

  LOOP AT t_copied_strings ASSIGNING <string_line>.
    CONCATENATE ch_concatenated_string <string_line> INTO
      ch_concatenated_string.
  ENDLOOP.

ENDFORM. " concatenate_strings

*&---------------------------------------------------------------------*
*& Form concatenate_strings_in_ways
*&---------------------------------------------------------------------*
*  Receives an internal table of strings and concatenates
*  their values in four different ways:
*  Way 1: concatenate internal table texts by the line order
*  Way 2: concatenate internal table texts by the text ascending order
*  Way 3: concatenate internal table texts by the text descending order
*  Way 4: concatenate internal table texts by the line reverse order
*----------------------------------------------------------------------*
* --> US_T_STRINGS Table of strings
* --> US_V_CONCAT_LOGIC Concatenation way # (1-4)
* --> CH_CONCATENATED_STRING Concatenated string
*----------------------------------------------------------------------*

FORM concatenate_strings_in_ways
    USING
      us_t_strings TYPE table_of_strings
      us_v_concat_logic TYPE c
    CHANGING
      ch_concatenated_string TYPE string.

  DATA t_copied_strings LIKE us_t_strings.
  t_copied_strings = us_t_strings.

  CASE us_v_concat_logic.

    WHEN '1'.
      PERFORM concatenate_strings
        USING
          t_copied_strings
        CHANGING
          ch_concatenated_string.

    WHEN '2'.
      SORT t_copied_strings.
      PERFORM concatenate_strings
        USING
          t_copied_strings
      CHANGING
          ch_concatenated_string.

    WHEN '3'.
      SORT t_copied_strings DESCENDING.
      PERFORM concatenate_strings
        USING
          t_copied_strings
        CHANGING
          ch_concatenated_string.

    WHEN '4'.
* reverse loop
      DATA vl_number_of_strings TYPE i.
      FIELD-SYMBOLS <string_line> TYPE string.
      DESCRIBE TABLE t_copied_strings LINES vl_number_of_strings.

      WHILE vl_number_of_strings > 0.
        READ TABLE t_copied_strings ASSIGNING <string_line> INDEX
          vl_number_of_strings.
        IF sy-subrc IS INITIAL.
          CONCATENATE ch_concatenated_string <string_line> INTO
            ch_concatenated_string.
        ENDIF.
        UNASSIGN <string_line>.
        vl_number_of_strings = vl_number_of_strings - 1.
      ENDWHILE.

  ENDCASE.

ENDFORM. " concatenate_strings_in_ways

START-OF-SELECTION.

  DATA it_strings TYPE table_of_strings.
  DATA gv_concatenated TYPE string.

  APPEND 'A' TO it_strings.
  APPEND 'B' TO it_strings.
  APPEND 'C' TO it_strings.
  APPEND 'D' TO it_strings.
  APPEND 'X' TO it_strings.
  APPEND 'Y' TO it_strings.
  APPEND 'Z' TO it_strings.
  APPEND 'M' TO it_strings.
  APPEND 'N' TO it_strings.
  APPEND 'O' TO it_strings.

  PERFORM concatenate_strings_in_ways
    USING
      it_strings
      '1'
    CHANGING
      gv_concatenated.
  WRITE: '1 - ', gv_concatenated, /.
  CLEAR gv_concatenated.

  PERFORM concatenate_strings_in_ways
    USING
      it_strings
      '2'
    CHANGING
      gv_concatenated.
  WRITE: '2 - ', gv_concatenated, /.
  CLEAR gv_concatenated.

  PERFORM concatenate_strings_in_ways
    USING
      it_strings
      '3'
    CHANGING
      gv_concatenated.
  WRITE: '3 - ', gv_concatenated, /.
  CLEAR gv_concatenated.

  PERFORM concatenate_strings_in_ways
    USING
      it_strings
      '4'
    CHANGING
      gv_concatenated.
  WRITE: '4 - ', gv_concatenated, /.
  CLEAR gv_concatenated.

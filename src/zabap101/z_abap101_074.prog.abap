*&---------------------------------------------------------------------*
*& Report Z_ABAP101_074
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_074.

DATA v_number TYPE i.
SELECT-OPTIONS s_number FOR v_number.

START-OF-SELECTION.

  LOOP AT s_number.
    IF s_number-sign = 'I'.
      WRITE: 'Include'.
    ELSE.
      WRITE: 'Exclude'.
    ENDIF.
    CASE s_number-option.
      WHEN 'EQ'.
        WRITE: 'Equal', s_number-low.
      WHEN 'NE'.
        WRITE: 'Not equal', s_number-low.
      WHEN 'LT'.
        WRITE: 'Less than', s_number-low.
      WHEN 'LE'.
        WRITE: 'Less or equal', s_number-low.
      WHEN 'GT'.
        WRITE: 'Greater than', s_number-low.
      WHEN 'GE'.
        WRITE: 'Greater or equal', s_number-low.
      WHEN 'BT'.
        WRITE: 'Between', s_number-low, ' and ', s_number-high.
      WHEN 'NB'.
        WRITE: 'Not between', s_number-low, ' and ', s_number-high.
      WHEN 'CP'. "Patterns are used in char and string select-options
        WRITE: 'Contains pattern', s_number-low.
      WHEN 'NP'.
        WRITE: 'Not the pattern', s_number-low.
    ENDCASE.
    NEW-LINE.
  ENDLOOP.

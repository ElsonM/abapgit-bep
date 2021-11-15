*&---------------------------------------------------------------------*
*& Report Z18_CURRENCY_TO_WORD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z18_currency_to_word NO STANDARD PAGE HEADING.

PARAMETERS p_amt TYPE pc207-betrg.

DATA v_amt TYPE char100.

CALL FUNCTION 'ZHR_IN_CHG_ALL_WRDS'
  EXPORTING
    amt_in_num         = p_amt
  IMPORTING
    amt_in_words       = v_amt
  EXCEPTIONS
    data_type_mismatch = 1
    OTHERS             = 2.

CALL FUNCTION 'ISP_CONVERT_FIRSTCHARS_TOUPPER'
  EXPORTING
    input_string  = v_amt
    separators    = ' '
  IMPORTING
    output_string = v_amt.

WRITE: / 'Shuma ne leke: ', v_amt.

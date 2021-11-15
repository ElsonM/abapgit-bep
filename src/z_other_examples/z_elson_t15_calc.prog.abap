*&---------------------------------------------------------------------*
*& Report Z_ELSON_T15_CALC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t15_calc.
INCLUDE zinclude_header.

DATA result TYPE i.

PARAMETERS opt1 TYPE i.
PARAMETERS opt2 TYPE i.

PARAMETERS add RADIOBUTTON GROUP grp1.
PARAMETERS sub RADIOBUTTON GROUP grp1.
PARAMETERS mul RADIOBUTTON GROUP grp1.
PARAMETERS div RADIOBUTTON GROUP grp1.
PARAMETERS rem RADIOBUTTON GROUP grp1.

IF add = 'X'.
  result = opt1 + opt2.
  PERFORM print_system_data_and_result USING result.
ENDIF.

IF sub = 'X'.
  result = opt1 - opt2.
  PERFORM print_system_data_and_result USING result.
ENDIF.

IF mul = 'X'.
  result = opt1 * opt2.
  PERFORM print_system_data_and_result USING result.
ENDIF.

IF div = 'X'.
  result = opt1 / opt2.
  PERFORM print_system_data_and_result USING result.
ENDIF.

IF rem = 'X'.
  result = opt1 mod opt2.
  PERFORM print_system_data_and_result USING result.
ENDIF.

NEW-LINE.
WRITE: 'Value of variable result before subrutine:', result.
NEW-LINE.
PERFORM testing_parameter USING result CHANGING opt1 opt2.
NEW-LINE.
WRITE: 'Value of variable result after subrutine:', result.

*&---------------------------------------------------------------------*
*&      Form  PRINT_SYSTEM_DATA_AND_RESULT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_RESULT  text
*----------------------------------------------------------------------*
FORM print_system_data_and_result  USING    p_result.
  WRITE: 'Result:', p_result.
  NEW-LINE.
  WRITE sy-uname.
  NEW-LINE.
  WRITE sy-datum.
ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  TESTING_PARAMETER
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_RESULT  text
*      <--P_OPT1  text
*      <--P_OPT2  text
*----------------------------------------------------------------------*
FORM testing_parameter  USING    VALUE(p_result) "By value
                        CHANGING VALUE(p_opt1)   "By value and result
                                 p_opt2.         "By reference
  ADD 1 TO p_result.
  WRITE: 'Value of variable result inside subrutine:', p_result.
ENDFORM.

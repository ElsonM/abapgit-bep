*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR14
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_pr14.

* --> Only one message
*CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
*  EXPORTING
*    i_msgid  = 'E4'
*    i_msgty  = 'E'
*    i_msgno  = '001'
*    i_msgv1  = 'ZTEST'
*    i_lineno = 1.

* --> More than one message

*DATA: lt_tab TYPE esp1_message_tab_type.
*DATA: ls_tab TYPE esp1_message_wa_type.
*
*ls_tab-msgid  = 'E4'.
*ls_tab-msgno  = '000'.
*
*ls_tab-msgty  = 'E'.
*ls_tab-msgv1  = 'Error Message'.
*ls_tab-lineno = 1.
*APPEND ls_tab TO lt_tab.
*
*ls_tab-msgty  = 'W'.
*ls_tab-msgv1  = 'Warning Message'.
*ls_tab-lineno = 2.
*APPEND ls_tab TO lt_tab.
*
*ls_tab-msgty  = 'S'.
*ls_tab-msgv1  = 'Success Message'.
*ls_tab-lineno = 3.
*APPEND ls_tab TO lt_tab.
*
*CALL FUNCTION 'C14Z_MESSAGES_SHOW_AS_POPUP'
*  TABLES
*    i_message_tab = lt_tab.

DATA: gv_answer.
DATA: go_alv TYPE REF TO cl_salv_table.
DATA: gr_functions TYPE REF TO cl_salv_functions_list.
DATA: it_employees TYPE TABLE OF zemployees,
      wa_employees TYPE          zemployees.

CALL FUNCTION 'POPUP_TO_CONFIRM'
  EXPORTING
    text_question         = 'Display errors?'
    text_button_1         = 'Yes'(001)
    icon_button_1         = 'ICON_CHECKED'
    text_button_2         = 'No'(002)
    icon_button_2         = 'ICON_INCOMPLETE'
    display_cancel_button = 'X'
  IMPORTING
    answer                = gv_answer.

IF gv_answer = '1'.
  SELECT * FROM zemployees INTO TABLE it_employees.

  TRY.
      cl_salv_table=>factory(
        IMPORTING
          r_salv_table = go_alv
        CHANGING
          t_table      = it_employees ).
    CATCH cx_salv_msg.
  ENDTRY.

  gr_functions = go_alv->get_functions( ).
  gr_functions->set_all( 'X' ).

  IF go_alv IS BOUND.
    go_alv->set_screen_popup(
      start_column = 0
      end_column   = 100
      start_line   = 10
      end_line     = 30 ).
    go_alv->display( ).
  ENDIF.
ENDIF.

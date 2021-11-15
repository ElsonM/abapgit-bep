*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR10
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_pr10.

TABLES: sscrfields.

*--------------------------------------------------------------*
* Selection-Screen
*--------------------------------------------------------------*
SELECTION-SCREEN: BEGIN OF LINE,
                    PUSHBUTTON 2(5)  btn_1_1 USER-COMMAND btn_1_1,
                    PUSHBUTTON 8(5)  btn_1_2 USER-COMMAND btn_1_2,
                    PUSHBUTTON 14(5) btn_1_3 USER-COMMAND btn_1_3,
*                    PUSHBUTTON 20(5) btn_1_4 USER-COMMAND btn_1_4,
*                    PUSHBUTTON 26(5) btn_1_5 USER-COMMAND btn_1_5,
                  END OF LINE.                                      "First line of numbers

SELECTION-SCREEN: BEGIN OF LINE,
                    PUSHBUTTON 2(5)  btn_2_1 USER-COMMAND btn_2_1,
                    PUSHBUTTON 8(5)  btn_2_2 USER-COMMAND btn_2_2,
                    PUSHBUTTON 14(5) btn_2_3 USER-COMMAND btn_2_3,
*                    PUSHBUTTON 20(5) btn_2_4 USER-COMMAND btn_2_4,
*                    PUSHBUTTON 26(5) btn_2_5 USER-COMMAND btn_2_5,
                  END OF LINE.                                      "Second line of numbers

SELECTION-SCREEN: BEGIN OF LINE,
                    PUSHBUTTON 2(5)  btn_3_1 USER-COMMAND btn_3_1,
                    PUSHBUTTON 8(5)  btn_3_2 USER-COMMAND btn_3_2,
                    PUSHBUTTON 14(5) btn_3_3 USER-COMMAND btn_3_3,
*                    PUSHBUTTON 20(5) btn_3_4 USER-COMMAND btn_3_4,
*                    PUSHBUTTON 26(5) btn_3_5 USER-COMMAND btn_3_5,
                  END OF LINE.                                      "Third line of numbers

*SELECTION-SCREEN: BEGIN OF LINE,
*                    PUSHBUTTON 2(5)  btn_4_1 USER-COMMAND btn_4_1,
*                    PUSHBUTTON 8(5)  btn_4_2 USER-COMMAND btn_4_2,
*                    PUSHBUTTON 14(5) btn_4_3 USER-COMMAND btn_4_3,
*                    PUSHBUTTON 20(5) btn_4_4 USER-COMMAND btn_4_4,
*                    PUSHBUTTON 26(5) btn_4_5 USER-COMMAND btn_4_5,
*                  END OF LINE.                                      "Fourth line of numbers
*
*SELECTION-SCREEN: BEGIN OF LINE,
*                    PUSHBUTTON 2(5)  btn_5_1 USER-COMMAND btn_5_1,
*                    PUSHBUTTON 8(5)  btn_5_2 USER-COMMAND btn_5_2,
*                    PUSHBUTTON 14(5) btn_5_3 USER-COMMAND btn_5_3,
*                    PUSHBUTTON 20(5) btn_5_4 USER-COMMAND btn_5_4,
*                    PUSHBUTTON 26(5) btn_5_5 USER-COMMAND btn_5_5,
*                  END OF LINE.                                      "Fifth line of numbers

SELECTION-SCREEN: SKIP 2.

SELECTION-SCREEN: PUSHBUTTON 2(17) random USER-COMMAND rand.  "Reset button


*--------------------------------------------------------------*
*At Selection-Screen Output
*--------------------------------------------------------------*
AT SELECTION-SCREEN OUTPUT.
  PERFORM win.

*--------------------------------------------------------------*
*At Selection-Screen
*--------------------------------------------------------------*
AT SELECTION-SCREEN.

*  DATA: btn_sel LIKE btn1,                   "Making the program more dynamic - To be worked on
*        btn_left LIKE btn1,
*        btn_right LIKE btn1,
*        btn_up    LIKE btn1,
*        btn_down  LIKE btn1.
*
*  IF sscrfields = 'RAND'.
*    MESSAGE 'You pressed reset' TYPE 'I'.
*  ELSE.
*    btn_sel = sscrfields+3(1).
*    IF ( ( btn_sel MOD 3 ) NE 1 ).
*      btn_left = btn_sel - 1.
*    ENDIF.
*  ENDIF.

  CASE sscrfields.
    WHEN 'BTN_1_1'.
      PERFORM check_button CHANGING btn_1_1 btn_1_2.
      PERFORM check_button CHANGING btn_1_1 btn_2_1.
    WHEN 'BTN_1_2'.
      PERFORM check_button CHANGING btn_1_2 btn_1_1.
      PERFORM check_button CHANGING btn_1_2 btn_1_3.
      PERFORM check_button CHANGING btn_1_2 btn_2_2.
    WHEN 'BTN_1_3'.
      PERFORM check_button CHANGING btn_1_3 btn_1_2.
      PERFORM check_button CHANGING btn_1_3 btn_2_3.
    WHEN 'BTN_2_1'.
      PERFORM check_button CHANGING btn_2_1 btn_1_1.
      PERFORM check_button CHANGING btn_2_1 btn_2_2.
      PERFORM check_button CHANGING btn_2_1 btn_3_1.
    WHEN 'BTN_2_2'.
      PERFORM check_button CHANGING btn_2_2 btn_1_2.
      PERFORM check_button CHANGING btn_2_2 btn_2_1.
      PERFORM check_button CHANGING btn_2_2 btn_2_3.
      PERFORM check_button CHANGING btn_2_2 btn_3_2.
    WHEN 'BTN_2_3'.
      PERFORM check_button CHANGING btn_2_3 btn_1_3.
      PERFORM check_button CHANGING btn_2_3 btn_2_2.
      PERFORM check_button CHANGING btn_2_3 btn_3_3.
    WHEN 'BTN_3_1'.
      PERFORM check_button CHANGING btn_3_1 btn_2_1.
      PERFORM check_button CHANGING btn_3_1 btn_3_2.
    WHEN 'BTN_3_2'.
      PERFORM check_button CHANGING btn_3_2 btn_2_2.
      PERFORM check_button CHANGING btn_3_2 btn_3_1.
      PERFORM check_button CHANGING btn_3_2 btn_3_3.
    WHEN 'BTN_3_3'.
      PERFORM check_button CHANGING btn_3_3 btn_2_3.
      PERFORM check_button CHANGING btn_3_3 btn_3_2.
    WHEN 'RAND'.
      PERFORM random.
  ENDCASE.

*&---------------------------------------------------------------------*
*& INITIALIZATION.
*&---------------------------------------------------------------------*
INITIALIZATION.
  random = 'Reset'.
  PERFORM random.

*&---------------------------------------------------------------------*
*& Form CHECK_BUTTON
*&---------------------------------------------------------------------*
FORM check_button
  CHANGING p_b1 p_b2.

  IF p_b2 IS INITIAL. "Change the value of the buttons
    p_b2 = p_b1.
    CLEAR p_b1.
  ENDIF.

ENDFORM.                    "CHECK_BUTTON

*&---------------------------------------------------------------------*
*&      Form  RANDOM
*&---------------------------------------------------------------------*
FORM random.

  DATA: it TYPE TABLE OF c,
        wa TYPE          c.

  DATA: lv_random  TYPE qf00-ran_int,
        lv_counter TYPE i.

  CONSTANTS: lv_btn(3) TYPE c VALUE 'BTN'.

  DATA: temp,
        lv_button(7) TYPE c.

  FIELD-SYMBOLS: <fs> TYPE c.

  DATA: nr_row TYPE int4,
        nr_col TYPE int4.

  DO.
    CALL FUNCTION 'QF05_RANDOM_INTEGER'
      EXPORTING
        ran_int_max   = 9
        ran_int_min   = 1
      IMPORTING
        ran_int       = lv_random
      EXCEPTIONS
        invalid_input = 1
        OTHERS        = 2.

    wa = lv_random.                                   "Assign number number to wa and see if it doesn't exist
    READ TABLE it TRANSPORTING NO FIELDS WITH KEY wa.
    IF sy-subrc <> 0.
      APPEND wa TO it.
      lv_counter = lines( it ).
    ENDIF.

    IF lv_counter = 9.                                "Check that table if filled
      EXIT.
    ENDIF.
  ENDDO.

  LOOP AT it INTO wa.

    nr_col = 3 - ( sy-tabix MOD 3 ).
    nr_row = ceil( sy-tabix / 3 ).

*    temp = sy-tabix.

    lv_button = |{ lv_btn }{ nr_row }_{ nr_col }|.

*    CONCATENATE lv_btn nr_row '_' nr_col INTO lv_button.
    ASSIGN (lv_button) TO   <fs>.                     "Assign a field symbol to the button

    IF wa = '9'.
      CLEAR wa.                                       "Button with value '9' is cleared
    ENDIF.
    <fs> = wa.                                        "Change value of the button
    CLEAR wa.
  ENDLOOP.

ENDFORM.                    " RANDOM

*&---------------------------------------------------------------------*
*&      Form  WIN
*&---------------------------------------------------------------------*
FORM win.
  IF btn_1_1 = '1' AND btn_1_2 = '2' AND btn_1_3 = '3' AND
     btn_2_1 = '4' AND btn_2_2 = '5' AND btn_2_3 = '6' AND
     btn_3_1 = '7' AND btn_3_2 = '8' AND btn_3_3 IS INITIAL.
    MESSAGE 'You Won!' TYPE 'I'.
    PERFORM random.
  ENDIF.
ENDFORM.                    " WIN

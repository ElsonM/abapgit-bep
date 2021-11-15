*&---------------------------------------------------------------------*
*& Report Z06_PUSHBUTTON
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z06_pushbutton.

TABLES sscrfields.

*--------------------------------------------------------------*
*Selection-Screen
*--------------------------------------------------------------*
SELECTION-SCREEN:
      PUSHBUTTON /2(40) button1 USER-COMMAND but1,
      PUSHBUTTON /2(40) button2 USER-COMMAND but2.

*--------------------------------------------------------------*
*Initialization
*--------------------------------------------------------------*
INITIALIZATION.
  button1 = 'Button 1'.
  button2 = 'Button 2'.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name   = icon_okay
      text   = 'Continue'
      info   = 'Click to Continue'
    IMPORTING
      result = button1
    EXCEPTIONS
      OTHERS = 0.

  CALL FUNCTION 'ICON_CREATE'
    EXPORTING
      name   = icon_cancel
      text   = 'Exit'
      info   = 'Click to Exit'
    IMPORTING
      result = button2
    EXCEPTIONS
      OTHERS = 0.

*--------------------------------------------------------------*
*At Selection-Screen
*--------------------------------------------------------------*
AT SELECTION-SCREEN.
  CASE sscrfields.
    WHEN 'BUT1'.
      MESSAGE 'Button 1 was clicked' TYPE 'I'.
    WHEN 'BUT2'.
      MESSAGE 'Button 2 was clicked' TYPE 'I'.
  ENDCASE.

*&---------------------------------------------------------------------*
*& Report Z_ABAP101_056
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_056.

DATA: BEGIN OF work_area,
        str     TYPE string,
        date    TYPE d,
        time    TYPE t,
        integer TYPE i,
        hex     TYPE x LENGTH 8,
      END OF work_area.

START-OF-SELECTION.

  work_area-str     = 'This is a string'.
  work_area-date    = '20141225'.         "Christmas
  work_area-time    = '134059'.
  work_area-integer = 101.
  work_area-hex     = '0123456789ABCDEF'.

** Before refactoring
*  WRITE work_area-str.
*  ULINE.
*  WRITE work_area-date DD/MM/YY.
*  ULINE.
*  WRITE work_area-time.
*  ULINE.
*  WRITE work_area-integer.
*  ULINE.
*  WRITE work_area-hex.
*  ULINE.

* After refactoring
  WRITE work_area-str.
  PERFORM separe_line.
  WRITE work_area-date DD/MM/YY.
  PERFORM separe_line.
  WRITE work_area-time.
  PERFORM separe_line.
  WRITE work_area-integer.
  PERFORM separe_line.
  WRITE work_area-hex.

  PERFORM separe_line.
*&---------------------------------------------------------------------*
*& Form separe_line
*&---------------------------------------------------------------------*
*  Separe each output line
*----------------------------------------------------------------------*
FORM separe_line.
  DO 2 TIMES.
    ULINE.
  ENDDO.
ENDFORM. " separe_line

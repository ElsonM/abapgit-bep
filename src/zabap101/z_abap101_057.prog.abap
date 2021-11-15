*&---------------------------------------------------------------------*
*& Report Z_ABAP101_057
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_057.

TYPES: BEGIN OF ty_work_area,
         str     TYPE string,
         date    TYPE d,
         time    TYPE i,
         integer TYPE i,
         hex     TYPE x LENGTH 8,
       END OF ty_work_area.

DATA work_area TYPE ty_work_area.

*&---------------------------------------------------------------------*
*& Form count_initial_components
*&---------------------------------------------------------------------*
*  Gets a work area, counts how many components are initial and write
*  the result
*----------------------------------------------------------------------*
* --> US_WORK_AREA work area
*----------------------------------------------------------------------*

FORM count_initial_components USING us_work_area TYPE ty_work_area.
  DATA lv_initial_components_counter TYPE i.

  IF us_work_area-str IS INITIAL.
    lv_initial_components_counter = lv_initial_components_counter + 1.
  ENDIF.

  IF us_work_area-date IS INITIAL.
    lv_initial_components_counter = lv_initial_components_counter + 1.
  ENDIF.

  IF us_work_area-time IS INITIAL.
    lv_initial_components_counter = lv_initial_components_counter + 1.
  ENDIF.

  IF us_work_area-integer IS INITIAL.
    lv_initial_components_counter = lv_initial_components_counter + 1.
  ENDIF.

  IF us_work_area-hex IS INITIAL.
    lv_initial_components_counter = lv_initial_components_counter + 1.
  ENDIF.

  WRITE: 'Initial components:', lv_initial_components_counter.
  NEW-LINE.
ENDFORM. " count_initial_components

START-OF-SELECTION.

  PERFORM count_initial_components USING work_area.
  work_area-str = 'This is a string'.

  PERFORM count_initial_components USING work_area.
  work_area-date = '20141225'. " Christmas

  PERFORM count_initial_components USING work_area.
  work_area-time = '134059'.

  PERFORM count_initial_components USING work_area.
  work_area-integer = 101.

  PERFORM count_initial_components USING work_area.
  work_area-hex = '0123456789ABCDEF'.

  PERFORM count_initial_components USING work_area.

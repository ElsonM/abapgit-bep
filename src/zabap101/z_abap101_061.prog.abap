*&---------------------------------------------------------------------*
*& Report Z_ABAP101_061
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_061.

TYPES: BEGIN OF ty_line,
         id            TYPE c LENGTH 10,
         name          TYPE string,
         value         TYPE i,
         creation_date TYPE d,
       END OF ty_line.

TYPES: ty_table TYPE STANDARD TABLE OF ty_line.

*&---------------------------------------------------------------------*
*& Form count_initial_fields_of_table
*&---------------------------------------------------------------------*
*  Counts how many fields are filled with their default value
*----------------------------------------------------------------------*
* --> US_TABLE internal table
*----------------------------------------------------------------------*

FORM count_initial_fields_of_table USING us_table TYPE ty_table.

  DATA lwa_line               TYPE ty_line.
  DATA lv_initial_field_total TYPE i.

  LOOP AT us_table INTO lwa_line.

    IF lwa_line-id IS INITIAL.
      lv_initial_field_total = lv_initial_field_total + 1.
    ENDIF.

    IF lwa_line-name IS INITIAL.
      lv_initial_field_total = lv_initial_field_total + 1.
    ENDIF.

    IF lwa_line-value IS INITIAL.
      lv_initial_field_total = lv_initial_field_total + 1.
    ENDIF.

    IF lwa_line-creation_date IS INITIAL.
      lv_initial_field_total = lv_initial_field_total + 1.
    ENDIF.

  ENDLOOP.

  WRITE: 'Number of initial values: ', lv_initial_field_total.
  NEW-LINE.

ENDFORM. " count_initial_fields_of_table

START-OF-SELECTION.

  DATA itab TYPE ty_table.
  DATA wa   TYPE ty_line.

  wa-id = '1'.
  wa-name = 'John'.
  wa-value = 50.
  wa-creation_date = '20140727'.

  APPEND wa TO itab.
  CLEAR wa.

  PERFORM count_initial_fields_of_table USING itab.

  wa-id = '2'.
  wa-name = 'Mary'.
  wa-value = 20.
* wa-creation_date = ?.

  APPEND wa TO itab.
  CLEAR wa.

  PERFORM count_initial_fields_of_table USING itab.

  wa-id = '3'.
  wa-name = 'Max'.
* wa-value = ?.
* wa-creation_date = ?.

  APPEND wa TO itab.
  CLEAR wa.

  PERFORM count_initial_fields_of_table USING itab.

  wa-id = '4'.
* wa-name = ?.
* wa-value = ?.
* wa-creation_date = ?.

  APPEND wa TO itab.
  CLEAR wa.

  PERFORM count_initial_fields_of_table USING itab.

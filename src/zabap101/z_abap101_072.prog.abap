*&---------------------------------------------------------------------*
*& Report Z_ABAP101_072_1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_072_1.

TYPES: BEGIN OF ty_person,
         id   TYPE n LENGTH 8,
         name TYPE c LENGTH 20,
         age  TYPE i,
       END OF ty_person.

TYPES tt_people TYPE TABLE OF ty_person WITH KEY id.
DATA  it_people TYPE tt_people.

FORM print_people
    USING us_itab_people TYPE tt_people.

  DATA lwa_person TYPE ty_person.
  LOOP AT us_itab_people INTO lwa_person.
    WRITE: lwa_person-id, lwa_person-name, lwa_person-age.
    NEW-LINE.
  ENDLOOP.

ENDFORM. " print_people

FORM sort_any_columns
    USING    us_t_columns   TYPE table_of_strings
    CHANGING ch_itab_people TYPE tt_people.

  DATA lv_number_of_lines TYPE i.

  DESCRIBE TABLE us_t_columns LINES lv_number_of_lines.

  DATA lv_first_column  TYPE string.
  DATA lv_second_column TYPE string.
  DATA lv_third_column  TYPE string.

  CASE lv_number_of_lines.

    WHEN 1.
      READ TABLE us_t_columns INDEX 1 INTO lv_first_column.
      SORT ch_itab_people BY (lv_first_column) ASCENDING.

    WHEN 2.
      READ TABLE us_t_columns INDEX 1 INTO lv_first_column.
      READ TABLE us_t_columns INDEX 2 INTO lv_second_column.
      SORT ch_itab_people BY (lv_first_column)  ASCENDING
        (lv_second_column) ASCENDING.

    WHEN 3.
      READ TABLE us_t_columns INDEX 1 INTO lv_first_column.
      READ TABLE us_t_columns INDEX 2 INTO lv_second_column.
      READ TABLE us_t_columns INDEX 3 INTO lv_third_column.
      SORT ch_itab_people BY (lv_first_column)  ASCENDING
        (lv_second_column) ASCENDING
        (lv_third_column)  ASCENDING.

  ENDCASE.

ENDFORM. " sort_any_columns

START-OF-SELECTION.

* Populating the internal table WITHOUT HEADER LINE (hat)
  DATA wa_person TYPE ty_person.


  wa_person-id   = 3.
  wa_person-name = 'The One'.
  wa_person-age  = 30.
  APPEND wa_person TO it_people.

  wa_person-id   = 6.
  wa_person-name = 'Peter'.
  wa_person-age  = 40.
  APPEND wa_person TO it_people.

  wa_person-id   = 2.
  wa_person-name = 'Bob'.
  wa_person-age  = 30.
  APPEND wa_person TO it_people.

  wa_person-id   = 1.
  wa_person-name = 'Mary'.
  wa_person-age  = 10.
  APPEND wa_person TO it_people.

  wa_person-id   = 5.
  wa_person-name = 'Chris'.
  wa_person-age  = 20.
  APPEND wa_person TO it_people.

  wa_person-id   = 4.
  wa_person-name = 'Bob'.
  wa_person-age  = 40.
  APPEND wa_person TO it_people.

  DATA it_sort_columns TYPE table_of_strings.

  WRITE 'Before SORT'. NEW-LINE.
  PERFORM print_people
    USING
      it_people.

  SKIP.

  APPEND `NAME` TO it_sort_columns.

  PERFORM sort_any_columns
    USING
      it_sort_columns
    CHANGING
      it_people.

  REFRESH it_sort_columns.
  WRITE 'After SORT by NAME'. NEW-LINE.
  PERFORM print_people USING it_people.

  SKIP.

  APPEND `AGE` TO it_sort_columns.
  APPEND `ID`  TO it_sort_columns.

  PERFORM sort_any_columns
    USING
      it_sort_columns
    CHANGING
      it_people.

  REFRESH it_sort_columns.
  WRITE 'After SORT by AGE / ID'. NEW-LINE.
  PERFORM print_people USING it_people.

  SKIP.

  APPEND `AGE`  TO it_sort_columns.
  APPEND `NAME` TO it_sort_columns.
  APPEND `ID`   TO it_sort_columns.

  PERFORM sort_any_columns
    USING
      it_sort_columns
    CHANGING
      it_people.

  REFRESH it_sort_columns.
  WRITE 'After SORT by AGE / NAME / ID'. NEW-LINE.
  PERFORM print_people USING it_people.

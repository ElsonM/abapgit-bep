*&---------------------------------------------------------------------*
*& Report Z_ABAP101_071
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_071.

TYPES: BEGIN OF ty_person,
         id   TYPE n LENGTH 8,
         name TYPE c LENGTH 20,
         age  TYPE i,
       END OF ty_person.

TYPES tt_person TYPE TABLE OF ty_person WITH KEY id.
DATA  it_person TYPE          tt_person.

FORM sort_any_column
    USING    us_v_column    TYPE string
    CHANGING ch_itab_person TYPE tt_person.

  SORT ch_itab_person BY (us_v_column) ASCENDING.

ENDFORM. " sort_any_column

START-OF-SELECTION.

* Populating the internal table WITHOUT HEADER LINE (hat)
  DATA wa_person TYPE ty_person.

  wa_person-id = 3.
  wa_person-name = 'The One'.
  wa_person-age = 30.
  APPEND wa_person TO it_person.

  wa_person-id = 2.
  wa_person-name = 'Bob'.
  wa_person-age = 20.
  APPEND wa_person TO it_person.

  wa_person-id = 1.
  wa_person-name = 'Mary'.
  wa_person-age = 10.
  APPEND wa_person TO it_person.

  wa_person-id = 5.
  wa_person-name = 'Chris'.
  wa_person-age = 50.
  APPEND wa_person TO it_person.

  wa_person-id = 4.
  wa_person-name = 'Janet'.
  wa_person-age = 40.
  APPEND wa_person TO it_person.

  WRITE 'Before SORT by ID' COLOR 1. NEW-LINE.
  LOOP AT it_person INTO wa_person.
    WRITE: wa_person-id, wa_person-name, wa_person-age.
    NEW-LINE.
  ENDLOOP.

  SKIP.

  PERFORM sort_any_column
    USING
      'ID'
    CHANGING
      it_person.

  WRITE 'After SORT by ID' COLOR 1. NEW-LINE.
  LOOP AT it_person INTO wa_person.
    WRITE: wa_person-id, wa_person-name, wa_person-age.
    NEW-LINE.
  ENDLOOP.

  SKIP.

  PERFORM sort_any_column
    USING
      'NAME'
    CHANGING
      it_person.

  WRITE 'After SORT by NAME' COLOR 1. NEW-LINE.
  LOOP AT it_person INTO wa_person.
    WRITE: wa_person-id, wa_person-name, wa_person-age.
    NEW-LINE.
  ENDLOOP.

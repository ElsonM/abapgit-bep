*&---------------------------------------------------------------------*
*& Report Z_ELSON_DY5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_dy5.

PARAMETER: p_from(30)   TYPE c DEFAULT 'T001L',
           p_where(255) TYPE c DEFAULT 'WERKS = ''0001'' AND LGORT = ''0001'''.

DATA: data_ref TYPE REF TO data.

FIELD-SYMBOLS: <line> TYPE any.

*----------------------------------------------------------------------*
*       CLASS lcl_util DEFINITION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_util DEFINITION.

  PUBLIC SECTION.
    CLASS-METHODS:
      write_struct
        IMPORTING p_struct TYPE any.

ENDCLASS.                           "lcl_util DEFINITION

*----------------------------------------------------------------------*
*       CLASS lcl_util IMPLEMENTATION
*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
CLASS lcl_util IMPLEMENTATION.

  METHOD write_struct.
    FIELD-SYMBOLS: <field> TYPE any.
    WRITE / '('.
    DO.
      ASSIGN COMPONENT sy-index OF STRUCTURE p_struct TO <field>.
      IF sy-subrc <> 0.
        EXIT.
      ENDIF.
      WRITE /4 <field>.
    ENDDO.
    WRITE / ')'.
  ENDMETHOD.                    "write_struct

ENDCLASS.                    "lcl_util IMPLEMENTATION

START-OF-SELECTION.

  CREATE DATA data_ref TYPE (p_from).
  ASSIGN data_ref->* TO <line>.

  SELECT * FROM (p_from) INTO <line> WHERE (p_where).

    CALL METHOD lcl_util=>write_struct
      EXPORTING
        p_struct = <line>.

  ENDSELECT.

*DATA: wa_mara TYPE mara,                            "Another example
*      it_mara TYPE TABLE OF mara.
*
*SELECT SINGLE * FROM mara INTO wa_mara
*  WHERE ersda = '20160510' AND mtart = 'FERT'.
*
*BREAK-POINT.

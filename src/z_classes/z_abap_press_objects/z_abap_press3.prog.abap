*&---------------------------------------------------------------------*
*& Report Z_ABAP_PRESS3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap_press3.

CLASS lcl_string_tokenizer DEFINITION.
  PUBLIC SECTION.
    METHODS:
      constructor IMPORTING iv_string TYPE csequence
                            iv_delimiter TYPE csequence,
      has_more_tokens RETURNING VALUE(rv_result) TYPE abap_bool,
      next_token RETURNING VALUE(rv_token) TYPE string.

  PRIVATE SECTION.
    DATA mt_tokens TYPE string_table.
    DATA mv_index TYPE i.
ENDCLASS.

DATA lo_tokenizer TYPE REF TO lcl_string_tokenizer.
DATA lv_token TYPE string.

CREATE OBJECT lo_tokenizer
  EXPORTING
    iv_string = '09/13/2005'
    iv_delimiter = '/'.

WHILE lo_tokenizer->has_more_tokens( ) EQ abap_true.
  lv_token = lo_tokenizer->next_token( ).
  WRITE:/ lv_token.
ENDWHILE.

*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_string_tokenizer
*&---------------------------------------------------------------------*
*  Text
*----------------------------------------------------------------------*
CLASS lcl_string_tokenizer IMPLEMENTATION.
  METHOD constructor.
    SPLIT iv_string AT iv_delimiter INTO TABLE me->mt_tokens.

    IF lines( me->mt_tokens ) GT 0.
      me->mv_index = 1.
    ELSE.
      me->mv_index = 0.
    ENDIF.
  ENDMETHOD.

  METHOD has_more_tokens.
    IF me->mv_index LE lines( me->mt_tokens ).
      rv_result = abap_true.
    ELSE.
      rv_result = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD next_token.
    READ TABLE me->mt_tokens INDEX me->mv_index INTO rv_token.
    ADD 1 TO me->mv_index.
  ENDMETHOD.
ENDCLASS.               "lcl_subscriber

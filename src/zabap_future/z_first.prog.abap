*&---------------------------------------------------------------------*
*& Report z_first
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_first.

CLASS lcl_laboratory DEFINITION.

  PUBLIC SECTION.

    METHODS: main.

  PRIVATE SECTION.

    METHODS create_monster
      IMPORTING
        id_number_of_heads TYPE i
      RETURNING
        VALUE(r_result)    TYPE i.

ENDCLASS. "Laboratory Definition

CLASS lcl_laboratory IMPLEMENTATION.

  METHOD main.

*   Local Variables
    DATA: monster_number  TYPE i,
        number_of_heads TYPE i.

    monster_number = create_monster( id_number_of_heads = number_of_heads ).

  ENDMETHOD.


  METHOD create_monster.

  ENDMETHOD.

ENDCLASS. "Laboratory Implementation

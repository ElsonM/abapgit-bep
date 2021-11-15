*&---------------------------------------------------------------------*
*& Report z2_second
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z2_second.

CLASS lcl_laboratory DEFINITION.

  PUBLIC SECTION.

    METHODS: main,
             new_monster,
             howl_at_moon,
             get_number_of_skulls RETURNING VALUE(r_result) TYPE i,
             set_number_of_skulls IMPORTING i_number_of_skulls TYPE i.

  PRIVATE SECTION.

    DATA: number_of_skulls TYPE i,
          md_howls TYPE i.

    METHODS derive_monster_sanity
      IMPORTING
        i_monster_madness1 TYPE i.

ENDCLASS.

CLASS lcl_laboratory IMPLEMENTATION.

  METHOD get_number_of_skulls.

    r_result = me->number_of_skulls.

  ENDMETHOD.

  METHOD set_number_of_skulls.
    me->number_of_skulls = i_number_of_skulls.
  ENDMETHOD.

  METHOD new_monster.

  ENDMETHOD.

  METHOD main.

*   Local Variables
    DATA: monster_madness1 TYPE i,
          monster_madness2 TYPE i,
          monster_madness3 TYPE i,
          description1 TYPE string,
          description2 TYPE string,
          description3 TYPE string.

    monster_madness1 = 25.
    monster_madness2 = 50.
    monster_madness3 = 100.

    derive_monster_sanity( monster_madness1 ).
    derive_monster_sanity( monster_madness2 ).
    derive_monster_sanity( monster_madness3 ).

  ENDMETHOD.

  METHOD derive_monster_sanity.


    DATA description1 TYPE string.

*   Derive Monster Sanity
    IF i_monster_madness1 LT 30.
      description1 = 'FAIRLY SANE'.
    ELSEIF i_monster_madness1 GT 90.
      description1 = 'BONKERS'.
    ELSE.
      description1 = 'AVERAGE SANITY'.
    ENDIF.

  ENDMETHOD.

  METHOD howl_at_moon.

    DO md_howls TIMES.
      MESSAGE 'Oooooooooooo' TYPE 'I'.
    ENDDO.

  ENDMETHOD. "howl_at_moon

ENDCLASS.

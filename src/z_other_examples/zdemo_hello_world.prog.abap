*&---------------------------------------------------------------------*
*& Report ZDEMO_HELLO_WORLD
*&---------------------------------------------------------------------*
REPORT zdemo_hello_world.

CLASS demo DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
ENDCLASS.

SELECTION-SCREEN BEGIN OF SCREEN 1100.
PARAMETERS input(12) TYPE c DEFAULT 'Hello World!'.
SELECTION-SCREEN END OF SCREEN 1100.

CLASS demo IMPLEMENTATION.
  METHOD main.

* Selection Screen

    "If addition STARTING AT not used SELECTION SCREEN is not separated
    CALL SELECTION-SCREEN 1100 STARTING AT 5 5.

    IF sy-subrc <> 0.
      LEAVE PROGRAM.
    ENDIF.

* Dynpro
    CALL SCREEN 100.

* Message
    MESSAGE input TYPE 'I'.

* List
    WRITE input.

  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  demo=>main( ).

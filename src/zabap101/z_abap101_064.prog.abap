*&---------------------------------------------------------------------*
*& Report Z_ABAP101_064
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_064.

TYPES: BEGIN OF ty_line,
         comp1 TYPE c LENGTH 10,
         comp2 TYPE string,
         comp3 TYPE c LENGTH 5,
       END OF ty_line.

TYPES: ty_tt_line TYPE TABLE OF ty_line.

*&---------------------------------------------------------------------*
*& Form replace_spaces
*&---------------------------------------------------------------------*
*  Replaces all occurrences of "space" by a "_" (underscore)
*  using field symbols (not work areas).
*----------------------------------------------------------------------*
* --> CH_ITAB text
*----------------------------------------------------------------------*
FORM replace_spaces CHANGING ch_itab TYPE ty_tt_line.

  FIELD-SYMBOLS <line> TYPE ty_line.
  LOOP AT ch_itab ASSIGNING <line>.
    REPLACE ALL OCCURRENCES OF REGEX '\s'          IN <line>-comp1 WITH '_' IN CHARACTER MODE.
    REPLACE ALL OCCURRENCES OF REGEX '[[:space:]]' IN <line>-comp2 WITH '_' IN CHARACTER MODE.
    REPLACE ALL OCCURRENCES OF REGEX '\s'          IN <line>-comp3 WITH '_' IN CHARACTER MODE.
  ENDLOOP.

ENDFORM. " replace_spaces

*&---------------------------------------------------------------------*
*& Form print_itab
*&---------------------------------------------------------------------*
*  Prints internal table contents
*----------------------------------------------------------------------*
* --> US_ITAB text
*----------------------------------------------------------------------*
FORM print_itab USING us_itab TYPE ty_tt_line.

  FIELD-SYMBOLS <line> TYPE ty_line.
  LOOP AT us_itab ASSIGNING <line>.
    WRITE: <line>-comp1 COLOR 1. NEW-LINE.
    WRITE: <line>-comp2 COLOR 2. NEW-LINE.
    WRITE: <line>-comp3 COLOR 3. NEW-LINE.
    WRITE /.
  ENDLOOP.

ENDFORM. " print_itab

START-OF-SELECTION.

  DATA itab TYPE ty_tt_line.
  DATA wa TYPE ty_line.

  wa-comp1 = 'ABAP 101'.
  wa-comp2 = 'One Two Three Four Five Six Seven Eight Nine'.
  wa-comp3 = '12345'.
  APPEND wa TO itab.
  CLEAR wa.

  wa-comp1 = 'ABAP101'.
  wa-comp2 = 'One/Two/Three/Four Five/Six/Seven/Eight/Nine'.
  wa-comp3 = '12 45'.
  APPEND wa TO itab.
  CLEAR wa.

  wa-comp1 = ' '.
  wa-comp2 = 'One/Two/Three/Four+=_-Five/Six/Seven/Eight/Nine'.
  wa-comp3 = ''.
  APPEND wa TO itab.
  CLEAR wa.

  WRITE: 'Before replace'. NEW-LINE.
  PERFORM print_itab
    USING
      itab.

  PERFORM replace_spaces
    CHANGING
      itab.

  WRITE: /, 'After replace'. NEW-LINE.
  PERFORM print_itab
    USING
      itab.

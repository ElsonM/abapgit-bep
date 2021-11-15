*&---------------------------------------------------------------------*
*& Report Z_ELSON_T5
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
PROGRAM z_elson_t5 NO STANDARD PAGE HEADING.

DATA: number LIKE datatype-integer2.
DATA: dummy  LIKE datatype-integer2.
DATA: BEGIN OF cards OCCURS 52 ,
        entry  TYPE i,
        row    TYPE i,
        col    TYPE i,
        vis(1),
      END OF cards.
DATA: card_num TYPE i, suit_num TYPE i, suit(1), card(2), rows TYPE i.
DATA: blank(3) VALUE '***'.
DATA: next-card(4) VALUE 'Next'.
DATA: restart(8) VALUE 'New game'.
DATA: reveal(6) VALUE 'Reveal'.
DATA: test_num   TYPE i, to_num TYPE i, moving_num TYPE i,
      pile_num   TYPE i.
DATA: curr_c TYPE i, curr_h TYPE i, curr_s TYPE i, curr_d TYPE i.
DATA: moving_suit(1), to_suit(1), moving_card(2), to_card(2),
      pile_suit(1), pile_card(2),moving_type(1)    .
DATA: moving_row TYPE i, moving_col TYPE i,
      to_row     TYPE i, to_col TYPE i, test_row TYPE i.
DATA: current_card TYPE i,
      min_card     TYPE i, max_card TYPE i.
DATA: currentfield(50).
DATA: disc_c(3),disc_h(3),disc_s(3),disc_d(3).
DATA: rows_out TYPE i, cols_out TYPE i.


PERFORM shuffle.
PERFORM show_screen.

AT LINE-SELECTION.
  GET CURSOR FIELD currentfield.
  PERFORM process-input.

*---------------------------------------------------------------------*
*       FORM SHUFFLE                                                  *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM shuffle.
  min_card = 3.max_card = 24.
  curr_c = -1.curr_d = -1.curr_h = -1.curr_s = -1.
  disc_c = 'CCC'.disc_h = 'HHH'.disc_s = 'SSS'.disc_d = 'DDD'.
  number = sy-uzeit MOD 1000.
  DO number TIMES.
    CALL FUNCTION 'RANDOM_I2'
      IMPORTING
        rnd_value = dummy.
  ENDDO.
  REFRESH cards. CLEAR cards. sy-tabix = 0.
  WHILE sy-tabix < 52.
*do 40 times.
    CALL FUNCTION 'RANDOM_I2'
      EXPORTING
        rnd_min   = 0
        rnd_max   = 51
      IMPORTING
        rnd_value = number.
    READ TABLE cards WITH KEY number TRANSPORTING NO FIELDS.
    IF sy-subrc <> 0.
      cards-vis = 'n'.
      DESCRIBE TABLE cards LINES rows.
      CASE rows.
        WHEN 0.cards-vis = 'y'.cards-row = 0.cards-col = 0.
        WHEN 7.cards-vis = 'y'.cards-row = 1.cards-col = 1.
        WHEN 13.cards-vis = 'y'.cards-row = 2.cards-col = 2.
        WHEN 18.cards-vis = 'y'.cards-row = 3.cards-col = 3.
        WHEN 22.cards-vis = 'y'.cards-row = 4.cards-col = 4.
        WHEN 25.cards-vis = 'y'.cards-row = 5.cards-col = 5.
        WHEN 27.cards-vis = 'y'.cards-row = 6.cards-col = 6.
        WHEN 28.cards-row = 20.cards-col = 0.
      ENDCASE.
      cards-col = cards-col + 1.
      cards-entry = number.
      APPEND cards.
    ENDIF.
*enddo.
  ENDWHILE.
  current_card = min_card.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM SHOW_SCREEN                                              *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM show_screen.
  rows_out = 1.
  cols_out = 4.
  DO 7 TIMES.
    SKIP TO LINE rows_out.
    POSITION cols_out.
    WRITE blank HOTSPOT.
    cols_out = cols_out + 4.
  ENDDO.
  LOOP AT cards.
    PERFORM make_card.
    IF cards-row < 20.
      rows_out = cards-row + 1.
      SKIP TO LINE rows_out.
      cols_out = cards-col * 4.
      POSITION cols_out.
      IF cards-vis = 'n'.
        WRITE 'XXX' COLOR OFF INTENSIFIED OFF INVERSE OFF.
      ELSE.
        IF suit = 'D' OR suit = 'H'.
          WRITE: suit NO-GAP COLOR 6 INTENSIFIED INVERSE HOTSPOT,
                 card COLOR 6 INTENSIFIED INVERSE HOTSPOT.
        ELSE.
          WRITE: suit NO-GAP COLOR OFF INTENSIFIED OFF INVERSE OFF HOTSPOT,
                card COLOR OFF INTENSIFIED OFF INVERSE OFF HOTSPOT.
        ENDIF.
      ENDIF.
    ELSE.
      SKIP TO LINE 20.      cols_out =  cards-col  * 4.
      IF cols_out > 48.
        SKIP TO LINE 21.
        cols_out = cols_out - 48.
      ENDIF.
      POSITION cols_out.
      IF cards-col = current_card.
        pile_suit = suit.
        pile_card = card.
        pile_num = card_num.
        IF suit = 'D' OR suit = 'H'.
          WRITE: pile_suit NO-GAP COLOR 6 INTENSIFIED INVERSE HOTSPOT,
                 pile_card COLOR 6 INTENSIFIED INVERSE HOTSPOT.
        ELSE.
          WRITE: pile_suit NO-GAP COLOR OFF INTENSIFIED OFF HOTSPOT,
                 pile_card COLOR OFF INTENSIFIED OFF HOTSPOT.
        ENDIF.
      ELSE.
        IF cards-col < current_card.
          WRITE 'XXX' COLOR OFF INTENSIFIED OFF INVERSE OFF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDLOOP.
  SKIP TO LINE 4. POSITION 40.WRITE: disc_c
       COLOR OFF INTENSIFIED OFF INVERSE OFF HOTSPOT.
  SKIP TO LINE 4. POSITION 44. WRITE: disc_d
       COLOR 6 INTENSIFIED INVERSE HOTSPOT.
  SKIP TO LINE 4. POSITION 48. WRITE: disc_s
       COLOR OFF INTENSIFIED OFF INVERSE OFF HOTSPOT.
  SKIP TO LINE 4. POSITION 52. WRITE: disc_h
       COLOR 6 INTENSIFIED INVERSE HOTSPOT.
  IF min_card > 0.
    SKIP TO LINE 23. POSITION 1. WRITE next-card HOTSPOT.
  ENDIF.
  SKIP TO LINE 23. POSITION 20. WRITE restart HOTSPOT.
*  skip to line 23. position 40. write reveal hotspot.
  SKIP TO LINE 25. POSITION 1. WRITE currentfield.
  sy-lsind = 0.
ENDFORM.

*---------------------------------------------------------------------*
*       FORM PROCESS-INPUT                                            *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM process-input.
  IF currentfield = 'NEXT-CARD'.
    IF current_card = max_card.
      current_card = min_card.
    ELSE.
      current_card = current_card + 3.
      IF current_card > max_card.
        current_card = max_card.
      ENDIF.
    ENDIF.
    moving_card = space.
    currentfield = space.
    PERFORM show_screen.
    EXIT.
  ENDIF.
  IF currentfield = 'REVEAL'.
    LOOP AT cards.
      cards-vis =  'y'.
      MODIFY cards.
    ENDLOOP.
    PERFORM show_screen.
    EXIT.
  ENDIF.
  IF currentfield = 'RESTART'.
    PERFORM shuffle.
    currentfield = 'Restarting'.
    PERFORM show_screen.
    EXIT.
  ENDIF.
  IF moving_card = space.
    IF currentfield = 'CARD' OR currentfield = 'SUIT'.
      currentfield = space.
      rows_out = sy-curow - 1.
      cols_out = sy-cucol DIV 4.
      LOOP AT cards.
        IF cards-row = rows_out AND cards-col = cols_out.
          currentfield = 'Moving '.
          PERFORM make_card.
          moving_row = cards-row.
          moving_col = cards-col.
          moving_card = card.
          moving_suit = suit.
          moving_type = 'm'.
          moving_num = card_num.
          currentfield+8(1) = suit.
          currentfield+9(2) = card.
        ENDIF.
      ENDLOOP.
    ELSE.
      IF currentfield = 'PILE_CARD' OR currentfield = 'PILE_SUIT'.
        moving_card = pile_card.
        moving_suit = pile_suit.
        moving_type = 'p'.
        moving_num = pile_num.
        currentfield = 'Moving pile card'.
        currentfield+17(1) = pile_suit.
        currentfield+18(2) = pile_card.
      ELSE.
        currentfield = space.
      ENDIF.
    ENDIF.
  ELSE.
    IF currentfield = 'CARD' OR currentfield = 'SUIT' OR
           currentfield = 'BLANK'.
      rows_out = sy-curow - 1.
      cols_out = sy-cucol DIV 4.
      test_row = -1.
      IF currentfield = 'BLANK'.
        to_col = cols_out.
        to_row = rows_out - 1.
        IF moving_card = 'K'.
          PERFORM move_card.
        ELSE.
          currentfield = 'Can only move K to blank'.
          moving_card = space.
        ENDIF.
      ELSE.
        LOOP AT cards.
          IF ( cards-row >= test_row AND cards-row < 20 )
                 AND cards-col = cols_out.
            test_row = cards-row.
            PERFORM make_card.
            to_col = cards-col.
            to_row = cards-row.
            to_card = card.
            to_suit = suit.
            to_num = card_num.
          ENDIF.
        ENDLOOP.
        IF to_col <> moving_col OR moving_type = 'p'.
          IF
             ( ( moving_suit = 'D' OR moving_suit = 'H' ) AND
               ( to_suit = 'D' OR to_suit = 'H' ) )
           OR
             ( ( moving_suit = 'C' OR moving_suit = 'S' ) AND
               ( to_suit = 'S' OR to_suit = 'S' ) ).
            currentfield = 'Can only put black on red or red on black'.
            moving_card = space.
          ELSE.
            test_num = to_num - 1.
            IF test_num = moving_num.
              PERFORM move_card.
            ELSE.
              currentfield = 'Can only put on next higher card'.
              moving_card = space.
            ENDIF.
          ENDIF.
        ELSE.
          currentfield = 'Can only move to another column'.
          moving_card = space.
        ENDIF.
      ENDIF.
    ELSE.
      IF currentfield(4) = 'DISC'.
        to_suit = currentfield+5(1).
        IF moving_type = 'p'.
        ELSE.
          test_row = -1.
          LOOP AT cards.
            IF cards-col = moving_col AND
                    cards-row > test_row AND cards-row < 20.
              test_row = cards-row.
              PERFORM make_card.
              moving_suit = suit.
              moving_card = card.
              moving_row = cards-row.
              moving_col = cards-col.
              moving_num = card_num.
            ENDIF.
          ENDLOOP.
        ENDIF.
        IF moving_suit = to_suit.
          CASE moving_suit.
            WHEN 'C'. test_num = curr_c + 1.
            WHEN 'H'. test_num = curr_h + 1.
            WHEN 'D'. test_num = curr_d + 1.
            WHEN 'S'. test_num = curr_s + 1.
          ENDCASE.
          IF test_num = moving_num.
            PERFORM discard_card.
            CASE moving_suit.
              WHEN 'C'. curr_c = curr_c + 1.
              WHEN 'D'. curr_d = curr_d + 1.
              WHEN 'S'. curr_s = curr_s + 1.
              WHEN 'H'. curr_h = curr_h + 1.
            ENDCASE.
          ELSE.
            currentfield = 'Can only discard on next lower card'.
            moving_card = space.
          ENDIF.
        ELSE.
          moving_card = space.
          currentfield = 'Can only discard on same suit'.
        ENDIF.
      ELSE.
        moving_card = space.
        currentfield = space.
      ENDIF.
    ENDIF.
  ENDIF.
  PERFORM show_screen.
ENDFORM.
*---------------------------------------------------------------------*
*       FORM MAKE_CARD                                                *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM make_card.
  suit_num = cards-entry DIV 13 .
  CASE suit_num.
    WHEN 0.suit = 'D'.
    WHEN 1.suit = 'H'.
    WHEN 2.suit = 'C'.
    WHEN 3.suit = 'S'.
  ENDCASE.
  card_num = cards-entry MOD 13.
  CASE card_num.
    WHEN 0.card = 'A'.
    WHEN 1.card = '2'.
    WHEN 2.card = '3'.
    WHEN 3.card = '4'.
    WHEN 4.card = '5'.
    WHEN 5.card = '6'.
    WHEN 6.card = '7'.
    WHEN 7.card = '8'.
    WHEN 8.card = '9'.
    WHEN 9.card = '10'.
    WHEN 10.card = 'J'.
    WHEN 11.card = 'Q'.
    WHEN 12.card = 'K'.
  ENDCASE.
ENDFORM.
*---------------------------------------------------------------------*
*       FORM MOVE_CARD                                                *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM move_card.
  IF currentfield <> 'BLANK'.
    currentfield = 'Moving xxx to'.
    MOVE moving_suit TO currentfield+7(1).
    MOVE moving_card TO currentfield+8(2).
    MOVE to_suit TO currentfield+14(1).
    MOVE to_card TO currentfield+15(2).
  ELSE.
    currentfield = 'Starting emtpy column'.
  ENDIF.
  IF moving_type = 'p'.
    MOVE 'from pile' TO currentfield+18.
    LOOP AT cards.
      IF cards-row = 20 AND cards-col = current_card.
        cards-col = to_col.
        cards-row = to_row + 1.
        cards-vis = 'y'.
      ENDIF.
      IF cards-row = 20 AND cards-col > current_card.
        cards-col = cards-col - 1.
      ENDIF.
      MODIFY cards.
    ENDLOOP.
    current_card = current_card - 1.
    max_card = max_card - 1.
    IF max_card < min_card.
      min_card = min_card - 1.
      max_card = min_card.
    ENDIF.
    IF current_card < 1.
      current_card = min_card.
    ENDIF.
  ELSE.
    LOOP AT cards.
      IF cards-col = moving_col AND
       ( cards-row >= moving_row AND cards-row < 20 ).
        cards-col = to_col.
        cards-row = to_row + 1 + cards-row - moving_row.
        MODIFY cards.
      ENDIF.
    ENDLOOP.
    test_row = moving_row - 1.
    LOOP AT cards.
      IF cards-col = moving_col AND cards-row = test_row.
        cards-vis = 'y'.
        MODIFY cards.
      ENDIF.
    ENDLOOP.
  ENDIF.
  moving_card = space.
ENDFORM.
*---------------------------------------------------------------------*
*       FORM DISCARD_CARD                                             *
*---------------------------------------------------------------------*
*       ........                                                      *
*---------------------------------------------------------------------*
FORM discard_card.
  MOVE 'Discarding' TO currentfield.
  MOVE moving_suit TO currentfield+13(1).
  MOVE moving_card TO currentfield+14(2).
  CASE to_suit.
    WHEN 'C'.
      disc_c+1(2) = moving_card.
    WHEN 'D'.
      disc_d+1(2) = moving_card.
    WHEN 'H'.
      disc_h+1(2) = moving_card.
    WHEN 'S'.
      disc_s+1(2) = moving_card.
  ENDCASE.
  IF moving_type = 'p'.
    MOVE 'from pile' TO currentfield+18.
    LOOP AT cards.
      IF cards-row = 20 AND cards-col = current_card.
        cards-col = 0.
      ENDIF.
      IF cards-row = 20 AND cards-col > current_card.
        cards-col = cards-col - 1.
      ENDIF.
      MODIFY cards.
    ENDLOOP.
    current_card = current_card - 1.
    max_card = max_card - 1.
    IF max_card < min_card.
      min_card = min_card - 1.
      max_card = min_card.
    ENDIF.
    IF current_card < 1.
      current_card = min_card.
    ENDIF.
  ELSE.
    LOOP AT cards.
      IF cards-row = moving_row AND cards-col = moving_col.
        cards-col = 0.
        MODIFY cards.
      ENDIF.
    ENDLOOP.
    test_row = moving_row - 1.
    LOOP AT cards.
      IF cards-col = moving_col AND cards-row = test_row.
        cards-vis = 'y'.
        MODIFY cards.
      ENDIF.
    ENDLOOP.
  ENDIF.
  moving_card = space.
ENDFORM.

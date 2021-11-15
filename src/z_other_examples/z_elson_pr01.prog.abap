*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*

REPORT z_elson_pr01.

DATA: gwa_spfli TYPE spfli,
      gt_spfli  TYPE TABLE OF spfli.
SELECT * UP TO 5 ROWS FROM spfli INTO TABLE gt_spfli.

WRITE: 'FIRST VERSION OF THE LOOP - AT FIRST & AT LAST'.

LOOP AT gt_spfli INTO gwa_spfli.

  AT FIRST.
    WRITE: / 'Start of Loop'.
    WRITE: / 'Flight Details'.
    WRITE: / 'Airline Code' COLOR 5, 14 'Connection No.' COLOR 5,
             29 'Departure City' COLOR 5, 44 'Arrival City' COLOR 5.
*    WRITE: / gwa_spfli-carrid, 14 gwa_spfli-connid,
*           29 gwa_spfli-cityfrom, 44 gwa_spfli-cityto.
    ULINE.
  ENDAT.

  WRITE: / gwa_spfli-carrid, 14 gwa_spfli-connid,
           29 gwa_spfli-cityfrom, 44 gwa_spfli-cityto.

  AT LAST.
    ULINE.
*   WRITE: / gwa_spfli-carrid, 14 gwa_spfli-connid,
*           29 gwa_spfli-cityfrom, 44 gwa_spfli-cityto.
    WRITE: / 'End of Loop'.
  ENDAT.

ENDLOOP.

WRITE: /, / 'SECOND VERSION OF THE LOOP - ADDITION OF AT NEW & AT END'.

LOOP AT gt_spfli INTO gwa_spfli.

  AT FIRST.
    WRITE: / 'Start of Loop'.
    WRITE: / 'Flight Details'.
    WRITE: / 'Airline Code' COLOR 5, 14 'Connection No.' COLOR 5,
             29 'Departure City' COLOR 5, 44 'Arrival City' COLOR 5,
             58 'Distance' COLOR 5.
    ULINE.
  ENDAT.

  AT NEW carrid.
    WRITE: / gwa_spfli-carrid, ': New Airline'.
    ULINE.
  ENDAT.

  WRITE: /14 gwa_spfli-connid, 29 gwa_spfli-cityfrom,
          44 gwa_spfli-cityto, 58 gwa_spfli-distance.

  AT END OF carrid.
    ULINE.
    WRITE: / 'End of Airline:', gwa_spfli-carrid.
    ULINE.
  ENDAT.

  AT LAST.
    WRITE: / 'End of Loop'.
  ENDAT.

ENDLOOP.

WRITE: /, / 'THIRD VERSION OF THE LOOP - SUM'.

LOOP AT gt_spfli INTO gwa_spfli.

  AT FIRST.
    WRITE: / 'Start of Loop'.
    WRITE: / 'Flight Details'.
    WRITE: / 'Airline Code' COLOR 5, 14 'Connection No.' COLOR 5,
             29 'Departure City' COLOR 5, 44 'Arrival City' COLOR 5,
             58 'Distance' COLOR 5.
    ULINE.
  ENDAT.

  AT NEW carrid.
    WRITE: / gwa_spfli-carrid, ': New Airline'.
    ULINE.
  ENDAT.

  WRITE: /14 gwa_spfli-connid, 29 gwa_spfli-cityfrom,
          44 gwa_spfli-cityto, 58 gwa_spfli-distance.

  AT END OF carrid.
    ULINE.
    SUM.
    WRITE: / 'End of Airline:', gwa_spfli-carrid, 58 gwa_spfli-distance.
    ULINE.
  ENDAT.

  AT LAST.
    SUM.
    WRITE: / 'Total', 58 gwa_spfli-distance.
    WRITE: / 'End of Loop'.
  ENDAT.

ENDLOOP.

WRITE: /, / 'FOURTH VERSION OF THE LOOP - Using ON CHANGE OF'.

LOOP AT gt_spfli INTO gwa_spfli.

  AT FIRST.
    WRITE: / 'Start of Loop'.
    WRITE: / 'Flight Details'.
    WRITE: / 'Airline Code' COLOR 5, 14 'Connection No.' COLOR 5,
             29 'Departure City' COLOR 5, 44 'Arrival City' COLOR 5,
             58 'Distance' COLOR 5.
  ENDAT.

  ON CHANGE OF gwa_spfli-carrid.
    ULINE.
    WRITE: / gwa_spfli-carrid, ': New Airline'.
    ULINE.
  ENDON.

  WRITE: /14 gwa_spfli-connid, 29 gwa_spfli-cityfrom,
          44 gwa_spfli-cityto, 58 gwa_spfli-distance.

  AT LAST.
    WRITE: / 'End of Loop'.
  ENDAT.

ENDLOOP.

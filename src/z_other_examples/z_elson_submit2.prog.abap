*&---------------------------------------------------------------------*
*& Report Z_ELSON_SUBMIT2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_submit2.

DATA: it_mara TYPE TABLE OF mara.

START-OF-SELECTION.

  SELECT * INTO TABLE it_mara FROM mara UP TO 10 ROWS.
  EXPORT it_mara TO MEMORY ID 'YOURID'.
  SUBMIT z_elson_submit1 AND RETURN.

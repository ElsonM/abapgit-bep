*&---------------------------------------------------------------------*
*& Report Z_ELSON_T17_DET_LIST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t17_det_list.

START-OF-SELECTION.
  WRITE: / TEXT-Z01,
         / 'sy-lsind:', sy-lsind.

AT LINE-SELECTION.
  CASE sy-lsind.
    WHEN 1.
      WRITE: / TEXT-z02,
             / 'sy-lsind:', sy-lsind.
    WHEN 2.
      WRITE: / TEXT-z03,
             / 'sy-lsind:', sy-lsind.
    WHEN OTHERS.
  ENDCASE.

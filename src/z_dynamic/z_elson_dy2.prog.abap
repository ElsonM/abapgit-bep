*&---------------------------------------------------------------------*
*& Report Z_ELSON_DY2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_dy2.

DATA: tabname  TYPE tabname,
      count    TYPE i.

START-OF-SELECTION.
  WRITE: / 'EBAN', / 'MARA', / 'VBAK'.

AT LINE-SELECTION.
  READ CURRENT LINE LINE VALUE INTO tabname.
  SELECT COUNT(*) FROM (tabname) INTO count.
  WRITE: 'The table', tabname(7), 'contains', count, 'entries.'.

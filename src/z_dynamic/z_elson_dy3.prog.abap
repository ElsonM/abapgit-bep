*&---------------------------------------------------------------------*
*& Report Z_ELSON_DY3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_dy3.

DATA: tabname TYPE        tabname,
      dref    TYPE REF TO data,
      alv     TYPE REF TO cl_gui_alv_grid.

FIELD-SYMBOLS: <itab> TYPE ANY TABLE.

START-OF-SELECTION.
  WRITE: / 'EBAN', / 'MARA', / 'VBAK'.

AT LINE-SELECTION.
  READ CURRENT LINE LINE VALUE INTO tabname.

* Dynamically create appropriate internal table
  CREATE DATA dref TYPE TABLE OF (tabname).
  ASSIGN dref->* TO <itab>.

* Fetch the data
  SELECT *
    FROM (tabname) up to 100 rows
    INTO TABLE <itab>.

* Display the result
  CREATE OBJECT alv
    EXPORTING
      i_parent = cl_gui_container=>screen0.

  CALL METHOD alv->set_table_for_first_display
    EXPORTING
      i_structure_name = tabname
    CHANGING
      it_outtab        = <itab>.

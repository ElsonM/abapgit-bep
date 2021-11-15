*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_17
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_17.

DATA: lo_cont TYPE REF TO cl_gui_custom_container. "Custom Container
DATA: lo_alv TYPE REF TO cl_gui_alv_grid.          "ALV Grid
DATA: it_mara TYPE TABLE OF mara.                  "MARA internal table

START-OF-SELECTION.
* Here 100 is the screen number which we are going to create, you can create any like: 200, 300 etc
  CALL SCREEN 100. "Double click on 100 to create a screen

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  CREATE OBJECT lo_cont
    EXPORTING
      container_name = 'CC_ALV' "Container name whcih we have created
.
* Create Object for ALV Grid
  CREATE OBJECT lo_alv
    EXPORTING
      i_parent = lo_cont. "Object of custom container

* Get data from MARA
  SELECT * FROM mara INTO TABLE it_mara UP TO 100 ROWS.

* Display ALV data using structure
  CALL METHOD lo_alv->set_table_for_first_display
    EXPORTING
      i_structure_name = 'MARA'
    CHANGING
      it_outtab        = it_mara.
ENDMODULE.

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

ENDMODULE.

*&---------------------------------------------------------------------*
*&  Include           Z_ELSON_ALV_2_O01
*&---------------------------------------------------------------------*

MODULE status_0100 OUTPUT.

  SET PF-STATUS 'STATUS_0100'.
  SET TITLEBAR  'TITLE_0100'.

  IF grid_container1 IS INITIAL.

    PERFORM instantiate_grid
       USING grid_container1
             grid1
             'CCONTAINER1'.
  ENDIF.

ENDMODULE.

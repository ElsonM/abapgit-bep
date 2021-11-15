*&---------------------------------------------------------------------*
*&  Include           Z_ALV_VBAP_O01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_0100  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_0100 OUTPUT.

  SET PF-STATUS 'GUI_0100'.
  SET TITLEBAR 'TITLE_0100'.

  IF g_custom_container IS INITIAL.

    " Create CONTAINER object with reference to container name in the screen
    CREATE OBJECT g_custom_container
      EXPORTING
        container_name = g_container.

    " Create GRID object with reference to parent name
    CREATE OBJECT g_grid
      EXPORTING
        i_parent = g_custom_container.

    PERFORM u_prepare_fieldcatalog.
    gs_layout-zebra = 'X'.
    "gs_layout-edit = 'X'. " Makes all Grid editable

    " SET_TABLE_FOR_FIRST_DISPLAY
    CALL METHOD g_grid->set_table_for_first_display
      EXPORTING
        is_layout       = gs_layout
      CHANGING
        it_fieldcatalog = gt_fieldcatalog
        it_outtab       = gt_item. " Data

  ELSE.

    CALL METHOD g_grid->refresh_table_display.

  ENDIF.

ENDMODULE.

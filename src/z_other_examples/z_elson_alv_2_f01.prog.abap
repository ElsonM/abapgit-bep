*&---------------------------------------------------------------------*
*&  Include           Z_ELSON_ALV_2_F01
*&---------------------------------------------------------------------*

FORM select_all_rows.

  DESCRIBE TABLE <dyn_table> LINES t_size.
  t_index = 1.

  WHILE t_index LE t_size.
    CLEAR wa_rows.
    wa_rows-row_id = t_index.
    APPEND wa_rows TO it_rows.
    t_index = t_index + 1.
  ENDWHILE.

  CALL METHOD grid1->set_selected_rows
    EXPORTING
      it_row_no = it_rows.

ENDFORM.


FORM deselect_all_rows.

  t_index = 1.

  REFRESH it_rows.
  CLEAR wa_rows.

  wa_rows-row_id = t_index.
  APPEND wa_rows TO it_rows.

  CALL METHOD grid1->set_selected_rows
    EXPORTING
      it_row_no = it_rows.

ENDFORM.


FORM double_click
USING e_row   TYPE lvc_s_row
e_column      TYPE lvc_s_col.
  READ TABLE <dyn_table> INDEX e_row INTO wa_elements.

  CASE e_column-fieldname.
    WHEN 'MATNR'.
      mat_nr = wa_elements-matnr.
      SET PARAMETER ID 'MAT'  FIELD mat_nr.
      CALL TRANSACTION  'MM03' AND SKIP FIRST SCREEN.
    WHEN 'KUNNR'.
      cus_nr = wa_elements-kunnr.
      SET PARAMETER ID 'KUN'  FIELD cus_nr.
      CALL TRANSACTION  'XD03' AND SKIP FIRST SCREEN.
    WHEN OTHERS.
  ENDCASE.
  wa_elements-status = 'V'.
  MODIFY <dyn_table> FROM wa_elements INDEX e_row.

ENDFORM.

FORM mouse_click
  USING e_row TYPE lvc_s_row
        e_column_id TYPE  lvc_s_col.
  READ TABLE <dyn_table> INDEX e_row INTO wa_elements.


  ord_nr = wa_elements-vbeln.
  SET PARAMETER ID 'AUN'  FIELD ord_nr.

  CALL TRANSACTION  'VA03' AND SKIP FIRST SCREEN.
  wa_elements-status = 'V'.
  MODIFY <dyn_table> FROM wa_elements INDEX e_row.

ENDFORM.

FORM data_changed
  USING er_data_changed.

  BREAK-POINT 1.
ENDFORM.
FORM data_changed_finished.


  BREAK-POINT 1.
ENDFORM.


FORM instantiate_grid
   USING  grid_container TYPE REF TO cl_gui_custom_container
          class_object   TYPE REF TO cl_gui_alv_grid
          container_name TYPE        scrfname.

  CREATE OBJECT grid_container
    EXPORTING
      container_name = container_name.

  CREATE OBJECT class_object
    EXPORTING
      i_parent = grid_container.

  struct_grid_lset-sel_mode = 'D'.

  CREATE OBJECT g_handler.

  SET HANDLER g_handler->handle_double_click          FOR class_object.
  SET HANDLER g_handler->handle_hotspot_click         FOR class_object.
  SET HANDLER g_handler->handle_toolbar               FOR class_object.
  SET HANDLER g_handler->handle_user_command          FOR class_object.
  SET HANDLER g_handler->handle_data_changed          FOR class_object.
  SET HANDLER g_handler->handle_data_changed_finished FOR class_object.

  CALL METHOD class_object->register_edit_event
    EXPORTING
      i_event_id = cl_gui_alv_grid=>mc_evt_enter.

  CALL METHOD class_object->set_table_for_first_display
    EXPORTING
      is_layout       = struct_grid_lset
    CHANGING
      it_outtab       = <dyn_table>
      it_fieldcatalog = it_fldcat.

ENDFORM.

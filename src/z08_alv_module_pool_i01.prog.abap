*&---------------------------------------------------------------------*
*&  Include           Z08_ALV_MODULE_POOL_I01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9001  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9001 INPUT.

  IF ok_code_sel IS NOT INITIAL.
    CASE ok_code_sel.
      WHEN 'BACK'.
        LEAVE PROGRAM.
      WHEN 'EXIT'.
        LEAVE PROGRAM.
      WHEN 'CANCEL'.
        LEAVE PROGRAM.
      WHEN 'DISP'.
        PERFORM display_project_wbs.
      WHEN 'CLR'.
        PERFORM clear_screen.
    ENDCASE.
  ENDIF.

ENDMODULE.                 " USER_COMMAND_9001  INPUT

*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_9002  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_9002 INPUT.

  IF ok_code_pro IS NOT INITIAL.
    CASE ok_code_pro.
      WHEN 'BACK'.
        PERFORM leave_alv.
      WHEN 'EXIT'.
        PERFORM leave_alv.
      WHEN 'CANCEL'.
        PERFORM leave_alv.
    ENDCASE.
  ENDIF.

ENDMODULE.                 " USER_COMMAND_9002  INPUT

*&---------------------------------------------------------------------*
*&      Form  FCAT_PROJ
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fcat_proj.

  CLEAR   wa_fcat_proj.
  REFRESH it_fcat_proj.

  DATA lv_col TYPE i.

  lv_col                 = 1 + lv_col.
  wa_fcat_proj-col_pos   = lv_col.
  wa_fcat_proj-fieldname = 'PSPNR'.
  wa_fcat_proj-tabname   = 'IT_PROJ'.
  wa_fcat_proj-reptext   = 'Project Definition (Internal)'.
  APPEND wa_fcat_proj TO it_fcat_proj.
  CLEAR  wa_fcat_proj.

  lv_col                 = 1 + lv_col.
  wa_fcat_proj-col_pos   = lv_col.
  wa_fcat_proj-fieldname = 'PSPID'.
  wa_fcat_proj-tabname   = 'IT_PROJ'.
  wa_fcat_proj-reptext   = 'Project Definition'.
  APPEND wa_fcat_proj TO it_fcat_proj.
  CLEAR  wa_fcat_proj.

  lv_col                 = 1 + lv_col.
  wa_fcat_proj-col_pos   = lv_col.
  wa_fcat_proj-fieldname = 'OBJNR'.
  wa_fcat_proj-tabname   = 'IT_PROJ'.
  wa_fcat_proj-reptext   = 'Object Number'.
  APPEND wa_fcat_proj TO it_fcat_proj.
  CLEAR  wa_fcat_proj.

  lv_col                 = 1 + lv_col.
  wa_fcat_proj-col_pos   = lv_col.
  wa_fcat_proj-fieldname = 'ERNAM'.
  wa_fcat_proj-tabname   = 'IT_PROJ'.
  wa_fcat_proj-reptext   = 'Name'.
  APPEND wa_fcat_proj TO it_fcat_proj.
  CLEAR  wa_fcat_proj.

  lv_col                 = 1 + lv_col.
  wa_fcat_proj-col_pos   = lv_col.
  wa_fcat_proj-fieldname = 'ERDAT'.
  wa_fcat_proj-tabname   = 'IT_PROJ'.
  wa_fcat_proj-reptext   = 'Date'.
  APPEND wa_fcat_proj TO it_fcat_proj.
  CLEAR  wa_fcat_proj.

  lv_col                 = 1 + lv_col.
  wa_fcat_proj-col_pos   = lv_col.
  wa_fcat_proj-fieldname = 'VBUKR'.
  wa_fcat_proj-tabname   = 'IT_PROJ'.
  wa_fcat_proj-reptext   = 'Comapany Code'.
  APPEND wa_fcat_proj TO it_fcat_proj.
  CLEAR  wa_fcat_proj.

  lv_col                 = 1 + lv_col.
  wa_fcat_proj-col_pos   = lv_col.
  wa_fcat_proj-fieldname = 'VGSBR'.
  wa_fcat_proj-tabname   = 'IT_PROJ'.
  wa_fcat_proj-reptext   = 'Business Area'.
  APPEND wa_fcat_proj TO it_fcat_proj.
  CLEAR  wa_fcat_proj.

  lv_col                 = 1 + lv_col.
  wa_fcat_proj-col_pos   = lv_col.
  wa_fcat_proj-fieldname = 'VKOKR'.
  wa_fcat_proj-tabname   = 'IT_PROJ'.
  wa_fcat_proj-reptext   = 'Controlling Area'.
  APPEND wa_fcat_proj TO it_fcat_proj.
  CLEAR  wa_fcat_proj.

ENDFORM.                    " FCAT_PROJ

*&---------------------------------------------------------------------*
*&      Form  FCAT_PRPS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fcat_prps.

  CLEAR   wa_fcat_prps.
  REFRESH it_fcat_prps.

  DATA lv_col TYPE i VALUE 0.

  lv_col                 = 1 + lv_col.
  wa_fcat_prps-col_pos   = lv_col.
  wa_fcat_prps-fieldname = 'PSPNR'.
  wa_fcat_prps-tabname   = 'IT_PRPS'.
  wa_fcat_prps-reptext   = 'WBS Element'.
  APPEND wa_fcat_prps TO it_fcat_prps.
  CLEAR  wa_fcat_prps.

  lv_col                 = 1 + lv_col.
  wa_fcat_prps-col_pos   = lv_col.
  wa_fcat_prps-fieldname = 'POSID'.
  wa_fcat_prps-tabname   = 'IT_PRPS'.
  wa_fcat_prps-reptext   = 'WBS Element'.
  APPEND wa_fcat_prps TO it_fcat_prps.
  CLEAR  wa_fcat_prps.

  lv_col                 = 1 + lv_col.
  wa_fcat_prps-col_pos   = lv_col.
  wa_fcat_prps-fieldname = 'PSPHI'.
  wa_fcat_prps-tabname   = 'IT_PRPS'.
  wa_fcat_prps-reptext   = 'Project Definition'.
  APPEND wa_fcat_prps TO it_fcat_prps.
  CLEAR  wa_fcat_prps.

  lv_col                 = 1 + lv_col.
  wa_fcat_prps-col_pos   = lv_col.
  wa_fcat_prps-fieldname = 'POSKI'.
  wa_fcat_prps-tabname   = 'IT_PRPS'.
  wa_fcat_prps-reptext   = 'WBS Identification'.
  APPEND wa_fcat_prps TO it_fcat_prps.
  CLEAR  wa_fcat_prps.

  lv_col                 = 1 + lv_col.
  wa_fcat_prps-col_pos   = lv_col.
  wa_fcat_prps-fieldname = 'PBUKR'.
  wa_fcat_prps-tabname   = 'IT_PRPS'.
  wa_fcat_prps-reptext   = 'WBS Company Code'.
  APPEND wa_fcat_prps TO it_fcat_prps.
  CLEAR  wa_fcat_prps.

  lv_col                 = 1 + lv_col.
  wa_fcat_prps-col_pos   = lv_col.
  wa_fcat_prps-fieldname = 'PGSBR'.
  wa_fcat_prps-tabname   = 'IT_PRPS'.
  wa_fcat_prps-reptext   = 'WBS Business Area'.
  APPEND wa_fcat_prps TO it_fcat_prps.
  CLEAR  wa_fcat_prps.

  lv_col                 = 1 + lv_col.
  wa_fcat_prps-col_pos   = lv_col.
  wa_fcat_prps-fieldname = 'PKOKR'.
  wa_fcat_prps-tabname   = 'IT_PRPS'.
  wa_fcat_prps-reptext   = 'WBS Controlling Area'.
  APPEND wa_fcat_prps TO it_fcat_prps.
  CLEAR  wa_fcat_prps.

ENDFORM.                    " FCAT_PRPS

*&---------------------------------------------------------------------*
*&      Form  LEAVE_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM leave_alv.

  "Calling method to refresh the ALV Grid with Container
  "Refresh_table_display refreshes the ALV Grid
  "FREE clears the Custom Container to generate new records
  CALL METHOD: obj_grid_proj->refresh_table_display, "FREE - another method
               obj_grid_prps->refresh_table_display, "FREE - another method

               obj_cust_proj->free,
               obj_cust_prps->free.

  CLEAR: s_pspid, p_vbukr.
  REFRESH: it_proj, it_prps, s_pspid[],
           it_fcat_proj, it_fcat_prps.
  CLEAR: ok_code_sel, ok_code_pro.

  LEAVE TO SCREEN 0.

ENDFORM.                    " LEAVE_ALV

*&---------------------------------------------------------------------*
*&      Form  CREATE_OBJECT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM create_object.

  CLEAR: obj_cust_proj, obj_cust_prps,
         obj_grid_proj, obj_grid_prps.

  "Creating the Container object for Header PROJ
  CREATE OBJECT obj_cust_proj
    EXPORTING
      container_name = 'CONT_PROJ'.

  "Creating the Container object for Item PRPS
  CREATE OBJECT obj_cust_prps
    EXPORTING
      container_name = 'CONT_PRPS'.

  "Creating the ALV Grid Object for Header PROJ
  CREATE OBJECT obj_grid_proj
    EXPORTING
      i_parent = obj_cust_proj.

  "Creating the ALV Grid Object for Item PRPS
  CREATE OBJECT obj_grid_prps
    EXPORTING
      i_parent = obj_cust_prps.

ENDFORM.                    " CREATE_OBJECT

*&---------------------------------------------------------------------*
*&      Form  GRID_METHOD
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM grid_method.

  PERFORM fcat_proj.  "Field Catalog for PROJ
  PERFORM alv_layout. "ALV Layout

  CALL METHOD obj_grid_proj->set_table_for_first_display
    EXPORTING
*      i_buffer_active               =
*      i_bypassing_buffer            =
*      i_consistency_check           =
*      i_structure_name              =
*      is_variant                    =
*      i_save                        =
*      i_default                     = 'x'
       is_layout                     = wa_layout
*      is_print                      =
*      it_special_groups             =
*      it_toolbar_excluding          =
*      it_hyperlink                  =
*      it_alv_graphics               =
*      it_except_qinfo               =
*      ir_salv_adapter               =
    CHANGING
       it_outtab                     = it_proj
       it_fieldcatalog               = it_fcat_proj
*      it_sort                       =
*      it_filter                     =
     EXCEPTIONS
       invalid_parameter_combination = 1
       program_error                 = 2
       too_many_lines                = 3
       OTHERS                        = 4.

  PERFORM fcat_prps. "Field Catalog for PRPS

  CALL METHOD obj_grid_prps->set_table_for_first_display
    EXPORTING
*      i_buffer_active               =
*      i_bypassing_buffer            =
*      i_consistency_check           =
*      i_structure_name              =
*      is_variant                    =
*      i_save                        =
*      i_default                     = 'x'
       is_layout                     = wa_layout
*      is_print                      =
*      it_special_groups             =
*      it_toolbar_excluding          =
*      it_hyperlink                  =
*      it_alv_graphics               =
*      it_except_qinfo               =
*      ir_salv_adapter               =
    CHANGING
       it_outtab                     = it_prps
       it_fieldcatalog               = it_fcat_prps
*      it_sort                       =
*      it_filter                     =
     EXCEPTIONS
       invalid_parameter_combination = 1
       program_error                 = 2
       too_many_lines                = 3
       OTHERS                        = 4.

ENDFORM.                    " GRID_METHOD

*&---------------------------------------------------------------------*
*&      Form  ALV_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_layout.

  wa_layout-zebra      = 'X'.
  wa_layout-cwidth_opt = 'X'.
  wa_layout-sel_mode   = 'X'.

ENDFORM.                    " ALV_LAYOUT

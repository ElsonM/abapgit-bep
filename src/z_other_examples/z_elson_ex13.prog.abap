**&---------------------------------------------------------------------*
**& Report Z_ELSON_EX13
**&---------------------------------------------------------------------*
**&
**&---------------------------------------------------------------------*
REPORT z_elson_ex13.
*
*Types: begin of lt_io.
*include structure mara. " Your Structure
*Types: style_table type lvc_t_style.
*Types: end of lt_io.
*
*data: lt_io type table of lt_io,
*ls_layout type lvc_s_layo,
*lt_fcat type lvc_t_fcat,
*lo_grid type ref to cl_gui_alv_grid.
*
*field-symbols: <io> type lt_io,
*<fcat> type lvc_s_fcat.
*
*... fill your output table ....
*
*ls_layout-stylefname = 'STYLE_TABLE'.
*
*loop at lt_io assigning <io>.
*PERFORM set_style USING 'CHECKBOX' "Your Filename
*CHANGING <io>.
*endloop.
*
**... Fill Your Field Catalog lt_fcat
*
*read table lt_fcat assigning <fcat>
* with key fieldname = 'CHECKBOX'.
*<fcat>-checkbox = 'X'.
*
**...
***create grid control lo_grid.
**...
*CALL METHOD lo_grid->set_table_for_first_display
*EXPORTING
*is_layout = ls_layout
*CHANGING
*it_fieldcatalog = lt_fcat
*it_outtab = lt_io[].
*
**...
*
*FORM set_button_to_line
*USING iv_fieldname TYPE lvc_fname
*CHANGING cs_io TYPE io.
*
*DATA: ls_style TYPE lvc_s_styl,
*lt_style TYPE lvc_t_styl.
*
*ls_style-fieldname = iv_fieldname.
*if cs_io-checkbox = ' '.
*ls_style-style = cl_gui_alv_grid=>mc_style_enabled.
*else.
*ls_style-style = cl_gui_alv_grid=>mc_style_disabled.
*endif.
*ls_style-maxlen = 2.
*INSERT ls_style INTO TABLE io-style_table.
*
*ENDFORM. "set_icon_to_status_line

*&---------------------------------------------------------------------*
*&  Include           Z_ELSON_ALV_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM display_alv.

  DATA ls_variant TYPE disvariant.

  IF gr_alvgrid IS INITIAL.
*-- Creating custom container instance
    CREATE OBJECT gr_ccontainer
      EXPORTING
        container_name              = gc_custom_control_name
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.

    IF sy-subrc <> 0.
      "Exception handling
    ENDIF.

*-- Creating ALV Grid instance
    CREATE OBJECT gr_alvgrid
      EXPORTING
        i_parent          = gr_ccontainer
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.

    IF sy-subrc <> 0.
      "Exception handling
    ENDIF.

    ls_variant-report = sy-repid.

*-- Preparing field catalog.
*   PERFORM prepare_field_catalog CHANGING gt_fieldcat.

    PERFORM prepare_field_catalog_semi CHANGING gt_fieldcat.

*-- Preparing layout structure
    PERFORM prepare_layout       CHANGING gs_layout.
    PERFORM prepare_filter_table CHANGING gt_filt.
    PERFORM exclude_tb_functions CHANGING gt_exclude.
    PERFORM prepare_sort_table       CHANGING gt_sort.
    PERFORM prepare_hyperlinks_table CHANGING gt_hype.

*-- Here will be additional preparations
*-- e.g. initial sorting criteria, initial filtering criteria, excluding
*-- functions

    CALL METHOD gr_alvgrid->set_table_for_first_display
      EXPORTING
*       I_BUFFER_ACTIVE               =
*       I_CONSISTENCY_CHECK           =
*       I_STRUCTURE_NAME              =
        is_variant                    = ls_variant
        i_save                        = 'X'
*       I_DEFAULT                     = 'X'
        is_layout                     = gs_layout
*       IS_PRINT                      =
*       IT_SPECIAL_GROUPS             =
        it_toolbar_excluding          = gt_exclude
        it_hyperlink                  = gt_hype
      CHANGING
        it_outtab                     = gt_list
        it_fieldcatalog               = gt_fieldcat
*       it_sort                       = gt_sort
        it_filter                     = gt_filt
      EXCEPTIONS
        invalid_parameter_combination = 1
        program_error                 = 2
        too_many_lines                = 3
        OTHERS                        = 4.

    IF sy-subrc <> 0.
      "Exception handling
    ENDIF.
  ELSE.
    CALL METHOD gr_alvgrid->refresh_table_display
*     EXPORTING
*       IS_STABLE =
*       I_SOFT_REFRESH =
      EXCEPTIONS
        finished = 1
        OTHERS   = 2.

    IF sy-subrc <> 0.
      "Exception handling
    ENDIF.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PREPARE_FIELD_CATALOG
*&---------------------------------------------------------------------*

FORM prepare_field_catalog CHANGING pt_fieldcat TYPE lvc_t_fcat.

  DATA ls_fcat TYPE lvc_s_fcat.

  ls_fcat-fieldname = 'CARRID'.
  ls_fcat-inttype   = 'C'.
  ls_fcat-outputlen = '3'.
  ls_fcat-coltext   = 'Carrier ID'.
  ls_fcat-seltext   = 'Carrier ID'.
*  ls_fcat-no_out    = 'X'.
*  ls_fcat-emphasize = 'X'.
  APPEND ls_fcat TO pt_fieldcat.

  CLEAR ls_fcat .

  ls_fcat-fieldname = 'CONNID'.
  ls_fcat-ref_table = 'SFLIGHT'.
  ls_fcat-ref_table = 'CONNID'.
  ls_fcat-outputlen = '3'.
  ls_fcat-coltext   = 'Connection ID'.
  ls_fcat-seltext   = 'Connection ID'.
  APPEND ls_fcat TO pt_fieldcat.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PREPARE_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GS_LAYOUT  text
*----------------------------------------------------------------------*
FORM prepare_layout CHANGING ps_layout TYPE lvc_s_layo.

*  ps_layout-smalltitle = 'X'.
*  ps_layout-grid_title = 'Grid Title'.
*  ps_layout-no_headers = 'X'.
  ps_layout-cwidth_opt = 'X'.
  ps_layout-zebra      = 'X'.
  ps_layout-grid_title = 'Flights'.
  ps_layout-smalltitle = 'X'.

ENDFORM. " prepare_layout

*&---------------------------------------------------------------------*
*&      Form  PREPARE_FIELD_CATALOG_SEMI
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FIELDCAT  text
*----------------------------------------------------------------------*
FORM prepare_field_catalog_semi CHANGING pt_fieldcat TYPE lvc_t_fcat.

  DATA ls_fcat TYPE lvc_s_fcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = 'SFLIGHT'
    CHANGING
      ct_fieldcat            = pt_fieldcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.

  IF sy-subrc <> 0.
    "Exception handling
  ENDIF.

  LOOP AT pt_fieldcat INTO ls_fcat.
    CASE ls_fcat-fieldname.
      WHEN 'CARRID'.
        ls_fcat-outputlen = '10'.
        ls_fcat-coltext   = 'Airline Carrier ID'.
        ls_fcat-web_field = 'CARRID_HANDLE'.
        MODIFY pt_fieldcat FROM ls_fcat.
      WHEN 'PAYMENTSUM'.
        ls_fcat-no_out = 'X'.
        MODIFY pt_fieldcat FROM ls_fcat.
      WHEN 'CONNID'.
        ls_fcat-web_field = 'CONNID_HANDLE'.
        MODIFY pt_fieldcat FROM ls_fcat.
    ENDCASE.
  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  EXCLUDE_TB_FUNCTIONS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_EXCLUDE  text
*----------------------------------------------------------------------*
FORM exclude_tb_functions CHANGING pt_exclude TYPE ui_functions.

  DATA ls_exclude TYPE ui_func.

  ls_exclude = cl_gui_alv_grid=>mc_fc_maximum.
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_minimum.
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_subtot.
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_sum.
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_fc_average.
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_mb_sum.
  APPEND ls_exclude TO pt_exclude.

  ls_exclude = cl_gui_alv_grid=>mc_mb_subtot.
  APPEND ls_exclude TO pt_exclude.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PREPARE_SORT_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_SORT  text
*----------------------------------------------------------------------*
FORM prepare_sort_table CHANGING pt_sort TYPE lvc_t_sort.

  DATA ls_sort TYPE lvc_s_sort.

  ls_sort-spos      = '1'.
  ls_sort-fieldname = 'CARRID'.
  ls_sort-up        = 'X'.      "A to Z
  ls_sort-down      = space.
  APPEND ls_sort TO pt_sort .

  ls_sort-spos      = '2'.
  ls_sort-fieldname = 'SEATSOCC'.
  ls_sort-up        = space.
  ls_sort-down      = 'X' .     "Z to A
  APPEND ls_sort TO pt_sort .

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  FETCH_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM fetch_table.

  SELECT * FROM sflight INTO TABLE gt_list.

  LOOP AT gt_list INTO gs_list.

    gs_list-carrid_handle = '1'.
    gs_list-connid_handle = '2'.
    MODIFY gt_list FROM gs_list.

  ENDLOOP.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PREPARE_FILTER_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_FILT  text
*----------------------------------------------------------------------*
FORM prepare_filter_table CHANGING pt_filt TYPE lvc_t_filt.

  DATA ls_filt TYPE lvc_s_filt .

  ls_filt-fieldname = 'FLDATE' .
  ls_filt-sign      = 'I' .
  ls_filt-option    = 'BT' .
  ls_filt-low       = '20171031'.
  ls_filt-high      = '20180108'.
  APPEND ls_filt TO pt_filt .

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  PREPARE_HYPERLINKS_TABLE
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      <--P_GT_HYPE  text
*----------------------------------------------------------------------*
FORM prepare_hyperlinks_table CHANGING pt_hype TYPE lvc_t_hype.

  DATA ls_hype TYPE lvc_s_hype.

  ls_hype-handle = '1'.
  ls_hype-href   = 'https://translate.google.com/' .
  APPEND ls_hype TO pt_hype.

  ls_hype-handle = '2'.
  ls_hype-href   = 'https://www.google.com/'.
  APPEND ls_hype TO pt_hype.

  ls_hype-handle = '3'.
  ls_hype-href   = 'http://www.company.com/carrids/car1' .
  APPEND ls_hype TO pt_hype.

  ls_hype-handle = '4'.
  ls_hype-href   = 'http://www.company.com/connids/con11' .
  APPEND ls_hype TO pt_hype.

  ls_hype-handle = '5'.
  ls_hype-href   = 'http://www.company.com/connids/con12' .
  APPEND ls_hype TO pt_hype.

ENDFORM.

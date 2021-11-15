*&---------------------------------------------------------------------*
*& Report ZELSON_DYNAMIC
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zelson_dynamic.

FIELD-SYMBOLS: <fs_table> TYPE STANDARD TABLE,
               <fs_wa>,
               <fs_field>.

DATA: dyn_table   TYPE REF TO data,
      dyn_line    TYPE REF TO data,

      wa_fieldcat TYPE lvc_s_fcat,
      it_fieldcat TYPE lvc_t_fcat.

*ALV data declarations
DATA: fieldcatalog TYPE slis_t_fieldcat_alv WITH HEADER LINE,
      gd_tab_group TYPE slis_t_sp_group_alv,
      gd_layout    TYPE slis_layout_alv,
      gd_repid     LIKE sy-repid.

SELECTION-SCREEN BEGIN OF BLOCK block1 WITH FRAME.
  PARAMETERS: p_table(30) TYPE c DEFAULT 'SFLIGHT'.
SELECTION-SCREEN END OF BLOCK block1.

***********************************************************************
*start-of-selection.
START-OF-SELECTION.
  PERFORM get_table_structure.
  PERFORM create_itab_dynamically.
  PERFORM get_data.
  PERFORM display_data.

*&---------------------------------------------------------------------*
*&      Form  get_table_structure
*&---------------------------------------------------------------------*
*       Get structure of an SAP table
*----------------------------------------------------------------------*
FORM get_table_structure.
  DATA : it_tabdescr TYPE abap_compdescr_tab,
         wa_tabdescr TYPE abap_compdescr.
  DATA : ref_table_descr TYPE REF TO cl_abap_structdescr.

* Return structure of the table.
  ref_table_descr ?= cl_abap_typedescr=>describe_by_name( p_table ).
  it_tabdescr[] = ref_table_descr->components[].
  LOOP AT it_tabdescr INTO wa_tabdescr.
    CLEAR wa_fieldcat.
    wa_fieldcat-fieldname = wa_tabdescr-name .
    wa_fieldcat-datatype  = wa_tabdescr-type_kind.
    wa_fieldcat-inttype   = wa_tabdescr-type_kind.
    wa_fieldcat-intlen    = wa_tabdescr-length.
    wa_fieldcat-decimals  = wa_tabdescr-decimals.
    APPEND wa_fieldcat TO it_fieldcat.
  ENDLOOP.
ENDFORM.                    "get_table_structure

*&---------------------------------------------------------------------*
*&      Form  create_itab_dynamically
*&---------------------------------------------------------------------*
*       Create internal table dynamically
*----------------------------------------------------------------------*
FORM create_itab_dynamically.
* Create dynamic internal table and assign to Field-Symbol
  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog = it_fieldcat
    IMPORTING
      ep_table        = dyn_table.
  ASSIGN dyn_table->* TO <fs_table>.
* Create dynamic work area and assign to Field Symbol
  CREATE DATA dyn_line LIKE LINE OF <fs_table>.
  ASSIGN dyn_line->* TO <fs_wa>.
ENDFORM.                    "create_itab_dynamically

*&---------------------------------------------------------------------*
*&      Form  get_data
*&---------------------------------------------------------------------*
*       Populate dynamic itab
*----------------------------------------------------------------------*
FORM get_data.
* Select Data from table using field symbol which points to dynamic itab
  SELECT * INTO CORRESPONDING FIELDS OF TABLE  <fs_table>
             FROM (p_table).
ENDFORM.                    "get_data

*&---------------------------------------------------------------------*
*&      Form  display_data
*&---------------------------------------------------------------------*
*       display data using ALV
*----------------------------------------------------------------------*
FORM display_data.
  PERFORM build_fieldcatalog.
  PERFORM build_layout.
  PERFORM display_alv_report.
ENDFORM.                    " display_data

*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCATALOG
*&---------------------------------------------------------------------*
*       Build Fieldcatalog for ALV Report, using SAP table structure
*----------------------------------------------------------------------*
FORM build_fieldcatalog.
* ALV Function module to build field catalog from SAP table structure
  DATA: it_fcat  TYPE slis_t_fieldcat_alv.

  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name       = p_table
    CHANGING
      ct_fieldcat            = it_fcat
    EXCEPTIONS
      inconsistent_interface = 1
      program_error          = 2
      OTHERS                 = 3.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  fieldcatalog[] =  it_fcat[].
ENDFORM.                    " BUILD_FIELDCATALOG

*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       Build layout for ALV grid report
*----------------------------------------------------------------------*
FORM build_layout.
  gd_layout-colwidth_optimize = 'X'.
ENDFORM.                    " BUILD_LAYOUT

*&---------------------------------------------------------------------*
*&      Form  DISPLAY_ALV_REPORT
*&---------------------------------------------------------------------*
*       Display report using ALV grid
*----------------------------------------------------------------------*
FORM display_alv_report.
  gd_repid = sy-repid.
  CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
    EXPORTING
      i_callback_program = gd_repid
      is_layout          = gd_layout
      it_fieldcat        = fieldcatalog[]
      i_save             = 'X'
    TABLES
      t_outtab           = <fs_table>
    EXCEPTIONS
      program_error      = 1
      OTHERS             = 2.
ENDFORM.                    " DISPLAY_ALV_REPORT

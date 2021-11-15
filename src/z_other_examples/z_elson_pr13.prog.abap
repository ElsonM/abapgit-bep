*&---------------------------------------------------------------------*
*& Report Z_ELSON_PR13
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_pr13.

PARAMETERS: p_tab TYPE dd03l-tabname.

FIELD-SYMBOLS: <fs_tab>   TYPE STANDARD TABLE,
               <fs_wa>    TYPE any,
               <fs_matnr> TYPE matnr.

DATA: fs_data  TYPE REF TO  data,
      dyn_line TYPE REF TO  data.

DATA: itab_fcat TYPE         lvc_t_fcat,
      wa_fcat   LIKE LINE OF itab_fcat.

START-OF-SELECTION.
******* Assign

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = p_tab
    CHANGING
      ct_fieldcat      = itab_fcat.

*  LOOP AT itab_fcat INTO wa_fcat.
*
*    CLEAR: wa_fcat-domname, wa_fcat-ref_table.
*    MODIFY itab_fcat INDEX sy-tabix FROM wa_fcat.
*
*  ENDLOOP.

  CALL METHOD cl_alv_table_create=>create_dynamic_table
    EXPORTING
      it_fieldcatalog = itab_fcat
    IMPORTING
      ep_table        = fs_data.

  ASSIGN fs_data->*  TO <fs_tab>.
  CREATE DATA dyn_line LIKE LINE OF <fs_tab>.
  ASSIGN dyn_line->* TO <fs_wa>.
******* Assign

  SELECT * FROM (p_tab) UP TO 10 ROWS INTO  CORRESPONDING FIELDS OF TABLE <fs_tab>.

  BREAK-POINT.

*  LOOP AT <fs_tab> ASSIGNING <fs_wa>.
*    ASSIGN COMPONENT 'matnr' OF STRUCTURE <fs_wa> TO <fs_matnr>.
*    <fs_matnr> = 'new change'.
*  ENDLOOP.
*
*  BREAK-POINT.

*&---------------------------------------------------------------------*
*& Report Z_ALV_INT_TABLE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_alv_int_table.

INCLUDE z_alv_int_table_top.

DATA: it_fieldcat TYPE slis_t_fieldcat_alv,
      it_lvcfcat  TYPE lvc_t_fcat.

CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
  EXPORTING
    i_program_name     = sy-repid
    i_internal_tabname = 'IT_DATA'
    i_inclname         = sy-repid
  CHANGING
    ct_fieldcat        = it_fieldcat[].

IF sy-subrc NE 0.

  MESSAGE ID sy-msgid TYPE sy-msgty
    NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

ENDIF.

CALL FUNCTION 'LVC_TRANSFER_FROM_SLIS'
  EXPORTING
    it_fieldcat_alv = it_fieldcat
  IMPORTING
    et_fieldcat_lvc = it_lvcfcat
  TABLES
    it_data         = it_data.

IF sy-subrc NE 0.

  MESSAGE ID sy-msgid TYPE sy-msgty
    NUMBER sy-msgno
      WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

ENDIF.

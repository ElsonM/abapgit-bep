*&---------------------------------------------------------------------*
*& Report Z_ELSON_ALV_8
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_alv_8.

INCLUDE zdemo_alv_top.

START-OF-SELECTION.
  PERFORM read_data.
  PERFORM fill_key_info.

  PERFORM fill_field_catalog USING 'it_vbak' 'VBAK'.
  PERFORM fill_field_catalog USING 'it_vbap' 'VBAP'.

  PERFORM display_heirseq_alv.

FORM read_data.
  SELECT * INTO TABLE it_vbak FROM vbak UP TO 10 ROWS.

  IF NOT it_vbak IS INITIAL.
    SELECT * INTO TABLE it_vbap FROM vbap FOR ALL ENTRIES IN it_vbak WHERE vbeln = it_vbak-vbeln.
  ENDIF.

ENDFORM.

FORM fill_field_catalog USING fp_tabnam TYPE c fp_structure TYPE c.
  CALL FUNCTION 'REUSE_ALV_FIELDCATALOG_MERGE'
    EXPORTING
      i_program_name     = sy-cprog
      i_internal_tabname = fp_tabnam
      i_structure_name   = fp_structure
*     I_CLIENT_NEVER_DISPLAY = 'X'
*     I_INCLNAME         =
*     I_BYPASSING_BUFFER =
*     I_BUFFER_ACTIVE    =
    CHANGING
      ct_fieldcat        = it_fieldcat
* EXCEPTIONS
*     INCONSISTENT_INTERFACE = 1
*     PROGRAM_ERROR      = 2
*     OTHERS             = 3
    .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
* WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.



FORM fill_key_info.
  CLEAR gs_keyinfo.
  gs_keyinfo-header01 = 'VBELN'.
  gs_keyinfo-item01 = 'VBELN'.
  gs_keyinfo-header02 = space.
  gs_keyinfo-item02 = 'POSNR'.
ENDFORM.

FORM display_heirseq_alv.
  CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
    EXPORTING
*     I_INTERFACE_CHECK  = ' '
      i_callback_program = sy-cprog
*     I_CALLBACK_PF_STATUS_SET = ' '
*     I_CALLBACK_USER_COMMAND = ' '
*     IS_LAYOUT          =
      it_fieldcat        = it_fieldcat
*     IT_EXCLUDING       =
*     IT_SPECIAL_GROUPS  =
*     IT_SORT            =
*     IT_FILTER          =
*     IS_SEL_HIDE        =
*     I_SCREEN_START_COLUMN = 0
*     I_SCREEN_START_LINE = 0
*     I_SCREEN_END_COLUMN = 0
*     I_SCREEN_END_LINE  = 0
*     I_DEFAULT          = 'X'
*     I_SAVE             = ' '
*     IS_VARIANT         =
*     IT_EVENTS          =
*     IT_EVENT_EXIT      =
      i_tabname_header   = 'it_vbak'
      i_tabname_item     = 'it_vbap'
*     I_STRUCTURE_NAME_HEADER =
*     I_STRUCTURE_NAME_ITEM =
      is_keyinfo         = gs_keyinfo
*     IS_PRINT           =
*     IS_REPREP_ID       =
*     I_BYPASSING_BUFFER =
*     I_BUFFER_ACTIVE    =
*     IR_SALV_HIERSEQ_ADAPTER =
*     IT_EXCEPT_QINFO    =
*     I_SUPPRESS_EMPTY_DATA = ABAP_FALSE
* IMPORTING
*     E_EXIT_CAUSED_BY_CALLER =
*     ES_EXIT_CAUSED_BY_USER =
    TABLES
      t_outtab_header    = it_vbak
      t_outtab_item      = it_vbap
* EXCEPTIONS
*     PROGRAM_ERROR      = 1
*     OTHERS             = 2
    .
  IF sy-subrc <> 0.
* MESSAGE ID SY-MSGID TYPE SY-MSGTY NUMBER SY-MSGNO
* WITH SY-MSGV1 SY-MSGV2 SY-MSGV3 SY-MSGV4.
  ENDIF.
ENDFORM.

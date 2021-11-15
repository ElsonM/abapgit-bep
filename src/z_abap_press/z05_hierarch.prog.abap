*&---------------------------------------------------------------------*
*& Report Z05_HIERARCH
*&---------------------------------------------------------------------*
REPORT z05_hierarch.

TYPES : BEGIN OF ty_vbrk,
          vbeln TYPE vbeln_vf, "Document Number
          kunrg TYPE kunrg,    "Payer
          fkdat TYPE fkdat,    "Billing date
          netwr TYPE netwr,    "Net Value
        END OF ty_vbrk.

TYPES : BEGIN OF ty_vbrp,
          vbeln TYPE vbeln_vf, "Document Number
          posnr TYPE posnr_vf, "Billing item
          arktx TYPE arktx,    "Description of Item
          fkimg TYPE fkimg,    "Billed quantity
          vrkme TYPE vrkme,    "Sales Unit
          netwr TYPE netwr_fp, "Net Value
          matnr TYPE matnr,    "Material Number
        END OF ty_vbrp.

DATA : it_vbrk     TYPE STANDARD TABLE OF ty_vbrk,
       it_vbrp     TYPE STANDARD TABLE OF ty_vbrp,

       it_fieldcat TYPE slis_t_fieldcat_alv,
       wa_fieldcat TYPE slis_fieldcat_alv,

       v_vbeln     TYPE vbeln_vf.

SELECT-OPTIONS s_vbeln FOR v_vbeln.

START-OF-SELECTION.
  PERFORM get_data.

END-OF-SELECTION.
  PERFORM field_catalog.
  PERFORM show_output.

*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data.

  SELECT vbeln kunrg fkdat netwr FROM vbrk
    INTO TABLE it_vbrk
    WHERE vbeln IN s_vbeln.

  SELECT vbeln posnr arktx fkimg vrkme netwr matnr FROM vbrp
    INTO TABLE it_vbrp
    WHERE vbeln IN s_vbeln.

ENDFORM.

*&--------------------------------------------------------------*
*& Form FIELD_CATALOG
*&--------------------------------------------------------------*
FORM field_catalog.

  wa_fieldcat-col_pos   = 1.
  wa_fieldcat-fieldname = 'VBELN'.
  wa_fieldcat-tabname   = 'IT_VBRK'.
  wa_fieldcat-seltext_m = 'Document No.'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-col_pos   = 2.
  wa_fieldcat-fieldname = 'KUNRG'.
  wa_fieldcat-tabname   = 'IT_VBRK'.
  wa_fieldcat-seltext_m = 'Customer'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-col_pos   = 3.
  wa_fieldcat-fieldname = 'FKDAT'.
  wa_fieldcat-tabname   = 'IT_VBRK'.
  wa_fieldcat-seltext_m = 'Billing Date'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-col_pos   = 4.
  wa_fieldcat-fieldname = 'NETWR'.
  wa_fieldcat-tabname   = 'IT_VBRK'.
  wa_fieldcat-seltext_m = 'Net Value'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-col_pos   = 5.
  wa_fieldcat-fieldname = 'POSNR'.
  wa_fieldcat-tabname   = 'IT_VBRP'.
  wa_fieldcat-seltext_m = 'Item No'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-col_pos   = 6.
  wa_fieldcat-fieldname = 'MATNR'.
  wa_fieldcat-tabname   = 'IT_VBRP'.
  wa_fieldcat-seltext_m = 'Document No.'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-col_pos   = 7.
  wa_fieldcat-fieldname = 'ARKTX'.
  wa_fieldcat-tabname   = 'IT_VBRP'.
  wa_fieldcat-seltext_m = 'Description'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-col_pos   = 8.
  wa_fieldcat-fieldname = 'FKIMG'.
  wa_fieldcat-tabname   = 'IT_VBRP'.
  wa_fieldcat-seltext_m = 'Quantity'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-col_pos   = 9.
  wa_fieldcat-fieldname = 'VRKME'.
  wa_fieldcat-tabname   = 'IT_VBRP'.
  wa_fieldcat-seltext_m = 'UoM'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

  wa_fieldcat-col_pos   = 10.
  wa_fieldcat-fieldname = 'NETWR'.
  wa_fieldcat-tabname   = 'IT_VBRP'.
  wa_fieldcat-seltext_m = 'Net Value'.
  APPEND wa_fieldcat TO it_fieldcat.
  CLEAR wa_fieldcat.

ENDFORM.

*&--------------------------------------------------------------*
*& Form SHOW_OUTPUT
*&--------------------------------------------------------------*
FORM show_output.

  DATA: layout   TYPE slis_layout_alv,
        key_info TYPE slis_keyinfo_alv.

  key_info-header01 = 'VBELN'.
  key_info-item01   = 'VBELN'.
  layout-zebra      = 'X'.

  CALL FUNCTION 'REUSE_ALV_HIERSEQ_LIST_DISPLAY'
    EXPORTING
      is_layout        = layout
      it_fieldcat      = it_fieldcat
      i_tabname_header = 'IT_VBRK'
      i_tabname_item   = 'IT_VBRP'
      is_keyinfo       = key_info
    TABLES
      t_outtab_header  = it_vbrk
      t_outtab_item    = it_vbrp
    EXCEPTIONS
      program_error    = 1
      others           = 2.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.

ENDFORM.

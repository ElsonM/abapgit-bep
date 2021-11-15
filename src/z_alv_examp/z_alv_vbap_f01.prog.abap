*&---------------------------------------------------------------------*
*&  Include           Z_ALV_VBAP_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  U_FILTER_VBAK
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM u_filter_vbak.

  REFRESH: gt_vbak, gt_vbap, gt_item, gr_vbeln.

  " Define Range Criteria
  grs_vbeln-sign   = 'I'.
  grs_vbeln-option = 'BT'.
  APPEND grs_vbeln TO gr_vbeln.

  CHECK gr_vbeln IS NOT INITIAL.

  SELECT mandt vbeln erdat kunnr
   INTO TABLE gt_vbak
   FROM vbak
   WHERE vbeln IN gr_vbeln.

  CHECK gt_vbak IS NOT INITIAL.

  SELECT vbeln posnr matnr arktx kwmeng FROM vbap
   INTO TABLE gt_vbap
   FOR ALL ENTRIES IN gt_vbak
   WHERE vbeln EQ gt_vbak-vbeln.

  LOOP AT gt_vbap INTO gs_vbap.

    READ TABLE gt_vbak INTO gs_vbak WITH KEY vbeln = gs_vbap-vbeln.

    gs_item-mandt  = gs_vbak-mandt.
    gs_item-vbeln  = gs_vbak-vbeln.
    gs_item-erdat  = gs_vbak-erdat.
    gs_item-kunnr  = gs_vbak-kunnr.
    gs_item-posnr  = gs_vbap-posnr.
    gs_item-matnr  = gs_vbap-matnr.
    gs_item-arktx  = gs_vbap-arktx.
    gs_item-kwmeng = gs_vbap-kwmeng.

    APPEND gs_item TO gt_item.

    CLEAR gs_item.
    CLEAR gs_vbak.
    CLEAR gs_vbap.

  ENDLOOP.

  CLEAR grs_vbeln.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  U_PREPARE_FIELDCATALOG
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM u_prepare_fieldcatalog.

  CLEAR gs_fieldcatalog.
  gs_fieldcatalog-fieldname = 'MANDT'.
  gs_fieldcatalog-tabname   = 'VBAP'.
  gs_fieldcatalog-col_pos   = 0.
  gs_fieldcatalog-coltext   = 'MANDT'.
  gs_fieldcatalog-no_out    = 'X'.      "Do not Display Column
  APPEND gs_fieldcatalog TO gt_fieldcatalog.

  CLEAR gs_fieldcatalog.
  gs_fieldcatalog-fieldname = 'VBELN'.
  gs_fieldcatalog-tabname   = 'VBAP'.
  gs_fieldcatalog-col_pos   = 1.
  gs_fieldcatalog-coltext   = 'VBELN'.
  APPEND gs_fieldcatalog TO gt_fieldcatalog.

  CLEAR gs_fieldcatalog.
  gs_fieldcatalog-fieldname = 'ERDAT'.
  gs_fieldcatalog-tabname   = 'VBAP'.
  gs_fieldcatalog-col_pos   = 2.
  gs_fieldcatalog-coltext   = 'ERDAT'.
  APPEND gs_fieldcatalog TO gt_fieldcatalog.

  CLEAR gs_fieldcatalog.
  gs_fieldcatalog-fieldname = 'KUNNR'.
  gs_fieldcatalog-tabname   = 'VBAP'.
  gs_fieldcatalog-col_pos   = 3.
  gs_fieldcatalog-coltext   = 'KUNNR'.
  APPEND gs_fieldcatalog TO gt_fieldcatalog.

  CLEAR gs_fieldcatalog.
  gs_fieldcatalog-fieldname = 'POSNR'.
  gs_fieldcatalog-tabname   = 'VBAP'.
  gs_fieldcatalog-col_pos   = 4.
  gs_fieldcatalog-coltext   = 'POSNR'.
  APPEND gs_fieldcatalog TO gt_fieldcatalog.

  CLEAR gs_fieldcatalog.
  gs_fieldcatalog-fieldname = 'MATNR'.
  gs_fieldcatalog-tabname   = 'VBAP'.
  gs_fieldcatalog-col_pos   = 5.
  gs_fieldcatalog-coltext   = 'MATNR'.
  APPEND gs_fieldcatalog TO gt_fieldcatalog.

  CLEAR gs_fieldcatalog.
  gs_fieldcatalog-fieldname = 'ARKTX'.
  gs_fieldcatalog-tabname   = 'VBAP'.
  gs_fieldcatalog-col_pos   = 6.
  gs_fieldcatalog-coltext   = 'ARKTX'.
  APPEND gs_fieldcatalog TO gt_fieldcatalog.

  CLEAR gs_fieldcatalog.
  gs_fieldcatalog-fieldname = 'KWMENG'.
  gs_fieldcatalog-tabname   = 'VBAP'.
  gs_fieldcatalog-col_pos   = 7.
  gs_fieldcatalog-coltext   = 'KWMENG'.
  gs_fieldcatalog-edit      = 'X'. "Makes field editable in Grid
  APPEND gs_fieldcatalog TO gt_fieldcatalog.

ENDFORM.

*&---------------------------------------------------------------------*
*&  Include           Z_ALV_VBAP_TOP
*&---------------------------------------------------------------------*
DATA: gr_vbeln  TYPE RANGE OF vbak-vbeln,
      grs_vbeln LIKE LINE OF gr_vbeln.

DATA: gs_fieldcatalog TYPE lvc_s_fcat,
      gt_fieldcatalog TYPE lvc_t_fcat,
      gs_layout       TYPE lvc_s_layo.

TYPES: BEGIN OF gty_item,
         mandt  TYPE vbak-mandt,
         vbeln  TYPE vbak-vbeln,
         erdat  TYPE vbak-erdat,
         kunnr  TYPE vbak-kunnr,
         posnr  TYPE vbap-posnr,
         matnr  TYPE vbap-matnr,
         arktx  TYPE vbap-arktx,
         kwmeng TYPE vbap-kwmeng,
       END OF gty_item,

       BEGIN OF gty_vbak,
         mandt TYPE vbak-mandt,
         vbeln TYPE vbak-vbeln,
         erdat TYPE vbak-erdat,
         kunnr TYPE vbak-kunnr,
       END OF gty_vbak,

       BEGIN OF gty_vbap,
         vbeln  TYPE vbap-vbeln,
         posnr  TYPE vbap-posnr,
         matnr  TYPE vbap-matnr,
         arktx  TYPE vbap-arktx,
         kwmeng TYPE vbap-kwmeng,
       END OF gty_vbap.

DATA: gs_item TYPE          gty_item,
      gt_item TYPE TABLE OF gty_item.

DATA: gs_vbak TYPE          gty_vbak,
      gt_vbak TYPE TABLE OF gty_vbak,
      gs_vbap TYPE          gty_vbap,
      gt_vbap TYPE TABLE OF gty_vbap.

DATA: g_container        TYPE scrfname VALUE 'CC_CONTAINER_GRID',
      g_custom_container TYPE REF TO cl_gui_custom_container,
      g_grid             TYPE REF TO cl_gui_alv_grid.

DATA: ok_code LIKE sy-ucomm,
      save_ok LIKE sy-ucomm.

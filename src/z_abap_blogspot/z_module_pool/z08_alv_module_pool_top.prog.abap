*&---------------------------------------------------------------------*
*& Include Z08_ALV_MODULE_POOL_TOP       "Module Pool
*&                                       "Z08_ALV_MODULE_POOL
*&---------------------------------------------------------------------*
PROGRAM z08_alv_module_pool.

TABLES: proj, prps.

TYPES: BEGIN OF ty_proj,
         pspnr TYPE proj-pspnr,
         pspid TYPE proj-pspid,
         objnr TYPE proj-objnr,
         ernam TYPE proj-ernam,
         erdat TYPE proj-erdat,
         vbukr TYPE proj-vbukr,
         vgsbr TYPE proj-vgsbr,
         vkokr TYPE proj-vkokr,
       END OF ty_proj,

       BEGIN OF ty_prps,
         pspnr TYPE prps-pspnr,
         posid TYPE prps-posid,
         psphi TYPE prps-psphi,
         poski TYPE prps-poski,
         pbukr TYPE prps-pbukr,
         pgsbr TYPE prps-pgsbr,
         pkokr TYPE prps-pkokr,
       END OF ty_prps.

DATA: ok_code_sel TYPE sy-ucomm,
      ok_code_pro TYPE sy-ucomm.

DATA: wa_proj TYPE ty_proj,
      wa_prps TYPE ty_prps,

      it_proj TYPE STANDARD TABLE OF ty_proj,
      it_prps TYPE STANDARD TABLE OF ty_prps.

DATA: wa_layout    TYPE lvc_s_layo,

      wa_fcat_proj TYPE lvc_s_fcat,
      wa_fcat_prps TYPE lvc_s_fcat,

      it_fcat_proj TYPE STANDARD TABLE OF lvc_s_fcat,
      it_fcat_prps TYPE STANDARD TABLE OF lvc_s_fcat.

DATA: obj_cust_proj TYPE REF TO cl_gui_custom_container,
      obj_cust_prps TYPE REF TO cl_gui_custom_container,

      obj_grid_proj TYPE REF TO cl_gui_alv_grid,
      obj_grid_prps TYPE REF TO cl_gui_alv_grid.

SELECTION-SCREEN BEGIN OF SCREEN 100 AS SUBSCREEN.
  PARAMETERS     p_vbukr TYPE proj-vbukr.
  SELECT-OPTIONS s_pspid FOR  proj-pspid.
SELECTION-SCREEN END OF SCREEN 100.

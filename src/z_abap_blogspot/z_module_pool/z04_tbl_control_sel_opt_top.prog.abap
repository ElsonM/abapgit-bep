*&---------------------------------------------------------------------*
*& Include Z04_TBL_CONTR_SEL_OPT_TOP     " Module Pool
*&                                         Z04_TBL_CONTROL_SEL_OPTIONS
*&---------------------------------------------------------------------*
PROGRAM z04_tbl_control_sel_options.

TABLES: mara.

TYPES: BEGIN OF ty_mara,
         matnr TYPE mara-matnr, "Material Number
         ersda TYPE mara-ersda, "Date
         ernam TYPE mara-ernam, "Name
         laeda TYPE mara-laeda, "Date of Last Change
         aenam TYPE mara-aenam, "Name of Person Who Changed Object
         pstat TYPE mara-pstat, "Maintenance status
         mtart TYPE mara-mtart, "Material Type
         mbrsh TYPE mara-mbrsh, "Industry sector
         matkl TYPE mara-matkl, "Material Group
         meins TYPE mara-meins, "Base Unit of Measure
         bstme TYPE mara-bstme, "Purchase Order Unit of Measure
       END OF ty_mara.

DATA: wa_mara TYPE          ty_mara,
      it_mara TYPE TABLE OF ty_mara.

DATA: ok_code_sel TYPE sy-ucomm,
      ok_code_mat TYPE sy-ucomm.

CONTROLS tab_ctrl TYPE TABLEVIEW USING SCREEN 9002.

SELECTION-SCREEN BEGIN OF SCREEN 100 AS SUBSCREEN.
  SELECT-OPTIONS s_matnr FOR mara-matnr.
  PARAMETERS p_matnr TYPE mara-matkl.
SELECTION-SCREEN END OF SCREEN 100.

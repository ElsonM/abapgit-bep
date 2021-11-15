*&---------------------------------------------------------------------*
*& Include Z06_TABSTRIP_TOP                Module Pool      Z06_TABSTRIP
*&
*&---------------------------------------------------------------------*
PROGRAM z06_tabstrip.

*-------Declaring DB tables to mention the screen fields---------------*
TABLES: mara, makt, marm, mvke.

*-----Declaring an work area for Material details----------------------*
DATA: BEGIN OF wa_mara,
        matnr TYPE mara-matnr,
        ersda TYPE mara-ersda,
        ernam TYPE mara-ernam,
        mtart TYPE mara-mtart,
      END OF wa_mara.

*-----Declaring an work area for Material description------------------*
DATA: BEGIN OF wa_makt,
        matnr TYPE makt-matnr,
        maktx TYPE makt-maktx,
      END OF wa_makt.

*-----Declaring an work area for Material units------------------------*
DATA: BEGIN OF wa_marm,
        matnr TYPE marm-matnr,
        meinh TYPE marm-meinh,
        volum TYPE marm-volum,
        voleh TYPE marm-voleh,
      END OF wa_marm.

*-----Declaring an work area for Material sales data-------------------*
DATA: BEGIN OF wa_mvke,
        matnr TYPE mvke-matnr,
        vkorg TYPE mvke-vkorg,
        vtweg TYPE mvke-vtweg,
      END OF wa_mvke.

*-----Declaring ok_code to capture user command------------------------*
DATA: ok_code TYPE sy-ucomm.

*--------Declaring the Tabstrip----------------------------------------*
CONTROLS ts_mat TYPE TABSTRIP.

*&---------------------------------------------------------------------*
*&  Include           Z06_TABSTRIP_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  tab1
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM tab1.
  ts_mat-activetab = 'TAB1'.
ENDFORM.                    " tab1

*&---------------------------------------------------------------------*
*&      Form  tab2
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM tab2.
  ts_mat-activetab = 'TAB2'.
ENDFORM.                    " tab2

*&---------------------------------------------------------------------*
*&      Form  tab3
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM tab3.
  ts_mat-activetab = 'TAB3'.
ENDFORM.                    " tab3

*&---------------------------------------------------------------------*
*&      Form  get_material
*&---------------------------------------------------------------------*
*       Get data from MARA
*----------------------------------------------------------------------*
FORM get_material.

  IF mara-matnr IS NOT INITIAL.
    SELECT SINGLE matnr ersda ernam mtart
      FROM mara INTO wa_mara
      WHERE matnr = mara-matnr.

    IF sy-subrc = 0.
      "Passing the data from work area to screen fields of TAB1
      mara-matnr = wa_mara-matnr.
      mara-ersda = wa_mara-ersda.
      mara-ernam = wa_mara-ernam.
      mara-mtart = wa_mara-mtart.
      CLEAR wa_mara.
    ENDIF.
  ENDIF.

ENDFORM.                    " get_material

*&---------------------------------------------------------------------*
*&      Form  get_material_description
*&---------------------------------------------------------------------*
*       Get data from MAKT
*----------------------------------------------------------------------*
FORM get_material_description .

  IF mara-matnr IS NOT INITIAL.
    SELECT SINGLE matnr maktx
      FROM makt INTO wa_makt
      WHERE matnr = mara-matnr
        AND spras = sy-langu.

    IF sy-subrc = 0.
      "Passing the data from work area to screen fields of TAB1
      makt-maktx = wa_makt-maktx.
      CLEAR wa_makt.
    ENDIF.
  ENDIF.

ENDFORM.                    " get_material_description

*&---------------------------------------------------------------------*
*&      Form  get_material_unit
*&---------------------------------------------------------------------*
*       Get data from MARM
*----------------------------------------------------------------------*
FORM get_material_unit.

  IF mara-matnr IS NOT INITIAL.
    SELECT SINGLE matnr meinh volum voleh
      FROM marm INTO wa_marm
      WHERE matnr = mara-matnr.

    IF sy-subrc = 0.
      "Passing the data from work area to screen fields of TAB2
      marm-matnr = wa_marm-matnr.
      marm-meinh = wa_marm-meinh.
      marm-volum = wa_marm-volum.
      marm-voleh = wa_marm-voleh.
      CLEAR wa_marm.
    ENDIF.
  ENDIF.

ENDFORM.                    " get_material_unit

*&---------------------------------------------------------------------*
*&      Form  get_material_sales_data
*&---------------------------------------------------------------------*
*       Get data from MVKE
*----------------------------------------------------------------------*
FORM get_material_sales_data.

  IF mara-matnr IS NOT INITIAL.
    SELECT SINGLE matnr vkorg vtweg
      FROM mvke INTO wa_mvke
      WHERE matnr = mara-matnr.

    IF sy-subrc = 0.
      "Passing the data from work area to screen fields of TAB3
      mvke-matnr = wa_mvke-matnr.
      mvke-vkorg = wa_mvke-vkorg.
      mvke-vtweg = wa_mvke-vtweg.
      CLEAR wa_mvke.
    ENDIF.
  ENDIF.

ENDFORM.                    " get_material_sales_data

*&---------------------------------------------------------------------*
*&      Form  clear_screen
*&---------------------------------------------------------------------*
*       Refresh the screen fields data
*----------------------------------------------------------------------*
FORM clear_screen.

  "Clearing all the screen fields & work area
  CLEAR: mara,    makt,    marm,    mvke,
         wa_mara, wa_makt, wa_marm, wa_mvke.

ENDFORM.                    " clear_screen

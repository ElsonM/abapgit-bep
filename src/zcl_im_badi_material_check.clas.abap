class ZCL_IM_BADI_MATERIAL_CHECK definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_MATERIAL_CHECK .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BADI_MATERIAL_CHECK IMPLEMENTATION.


  method IF_EX_BADI_MATERIAL_CHECK~CHECK_CHANGE_MARA_MEINS.
  endmethod.


  method IF_EX_BADI_MATERIAL_CHECK~CHECK_CHANGE_PMATA.
  endmethod.


  METHOD if_ex_badi_material_check~check_data.

*    DATA lv_maktx TYPE short_desc-maktx VALUE 'HELLO'.
*
*    LOOP AT stext INTO DATA(wa_text).
*      wa_text-maktx = |{ wa_text-maktx } { lv_maktx }|.
*      MODIFY stext FROM wa_text.
*    ENDLOOP.

  ENDMETHOD.


  method IF_EX_BADI_MATERIAL_CHECK~CHECK_DATA_RETAIL.
  endmethod.


  method IF_EX_BADI_MATERIAL_CHECK~CHECK_MASS_MARC_DATA.
  endmethod.


  method IF_EX_BADI_MATERIAL_CHECK~FRE_SUPPRESS_MARC_CHECK.
  endmethod.
ENDCLASS.

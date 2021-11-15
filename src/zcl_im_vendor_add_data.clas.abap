class ZCL_IM_VENDOR_ADD_DATA definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_VENDOR_ADD_DATA .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_VENDOR_ADD_DATA IMPLEMENTATION.


  method IF_EX_VENDOR_ADD_DATA~BUILD_TEXT_FOR_CHANGE_DETAIL.
  endmethod.


  method IF_EX_VENDOR_ADD_DATA~CHECK_ACCOUNT_NUMBER.
  endmethod.


  method IF_EX_VENDOR_ADD_DATA~CHECK_ADD_ON_ACTIVE.
  endmethod.


METHOD if_ex_vendor_add_data~check_all_data.

  IF i_lfa1-land1 = 'DE' AND i_lfa1-regio = ' '.

    MESSAGE 'Region is required for German Vendors' TYPE 'E'.

  ENDIF.

ENDMETHOD.


  method IF_EX_VENDOR_ADD_DATA~CHECK_DATA_CHANGED.
  endmethod.


  method IF_EX_VENDOR_ADD_DATA~GET_CHANGEDOCS_FOR_OWN_TABLES.
  endmethod.


  method IF_EX_VENDOR_ADD_DATA~INITIALIZE_ADD_ON_DATA.
  endmethod.


  method IF_EX_VENDOR_ADD_DATA~MODIFY_ACCOUNT_NUMBER.
  endmethod.


  method IF_EX_VENDOR_ADD_DATA~PRESET_VALUES_CCODE.
  endmethod.


  method IF_EX_VENDOR_ADD_DATA~PRESET_VALUES_PORG.
  endmethod.


  method IF_EX_VENDOR_ADD_DATA~PRESET_VALUES_PORG_ALTERNATIVE.
  endmethod.


  method IF_EX_VENDOR_ADD_DATA~READ_ADD_ON_DATA.
  endmethod.


  method IF_EX_VENDOR_ADD_DATA~SAVE_DATA.
  endmethod.


  METHOD if_ex_vendor_add_data~set_user_inputs.

  ENDMETHOD.
ENDCLASS.

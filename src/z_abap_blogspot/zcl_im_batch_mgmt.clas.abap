class ZCL_IM_BATCH_MGMT definition
  public
  final
  create public .

public section.

  interfaces IF_EX_BADI_MATERIAL_CHECK .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM_BATCH_MGMT IMPLEMENTATION.


  METHOD if_ex_badi_material_check~check_data.


    IF wmarc-xchar = 'X' AND ( wmara-mtart = 'ROH' OR wmara-mtart = 'VERP' )
      AND sy-tcode = 'MM01'.

      IF wmbew-bwtty IS INITIAL.

        MESSAGE 'Valuation Category is Mandatory (Value = X)' TYPE 'I' DISPLAY LIKE 'E'.
        LEAVE LIST-PROCESSING.
        LEAVE TO SCREEN sy-dynnr.

      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.

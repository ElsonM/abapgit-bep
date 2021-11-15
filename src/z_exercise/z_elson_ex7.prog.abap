*&---------------------------------------------------------------------*
*& Report Z_ELSON_EX7
*&---------------------------------------------------------------------*

REPORT z_elson_ex7.

INCLUDE z_elson_ex7_top.
INCLUDE z_elson_ex7_frm.

START-OF-SELECTION.

  IF r1 = 'X'.

    PERFORM get_data_script_form.

    PERFORM open_form.
    PERFORM start_form.

    PERFORM write_form USING 'VENDOR' 'E_VEND'.
    PERFORM write_form USING 'ADDRESS' 'E_ADDR'.

    PERFORM write_form USING 'MAIN' 'E_HEAD'.

    LOOP AT lt_mara INTO ls_mara.
      PERFORM write_form USING 'MAIN' 'E_CONT'.
    ENDLOOP.

    PERFORM end_form.
    PERFORM close_form.


  ELSEIF r2 = 'X'.

    PERFORM get_data_alv.

  ELSE.

    PERFORM get_data_script_form.

    PERFORM create_smart_form.

  ENDIF.

*&---------------------------------------------------------------------*
*&  Include           ZPBO_DEMO
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  FILL_VALUES  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE fill_values OUTPUT.

  gwa_list-key = '1'.
  gwa_list-text = 'AA'.
  APPEND gwa_list TO gt_list.
  gwa_list-key = '2'.
  gwa_list-text = 'AH'.
  APPEND gwa_list TO gt_list.
*  gwa_list-key = '3'.
*  gwa_list-text = 'Color'.
*  APPEND gwa_list TO gt_list.
*  gwa_list-key = '4'.
*  gwa_list-text = 'Count'.
*  APPEND gwa_list TO gt_list.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id              = 'P_CONNID'
      values          = gt_list
    EXCEPTIONS
      id_illegal_name = 1
      OTHERS          = 2.

ENDMODULE.

MODULE init_listbox OUTPUT.

  CLEAR: p_connid,
         list.

  SELECT  connid, cityfrom, cityto, deptime
          FROM spfli
          WHERE carrid = @p_connid
          INTO CORRESPONDING FIELDS OF @wa_spfli.

    value-key  = wa_spfli-connid.

    WRITE wa_spfli-deptime TO value-text USING EDIT MASK '__:__:__'.

    value-text =
      |{ value-text } { wa_spfli-cityfrom } { wa_spfli-cityto }|.
    APPEND value TO list.

  ENDSELECT.

  IF sy-subrc <> 0.
    MESSAGE 'No connections for that airline' TYPE 'I' DISPLAY LIKE 'E'.
    LEAVE TO SCREEN 100.
  ENDIF.

  CALL FUNCTION 'VRM_SET_VALUES'
    EXPORTING
      id     = name
      values = list.

ENDMODULE.

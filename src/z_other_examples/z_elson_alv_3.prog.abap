*&---------------------------------------------------------------------*
*& Report Z_ELSON_ALV_3
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_alv_3.

TABLES: sflight.

DATA: wa_sflight TYPE sflight,
      it_sflight TYPE STANDARD TABLE OF sflight.

DATA: wa_fcat TYPE lvc_s_fcat,
      gt_fcat TYPE lvc_t_fcat.

DATA: lo_container TYPE REF TO cl_gui_custom_container,
      lo_alvgrid   TYPE REF TO cl_gui_alv_grid.

SELECT-OPTIONS: s_fldate FOR sflight-fldate.

DATA ok_code TYPE sy-ucomm.

START-OF-SELECTION.

  SELECT * FROM sflight
    INTO TABLE it_sflight
    WHERE fldate IN s_fldate.

  IF sy-subrc = 0.
    SORT it_sflight BY carrid connid fldate.
  ENDIF.

  PERFORM build_fcat USING '1' 'CARRID'   'Carried ID' '3'.
  PERFORM build_fcat USING '1' 'CONNID'   'Conn. No'   '10'.
  PERFORM build_fcat USING '1' 'PRICE'    'Price'      '10'.
  PERFORM build_fcat USING '1' 'SEATSMAX' 'Seats Max'  '10'.
  PERFORM build_fcat USING '1' 'SEATSOCC' 'Seats Occ.' '10'.

  CREATE OBJECT lo_container
    EXPORTING
      container_name              = 'ALV_CONT'
    EXCEPTIONS
      cntl_error                  = 1
      cntl_system_error           = 2
      create_error                = 3
      lifetime_error              = 4
      lifetime_dynpro_dynpro_link = 5
      OTHERS                      = 6.

  IF sy-subrc = 0.

    CREATE OBJECT lo_alvgrid
      EXPORTING
        i_parent          = lo_container
      EXCEPTIONS
        error_cntl_create = 1
        error_cntl_init   = 2
        error_cntl_link   = 3
        error_dp_create   = 4
        OTHERS            = 5.

   CALL SCREEN 9001.

  ENDIF.

*&---------------------------------------------------------------------*
*&      Form  BUILD_FCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*      -->P_0050   text
*      -->P_0051   text
*      -->P_0052   text
*      -->P_0053   text
*----------------------------------------------------------------------*
FORM build_fcat USING col_pos
                      fieldname
                      seltext
                      outputlen.

  wa_fcat-col_pos   = col_pos.
  wa_fcat-fieldname = fieldname.
  wa_fcat-seltext   = seltext.
  wa_fcat-outputlen = outputlen.
  APPEND wa_fcat TO gt_fcat.
  CLEAR wa_fcat.

ENDFORM.

INCLUDE z_elson_alv_3_o01.

INCLUDE z_elson_alv_3_i01.

*&---------------------------------------------------------------------*
*& Report ZTEST_DETERMINE_BOOKING
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ztest_determine_booking.

DATA:
  gd_date TYPE d.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-t01.
PARAMETERS:
  p_bukrs TYPE bkpf-bukrs,
  p_belnr TYPE bkpf-belnr,
  p_gjahr TYPE bkpf-gjahr.
SELECT-OPTIONS:
  s_date FOR gd_date.
SELECTION-SCREEN END OF BLOCK b01.

CLASS lcl_report DEFINITION FINAL.
  PUBLIC SECTION.
    TYPES:
      BEGIN OF ts_booking,
        bukrs TYPE bkpf-bukrs,
        belnr TYPE bkpf-belnr,
        gjahr TYPE bkpf-gjahr,
        cpudt TYPE bkpf-cpudt,
        xblnr TYPE bkpf-xblnr,
        buzei TYPE bseg-buzei,
        wrbtr TYPE bseg-wrbtr,
        waers TYPE bkpf-waers,
        kostl TYPE bseg-kostl,
        prctr TYPE bseg-prctr,
        butxt TYPE t001-butxt,
      END OF ts_booking,
      tt_booking TYPE STANDARD TABLE OF ts_booking WITH DEFAULT KEY.

    METHODS:
      initialization,

      main,

      on_bukrs.

  PRIVATE SECTION.
    METHODS:
      output_booking
        IMPORTING
          it_booking TYPE tt_booking,

      validate_parameters
        RETURNING
          VALUE(rd_valid) TYPE abap_bool,

      validate_company_code
        IMPORTING
          id_bukrs        TYPE bkpf-bukrs
        RETURNING
          VALUE(rd_valid) TYPE abap_bool,

      selection
        RETURNING
          VALUE(rt_booking) TYPE tt_booking.
ENDCLASS.

CLASS lcl_report IMPLEMENTATION.

  METHOD initialization.
    INSERT VALUE #( sign = 'I' option = 'BT' low = '20200101' high = sy-datum )
      INTO TABLE s_date[].
  ENDMETHOD.

  METHOD on_bukrs.
    IF p_bukrs IS NOT INITIAL AND NOT validate_company_code( p_bukrs ).
      MESSAGE TEXT-001 TYPE 'E'.
    ENDIF.
  ENDMETHOD.

  METHOD main.
    IF validate_parameters( ) = abap_false.
      RETURN.
    ENDIF.

    DATA(lt_booking) = selection( ).

    output_booking( lt_booking ).
  ENDMETHOD.

  METHOD output_booking.
    DATA(lt_booking) = it_booking.

    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = DATA(lo_my_table)
      CHANGING
        t_table      = lt_booking ).

    lo_my_table->display( ).
  ENDMETHOD.

  METHOD validate_company_code.
    SELECT SINGLE @abap_true
      FROM t001
      WHERE bukrs = @id_bukrs
      INTO @rd_valid.
  ENDMETHOD.

  METHOD validate_parameters.
    IF p_bukrs IS INITIAL OR p_belnr IS INITIAL OR p_gjahr IS INITIAL.
      MESSAGE TEXT-002 TYPE 'E'.
      rd_valid = abap_false.
    ELSE.
      IF validate_company_code( p_bukrs ) = abap_false.
        MESSAGE TEXT-001 TYPE 'E'.
        rd_valid = abap_false.
      ELSE.
        rd_valid = abap_true.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD selection.
    SELECT SINGLE bukrs, belnr, gjahr, cpudt, xblnr, waers
      FROM bkpf
      WHERE bukrs = @p_bukrs
        AND belnr = @p_belnr
        AND gjahr = @p_gjahr
      INTO @DATA(ls_bkpf).

    CHECK sy-subrc = 0.

    SELECT buzei, wrbtr, kostl, prctr
      FROM bseg
      WHERE bukrs = @p_bukrs
        AND belnr = @p_belnr
        AND gjahr = @p_gjahr
      INTO TABLE @DATA(lt_bseg).

    SELECT SINGLE butxt
      FROM t001
      WHERE bukrs = @p_bukrs
      INTO @DATA(ld_description).

    LOOP AT lt_bseg INTO DATA(ls_bseg).
      DATA(ls_booking) = CORRESPONDING ts_booking( ls_bkpf ).
      ls_booking = CORRESPONDING #( BASE ( ls_booking ) ls_bseg ).
      ls_booking-butxt = ld_description.
      INSERT ls_booking INTO TABLE rt_booking.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

INITIALIZATION.
  DATA(go_report) = NEW lcl_report( ).
  go_report->initialization( ).


AT SELECTION-SCREEN ON p_bukrs.
  go_report->on_bukrs( ).

START-OF-SELECTION.
  go_report->main( ).

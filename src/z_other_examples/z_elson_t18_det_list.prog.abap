*&---------------------------------------------------------------------*
*& Report Z_ELSON_T18_DET_LIST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t18_det_list.

DATA wa_spfli   TYPE spfli.
DATA wa_sflight TYPE sflight.

START-OF-SELECTION.

  WRITE: TEXT-002 COLOR COL_HEADING,
         TEXT-003 COLOR COL_HEADING,
         TEXT-004 COLOR COL_HEADING,
         TEXT-005 COLOR COL_HEADING,
         TEXT-006 COLOR COL_HEADING.

  SELECT carrid connid airpfrom airpto deptime
    FROM spfli
    INTO CORRESPONDING FIELDS OF wa_spfli.

    WRITE: / wa_spfli-carrid   UNDER TEXT-002,

             wa_spfli-connid   UNDER TEXT-003,
             wa_spfli-airpfrom UNDER TEXT-004,
             wa_spfli-airpto   UNDER TEXT-005,
             wa_spfli-deptime  UNDER TEXT-006.
    HIDE:    wa_spfli-carrid,
             wa_spfli-connid.
  ENDSELECT.

AT LINE-SELECTION.
  IF sy-lsind = 1.
    WRITE: TEXT-001,
           wa_spfli-carrid,
           wa_spfli-connid.
    SELECT fldate seatsmax seatsocc
      FROM sflight
      INTO CORRESPONDING FIELDS OF wa_sflight
      WHERE carrid = wa_spfli-carrid AND
            connid = wa_spfli-connid.
      WRITE: / wa_sflight-fldate,
               wa_sflight-seatsmax,
               wa_sflight-seatsocc.
    ENDSELECT.
  ENDIF.

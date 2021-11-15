*&---------------------------------------------------------------------*
*& Report Z09_F4_HELP
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z09_f4_help.

*---------PROJ & PRPS Tables Declaration-------------------------------*
*----------------------------------------------------------------------*
TABLES: proj, prps.

*---------Structure Declaration for different Internal Tables----------*
*----------------------------------------------------------------------*

"Structure to create F4 Help for Company Code
TYPES: BEGIN OF ty_vbukr,
         vbukr TYPE proj-vbukr, "Company code
       END OF ty_vbukr,

"Structure to create F4 Help for Project definition
       BEGIN OF ty_pspid,
         pspid TYPE proj-pspid, "Project definition
       END OF ty_pspid.

"Internal Tables of Value Table for F4 Help
DATA: it_vbukr   TYPE STANDARD TABLE OF ty_vbukr,
      it_pspid   TYPE STANDARD TABLE OF ty_pspid,
      it_pspid1  TYPE STANDARD TABLE OF ty_pspid,

      "Internal Tables of Return Table for F4 Help
      wa_return1 TYPE                   ddshretval,
      wa_return2 TYPE                   ddshretval,
      wa_return3 TYPE                   ddshretval,
      it_return1 TYPE STANDARD TABLE OF ddshretval,
      it_return2 TYPE STANDARD TABLE OF ddshretval,
      it_return3 TYPE STANDARD TABLE OF ddshretval.


"Constants for F4IF_INT_TABLE_VALUE_REQUEST
CONSTANTS: c_vbukr   TYPE dfies-fieldname VALUE 'P_VBUKR',
           c_pspid_l TYPE dfies-fieldname VALUE 'P_PSPID-LOW',
           c_pspid_h TYPE dfies-fieldname VALUE 'P_PSPID-HIGH',
           c_vorg    TYPE char1           VALUE 'S'.

*---------SELECTION SCREEN---------------------------------------------*
*----------------------------------------------------------------------*
SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
  PARAMETERS     p_vbukr LIKE proj-vbukr.
  SELECT-OPTIONS s_pspid FOR  proj-pspid.
SELECTION-SCREEN END OF BLOCK b1.

*---------AT SELECTION-SCREEN ON VALUE-REQUEST for COMPANY CODE--------*
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_vbukr.

  SELECT DISTINCT vbukr FROM proj INTO TABLE it_vbukr.

  IF sy-subrc = 0.
    SORT it_vbukr BY vbukr.
  ENDIF.

  "Function Module to create F4 help
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = c_vbukr
      value_org       = c_vorg
    TABLES
      value_tab       = it_vbukr
      return_tab      = it_return1
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF it_return1 IS NOT INITIAL.

    LOOP AT it_return1 INTO wa_return1.
      p_vbukr = wa_return1-fieldval.
    ENDLOOP.

    SELECT pspid FROM proj INTO TABLE it_pspid
      WHERE vbukr = p_vbukr.

    IF sy-subrc = 0.
      SORT it_pspid BY pspid.
    ENDIF.

  ENDIF.

*-----AT SELECTION-SCREEN ON VALUE-REQUEST for PROJECT DEFINITION------*
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_pspid-low.

"Function Module to create F4 help
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = c_pspid_l
      value_org       = c_vorg
    TABLES
      value_tab       = it_pspid
      return_tab      = it_return2
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF it_return2 IS NOT INITIAL.

    LOOP AT it_return2 INTO wa_return2.
      s_pspid-low = wa_return2-fieldval.
    ENDLOOP.

    SELECT pspid FROM proj INTO TABLE it_pspid1
      WHERE pspid GT s_pspid-low
        AND vbukr = p_vbukr.
    IF sy-subrc = 0.
      SORT it_pspid1 BY pspid.
    ENDIF.

  ENDIF.

*-----AT SELECTION-SCREEN ON VALUE-REQUEST for PROJECT DEFINITION------*
*----------------------------------------------------------------------*
AT SELECTION-SCREEN ON VALUE-REQUEST FOR s_pspid-high.

  "Function Module to create F4 help
  CALL FUNCTION 'F4IF_INT_TABLE_VALUE_REQUEST'
    EXPORTING
      retfield        = c_pspid_h
      value_org       = c_vorg
    TABLES
      value_tab       = it_pspid1
      return_tab      = it_return3
    EXCEPTIONS
      parameter_error = 1
      no_values_found = 2
      OTHERS          = 3.

  IF it_return3 IS NOT INITIAL.

    LOOP AT it_return3 INTO wa_return3.
      s_pspid-high = wa_return3-fieldval.
    ENDLOOP.

  ENDIF.

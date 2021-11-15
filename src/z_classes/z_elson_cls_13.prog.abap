*&---------------------------------------------------------------------*
*& Report Z_ELSON_CLS_13
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_cls_13.

CLASS cl_events DEFINITION DEFERRED.
DATA lo_event TYPE REF TO cl_events. "Declare class
DATA wa_mara TYPE mara. "Declare work area
PARAMETERS p_matnr TYPE mara-matnr. "Material no. input

CLASS cl_events DEFINITION. "Class definition
  PUBLIC SECTION.
    EVENTS: no_material. "Event
    METHODS: get_material_details
      IMPORTING im_matnr TYPE mara-matnr
      EXPORTING ex_mara  TYPE mara.
    METHODS: event_handler FOR EVENT no_material OF cl_events.
ENDCLASS.

START-OF-SELECTION.
  CREATE OBJECT lo_event. "Create object
  SET HANDLER lo_event->event_handler FOR lo_event. "Register event handler method for the object
  CALL METHOD lo_event->get_material_details        "Call method to get material details
    EXPORTING
      im_matnr = p_matnr
    IMPORTING
      ex_mara  = wa_mara.
  WRITE :/ wa_mara-matnr, wa_mara-mtart, wa_mara-meins, wa_mara-matkl.

CLASS cl_events IMPLEMENTATION. "Class implementation
  METHOD get_material_details.
    SELECT SINGLE * FROM mara
      INTO ex_mara
      WHERE matnr = im_matnr.
    IF sy-subrc NE 0.
      RAISE EVENT no_material. "Trigger the event
    ENDIF.
  ENDMETHOD.
  METHOD event_handler.
    WRITE:/ 'No material found'. "Event handler method implementation
  ENDMETHOD.
ENDCLASS.               "CL_EVENTS

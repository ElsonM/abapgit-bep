*&---------------------------------------------------------------------*
*& Report Z_ABAP_PRESS2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap_press2.

CLASS lcl_publisher DEFINITION.
  PUBLIC SECTION.
    METHODS:
      add_message IMPORTING iv_message TYPE string,
      confirm_receipt IMPORTING iv_subscriber TYPE string.

    EVENTS:
      message_added
        EXPORTING VALUE(ev_message) TYPE string.
ENDCLASS.

CLASS lcl_subscriber DEFINITION.
  PUBLIC SECTION.
    METHODS:
    constructor,
    on_message FOR EVENT message_added
                 OF lcl_publisher
               IMPORTING
                 ev_message sender.
ENDCLASS.

DATA lo_publisher TYPE REF TO lcl_publisher.
DATA lo_subscriber TYPE REF TO lcl_subscriber.

CREATE OBJECT lo_publisher.
CREATE OBJECT lo_subscriber.

lo_publisher->add_message( 'Ping...' ).

*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_publisher
*&---------------------------------------------------------------------*
*  Text
*----------------------------------------------------------------------*
CLASS lcl_publisher IMPLEMENTATION.
  METHOD add_message.
    DATA lv_message TYPE string.
    lv_message = |Publishing message: [{ iv_message }]|.
    WRITE:/ lv_message.

    RAISE EVENT message_added
      EXPORTING
        ev_message = iv_message.
  ENDMETHOD.

  METHOD confirm_receipt.
    DATA lv_message TYPE string.
    lv_message = |Message processed by { iv_subscriber }.|.
    WRITE:/ lv_message.
  ENDMETHOD.
ENDCLASS.               "lcl_publisher

*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_subscriber
*&---------------------------------------------------------------------*
*  Text
*----------------------------------------------------------------------*
CLASS lcl_subscriber IMPLEMENTATION.
  METHOD constructor.
    SET HANDLER on_message FOR ALL INSTANCES.
  ENDMETHOD.

  METHOD on_message.
    DATA lv_message TYPE string.
    lv_message = |Received message: [{ ev_message }]|.
    WRITE:/ lv_message.

    sender->confirm_receipt( 'LCL_SUBSCRIBER' ).
  ENDMETHOD.
ENDCLASS.               "lcl_subscriber

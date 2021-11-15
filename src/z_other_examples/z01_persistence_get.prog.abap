*&---------------------------------------------------------------------*
*& Report Z01_PERSISTENCE_GET
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_persistence_get.

DATA airline_agent TYPE REF TO zca_os_scarr.
DATA airline       TYPE REF TO zcl_os_scarr.
DATA airline_name  TYPE        s_carrname.

TRY.
    airline_agent = zca_os_scarr=>agent.
    airline = airline_agent->get_persistent( 'BA' ).

    airline_name = airline->get_carrname( ).
    WRITE: 'Name of the selected airline:', airline_name.
  CATCH cx_os_object_not_found.
ENDTRY.

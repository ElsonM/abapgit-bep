*&---------------------------------------------------------------------*
*& Report Z02_PERSISTENCE_CREATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_persistence_create.

DATA airline_agent TYPE REF TO zca_os_scarr.
DATA airline       TYPE REF TO zcl_os_scarr.

TRY.
    airline_agent = zca_os_scarr=>agent.
    airline_agent->delete_persistent(
      i_carrid = 'WA'


*      i_carrid   = 'WA'
*      i_carrname = 'Wizz Air'
*      i_currcode = 'HUF'
*      i_url      = 'http://wizzair.com'
    ).

    COMMIT WORK.
  CATCH cx_os_object_existing.
ENDTRY.

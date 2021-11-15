*&---------------------------------------------------------------------*
*& Report Z02_FLIGHT_BOOKING_LIST_73
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_flight_booking_list_73.

"-------------------------------------------------------------------"
"$. Region  Define a selection field for Flight Date
"-------------------------------------------------------------------"
PARAMETERS pfldate TYPE d OBLIGATORY DEFAULT '20170419'.

"-------------------------------------------------------------------"
"$. Endregion
"-------------------------------------------------------------------"

"-------------------------------------------------------------------"
"$. Region  Query first 40 flight bookings for selected date
"-------------------------------------------------------------------"
DATA flight_bookings TYPE TABLE OF sbook.

SELECT * FROM sbook INTO TABLE flight_bookings UP TO 40 ROWS
  WHERE fldate = pfldate.

"-------------------------------------------------------------------"
"$. Endregion
"-------------------------------------------------------------------"

"-------------------------------------------------------------------"
"$. Region  Determine the name of the selected day
"-------------------------------------------------------------------"
DATA name_of_the_day TYPE string. "Inline Declaration is not allowed in FM calls

CALL FUNCTION 'Z_DETERMINE_NAME_OF_THE_DAY_73'
  EXPORTING
    date            = pfldate
  IMPORTING
    name_of_the_day = name_of_the_day.

"-------------------------------------------------------------------"
"$. Endregion
"-------------------------------------------------------------------"

"-------------------------------------------------------------------"
"$. Region  Prepare the title of the ALV
"-------------------------------------------------------------------"
DATA formatted_date TYPE string. "In 7.3 you do not have Inline Declaration
DATA title_of_alv   TYPE string. "In 7.3 you do not have Inline Declaration

formatted_date = |{ pfldate+6(2) }-{ pfldate+4(2) }-{ pfldate(4) }|.
title_of_alv = |Flight Bookings on { formatted_date }, { name_of_the_day }|.

"-------------------------------------------------------------------"
"$. Endregion
"-------------------------------------------------------------------"

"-------------------------------------------------------------------"
"$. Region  Display flight bookings in ALV
"-------------------------------------------------------------------"
DATA alv_object          TYPE REF TO cl_salv_table.     " In 7.3 you do not have Inline Declaration
DATA factory_message     TYPE REF TO cx_salv_msg.       " In 7.3 you do not have Inline Declaration
DATA column_not_found    TYPE REF TO cx_salv_not_found. " In 7.3 you do not have Inline Declaration
DATA error_message       TYPE string.                   " In 7.3 you do not have Inline Declaration
DATA title_of_alv_char70 TYPE lvc_title.                " In 7.3 you do not have Inline Declaration

TRY.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = alv_object
      CHANGING
        t_table = flight_bookings
    ).
  CATCH cx_salv_msg INTO factory_message.
    error_message = factory_message->get_text( ).
    MESSAGE e398(00) WITH error_message. " In 7.3 you cannot embed method calls here
ENDTRY.

alv_object->get_functions( )->set_all( ).

alv_object->get_columns( )->set_optimize( ).

alv_object->get_display_settings( )->set_striped_pattern( abap_true ).

title_of_alv_char70 = title_of_alv. " Instead of CONV operator you have to convert it manually
alv_object->get_display_settings( )->set_list_header( title_of_alv_char70 ).

TRY.
    alv_object->get_columns( )->get_column( 'MANDT' )->set_visible( abap_false ).
    alv_object->get_columns( )->get_column( 'CANCELLED' )->set_visible( abap_false ).
    alv_object->get_columns( )->get_column( 'RESERVED' )->set_visible( abap_false ).
    alv_object->get_columns( )->get_column( 'PASSFORM' )->set_visible( abap_false ).
    alv_object->get_columns( )->get_column( 'PASSBIRTH' )->set_visible( abap_false ).
  CATCH cx_salv_not_found INTO column_not_found.
    error_message = column_not_found->get_text( ).
    MESSAGE e398(00) WITH error_message. " In 7.3 you cannot embed method calls here
ENDTRY.

alv_object->display( ).

"-------------------------------------------------------------------"
"$. Endregion
"-------------------------------------------------------------------"

*&---------------------------------------------------------------------*
*& Report Z03_FLIGHT_BOOKING_LIST_73
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z03_flight_booking_list_73.

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
DATA name_of_the_day TYPE string. " Inline Declaration is not allowed in FM calls

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
DATA formatted_date TYPE string. " In 7.3 you do not have Inline Declaration
DATA title_of_alv   TYPE string. " In 7.3 you do not have Inline Declaration

formatted_date = |{ pfldate+6(2) }-{ pfldate+4(2) }-{ pfldate(4) }|.
title_of_alv = |Flight Bookings on { formatted_date }, { name_of_the_day }|.

"-------------------------------------------------------------------"
"$. Endregion
"-------------------------------------------------------------------"

"-------------------------------------------------------------------"
"$. Region  Display flight bookings in ALV
"-------------------------------------------------------------------"
DATA simple_alv       TYPE REF TO zcl_simple_alv_73. " In 7.3 you do not have Inline Declaration
DATA factory_message  TYPE REF TO cx_salv_msg.       " In 7.3 you do not have Inline Declaration
DATA column_not_found TYPE REF TO cx_salv_not_found. " In 7.3 you do not have Inline Declaration
DATA error_message    TYPE string.                   " In 7.3 you do not have Inline Declaration

CREATE OBJECT simple_alv
  EXPORTING
    title               = title_of_alv
    fields_to_be_hidden = 'MANDT;CANCELLED;RESERVED;PASSFORM;PASSBIRTH'.

TRY.
    simple_alv->display(
      CHANGING
        data_to_be_displayed = flight_bookings
    ).
  CATCH cx_salv_msg INTO factory_message.
    error_message = factory_message->get_text( ).
    MESSAGE e398(00) WITH error_message. " In 7.3 you cannot embed method calls here
  CATCH cx_salv_not_found INTO column_not_found.
    error_message = column_not_found->get_text( ).
    MESSAGE e398(00) WITH error_message. " In 7.3 you cannot embed method calls here
ENDTRY.

"-------------------------------------------------------------------"
"$. Endregion
"-------------------------------------------------------------------"

*&---------------------------------------------------------------------*
*& Report Z01_FLIGHT_BOOKING_LIST_74
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z01_flight_booking_list_74.

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
DATA(day_of_the_week) = pfldate MOD 7.

IF day_of_the_week > 1.
  day_of_the_week = day_of_the_week - 1.
ELSE.
  day_of_the_week = day_of_the_week + 6.
ENDIF.

DATA(name_of_the_day) = SWITCH string(
  day_of_the_week
    WHEN 1 THEN 'Monday'
    WHEN 2 THEN 'Tuesday'
    WHEN 3 THEN 'Wednesday'
    WHEN 4 THEN 'Thursday'
    WHEN 5 THEN 'Friday'
    WHEN 6 THEN 'Saturday'
    WHEN 7 THEN 'Sunday'
).

"-------------------------------------------------------------------"
"$. Endregion
"-------------------------------------------------------------------"

"-------------------------------------------------------------------"
"$. Region  Prepare the title of the ALV
"-------------------------------------------------------------------"
DATA(formatted_date) = |{ pfldate+6(2) }-{ pfldate+4(2) }-{ pfldate(4) }|.
DATA(title_of_alv) = |Flight Bookings on { formatted_date }, { name_of_the_day }|.

"-------------------------------------------------------------------"
"$. Endregion
"-------------------------------------------------------------------"

"-------------------------------------------------------------------"
"$. Region  Display flight bookings in ALV
"-------------------------------------------------------------------"
TRY.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = DATA(alv_object)
      CHANGING
        t_table = flight_bookings
    ).
  CATCH cx_salv_msg INTO DATA(factory_message).
    MESSAGE e398(00) WITH factory_message->get_text( ).
ENDTRY.

alv_object->get_functions( )->set_all( ).

alv_object->get_columns( )->set_optimize( ).

alv_object->get_display_settings( )->set_striped_pattern( abap_true ).

alv_object->get_display_settings( )->set_list_header( CONV #( title_of_alv ) ).

TRY.
    alv_object->get_columns( )->get_column( 'MANDT' )->set_visible( abap_false ).
    alv_object->get_columns( )->get_column( 'CANCELLED' )->set_visible( abap_false ).
    alv_object->get_columns( )->get_column( 'RESERVED' )->set_visible( abap_false ).
    alv_object->get_columns( )->get_column( 'PASSFORM' )->set_visible( abap_false ).
    alv_object->get_columns( )->get_column( 'PASSBIRTH' )->set_visible( abap_false ).
  CATCH cx_salv_not_found INTO DATA(column_not_found).
    MESSAGE e398(00) WITH column_not_found->get_text( ).
ENDTRY.

alv_object->display( ).

"-------------------------------------------------------------------"
"$. Endregion
"-------------------------------------------------------------------"

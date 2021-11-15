*&---------------------------------------------------------------------*
*& Report Z02_FLIGHT_BOOKING_LIST_74
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z02_flight_booking_list_74.

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

CALL FUNCTION 'Z_DETERMINE_NAME_OF_THE_DAY_74'
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

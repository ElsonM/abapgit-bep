REPORT z03_flight_booking_list_74.

"----------------------------------------------------------------------"
"$. Region  Define a selection field for Flight Date
"----------------------------------------------------------------------"
PARAMETERS pfldate TYPE d OBLIGATORY DEFAULT '20170419'.
"----------------------------------------------------------------------"
"$. Endregion
"----------------------------------------------------------------------"

"----------------------------------------------------------------------"
"$. Region  Query first 40 flight bookings for selected date
"----------------------------------------------------------------------"
DATA flight_bookings TYPE TABLE OF sbook.

SELECT * FROM sbook INTO TABLE flight_bookings UP TO 40 ROWS
  WHERE fldate = pfldate.
"----------------------------------------------------------------------"
"$. Endregion
"----------------------------------------------------------------------"

"----------------------------------------------------------------------"
"$. Region  Determine the name of the selected day
"----------------------------------------------------------------------"
DATA name_of_the_selected_date TYPE string.

CALL FUNCTION 'Z_DETERMINE_NAME_OF_THE_DAY_74'
  EXPORTING
    date            = pfldate
  IMPORTING
    name_of_the_day = name_of_the_selected_date.
"----------------------------------------------------------------------"
"$. Endregion
"----------------------------------------------------------------------"

"----------------------------------------------------------------------"
"$. Region  Prepare the title of the ALV
"----------------------------------------------------------------------"
DATA(formatted_date) = |{ pfldate+6(2) }-{ pfldate+4(2) }-{ pfldate(4) }|.
DATA(title_of_alv) = |Flight bookings on { formatted_date }, { name_of_the_selected_date }|.
"----------------------------------------------------------------------"
"$. Endregion
"----------------------------------------------------------------------"

"----------------------------------------------------------------------"
"$. Region  Display flight bookings in ALV
"----------------------------------------------------------------------"
DATA(simple_alv) = NEW zcl_simple_alv_74(
  title               = title_of_alv
  fields_to_be_hidden = 'MANDT;CANCELLED;RESERVED;PASSFORM;PASSBIRTH'
).

TRY.
    simple_alv->display(
      CHANGING
        data_to_be_displayed = flight_bookings
    ).
  CATCH cx_salv_msg INTO DATA(factory_message).
    MESSAGE e398(00) WITH factory_message->get_text( ).
  CATCH cx_salv_not_found INTO DATA(column_not_found).
    MESSAGE e398(00) WITH column_not_found->get_text( ).
ENDTRY.

"----------------------------------------------------------------------"
"$. Endregion
"----------------------------------------------------------------------"

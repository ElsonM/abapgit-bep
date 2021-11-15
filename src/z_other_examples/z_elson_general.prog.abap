REPORT z_elson_general.

"-------------------------------------------------------------------"
"$. Region  Define a selection field for Flight Date
"-------------------------------------------------------------------"
PARAMETERS pfldate TYPE d OBLIGATORY DEFAULT '20100313'.

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
DATA day_of_the_week TYPE i. " in 7.3 you do not have Inline Declaration
DATA name_of_the_day TYPE string. " in 7.3 you do not have Inline Declaration

day_of_the_week = pfldate MOD 7.

IF day_of_the_week > 1.
  day_of_the_week = day_of_the_week - 1.
ELSE.
  day_of_the_week = day_of_the_week + 6.
ENDIF.

" in 7.3 you do not have SWITCH statement, you have CASE
CASE day_of_the_week.
  WHEN 1.
    name_of_the_day = 'Monday'.
  WHEN 2.
    name_of_the_day = 'Tuesday'.
  WHEN 3.
    name_of_the_day = 'Wednesday'.
  WHEN 4.
    name_of_the_day = 'Thursday'.
  WHEN 5.
    name_of_the_day = 'Friday'.
  WHEN 6.
    name_of_the_day = 'Saturday'.
  WHEN 7.
    name_of_the_day = 'Sunday'.
ENDCASE.

"-------------------------------------------------------------------"
"$. Endregion
"-------------------------------------------------------------------"

"-------------------------------------------------------------------"
"$. Region  Prepare the title of the ALV
"-------------------------------------------------------------------"
DATA formatted_date TYPE string. " in 7.3 you do not have Inline Declaration
DATA title_of_alv   TYPE string. " in 7.3 you do not have Inline Declaration

formatted_date = |{ pfldate(4) }-{ pfldate+4(2) }-{ pfldate+6(2) }|.
title_of_alv = |Flight Bookings on { formatted_date }, { name_of_the_day }|.

"-------------------------------------------------------------------"
"$. Endregion
"-------------------------------------------------------------------"

"-------------------------------------------------------------------"
"$. Region  Display flight bookings in ALV
"-------------------------------------------------------------------"
DATA alv_object          TYPE REF TO cl_salv_table. " in 7.3 you do not have Inline Declaration
DATA factory_message     TYPE REF TO cx_salv_msg. " in 7.3 you do not have Inline Declaration
DATA column_not_found    TYPE REF TO cx_salv_not_found. " in 7.3 you do not have Inline Declaration
DATA error_message       TYPE string. " in 7.3 you do not have Inline Declaration
DATA title_of_alv_char70 TYPE lvc_title. " in 7.3 you do not have Inline Declaration

TRY.
    cl_salv_table=>factory(
      IMPORTING
        r_salv_table = alv_object
      CHANGING
        t_table = flight_bookings
    ).
  CATCH cx_salv_msg INTO factory_message.
    error_message = factory_message->get_text( ).
    MESSAGE e398(00) WITH error_message. " in 7.3 you cannot embed method calls here
ENDTRY.

alv_object->get_functions( )->set_all( ).

alv_object->get_columns( )->set_optimize( ).

alv_object->get_display_settings( )->set_striped_pattern( abap_true ).

title_of_alv_char70 = title_of_alv. " instead of CONV operator you have to convert it manually
alv_object->get_display_settings( )->set_list_header( title_of_alv_char70 ).

TRY.
    alv_object->get_columns( )->get_column( 'MANDT' )->set_visible( abap_false ).
    alv_object->get_columns( )->get_column( 'CANCELLED' )->set_visible( abap_false ).
    alv_object->get_columns( )->get_column( 'RESERVED' )->set_visible( abap_false ).
    alv_object->get_columns( )->get_column( 'PASSFORM' )->set_visible( abap_false ).
    alv_object->get_columns( )->get_column( 'PASSBIRTH' )->set_visible( abap_false ).
  CATCH cx_salv_not_found INTO column_not_found.
    error_message = column_not_found->get_text( ).
    MESSAGE e398(00) WITH error_message. " in 7.3 you cannot embed method calls here
ENDTRY.

alv_object->display( ).

"-------------------------------------------------------------------"
"$. Endregion
"-------------------------------------------------------------------"

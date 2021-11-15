FUNCTION z_determine_name_of_the_day_74.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(DATE) TYPE  D
*"  EXPORTING
*"     REFERENCE(NAME_OF_THE_DAY)
*"----------------------------------------------------------------------
  DATA(day_of_the_week) = date MOD 7.

  IF day_of_the_week > 1.
    day_of_the_week = day_of_the_week - 1.
  ELSE.
    day_of_the_week = day_of_the_week + 6.
  ENDIF.

  name_of_the_day = SWITCH string(
    day_of_the_week
      WHEN 1 THEN 'Monday'
      WHEN 2 THEN 'Tuesday'
      WHEN 3 THEN 'Wednesday'
      WHEN 4 THEN 'Thursday'
      WHEN 5 THEN 'Friday'
      WHEN 6 THEN 'Saturday'
      WHEN 7 THEN 'Sunday'
  ).
ENDFUNCTION.

FUNCTION z_determine_name_of_the_day_73.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(DATE) TYPE  D
*"  EXPORTING
*"     REFERENCE(NAME_OF_THE_DAY) TYPE  STRING
*"----------------------------------------------------------------------
  DATA day_of_the_week TYPE i. "In 7.3 you do not have Inline Declaration

  day_of_the_week = date MOD 7.

  IF day_of_the_week > 1.
    day_of_the_week = day_of_the_week - 1.
  ELSE.
    day_of_the_week = day_of_the_week + 6.
  ENDIF.

  "In 7.3 you do not have SWITCH statement, you have CASE
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
ENDFUNCTION.

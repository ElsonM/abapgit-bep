"Name: \PR:Z25_EXPLICIT_ENCH_SECTION\EX:ZENCH_S\EI
ENHANCEMENT 0 ZENCH_02.
  IF it_sflight IS NOT INITIAL.
    WRITE:  / 'Airline Code',
           15 'Flight No.',
           27 'Flight Date',
           45 'Maximum Seat',
           60 'Occupied Seat'.
    ULINE.
    SKIP.
  ENDIF.
ENDENHANCEMENT.

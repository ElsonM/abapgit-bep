*&---------------------------------------------------------------------*
*& Report Z_ABAP101_051
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_051.

TYPES ty_users TYPE TABLE OF usr04-bname.

DATA  it_users TYPE ty_users.

START-OF-SELECTION.
  SELECT bname FROM usr04 INTO TABLE it_users.
  PERFORM print_users USING it_users.

*&---------------------------------------------------------------------*
*&    Form PRINT_USERS
*&---------------------------------------------------------------------*
*     Prints all usernames in the system
*----------------------------------------------------------------------*
* --> US_T_USERS usernames
*----------------------------------------------------------------------*
FORM print_users
    USING us_t_users TYPE ty_users.

  DATA lwa_user TYPE LINE OF ty_users.
  LOOP AT us_t_users INTO lwa_user.
    WRITE lwa_user.
    NEW-LINE.
  ENDLOOP.

ENDFORM. " print_users

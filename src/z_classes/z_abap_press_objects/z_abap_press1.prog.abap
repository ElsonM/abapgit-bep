*&---------------------------------------------------------------------*
*& Report Z_ABAP_PRESS1
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap_press1.

CLASS lcl_point DEFINITION.
  PUBLIC SECTION.
    CONSTANTS co_pi TYPE f VALUE '3.14159265'.

    DATA: mv_x TYPE p DECIMALS 2, "X-Coordinate
          mv_y TYPE p DECIMALS 2. "Y-Coordinate

    CLASS-METHODS create_from_polar IMPORTING iv_r            TYPE f
                                              iv_theta        TYPE p
                                    RETURNING VALUE(ro_point)
                                                TYPE REF TO lcl_point.

    METHODS get_distance IMPORTING io_point2
                                     TYPE REF TO lcl_point
                         RETURNING VALUE(rv_distance) TYPE f.
ENDCLASS.

DATA: lo_point_a  TYPE REF TO lcl_point,
      lo_point_b  TYPE REF TO lcl_point,
      lv_distance TYPE f.

DATA lo_point TYPE REF TO lcl_point.
DATA lv_message TYPE string.

"Instantiate both of the point objects:
CREATE OBJECT lo_point_a.
lo_point_a->mv_x = 1.
lo_point_a->mv_y = 1.

CREATE OBJECT lo_point_b.
lo_point_b->mv_x = 3.
lo_point_b->mv_y = 3.

"Calculate the distance and display the results:
lv_distance = lo_point_a->get_distance( lo_point_b ).

WRITE: 'Distance between point a and point b is: ',
       lv_distance.

lo_point = lcl_point=>create_from_polar( iv_r = '3.6'
                                         iv_theta = '56.31' ).
lv_message =
  |Coordinates: ({ lo_point->mv_x }, { lo_point->mv_y })|.
WRITE:/ lv_message.

lv_message = |PI is { lcl_point=>co_pi }|.
WRITE:/ lv_message.

*&---------------------------------------------------------------------*
*& Class (Implementation) lcl_point
*&---------------------------------------------------------------------*
*  Text
*----------------------------------------------------------------------*
CLASS lcl_point IMPLEMENTATION.
  METHOD create_from_polar.
    "Convert the angle measure to radians:
    DATA lv_theta_rad TYPE f.
    lv_theta_rad = ( iv_theta * co_pi ) / 180.
    "Create a new point object and calculate the
    "X & Y coordinates:
    CREATE OBJECT ro_point.
    ro_point->mv_x = iv_r * cos( lv_theta_rad ).
    ro_point->mv_y = iv_r * sin( lv_theta_rad ).
  ENDMETHOD.

  METHOD get_distance.
    DATA: lv_dx TYPE f, "Diff. X
          lv_dy TYPE f. "Diff. Y

    "Calculate the Euclidean distance between the points:
    lv_dx = io_point2->mv_x - me->mv_x.
    lv_dy = io_point2->mv_y - me->mv_y.

    rv_distance =
      sqrt( ( lv_dx * lv_dx ) + ( lv_dy * lv_dy ) ).
  ENDMETHOD.
ENDCLASS.               "lcl_point

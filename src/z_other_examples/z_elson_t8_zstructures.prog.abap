*&---------------------------------------------------------------------*
*& Report Z_ELSON_T8_ZSTRUCTURES
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_t8_zstructures.

"Variable structure declared locally in the program
TYPES: BEGIN OF st_flightinfo,
         carrid        TYPE s_carr_id,
         connid        TYPE s_conn_id,
         fldate        TYPE s_date,
         seatsmax      TYPE sflight-seatsmax,
         seatsocc      TYPE sflight-seatsocc,
         percentage(3) TYPE p DECIMALS 2,
       END OF st_flightinfo.

DATA ls_flightinfo TYPE st_flightinfo.

"Variable structure referring to a transparent table
DATA ls_spfli TYPE spfli.

"Variable structure using a Dictionary structure
DATA ls_spfli_2.

DATA: BEGIN OF ls_flightinfo_2,
        carrid        TYPE s_carr_id,
        connid        TYPE s_conn_id,
        fldate        TYPE s_date,
        seatsmax      TYPE sflight-seatsmax,
        seatsocc      TYPE sflight-seatsocc,
        percentage(3) TYPE p DECIMALS 2,
      END OF ls_flightinfo_2.

ls_flightinfo_2-carrid = 'TON'.
ls_flightinfo_2-connid = '0001'.
ls_flightinfo_2-fldate = sy-datum.

WRITE: 'carrid 2:', ls_flightinfo_2-carrid,
       / 'connid 2:', ls_flightinfo_2-connid,
       / 'fldate 2:', ls_flightinfo_2-fldate.

"MOVE
MOVE ls_flightinfo_2-carrid TO ls_flightinfo-carrid.
MOVE '0002' TO ls_flightinfo-connid.
DATA lv_date TYPE d.
lv_date = sy-datum + 1.
MOVE lv_date TO ls_flightinfo-fldate.

WRITE: /, /, 'carrid 1:', ls_flightinfo-carrid,
       / 'connid 1:', ls_flightinfo-connid,
       / 'fldate 1:', ls_flightinfo-fldate.

"MOVE-CORRESPONDING
DATA ls_flightinfo_3 TYPE spfli.
MOVE-CORRESPONDING ls_flightinfo_2 TO ls_flightinfo_3.
WRITE: /, /, 'carrid 3:', ls_flightinfo_3-carrid,
       / 'connid 3:', ls_flightinfo-connid.

DATA ls_flight TYPE zst_flightinfo.

ls_flight-flight_id = '727'.
ls_flight-airline_id = 'MA'.
ls_flight-airline_name = 'My Airline'.
ls_flight-distance = '1500'.
ls_flight-distance_unit = 'KM'.
ls_flight-passenger-name = 'Carlos'.
ls_flight-passenger-id = '12345678'.
ls_flight-passenger-address = 'Tegucigalpa, Honduras'.
ls_flight-passenger-phone = '33322123'.


WRITE: /, /, 'Components of structure ls_flight',
       / 'flight_id:', ls_flight-flight_id,
       / 'airline_id:', ls_flight-airline_id,
       / 'airline_name:', ls_flight-airline_name,
       / 'distance:', ls_flight-distance,
       / 'distance_unit:', ls_flight-distance_unit,
       /, /, 'Components of nested structure passenger',
       / 'name:', ls_flight-passenger-name,
       / 'id:', ls_flight-passenger-id,
       / 'address:', ls_flight-passenger-address,
       / 'phone:', ls_flight-passenger-phone.

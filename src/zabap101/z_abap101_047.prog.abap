*&---------------------------------------------------------------------*
*& Report Z_ABAP101_047
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_047.

DATA: v_timezone1 TYPE tznzone VALUE 'GMTUK',  "Greenwich
      v_timezone2 TYPE tznzone VALUE 'INDIA',  "Delhi
      v_timezone3 TYPE tznzone VALUE 'BRAZIL', "Brasilia
      v_timezone4 TYPE tznzone VALUE 'CST',
      v_timezone5 TYPE tznzone VALUE 'ISRAEL',
      v_timezone6 TYPE tznzone VALUE 'RUS06'.

DATA: v_timestamp        TYPE tzonref-tstamps,
      v_timestamp_string TYPE string.

START-OF-SELECTION.

  CONCATENATE sy-datum sy-uzeit INTO v_timestamp_string.
  v_timestamp = v_timestamp_string.

  WRITE v_timestamp TIME ZONE v_timezone1. NEW-LINE.
  WRITE v_timestamp TIME ZONE v_timezone2. NEW-LINE.
  WRITE v_timestamp TIME ZONE v_timezone3. NEW-LINE.
  WRITE v_timestamp TIME ZONE v_timezone4. NEW-LINE.
  WRITE v_timestamp TIME ZONE v_timezone5. NEW-LINE.
  WRITE v_timestamp TIME ZONE v_timezone6. NEW-LINE.

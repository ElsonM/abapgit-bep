*&---------------------------------------------------------------------*
*& Report Z_ELSON_DY4
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_elson_dy4. "Contains 3 examples

*** --- Example 2 variables and field symbol

*DATA: var1 TYPE i.
*DATA: var2 TYPE i.
*
*FIELD-SYMBOLS: <fs1> TYPE i.
*
*var1  = 3.
*
*MOVE var1 TO var2.
*
*ASSIGN var1 TO <fs1>.
*
*IF <fs1> IS ASSIGNED.
*  WRITE: / 'fs1', <fs1>.
*  CLEAR <fs1>.
*  WRITE: / 'fs1', <fs1>.
*ENDIF.

*** -----------------------------------------

**** --- Print the rows of an internal table using field symbols
*DATA: lt_employee TYPE TABLE OF zemployees2,
*      ls_employee TYPE          zemployees2.
*
*FIELD-SYMBOLS: <fs_line>  TYPE zemployees2,
*               <fs_field> TYPE any.
*
*SELECT * FROM  zemployees2 INTO TABLE lt_employee.
*
*LOOP AT lt_employee ASSIGNING <fs_line>.
*
*  ASSIGN COMPONENT 'SURNAME' OF STRUCTURE <fs_line> TO <fs_field>.
*
*  IF <fs_field> NE 'MILLS'.
*    WRITE: / <fs_field>.
*  ENDIF.
*
*ENDLOOP.
**** -----------------------------------------

** --- Check difference in time of execution for field symbols
DATA: v_time1 TYPE i,
      v_time2 TYPE i.

DATA: lt_employee TYPE TABLE OF zemployees2,
      ls_employee TYPE          zemployees2.

FIELD-SYMBOLS: <fs_line> TYPE zemployees2.

SELECT * FROM  zemployees2 INTO TABLE lt_employee.

DO 20 TIMES.
  APPEND LINES OF lt_employee TO lt_employee.
ENDDO.

* Using normal variables
GET RUN TIME FIELD v_time1.

LOOP AT lt_employee INTO ls_employee.
  ls_employee-surname = 'SMITH'.
  MODIFY lt_employee FROM ls_employee.
ENDLOOP.

GET RUN TIME FIELD v_time2.

* Calculate the differences
v_time2 = v_time2 - v_time1.

* Display the run time
WRITE: / 'Run time in micro seconds = ', v_time2.
CLEAR: v_time1, v_time2.

* Using field symbols

GET RUN TIME FIELD v_time1.
LOOP AT lt_employee ASSIGNING <fs_line>.
  ls_employee-surname = 'SMITH'.
  MODIFY lt_employee FROM ls_employee.
ENDLOOP.

GET RUN TIME FIELD v_time2.

* Calculate the differences
v_time2 = v_time2 - v_time1.

* Display the run time
WRITE: / 'Run time in micro seconds = ', v_time2.
CLEAR: v_time1, v_time2.
** --------------------------------------------------

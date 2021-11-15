*&---------------------------------------------------------------------*
*& Report Z_ABAP101_040
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z_abap101_040.

DATA v_reused_time TYPE t.

DATA v_last_changed_at LIKE v_reused_time.

TYPES ty_last_changed_at LIKE v_reused_time.

DATA: BEGIN OF wa_employee,
        name            TYPE string,
        next_meeting_at LIKE v_reused_time,
      END OF wa_employee.

DATA: BEGIN OF itab_employees OCCURS 0,
        name            TYPE string,
        next_meeting_at LIKE v_reused_time,
      END OF itab_employees.

CONSTANTS c_lunch_time LIKE v_reused_time VALUE '130000'.

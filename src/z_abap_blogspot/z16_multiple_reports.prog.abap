*&---------------------------------------------------------------------*
*& Report Z16_MULTIPLE_REPORTS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT z16_multiple_reports NO STANDARD PAGE HEADING.

DATA: number           TYPE tbtcjob-jobcount,
      name             TYPE tbtcjob-jobname VALUE 'JOB_TEST',
      print_parameters TYPE pri_params.

START-OF-SELECTION.

  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
      jobname          = name
    IMPORTING
      jobcount         = number
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.

  IF sy-subrc = 0.
    SUBMIT z01_dynamic_list TO SAP-SPOOL
           SPOOL PARAMETERS print_parameters
           WITHOUT SPOOL DYNPRO
           VIA JOB name NUMBER number AND RETURN.

    SUBMIT z02_interactive_list_button TO SAP-SPOOL
           SPOOL PARAMETERS print_parameters
           WITHOUT SPOOL DYNPRO
           VIA JOB name NUMBER number AND RETURN.

    SUBMIT z03_simple_alv TO SAP-SPOOL
           SPOOL PARAMETERS print_parameters
           WITHOUT SPOOL DYNPRO
           VIA JOB name NUMBER number AND RETURN.

    SUBMIT z04_simple_alv_mult_tables TO SAP-SPOOL
           SPOOL PARAMETERS print_parameters
           WITHOUT SPOOL DYNPRO
           VIA JOB name NUMBER number AND RETURN.

    SUBMIT z05_alv_dynamic TO SAP-SPOOL
           SPOOL PARAMETERS print_parameters
           WITHOUT SPOOL DYNPRO
           VIA JOB name NUMBER number AND RETURN.

    SUBMIT z06_alv_dynamic_button TO SAP-SPOOL
           SPOOL PARAMETERS print_parameters
           WITHOUT SPOOL DYNPRO
           VIA JOB name NUMBER number AND RETURN.

    SUBMIT z07_alv_list TO SAP-SPOOL
           SPOOL PARAMETERS print_parameters
           WITHOUT SPOOL DYNPRO
           VIA JOB name NUMBER number AND RETURN.

    SUBMIT z08_alv_list_interactive TO SAP-SPOOL
           SPOOL PARAMETERS print_parameters
           WITHOUT SPOOL DYNPRO
           VIA JOB name NUMBER number AND RETURN.

    SUBMIT z09_f4_help TO SAP-SPOOL
           SPOOL PARAMETERS print_parameters
           WITHOUT SPOOL DYNPRO
           VIA JOB name NUMBER number AND RETURN.

    SUBMIT z10_two_alvs TO SAP-SPOOL
           SPOOL PARAMETERS print_parameters
           WITHOUT SPOOL DYNPRO
           VIA JOB name NUMBER number AND RETURN.

    IF sy-subrc = 0.
      CALL FUNCTION 'JOB_CLOSE'
        EXPORTING
          jobcount             = number
          jobname              = name
          strtimmed            = 'X'
        EXCEPTIONS
          cant_start_immediate = 1
          invalid_startdate    = 2
          jobname_missing      = 3
          job_close_failed     = 4
          job_nosteps          = 5
          job_notex            = 6
          lock_failed          = 7
          OTHERS               = 8.

      IF sy-subrc <> 0.
        MESSAGE 'Report not Generated' TYPE 'I'.
      ENDIF.
    ENDIF.
  ENDIF.

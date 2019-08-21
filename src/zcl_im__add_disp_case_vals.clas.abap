class ZCL_IM__ADD_DISP_CASE_VALS definition
  public
  final
  create public .

public section.

  interfaces IF_EX_SCMG_CHNG_BFR_STR_C .
protected section.
private section.
ENDCLASS.



CLASS ZCL_IM__ADD_DISP_CASE_VALS IMPLEMENTATION.


  METHOD if_ex_scmg_chng_bfr_str_c~change.

    DATA: lv_closing_time   TYPE string,
          lv_zzcreate_time  TYPE string,
          lv_zzchange_time  TYPE string,
          lv_zzclosing_time TYPE string.


    CONSTANTS: lc_zzcreate_time  TYPE string VALUE 'ZZCREATE_TIME',
               lc_zzchange_time  TYPE string VALUE 'ZZCHANGE_TIME',
               lc_zzclosing_time TYPE string VALUE 'ZZCLOSING_TIME',
               lc_closing_time   TYPE string VALUE 'CLOSING_TIME'.
*-- Get GUID.
*-- Based on GUID, we came to know that the dispute case is creating
*-- nwely or existed.

    CALL METHOD im_case->get_guid
      RECEIVING
        re_guid = DATA(lv_case_guid).

*-- Check wether the CASE_GUID is already available or New.
    SELECT SINGLE case_guid, create_time, change_time, closing_time
                                    INTO @DATA(ls_scmg_t_case_attr)
                                      FROM scmg_t_case_attr
                                      WHERE case_guid EQ @lv_case_guid.
    IF sy-subrc EQ 0.
*-- Adding ZZCREATE_TIME.
      IF NOT ls_scmg_t_case_attr-create_time EQ 0.
        lv_zzcreate_time = ls_scmg_t_case_attr-create_time+0(8).

        TRY.
            CALL METHOD im_case->set_single_attribute_value
              EXPORTING
                im_value   = lv_zzcreate_time
                im_srmadid = lc_zzcreate_time.
          CATCH cx_srm_framework .
          CATCH cx_scmg_case_attribute .
        ENDTRY.
      ENDIF.
*-- Adding ZZCHNAGE_TIME.
      IF NOT ls_scmg_t_case_attr-change_time EQ 0.
        lv_zzchange_time = sy-datum.
        TRY.
            CALL METHOD im_case->set_single_attribute_value
              EXPORTING
                im_value   = lv_zzchange_time
                im_srmadid = lc_zzchange_time.
          CATCH cx_srm_framework .
          CATCH cx_scmg_case_attribute .
        ENDTRY.
      ENDIF.
*-- Adding ZZCLOSING_TIME. ( It will be done when closing the case ).
      TRY.
          CALL METHOD im_case->if_scmg_case_read~get_single_attribute_value
            EXPORTING
              im_srmadid = lc_closing_time
            RECEIVING
              re_value   = lv_closing_time.

          IF NOT lv_closing_time EQ 0.
            lv_zzclosing_time = sy-datum.
            TRY.
                CALL METHOD im_case->set_single_attribute_value
                  EXPORTING
                    im_value   = lv_zzclosing_time
                    im_srmadid = lc_zzclosing_time.
              CATCH cx_srm_framework .
              CATCH cx_scmg_case_attribute .
            ENDTRY.
          ENDIF.
        CATCH cx_srm_framework .
        CATCH cx_scmg_case_attribute .
      ENDTRY.

    ELSE.

*-- Adding ZZCREATE_TIME.
      lv_zzcreate_time = sy-datum.
      TRY.
          CALL METHOD im_case->set_single_attribute_value
            EXPORTING
              im_value   = lv_zzcreate_time
              im_srmadid = lc_zzcreate_time.
        CATCH cx_srm_framework .
        CATCH cx_scmg_case_attribute .
      ENDTRY.
*-- Adding ZZCHANGE_TIME.
      lv_zzchange_time = sy-datum.
      TRY.
          CALL METHOD im_case->set_single_attribute_value
            EXPORTING
              im_value   = lv_zzchange_time
              im_srmadid = lc_zzchange_time.

        CATCH cx_srm_framework .
        CATCH cx_scmg_case_attribute .
      ENDTRY.

    ENDIF.

    CLEAR: lv_case_guid,
           lv_closing_time,
           lv_zzcreate_time,
           lv_zzchange_time,
           lv_zzclosing_time,
           ls_scmg_t_case_attr.

  ENDMETHOD.
ENDCLASS.

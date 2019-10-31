CLASS zcl_im__add_disp_case_vals DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.

  INTERFACES if_ex_scmg_chng_bfr_str_c .
PROTECTED SECTION.
PRIVATE SECTION.
ENDCLASS.



CLASS zcl_im__add_disp_case_vals IMPLEMENTATION.


METHOD if_ex_scmg_chng_bfr_str_c~change.

"MNS check user exit framework
CHECK zcl_it_exit=>check_active( iv_exitnumber = zif_it_exit=>no_0023 ).
"MNS check user exit framework

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
*-- newely or existed.

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

"MNS S4HANA-1499
"add Reason code to standard table

"check if it comes from Fiori app or SAP Gui
IF sy-cprog EQ 'SAPMHTTP'. "from Fiori App

      TRY.
"get descriptions
          DATA(lv_reason_text) = im_case->if_scmg_case_read~get_single_attribute_value( 'ZZREASON_CODE_TEXT' ).
          DATA(lv_action_text) = im_case->if_scmg_case_read~get_single_attribute_value( 'ZZREQUIRED_ACTION_TEXT' ).
        CATCH cx_srm_framework .
        CATCH cx_scmg_case_attribute .
      ENDTRY.

        IF NOT lv_reason_text IS INITIAL.

"from description - get Reason Code
          SELECT reason_code
            FROM scmgattr_reasont
            WHERE langu       EQ @sy-langu  AND
                  description EQ @lv_reason_text
            ORDER BY PRIMARY KEY
            INTO @DATA(lv_reason_code)
            UP TO 1 ROWS.
          ENDSELECT.
        ELSE.
        CLEAR lv_reason_code.
        ENDIF.

        IF NOT lv_action_text IS INITIAL.
"from description - get Action ID
          SELECT action_id
            FROM zfscm_dm_actt
            WHERE langu       EQ @sy-langu AND
                  action_text EQ @lv_action_text
            ORDER BY PRIMARY KEY
            INTO @DATA(lv_action)
            UP TO 1 ROWS.
          ENDSELECT.
        ELSE.
            CLEAR lv_action.
        ENDIF.

"set Reason code - standard field and custom field
            TRY.

            im_case->set_single_attribute_value(
                im_value   = CONV #( lv_reason_code )
                im_srmadid = im_case->reason_code
            ).


              im_case->set_single_attribute_value(
                    im_value   = CONV #( lv_reason_code )
                    im_srmadid = 'ZZREASON_CODE'
              ).


"set Required Action
              im_case->set_single_attribute_value(
                    im_value   = CONV #( lv_action )
                    im_srmadid = 'ZZREQUIRED_ACTION'
              ).

              CATCH cx_srm_framework .
              CATCH cx_scmg_case_attribute .
            ENDTRY.

ELSE. "From SAP Gui

*Get reason code and action id
      TRY.
         lv_reason_code = im_case->if_scmg_case_read~get_single_attribute_value( 'ZZREASON_CODE' ).
         lv_action = im_case->if_scmg_case_read~get_single_attribute_value( 'ZZREQUIRED_ACTION' ).
         DATA(lv_casetype) = im_case->if_scmg_case_read~get_case_type( ).
        CATCH cx_srm_framework .
        CATCH cx_scmg_case_attribute .
      ENDTRY.

"from Reason Code - Get description
          IF NOT lv_reason_code IS INITIAL.
          SELECT description
            FROM scmgattr_reasont
            WHERE langu       EQ @sy-langu AND
                  case_type   EQ @lv_casetype AND
                  reason_code EQ @lv_reason_code
            INTO @lv_reason_text
            UP TO 1 ROWS.
          ENDSELECT.

        ELSE.
            CLEAR lv_reason_text.
        ENDIF.

"from Action Id - Get description
        IF NOT lv_action IS INITIAL.
          SELECT action_text
            FROM zfscm_dm_actt
            WHERE langu     EQ @sy-langu    AND
                  case_type EQ @lv_casetype AND
                  action_id EQ @lv_action
            INTO @lv_action_text
            UP TO 1 ROWS.
          ENDSELECT.
        ELSE.
        CLEAR lv_action_text.
        ENDIF.

"set Reason code - standard field and custom field
            TRY.

                im_case->set_single_attribute_value(
                    im_value   = CONV #( lv_reason_code )
                    im_srmadid = im_case->reason_code
                ).

                 im_case->set_single_attribute_value(
                    im_value   = lv_reason_text
                    im_srmadid = 'ZZREASON_CODE_TEXT'
                ).

                 im_case->set_single_attribute_value(
                    im_value   = lv_action_text
                    im_srmadid = 'ZZREQUIRED_ACTION_TEXT'
                ).

              CATCH cx_srm_framework .
              CATCH cx_scmg_case_attribute .
            ENDTRY.

ENDIF. "check Fiori or Gui
  ENDMETHOD.
ENDCLASS.

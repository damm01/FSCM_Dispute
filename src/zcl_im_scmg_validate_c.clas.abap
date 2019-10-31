CLASS zcl_im_scmg_validate_c DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

PUBLIC SECTION.

  INTERFACES if_ex_scmg_validate_c .

PROTECTED SECTION.
PRIVATE SECTION.

    METHODS check_action_reason
        IMPORTING iv_case_type TYPE string
                  iv_action    TYPE string
                  iv_reason    TYPE string
        EXPORTING VALUE(ev_is_valid) TYPE bool.

    METHODS check_category_reason
        IMPORTING iv_case_type TYPE string
                  iv_category  TYPE string
                  iv_reason    TYPE string
        EXPORTING VALUE(ev_is_valid) TYPE bool.


ENDCLASS.

CLASS zcl_im_scmg_validate_c IMPLEMENTATION.

METHOD check_action_reason.

      SELECT SINGLE @abap_true
      FROM zfscm_dm_rea_act
      INTO @DATA(lv_result)
      WHERE case_type   EQ @iv_case_type AND
            reason_code EQ @iv_reason AND
            action_id   EQ @iv_action.

      IF sy-subrc EQ 0.
        ev_is_valid = abap_true.
      ENDIF.

  ENDMETHOD.

  METHOD check_category_reason.

    SELECT SINGLE @abap_true
    FROM zfscm_dm_cat_rea
    INTO @DATA(lv_result)
    WHERE case_type   EQ @iv_case_type AND
          category    EQ @iv_category  AND
          reason_code EQ @iv_reason.

    IF sy-subrc EQ 0.
      ev_is_valid = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD if_ex_scmg_validate_c~validate.

*Check if the exit framework is active
    CHECK zcl_it_exit=>check_active( iv_exitnumber = zif_it_exit=>no_0024 ).

 "validation only for Fiori app
IF sy-cprog EQ 'SAPMHTTP'.

TRY.
    DATA(lv_reasont) = im_case->if_scmg_case_read~get_single_attribute_value( 'ZZREASON_CODE_TEXT' ).
    DATA(lv_actiont) = im_case->if_scmg_case_read~get_single_attribute_value( 'ZZREQUIRED_ACTION_TEXT' ).
    CATCH cx_srm_framework .
    CATCH cx_scmg_case_attribute .
ENDTRY.

IF NOT lv_reasont IS INITIAL.
    SELECT reason_code
      FROM scmgattr_reasont
      WHERE langu       EQ @sy-langu AND
            description EQ @lv_reasont
      ORDER BY PRIMARY KEY
      INTO @DATA(lv_reason)
      UP TO 1 ROWS.
    ENDSELECT.

    IF sy-subrc NE 0.
      ex_is_valid = if_srm=>false.

      "Invalid Reason Code
      DATA(ls_messages) = VALUE scmg_attr_return_value(  type = 'E' id = 'ZFSCM_DM'  number = '003' ).
      INSERT ls_messages INTO TABLE ex_messages.

    ENDIF.
ENDIF.  "reason initial

    IF NOT lv_actiont IS INITIAL.

    SELECT action_id
      FROM zfscm_dm_actt
      WHERE action_text EQ @lv_actiont
      ORDER BY PRIMARY KEY
      INTO @DATA(lv_action)
      UP TO 1 ROWS.
    ENDSELECT.

    IF sy-subrc NE 0.
      ex_is_valid = if_srm=>false.

      "Invalid Required Action
  ls_messages = VALUE #( type = 'E' id = 'ZFSCM_DM'
                         number = '004' ).
      INSERT ls_messages INTO TABLE ex_messages.
      CLEAR ls_messages.
    ENDIF.
ENDIF. "lv_action intial
ELSE.
TRY.
        lv_reason = im_case->if_scmg_case_read~get_single_attribute_value( 'ZZREASON_CODE' ).
        lv_action = im_case->if_scmg_case_read~get_single_attribute_value( 'ZZREQUIRED_ACTION' ).
   CATCH cx_srm_framework .
   CATCH cx_scmg_case_attribute .
ENDTRY.

ENDIF. "check fiori or gui

TRY.
     DATA(lv_category) = im_case->if_scmg_case_read~get_single_attribute_value( 'CATEGORY' ).
     DATA(lv_case_type) = im_case->get_case_type( ).
   CATCH cx_srm_framework .
   CATCH cx_scmg_case_attribute .
ENDTRY.

    IF NOT lv_category IS INITIAL AND
       NOT lv_reason   IS INITIAL.

     "Check if Category is assigned to Reason Code
      me->check_category_reason(
        EXPORTING
          iv_case_type = CONV #( lv_case_type )
          iv_category  = lv_category
          iv_reason    = CONV #( lv_reason )
        IMPORTING
          ev_is_valid  = DATA(lv_is_valid)
      ).

      IF lv_is_valid = abap_false.

      ex_is_valid = if_srm=>false.

      "Reason Code & not assigned to Category &
      ls_messages = VALUE #( type = 'E' id = 'ZFSCM_DM'  number = '002'
                              message_v1 = lv_reason
                              message_v2 = lv_category  ).
      INSERT ls_messages INTO TABLE ex_messages.

      ENDIF. "is valid
    CLEAR lv_is_valid.

    ENDIF. "category and reason not initial

    "Check if Reason Code is assigned to Required Action
    IF NOT lv_action IS INITIAL AND
       NOT lv_reason IS INITIAL.

      me->check_action_reason(
        EXPORTING
          iv_case_type = CONV #( lv_case_type )
          iv_action    = CONV #( lv_action )
          iv_reason    = CONV #( lv_reason )
        IMPORTING
          ev_is_valid  = lv_is_valid
      ).

      IF lv_is_valid = abap_false.
      ex_is_valid = if_srm=>false.


      "Required Action & not assigned to Reason code &
       ls_messages = VALUE #( type = 'E' id = 'ZFSCM_DM' number = '001'
                              message_v1 = lv_action
                              message_v2 = lv_reason  ).
      INSERT ls_messages INTO TABLE ex_messages.

      ENDIF.
    CLEAR lv_is_valid.

    ENDIF. "action and reason not initial


ENDMETHOD.
ENDCLASS.

CLASS zcl_zudmo_dispute_srmp_dpc_ext DEFINITION
  PUBLIC
  INHERITING FROM zcl_zudmo_dispute_srmp_dpc
  CREATE PUBLIC .

PUBLIC SECTION.
PROTECTED SECTION.

  METHODS zc_dispute_srmpr_get_entityset
    REDEFINITION .
PRIVATE SECTION.
  METHODS set_username
  CHANGING
    et_entityset TYPE zcl_zudmo_dispute_srmp_mpc=>tt_zc_dispute_srmprotocoltype.

  METHODS set_log_attribute_labels
    CHANGING
      et_entityset TYPE zcl_zudmo_dispute_srmp_mpc=>tt_zc_dispute_srmprotocoltype.

METHODS set_activity_name
    CHANGING
      et_entityset TYPE zcl_zudmo_dispute_srmp_mpc=>tt_zc_dispute_srmprotocoltype.

ENDCLASS.


CLASS zcl_zudmo_dispute_srmp_dpc_ext IMPLEMENTATION.


  METHOD zc_dispute_srmpr_get_entityset.
**TRY.
*CALL METHOD SUPER->ZC_DISPUTE_SRMPR_Get_entityset
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
** CATCH /iwbep/cx_mgw_busi_exception .
** CATCH /iwbep/cx_mgw_tech_exception .
**ENDTRY.

" 005056A5F0F91EE9BDAE813FA15B4884

    " IT_FILTER_SELECT_OPTIONS
    READ TABLE it_filter_select_options ASSIGNING FIELD-SYMBOL(<ls_filter>) WITH KEY property = 'case_guid'.
    CHECK sy-subrc EQ 0 AND lines( <ls_filter>-select_options ) > 0.

    DATA lv_case_guid TYPE bapiscmgcase-case_guid.
    lv_case_guid = <ls_filter>-select_options[ 1 ]-low.

    "lv_case_guid
    DATA: ls_return TYPE bapiret2,
          lt_log_entries TYPE TABLE OF bapilog.

    CALL FUNCTION 'BAPI_CASE_READLOG'
      EXPORTING
        guid        = lv_case_guid
      IMPORTING
        return      = ls_return
      TABLES
        log_entries = lt_log_entries
      .
    et_entityset = CORRESPONDING #( lt_log_entries ).

    me->set_username( CHANGING !et_entityset = et_entityset ).
    me->set_activity_name( CHANGING !et_entityset = et_entityset ).
    me->set_log_attribute_labels( CHANGING !et_entityset = et_entityset ).


  ENDMETHOD.

  METHOD set_username.

  IF et_entityset IS NOT INITIAL.

  DATA: lt_return   TYPE TABLE OF bapiret2,
        lv_username TYPE bapibname-bapibname,
        ls_address  TYPE bapiaddr3.

  TYPES: BEGIN OF ty_username,
          user     TYPE bapibname-bapibname,
          fullname TYPE bapiaddr3-fullname.
  TYPES: END OF ty_username.

   DATA: lv_string TYPE string,
         lt_users  TYPE TABLE OF ty_username.

  lt_users = CORRESPONDING #( et_entityset MAPPING user = xuser ).
  SORT lt_users.
  DELETE ADJACENT DUPLICATES FROM lt_users.

  "getting user name
  LOOP AT lt_users ASSIGNING FIELD-SYMBOL(<ls_users>).

   MOVE <ls_users>-user TO lv_username.

  CALL FUNCTION 'BAPI_USER_GET_DETAIL'
    EXPORTING
      username       = lv_username
      cache_results  = abap_true
    IMPORTING
       address        = ls_address
    TABLES
      return         = lt_return
    .

    <ls_users>-fullname = ls_address-fullname.

  ENDLOOP.

  LOOP AT et_entityset ASSIGNING FIELD-SYMBOL(<ls_entity>).
          READ TABLE lt_users ASSIGNING <ls_users>
              WITH KEY user = <ls_entity>-xuser.
          CHECK sy-subrc = 0.
          <ls_entity>-display_name = <ls_users>-fullname.
  ENDLOOP.

  ENDIF.
  ENDMETHOD.

  METHOD set_log_attribute_labels.

    IF et_entityset IS NOT INITIAL.
      TYPES: BEGIN OF  ty_fieldname,
               fieldname TYPE dd03l-fieldname,
             END OF  ty_fieldname.

      DATA: lv_string TYPE string,
            lt_attribute_names TYPE TABLE OF ty_fieldname .

      lt_attribute_names = CORRESPONDING #( et_entityset MAPPING fieldname = arg_string ).
      SORT lt_attribute_names.
      DELETE ADJACENT DUPLICATES FROM lt_attribute_names.

      " getting field names for append structure
      IF lt_attribute_names IS NOT INITIAL.
      SELECT fieldname, rollname
        FROM dd03l
        FOR ALL ENTRIES IN @lt_attribute_names
        WHERE fieldname = @lt_attribute_names-fieldname AND
            ( tabname = 'CI_UDMCASEATTR00'              OR
              tabname = 'UDMCASEATTR00'                 OR
              tabname = 'SCMG_T_CASE_ATTR')
        INTO TABLE @DATA(lt_dd03l).
     ENDIF.

      if sy-subrc eq 0.
        SELECT rollname, ddlanguage, scrtext_m  "#EC CI_NO_TRANSFORM "#EC CI_SUBRC
          FROM dd04t
          FOR ALL ENTRIES IN @lt_dd03l
          WHERE rollname = @lt_dd03l-rollname
          INTO TABLE @DATA(lt_field_texts).
      ENDIF.

      LOOP AT et_entityset ASSIGNING FIELD-SYMBOL(<ls_entity>).
        READ TABLE lt_dd03l ASSIGNING FIELD-SYMBOL(<ls_dd03l>)
            WITH KEY fieldname = <ls_entity>-arg_string.
        CHECK sy-subrc = 0.

        READ TABLE lt_field_texts ASSIGNING FIELD-SYMBOL(<ls_text_field>)
            WITH KEY rollname = <ls_dd03l>-rollname
                     ddlanguage = sy-langu.
        IF sy-subrc <> 0.
          READ TABLE lt_field_texts ASSIGNING <ls_text_field>
            WITH KEY rollname = <ls_dd03l>-rollname
                     ddlanguage = 'E'.
          CHECK sy-subrc = 0.
        ENDIF.

        <ls_entity>-arg_string = <ls_text_field>-scrtext_m.
      ENDLOOP.

    ENDIF.
  ENDMETHOD.

METHOD set_activity_name.

IF et_entityset IS NOT INITIAL.

DATA: lt_return   TYPE TABLE OF bapiret2,
      lv_text     TYPE sotr_txt,
      lv_act_otr_ref TYPE sotr_alias.

  TYPES: BEGIN OF ty_activities,
          act_otr_ref TYPE sotr_alias,
          act_name TYPE sotr_txt.
  TYPES: END OF ty_activities.

   DATA: lv_string TYPE string,
         lt_activities  TYPE TABLE OF ty_activities.

  lt_activities = CORRESPONDING #( et_entityset MAPPING act_otr_ref = act_otr_ref ).
  SORT lt_activities.
  DELETE ADJACENT DUPLICATES FROM lt_activities.

"getting user name
  LOOP AT lt_activities ASSIGNING FIELD-SYMBOL(<ls_acts>).

   MOVE <ls_acts>-act_otr_ref TO lv_act_otr_ref.

  CALL FUNCTION 'SOTR_GET_TEXT_KEY'
    EXPORTING
      alias                  =  lv_act_otr_ref
      lfd_num                = 0001
      langu                  = sy-langu
    IMPORTING
      e_text                 =  lv_text
    EXCEPTIONS
      no_entry_found         = 1
      parameter_error        = 2
      OTHERS                 = 3.

  IF sy-subrc EQ 0.
    <ls_acts>-act_name = lv_text.
  ENDIF.

  ENDLOOP.

  LOOP AT et_entityset ASSIGNING FIELD-SYMBOL(<ls_entity>).
          READ TABLE lt_activities ASSIGNING <ls_acts>
              WITH KEY act_otr_ref = <ls_entity>-act_otr_ref.
          CHECK sy-subrc = 0.
          <ls_entity>-act_id = <ls_acts>-act_name.
  ENDLOOP.

ENDIF.

ENDMETHOD.

ENDCLASS.

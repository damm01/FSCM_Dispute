CLASS zcl_scmg_attr_f4_callback DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_scmg_attr_f4_callback.

    DATA: lo_read TYPE REF TO cl_scmg_case.

  PROTECTED SECTION.

PRIVATE SECTION.

  METHODS execute_reason_f4
    IMPORTING
      !im_case_type   TYPE scmgcase_type
      !im_category    TYPE string
    CHANGING
      !ch_f4_val TYPE shvalue_d
    EXCEPTIONS
    cx_scmg_case_attribute
    cx_srm_framework.

  METHODS execute_action_f4
    IMPORTING
      !im_case_type   TYPE scmgcase_type
      !im_reason_code TYPE string
    CHANGING
      !ch_f4_val TYPE shvalue_d
    EXCEPTIONS
    cx_scmg_case_attribute
    cx_srm_framework.


ENDCLASS.



CLASS zcl_scmg_attr_f4_callback IMPLEMENTATION.


METHOD execute_action_f4.
  DATA: lt_fcat TYPE lvc_t_fcat,
        ls_fcat TYPE lvc_s_fcat,
        l_index LIKE sy-tabix,
        ls_selfield    TYPE slis_selfield,
        lv_reason_code TYPE string,
        ls_rea_act TYPE zfscm_dm_rea_act,
        lt_rea_act TYPE TABLE OF zfscm_dm_rea_act_s.


  REFRESH: lt_rea_act, lt_fcat.
  CLEAR:  ls_rea_act, ls_fcat.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZFSCM_DM_REA_ACT_S'
    CHANGING
      ct_fieldcat      = lt_fcat.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT lt_fcat INTO ls_fcat.
    l_index = sy-tabix.

    IF ls_fcat-fieldname = 'CASE_TYPE'.
      ls_fcat-no_out = 'X'.
      MODIFY lt_fcat FROM ls_fcat
        INDEX l_index
        TRANSPORTING no_out.
    ENDIF.

  ENDLOOP.

  SELECT a~case_type a~reason_code a~action_id b~action_text
    FROM zfscm_dm_rea_act AS a
    INNER JOIN zfscm_dm_actt AS b ON a~action_id = b~action_id
    INTO CORRESPONDING FIELDS OF TABLE lt_rea_act
    WHERE a~case_type   = im_case_type AND
          a~reason_code = im_reason_code and
          b~langu       = sy-langu.

IF sy-subrc EQ 0.

  CALL FUNCTION 'LVC_SINGLE_ITEM_SELECTION'
    EXPORTING
      it_fieldcatalog = lt_fcat
    IMPORTING
      es_selfield     = ls_selfield
    TABLES
      t_outtab        = lt_rea_act.

  IF NOT ls_selfield IS INITIAL.
    READ TABLE lt_rea_act INTO ls_rea_act
               INDEX ls_selfield-tabindex.  "#EC CI_SORTED
    ch_f4_val = ls_rea_act-action_id.
  ENDIF.
ELSE.
    MESSAGE i006(zfscm_dm) WITH im_reason_code.
    "No Required Action assigned to Reason Code &
  ENDIF.

ENDMETHOD.


METHOD execute_reason_f4 .

  DATA: lt_fcat        TYPE lvc_t_fcat,
        ls_fcat        TYPE lvc_s_fcat,
        l_index        LIKE sy-tabix,
        ls_selfield    TYPE slis_selfield,
        lt_cat_rea     TYPE TABLE OF zfscm_dm_cat_re_s,
        ls_cat_rea     TYPE zfscm_dm_cat_re_s.

  REFRESH: lt_cat_rea, lt_fcat.
  CLEAR: ls_fcat, ls_cat_rea.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZFSCM_DM_CAT_RE_S'
    CHANGING
      ct_fieldcat      = lt_fcat
    .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT lt_fcat INTO ls_fcat.
    l_index = sy-tabix.

    IF ls_fcat-fieldname = 'CASE_TYPE'.
      ls_fcat-no_out = 'X'.
      MODIFY lt_fcat FROM ls_fcat
        INDEX l_index
        TRANSPORTING no_out.
    ENDIF.
 ENDLOOP.

CLEAR lt_cat_rea.

 SELECT a~case_type a~category a~reason_code b~description
    FROM zfscm_dm_cat_rea AS a
    INNER JOIN scmgattr_reasont AS b ON a~case_type   = b~case_type AND
                                        a~reason_code = b~reason_code
    INTO CORRESPONDING FIELDS OF TABLE lt_cat_rea
    WHERE a~case_type = im_case_type AND
          a~category  = im_category  and
          b~langu     = sy-langu.

  IF sy-subrc EQ 0.
  CALL FUNCTION 'LVC_SINGLE_ITEM_SELECTION'
    EXPORTING
      it_fieldcatalog = lt_fcat
    IMPORTING
      es_selfield     = ls_selfield
    TABLES
      t_outtab        = lt_cat_rea.

  IF NOT ls_selfield IS INITIAL.
    READ TABLE lt_cat_rea INTO ls_cat_rea
               INDEX ls_selfield-tabindex.  "#EC CI_SORTED
    ch_f4_val = ls_cat_rea-reason_code.
  ENDIF.
  ELSE.
    MESSAGE i005(zfscm_dm) WITH im_category.
    "No reason code assigned to Category &
  ENDIF.

ENDMETHOD.


  METHOD if_scmg_attr_f4_callback~get_drop_down_values.
  ENDMETHOD.


  METHOD if_scmg_attr_f4_callback~get_instance.

  DATA:
    l_f4_callback TYPE REF TO zcl_scmg_attr_f4_callback.

  CREATE OBJECT l_f4_callback.
  re_instance = l_f4_callback.


  ENDMETHOD.


  METHOD if_scmg_attr_f4_callback~process_f4.

    DATA:
      ls_type_data     TYPE scmgcasetype,
      lv_reason_code   TYPE scmg_reason_code,
      lv_value_c(4)    TYPE c,
      lv_value         TYPE string.


  DATA: ls_sel_object   TYPE objec,
        lv_seark        TYPE seark,
        l_case          TYPE REF TO cl_scmg_case_visualization_win,
        lv_value_reason TYPE srmavstr,
        lv_value_cat    TYPE srmavstr,
        lv_otype        TYPE otype,
        lt_attr_tab     TYPE srm_list_edit_attribute_value,
        lr_attr         TYPE REF TO if_srm_edit_attribute_value,
        lv_attr_name    TYPE string,
        lt_string       TYPE srm_list_string,
        ls_string       TYPE srmliststr.


  l_case ?= im_attr_display->caller.

  lt_attr_tab = l_case->g_attributes.

 IF NOT lt_attr_tab IS INITIAL.

*   Get attribute
    TRY.
        im_attr_display->get_screen_values( im_values = lt_attr_tab ).
      CATCH cx_root.
    ENDTRY.


    LOOP AT lt_attr_tab INTO lr_attr.

      TRY.
          lv_attr_name = lr_attr->if_srm_attribute_value~get_id( ).
        CATCH cx_root.
      ENDTRY.

      IF lv_attr_name = 'CATEGORY'.
        TRY.
         lt_string = lr_attr->if_srm_attribute_value~get_ddic_string( ).
          CATCH cx_root.
        ENDTRY.
        LOOP AT lt_string INTO ls_string.
          EXIT.
        ENDLOOP.
        IF sy-subrc = 0.
          lv_value_cat = ls_string-value.
        ENDIF.
      ENDIF.

      IF lv_attr_name = 'ZZREASON_CODE'.
        TRY.
         lt_string = lr_attr->if_srm_attribute_value~get_ddic_string( ).
          CATCH cx_root.
        ENDTRY.
        LOOP AT lt_string INTO ls_string.
          EXIT.
        ENDLOOP.
        IF sy-subrc = 0.
          lv_value_reason = ls_string-value.
        ENDIF.
        EXIT.
      ENDIF.
    ENDLOOP.
  ENDIF.


    CASE im_id.



     WHEN 'ZZREASON_CODE'.
       MOVE lv_value_cat TO lv_value.


      CALL METHOD me->execute_reason_f4
        EXPORTING
          im_case_type = l_case->g_case_type
          im_category = lv_value
        CHANGING
          ch_f4_val    = ch_f4_val.


      WHEN 'ZZREQUIRED_ACTION'.

       MOVE lv_value_reason TO lv_value.

       CALL METHOD me->execute_action_f4
        EXPORTING
          im_case_type = l_case->g_case_type
          im_reason_code = lv_value
        CHANGING
          ch_f4_val    = ch_f4_val.


    ENDCASE.
  ENDMETHOD.
ENDCLASS.

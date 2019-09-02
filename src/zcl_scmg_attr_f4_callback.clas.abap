CLASS zcl_scmg_attr_f4_callback DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_scmg_attr_f4_callback.

    DATA: lo_read TYPE REF TO cl_scmg_case.

  PROTECTED SECTION.

PRIVATE SECTION.

  METHODS execute_action_f4
    IMPORTING
      !im_case_type TYPE scmgcase_type
    CHANGING
      !ch_f4_val TYPE shvalue_d
    exceptions
    CX_SCMG_CASE_ATTRIBUTE
    CX_SRM_FRAMEWORK.

  METHODS execute_reason_f4
    IMPORTING
      !im_case_type TYPE scmgcase_type
    CHANGING
      !ch_f4_val TYPE shvalue_d
    exceptions
    CX_SCMG_CASE_ATTRIBUTE
    CX_SRM_FRAMEWORK.

ENDCLASS.



CLASS ZCL_SCMG_ATTR_F4_CALLBACK IMPLEMENTATION.


METHOD execute_action_f4.
  DATA: lt_fcat TYPE lvc_t_fcat,
        ls_fcat TYPE lvc_s_fcat,
        l_index LIKE sy-tabix,
        lt_actions    TYPE STANDARD TABLE OF zfifscm_action,
        l_action      TYPE zfifscm_action_id,
        li_cnt_action   TYPE i,
        li_cnt_actiont  TYPE i,
        lt_action TYPE STANDARD TABLE OF zfifscm_actiont,
        ls_action TYPE zfifscm_actiont,
        ls_selfield    TYPE slis_selfield,
        lv_reason_code TYPE string.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'ZFIFSCM_ACTIONT'
    CHANGING
      ct_fieldcat      = lt_fcat.

  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT lt_fcat INTO ls_fcat.
    l_index = sy-tabix.

    IF ls_fcat-fieldname = 'LANGU' OR
       ls_fcat-fieldname = 'CASE_TYPE'.
      ls_fcat-no_out = 'X'.
      MODIFY lt_fcat FROM ls_fcat
        INDEX l_index
        TRANSPORTING no_out.
    ENDIF.
    IF ls_fcat-fieldname = 'ACTION_ID'.
      ls_fcat-outputlen = 10.
      MODIFY lt_fcat FROM ls_fcat
        INDEX l_index
        TRANSPORTING outputlen.
    ENDIF.
  ENDLOOP.

  CLEAR: li_cnt_action, li_cnt_actiont ,lt_actions, lt_action.

*  CREATE OBJECT lo_read.

*TRY.
*  lv_reason_code = lo_read->get_single_attribute_value('REASON_CODE').
*  CATCH cx_scmg_case_attribute.
*  CATCH cx_srm_framework.
*ENDTRY.

  SELECT * FROM zfifscm_action
    INTO TABLE lt_actions
    WHERE case_type = im_case_type.

  DESCRIBE TABLE lt_actions LINES li_cnt_action .

  IF li_cnt_action <> 0.

    SELECT * FROM zfifscm_actiont
      INTO CORRESPONDING FIELDS OF TABLE lt_action
      FOR ALL ENTRIES IN lt_actions
      WHERE langu       = sy-langu
        AND case_type   = im_case_type
        AND action_id = lt_actions-action_id.

  ELSE.
    RETURN.
  ENDIF.

  DESCRIBE TABLE lt_action LINES li_cnt_actiont.
  IF li_cnt_action > li_cnt_actiont." there are some entries which dont have desc in sy langu
    LOOP AT lt_actions INTO l_action.   "#EC CI_NOORDER
      READ TABLE lt_action WITH KEY action_id = l_action TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0. " descp in logon language does not exist..pick EN one
        CLEAR ls_action.
        ls_action-mandt = sy-mandt .
        ls_action-langu = sy-langu.
        ls_action-case_type = im_case_type.
        ls_action-action_id = l_action.
        APPEND ls_action TO lt_action.
      ENDIF.
    ENDLOOP.
    SORT lt_action BY action_id.
  ENDIF.


  CALL FUNCTION 'LVC_SINGLE_ITEM_SELECTION'
    EXPORTING
      it_fieldcatalog = lt_fcat
    IMPORTING
      es_selfield     = ls_selfield
    TABLES
      t_outtab        = lt_action.

  IF NOT ls_selfield IS INITIAL.
    READ TABLE lt_action INTO ls_action
               INDEX ls_selfield-tabindex.  "#EC CI_SORTED
    ch_f4_val = ls_action-action_id.
  ENDIF.

ENDMETHOD.


METHOD execute_reason_f4 .

  DATA: lt_fcat TYPE lvc_t_fcat,
        ls_fcat TYPE lvc_s_fcat,
        l_index LIKE sy-tabix,
        lt_reasons      TYPE STANDARD TABLE OF scmg_reason_code,
        l_reason      TYPE scmg_reason_code,
        li_cnt_reason   TYPE i,
        li_cnt_reasont  TYPE i,
        lt_reason TYPE STANDARD TABLE OF scmgattr_reasont,
        ls_reason TYPE scmgattr_reasont,
        ls_selfield    TYPE slis_selfield.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = 'SCMGATTR_REASONT'
    CHANGING
      ct_fieldcat      = lt_fcat
    .
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  LOOP AT lt_fcat INTO ls_fcat.
    l_index = sy-tabix.

    IF ls_fcat-fieldname = 'LANGU' OR
       ls_fcat-fieldname = 'CASE_TYPE'.
      ls_fcat-no_out = 'X'.
      MODIFY lt_fcat FROM ls_fcat
        INDEX l_index
        TRANSPORTING no_out.
    ENDIF.
    IF ls_fcat-fieldname = 'REASON_CODE'.
      ls_fcat-outputlen = 10.
      MODIFY lt_fcat FROM ls_fcat
        INDEX l_index
        TRANSPORTING outputlen.
    ENDIF.
  ENDLOOP.
*--PANDEP--note 1834675--reason F4 shows ld/deleted entries too-----
  CLEAR: li_cnt_reason, li_cnt_reasont ,lt_reasons, lt_reason.
  SELECT reason_code FROM scmgattr_reason
    INTO TABLE lt_reasons
    WHERE case_type = im_case_type.
  DESCRIBE TABLE lt_reasons LINES li_cnt_reason .
  IF li_cnt_reason <> 0.
    SELECT * FROM scmgattr_reasont
      INTO CORRESPONDING FIELDS OF TABLE lt_reason
      FOR ALL ENTRIES IN lt_reasons
      WHERE langu       = sy-langu
        AND case_type   = im_case_type
        AND reason_code = lt_reasons-table_line.
  ELSE.
    RETURN.
  ENDIF.
  DESCRIBE TABLE lt_reason LINES li_cnt_reasont.
  IF li_cnt_reason > li_cnt_reasont." there are some entries which dont have desc in sy langu
    LOOP AT lt_reasons INTO l_reason.   "#EC CI_NOORDER
      READ TABLE lt_reason WITH KEY reason_code = l_reason TRANSPORTING NO FIELDS.
      IF sy-subrc <> 0. " descp in logon language does not exist..pick EN one
        CLEAR ls_reason.
        ls_reason-mandt = sy-mandt .
        ls_reason-langu = sy-langu.
        ls_reason-case_type = im_case_type.
        ls_reason-reason_code = l_reason.
        APPEND ls_reason TO lt_reason.
      ENDIF.
    ENDLOOP.
    SORT lt_reason BY reason_code.
  ENDIF.
*--PANDEP--note 1834675--reason F4 shows ld/deleted entries too-----
  CALL FUNCTION 'LVC_SINGLE_ITEM_SELECTION'
    EXPORTING
      it_fieldcatalog = lt_fcat
    IMPORTING
      es_selfield     = ls_selfield
    TABLES
      t_outtab        = lt_reason.

  IF NOT ls_selfield IS INITIAL.
    READ TABLE lt_reason INTO ls_reason
               INDEX ls_selfield-tabindex.  "#EC CI_SORTED
    ch_f4_val = ls_reason-reason_code.
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
      l_case       TYPE REF TO cl_scmg_case_visualization_win,
      ls_type_data TYPE scmgcasetype,
      lv_reason_code TYPE scmg_reason_code,
      lv_attributes TYPE REF TO if_srm_edit_attribute_value.

    INTERFACE if_scmg_case_read LOAD.

    CASE im_id.
      WHEN 'ZZREQUIRED_ACTION'.
        l_case ?= im_attr_display->caller.

      CALL METHOD me->execute_action_f4
        EXPORTING
          im_case_type = l_case->g_case_type
        CHANGING
          ch_f4_val    = ch_f4_val.

      WHEN if_scmg_case_read=>reason_code.
        l_case ?= im_attr_display->caller.

      CALL METHOD me->execute_reason_f4
        EXPORTING
          im_case_type = l_case->g_case_type
        CHANGING
          ch_f4_val    = ch_f4_val.

    ENDCASE.
  ENDMETHOD.
ENDCLASS.

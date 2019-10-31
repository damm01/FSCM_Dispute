FUNCTION zudm_dispute_oip_text_read.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     VALUE(TABNAME) TYPE  TABNAME
*"     VALUE(FIELDNAME) TYPE  FIELDNAME
*"     VALUE(DATAELEMENTNAME) TYPE  ROLLNAME
*"     VALUE(DOMAINNAME) TYPE  DOMNAME
*"     VALUE(MODE) TYPE  C
*"     VALUE(FIELDVALUE) TYPE  ANY OPTIONAL
*"     VALUE(RECORD) TYPE  ANY OPTIONAL
*"     VALUE(RECORD_SPECIFIED) TYPE  FLAG_X OPTIONAL
*"     VALUE(LANGUAGE) TYPE  SY-LANGU OPTIONAL
*"     REFERENCE(VALUESOURCE_TABLES) TYPE  TFIELDVAL
*"     REFERENCE(SPECIAL_PARAMETERS) TYPE  TFIELDVAL
*"  EXPORTING
*"     REFERENCE(TEXT_EXISTS_TYPE) TYPE  I
*"     REFERENCE(TEXT) TYPE  TEXT255
*"     REFERENCE(TEXT_FOR_VALUE_READ) TYPE  FLAG_X
*"     REFERENCE(LIKE_TABNAME) TYPE  TABNAME
*"     REFERENCE(LIKE_FIELDNAME) TYPE  FIELDNAME
*"     REFERENCE(REQUIRED_FIELDS) TYPE  TTFIELDNAME
*"     REFERENCE(REQUIRED_TABLE_FIELDS) TYPE  TTABFIELD
*"----------------------------------------------------------------------
  CLASS cl_text_identifier DEFINITION LOAD.

  DATA: l_subrc TYPE sysubrc.
  DATA: l_record TYPE scmg_t_case_attr.

  FIELD-SYMBOLS: <l_logsys> TYPE logsys,
                 <l_type> TYPE scmgcase_type,
                 <l_profile> TYPE scmgstatusprofid,
                 <l_strat> TYPE udm_coll_strategy.

        FIELD-SYMBOLS: <l_guid> TYPE scmg_case_guid.

  DATA l_fieldname TYPE fieldname.

  IF dataelementname = 'ZFSCM_DM_ACTION'.

    like_tabname = 'ZFSCM_DM_ACTT'.
    like_fieldname = 'ACTION_TEXT'.


    IF mode = 'IDENTIFY_TEXT'.

      text_exists_type = cl_text_identifier=>co_tetype_readable_w_record.
      MOVE 'CASE_TYPE' TO l_fieldname.
      APPEND l_fieldname TO required_fields.

    ELSEIF mode = 'READ_TEXT'.

      ASSIGN COMPONENT 'CASE_TYPE' OF STRUCTURE record TO <l_type>.

      IF sy-subrc = 0.

        PERFORM f_required_action_text USING text fieldvalue  <l_type> l_subrc.

* Start of note 2405192
      ELSE.
        ASSIGN COMPONENT 'CASE_GUID' OF STRUCTURE record TO <l_guid>.
        IF sy-subrc = 0.
           SELECT SINGLE case_type FROM scmg_t_case_attr INTO l_record-case_type
             WHERE case_guid = <l_guid>.
           ASSIGN COMPONENT 'CASE_TYPE' OF STRUCTURE l_record TO <l_type>.
           PERFORM f_required_action_text USING text fieldvalue  <l_type> l_subrc.
        ENDIF.
      ENDIF.
* End of note 2405192

        IF l_subrc = 0.
          text_for_value_read = 'X'.
        ENDIF.
    ENDIF.

  ELSEIF dataelementname = 'ZFSCM_DM_REASON_CODE'.

    like_tabname = 'SCMGATTR_REASONT'.
    like_fieldname = 'DESCRIPTION'.


    IF mode = 'IDENTIFY_TEXT'.

      text_exists_type = cl_text_identifier=>co_tetype_readable_w_record.
      MOVE 'CASE_TYPE' TO l_fieldname.
      APPEND l_fieldname TO required_fields.

    ELSEIF mode = 'READ_TEXT'.

      ASSIGN COMPONENT 'CASE_TYPE' OF STRUCTURE record TO <l_type>.

      IF sy-subrc = 0.

        PERFORM f_reason_code_text USING text fieldvalue  <l_type> l_subrc.

* Start of note 2405192
      ELSE.

        ASSIGN COMPONENT 'CASE_GUID' OF STRUCTURE record TO <l_guid>.
        IF sy-subrc = 0.
           SELECT SINGLE case_type FROM scmg_t_case_attr INTO l_record-case_type
             WHERE case_guid = <l_guid>.
           ASSIGN COMPONENT 'CASE_TYPE' OF STRUCTURE l_record TO <l_type>.
           PERFORM f_reason_code_text USING text fieldvalue  <l_type> l_subrc.
        ENDIF.
        ENDIF.
* End of note 2405192

        IF l_subrc = 0.

          text_for_value_read = 'X'.
        ENDIF.

    ENDIF.

  ENDIF.

ENDFUNCTION.

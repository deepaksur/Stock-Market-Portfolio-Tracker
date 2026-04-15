CLASS zcl_ptf_ut_22it018 DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_ptf_hdr,
             portfolioid TYPE zcit_ptf_ele_018 ,
           END OF ty_ptf_hdr,
           BEGIN OF ty_stk_itm,
             portfolioid TYPE zcit_ptf_ele_018 ,
             stockitemno TYPE int2,
           END OF ty_stk_itm.
    TYPES: tt_ptf_hdr TYPE STANDARD TABLE OF ty_ptf_hdr,
           tt_stk_itm TYPE STANDARD TABLE OF ty_stk_itm.

    CLASS-METHODS get_instance
      RETURNING VALUE(ro_instance) TYPE REF TO zcl_ptf_ut_22it018.

    METHODS:
      set_hdr_value
        IMPORTING im_ptf_hdr    TYPE zcit_ptf_h_it018
        EXPORTING ex_created    TYPE abap_boolean,
      get_hdr_value
        EXPORTING ex_ptf_hdr    TYPE zcit_ptf_h_it018,
      set_itm_value
        IMPORTING im_stk_itm    TYPE zcit_ptf_s_it018
        EXPORTING ex_created    TYPE abap_boolean,
      get_itm_value
        EXPORTING ex_stk_itm    TYPE zcit_ptf_s_it018,
      set_hdr_t_deletion
        IMPORTING im_ptf_doc    TYPE ty_ptf_hdr,
      set_itm_t_deletion
        IMPORTING im_stk_info   TYPE ty_stk_itm,
      get_hdr_t_deletion
        EXPORTING ex_ptf_docs   TYPE tt_ptf_hdr,
      get_itm_t_deletion
        EXPORTING ex_stk_info   TYPE tt_stk_itm,
      set_hdr_deletion_flag
        IMPORTING im_ptf_delete TYPE abap_boolean,
      get_deletion_flags
        EXPORTING ex_ptf_hdr_del TYPE abap_boolean,
      cleanup_buffer.

  PRIVATE SECTION.
    CLASS-DATA: gs_ptf_hdr_buff  TYPE zcit_ptf_h_it018,
                gs_stk_itm_buff  TYPE zcit_ptf_s_it018,
                gt_ptf_hdr_t_buff TYPE tt_ptf_hdr,
                gt_stk_itm_t_buff TYPE tt_stk_itm,
                gv_ptf_delete     TYPE abap_boolean.
    CLASS-DATA mo_instance TYPE REF TO zcl_ptf_ut_22it018.

ENDCLASS.

CLASS zcl_ptf_ut_22it018 IMPLEMENTATION.

  METHOD get_instance.
    IF mo_instance IS INITIAL.
      CREATE OBJECT mo_instance.
    ENDIF.
    ro_instance = mo_instance.
  ENDMETHOD.

  METHOD set_hdr_value.
    IF im_ptf_hdr-portfolioid IS NOT INITIAL.
      gs_ptf_hdr_buff = im_ptf_hdr.
      ex_created = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_hdr_value.
    ex_ptf_hdr = gs_ptf_hdr_buff.
  ENDMETHOD.

  METHOD set_itm_value.
    IF im_stk_itm IS NOT INITIAL.
      gs_stk_itm_buff = im_stk_itm.
      ex_created = abap_true.
    ENDIF.
  ENDMETHOD.

  METHOD get_itm_value.
    ex_stk_itm = gs_stk_itm_buff.
  ENDMETHOD.

  METHOD set_hdr_t_deletion.
    APPEND im_ptf_doc TO gt_ptf_hdr_t_buff.
  ENDMETHOD.

  METHOD set_itm_t_deletion.
    APPEND im_stk_info TO gt_stk_itm_t_buff.
  ENDMETHOD.

  METHOD get_hdr_t_deletion.
    ex_ptf_docs = gt_ptf_hdr_t_buff.
  ENDMETHOD.

  METHOD get_itm_t_deletion.
    ex_stk_info = gt_stk_itm_t_buff.
  ENDMETHOD.

  METHOD set_hdr_deletion_flag.
    gv_ptf_delete = im_ptf_delete.
  ENDMETHOD.

  METHOD get_deletion_flags.
    ex_ptf_hdr_del = gv_ptf_delete.
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: gs_ptf_hdr_buff, gs_stk_itm_buff,
           gt_ptf_hdr_t_buff, gt_stk_itm_t_buff,
           gv_ptf_delete.
  ENDMETHOD.

ENDCLASS.

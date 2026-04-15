CLASS lhc_PortfolioHdr DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR PortfolioHdr RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR PortfolioHdr RESULT result.
    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE PortfolioHdr.
    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE PortfolioHdr.
    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE PortfolioHdr.
    METHODS read FOR READ
      IMPORTING keys FOR READ PortfolioHdr RESULT result.
    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK PortfolioHdr.
    METHODS rba_StockItem FOR READ
      IMPORTING keys_rba FOR READ PortfolioHdr\_StockItem
      FULL result_requested RESULT result LINK association_links.
    METHODS cba_StockItem FOR MODIFY
      IMPORTING entities_cba FOR CREATE PortfolioHdr\_StockItem.
ENDCLASS.

CLASS lhc_PortfolioHdr IMPLEMENTATION.

  METHOD get_instance_authorizations. ENDMETHOD.
  METHOD get_global_authorizations.   ENDMETHOD.
  METHOD lock.                        ENDMETHOD.

  METHOD create.
    DATA: ls_ptf_hdr TYPE zcit_ptf_h_it018.
    LOOP AT entities INTO DATA(ls_entities).
      ls_ptf_hdr = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).
      IF ls_ptf_hdr-portfolioid IS NOT INITIAL.
        SELECT FROM zcit_ptf_h_it018 FIELDS *
          WHERE portfolioid = @ls_ptf_hdr-portfolioid
          INTO TABLE @DATA(lt_ptf_hdr).
        IF sy-subrc NE 0.
          DATA(lo_util) = zcl_ptf_ut_22it018=>get_instance( ).
          lo_util->set_hdr_value(
            EXPORTING im_ptf_hdr = ls_ptf_hdr
            IMPORTING ex_created = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #( %cid = ls_entities-%cid
                            portfolioid = ls_ptf_hdr-portfolioid )
              TO mapped-portfoliohdr.
            APPEND VALUE #( %cid = ls_entities-%cid
                            portfolioid = ls_ptf_hdr-portfolioid
              %msg = new_message( id = 'ZCIT_PTF_22IT018' number = 001
                v1 = 'Portfolio Created Successfully'
                severity = if_abap_behv_message=>severity-success ) )
              TO reported-portfoliohdr.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_entities-%cid
                          portfolioid = ls_ptf_hdr-portfolioid )
            TO failed-portfoliohdr.
          APPEND VALUE #( %cid = ls_entities-%cid
                          portfolioid = ls_ptf_hdr-portfolioid
            %msg = new_message( id = 'ZCIT_PTF_22IT018' number = 001
              v1 = 'Duplicate Portfolio ID'
              severity = if_abap_behv_message=>severity-error ) )
            TO reported-portfoliohdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA: ls_ptf_hdr TYPE zcit_ptf_h_it018.
    LOOP AT entities INTO DATA(ls_entities).
      ls_ptf_hdr = CORRESPONDING #( ls_entities MAPPING FROM ENTITY ).
      IF ls_ptf_hdr-portfolioid IS NOT INITIAL.
        SELECT FROM zcit_ptf_h_it018 FIELDS *
          WHERE portfolioid = @ls_ptf_hdr-portfolioid
          INTO TABLE @DATA(lt_ptf_hdr).
        IF sy-subrc EQ 0.
          DATA(lo_util) = zcl_ptf_ut_22it018=>get_instance( ).
          lo_util->set_hdr_value(
            EXPORTING im_ptf_hdr = ls_ptf_hdr
            IMPORTING ex_created = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #( portfolioid = ls_ptf_hdr-portfolioid )
              TO mapped-portfoliohdr.
            APPEND VALUE #( %key = ls_entities-%key
              %msg = new_message( id = 'ZCIT_PTF_22IT018' number = 001
                v1 = 'Portfolio Updated Successfully'
                severity = if_abap_behv_message=>severity-success ) )
              TO reported-portfoliohdr.
          ENDIF.
        ELSE.
          APPEND VALUE #( %cid = ls_entities-%cid_ref
                          portfolioid = ls_ptf_hdr-portfolioid )
            TO failed-portfoliohdr.
          APPEND VALUE #( %cid = ls_entities-%cid_ref
                          portfolioid = ls_ptf_hdr-portfolioid
            %msg = new_message( id = 'ZCIT_PTF_22IT018' number = 001
              v1 = 'Portfolio Not Found'
              severity = if_abap_behv_message=>severity-error ) )
            TO reported-portfoliohdr.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    TYPES: BEGIN OF ty_ptf_hdr, portfolioid TYPE zcit_ptf_ele_018 , END OF ty_ptf_hdr.
    DATA ls_ptf_hdr TYPE ty_ptf_hdr.
    DATA(lo_util) = zcl_ptf_ut_22it018=>get_instance( ).
    LOOP AT keys INTO DATA(ls_key).
      CLEAR ls_ptf_hdr.
      ls_ptf_hdr-portfolioid = ls_key-portfolioid.
      lo_util->set_hdr_t_deletion( EXPORTING im_ptf_doc = ls_ptf_hdr ).
      lo_util->set_hdr_deletion_flag( EXPORTING im_ptf_delete = abap_true ).
      APPEND VALUE #( %cid = ls_key-%cid_ref
                      portfolioid = ls_key-portfolioid
        %msg = new_message( id = 'ZCIT_PTF_22IT018' number = 001
          v1 = 'Portfolio Deleted Successfully'
          severity = if_abap_behv_message=>severity-success ) )
        TO reported-portfoliohdr.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE FROM zcit_ptf_h_it018 FIELDS *
        WHERE portfolioid = @ls_key-portfolioid
        INTO @DATA(ls_hdr).
      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_hdr ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_StockItem.
    LOOP AT keys_rba INTO DATA(ls_key).
      SELECT FROM zcit_ptf_s_it018 FIELDS *
        WHERE portfolioid = @ls_key-portfolioid
        INTO TABLE @DATA(lt_items).
      LOOP AT lt_items INTO DATA(ls_item).
        APPEND CORRESPONDING #( ls_item ) TO result.
        APPEND VALUE #(
          source-portfolioid = ls_key-portfolioid
          target-portfolioid = ls_item-portfolioid
          target-stockitemno = ls_item-stockitemno )
        TO association_links.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

  METHOD cba_StockItem.
    DATA ls_stk_itm TYPE zcit_ptf_s_it018.
    LOOP AT entities_cba INTO DATA(ls_entities_cba).
      ls_stk_itm = CORRESPONDING #( ls_entities_cba-%target[ 1 ] ).
      IF ls_stk_itm-portfolioid IS NOT INITIAL AND ls_stk_itm-stockitemno IS NOT INITIAL.
        SELECT FROM zcit_ptf_s_it018 FIELDS *
          WHERE portfolioid = @ls_stk_itm-portfolioid
            AND stockitemno = @ls_stk_itm-stockitemno
          INTO TABLE @DATA(lt_stk_itm).
        IF sy-subrc NE 0.
          DATA(lo_util) = zcl_ptf_ut_22it018=>get_instance( ).
          lo_util->set_itm_value(
            EXPORTING im_stk_itm = ls_stk_itm
            IMPORTING ex_created = DATA(lv_created) ).
          IF lv_created EQ abap_true.
            APPEND VALUE #(
              %cid        = ls_entities_cba-%target[ 1 ]-%cid
              portfolioid = ls_stk_itm-portfolioid
              stockitemno = ls_stk_itm-stockitemno )
            TO mapped-stockitem.
            APPEND VALUE #(
              %cid        = ls_entities_cba-%target[ 1 ]-%cid
              portfolioid = ls_stk_itm-portfolioid
              %msg = new_message( id = 'ZCIT_PTF_22IT018' number = 001
                v1 = 'Stock Item Created Successfully'
                severity = if_abap_behv_message=>severity-success ) )
            TO reported-stockitem.
          ENDIF.
        ELSE.
          APPEND VALUE #(
            %cid        = ls_entities_cba-%target[ 1 ]-%cid
            portfolioid = ls_stk_itm-portfolioid
            stockitemno = ls_stk_itm-stockitemno )
          TO failed-stockitem.
          APPEND VALUE #(
            %cid        = ls_entities_cba-%target[ 1 ]-%cid
            portfolioid = ls_stk_itm-portfolioid
            %msg = new_message( id = 'ZCIT_PTF_22IT018' number = 001
              v1 = 'Duplicate Stock Item'
              severity = if_abap_behv_message=>severity-error ) )
          TO reported-stockitem.
        ENDIF.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

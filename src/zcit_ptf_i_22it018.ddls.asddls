@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Root Interface View - Portfolio Header'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZCIT_PTF_I_22IT018
  as select from zcit_ptf_h_it018 as ptfHeader
  composition [0..*] of ZCIT_STK_I_22IT018 as _stockitem
{
  key portfolioid         as PortfolioId,
  portfolioname           as PortfolioName,
  ownername               as OwnerName,
  basecurrency            as BaseCurrency,
  @Semantics.amount.currencyCode: 'BaseCurrency'
  totalvalue              as TotalValue,
  createdon               as CreatedOn,
  riskprofile             as RiskProfile,
  @Semantics.user.createdBy: true
  local_created_by        as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at        as LocalCreatedAt,
  @Semantics.user.lastChangedBy: true
  local_last_changed_by   as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at   as LocalLastChangedAt,

  /* Associations */
  _stockitem
}

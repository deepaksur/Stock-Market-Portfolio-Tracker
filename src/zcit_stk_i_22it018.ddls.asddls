@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Child Interface View - Stock Items'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
  serviceQuality: #X,
  sizeCategory: #S,
  dataClass: #MIXED
}
define view entity ZCIT_STK_I_22IT018
  as select from zcit_ptf_s_it018
  association to parent ZCIT_PTF_I_22IT018 as _portfolio
    on $projection.PortfolioId = _portfolio.PortfolioId
{
  key portfolioid         as PortfolioId,
  key stockitemno         as StockItemNo,
  tickersymbol            as TickerSymbol,
  companyname             as CompanyName,
  exchange                as Exchange,
  sector                  as Sector,
  @Semantics.quantity.unitOfMeasure: 'QuantityUnit'
  quantity                as Quantity,
  quantityunit            as QuantityUnit,
  @Semantics.amount.currencyCode: 'Currency'
  buyprice                as BuyPrice,
  @Semantics.amount.currencyCode: 'Currency'
  currentprice            as CurrentPrice,
  currency                as Currency,
  purchasedate            as PurchaseDate,
  @Semantics.user.createdBy: true
  local_created_by        as LocalCreatedBy,
  @Semantics.systemDateTime.createdAt: true
  local_created_at        as LocalCreatedAt,
  @Semantics.user.lastChangedBy: true
  local_last_changed_by   as LocalLastChangedBy,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed_at   as LocalLastChangedAt,

  /* Associations */
  _portfolio
}

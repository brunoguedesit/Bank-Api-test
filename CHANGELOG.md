# changelog

## Unreleasead

## [0.1.1] - 2021-04-10
### Added

- add split payment route
- add split payment function at operations module and controller
- add transaction and account struct at Jason.Encoder protocol


### Changed

- refactor(transaction_view): change the response for the split payment operation
- refactor(config): put never value into exchanges_rates_retrievery_every to not exceed our requests into our free plan at OpenExchangesRates api

### Removed

- removed tuple encoder, because we dont need anymore
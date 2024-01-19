1. (Relative Stability) Anchored or Pegged to USD
    - our 1 stable coin will always worth $1
    - we should write a code to make sure 1 stable coin == $1
2. Stability Mechanism (Minting):
    - Algorathmic (Decentralized)
3. Collateral Type: Exogenous
    - we will use crypto currencies as collateral
    - wETH
    - wBTC

We will use chainlink pricefeed to get the dollar equivalent value of wETH & wBTC

### \_healthFactor()

To calculate the health factor

```sol
    uint256 private constant LIQUIDATION_THRESHOLD = 50; //user should be 200% overcollateralized
    uint256 private constant LIQUIDATION_PRECISION = 100;

    function _calculateHealthFactor(address user) private view returns (uint256) {
        (uint256 totalDSCMinted, uint256 collateralValueInUsd) = _getAccountInformation(user);
        uint256 collateralAdjustedForThreshold =
            ((collateralValueInUsd * LIQUIDATION_THRESHOLD) / LIQUIDATION_PRECISION);
        return ((collateralAdjustedForThreshold * PRECISION) / totalDSCMinted);
    }

    // since we are multiplying with liquidation threshold, we have to divide by 100

    // collateralValueInUsd = $2000 => 2000e18
    // totalDSCMinted = 100 DSC // value in wei => 100e18
    // collateralValueInUsd * LIQUIDATION_THRESHOLD = 2000e18 * 50 = $100000e18
    // ((collateralValueInUsd * LIQUIDATION_THRESHOLD) / LIQUIDATION_PRECISION) = 100000e18 / 100 = 1000e18
    // collateralAdjustedForThreshold = 1000e18
    // collateralAdjustedForThreshold * PRECISION = 1000e18 * 1e18 = 1000e36
    // ((collateralAdjustedForThreshold * PRECISION) / totalDSCMinted) = 1000e36 / 100e18 = 10e18
    // healthfactor > 1

    // HealthFactor < 1
    // collateralValueInUsd = $150 => 150e18
    // totalDSCMinted = 100 DSC // value in wei => 100e18
    // collateralValueInUsd * LIQUIDATION_THRESHOLD = 150 * 50 = 7500e18
    // ((collateralValueInUsd * LIQUIDATION_THRESHOLD) / LIQUIDATION_PRECISION) = 7500e18 / 100 = 75e18
    // collateralAdjustedForThreshold = 75e18
    // collateralAdjustedForThreshold * PRECISION = 75e18 * 1e18 = 75e36
    // ((collateralAdjustedForThreshold * PRECISION) / totalDSCMinted) = 75e36 / 100e18 = 0.75e18
    // healthfactor < 1
```

Liquidation()

```
    /// If we do start nearing undercollateralization, we need someone to liquidate positions
    /// we need someone to call redeem and burn onbehalf of the user

    // If $100 worth of ETH is backing $50 worth of DSC
    // If the price of ETH tanks to $20
    // now $20 worth of ETH is backing $50 worth of DSC,
    // which means this is undercollateralized, we can't let this happen
    // we need to make sure to liquidate peoples positions before they become undercollateralized

    // If someone is almost undercollateralized, the protoccol will pay to the person whoever liquidates
    // protocol will incentives someone if they liquidate peoples position

    // If $100 worth of ETH is backing $50 worth of DSC
    // this person is 200% overcollateralized, which is good.
    // If ETH price tanks to $99, then this user is undercollateralized
    // someone has to liquidate this persons position
    // whoever is calling the liquidate
    // they will pay the $50 worth of DSC which is the debt amount
    // since the covered the debt amount, they will be incentivized
    // they will be give $99 worth of ETH
    // this user earned $49 worth of ETH, by liquidating someones position
    function liquidate(uint256 amount) public {}
```

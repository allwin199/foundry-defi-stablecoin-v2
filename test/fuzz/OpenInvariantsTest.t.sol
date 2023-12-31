// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// This contract will contain our invariant aka properties

// What are our invariants?

// 1. The total supply of DSC should be less than the total value of collateral
// 2. Getter view functions should never revert

import {Test} from "forge-std/Test.sol";
import {StdInvariant} from "forge-std/StdInvariant.sol";

import {DeployDSCEngine} from "../../script/DeployDSCEngine.s.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {ERC20Mock} from "@openzeppelin/contracts/mocks/ERC20Mock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract OpenInvariantsTest is StdInvariant, Test {
    DSCEngine public dscEngine;
    DecentralizedStableCoin public dsCoin;
    HelperConfig public helperConfig;

    address public weth;
    address public wbtc;
    address public ethUsdPriceFeed;
    address public btcUsdPriceFeed;
    uint256 public deployerKey;

    address public user = address(1);
    uint256 public constant STARTING_USER_BALANCE = 10e18;

    function setUp() public {
        DeployDSCEngine deployer = new DeployDSCEngine();
        (dscEngine, dsCoin, helperConfig) = deployer.run();
        (weth, wbtc, ethUsdPriceFeed, btcUsdPriceFeed, deployerKey) = helperConfig.activeNetworkConfig();
        if (block.chainid == 31337) {
            vm.deal(user, STARTING_USER_BALANCE);
        }

        /// @dev user should have some balance.
        ERC20Mock(weth).mint(user, STARTING_USER_BALANCE);
        ERC20Mock(wbtc).mint(user, STARTING_USER_BALANCE);

        // targeted contract
        targetContract(address(dscEngine));
    }

    // function invariant_ProtocolMustHave_MoreValue_ThanDSC() public {
    //     // get the value of all the collateral in the protocol
    //     // compare it to all the debt (DSC)

    //     uint256 totalSupployOfDSC = dsCoin.totalSupply();
    //     uint256 totalWethDeposited = IERC20(weth).balanceOf(address(dscEngine));
    //     uint256 totalWbtcDeposited = IERC20(wbtc).balanceOf(address(dscEngine));

    //     uint256 wethValue = dscEngine.getUsdValue(weth, totalWethDeposited);
    //     uint256 wbtcValue = dscEngine.getUsdValue(wbtc, totalWbtcDeposited);

    //     // assertGe(wethValue + wbtcValue, totalSupployOfDSC);
    // }
}

// for open based testing, keep fail_on_revert as false

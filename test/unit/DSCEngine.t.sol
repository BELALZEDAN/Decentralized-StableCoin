// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {DeployDSC} from "../../script/DeployDSC.s.sol";
import {DSCEngine} from "../../src/DSCEngine.sol";
import {DecentralizedStableCoin} from "../../src/DecentralizedStableCoin.sol";
import {Test, console} from "forge-std/Test.sol";
import {HelperConfig} from "../../script/HelperConfig.s.sol";
import {ERC20Mock} from "../mocks/ERC20Mock.sol";

contract DSCEngineTest is Test {
    DeployDSC deployer;
    DecentralizedStableCoin dsc;
    DSCEngine dsce;
    HelperConfig config;

    address weth;
    address ethUsdPriceFeed;
    address public USER = makeAddr("user");

    uint256 public constant AMOUNT_COLLATERAL = 10 ether;
    uint256 public constant STARTING_ERC20_BALANCE = 10 ether;
    uint256 public constant MINT_AMOUNT = 1000 ether;

    function setUp() public {
        deployer = new DeployDSC();
        (dsc, dsce, config) = deployer.run();
        (ethUsdPriceFeed, , weth, , ) = config.activeNetworkConfig();

        ERC20Mock(weth).mint(USER, STARTING_ERC20_BALANCE);
    }

    /////////////////////////
    // Price Feed & Values //
    /////////////////////////

    function testGetUsdValue() public {
        // 15 ETH * 2000 = 30,000 USD
        uint256 ethAmount = 15e18;
        uint256 expectedUsd = 30000e18;
        uint256 actualUsd = dsce.getUsdValue(weth, ethAmount);
        assertEq(expectedUsd, actualUsd);
    }

    /////////////////////////////
    // depositCollateral Tests //
    /////////////////////////////

    function testRevertsIfCollateralZero() public {
        vm.startPrank(USER);
        ERC20Mock(weth).approve(address(dsce), AMOUNT_COLLATERAL);
        vm.expectRevert(DSCEngine.DSCEngine__NeedsMoreThanZero.selector);
        dsce.depositCollateral(weth, 0);
        vm.stopPrank();
    }

    function testCanDepositCollateral() public {
        vm.startPrank(USER);
        ERC20Mock(weth).approve(address(dsce), AMOUNT_COLLATERAL);
        dsce.depositCollateral(weth, AMOUNT_COLLATERAL);
        vm.stopPrank();

        uint256 collateralValue = dsce.getAccountCollateralValue(USER);
        // 10 ETH * 2000 = 20,000 USD
        assertEq(collateralValue, 20000e18);
    }

    //////////////////
    // Minting DSC  //
    //////////////////

    function testRevertsIfMintZero() public {
        vm.startPrank(USER);
        vm.expectRevert(DSCEngine.DSCEngine__NeedsMoreThanZero.selector);
        dsce.mintDsc(0);
        vm.stopPrank();
    }

    function testCanMintDscAfterDeposit() public {
        vm.startPrank(USER);
        ERC20Mock(weth).approve(address(dsce), AMOUNT_COLLATERAL);
        dsce.depositCollateral(weth, AMOUNT_COLLATERAL);
        dsce.mintDsc(1000e18);
        vm.stopPrank();

        uint256 userBalance = dsc.balanceOf(USER);
        assertEq(userBalance, 1000e18);
    }

    /////////////////////////////
    // Redeem & Burn Functions //
    /////////////////////////////

   function testRedeemCollateralAndBurnDsc() public {
    vm.startPrank(USER);

    // Arrange: approve + deposit + mint
    ERC20Mock(weth).approve(address(dsce), AMOUNT_COLLATERAL);
    dsce.depositCollateral(weth, AMOUNT_COLLATERAL);
    dsce.mintDsc(1000e18);

    // Act: user burns proportional DSC and redeems collateral
    dsc.approve(address(dsce), 1000e18);
    dsce.redeemCollateralForDsc(weth, AMOUNT_COLLATERAL, 1000e18);

    vm.stopPrank();

    uint256 remainingCollateral = dsce.getAccountCollateralValue(USER);
    assertEq(remainingCollateral, 0);
    assertEq(dsc.balanceOf(USER), 0);
}


    /////////////////////////////
    // Liquidation (Basic Test)//
    /////////////////////////////

    function testRevertsIfHealthFactorOkOnLiquidation() public {
        vm.startPrank(USER);
        ERC20Mock(weth).approve(address(dsce), AMOUNT_COLLATERAL);
        dsce.depositCollateral(weth, AMOUNT_COLLATERAL);
        dsce.mintDsc(1000e18);
        vm.stopPrank();

        vm.startPrank(address(1));
        vm.expectRevert(DSCEngine.DSCEngine__HealthFactorOk.selector);
        dsce.liquidate(weth, USER, 100e18);
        vm.stopPrank();
    }
}

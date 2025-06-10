// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Test, console} from "forge-std/Test.sol";
import {ProjectFactory} from "../src/Factory.sol";

contract CrowdfundTest is Test {
    ProjectFactory public factory;

    function setUp() public {
        factory = new ProjectFactory();
    }

    function testProjectCreation() public {
        factory.createProject(500 ether, "FundX", "FX");
        // assertEq(Factory.)
    }
}

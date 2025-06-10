// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.21;

import "./Project.sol";

contract ProjectFactory {
    address[] public projects;

    event ProjectCreated(address creatorOfProject, address indexed project, uint256 goalAmount, string nameOfProject);

    function createProject(uint256 goalAmount, string memory nameOfProject, string calldata symbol) external {
        Project project = new Project(msg.sender, goalAmount, nameOfProject, symbol);
        projects.push(address(project));
        emit ProjectCreated(msg.sender, address(project), goalAmount, nameOfProject);
    }

    function getProjects() external view returns (address[] memory) {
        return projects;
    }
}

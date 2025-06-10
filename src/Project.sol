// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.2 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract Project is ERC721 {
    address public immutable CREATOR;
    uint256 public constant RAISE_DURATION = 30 days;
    uint256 public immutable CREATION_TIME;
    uint256 public TOTAL_RAISED;
    uint256 public immutable GOAL_AMOUNT;

    mapping(address => uint256) contribution;
    mapping(address => uint256) badgesClaimed;
    uint256 public tokenId;
    uint256 public amountWithdrawn;

    event Contributed(address contributor, uint256 amount);
    event ProjectCanceled(uint256 timeStamp);
    event Refunded(address contributor, uint256 amount);
    event Withdrawn(address creator, uint256 amount);

    enum Status {
        Active,
        Completed,
        Failed
    }

    Status public status;

    receive() external payable {
        revert("Use contribute");
    }

    modifier onlyCreator() {
        require(CREATOR == msg.sender, "Not creator");
        _;
    }

    modifier isActive() {
        require(status == Status.Active, "Not Active");
        require(CREATION_TIME + RAISE_DURATION > block.timestamp, "Expired");
        require(TOTAL_RAISED < GOAL_AMOUNT, "Goal met");
        _;
    }

    constructor(address creator_, uint256 goalAmount_, string memory nameOfProject_, string memory symbol_)
        ERC721(nameOfProject_, symbol_)
    {
        require(goalAmount_ > 0.01 ether, "Invalid amount");
        status = Status.Active;
        CREATOR = creator_;
        GOAL_AMOUNT = goalAmount_;
        CREATION_TIME = block.timestamp;
    }

    function contribute() public payable isActive {
        require(msg.value >= 0.01 ether, "Amount less than 0.01 ether");
        require(TOTAL_RAISED + msg.value <= GOAL_AMOUNT, "Exceeds goal");
        if (TOTAL_RAISED + msg.value >= GOAL_AMOUNT) {
            status = Status.Completed;
        }

        contribution[msg.sender] += msg.value;
        TOTAL_RAISED += msg.value;

        emit Contributed(msg.sender, msg.value);
        uint256 badgeToGive = contribution[msg.sender] / 1 ether - badgesClaimed[msg.sender];

        if (msg.sender.code.length > 0) {
            try IERC721Receiver(msg.sender).onERC721Received(address(this), address(0), tokenId, "") returns (
                bytes4 retval
            ) {
                require(retval == IERC721Receiver.onERC721Received.selector, "Receiver does not accept ERC721");
            } catch {
                revert("Receiver contract must implement IERC721Receiver");
            }
        }

        for (uint256 i = 0; i < badgeToGive; i++) {
            _safeMint(msg.sender, tokenId++);
            badgesClaimed[msg.sender]++;
        }
    }

    function cancelProject() external onlyCreator isActive {
        status = Status.Failed;
        emit ProjectCanceled(block.timestamp);
    }

    function refund() external {
        require(status == Status.Active, "Refund not allowed");
        require(TOTAL_RAISED < GOAL_AMOUNT, "Goal met");
        require(block.timestamp > CREATION_TIME + RAISE_DURATION, "Refund period not started");
        uint256 amount = contribution[msg.sender];
        require(amount > 0, "0 amount to withdraw");

        contribution[msg.sender] = 0;
        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "Refund failed");

        emit Refunded(msg.sender, amount);
    }

    function withdraw(uint256 amount) external onlyCreator {
        require(status == Status.Completed, "Goal not met");
        uint256 available = TOTAL_RAISED - amountWithdrawn;
        require(amount <= available, "Insufficient balance");

        amountWithdrawn += amount;

        (bool success,) = payable(msg.sender).call{value: amount}("");
        require(success, "Withdraw failed");

        emit Withdrawn(msg.sender, amount);
    }
}

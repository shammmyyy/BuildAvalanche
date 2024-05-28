// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    event VoucherCreated(address indexed creator, string voucherName, uint256 quantity, uint256 price);
    event VoucherRedeemed(address indexed redeemer, string voucherName, uint256 quantity);

    struct Voucher {
        uint256 quantity;
        uint256 price;
    }

    mapping(string => Voucher) public vouchers;

    constructor(address initialOwner) Ownable(initialOwner) ERC20("Degen", "DGN") {}

    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }

    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        _transfer(_msgSender(), to, amount);
        return true;
    }

    function createVoucher(string memory voucherName, uint256 quantity, uint256 price) external onlyOwner {
        require(quantity > 0, "Quantity must be greater than zero");
        require(price > 0, "Price must be greater than zero");

        vouchers[voucherName] = Voucher({
            quantity: quantity,
            price: price
        });

        emit VoucherCreated(msg.sender, voucherName, quantity, price);
    }

    function redeemVoucher(string memory voucherName, uint256 quantity) external {
        Voucher storage voucher = vouchers[voucherName];
        require(voucher.quantity >= quantity, "Not enough vouchers available");
        require(voucher.price * quantity <= balanceOf(msg.sender), "Insufficient balance");

        _burn(msg.sender, voucher.price * quantity);
        voucher.quantity -= quantity;

        emit VoucherRedeemed(msg.sender, voucherName, quantity);
    }

    function checkVoucherBalance(address account, string memory voucherName) external view returns (uint256) {
        return balanceOf(account) / vouchers[voucherName].price;
    }
}


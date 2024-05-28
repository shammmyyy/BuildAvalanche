// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Etherium is ERC20, Ownable {
    uint256 private _maxOwnerMint;
    mapping(address => uint256) private _ownerMintedAmounts;

    constructor(address owner) ERC20("Etherium", "ETH") Ownable(owner) {
        // Initialize the maximum owner mint to 0
        _maxOwnerMint = 300;
    }

    modifier onlyUnderMaxOwnerMint(uint256 amount) {
        require(_ownerMintedAmounts[msg.sender] + amount <= _maxOwnerMint, "Exceeds max owner mint");
        _;
    }

    function mint(address to, uint256 amount) public onlyOwner onlyUnderMaxOwnerMint(amount) {
        _mint(to, amount);
        _ownerMintedAmounts[msg.sender] += amount;
    }

    function burn(uint256 amount) public {
        _burn(msg.sender, amount);
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        return super.transfer(to, amount);
    }

    function setMaxOwnerMint(uint256 maxOwnerMint) public onlyOwner {
        _maxOwnerMint = maxOwnerMint;
    }

    function getMaxOwnerMint() public view returns (uint256) {
        return _maxOwnerMint;
    }

    function getOwnerMintedAmount(address owner) public view returns (uint256) {
        return _ownerMintedAmounts[owner];
    }
}

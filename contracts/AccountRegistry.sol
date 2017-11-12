pragma solidity ^0.4.15;

import "zeppelin/ownership/Ownable.sol";
import "zeppelin/token/SafeERC20.sol";
import "zeppelin/token/ERC20.sol";
import "./InviteCollateralizer.sol";

contract AccountRegistry is Ownable {
  mapping(address => bool) public accounts;
  mapping(address => bool) public invites;
  mapping(address => mapping(address => bool)) pendingInvites;
  address public inviteCollateralizer;
  ERC20 public blt;

  function AccountRegistry(ERC20 _blt) {
    inviteCollateralizer = new InviteCollateralizer(this, _blt);
    blt = _blt;
    accounts[owner] = true;
  }

  function invite(address _recipient) {
    require(accounts[msg.sender] && !invites[_recipient]);
    require(InviteCollateralizer(inviteCollateralizer).takeCollateral(msg.sender));
    invites[_recipient] = true;
  }

  function acceptInvite() {
    require(invites[msg.sender]);

    invites[msg.sender] = false;
    accounts[msg.sender] = true;
  }
}

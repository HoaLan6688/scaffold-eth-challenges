// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;

// import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";


contract Streamer {
  event Opened(address, uint256);
  event Challenged(address);
  event Closed(address);
  event Withdrawn(address, uint256);

  mapping(address => uint256) balances;
  mapping(address => uint256) closeAt;

  function fundChannel() public payable {
    /*
      Checkpoint 3: fund a channel

      complete this function so that it:
      - reverts if msg.sender already has a running channel (ie, if balances[msg.sender] != 0)
      - updates the balances mapping with the eth recieved in the function call
      - emits an Opened event
    */
  }

  function challengeChannel() public {
      require(balances[msg.sender] > 0, "no user channel exists");
  
      closeAt[msg.sender] = block.timestamp + 2 minutes;
      emit Challenged(msg.sender);
  }

  function timeLeft(address channel) public view returns (uint256) {
    require(closeAt[channel] != 0, "channel is not closing");
    return closeAt[channel] - block.timestamp;
  }


  function liquidateChannel() public {
    require(balances[msg.sender] > 0, "no channel exists");
    require(closeAt[msg.sender] != 0, "channel is not marked for closure");
    require(block.timestamp > closeAt[msg.sender], "not yet ready to close");

    bool sent;
    bytes memory mem;
    (sent, mem) = msg.sender.call{value: balances[msg.sender]}("");
    require(sent, "liquidation failed");
    balances[msg.sender] = 0;
    emit Closed(msg.sender);
  }

  function withdrawEarnings(Voucher calldata v) public {
    // like the off-chain code, signatures are applied to the hash of the data
    // instead of the raw data itself
    bytes32 hashed = keccak256(abi.encode(v.updatedBalance));

    // The prefix string here is part of a convention used in ethereum for signing
    // and verification of off-chain messages. The trailing 32 refers to the 32 byte
    // length of the attached hash message.
    //
    // There are seemingly extra steps here compared to what was done in the off-chain
    // `reimburseService` and `processVoucher`. Note that those ethers signing and verification
    // functinos do the same under the hood.
    //
    // again, see https://blog.ricmoo.com/verifying-messages-in-solidity-50a94f82b2ca
    bytes memory prefixed = abi.encodePacked('\x19Ethereum Signed Message:\n32', hashed);
    bytes32 prefixedHashed = keccak256(prefixed);

    /*
      Checkpoint 5: Recover earnings

      The service provider would like to cash out their hard earned ether.
    */

    // use ecrecover on prefixedHashed and the supplied signature

    // require that the recovered signer has a running channel with balances[signer] > v.updatedBalance

    // calculate the payment when reducing balances[signer] to v.updatedBalance

    // adjust the channel balance, and pay the contract owner. (Get the owner address with 
    // the `owner()` function)
    
  }

  struct Voucher {
    uint256 updatedBalance;
    Signature sig;
  }
  struct Signature {
    bytes32 r;
    bytes32 s;
    uint8 v;
  }
}

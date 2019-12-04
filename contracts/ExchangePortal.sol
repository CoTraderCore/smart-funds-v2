pragma solidity ^0.4.24;

import "./ExchangePortalInterface.sol";
import "./zeppelin-solidity/contracts/ownership/Ownable.sol";
import "./zeppelin-solidity/contracts/math/SafeMath.sol";
import "./zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol";
import "./paraswap/ParaswapInterface";
import "./paraswap/IPriceFeed";

/*
* The ExchangePortal contract is an implementation of ExchangePortalInterface that allows
* SmartFunds to exchange and calculate their value via KyberNetwork
*/
contract ExchangePortal is ExchangePortalInterface, Ownable {
  using SafeMath for uint256;

  ParaswapInterface public paraswapInterface;
  IPriceFeed public priceFeedInterface;
  address public paraswap;

  enum ExchangeType { Paraswap }

  // Paraswap recognizes ETH by this address
  ERC20 constant private ETH_TOKEN_ADDRESS = ERC20(0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE);

  mapping (address => bool) disabledTokens;

  event Trade(address trader, address src, uint256 srcAmount, address dest, uint256 destReceived, uint8 exchangeType);

  // Modifier to check that trading this token is not disabled
  modifier tokenEnabled(ERC20 _token) {
    require(!disabledTokens[address(_token)]);
    _;
  }

  /**
  * @dev contructor
  *
  * @param _paraswap        paraswap main address
  * @param _paraswapPrice   paraswap price feed address
  */
  constructor(address _paraswap, address _paraswapPrice) public {
    paraswapInterface = paraswapInterface(_paraswap);
    priceFeedInterface = IPriceFeed(_paraswapPrice);
    paraswap = _paraswap;
  }


  /**
  * @dev Facilitates a trade for a SmartFund
  *
  * @param _source            ERC20 token to convert from
  * @param _sourceAmount      Amount to convert from (in _source token)
  * @param _destination       ERC20 token to convert to
  * @param _type              The type of exchange to trade with (For now 0 - because only paraswap)
  * @param _additionalArgs    Array of bytes32 additional arguments
  *
  * @return The amount of _destination received from the trade
  */
  function trade(
    ERC20 _source,
    uint256 _sourceAmount,
    ERC20 _destination,
    uint256 _type,
    bytes32[] _additionalArgs
  )
    external
    payable
    tokenEnabled(_destination)
    returns (uint256)
  {

    require(_source != _destination);

    uint256 receivedAmount;

    if (_source == ETH_TOKEN_ADDRESS) {
      require(msg.value == _sourceAmount);
    } else {
      require(msg.value == 0);
    }

    // SHOULD TRADE PARASWAP HERE
    if (_type == uint(ExchangeType.Paraswap)) {
    receivedAmount = _tradeViaParaswap(
      _source,
      _destination,
      _sourceAmount,

      // TODO write function for correct converts from bytes
      uint256(_additionalArgs[0]),  // minDestinationAmount,
      address[] _additionalArgs[1], // memory callees,
      bytes _additionalArgs[2], // memory exchangeData,
      uint256[] _additionalArgs[3], // memory startIndexes,
      uint256[] _additionalArgs[4], // memory values,
      uint256 _additionalArgs[5] // mintPrice
    )
    } else {
      // unknown exchange type
      revert();
    }

    // Check if Ether was received
    if (_destination == ETH_TOKEN_ADDRESS) {
      (msg.sender).transfer(receivedAmount);
    } else {
      // transfer tokens received to sender
      _destination.transfer(msg.sender, receivedAmount);
    }

    // After the trade, any _source that exchangePortal holds will be sent back to msg.sender
    uint256 endAmount = (_source == ETH_TOKEN_ADDRESS) ? this.balance : _source.balanceOf(this);

    // Check if we hold a positive amount of _source
    if (endAmount > 0) {
      if (_source == ETH_TOKEN_ADDRESS) {
        (msg.sender).transfer(endAmount);
      } else {
        _source.transfer(msg.sender, endAmount);
      }
    }

    emit Trade(msg.sender, _source, _sourceAmount, _destination, receivedAmount, uint8(_type));

    return receivedAmount;
  }

  // Paraswap trade helper
  // TODO describe this
  function _tradeViaParaswap(
    address sourceToken,
    address destinationToken,
    uint256 sourceAmount,
    uint256 minDestinationAmount,
    address[] memory callees,
    bytes memory exchangeData,
    uint256[] memory startIndexes,
    uint256[] memory values,
    uint256 mintPrice
 )
   private
   returns (uint256)
 {

   if (_source == ETH_TOKEN_ADDRESS) {
     destinationReceived = paraswapInterface.swap.value(_sourceAmount)(
       address(sourceToken),
       address(destinationToken),
       sourceAmount,
       minDestinationAmount,
       callees,
       exchangeData,
       startIndexes,
       values,
       mintPrice
     );
   } else {
     _transferFromSenderAndApproveTo(_source, _sourceAmount, paraswap);
     destinationReceived = paraswapInterface.swap(
       address(sourceToken),
       address(destinationToken),
       sourceAmount,
       minDestinationAmount,
       callees,
       exchangeData,
       startIndexes,
       values,
       mintPrice
     );
   }

   uint256 destinationReceived = tokenBalance(destinationToken, address(this));
   return destinationReceive;
 }

 function tokenBalance(ERC20 _token) private view returns (uint256) {
   if (_token == ETH_TOKEN_ADDRESS)
     return this.balance;
   return _token.balanceOf(this);
 }

  /**
  * @dev Transfers tokens to this contract and approves them to another address
  *
  * @param _source          Token to transfer and approve
  * @param _sourceAmount    The amount to transfer and approve (in _source token)
  * @param _to              Address to approve to
  */
  function _transferFromSenderAndApproveTo(ERC20 _source, uint256 _sourceAmount, address _to) private {
    require(_source.transferFrom(msg.sender, this, _sourceAmount));

    _source.approve(_to, _sourceAmount);
  }

  /**
  * @dev Gets the value of a given amount of some token
  *
  * @param _from      Address of token we're converting from
  * @param _to        Address of token we're getting the value in
  * @param _amount    The amount of _from
  *
  * @return The value of `_amount` amount of _from in terms of _to
  */
  function getValue(address _from, address _to, uint256 _amount) public view returns (uint256) {
     // SHOULD GET VALUE FROM PARASWAP HERE
     uint256 expectedRate = getValueFromParaswap(ERC20(_from), ERC20(_to), _amount);
     uint256 value = expectedRate * _amount / (10 ** uint256(DetailedERC20(_from).decimals()));

    return value;
  }

  // NOT FINISHED
  // Should check token and return best price
  function getValueFromParaswap(address _from, address _to, uint256 _amount) private view returns (uint256){
    return priceFeedInterface.getBestPrice(_from, _to, _amount);
  }

  /**
  * @dev Gets the total value of array of tokens and amounts
  *
  * @param _fromAddresses    Addresses of all the tokens we're converting from
  * @param _amounts          The amounts of all the tokens
  * @param _to               The token who's value we're converting to
  *
  * @return The total value of _fromAddresses and _amounts in terms of _to
  */
  function getTotalValue(address[] _fromAddresses, uint256[] _amounts, address _to) public view returns (uint256) {
    uint256 sum = 0;

    for (uint256 i = 0; i < _fromAddresses.length; i++) {
      sum = sum.add(getValue(_fromAddresses[i], _to, _amounts[i]));
    }

    return sum;
  }

  /**
  * @dev Allows the owner to disable/enable the buying of a token
  *
  * @param _token      Token address whos trading permission is to be set
  * @param _enabled    New token permission
  */
  function setToken(address _token, bool _enabled) external onlyOwner {
    disabledTokens[_token] = _enabled;
  }

  // fallback payable function to receive ether from other contract addresses
  function() public payable {}

}

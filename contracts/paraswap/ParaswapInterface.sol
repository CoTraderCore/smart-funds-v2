pragma solidity ^0.5.0;

contract ParaswapInterface{
  function swap(
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
   public
   payable;
}

pragma solidity ^0.4.24;

contract IParaswapParams{
  function getParaswapParamsFromBytes32Array(bytes32[] _additionalArgs) public pure returns
  (
    uint256 minDestinationAmount,
    address[] memory callees,
    bytes memory exchangeData,
    uint256[] memory startIndexes,
    uint256[] memory values,
    uint256 mintPrice
  );
}

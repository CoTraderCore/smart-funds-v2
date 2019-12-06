pragma solidity ^0.4.24;
// helper contract for convert paraswap params from bytes32 arrray on contract side and to bytes32 on client side

contract ParaswapParams {

  // TODO describe this
  function getParaswapParamsFromBytes32(bytes32[] _additionalArgs) public pure returns
  (
    uint256 minDestinationAmount,
    address[] memory callees,
    bytes memory exchangeData,
    uint256[] memory startIndexes,
    uint256[] memory values,
    uint256 mintPrice
  )
  {
    // get not arrays data
    minDestinationAmount = uint256(_additionalArgs[0]);
    mintPrice = uint256(_additionalArgs[1]);
    // convert bytes32 to bytes
    exchangeData = abi.encodePacked(_additionalArgs[2]);


    // create arrays from bytes32[] items

    // get callees arrays with addresses
    uint calleesLength = uint(_additionalArgs[3]);
    uint i = 0;
    uint j = 0;
    uint totalLength = 3;

    for(i = totalLength; i < calleesLength; i++){
      callees[j] = address(_additionalArgs[i]);
      j++;
    }

    // get startIndexes array with uint256
    j = 0;
    totalLength = totalLength + calleesLength;

    uint startIndexesLength = uint(_additionalArgs[totalLength]);
    for(i = totalLength; i < startIndexesLength; i++){
      startIndexes[j] = uint256(_additionalArgs[i]);
      j++;
    }

    // get values array with uin256
    j = 0;
    totalLength = totalLength + startIndexesLength;

    uint valuesLength = uint(_additionalArgs[totalLength]);
    for(i = totalLength; i < valuesLength ; i++){
      values[j] = uint256(_additionalArgs[i]);
      j++;
    }
  }
}

pragma solidity ^0.4.24;
// helper contract for convert paraswap params from bytes32 arrray on contract side and to bytes32 on client side

contract ParaswapParams {

  // TODO describe this
  function getParaswapParamsFromBytes32Array(bytes32[] memory _additionalArgs) public pure returns
  (
    uint256 minDestinationAmount,
    address[] memory,
    bytes memory exchangeData,
    uint256[] memory,
    uint256[] memory,
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
    // create fixed size array callees
    address[] memory callees = new address[](calleesLength);

    for(i = totalLength; i < calleesLength; i++){
      callees[j] = address(_additionalArgs[i]);
      j++;
    }

    // get startIndexes array with uint256
    j = 0;
    totalLength = totalLength + calleesLength;

    uint startIndexesLength = uint(_additionalArgs[totalLength]);
    // create fixed size array startIndexes
    uint256[] memory startIndexes = new uint256[](startIndexesLength);

    for(i = totalLength; i < startIndexesLength; i++){
      startIndexes[j] = uint256(_additionalArgs[i]);
      j++;
    }

    // get values array with uin256
    j = 0;
    totalLength = totalLength + startIndexesLength;
    uint valuesLength = uint(_additionalArgs[totalLength]);
    // create fixed size array values
    uint256[] memory values = new uint256[](valuesLength);

    for(i = totalLength; i < valuesLength ; i++){
      values[j] = uint256(_additionalArgs[i]);
      j++;
    }
  }


  // TODO describe this
  function convertParaswapParamsToBytes32Array(
    uint256 minDestinationAmount,
    address[] memory callees,
    bytes memory exchangeData,
    uint256[] memory startIndexes,
    uint256[] memory values,
    uint256 mintPrice
  )
  public pure returns(bytes32[10] memory _output){ // should always return fixed size array
    _output[0] = bytes32(minDestinationAmount);
    _output[1] = bytes32(mintPrice);
    _output[2] = bytesToBytes32(exchangeData);

    // Write callees
    _output[3] = bytes32(callees.length);
    uint totalLength = 3;
    uint i = totalLength;
    uint j = 0;

    for(i; i < totalLength + callees.length; i++){
        _output[i] = bytes32(callees[j]);
    }

    // Write startIndexes
    totalLength = totalLength + startIndexes.length;
    _output[totalLength] = bytes32(startIndexes.length);
    i = totalLength;
    j = 0;

    for(i; i < totalLength + startIndexes.length; i++){
        _output[i] = bytes32(startIndexes[j]);
    }

    // Write values
    totalLength = totalLength + startIndexes.length;
    _output[totalLength] = bytes32(values.length);
    i = totalLength;
    j = 0;

    for(i; i < totalLength + values.length; i++){
        _output[i] = bytes32(values[j]);
    }

  }

  // helper for converts bytes to bytes32
  function bytesToBytes32(bytes memory source) private pure returns (bytes32 result) {
    if (source.length == 0) {
        return 0x0;
    }
    assembly {
        result := mload(add(source, 32))
    }
  }
}

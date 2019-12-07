pragma solidity ^0.4.24;
// helper contract for convert paraswap params from bytes32 arrray on contract side and to bytes32 on client side

contract ParaswapParams {

  // UNPACK DATA from bytes32 ARRAY
  // TODO describe this
  function getParaswapParamsFromBytes32Array(bytes32[] memory _additionalArgs)
  public pure returns
  (
    uint256 minDestinationAmount,
    address[] memory callees,
    bytes memory exchangeData,
    uint256[] memory startIndexes,
    uint256[] memory values,
    uint256 mintPrice
  )
  {
    // START convert single data from bytes32
    minDestinationAmount = uint256(_additionalArgs[0]);
    mintPrice = uint256(_additionalArgs[1]);
    // convert bytes32 to bytes
    exchangeData = abi.encodePacked(_additionalArgs[2]);
    // END convert single data from bytes32


    // START create arrays from converted bytes32 items

    // length of input bytes32 array
    uint totalLength = 3;

    // Start create callees arrays with address data

    // create fixed size array callees
    uint calleesLength = uint(_additionalArgs[3]);
    callees = new address[](calleesLength);
    totalLength = totalLength + 1;

    // indexes for input array and currect array
    uint i = totalLength;
    uint j = 0;

    // convert address from bytes and write to callees array
    for(i = totalLength; i < totalLength + calleesLength; i++){
      callees[j] = address(_additionalArgs[i]);
      j++;
    }
    // End create callees arrays


    // Start create startIndexes array with uint256 data

    // update indexes
    j = 0;
    totalLength = totalLength + calleesLength;

    // create fixed size array startIndexes
    uint startIndexesLength = uint(_additionalArgs[totalLength]);
    startIndexes = new uint256[](startIndexesLength);
    // update next index
    totalLength = totalLength + 1;

    // convert data from bytes32 to uint256 and write to startIndexes array
    for(i = totalLength; i < totalLength + startIndexesLength; i++){
      startIndexes[j] = uint256(_additionalArgs[i]);
      j++;
    }
    // End create startIndexes array


    // Start create values array with uin256 data

    // update indexes
    j = 0;
    totalLength = totalLength + startIndexesLength;

    // create fixed size array values
    uint valuesLength = uint(_additionalArgs[totalLength]);
    values = new uint256[](valuesLength);
    // update next index
    totalLength = totalLength + 1;

    // convert data from bytes32 to uint256 and write to values array
    for(i = totalLength; i < totalLength + valuesLength ; i++){
      values[j] = uint256(_additionalArgs[i]);
      j++;
    }
    // End create values array

    // END create arrays from bytes32 items
  }


  // PACK DATA IN BYTES32 array
  // TODO describe this
  function convertParaswapParamsToBytes32Array(
    uint256 minDestinationAmount,
    address[] memory callees,
    bytes memory exchangeData,
    uint256[] memory startIndexes,
    uint256[] memory values,
    uint256 mintPrice
  )
  public pure returns(bytes32[] memory _output){
     // define fixed size output array
     uint arraySize = 6 + callees.length + startIndexes.length + values.length;
     _output = new bytes32[](arraySize);

     // START convert to bytes32 single data and write result to output
    _output[0] = bytes32(minDestinationAmount);
    _output[1] = bytes32(mintPrice);
    _output[2] = bytesToBytes32(exchangeData);
     // END convert to bytes32 single data and write result to output


    // START convert arrays to bytes32 and write result to output

    // length for _output array
    uint totalLength = 3;

    // Start convert callees array to bytes32
    // convert and write callees array length to bytes32
    _output[totalLength] = bytes32(callees.length);

    // create and update indexes
    totalLength = totalLength + 1;
    uint i = totalLength;
    uint j = 0;

    // convert and write callees items to bytes32
    for(i; i < totalLength + callees.length; i++){
        _output[i] = bytes32(callees[j]);
        j++;
    }
    // End convert callees array to bytes32


    // Start convert startIndexes array to bytes32
    totalLength = totalLength + callees.length;
    // convert and write startIndexes array length
    _output[totalLength] = bytes32(startIndexes.length);

    // update indexes
    totalLength = totalLength + 1;
    i = totalLength;
    j = 0;

    // convert and write startIndexes items
    for(i; i < totalLength + startIndexes.length; i++){
        _output[i] = bytes32(startIndexes[j]);
        j++;
    }
    // End convert startIndexes array to bytes32

    // Start convert values array to bytes32
    // Write values array
    totalLength = totalLength + startIndexes.length;
    // convert and write values length
    _output[totalLength] = bytes32(values.length);

    // update indexes
    totalLength = totalLength + 1;
    i = totalLength;
    j = 0;

    // convert and write values array items
    for(i; i < totalLength + values.length; i++){
        _output[i] = bytes32(values[j]);
        j++;
    }
    // End convert values array to bytes32

    // END convert to bytes arrays and write result to output
  }



  // BUG CAN BE HERE
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

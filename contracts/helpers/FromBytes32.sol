pragma solidity ^0.4.24;

library FromBytes32 {

/**
* @dev Allows convert address from bytes32
*
* @param _address   bytes32 address
*/
function bytesToAddress(bytes32 _address) internal pure returns (address) {
    uint160 m = 0;
    uint160 b = 0;

    for (uint8 i = 0; i < 20; i++) {
      m *= 256;
      b = uint160(_address[i]);
      m += (b);
    }

    return address(m);
}

// BUG CAN BE HERE
// NOT TESTED THIS
function bytes32ToBytes(bytes32 data) internal pure returns (bytes) {
    uint i = 0;
    while (i < 32 && uint(data[i]) != 0) {
        ++i;
    }
    bytes memory result = new bytes(i);
    i = 0;
    while (i < 32 && data[i] != 0) {
        result[i] = data[i];
        ++i;
    }
    return result;
}


// NOT TESTED THIS
function getAddressArrayFromBytes32(bytes32[] _inputArray) internal pure returns(address[]){
  address[] memory output;
  for(uint i = 0; i<_inputArray.length; i++){
    output[i] = bytesToAddress(_inputArray[i]);
  }

  return output;
}

// NOT TESTED THIS
function getUintArrayFromBytes32(bytes32[] _inputArray) internal pure returns(uint256[]){
  uint256[] memory output;
  for(uint i = 0; i<_inputArray.length; i++){
    output[i] = (uint256(_inputArray[i]));
  }

  return output;
}

}

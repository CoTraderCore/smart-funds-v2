contract IPriceFeedWrapper{
  function getBestPrice(address _from, address _to, uint256 _amount) public view returns (uint256);
}

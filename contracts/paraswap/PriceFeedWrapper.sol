pragma solidity 0.5.10;
pragma experimental ABIEncoderV2;

contract IPriceFeed {
  struct OptimalRate {
    uint rate;
    RateDistribution distribution;
  }

  struct RateDistribution {
    uint Uniswap;
    uint Bancor;
    uint Kyber;
    uint Oasis;
  }

  function getBestPrice(address _from, address _to, uint256 _amount) public view returns (OptimalRate memory optimalRate);
}

contract PriceFeedWrapper{
  IPriceFeed public priceFeedInterface;

  constructor(address _priceFeedInterface) public{
    priceFeedInterface = IPriceFeed(_priceFeedInterface);
  }

  function getBestPrice(address _from, address _to, uint256 _amount) external view returns (uint256 result){
    IPriceFeed.OptimalRate memory price = priceFeedInterface.getBestPrice(_from, _to, _amount);
    result = uint256(price.rate);
  }
}

pragma solidity 0.5.10;
pragma experimental ABIEncoderV2;

interface IPriceFeed {
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

  function getBestPrice(address fromToken, address toToken, uint srcAmount) external view returns (OptimalRate memory optimalRate);

  function getBancorRelayer(address token) external view returns (address);
}


// Kovan: 0xe7B08b5ce1594653d7Bc8457c42FaE1385160823

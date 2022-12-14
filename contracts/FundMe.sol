// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import '@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol';
import './PriceConverter.sol';

error FundMe__NotOwner();
error FundMe__SpendMoreETH();

/**
 * @title A contract for Crowdfunding
 * @author Gonzalo Barria
 * @notice This contract is a demo of funding
 * @dev This implements price feeds as a library
 */
contract FundMe {
  // Type Declarations
  using PriceConverter for uint256;

  // State variables
  //   event Funded(address indexed from, uint256 amount);

  mapping(address => uint256) private s_addressToAmountFunded;
  address[] private s_funders;
  address private immutable i_owner;
  uint256 public constant MINIMUM_USD = 50 * 10**18;
  AggregatorV3Interface private s_priceFeed;

  modifier onlyOwner() {
    // require(msg.sender == i_owner);
    if (msg.sender != i_owner) revert FundMe__NotOwner();
    _;
  }

  //   Functions Order
  //   constructor
  //   receive
  //   fallback
  //   external
  //   public
  //   internal
  //   private
  //   view / pure

  constructor(address priceFeedAddress) {
    i_owner = msg.sender;
    s_priceFeed = AggregatorV3Interface(priceFeedAddress);
  }

  /**
   * @notice This function funds this contract
   * @dev ayuda para desarrolladores
   */
  function fund() public payable {
    if (msg.value.getConversionRate(s_priceFeed) < MINIMUM_USD)
      revert FundMe__SpendMoreETH();

    s_addressToAmountFunded[msg.sender] += msg.value;
    s_funders.push(msg.sender);
    // emit Funded(msg.sender, msg.value);
  }

  function withdraw() public payable onlyOwner {
    for (
      uint256 funderIndex = 0;
      funderIndex < s_funders.length;
      funderIndex++
    ) {
      address funder = s_funders[funderIndex];
      s_addressToAmountFunded[funder] = 0;
    }
    s_funders = new address[](0);
    // payable(msg.sender).transfer(address(this).balance);
    (bool success, ) = payable(msg.sender).call{value: address(this).balance}(
      ''
    );
    // call vs delegatecall
    require(success, 'Transfer failed');
  }

  function cheaperWithdraw() public payable onlyOwner {
    address[] memory funders = s_funders;

    for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
      address funder = funders[funderIndex];
      s_addressToAmountFunded[funder] = 0;
    }
    s_funders = new address[](0);
    // payable(msg.sender).transfer(address(this).balance);
    (bool success, ) = i_owner.call{value: address(this).balance}('');
    // call vs delegatecall
    require(success, 'Transfer failed');
  }

  //   view / pure

  function getAddressToAmountFunded(address funder)
    public
    view
    returns (uint256)
  {
    return s_addressToAmountFunded[funder];
  }

  function getFunder(uint256 index) public view returns (address) {
    return s_funders[index];
  }

  function getOwner() public view returns (address) {
    return i_owner;
  }

  function getPriceFeed() public view returns (AggregatorV3Interface) {
    return s_priceFeed;
  }
}

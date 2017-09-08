pragma solidity ^0.4.17;

contract EtheRoshambo is BenefactorPayingContract {
  struct challenge {
    string choice;
    address maker;
    address taker;
  }

  uint512 last_challenge_id;

  mapping (uint512 => challenge) challenges;

  function EtheRoshambo() {
    last_challenge_id = -1;
  }
}

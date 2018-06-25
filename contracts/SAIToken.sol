// SAI Token is a first token of TokenStars platform
// Copyright (c) 2018 TokenStars
// Made by Maggie Samoyed
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "Sophon Capital", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
pragma solidity ^0.4.17;

import 'zeppelin-solidity/contracts/token/ERC20/MintableToken.sol';
import 'zeppelin-solidity/contracts/token/ERC20/PausableToken.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract SAIToken is MintableToken, PausableToken{
	// ERC20 constants
	string public name="Sophon Capital Token";
	string public symbol="SAIT";
	string public standard="ERC20";	
	uint8 public decimals=18;

	/*Publish Constants*/
	uint256 public totalSupply=0;
	uint256 public INITIAL_SUPPLY = 10*(10**8)*(10**18);
	uint256 public ONE_PERCENT = INITIAL_SUPPLY/100;
	uint256 public TOKEN_SALE = 30 * ONE_PERCENT;//Directed distribution
	uint256 public COMMUNITY_RESERVE = 10 * ONE_PERCENT;//Community operation
	uint256 public TEAM_RESERVE = 30 * ONE_PERCENT;//Team motivation
	uint256 public FOUNDATION_RESERVE = 30 * ONE_PERCENT;//Foundation development standby

	/*Issuing Address Constants*/
	address public salesTokenHolder;
	address public communityTokenHolder;
	address public teamTokenHolder;
	address public foundationTokenHolder;

	/* Freeze Account*/
	mapping(address => bool) public frozenAccount;
	event FrozenFunds(address target, bool frozen);

	using SafeMath for uint256;
	
	/*Here is the constructor function that is executed when the instance is created*/
	function SAIToken(address _communityAdd, address _teamAdd, address _foundationAdd) public{
		balances[_communityAdd] = balances[_communityAdd].add(COMMUNITY_RESERVE);
		totalSupply = totalSupply.add(COMMUNITY_RESERVE);
		Transfer(0x0, _communityAdd, COMMUNITY_RESERVE);
		communityTokenHolder = _communityAdd;

		balances[_teamAdd] = balances[_teamAdd].add(TEAM_RESERVE);
		totalSupply = totalSupply.add(TEAM_RESERVE);
		Transfer(0x0, _teamAdd, TEAM_RESERVE);
		teamTokenHolder = _teamAdd;

		balances[_foundationAdd] = balances[_foundationAdd].add(FOUNDATION_RESERVE);
		totalSupply = totalSupply.add(FOUNDATION_RESERVE);
		Transfer(0x0, _foundationAdd, FOUNDATION_RESERVE);
		foundationTokenHolder = _foundationAdd;
	}

  /**
  * @dev mint required amount of token
  * @param _investor address of investor
  * @param _value token amount corresponding to investor
  */
  function mint(address _investor, uint256 _value) onlyOwner whenNotPaused returns (bool success){
		require(_value > 0);
		require(totalSupply.add(_value) <= INITIAL_SUPPLY);
    	balances[_investor] = balances[_investor].add(_value);
		totalSupply = totalSupply.add(_value);
	 	Transfer(0x0, _investor, _value);
		return true;
	}

   /**
    * @dev Function to freeze Account
    * @param target The address that will freezed.
    * @param freeze Is it frozen.
    */
	function freezeAccount(address target, bool freeze) onlyOwner {
		frozenAccount[target]=freeze;
		FrozenFunds(target,freeze);
	}

   /**
    * @dev transfer token for a specified address if transfer is open
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
	function transfer(address _to, uint256 _value) returns (bool) {
		require(!frozenAccount[msg.sender]);
		return super.transfer(_to, _value);	
	}
}
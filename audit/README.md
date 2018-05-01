# Blue Frontiers Varyon Contract Audit

## Table Of Contents

* [Recommendations](#recommendations)
* [Testing](#testing)
* [Code Review](#code-review)

<br />

<hr />

## Recommendations

* **MEDIUM IMPORTANCE** `Solc 0.4.23+commit.124ca40d.Darwin.appleclang` has an internal error when compiling the smart contract code. This error
  disappears when the line `require( TOKEN_PRESALE_CAP.mul(BONUS) / 100 == MAX_BONUS_TOKENS );` is commented out. Note that the same code works
  in Remix with Solidity 0.4.23. My suggestion is to define `uint public constant MAX_BONUS_TOKENS   = TOKEN_PRESALE_CAP * BONUS / 100;` and
  skip the `require(...)` check. Add a comment next to the constant if you want the calculated number
* **LOW IMPORTANCE** `uint public BONUS = 15;` can be made constant
* **VERY LOW IMPORTANCE** `// event Returned(address indexed _account, uint _tokens);` can be removed
* **VERY LOW IMPORTANCE** Your sub-indentation of the `/* Keep track of tokens */` and `/* Keep track of ether received */` blocks are not
  standard formatting

<br />

<hr />

## Testing

<br />

<hr />

## Code Review

* [ ] [code-review/VaryonToken.md](code-review/VaryonToken.md)
  * [ ] library SafeMath
  * [ ] contract Owned
  * [ ] contract ERC20Interface
  * [ ] contract ERC20Token is ERC20Interface, Owned
    * [ ] using SafeMath for uint;
  * [ ] contract VaryonToken is ERC20Token
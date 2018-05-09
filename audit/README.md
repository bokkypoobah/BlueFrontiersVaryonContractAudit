# Blue Frontiers Varyon Contract Audit

## Table Of Contents

* [Recommendations](#recommendations)
* [Testing](#testing)
* [Code Review](#code-review)

<br />

<hr />

## Recommendations

* [ ] **LOW IMPORTANCE** `wallet.transfer(thisAddress.balance - totalEthPending);` should use the `sub(...)` function

<br />

### Completed

* [x] **MEDIUM IMPORTANCE** `Solc 0.4.23+commit.124ca40d.Darwin.appleclang` has an internal error when compiling the smart contract code. This error
  disappears when the line `require( TOKEN_PRESALE_CAP.mul(BONUS) / 100 == MAX_BONUS_TOKENS );` is commented out. Note that the same code works
  in Remix with Solidity 0.4.23. My suggestion is to define `uint public constant MAX_BONUS_TOKENS   = TOKEN_PRESALE_CAP * BONUS / 100;` and
  skip the `require(...)` check. Add a comment next to the constant if you want the calculated number
* [x] **LOW IMPORTANCE** `uint public BONUS = 15;` can be made constant
* [x] **LOW IMPORTANCE** `uint public constant MINIMUM_ETH_CONTRIBUTION  = 1 ether / 100; // 0.01 ether` can be specified as
  `uint public constant MINIMUM_ETH_CONTRIBUTION  = 0.01 ether;`
* [x] **VERY LOW IMPORTANCE** `// event Returned(address indexed _account, uint _tokens);` can be removed
* [x] **VERY LOW IMPORTANCE** Your sub-indentation of the `/* Keep track of tokens */` and `/* Keep track of ether received */` blocks are not
  standard formatting

<br />

<hr />

## Testing

<br />

<hr />

## Code Review

* [ ] [code-review/VaryonToken.md](code-review/VaryonToken.md)
  * [x] library SafeMath
  * [x] contract Owned
  * [x] contract ERC20Interface
  * [x] contract ERC20Token is ERC20Interface, Owned
    * [x] using SafeMath for uint;
  * [ ] contract VaryonToken is ERC20Token

### Structure Using Surya

Using `surya describe VaryonToken.sol` from https://github.com/GNSPS/soli :

```
 + [Lib] SafeMath 
    - [Int] add 
    - [Int] sub 
    - [Int] mul 

 +  Owned 
    - [Pub] <fallback> 
    - [Pub] transferOwnership 
    - [Pub] acceptOwnership 
    - [Pub] addAdmin 
    - [Pub] removeAdmin 

 +  ERC20Interface 
    - [Pub] totalSupply 
    - [Pub] balanceOf 
    - [Pub] transfer 
    - [Pub] transferFrom 
    - [Pub] approve 
    - [Pub] allowance 

 +  ERC20Token (ERC20Interface, Owned)
    - [Pub] totalSupply 
    - [Pub] balanceOf 
    - [Pub] transfer 
    - [Pub] approve 
    - [Pub] transferFrom 
    - [Pub] allowance 

 +  VaryonToken (ERC20Token)
    - [Pub] <fallback> 
    - [Pub] <fallback> ($)
    - [Pub] atNow 
    - [Pub] tradeable 
    - [Pub] thresholdReached 
    - [Pub] availableToMint 
    - [Prv] tokensAvailableIco 
    - [Prv] minumumInvestment 
    - [Pub] ethToTokens 
    - [Pub] tokensToEth 
    - [Prv] getBonus 
    - [Prv] registerLockedTokens 
    - [Pub] unlockedTokens 
    - [Pub] isAvailableLockSlot 
    - [Pub] setWallet 
    - [Pub] setDateIcoPresale 
    - [Pub] setDateIcoMain 
    - [Pub] setDateIcoEnd 
    - [Pub] setDateIcoDeadline 
    - [Pub] addToWhitelist 
    - [Pub] addToWhitelistParams 
    - [Pub] addToWhitelistMultiple 
    - [Pub] addToWhitelistParamsMultiple 
    - [Prv] pWhitelist 
    - [Pub] addToBlacklist 
    - [Pub] addToBlacklistMultiple 
    - [Prv] pBlacklist 
    - [Pub] mintTokens 
    - [Pub] mintTokensMultiple 
    - [Prv] pMintTokens 
    - [Pub] mintTokensLocked 
    - [Pub] mintTokensLockedMultiple 
    - [Prv] pMintTokensLocked 
    - [Pub] modifyIcoLock 
    - [Pub] offlineContribution 
    - [Prv] offlineTokensWhitelist 
    - [Prv] offlineTokensPending 
    - [Prv] buyTokens 
    - [Prv] buyTokensPending 
    - [Prv] buyTokensWhitelist 
    - [Prv] processWhitelisting 
    - [Prv] sendEtherToWallet 
    - [Prv] processTokenIssue 
    - [Pub] cancelPending 
    - [Pub] cancelPendingMultiple 
    - [Pub] reclaimPending 
    - [Prv] pRevertPending 
    - [Pub] reclaimEth 
    - [Pub] reclaimEthAdmin 
    - [Pub] reclaimEthAdminMultiple 
    - [Prv] pReclaimEth 
    - [Pub] transferAnyERC20Token 
    - [Pub] transfer 
    - [Pub] transferFrom 
    - [Pub] transferLocked 
    - [Ext] transferMultiple 
```
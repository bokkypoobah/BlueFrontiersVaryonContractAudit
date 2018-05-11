# Blue Frontiers Varyon Contract Audit

[2edcced](https://github.com/Blue-Frontiers/varyon/commit/2edccedc46e66644058db50bb6e6652175bf09a6)
[66ef18e](https://github.com/Blue-Frontiers/varyon/commit/66ef18ec538500ea7ecf83905f6f53063dcf923a)

## Table Of Contents

* [Recommendations](#recommendations)
* [Testing](#testing)
* [Code Review](#code-review)

<br />

<hr />

## Recommendations

NIL

<br />

### Completed

* [x] **MEDIUM IMPORTANCE** `Solc 0.4.23+commit.124ca40d.Darwin.appleclang` has an internal error when compiling the smart contract code. This error
  disappears when the line `require( TOKEN_PRESALE_CAP.mul(BONUS) / 100 == MAX_BONUS_TOKENS );` is commented out. Note that the same code works
  in Remix with Solidity 0.4.23. My suggestion is to define `uint public constant MAX_BONUS_TOKENS   = TOKEN_PRESALE_CAP * BONUS / 100;` and
  skip the `require(...)` check. Add a comment next to the constant if you want the calculated number
  * [x] Updated in [66ef18e](https://github.com/Blue-Frontiers/varyon/commit/66ef18ec538500ea7ecf83905f6f53063dcf923a)
* [x] **LOW IMPORTANCE** `uint public BONUS = 15;` can be made constant
  * [x] Updated in [66ef18e](https://github.com/Blue-Frontiers/varyon/commit/66ef18ec538500ea7ecf83905f6f53063dcf923a)
* [x] **LOW IMPORTANCE** `uint public constant MINIMUM_ETH_CONTRIBUTION  = 1 ether / 100; // 0.01 ether` can be specified as
  `uint public constant MINIMUM_ETH_CONTRIBUTION  = 0.01 ether;`
  * [x] Updated in [66ef18e](https://github.com/Blue-Frontiers/varyon/commit/66ef18ec538500ea7ecf83905f6f53063dcf923a)
* [x] **VERY LOW IMPORTANCE** `// event Returned(address indexed _account, uint _tokens);` can be removed
  * [x] Updated in [66ef18e](https://github.com/Blue-Frontiers/varyon/commit/66ef18ec538500ea7ecf83905f6f53063dcf923a)
* [x] **VERY LOW IMPORTANCE** Your sub-indentation of the `/* Keep track of tokens */` and `/* Keep track of ether received */` blocks are not
  standard formatting
  * [x] Updated in [66ef18e](https://github.com/Blue-Frontiers/varyon/commit/66ef18ec538500ea7ecf83905f6f53063dcf923a)
* [x] **LOW IMPORTANCE** `wallet.transfer(thisAddress.balance - totalEthPending);` should use the `sub(...)` function
  * [x] Updated in [66ef18e](https://github.com/Blue-Frontiers/varyon/commit/66ef18ec538500ea7ecf83905f6f53063dcf923a)

<br />

<hr />

## Testing

<br />

<hr />

## Code Review

* [ ] [code-review/VaryonToken.md](code-review/VaryonToken.md)
  * [ ] library SafeMath
  * [ ] contract Utils
  * [ ] contract Owned
  * [ ] contract Wallet is Owned
  * [ ] contract ERC20Interface
  * [ ] contract ERC20Token is ERC20Interface, Owned
    * [ ] using SafeMath for uint;
  * [ ] contract LockSlots is ERC20Token, Utils
    * [ ] using SafeMath for uint;
  * [ ] contract WBList is Owned, Utils
    * [ ] using SafeMath for uint;
  * [ ] contract VaryonIcoDates is Owned, Utils  
  * [ ] contract VaryonToken is ERC20Token, Wallet, LockSlots, WBList, VaryonIcoDates

### Structure Using Surya

Using `surya describe VaryonToken.sol` from https://github.com/GNSPS/soli :

```
 + [Lib] SafeMath 
    - [Int] add 
    - [Int] sub 
    - [Int] mul 

 +  Utils 
    - [Pub] atNow 

 +  Owned 
    - [Pub] <fallback> 
    - [Pub] transferOwnership 
    - [Pub] acceptOwnership 
    - [Pub] addAdmin 
    - [Pub] removeAdmin 

 +  Wallet (Owned)
    - [Pub] <fallback> 
    - [Pub] setWallet 

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

 +  LockSlots (ERC20Token, Utils)
    - [Int] registerLockedTokens 
    - [Pub] lockedTokens 
    - [Pub] unlockedTokens 
    - [Pub] isAvailableLockSlot 
    - [Int] setIcoLock 
    - [Pub] modifyIcoLock 

 +  WBList (Owned, Utils)
    - [Int] processWhitelisting 
    - [Int] processBlacklisting 
    - [Pub] addToWhitelist 
    - [Pub] addToWhitelistParams 
    - [Pub] addToWhitelistMultiple 
    - [Pub] addToWhitelistParamsMultiple 
    - [Prv] pWhitelist 
    - [Pub] addToBlacklist 
    - [Pub] addToBlacklistMultiple 
    - [Prv] pBlacklist 

 +  VaryonIcoDates (Owned, Utils)
    - [Pub] <fallback> 
    - [Pub] setDateIcoPresale 
    - [Pub] setDateIcoMain 
    - [Pub] setDateIcoEnd 
    - [Pub] setDateIcoDeadline 

 +  VaryonToken (ERC20Token, Wallet, LockSlots, WBList, VaryonIcoDates)
    - [Pub] <fallback> 
    - [Pub] <fallback> ($)
    - [Pub] tradeable 
    - [Pub] thresholdReached 
    - [Pub] availableToMint 
    - [Pub] tokensAvailableIco 
    - [Prv] minimumInvestment 
    - [Pub] ethToTokens 
    - [Pub] tokensToEth 
    - [Prv] getBonus 
    - [Pub] mintTokens 
    - [Pub] mintTokensMultiple 
    - [Prv] pMintTokens 
    - [Pub] mintTokensLocked 
    - [Pub] mintTokensLockedMultiple 
    - [Prv] pMintTokensLocked 
    - [Pub] buyOffline 
    - [Prv] buyOfflineWhitelist 
    - [Prv] buyOfflinePending 
    - [Prv] buyTokens 
    - [Prv] buyTokensPending 
    - [Prv] buyTokensWhitelist 
    - [Int] processWhitelisting 
    - [Prv] sendEtherToWallet 
    - [Prv] processTokenIssue 
    - [Int] processBlacklisting 
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
    - [Ext] transferMultiple 
```
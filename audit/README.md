# Blue Frontiers Varyon Contract Audit

## Summary

[Blue Frontiers](https://www.blue-frontiers.com/) intends to run a crowdsale in May or June 2018.

Bok Consulting Pty Ltd was commissioned to perform an private audit on the Ethereum smart contracts for Blue Frontiers's crowdsale.

This audit has been conducted on Blue Frontiers's source code in commits
[2edcced](https://github.com/Blue-Frontiers/varyon/commit/2edccedc46e66644058db50bb6e6652175bf09a6), 
[66ef18e](https://github.com/Blue-Frontiers/varyon/commit/66ef18ec538500ea7ecf83905f6f53063dcf923a),
[d2e0b13](https://github.com/Blue-Frontiers/varyon/commit/d2e0b13e3e283a1dcde898e90daa2e70fb25d3f0) and
[2c03503](https://github.com/Blue-Frontiers/varyon/commit/2c03503794c527346526bfcf92118e949c29acf8).

TODO - Check that no potential vulnerabilities have been identified in the crowdsale and token contracts.

<br />

<hr />

* [Summary](#summary)
* [Recommendations](#recommendations)
* [Potential Vulnerabilities](#potential-vulnerabilities)
* [Scope](#scope)
* [Limitations](#limitations)
* [Due Diligence](#due-diligence)
* [Risks](#risks)
* [Testing](#testing)
* [Code Review](#code-review)

<br />

<hr />

## Recommendations

n/a

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
* [x] **MEDIUM IMPORTANCE** `buyOffline(...)` can only be executed by the admin, and this calls `buyOfflineWhitelist(...)` which calls `processTokenIssue(...)`. In `processTokenIssue(...)`, the statement `uint balance = balances[msg.sender].sub(balancesBonus[msg.sender]).sub(balancesMinted[msg.sender]);` checks the balance of `msg.sender` which will be the admin account
  * [x] Fixed in [2c03503](https://github.com/Blue-Frontiers/varyon/commit/2c03503794c527346526bfcf92118e949c29acf8)
* [x] **MEDIUM IMPORTANCE** `VaryonToken.pMintTokens(...)` has the statement `balancesMinted[_account] = balances[_account].add(_tokens);` which should be `balancesMinted[_account] = balancesMinted[_account].add(_tokens);`
  * [x] Fixed in [2c03503](https://github.com/Blue-Frontiers/varyon/commit/2c03503794c527346526bfcf92118e949c29acf8)
* [x] **LOW IMPORTANCE** Inconsistency between `uint public constant MAX_LOCKING_PERIOD = 1827 days; // max 5 years` and `require(_term < atNow() + MAX_LOCKING_PERIOD, "the locking period cannot exceed 720 days");`
  * [x] Fixed in [2c03503](https://github.com/Blue-Frontiers/varyon/commit/2c03503794c527346526bfcf92118e949c29acf8)

<br />

<hr />

## Potential Vulnerabilities

TODO - Check that no potential vulnerabilities have been identified in the crowdsale and token contracts.

<br />

<hr />

## Scope

This audit is into the technical aspects of the crowdsale contracts. The primary aim of this audit is to ensure that funds
contributed to these contracts are not easily attacked or stolen by third parties. The secondary aim of this audit is to
ensure the coded algorithms work as expected. This audit does not guarantee that that the code is bugfree, but intends to
highlight any areas of weaknesses.

<br />

<hr />

## Limitations

This audit makes no statements or warranties about the viability of the Blue Frontier's business proposition, the individuals
involved in this business or the regulatory regime for the business model.

<br />

<hr />

## Due Diligence

As always, potential participants in any crowdsale are encouraged to perform their due diligence on the business proposition
before funding any crowdsales.

Potential participants are also encouraged to only send their funds to the official crowdsale Ethereum address, published on
the crowdsale beneficiary's official communication channel.

Scammers have been publishing phishing address in the forums, twitter and other communication channels, and some go as far as
duplicating crowdsale websites. Potential participants should NOT just click on any links received through these messages.
Scammers have also hacked the crowdsale website to replace the crowdsale contract address with their scam address.
 
Potential participants should also confirm that the verified source code on EtherScan.io for the published crowdsale address
matches the audited source code, and that the deployment parameters are correctly set, including the constant parameters.

<br />

<hr />

## Risks

TODO

<br />

<hr />

## Testing

Details of the testing environment can be found in [test](test).

### MintTokens And MintTokensLocked

The following functions were tested using the script [test/01_testMinted.sh](test/01_testMinted.sh) with the summary results saved
in [test/test1results.txt](test/test1results.txt) and the detailed output saved in [test/test1output.txt](test/test1output.txt):

* [x] Deploy crowdsale/token contract
* [x] Whitelist accounts
* [x] Contribute just below minimum threshold - `crowdsale.thresholdReached=false`
* [x] Contribute just above minimum threshold - `crowdsale.thresholdReached=true`
* [x] `mintTokens(...)`
* [x] `mintTokensMultiple(...)`
* [x] `mintTokensLocked(...)`
* [x] `mintTokensLockedMultiple(...)`
* [x] `transfer(...)`, `approve(...)` and `transferFrom(...)`
* [x] `transfer(...)` tokens after unlock dates

<br />

### OfflineWhitelisted And OfflinePending

The following functions were tested using the script [test/02_testOffline.sh](test/02_testOffline.sh) with the summary results saved
in [test/test2results.txt](test/test2results.txt) and the detailed output saved in [test/test2output.txt](test/test2output.txt):

* [x] Deploy crowdsale/token contract
* [x] Whitelist accounts
* [x] Buy offline for whitelisted account
* [x] Buy offline for non-whitelisted account
* [x] Whitelist an offline account
* [x] Blacklist an offline account

<br />


The following functions were tested using the script [test/01_test1.sh](test/01_test1.sh) with the summary results saved
in [test/test1results.txt](test/test1results.txt) and the detailed output saved in [test/test1output.txt](test/test1output.txt):

* [x] Deploy crowdsale/token contract
* [ ] Contribute
* [ ] Finalise crowdsale
* [ ] `transfer(...)`, `approve(...)` and `transferFrom(...)`


<br />

<hr />

## Code Review

* [ ] [code-review/VaryonToken.md](code-review/VaryonToken.md)
  * [x] library SafeMath
  * [x] contract Utils
  * [x] contract Owned
  * [x] contract Wallet is Owned
  * [x] contract ERC20Interface
  * [x] contract ERC20Token is ERC20Interface, Owned
    * [x] using SafeMath for uint;
  * [ ] contract LockSlots is ERC20Token, Utils
    * [ ] using SafeMath for uint;
  * [ ] contract WBList is Owned, Utils
    * [ ] using SafeMath for uint;
  * [x] contract VaryonIcoDates is Owned, Utils  
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

<br />

<br />

(c) BokkyPooBah / Bok Consulting Pty Ltd for Blue Frontier - May 12 2018. The MIT Licence.
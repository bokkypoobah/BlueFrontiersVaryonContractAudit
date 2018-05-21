// ETH/USD 19 Feb 2018 21:38 AEDT from CMC and ethgasstation.info
var ethPriceUSD = 401.43;
var defaultGasPrice = web3.toWei(1, "gwei");

// -----------------------------------------------------------------------------
// Accounts
// -----------------------------------------------------------------------------
var accounts = [];
var accountNames = {};

addAccount(eth.accounts[0], "Account #0 - Miner");
addAccount(eth.accounts[1], "Account #1 - Contract Owner");
addAccount(eth.accounts[2], "Account #2 - Wallet");
addAccount(eth.accounts[3], "Account #3 - Offline, Not Whitelisted");
addAccount(eth.accounts[4], "Account #4 - Offline, Whitelisted");
addAccount(eth.accounts[5], "Account #5 - Whitelisted");
addAccount(eth.accounts[6], "Account #6 - Whitelisted");
addAccount(eth.accounts[7], "Account #7 - Blacklisted");
addAccount(eth.accounts[8], "Account #8 - Not Whitelisted, Pending");
addAccount(eth.accounts[9], "Account #9");
addAccount(eth.accounts[10], "Account #10 - Minted Tokens");
addAccount(eth.accounts[11], "Account #11 - Minted Locked Tokens");
addAccount(eth.accounts[12], "Account #12");

var minerAccount = eth.accounts[0];
var contractOwnerAccount = eth.accounts[1];
var wallet = eth.accounts[2];
var account3 = eth.accounts[3];
var account4 = eth.accounts[4];
var account5 = eth.accounts[5];
var account6 = eth.accounts[6];
var account7 = eth.accounts[7];
var account8 = eth.accounts[8];
var account9 = eth.accounts[9];
var account10 = eth.accounts[10];
var account11 = eth.accounts[11];
var account12 = eth.accounts[12];

var baseBlock = eth.blockNumber;

function unlockAccounts(password) {
  for (var i = 0; i < eth.accounts.length && i < accounts.length; i++) {
    personal.unlockAccount(eth.accounts[i], password, 100000);
    if (i > 0 && eth.getBalance(eth.accounts[i]) == 0) {
      personal.sendTransaction({from: eth.accounts[0], to: eth.accounts[i], value: web3.toWei(1000000, "ether")});
    }
  }
  while (txpool.status.pending > 0) {
  }
  baseBlock = eth.blockNumber;
}

function addAccount(account, accountName) {
  accounts.push(account);
  accountNames[account] = accountName;
}


// -----------------------------------------------------------------------------
// Token Contract
// -----------------------------------------------------------------------------
var tokenContractAddress = null;
var tokenContractAbi = null;

function addTokenContractAddressAndAbi(address, tokenAbi) {
  tokenContractAddress = address;
  tokenContractAbi = tokenAbi;
}


// -----------------------------------------------------------------------------
// Account ETH and token balances
// -----------------------------------------------------------------------------
function printBalances() {
  var token = tokenContractAddress == null || tokenContractAbi == null ? null : web3.eth.contract(tokenContractAbi).at(tokenContractAddress);
  var decimals = token == null ? 18 : token.decimals();
  var i = 0;
  var totalTokenBalance = new BigNumber(0);
  console.log("RESULT:  # Account                                             EtherBalanceChange                          Token Name");
  console.log("RESULT: -- ------------------------------------------ --------------------------- ------------------------------ ---------------------------");
  accounts.forEach(function(e) {
    var etherBalanceBaseBlock = eth.getBalance(e, baseBlock);
    var etherBalance = web3.fromWei(eth.getBalance(e).minus(etherBalanceBaseBlock), "ether");
    var tokenBalance = token == null ? new BigNumber(0) : token.balanceOf(e).shift(-decimals);
    totalTokenBalance = totalTokenBalance.add(tokenBalance);
    console.log("RESULT: " + pad2(i) + " " + e  + " " + pad(etherBalance) + " " + padToken(tokenBalance, decimals) + " " + accountNames[e]);
    i++;
  });
  console.log("RESULT: -- ------------------------------------------ --------------------------- ------------------------------ ---------------------------");
  console.log("RESULT:                                                                           " + padToken(totalTokenBalance, decimals) + " Total Token Balances");
  console.log("RESULT: -- ------------------------------------------ --------------------------- ------------------------------ ---------------------------");
  console.log("RESULT: ");
}

function pad2(s) {
  var o = s.toFixed(0);
  while (o.length < 2) {
    o = " " + o;
  }
  return o;
}

function pad(s) {
  var o = s.toFixed(18);
  while (o.length < 27) {
    o = " " + o;
  }
  return o;
}

function padToken(s, decimals) {
  var o = s.toFixed(decimals);
  var l = parseInt(decimals)+12;
  while (o.length < l) {
    o = " " + o;
  }
  return o;
}


// -----------------------------------------------------------------------------
// Transaction status
// -----------------------------------------------------------------------------
function printTxData(name, txId) {
  var tx = eth.getTransaction(txId);
  var txReceipt = eth.getTransactionReceipt(txId);
  var gasPrice = tx.gasPrice;
  var gasCostETH = tx.gasPrice.mul(txReceipt.gasUsed).div(1e18);
  var gasCostUSD = gasCostETH.mul(ethPriceUSD);
  var block = eth.getBlock(txReceipt.blockNumber);
  console.log("RESULT: " + name + " status=" + txReceipt.status + (txReceipt.status == 0 ? " Failure" : " Success") + " gas=" + tx.gas +
    " gasUsed=" + txReceipt.gasUsed + " costETH=" + gasCostETH + " costUSD=" + gasCostUSD +
    " @ ETH/USD=" + ethPriceUSD + " gasPrice=" + web3.fromWei(gasPrice, "gwei") + " gwei block=" + 
    txReceipt.blockNumber + " txIx=" + tx.transactionIndex + " txId=" + txId +
    " @ " + block.timestamp + " " + new Date(block.timestamp * 1000).toUTCString());
}

function assertEtherBalance(account, expectedBalance) {
  var etherBalance = web3.fromWei(eth.getBalance(account), "ether");
  if (etherBalance == expectedBalance) {
    console.log("RESULT: OK " + account + " has expected balance " + expectedBalance);
  } else {
    console.log("RESULT: FAILURE " + account + " has balance " + etherBalance + " <> expected " + expectedBalance);
  }
}

function assertEquals(variableText, variable, value) {
  if (variable == value) {
    console.log("RESULT: PASS " + variableText + " == " + value);
  } else {
    console.log("RESULT: FAIL " + variableText + " != " + value);
  }
}

function failIfTxStatusError(tx, msg) {
  var status = eth.getTransactionReceipt(tx).status;
  if (status == 0) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    console.log("RESULT: PASS " + msg);
    return 1;
  }
}

function passIfTxStatusError(tx, msg) {
  var status = eth.getTransactionReceipt(tx).status;
  if (status == 1) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    console.log("RESULT: PASS " + msg);
    return 1;
  }
}

function gasEqualsGasUsed(tx) {
  var gas = eth.getTransaction(tx).gas;
  var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
  return (gas == gasUsed);
}

function failIfGasEqualsGasUsed(tx, msg) {
  var gas = eth.getTransaction(tx).gas;
  var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
  if (gas == gasUsed) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    console.log("RESULT: PASS " + msg);
    return 1;
  }
}

function passIfGasEqualsGasUsed(tx, msg) {
  var gas = eth.getTransaction(tx).gas;
  var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
  if (gas == gasUsed) {
    console.log("RESULT: PASS " + msg);
    return 1;
  } else {
    console.log("RESULT: FAIL " + msg);
    return 0;
  }
}

function failIfGasEqualsGasUsedOrContractAddressNull(contractAddress, tx, msg) {
  if (contractAddress == null) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    var gas = eth.getTransaction(tx).gas;
    var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
    if (gas == gasUsed) {
      console.log("RESULT: FAIL " + msg);
      return 0;
    } else {
      console.log("RESULT: PASS " + msg);
      return 1;
    }
  }
}


//-----------------------------------------------------------------------------
// Wait one block
//-----------------------------------------------------------------------------
function waitOneBlock(oldCurrentBlock) {
  while (eth.blockNumber <= oldCurrentBlock) {
  }
  console.log("RESULT: Waited one block");
  console.log("RESULT: ");
  return eth.blockNumber;
}


//-----------------------------------------------------------------------------
// Pause for {x} seconds
//-----------------------------------------------------------------------------
function pause(message, addSeconds) {
  var time = new Date((parseInt(new Date().getTime()/1000) + addSeconds) * 1000);
  console.log("RESULT: Pausing '" + message + "' for " + addSeconds + "s=" + time + " now=" + new Date());
  while ((new Date()).getTime() <= time.getTime()) {
  }
  console.log("RESULT: Paused '" + message + "' for " + addSeconds + "s=" + time + " now=" + new Date());
  console.log("RESULT: ");
}


//-----------------------------------------------------------------------------
//Wait until some unixTime + additional seconds
//-----------------------------------------------------------------------------
function waitUntil(message, unixTime, addSeconds) {
  var t = parseInt(unixTime) + parseInt(addSeconds) + parseInt(1);
  var time = new Date(t * 1000);
  console.log("RESULT: Waiting until '" + message + "' at " + unixTime + "+" + addSeconds + "s=" + time + " now=" + new Date());
  while ((new Date()).getTime() <= time.getTime()) {
  }
  console.log("RESULT: Waited until '" + message + "' at at " + unixTime + "+" + addSeconds + "s=" + time + " now=" + new Date());
  console.log("RESULT: ");
}


//-----------------------------------------------------------------------------
//Wait until some block
//-----------------------------------------------------------------------------
function waitUntilBlock(message, block, addBlocks) {
  var b = parseInt(block) + parseInt(addBlocks);
  console.log("RESULT: Waiting until '" + message + "' #" + block + "+" + addBlocks + "=#" + b + " currentBlock=" + eth.blockNumber);
  while (eth.blockNumber <= b) {
  }
  console.log("RESULT: Waited until '" + message + "' #" + block + "+" + addBlocks + "=#" + b + " currentBlock=" + eth.blockNumber);
  console.log("RESULT: ");
}


//-----------------------------------------------------------------------------
// Token Contract
//-----------------------------------------------------------------------------
var tokenFromBlock = 0;
function printTokenContractDetails(detailedAccounts) {
  console.log("RESULT: tokenContractAddress=" + tokenContractAddress);
  if (tokenContractAddress != null && tokenContractAbi != null) {
    var contract = eth.contract(tokenContractAbi).at(tokenContractAddress);
    var decimals = contract.decimals();
    console.log("RESULT: token.owner=" + contract.owner());
    console.log("RESULT: token.newOwner=" + contract.newOwner());

    console.log("RESULT: token.wallet=" + contract.wallet());

    console.log("RESULT: token.tokensIssuedTotal=" + contract.tokensIssuedTotal().shift(-decimals) + " tokens");
    console.log("RESULT: token.totalSupply=" + contract.totalSupply().shift(-decimals) + " tokens");
    // mapping(address => uint) public balances;

    console.log("RESULT: lockSlots.LOCK_SLOTS=" + contract.LOCK_SLOTS());
    // mapping(address => uint[LOCK_SLOTS]) public lockTerm;
    // mapping(address => uint[LOCK_SLOTS]) public lockAmnt;
    // function lockedTokens(address _account) public view returns (uint locked)
    // function unlockedTokens (address _account) public view returns (uint unlocked)
    // function isAvailableLockSlot(address _account, uint _term) public view returns (bool)

    console.log("RESULT: wbList.MAX_LOCKING_PERIOD=" + contract.MAX_LOCKING_PERIOD() + " " + contract.MAX_LOCKING_PERIOD()/365/24/60/60 + " years");
    // mapping(address => bool) public whitelist;
    // mapping(address => uint) public whitelistLimit;
    // mapping(address => uint) public whitelistThreshold;
    // mapping(address => uint) public whitelistLockDate;
    // mapping(address => bool) public blacklist;

    console.log("RESULT: icoDates.dateIcoPresale=" + contract.dateIcoPresale() + " " + new Date(contract.dateIcoPresale() * 1000).toUTCString() + " " + new Date(contract.dateIcoPresale() * 1000).toString());
    console.log("RESULT: icoDates.dateIcoMain=" + contract.dateIcoMain() + " " + new Date(contract.dateIcoMain() * 1000).toUTCString() + " " + new Date(contract.dateIcoMain() * 1000).toString());
    console.log("RESULT: icoDates.dateIcoEnd=" + contract.dateIcoEnd() + " " + new Date(contract.dateIcoEnd() * 1000).toUTCString() + " " + new Date(contract.dateIcoEnd() * 1000).toString());
    console.log("RESULT: icoDates.dateIcoDeadline=" + contract.dateIcoDeadline() + " " + new Date(contract.dateIcoDeadline() * 1000).toUTCString() + " " + new Date(contract.dateIcoDeadline() * 1000).toString());
    console.log("RESULT: icoDates.DATE_LIMIT=" + contract.DATE_LIMIT() + " " + new Date(contract.DATE_LIMIT() * 1000).toUTCString() + " " + new Date(contract.DATE_LIMIT() * 1000).toString());

    console.log("RESULT: token.name=" + contract.name());
    console.log("RESULT: token.symbol=" + contract.symbol());
    console.log("RESULT: token.decimals=" + decimals);
    console.log("RESULT: crowdsale.TOKENS_PER_ETH=" + contract.TOKENS_PER_ETH() + " tokens/ETH");
    console.log("RESULT: crowdsale.TOKEN_TOTAL_SUPPLY=" + contract.TOKEN_TOTAL_SUPPLY().shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.TOKEN_THRESHOLD=" + contract.TOKEN_THRESHOLD().shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.TOKEN_PRESALE_CAP=" + contract.TOKEN_PRESALE_CAP().shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.TOKEN_ICO_CAP=" + contract.TOKEN_ICO_CAP().shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.BONUS=" + contract.BONUS() + "%");
    console.log("RESULT: crowdsale.MAX_BONUS_TOKENS=" + contract.MAX_BONUS_TOKENS().shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.MIN_PURCHASE_PRESALE=" + contract.MIN_PURCHASE_PRESALE().shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.MIN_PURCHASE_MAIN=" + contract.MIN_PURCHASE_MAIN().shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.MINIMUM_ETH_CONTRIBUTION=" + contract.MINIMUM_ETH_CONTRIBUTION().shift(-18) + " ETH");
    // mapping(address => uint) public balancesOffline;
    // mapping(address => uint) public balancesPending;
    // mapping(address => uint) public balancesPendingOffline;
    console.log("RESULT: crowdsale.tokensIcoPending=" + contract.tokensIcoPending().shift(-decimals) + " tokens");
    // mapping(address => uint) public balancesMinted;
    console.log("RESULT: crowdsale.tokensIcoIssued=" + contract.tokensIcoIssued().shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.tokensIcoCrowd=" + contract.tokensIcoCrowd().shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.tokensIcoOffline=" + contract.tokensIcoOffline().shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.tokensIcoBonus=" + contract.tokensIcoBonus().shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.tokensMinted=" + contract.tokensMinted().shift(-decimals) + " tokens");
    // mapping(address => uint) public balancesBonus;
    // mapping(address => uint) public ethPending;
    console.log("RESULT: crowdsale.totalEthPending=" + contract.totalEthPending().shift(-18) + " ETH");
    // mapping(address => uint) public ethContributed;
    console.log("RESULT: crowdsale.totalEthContributed=" + contract.totalEthContributed().shift(-18) + " ETH");
    // mapping(address => bool) public refundClaimed;

    console.log("RESULT: crowdsale.tradeable=" + contract.tradeable());
    console.log("RESULT: crowdsale.thresholdReached=" + contract.thresholdReached());
    console.log("RESULT: crowdsale.availableToMint=" + contract.availableToMint().shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.tokensAvailableIco=" + contract.tokensAvailableIco().shift(-decimals) + " tokens");

    var ether1Div3 = new BigNumber("1").shift(18).div(3);
    var ether1 = new BigNumber("1").shift(18);
    var ether100 = new BigNumber("100").shift(18);
    console.log("RESULT: crowdsale.ethToTokens(1/3 ETH)=" + contract.ethToTokens(ether1Div3).shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.ethToTokens(1 ETH)=" + contract.ethToTokens(ether1).shift(-decimals) + " tokens");
    console.log("RESULT: crowdsale.ethToTokens(100 ETH)=" + contract.ethToTokens(ether100).shift(-decimals) + " tokens");

    var tokensFor1Div3Ether = new BigNumber("14750").shift(decimals).div(3);
    var tokensFor1Div3EtherRoundUp = new BigNumber("4916.666667").shift(decimals);
    var tokensFor1Ether = new BigNumber("14750").shift(decimals);
    var tokensFor100Ether = new BigNumber("1475000").shift(decimals);
    console.log("RESULT: crowdsale.tokensToEth(" + tokensFor1Div3Ether.shift(-decimals) + " tokens)=" + contract.tokensToEth(tokensFor1Div3Ether).shift(-18) + " ETH");
    console.log("RESULT: crowdsale.tokensToEth(" + tokensFor1Div3EtherRoundUp.shift(-decimals) + " tokens)=" + contract.tokensToEth(tokensFor1Div3EtherRoundUp).shift(-18) + " ETH");
    console.log("RESULT: crowdsale.tokensToEth(" + tokensFor1Ether.shift(-decimals) + " tokens)=" + contract.tokensToEth(tokensFor1Ether).shift(-18) + " ETH");
    console.log("RESULT: crowdsale.tokensToEth(" + tokensFor100Ether.shift(-decimals) + " tokens)=" + contract.tokensToEth(tokensFor100Ether).shift(-18) + " ETH");

    // [account3, account4, account5, account6, account7, account8, account10, account11].forEach(function(e) 
    detailedAccounts.forEach(function(e) {
      console.log("RESULT: --- " + e  + " " + accountNames[e] + " ---");
      console.log("RESULT: - lockTerm                 : " + contract.lockTerm(e, 0) + ", " + contract.lockTerm(e, 1) +
        ", " + contract.lockTerm(e, 2) + ", " + contract.lockTerm(e, 3) + ", " + contract.lockTerm(e, 4) +
        ", " + contract.lockTerm(e, 5));
      console.log("RESULT: - lockAmnt                 : " + contract.lockAmnt(e, 0).shift(-decimals) + ", " + contract.lockAmnt(e, 1).shift(-decimals) +
          ", " + contract.lockAmnt(e, 2).shift(-decimals) + ", " + contract.lockAmnt(e, 3).shift(-decimals) +
          ", " + contract.lockAmnt(e, 4).shift(-decimals) + ", " + contract.lockAmnt(e, 5).shift(-decimals));
      // mapping(address => uint[LOCK_SLOTS]) public lockTerm;
      // mapping(address => uint[LOCK_SLOTS]) public lockAmnt;
      // mapping(address => bool) public hasLockedTokens;
      console.log("RESULT: - mayHaveLockedTokens      : " + contract.mayHaveLockedTokens(e));

      console.log("RESULT: - lockedTokens             : " + contract.lockedTokens(e).shift(-decimals) + " tokens");
      console.log("RESULT: - unlockedTokens           : " + contract.unlockedTokens(e).shift(-decimals) + " tokens");
      // 01/01/2035
      console.log("RESULT: - isAvailableLockSlot(2035): " + contract.isAvailableLockSlot(e, 2051222400));
      // function lockedTokens(address _account) public view returns (uint locked)
      // function unlockedTokens (address _account) public view returns (uint unlocked)
      // function isAvailableLockSlot(address _account, uint _term) public view returns (bool)

      console.log("RESULT: - whitelist                : " + contract.whitelist(e));
      console.log("RESULT: - whitelistLimit           : " + contract.whitelistLimit(e));
      console.log("RESULT: - whitelistThreshold       : " + contract.whitelistThreshold(e));
      console.log("RESULT: - whitelistLockDate        : " + contract.whitelistLockDate(e));
      console.log("RESULT: - blacklist                : " + contract.blacklist(e));
      // mapping(address => bool) public whitelist;
      // mapping(address => uint) public whitelistLimit;
      // mapping(address => uint) public whitelistThreshold;
      // mapping(address => uint) public whitelistLockDate;
      // mapping(address => bool) public blacklist;

      console.log("RESULT: - balanceOf                : " + contract.balanceOf(e).shift(-decimals) + " tokens");
      console.log("RESULT: - balancesOffline          : " + contract.balancesOffline(e).shift(-decimals) + " tokens");
      console.log("RESULT: - balancesPending          : " + contract.balancesPending(e).shift(-decimals) + " tokens");
      console.log("RESULT: - balancesPendingOffline   : " + contract.balancesPendingOffline(e).shift(-decimals) + " tokens");
      console.log("RESULT: - balancesMinted           : " + contract.balancesMinted(e).shift(-decimals) + " tokens");
      console.log("RESULT: - balancesBonus            : " + contract.balancesBonus(e).shift(-decimals) + " tokens");
      console.log("RESULT: - ethPending               : " + contract.ethPending(e).shift(-18) + " ETH");
      console.log("RESULT: - ethContributed           : " + contract.ethContributed(e).shift(-18) + " ETH");
      console.log("RESULT: - refundClaimed            : " + contract.refundClaimed(e));
      // mapping(address => uint) public balancesOffline;
      // mapping(address => uint) public balancesPending;
      // mapping(address => uint) public balancesPendingOffline;
      // mapping(address => uint) public balancesMinted;
      // mapping(address => uint) public balancesBonus;
      // mapping(address => uint) public ethPending;
      // mapping(address => uint) public ethContributed;
      // mapping(address => bool) public refundClaimed;
    })

    var latestBlock = eth.blockNumber;
    var i;

    var ownershipTransferProposedEvents = contract.OwnershipTransferProposed({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    ownershipTransferProposedEvents.watch(function (error, result) {
      console.log("RESULT: OwnershipTransferProposed " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    ownershipTransferProposedEvents.stopWatching();

    var ownershipTransferredEvents = contract.OwnershipTransferred({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    ownershipTransferredEvents.watch(function (error, result) {
      console.log("RESULT: OwnershipTransferred " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    ownershipTransferredEvents.stopWatching();

    var adminChangeEvents = contract.AdminChange({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    adminChangeEvents.watch(function (error, result) {
      console.log("RESULT: AdminChange " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    adminChangeEvents.stopWatching();


    var walletUpdatedEvents = contract.WalletUpdated({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    walletUpdatedEvents.watch(function (error, result) {
      console.log("RESULT: WalletUpdated " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    walletUpdatedEvents.stopWatching();


    var approvalEvents = contract.Approval({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    approvalEvents.watch(function (error, result) {
      console.log("RESULT: Approval " + i++ + " #" + result.blockNumber + " _owner=" + result.args._owner +
        " _spender=" + result.args._spender + " _value=" + result.args._value.shift(-decimals));
    });
    approvalEvents.stopWatching();

    var transferEvents = contract.Transfer({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    transferEvents.watch(function (error, result) {
      console.log("RESULT: Transfer " + i++ + " #" + result.blockNumber + ": _from=" + result.args._from + " _to=" + result.args._to +
        " _value=" + result.args._value.shift(-decimals));
    });
    transferEvents.stopWatching();


    var registeredLockedTokensEvents = contract.RegisteredLockedTokens({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    registeredLockedTokensEvents.watch(function (error, result) {
      console.log("RESULT: RegisteredLockedTokens " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    registeredLockedTokensEvents.stopWatching();

    var  icoLockSetEvents = contract.IcoLockSet({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    icoLockSetEvents.watch(function (error, result) {
      console.log("RESULT: IcoLockSet " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    icoLockSetEvents.stopWatching();

    var icoLockChangedEvents = contract.IcoLockChanged({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    icoLockChangedEvents.watch(function (error, result) {
      console.log("RESULT: IcoLockChanged " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    icoLockChangedEvents.stopWatching();


    var whitelistedEvents = contract.Whitelisted({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    whitelistedEvents.watch(function (error, result) {
      console.log("RESULT: Whitelisted " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    whitelistedEvents.stopWatching();

    var blacklistedEvents = contract.Blacklisted({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    blacklistedEvents.watch(function (error, result) {
      console.log("RESULT: Blacklisted " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    blacklistedEvents.stopWatching();


    var icoDateUpdatedEvents = contract.IcoDateUpdated({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    icoDateUpdatedEvents.watch(function (error, result) {
      console.log("RESULT: IcoDateUpdated " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    icoDateUpdatedEvents.stopWatching();


    var tokensMintedEvents = contract.TokensMinted({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    tokensMintedEvents.watch(function (error, result) {
      console.log("RESULT: TokensMinted " + i++ + " #" + result.blockNumber + " account=" + result.args.account +
        " tokens=" + result.args.tokens.shift(-decimals) + " term=" + result.args.term);
    });
    tokensMintedEvents.stopWatching();

    var registerOfflineContributionEvents = contract.RegisterOfflineContribution({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    registerOfflineContributionEvents.watch(function (error, result) {
      console.log("RESULT: RegisterOfflineContribution " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    registerOfflineContributionEvents.stopWatching();

    var registerOfflinePendingEvents = contract.RegisterOfflinePending({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    registerOfflinePendingEvents.watch(function (error, result) {
      console.log("RESULT: RegisterOfflinePending " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    registerOfflinePendingEvents.stopWatching();

    var registerContributionEvents = contract.RegisterContribution({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    registerContributionEvents.watch(function (error, result) {
      console.log("RESULT: RegisterContribution " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    registerContributionEvents.stopWatching();

    var registerPendingEvents = contract.RegisterPending({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    registerPendingEvents.watch(function (error, result) {
      console.log("RESULT: RegisterPending " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    registerPendingEvents.stopWatching();

    var whitelistingEventEvents = contract.WhitelistingEvent({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    whitelistingEventEvents.watch(function (error, result) {
      console.log("RESULT: WhitelistingEvent " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    whitelistingEventEvents.stopWatching();

    var offlineTokenReturnEvents = contract.OfflineTokenReturn({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    offlineTokenReturnEvents.watch(function (error, result) {
      console.log("RESULT: OfflineTokenReturn " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    offlineTokenReturnEvents.stopWatching();

    var revertPendingEvents = contract.RevertPending({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    revertPendingEvents.watch(function (error, result) {
      console.log("RESULT: RevertPending " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    revertPendingEvents.stopWatching();

    var refundFailedIcoEvents = contract.RefundFailedIco({}, { fromBlock: tokenFromBlock, toBlock: latestBlock });
    i = 0;
    refundFailedIcoEvents.watch(function (error, result) {
      console.log("RESULT: RefundFailedIco " + i++ + " #" + result.blockNumber + " " + JSON.stringify(result.args));
    });
    refundFailedIcoEvents.stopWatching();

    tokenFromBlock = latestBlock + 1;
  }
}


// -----------------------------------------------------------------------------
// Generate Summary JSON
// -----------------------------------------------------------------------------
function generateSummaryJSON() {
  console.log("JSONSUMMARY: {");
  if (crowdsaleContractAddress != null && crowdsaleContractAbi != null) {
    var contract = eth.contract(crowdsaleContractAbi).at(crowdsaleContractAddress);
    var blockNumber = eth.blockNumber;
    var timestamp = eth.getBlock(blockNumber).timestamp;
    console.log("JSONSUMMARY:   \"blockNumber\": " + blockNumber + ",");
    console.log("JSONSUMMARY:   \"blockTimestamp\": " + timestamp + ",");
    console.log("JSONSUMMARY:   \"blockTimestampString\": \"" + new Date(timestamp * 1000).toUTCString() + "\",");
    console.log("JSONSUMMARY:   \"crowdsaleContractAddress\": \"" + crowdsaleContractAddress + "\",");
    console.log("JSONSUMMARY:   \"crowdsaleContractOwnerAddress\": \"" + contract.owner() + "\",");
    console.log("JSONSUMMARY:   \"tokenContractAddress\": \"" + contract.bttsToken() + "\",");
    console.log("JSONSUMMARY:   \"tokenContractDecimals\": " + contract.TOKEN_DECIMALS() + ",");
    console.log("JSONSUMMARY:   \"crowdsaleWalletAddress\": \"" + contract.wallet() + "\",");
    console.log("JSONSUMMARY:   \"crowdsaleTeamWalletAddress\": \"" + contract.teamWallet() + "\",");
    console.log("JSONSUMMARY:   \"crowdsaleTeamPercent\": " + contract.TEAM_PERCENT_GZE() + ",");
    console.log("JSONSUMMARY:   \"bonusListContractAddress\": \"" + contract.bonusList() + "\",");
    console.log("JSONSUMMARY:   \"tier1Bonus\": " + contract.TIER1_BONUS() + ",");
    console.log("JSONSUMMARY:   \"tier2Bonus\": " + contract.TIER2_BONUS() + ",");
    console.log("JSONSUMMARY:   \"tier3Bonus\": " + contract.TIER3_BONUS() + ",");
    var startDate = contract.START_DATE();
    // BK TODO - Remove for production
    startDate = 1512921600;
    var endDate = contract.endDate();
    // BK TODO - Remove for production
    endDate = 1513872000;
    console.log("JSONSUMMARY:   \"crowdsaleStart\": " + startDate + ",");
    console.log("JSONSUMMARY:   \"crowdsaleStartString\": \"" + new Date(startDate * 1000).toUTCString() + "\",");
    console.log("JSONSUMMARY:   \"crowdsaleEnd\": " + endDate + ",");
    console.log("JSONSUMMARY:   \"crowdsaleEndString\": \"" + new Date(endDate * 1000).toUTCString() + "\",");
    console.log("JSONSUMMARY:   \"usdPerEther\": " + contract.usdPerKEther().shift(-3) + ",");
    console.log("JSONSUMMARY:   \"usdPerGze\": " + contract.USD_CENT_PER_GZE().shift(-2) + ",");
    console.log("JSONSUMMARY:   \"gzePerEth\": " + contract.gzePerEth().shift(-18) + ",");
    console.log("JSONSUMMARY:   \"capInUsd\": " + contract.CAP_USD() + ",");
    console.log("JSONSUMMARY:   \"capInEth\": " + contract.capEth().shift(-18) + ",");
    console.log("JSONSUMMARY:   \"minimumContributionEth\": " + contract.MIN_CONTRIBUTION_ETH().shift(-18) + ",");
    console.log("JSONSUMMARY:   \"contributedEth\": " + contract.contributedEth().shift(-18) + ",");
    console.log("JSONSUMMARY:   \"contributedUsd\": " + contract.contributedUsd() + ",");
    console.log("JSONSUMMARY:   \"generatedGze\": " + contract.generatedGze().shift(-18) + ",");
    console.log("JSONSUMMARY:   \"lockedAccountThresholdUsd\": " + contract.lockedAccountThresholdUsd() + ",");
    console.log("JSONSUMMARY:   \"lockedAccountThresholdEth\": " + contract.lockedAccountThresholdEth().shift(-18) + ",");
    console.log("JSONSUMMARY:   \"precommitmentAdjusted\": " + contract.precommitmentAdjusted() + ",");
    console.log("JSONSUMMARY:   \"finalised\": " + contract.finalised());
  }
  console.log("JSONSUMMARY: }");
}
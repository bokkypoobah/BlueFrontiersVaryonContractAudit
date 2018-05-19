#!/bin/bash
# ----------------------------------------------------------------------------------------------
# Testing the smart contract
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

MODE=${1:-test}

GETHATTACHPOINT=`grep ^IPCFILE= settings.txt | sed "s/^.*=//"`
PASSWORD=`grep ^PASSWORD= settings.txt | sed "s/^.*=//"`

SOURCEDIR=`grep ^SOURCEDIR= settings.txt | sed "s/^.*=//"`

CROWDSALESOL=`grep ^CROWDSALESOL= settings.txt | sed "s/^.*=//"`
CROWDSALEJS=`grep ^CROWDSALEJS= settings.txt | sed "s/^.*=//"`

DEPLOYMENTDATA=`grep ^DEPLOYMENTDATA= settings.txt | sed "s/^.*=//"`

INCLUDEJS=`grep ^INCLUDEJS= settings.txt | sed "s/^.*=//"`
TEST1OUTPUT=`grep ^TEST1OUTPUT= settings.txt | sed "s/^.*=//"`
TEST1RESULTS=`grep ^TEST1RESULTS= settings.txt | sed "s/^.*=//"`
JSONSUMMARY=`grep ^JSONSUMMARY= settings.txt | sed "s/^.*=//"`
JSONEVENTS=`grep ^JSONEVENTS= settings.txt | sed "s/^.*=//"`

CURRENTTIME=`date +%s`
CURRENTTIMES=`date -r $CURRENTTIME -u`

ICO_PRESALE_DATE=`echo "$CURRENTTIME+30" | bc`
ICO_PRESALE_DATE_S=`perl -le "print scalar localtime $ICO_PRESALE_DATE"`
ICO_MAIN_DATE=`echo "$CURRENTTIME+60" | bc`
ICO_MAIN_DATE_S=`perl -le "print scalar localtime $ICO_MAIN_DATE"`
ICO_END_DATE=`echo "$CURRENTTIME+90" | bc`
ICO_END_DATE_S=`perl -le "print scalar localtime $ICO_END_DATE"`
ICO_DEADLINE_DATE=`echo "$CURRENTTIME+120" | bc`
ICO_DEADLINE_DATE_S=`perl -le "print scalar localtime $ICO_DEADLINE_DATE"`
DATE_LIMIT_DATE=`echo "$CURRENTTIME+150" | bc`
DATE_LIMIT_DATE_S=`perl -le "print scalar localtime $DATE_LIMIT_DATE"`
LOCK_TERM_1_DATE=`echo "$CURRENTTIME+180" | bc`
LOCK_TERM_1_DATE_S=`perl -le "print scalar localtime $LOCK_TERM_1_DATE"`
LOCK_TERM_2_DATE=`echo "$CURRENTTIME+195" | bc`
LOCK_TERM_2_DATE_S=`perl -le "print scalar localtime $LOCK_TERM_2_DATE"`
LOCK_TERM_3_DATE=`echo "$CURRENTTIME+210" | bc`
LOCK_TERM_3_DATE_S=`perl -le "print scalar localtime $LOCK_TERM_3_DATE"`
LOCK_TERM_4_DATE=`echo "$CURRENTTIME+225" | bc`
LOCK_TERM_4_DATE_S=`perl -le "print scalar localtime $LOCK_TERM_4_DATE"`
LOCK_TERM_5_DATE=`echo "$CURRENTTIME+240" | bc`
LOCK_TERM_5_DATE_S=`perl -le "print scalar localtime $LOCK_TERM_5_DATE"`

CURRENTTIMES=`perl -le "print scalar localtime $CURRENTTIME"`

printf "MODE               = '$MODE'\n" | tee $TEST1OUTPUT
printf "GETHATTACHPOINT    = '$GETHATTACHPOINT'\n" | tee -a $TEST1OUTPUT
printf "PASSWORD           = '$PASSWORD'\n" | tee -a $TEST1OUTPUT
printf "SOURCEDIR          = '$SOURCEDIR'\n" | tee -a $TEST1OUTPUT
printf "CROWDSALESOL       = '$CROWDSALESOL'\n" | tee -a $TEST1OUTPUT
printf "CROWDSALEJS        = '$CROWDSALEJS'\n" | tee -a $TEST1OUTPUT
printf "DEPLOYMENTDATA     = '$DEPLOYMENTDATA'\n" | tee -a $TEST1OUTPUT
printf "INCLUDEJS          = '$INCLUDEJS'\n" | tee -a $TEST1OUTPUT
printf "TEST1OUTPUT        = '$TEST1OUTPUT'\n" | tee -a $TEST1OUTPUT
printf "TEST1RESULTS       = '$TEST1RESULTS'\n" | tee -a $TEST1OUTPUT
printf "JSONSUMMARY        = '$JSONSUMMARY'\n" | tee -a $TEST1OUTPUT
printf "JSONEVENTS         = '$JSONEVENTS'\n" | tee -a $TEST1OUTPUT
printf "CURRENTTIME        = '$CURRENTTIME' '$CURRENTTIMES'\n" | tee -a $TEST1OUTPUT
printf "ICO_PRESALE_DATE   = '$ICO_PRESALE_DATE' '$ICO_PRESALE_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "ICO_MAIN_DATE      = '$ICO_MAIN_DATE' '$ICO_MAIN_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "ICO_END_DATE       = '$ICO_END_DATE' '$ICO_END_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "ICO_DEADLINE_DATE  = '$ICO_DEADLINE_DATE' '$ICO_DEADLINE_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "DATE_LIMIT_DATE    = '$DATE_LIMIT_DATE' '$DATE_LIMIT_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "LOCK_TERM_1_DATE   = '$LOCK_TERM_1_DATE' '$LOCK_TERM_1_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "LOCK_TERM_2_DATE   = '$LOCK_TERM_2_DATE' '$LOCK_TERM_2_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "LOCK_TERM_3_DATE   = '$LOCK_TERM_3_DATE' '$LOCK_TERM_3_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "LOCK_TERM_4_DATE   = '$LOCK_TERM_4_DATE' '$LOCK_TERM_4_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "LOCK_TERM_5_DATE   = '$LOCK_TERM_5_DATE' '$LOCK_TERM_5_DATE_S'\n" | tee -a $TEST1OUTPUT

# Make copy of SOL file and modify start and end times ---
`cp $SOURCEDIR/$CROWDSALESOL .`

# --- Modify parameters ---
# `perl -pi -e "s/require\( TOKEN_PRESALE_CAP\.mul\(BONUS\) \/ 100 \=\= MAX_BONUS_TOKENS \);/\/\/ require\( TOKEN_PRESALE_CAP\.mul\(BONUS\) \/ 100 \=\= MAX_BONUS_TOKENS \);/" $CROWDSALESOL`
`perl -pi -e "s/dateIcoPresale  \= 1526392800;.*$/dateIcoPresale  \= $ICO_PRESALE_DATE; \/\/ $ICO_PRESALE_DATE_S/" $CROWDSALESOL`
`perl -pi -e "s/dateIcoMain     \= 1527861600;.*$/dateIcoMain     \= $ICO_MAIN_DATE; \/\/ $ICO_MAIN_DATE_S/" $CROWDSALESOL`
`perl -pi -e "s/dateIcoEnd      \= 1530367200;.*$/dateIcoEnd      \= $ICO_END_DATE; \/\/ $ICO_END_DATE_S/" $CROWDSALESOL`
`perl -pi -e "s/dateIcoDeadline \= 1533045600;.*$/dateIcoDeadline \= $ICO_DEADLINE_DATE; \/\/ $ICO_DEADLINE_DATE_S/" $CROWDSALESOL`
`perl -pi -e "s/DATE_LIMIT \= 1538316000;.*$/DATE_LIMIT \= $DATE_LIMIT_DATE; \/\/ $DATE_LIMIT_DATE_S/" $CROWDSALESOL`

DIFFS1=`diff $SOURCEDIR/$CROWDSALESOL $CROWDSALESOL`
echo "--- Differences $SOURCEDIR/$CROWDSALESOL $CROWDSALESOL ---" | tee -a $TEST1OUTPUT
echo "$DIFFS1" | tee -a $TEST1OUTPUT

solc_0.4.23 --version | tee -a $TEST1OUTPUT

echo "var crowdsaleOutput=`solc_0.4.23 --optimize --pretty-json --combined-json abi,bin,interface $CROWDSALESOL`;" > $CROWDSALEJS

geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee -a $TEST1OUTPUT
loadScript("$CROWDSALEJS");
loadScript("functions.js");

var crowdsaleAbi = JSON.parse(crowdsaleOutput.contracts["$CROWDSALESOL:VaryonToken"].abi);
var crowdsaleBin = "0x" + crowdsaleOutput.contracts["$CROWDSALESOL:VaryonToken"].bin;

// console.log("DATA: crowdsaleAbi=" + JSON.stringify(crowdsaleAbi));
// console.log("DATA: crowdsaleBin=" + JSON.stringify(crowdsaleBin));

unlockAccounts("$PASSWORD");
printBalances();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var crowdsaleMessage = "Deploy Crowdsale Contract";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + crowdsaleMessage + " ----------");
var crowdsaleContract = web3.eth.contract(crowdsaleAbi);
var crowdsaleTx = null;
var crowdsaleAddress = null;
var crowdsale = crowdsaleContract.new({from: contractOwnerAccount, data: crowdsaleBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        crowdsaleTx = contract.transactionHash;
      } else {
        crowdsaleAddress = contract.address;
        addAccount(crowdsaleAddress, "Varyone Crowdsale + Token '" + crowdsale.symbol() + "' '" + crowdsale.name() + "'");
        addTokenContractAddressAndAbi(crowdsaleAddress, crowdsaleAbi);
        console.log("DATA: crowdsaleAddress=" + crowdsaleAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(crowdsaleTx, crowdsaleMessage);
printTxData("crowdsaleAddress=" + crowdsaleAddress, crowdsaleTx);
printTokenContractDetails([]);
console.log("RESULT: ");

assertEquals("availableToMint()", crowdsale.availableToMint().shift(-crowdsale.decimals()), "751400000");
assertEquals("tokensAvailableIco()", crowdsale.tokensAvailableIco().shift(-crowdsale.decimals()), "44000000");


// -----------------------------------------------------------------------------
var whiteBlackList_Message = "Whitelist / Blacklist Accounts";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + whiteBlackList_Message + " ----------");
var whiteBlackList_1Tx = crowdsale.addToWhitelist(account4, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
var whiteBlackList_2Tx = crowdsale.addToWhitelistMultiple([account5, account6], {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
var whiteBlackList_3Tx = crowdsale.addToBlacklistMultiple([account7], {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(whiteBlackList_1Tx, whiteBlackList_Message + " - owner addToWhitelist(ac4)");
failIfTxStatusError(whiteBlackList_2Tx, whiteBlackList_Message + " - owner addToWhitelistMultiple([ac5, ac6])");
failIfTxStatusError(whiteBlackList_3Tx, whiteBlackList_Message + " - owner addToBlacklistMultiple([ac7])");
printTxData("whiteBlackList_1Tx", whiteBlackList_1Tx);
printTxData("whiteBlackList_2Tx", whiteBlackList_2Tx);
printTxData("whiteBlackList_3Tx", whiteBlackList_3Tx);
printTokenContractDetails([account4, account5, account6, account7]);
console.log("RESULT: ");


waitUntil("dateIcoPresale", crowdsale.dateIcoPresale(), 1);


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution #1";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution1Message);
var sendContribution1_1Tx = crowdsale.buyOffline(account3, new BigNumber("40000").shift(18), {from: contractOwnerAccount, to: crowdsaleAddress, gas: 400000});
var sendContribution1_2Tx = crowdsale.buyOffline(account4, new BigNumber("50000").shift(18), {from: contractOwnerAccount, to: crowdsaleAddress, gas: 400000});
var sendContribution1_3Tx = eth.sendTransaction({from: account5, to: crowdsaleAddress, gas: 400000, value: web3.toWei("10", "ether")});
while (txpool.status.pending > 0) {
}
var sendContribution1_4Tx = eth.sendTransaction({from: account5, to: crowdsaleAddress, gas: 400000, value: web3.toWei("40", "ether")});
var sendContribution1_5Tx = eth.sendTransaction({from: account6, to: crowdsaleAddress, gas: 400000, value: web3.toWei("50", "ether")});
var sendContribution1_6Tx = eth.sendTransaction({from: account7, to: crowdsaleAddress, gas: 400000, value: web3.toWei("40", "ether")});
var sendContribution1_7Tx = eth.sendTransaction({from: account8, to: crowdsaleAddress, gas: 400000, value: web3.toWei("40", "ether")});
while (txpool.status.pending > 0) {
}
var sendContribution1_8Tx = eth.sendTransaction({from: account5, to: crowdsaleAddress, gas: 400000, value: web3.toWei("10", "ether")});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " - Offline ac3 40000 tokens - not whitelisted");
failIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " - Offline ac4 50000 tokens - whitelisted");
passIfTxStatusError(sendContribution1_3Tx, sendContribution1Message + " - ac5 10 ETH - Whitelisted - Expecting failure as under min contribution");
failIfTxStatusError(sendContribution1_4Tx, sendContribution1Message + " - ac5 40 ETH - Whitelisted");
failIfTxStatusError(sendContribution1_5Tx, sendContribution1Message + " - ac6 50 ETH - Whitelisted");
passIfTxStatusError(sendContribution1_6Tx, sendContribution1Message + " - ac7 40 ETH - Expecting failure as blacklisted");
failIfTxStatusError(sendContribution1_7Tx, sendContribution1Message + " - ac8 40 ETH - Not Whitelisted, goes into Pending");
failIfTxStatusError(sendContribution1_8Tx, sendContribution1Message + " - ac5 10 ETH - Whitelisted - Under min contribution, but topping up");
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
printTxData("sendContribution1_2Tx", sendContribution1_2Tx);
printTxData("sendContribution1_3Tx", sendContribution1_3Tx);
printTxData("sendContribution1_4Tx", sendContribution1_4Tx);
printTxData("sendContribution1_5Tx", sendContribution1_5Tx);
printTxData("sendContribution1_6Tx", sendContribution1_5Tx);
printTxData("sendContribution1_7Tx", sendContribution1_7Tx);
printTxData("sendContribution1_8Tx", sendContribution1_8Tx);
printTokenContractDetails([account3, account4, account5, account6, account7, account8]);
console.log("RESULT: ");


if (true) {
// -----------------------------------------------------------------------------
var mintTokens_Message = "Mint Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + mintTokens_Message + " ----------");
var mintTokens_1Tx = crowdsale.mintTokens(account10, new BigNumber("123.456").shift(18), {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(mintTokens_1Tx, mintTokens_Message + " - owner mint(ac10, 123.456 tokens)");
printTxData("mintTokens_1Tx", mintTokens_1Tx);
printTokenContractDetails([account10]);
console.log("RESULT: ");
}


// -----------------------------------------------------------------------------
var mintLockedTokens_Message = "Mint Locked Tokens";
var lockedAccounts = [account11, account11, account11, account11];
var lockedTokens = [new BigNumber("234.5672").shift(18), new BigNumber("234.5673").shift(18), new BigNumber("234.5674").shift(18), new BigNumber("234.5675").shift(18)];
var lockedTerms = [$LOCK_TERM_2_DATE, $LOCK_TERM_3_DATE, $LOCK_TERM_4_DATE, $LOCK_TERM_5_DATE];
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + mintLockedTokens_Message + " ----------");
var mintLockedTokens_1Tx = crowdsale.mintTokensLocked(account11, new BigNumber("234.5671").shift(18), $LOCK_TERM_1_DATE, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
var mintLockedTokens_2Tx = crowdsale.mintTokensLockedMultiple(lockedAccounts, lockedTokens, lockedTerms, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var mintLockedTokens_3Tx = crowdsale.mintTokensLocked(account11, new BigNumber("234.5676").shift(18), parseInt($LOCK_TERM_5_DATE) + 30, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(mintLockedTokens_1Tx, mintLockedTokens_Message + " - owner mint locked term 1");
failIfTxStatusError(mintLockedTokens_2Tx, mintLockedTokens_Message + " - owner mint locked terms 2, 3, 4, 5");
passIfTxStatusError(mintLockedTokens_3Tx, mintLockedTokens_Message + " - owner mint locked term 6 - Expecting failure");
printTxData("mintLockedTokens_1Tx", mintLockedTokens_1Tx);
printTxData("mintLockedTokens_2Tx", mintLockedTokens_2Tx);
printTxData("mintLockedTokens_3Tx", mintLockedTokens_3Tx);
printTokenContractDetails([account11]);
console.log("RESULT: ");


exit;

// -----------------------------------------------------------------------------
var approveTokensForSale_Message = "Approve Tokens For Sale";
var tokensForSale = "4000000000000000000000000";
// -----------------------------------------------------------------------------
console.log("RESULT: " + approveTokensForSale_Message);
var transferToAirdropper_1Tx = token.approve(crowdsaleAddress, tokensForSale, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(transferToAirdropper_1Tx, transferToAirdropper_1Tx + " - ac1 approve sale 4m");
printTxData("transferToAirdropper_1Tx", transferToAirdropper_1Tx);
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var whitelist_Message = "Whitelist Addresses";
// -----------------------------------------------------------------------------
console.log("RESULT: " + whitelist_Message);
var whitelist_1Tx = crowdsale.addToWhitelist(account3, {from: contractOwnerAccount, gas: 100000, gasPrice: defaultGasPrice});
var whitelist_2Tx = crowdsale.addToWhitelist(account4, {from: contractOwnerAccount, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(whitelist_1Tx, whitelist_Message + " - crowdsale.addToWhitelist(account3)");
failIfTxStatusError(whitelist_2Tx, whitelist_Message + " - crowdsale.addToWhitelist(account4)");
printTxData("whitelist_1Tx", whitelist_1Tx);
printTxData("whitelist_2Tx", whitelist_2Tx);
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


waitUntil("START_DATE", crowdsale.START_DATE(), 0);


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution #1";
// -----------------------------------------------------------------------------
console.log("RESULT: " + sendContribution1Message);
var sendContribution1_1Tx = eth.sendTransaction({from: account3, to: crowdsaleAddress, gas: 400000, value: web3.toWei("10", "ether")});
var sendContribution1_2Tx = eth.sendTransaction({from: account4, to: crowdsaleAddress, gas: 400000, value: web3.toWei("10", "ether")});
var sendContribution1_3Tx = eth.sendTransaction({from: account5, to: crowdsaleAddress, gas: 400000, value: web3.toWei("10", "ether")});
var sendContribution1_4Tx = eth.sendTransaction({from: account6, to: crowdsaleAddress, gas: 400000, value: web3.toWei("10", "ether")});
while (txpool.status.pending > 0) {
}
var sendContribution1_5Tx = eth.sendTransaction({from: account4, to: crowdsaleAddress, gas: 400000, value: web3.toWei("20", "ether")});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " - ac3 10 ETH");
failIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " - ac4 10 ETH");
passIfTxStatusError(sendContribution1_3Tx, sendContribution1Message + " - ac5 10 ETH - Expecting failure as not whitelisted");
passIfTxStatusError(sendContribution1_4Tx, sendContribution1Message + " - ac6 10 ETH- Expecting failure as not whitelisted");
failIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " - ac4 20 ETH");
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
printTxData("sendContribution1_2Tx", sendContribution1_2Tx);
printTxData("sendContribution1_3Tx", sendContribution1_3Tx);
printTxData("sendContribution1_4Tx", sendContribution1_4Tx);
printTxData("sendContribution1_5Tx", sendContribution1_5Tx);
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var closeSale_Message = "Close Sale";
// -----------------------------------------------------------------------------
console.log("RESULT: " + closeSale_Message);
var closeSale_1Tx = crowdsale.closeSale({from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(closeSale_1Tx, closeSale_Message);
printTxData("closeSale_1Tx", closeSale_1Tx);
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var transfer1_Message = "Move Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + transfer1_Message);
var transfer1_1Tx = token.transfer(account7, "1000000000000", {from: account3, gas: 100000, gasPrice: defaultGasPrice});
var transfer1_2Tx = token.approve(account8,  "30000000000000000", {from: account4, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var transfer1_3Tx = token.transferFrom(account4, account9, "30000000000000000", {from: account8, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("transfer1_1Tx", transfer1_1Tx);
printTxData("transfer1_2Tx", transfer1_2Tx);
printTxData("transfer1_3Tx", transfer1_3Tx);
failIfTxStatusError(transfer1_1Tx, transfer1_Message + " - transfer 0.000001 tokens ac3 -> ac7. CHECK for movement");
failIfTxStatusError(transfer1_2Tx, transfer1_Message + " - approve 0.03 tokens ac4 -> ac8");
failIfTxStatusError(transfer1_3Tx, transfer1_Message + " - transferFrom 0.03 tokens ac4 -> ac9 by ac8. CHECK for movement");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var burnTokens_Message = "Burn Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: " + burnTokens_Message);
var burnTokens_1Tx = token.burn("200000000000000", {from: account3, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("burnTokens_1Tx", burnTokens_1Tx);
failIfTxStatusError(burnTokens_1Tx, burnTokens_Message + " - ac3 burn 0.0002 tokens");
printCrowdsaleContractDetails();
printTokenContractDetails();
console.log("RESULT: ");


EOF
grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST1OUTPUT | sed "s/RESULT: //" > $TEST1RESULTS
cat $TEST1RESULTS
# grep "JSONSUMMARY: " $TEST1OUTPUT | sed "s/JSONSUMMARY: //" > $JSONSUMMARY
# cat $JSONSUMMARY

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
ICO_END_DATE=`echo "$CURRENTTIME+75" | bc`
ICO_END_DATE_S=`perl -le "print scalar localtime $ICO_END_DATE"`
ICO_DEADLINE_DATE=`echo "$CURRENTTIME+90" | bc`
ICO_DEADLINE_DATE_S=`perl -le "print scalar localtime $ICO_DEADLINE_DATE"`
DATE_LIMIT_DATE=`echo "$CURRENTTIME+120" | bc`
DATE_LIMIT_DATE_S=`perl -le "print scalar localtime $DATE_LIMIT_DATE"`
LOCK_TERM_1_DATE=`echo "$CURRENTTIME+105" | bc`
LOCK_TERM_1_DATE_S=`perl -le "print scalar localtime $LOCK_TERM_1_DATE"`
LOCK_TERM_2_DATE=`echo "$CURRENTTIME+120" | bc`
LOCK_TERM_2_DATE_S=`perl -le "print scalar localtime $LOCK_TERM_2_DATE"`
LOCK_TERM_3_DATE=`echo "$CURRENTTIME+135" | bc`
LOCK_TERM_3_DATE_S=`perl -le "print scalar localtime $LOCK_TERM_3_DATE"`
LOCK_TERM_4_DATE=`echo "$CURRENTTIME+150" | bc`
LOCK_TERM_4_DATE_S=`perl -le "print scalar localtime $LOCK_TERM_4_DATE"`
LOCK_TERM_5_DATE=`echo "$CURRENTTIME+165" | bc`
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

accountNames[account3] = "Account #3 - Minted 1";
accountNames[account4] = "Account #4 - Minted 2";
accountNames[account5] = "Account #5 - Minted Locked 1";
accountNames[account6] = "Account #6 - Minted Locked 2";
accountNames[account7] = "Account #7 - Contributed";
accountNames[account8] = "Account #8";
accountNames[account9] = "Account #9";
accountNames[account10] = "Account #10";
accountNames[account11] = "Account #11";

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
var whiteBlackList_Message = "Whitelist Accounts";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + whiteBlackList_Message + " ----------");
var whiteBlackList_1Tx = crowdsale.addToWhitelist(account7, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(whiteBlackList_1Tx, whiteBlackList_Message + " - owner addToWhitelist(ac7)");
printTxData("whiteBlackList_1Tx", whiteBlackList_1Tx);
printTokenContractDetails([account7]);
console.log("RESULT: ");


waitUntil("dateIcoPresale", crowdsale.dateIcoPresale(), 1);


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution #1";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + sendContribution1Message + " ----------");
var sendContribution1_1Tx = eth.sendTransaction({from: account7, to: crowdsaleAddress, gas: 400000, value: web3.toWei("3999", "ether")});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " - Whitelisted contribution ac7 3999 ETH");
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
printTokenContractDetails([account7]);
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var sendContribution2Message = "Send Contribution #2";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + sendContribution2Message + " ----------");
var sendContribution2_1Tx = eth.sendTransaction({from: account7, to: crowdsaleAddress, gas: 400000, value: web3.toWei("1.01", "ether")});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(sendContribution2_1Tx, sendContribution2Message + " - Whitelisted contribution ac7 1.01 ETH");
printTxData("sendContribution2_1Tx", sendContribution2_1Tx);
printTokenContractDetails([account7]);
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var mintTokens_Message = "Mint Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + mintTokens_Message + " ----------");
var mintTokens_1Tx = crowdsale.mintTokens(account3, new BigNumber("123.4561").shift(18), {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
var mintTokens_2Tx = crowdsale.mintTokensMultiple([account4], [new BigNumber("123.4562").shift(18)], {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(mintTokens_1Tx, mintTokens_Message + " - owner mint(ac3, 123.4561 tokens)");
failIfTxStatusError(mintTokens_2Tx, mintTokens_Message + " - owner mintTokensMultiple([ac4], [123.4562 tokens])");
printTxData("mintTokens_1Tx", mintTokens_1Tx);
printTxData("mintTokens_2Tx", mintTokens_2Tx);
printTokenContractDetails([account3, account4]);
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var mintLockedTokens_Message = "Mint Locked Tokens";
var lockedAccounts = [account6, account6, account6, account6];
var lockedTokens = [new BigNumber("234.5672").shift(18), new BigNumber("234.5673").shift(18), new BigNumber("234.5674").shift(18), new BigNumber("234.5675").shift(18)];
var lockedTerms = [$LOCK_TERM_2_DATE, $LOCK_TERM_3_DATE, $LOCK_TERM_4_DATE, $LOCK_TERM_5_DATE];
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + mintLockedTokens_Message + " ----------");
var mintLockedTokens_1Tx = crowdsale.mintTokensLocked(account5, new BigNumber("234.567").shift(18), $LOCK_TERM_1_DATE, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
var mintLockedTokens_2Tx = crowdsale.mintTokensLocked(account6, new BigNumber("234.5671").shift(18), $LOCK_TERM_1_DATE, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
var mintLockedTokens_3Tx = crowdsale.mintTokensLockedMultiple(lockedAccounts, lockedTokens, lockedTerms, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var mintLockedTokens_4Tx = crowdsale.mintTokensLocked(account6, new BigNumber("234.5676").shift(18), parseInt($LOCK_TERM_5_DATE) + 30, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(mintLockedTokens_1Tx, mintLockedTokens_Message + " - owner mint locked ac5 term 1 234.567 tokens");
failIfTxStatusError(mintLockedTokens_2Tx, mintLockedTokens_Message + " - owner mint locked ac6 term 1 234.5671");
failIfTxStatusError(mintLockedTokens_3Tx, mintLockedTokens_Message + " - owner mint locked ac6 terms 2 234.5672, 3 234.5673, 4 234.5674, 5 234.5675");
passIfTxStatusError(mintLockedTokens_4Tx, mintLockedTokens_Message + " - owner mint locked ac6 term 6 234.5676 - Expecting failure");
printTxData("mintLockedTokens_1Tx", mintLockedTokens_1Tx);
printTxData("mintLockedTokens_2Tx", mintLockedTokens_2Tx);
printTxData("mintLockedTokens_3Tx", mintLockedTokens_3Tx);
printTxData("mintLockedTokens_4Tx", mintLockedTokens_4Tx);
printTokenContractDetails([account5, account6]);
console.log("RESULT: ");


waitUntil("ICO_END_DATE", $ICO_END_DATE, 1);


// -----------------------------------------------------------------------------
var transfer1_Message = "Move Tokens";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + transfer1_Message + " ----------");
var transfer1_1Tx = crowdsale.transfer(account9, "1000000000000", {from: account3, gas: 100000, gasPrice: defaultGasPrice});
var transfer1_2Tx = crowdsale.approve(account10,  "30000000000000000", {from: account4, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
var transfer1_3Tx = crowdsale.transferFrom(account4, account11, "30000000000000000", {from: account10, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("transfer1_1Tx", transfer1_1Tx);
printTxData("transfer1_2Tx", transfer1_2Tx);
printTxData("transfer1_3Tx", transfer1_3Tx);
failIfTxStatusError(transfer1_1Tx, transfer1_Message + " - transfer 0.000001 tokens ac3 -> ac9. CHECK for movement");
failIfTxStatusError(transfer1_2Tx, transfer1_Message + " - approve 0.03 tokens ac4 -> ac10");
failIfTxStatusError(transfer1_3Tx, transfer1_Message + " - transferFrom 0.03 tokens ac4 -> ac11 by ac10. CHECK for movement");
printTokenContractDetails([account6]);
console.log("RESULT: ");


waitUntil("LOCK_TERM_1_DATE", $LOCK_TERM_1_DATE, 1);


// -----------------------------------------------------------------------------
var transferUnlocked1_Message = "Move Unlocked Tokens #1";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + transferUnlocked1_Message + " ----------");
var transferUnlocked1_1Tx = crowdsale.transfer(account12, crowdsale.unlockedTokens(account6), {from: account6, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("transferUnlocked1_1Tx", transferUnlocked1_1Tx);
failIfTxStatusError(transferUnlocked1_1Tx, transferUnlocked1_Message + " - transfer unlocked tokens ac6 -> ac12. CHECK for movement");
printTokenContractDetails([account6]);
console.log("RESULT: ");


waitUntil("LOCK_TERM_2_DATE", $LOCK_TERM_2_DATE, 1);


// -----------------------------------------------------------------------------
var transferUnlocked1_Message = "Move Unlocked Tokens #2";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + transferUnlocked1_Message + " ----------");
var transferUnlocked1_1Tx = crowdsale.transfer(account12, crowdsale.unlockedTokens(account6), {from: account6, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("transferUnlocked1_1Tx", transferUnlocked1_1Tx);
failIfTxStatusError(transferUnlocked1_1Tx, transferUnlocked1_Message + " - transfer unlocked tokens ac6 -> ac12. CHECK for movement");
printTokenContractDetails([account6]);
console.log("RESULT: ");


waitUntil("LOCK_TERM_3_DATE", $LOCK_TERM_3_DATE, 1);


// -----------------------------------------------------------------------------
var transferUnlocked1_Message = "Move Unlocked Tokens #3";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + transferUnlocked1_Message + " ----------");
var transferUnlocked1_1Tx = crowdsale.transfer(account12, crowdsale.unlockedTokens(account6), {from: account6, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("transferUnlocked1_1Tx", transferUnlocked1_1Tx);
failIfTxStatusError(transferUnlocked1_1Tx, transferUnlocked1_Message + " - transfer unlocked tokens ac6 -> ac12. CHECK for movement");
printTokenContractDetails([account6]);
console.log("RESULT: ");


waitUntil("LOCK_TERM_4_DATE", $LOCK_TERM_4_DATE, 1);


// -----------------------------------------------------------------------------
var transferUnlocked1_Message = "Move Unlocked Tokens #4";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + transferUnlocked1_Message + " ----------");
var transferUnlocked1_1Tx = crowdsale.transfer(account12, crowdsale.unlockedTokens(account6), {from: account6, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("transferUnlocked1_1Tx", transferUnlocked1_1Tx);
failIfTxStatusError(transferUnlocked1_1Tx, transferUnlocked1_Message + " - transfer unlocked tokens ac6 -> ac12. CHECK for movement");
printTokenContractDetails([account6]);
console.log("RESULT: ");


waitUntil("LOCK_TERM_5_DATE", $LOCK_TERM_5_DATE, 1);


// -----------------------------------------------------------------------------
var transferUnlocked1_Message = "Move Unlocked Tokens #5";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + transferUnlocked1_Message + " ----------");
var transferUnlocked1_1Tx = crowdsale.transfer(account12, crowdsale.unlockedTokens(account6), {from: account6, gas: 100000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
printTxData("transferUnlocked1_1Tx", transferUnlocked1_1Tx);
failIfTxStatusError(transferUnlocked1_1Tx, transferUnlocked1_Message + " - transfer unlocked tokens ac6 -> ac12. CHECK for movement");
printTokenContractDetails([account6]);
console.log("RESULT: ");


EOF
grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST1OUTPUT | sed "s/RESULT: //" > $TEST1RESULTS
cat $TEST1RESULTS
# grep "JSONSUMMARY: " $TEST1OUTPUT | sed "s/JSONSUMMARY: //" > $JSONSUMMARY
# cat $JSONSUMMARY

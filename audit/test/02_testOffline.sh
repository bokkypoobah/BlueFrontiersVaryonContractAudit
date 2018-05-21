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
TEST2OUTPUT=`grep ^TEST2OUTPUT= settings.txt | sed "s/^.*=//"`
TEST2RESULTS=`grep ^TEST2RESULTS= settings.txt | sed "s/^.*=//"`
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

printf "MODE               = '$MODE'\n" | tee $TEST2OUTPUT
printf "GETHATTACHPOINT    = '$GETHATTACHPOINT'\n" | tee -a $TEST2OUTPUT
printf "PASSWORD           = '$PASSWORD'\n" | tee -a $TEST2OUTPUT
printf "SOURCEDIR          = '$SOURCEDIR'\n" | tee -a $TEST2OUTPUT
printf "CROWDSALESOL       = '$CROWDSALESOL'\n" | tee -a $TEST2OUTPUT
printf "CROWDSALEJS        = '$CROWDSALEJS'\n" | tee -a $TEST2OUTPUT
printf "DEPLOYMENTDATA     = '$DEPLOYMENTDATA'\n" | tee -a $TEST2OUTPUT
printf "INCLUDEJS          = '$INCLUDEJS'\n" | tee -a $TEST2OUTPUT
printf "TEST2OUTPUT        = '$TEST2OUTPUT'\n" | tee -a $TEST2OUTPUT
printf "TEST2RESULTS       = '$TEST2RESULTS'\n" | tee -a $TEST2OUTPUT
printf "JSONSUMMARY        = '$JSONSUMMARY'\n" | tee -a $TEST2OUTPUT
printf "JSONEVENTS         = '$JSONEVENTS'\n" | tee -a $TEST2OUTPUT
printf "CURRENTTIME        = '$CURRENTTIME' '$CURRENTTIMES'\n" | tee -a $TEST2OUTPUT
printf "ICO_PRESALE_DATE   = '$ICO_PRESALE_DATE' '$ICO_PRESALE_DATE_S'\n" | tee -a $TEST2OUTPUT
printf "ICO_MAIN_DATE      = '$ICO_MAIN_DATE' '$ICO_MAIN_DATE_S'\n" | tee -a $TEST2OUTPUT
printf "ICO_END_DATE       = '$ICO_END_DATE' '$ICO_END_DATE_S'\n" | tee -a $TEST2OUTPUT
printf "ICO_DEADLINE_DATE  = '$ICO_DEADLINE_DATE' '$ICO_DEADLINE_DATE_S'\n" | tee -a $TEST2OUTPUT
printf "DATE_LIMIT_DATE    = '$DATE_LIMIT_DATE' '$DATE_LIMIT_DATE_S'\n" | tee -a $TEST2OUTPUT
printf "LOCK_TERM_1_DATE   = '$LOCK_TERM_1_DATE' '$LOCK_TERM_1_DATE_S'\n" | tee -a $TEST2OUTPUT
printf "LOCK_TERM_2_DATE   = '$LOCK_TERM_2_DATE' '$LOCK_TERM_2_DATE_S'\n" | tee -a $TEST2OUTPUT
printf "LOCK_TERM_3_DATE   = '$LOCK_TERM_3_DATE' '$LOCK_TERM_3_DATE_S'\n" | tee -a $TEST2OUTPUT
printf "LOCK_TERM_4_DATE   = '$LOCK_TERM_4_DATE' '$LOCK_TERM_4_DATE_S'\n" | tee -a $TEST2OUTPUT
printf "LOCK_TERM_5_DATE   = '$LOCK_TERM_5_DATE' '$LOCK_TERM_5_DATE_S'\n" | tee -a $TEST2OUTPUT

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
echo "--- Differences $SOURCEDIR/$CROWDSALESOL $CROWDSALESOL ---" | tee -a $TEST2OUTPUT
echo "$DIFFS1" | tee -a $TEST2OUTPUT

solc_0.4.23 --version | tee -a $TEST2OUTPUT

echo "var crowdsaleOutput=`solc_0.4.23 --optimize --pretty-json --combined-json abi,bin,interface $CROWDSALESOL`;" > $CROWDSALEJS

geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee -a $TEST2OUTPUT
loadScript("$CROWDSALEJS");
loadScript("functions.js");

var crowdsaleAbi = JSON.parse(crowdsaleOutput.contracts["$CROWDSALESOL:VaryonToken"].abi);
var crowdsaleBin = "0x" + crowdsaleOutput.contracts["$CROWDSALESOL:VaryonToken"].bin;

// console.log("DATA: crowdsaleAbi=" + JSON.stringify(crowdsaleAbi));
// console.log("DATA: crowdsaleBin=" + JSON.stringify(crowdsaleBin));

unlockAccounts("$PASSWORD");

accountNames[account3] = "Account #3 - Offline Whitelisted";
accountNames[account4] = "Account #4 - Offline Pending, Later Whitelisted";
accountNames[account5] = "Account #5 - Offline Pending, Later Blacklisted";
accountNames[account6] = "Account #6";
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
var whiteBlackList_1Tx = crowdsale.addToWhitelist(account3, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(whiteBlackList_1Tx, whiteBlackList_Message + " - owner addToWhitelist(ac3)");
printTxData("whiteBlackList_1Tx", whiteBlackList_1Tx);
printTokenContractDetails([account3]);
console.log("RESULT: ");


waitUntil("dateIcoPresale", crowdsale.dateIcoPresale(), 1);


// -----------------------------------------------------------------------------
var buyOffline1Message = "Send Contribution #1";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + buyOffline1Message + " ----------");
var buyOffline1_1Tx = crowdsale.buyOffline(account3, new BigNumber("40000").shift(18), {from: contractOwnerAccount, to: crowdsaleAddress, gas: 400000});
var buyOffline1_2Tx = crowdsale.buyOffline(account4, new BigNumber("50000").shift(18), {from: contractOwnerAccount, to: crowdsaleAddress, gas: 400000});
var buyOffline1_3Tx = crowdsale.buyOffline(account5, new BigNumber("60000").shift(18), {from: contractOwnerAccount, to: crowdsaleAddress, gas: 400000});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(buyOffline1_1Tx, buyOffline1Message + " - Offline ac3 40000 tokens - Whitelisted");
failIfTxStatusError(buyOffline1_2Tx, buyOffline1Message + " - Offline ac4 50000 tokens - Not whitelisted, later whitelisted");
failIfTxStatusError(buyOffline1_3Tx, buyOffline1Message + " - Offline ac5 60000 tokens - Not whitelisted, later blacklisted");
printTxData("buyOffline1_1Tx", buyOffline1_1Tx);
printTxData("buyOffline1_2Tx", buyOffline1_2Tx);
printTxData("buyOffline1_3Tx", buyOffline1_3Tx);
printTokenContractDetails([account3, account4, account5]);
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var whitelistOffline_Message = "Whitelist Offline";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + whitelistOffline_Message + " ----------");
var whitelistOffline_1Tx = crowdsale.addToWhitelist(account4, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(whitelistOffline_1Tx, whitelistOffline_Message + " - owner addToWhitelist(ac4)");
printTxData("whitelistOffline_1Tx", whitelistOffline_1Tx);
printTokenContractDetails([account4]);
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var blacklistOffline_Message = "Blacklist Offline";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + blacklistOffline_Message + " ----------");
var blacklistOffline_1Tx = crowdsale.addToBlacklist(account5, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(blacklistOffline_1Tx, blacklistOffline_Message + " - owner addToBlacklist(ac5)");
printTxData("blacklistOffline_1Tx", blacklistOffline_1Tx);
printTokenContractDetails([account5]);
console.log("RESULT: ");


EOF
grep "DATA: " $TEST2OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST2OUTPUT | sed "s/RESULT: //" > $TEST2RESULTS
cat $TEST2RESULTS
# grep "JSONSUMMARY: " $TEST2OUTPUT | sed "s/JSONSUMMARY: //" > $JSONSUMMARY
# cat $JSONSUMMARY

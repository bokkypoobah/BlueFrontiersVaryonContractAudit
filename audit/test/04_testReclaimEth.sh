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
TEST4OUTPUT=`grep ^TEST4OUTPUT= settings.txt | sed "s/^.*=//"`
TEST4RESULTS=`grep ^TEST4RESULTS= settings.txt | sed "s/^.*=//"`
JSONSUMMARY=`grep ^JSONSUMMARY= settings.txt | sed "s/^.*=//"`
JSONEVENTS=`grep ^JSONEVENTS= settings.txt | sed "s/^.*=//"`

CURRENTTIME=`date +%s`
CURRENTTIMES=`date -r $CURRENTTIME -u`

ICO_PRESALE_DATE=`echo "$CURRENTTIME+30" | bc`
ICO_PRESALE_DATE_S=`perl -le "print scalar localtime $ICO_PRESALE_DATE"`
ICO_MAIN_DATE=`echo "$CURRENTTIME+60" | bc`
ICO_MAIN_DATE_S=`perl -le "print scalar localtime $ICO_MAIN_DATE"`
ICO_END_DATE=`echo "$CURRENTTIME+89" | bc`
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

printf "MODE               = '$MODE'\n" | tee $TEST4OUTPUT
printf "GETHATTACHPOINT    = '$GETHATTACHPOINT'\n" | tee -a $TEST4OUTPUT
printf "PASSWORD           = '$PASSWORD'\n" | tee -a $TEST4OUTPUT
printf "SOURCEDIR          = '$SOURCEDIR'\n" | tee -a $TEST4OUTPUT
printf "CROWDSALESOL       = '$CROWDSALESOL'\n" | tee -a $TEST4OUTPUT
printf "CROWDSALEJS        = '$CROWDSALEJS'\n" | tee -a $TEST4OUTPUT
printf "DEPLOYMENTDATA     = '$DEPLOYMENTDATA'\n" | tee -a $TEST4OUTPUT
printf "INCLUDEJS          = '$INCLUDEJS'\n" | tee -a $TEST4OUTPUT
printf "TEST4OUTPUT        = '$TEST4OUTPUT'\n" | tee -a $TEST4OUTPUT
printf "TEST4RESULTS       = '$TEST4RESULTS'\n" | tee -a $TEST4OUTPUT
printf "JSONSUMMARY        = '$JSONSUMMARY'\n" | tee -a $TEST4OUTPUT
printf "JSONEVENTS         = '$JSONEVENTS'\n" | tee -a $TEST4OUTPUT
printf "CURRENTTIME        = '$CURRENTTIME' '$CURRENTTIMES'\n" | tee -a $TEST4OUTPUT
printf "ICO_PRESALE_DATE   = '$ICO_PRESALE_DATE' '$ICO_PRESALE_DATE_S'\n" | tee -a $TEST4OUTPUT
printf "ICO_MAIN_DATE      = '$ICO_MAIN_DATE' '$ICO_MAIN_DATE_S'\n" | tee -a $TEST4OUTPUT
printf "ICO_END_DATE       = '$ICO_END_DATE' '$ICO_END_DATE_S'\n" | tee -a $TEST4OUTPUT
printf "ICO_DEADLINE_DATE  = '$ICO_DEADLINE_DATE' '$ICO_DEADLINE_DATE_S'\n" | tee -a $TEST4OUTPUT
printf "DATE_LIMIT_DATE    = '$DATE_LIMIT_DATE' '$DATE_LIMIT_DATE_S'\n" | tee -a $TEST4OUTPUT
printf "LOCK_TERM_1_DATE   = '$LOCK_TERM_1_DATE' '$LOCK_TERM_1_DATE_S'\n" | tee -a $TEST4OUTPUT
printf "LOCK_TERM_2_DATE   = '$LOCK_TERM_2_DATE' '$LOCK_TERM_2_DATE_S'\n" | tee -a $TEST4OUTPUT
printf "LOCK_TERM_3_DATE   = '$LOCK_TERM_3_DATE' '$LOCK_TERM_3_DATE_S'\n" | tee -a $TEST4OUTPUT
printf "LOCK_TERM_4_DATE   = '$LOCK_TERM_4_DATE' '$LOCK_TERM_4_DATE_S'\n" | tee -a $TEST4OUTPUT
printf "LOCK_TERM_5_DATE   = '$LOCK_TERM_5_DATE' '$LOCK_TERM_5_DATE_S'\n" | tee -a $TEST4OUTPUT

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
echo "--- Differences $SOURCEDIR/$CROWDSALESOL $CROWDSALESOL ---" | tee -a $TEST4OUTPUT
echo "$DIFFS1" | tee -a $TEST4OUTPUT

solc_0.4.23 --version | tee -a $TEST4OUTPUT

echo "var crowdsaleOutput=`solc_0.4.23 --optimize --pretty-json --combined-json abi,bin,interface $CROWDSALESOL`;" > $CROWDSALEJS

geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee -a $TEST4OUTPUT
loadScript("$CROWDSALEJS");
loadScript("functions.js");

var crowdsaleAbi = JSON.parse(crowdsaleOutput.contracts["$CROWDSALESOL:VaryonToken"].abi);
var crowdsaleBin = "0x" + crowdsaleOutput.contracts["$CROWDSALESOL:VaryonToken"].bin;

// console.log("DATA: crowdsaleAbi=" + JSON.stringify(crowdsaleAbi));
// console.log("DATA: crowdsaleBin=" + JSON.stringify(crowdsaleBin));

unlockAccounts("$PASSWORD");

accountNames[account3] = "Account #3 - Not Whitelisted";
accountNames[account4] = "Account #4 - Whitelisted";
accountNames[account5] = "Account #5 - Whitelisted With Limit, Threshold and Term";
accountNames[account6] = "Account #6";
accountNames[account7] = "Account #7 - Contributed";
accountNames[account8] = "Account #8 - Not Whitelisted - To Reclaim Eth";
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
var whiteBlackList_Message = "Whitelist + Blacklist Accounts";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + whiteBlackList_Message + " ----------");
var whiteBlackList_1Tx = crowdsale.addToWhitelist(account4, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
var whiteBlackList_2Tx = crowdsale.addToWhitelistParamsMultiple([account5], [new BigNumber(60).shift(18)], [new BigNumber(100).shift(18)], [$LOCK_TERM_1_DATE], {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
var whiteBlackList_3Tx = crowdsale.addToBlacklist(account6, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
var whiteBlackList_4Tx = crowdsale.addToWhitelist(account7, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(whiteBlackList_1Tx, whiteBlackList_Message + " - owner addToWhitelist(ac4)");
failIfTxStatusError(whiteBlackList_2Tx, whiteBlackList_Message + " - owner addToWhitelistParamsMultiple([ac5], [60 ETH], [100 ETH])");
failIfTxStatusError(whiteBlackList_3Tx, whiteBlackList_Message + " - owner addToBlacklist(ac6");
failIfTxStatusError(whiteBlackList_4Tx, whiteBlackList_Message + " - owner addToWhitelist(ac7)");
printTxData("whiteBlackList_1Tx", whiteBlackList_1Tx);
printTxData("whiteBlackList_2Tx", whiteBlackList_2Tx);
printTxData("whiteBlackList_3Tx", whiteBlackList_3Tx);
printTxData("whiteBlackList_4Tx", whiteBlackList_4Tx);
printTokenContractDetails([account4, account5, account6, account7]);
console.log("RESULT: ");


waitUntil("dateIcoMain", crowdsale.dateIcoMain(), 1);


// -----------------------------------------------------------------------------
var sendContribution1Message = "Send Contribution #1";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + sendContribution1Message + " ----------");
var sendContribution1_1Tx = eth.sendTransaction({from: account3, to: crowdsaleAddress, gas: 400000, value: web3.toWei("100", "ether")});
var sendContribution1_2Tx = eth.sendTransaction({from: account4, to: crowdsaleAddress, gas: 400000, value: web3.toWei("200", "ether")});
var sendContribution1_3Tx = eth.sendTransaction({from: account5, to: crowdsaleAddress, gas: 400000, value: web3.toWei("300", "ether")});
var sendContribution1_4Tx = eth.sendTransaction({from: account6, to: crowdsaleAddress, gas: 400000, value: web3.toWei("400", "ether")});
var sendContribution1_5Tx = eth.sendTransaction({from: account8, to: crowdsaleAddress, gas: 400000, value: web3.toWei("500", "ether")});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(sendContribution1_1Tx, sendContribution1Message + " - Not Whitelisted contribution ac3 100 ETH");
failIfTxStatusError(sendContribution1_2Tx, sendContribution1Message + " - Whitelisted contribution ac4 200 ETH");
failIfTxStatusError(sendContribution1_3Tx, sendContribution1Message + " - Whitelisted contribution ac5 300 ETH");
passIfTxStatusError(sendContribution1_4Tx, sendContribution1Message + " - Blacklisted contribution ac6 400 ETH");
failIfTxStatusError(sendContribution1_5Tx, sendContribution1Message + " - Not Whitelisted contribution ac8 500 ETH - To reclaim ETH");
printTxData("sendContribution1_1Tx", sendContribution1_1Tx);
printTxData("sendContribution1_2Tx", sendContribution1_2Tx);
printTxData("sendContribution1_3Tx", sendContribution1_3Tx);
printTxData("sendContribution1_4Tx", sendContribution1_4Tx);
printTxData("sendContribution1_4Tx", sendContribution1_5Tx);
printTokenContractDetails([account3, account4, account5, account6, account8]);
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var whitelist_Message = "Whitelist Accounts";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + whitelist_Message + " ----------");
var whitelist_1Tx = crowdsale.addToWhitelist(account3, {from: contractOwnerAccount, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(whitelist_1Tx, whitelist_Message + " - owner addToWhitelist(ac3)");
printTxData("whitelist_1Tx", whitelist_1Tx);
printTokenContractDetails([account3]);
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var sendContributions2Message = "Send Contribution #1";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + sendContributions2Message + " ----------");
var sendContributions2_1Tx = eth.sendTransaction({from: account7, to: crowdsaleAddress, gas: 400000, value: web3.toWei("1400", "ether")});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(sendContributions2_1Tx, sendContributions2Message + " - ac7 1,400 ETH");
printTxData("sendContributions2_1Tx", sendContributions2_1Tx);
printTokenContractDetails([account7]);
console.log("RESULT: ");


waitUntil("dateIcoDeadline", crowdsale.dateIcoDeadline(), 1);


// -----------------------------------------------------------------------------
var reclaimEth1Message = "Reclaim ETH #1";
// -----------------------------------------------------------------------------
console.log("RESULT: ---------- " + reclaimEth1Message + " ----------");
var reclaimEth1_1Tx = crowdsale.reclaimEth({from: account3, gas: 1000000, gasPrice: defaultGasPrice});
var reclaimEth1_2Tx = crowdsale.reclaimEth({from: account4, gas: 1000000, gasPrice: defaultGasPrice});
var reclaimEth1_3Tx = crowdsale.reclaimEth({from: account5, gas: 1000000, gasPrice: defaultGasPrice});
var reclaimEth1_4Tx = crowdsale.reclaimEth({from: account7, gas: 1000000, gasPrice: defaultGasPrice});
var reclaimEth1_5Tx = crowdsale.reclaimEth({from: account8, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(reclaimEth1_1Tx, reclaimEth1Message + " - ac3 Reclaim 100 ETH");
failIfTxStatusError(reclaimEth1_2Tx, reclaimEth1Message + " - ac4 Reclaim 200 ETH");
failIfTxStatusError(reclaimEth1_3Tx, reclaimEth1Message + " - ac5 Reclaim 300 ETH");
failIfTxStatusError(reclaimEth1_4Tx, reclaimEth1Message + " - ac7 Reclaim 1,400 ETH");
failIfTxStatusError(reclaimEth1_5Tx, reclaimEth1Message + " - ac8 Reclaim 500 ETH");
printTxData("reclaimEth1_1Tx", reclaimEth1_1Tx);
printTxData("reclaimEth1_2Tx", reclaimEth1_2Tx);
printTxData("reclaimEth1_3Tx", reclaimEth1_3Tx);
printTxData("reclaimEth1_4Tx", reclaimEth1_4Tx);
printTxData("reclaimEth1_5Tx", reclaimEth1_5Tx);
printTokenContractDetails([account8]);
console.log("RESULT: ");


EOF
grep "DATA: " $TEST4OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST4OUTPUT | sed "s/RESULT: //" > $TEST4RESULTS
cat $TEST4RESULTS
# grep "JSONSUMMARY: " $TEST4OUTPUT | sed "s/JSONSUMMARY: //" > $JSONSUMMARY
# cat $JSONSUMMARY

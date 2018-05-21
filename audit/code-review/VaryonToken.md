# VaryonToken

Source file [../../contracts/VaryonToken.sol](../../contracts/VaryonToken.sol).

<br />

<hr />

```javascript
// BK Ok
pragma solidity ^0.4.23;

// ----------------------------------------------------------------------------
//
// VAR 'Varyon' token public sale contract
//
// For details, please visit: http://www.blue-frontiers.com
//
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
//
// SafeMath
//
// ----------------------------------------------------------------------------

// BK Ok
library SafeMath {

    // BK Ok - Internal pure function
    function add(uint a, uint b) internal pure returns (uint c) {
        // BK Ok
        c = a + b;
        // BK Ok
        require(c >= a);
    }

    // BK Ok - Internal pure function
    function sub(uint a, uint b) internal pure returns (uint c) {
        // BK Ok
        require(b <= a);
        // BK Ok
        c = a - b;
    }

    // BK Ok - Internal pure function
    function mul(uint a, uint b) internal pure returns (uint c) {
        // BK Ok
        c = a * b;
        // BK Ok
        require(a == 0 || c / a == b);
    }

}


// ----------------------------------------------------------------------------
//
// Utils
//
// ----------------------------------------------------------------------------

// BK Ok
contract Utils {
    
    // BK Ok - View function
    function atNow() public view returns (uint) {
        // BK Ok
        return now;
    }

}


// ----------------------------------------------------------------------------
//
// Owned
//
// ----------------------------------------------------------------------------

// BK Ok
contract Owned {

    // BK Next 2 Ok
    address public owner;
    address public newOwner;

    // BK Ok
    mapping(address => bool) public isAdmin;

    // BK Next 3 Ok
    event OwnershipTransferProposed(address indexed _from, address indexed _to);
    event OwnershipTransferred(address indexed _from, address indexed _to);
    event AdminChange(address indexed _admin, bool _status);

    // BK Next 2 Ok
    modifier onlyOwner { require(msg.sender == owner); _; }
    modifier onlyAdmin { require(isAdmin[msg.sender]); _; }

    // BK Ok - Constructor
    constructor() public {
        // BK Ok
        owner = msg.sender;
        // BK Ok
        isAdmin[owner] = true;
    }

    // BK Ok - Only owner can execute
    function transferOwnership(address _newOwner) public onlyOwner {
        // BK Ok
        require(_newOwner != address(0x0));
        // BK Ok - Log event
        emit OwnershipTransferProposed(owner, _newOwner);
        // BK Ok
        newOwner = _newOwner;
    }

    // BK Ok - Only new owner can execute
    function acceptOwnership() public {
        require(msg.sender == newOwner);
        // BK Ok - Log event
        emit OwnershipTransferred(owner, newOwner);
        // BK Ok
        owner = newOwner;
    }

    // BK Ok - Only owner can execute
    function addAdmin(address _a) public onlyOwner {
        // BK Ok
        require(isAdmin[_a] == false);
        // BK Ok
        isAdmin[_a] = true;
        // BK Ok - Log event
        emit AdminChange(_a, true);
    }

    // BK Ok - Only owner can execute
    function removeAdmin(address _a) public onlyOwner {
        // BK Ok
        require(isAdmin[_a] == true);
        // BK Ok
        isAdmin[_a] = false;
        // BK Ok
        emit AdminChange(_a, false);
    }

}


// ----------------------------------------------------------------------------
//
// Wallet
//
// ----------------------------------------------------------------------------

// BK Ok
contract Wallet is Owned {

    // BK Ok
    address public wallet;

    // BK Ok - Event
    event WalletUpdated(address newWallet);

    // BK Ok - Constructor
    constructor() public {
        // BK Ok
        wallet = owner;
    }

    // BK Ok - Only owner can execute
    function setWallet(address _wallet) public onlyOwner {
        // BK Ok
        require(_wallet != address(0x0));
        // BK Ok
        wallet = _wallet;
        // BK Ok
        emit WalletUpdated(_wallet);
    }

}


// ----------------------------------------------------------------------------
//
// ERC20Interface
//
// ----------------------------------------------------------------------------

// BK Ok
contract ERC20Interface {

    // BK Next 2 Ok
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);

    // BK Next 6 Ok
    function totalSupply() public view returns (uint);
    function balanceOf(address _owner) public view returns (uint balance);
    function transfer(address _to, uint _value) public returns (bool success);
    function transferFrom(address _from, address _to, uint _value) public returns (bool success);
    function approve(address _spender, uint _value) public returns (bool success);
    function allowance(address _owner, address _spender) public view returns (uint remaining);

}


// ----------------------------------------------------------------------------
//
// ERC20Token
//
// ----------------------------------------------------------------------------

// BK Ok
contract ERC20Token is ERC20Interface, Owned {

    // BK Ok
    using SafeMath for uint;

    // BK Ok
    uint public tokensIssuedTotal = 0;
    // BK Next 2 Ok
    mapping(address => uint) balances;
    mapping(address => mapping (address => uint)) allowed;

    // BK Ok - View function
    function totalSupply() public view returns (uint) {
        // BK Ok
        return tokensIssuedTotal;
    }

    // BK Ok - View function
    function balanceOf(address _owner) public view returns (uint balance) {
        // BK Ok
        return balances[_owner];
    }

    // BK Ok
    function transfer(address _to, uint _amount) public returns (bool success) {
        // BK Ok
        require(balances[msg.sender] >= _amount);
        // BK Ok
        balances[msg.sender] = balances[msg.sender].sub(_amount);
        // BK Ok
        balances[_to] = balances[_to].add(_amount);
        // BK Ok - Log event
        emit Transfer(msg.sender, _to, _amount);
        // BK Ok
        return true;
    }

    // BK Ok
    function approve(address _spender, uint _amount) public returns (bool success) {
        // BK Ok
        require(balances[msg.sender] >= _amount);
        // BK Ok
        allowed[msg.sender][_spender] = _amount;
        // BK Ok - Log event
        emit Approval(msg.sender, _spender, _amount);
        // BK Ok
        return true;
    }

    // BK Ok
    function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
        // BK Ok
        require(balances[_from] >= _amount);
        // BK Ok
        require(allowed[_from][msg.sender] >= _amount);
        // BK Ok
        balances[_from] = balances[_from].sub(_amount);
        // BK Ok
        allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_amount);
        // BK Ok
        balances[_to] = balances[_to].add(_amount);
        // BK Ok - Log event
        emit Transfer(_from, _to, _amount);
        // BK Ok
        return true;
    }

    // BK Ok - View function
    function allowance(address _owner, address _spender) public view returns (uint remaining) {
        // BK Ok
        return allowed[_owner][_spender];
    }

}


// ----------------------------------------------------------------------------
//
// LockSlots
//
// ----------------------------------------------------------------------------

// BK Ok
contract LockSlots is ERC20Token, Utils {

    // BK Ok
    using SafeMath for uint;

    // BK Ok
    uint8 public constant LOCK_SLOTS = 6;
    // BK Next 2 Ok
    mapping(address => uint[LOCK_SLOTS]) public lockTerm;
    mapping(address => uint[LOCK_SLOTS]) public lockAmnt;
    // BK Ok
    mapping(address => bool) public mayHaveLockedTokens;

    // BK Next 3 Ok - Events
    event RegisteredLockedTokens(address indexed account, uint indexed idx, uint tokens, uint term);
    event IcoLockSet(address indexed account, uint term, uint tokens);
    event IcoLockChanged(address indexed account, uint oldTerm, uint newTerm);

    // BK Ok - Internal function, called by VaryonToken.pMintTokensLocked(...) private
    function registerLockedTokens(address _account, uint _tokens, uint _term) internal returns (uint idx) {
        // BK Ok
        require(_term > atNow(), "lock term must be in the future"); 

        // find a slot (clean up while doing this)
        // use either the existing slot with the exact same term,
        // of which there can be at most one, or the first empty slot
        // BK Ok
        idx = 9999;    
        // BK Next 2 Ok
        uint[LOCK_SLOTS] storage term = lockTerm[_account];
        uint[LOCK_SLOTS] storage amnt = lockAmnt[_account];
        // BK Ok
        for (uint i = 1; i < LOCK_SLOTS; i++) {
            // BK Ok
            if (term[i] <= atNow()) {
                // BK Next 2 Ok
                term[i] = 0;
                amnt[i] = 0;
                // BK Ok
                if (idx == 9999) idx = i;
            }
            // BK Ok
            if (term[i] == _term) idx = i;
        }

        // fail if no slot was found
        // BK Ok
        require(idx != 9999, "registerLockedTokens: no available slot found");

        // register locked tokens
        // BK Ok
        if (term[idx] == 0) term[idx] = _term;
        // BK Ok
        amnt[idx] = amnt[idx].add(_tokens);
        // BK Ok
        mayHaveLockedTokens[_account] = true;
        // BK Ok - Log event
        emit RegisteredLockedTokens(_account, idx, _tokens, _term);
    }

    // public view functions

    // BK Ok - View function
    function lockedTokens(address _account) public view returns (uint) {
        // BK Ok
        if (!mayHaveLockedTokens[_account]) return 0;
        // BK Ok
        return pNumberOfLockedTokens(_account);
    }

    // BK Ok - View function
    function unlockedTokens(address _account) public view returns (uint) {
        // BK Ok
        return balances[_account].sub(lockedTokens(_account));
    }

    // BK Ok - View function
    function isAvailableLockSlot(address _account, uint _term) public view returns (bool) {
        // BK Ok
        if (!mayHaveLockedTokens[_account]) return true;
        // BK Ok
        if (_term < atNow()) return true;
        // BK Ok
        uint[LOCK_SLOTS] storage term = lockTerm[_account];
        // does not check ICO slot 0
        // BK Ok
        for (uint i = 1; i < LOCK_SLOTS; i++) {
            // BK Ok
            if (term[i] < atNow() || term[i] == _term) return true;
        }
        // BK Ok
        return false;
    }

    // Slot 0 is used only for ICO contributions only

    // BK Ok - Internal function, called by processTokenIssue(...)
    function setIcoLock(address _account, uint _term, uint _tokens) internal {
        // BK Ok
        lockTerm[_account][0] = _term;
        // BK Ok
        lockAmnt[_account][0] = _tokens;
        // BK Ok
        mayHaveLockedTokens[_account] = true;
        // BK Ok - Log event
        emit IcoLockSet(_account, _term, _tokens);
    }

    // BK Ok - Only admin can execute
    function modifyIcoLock(address _account, uint _unixts) public onlyAdmin {
        // BK Ok
        require(lockTerm[_account][0] > atNow(), "the ICO tokens are already unlocked");
        // BK Ok
        require(_unixts < lockTerm[_account][0], "locking period can only be shortened");
        // BK Ok
        uint term = lockTerm[_account][0];
        // BK Ok
        lockTerm[_account][0] = _unixts;
        // BK Ok - Log event
        emit IcoLockChanged(_account, term, _unixts);
    }

    // internal and private functions

    // BK Ok - Internal function, called by transfer(...), transferFrom(...) and transferMultiple(...)
    function unlockedTokensInternal(address _account) internal returns (uint) {
        // updates mayHaveLockedTokens if necessary
        // BK Ok
        if (!mayHaveLockedTokens[_account]) return balances[_account];
        // BK Ok
        uint locked = pNumberOfLockedTokens(_account);
        // BK Ok
        if (locked == 0) mayHaveLockedTokens[_account] = false;
        // BK Ok
        return balances[_account].sub(locked);
    }

    // BK Ok - View function
    function pNumberOfLockedTokens(address _account) private view returns (uint locked) {
        // BK Next 2 Ok
        uint[LOCK_SLOTS] storage term = lockTerm[_account];
        uint[LOCK_SLOTS] storage amnt = lockAmnt[_account];
        // BK Ok
        for (uint i = 0; i < LOCK_SLOTS; i++) {
            // BK Ok
            if (term[i] >= atNow()) locked = locked.add(amnt[i]);
        }
    }

}


// ----------------------------------------------------------------------------
//
// WBList
//
// ----------------------------------------------------------------------------

// BK Ok
contract WBList is Owned, Utils {

    // BK Ok
    using SafeMath for uint;

    // BK Ok
    uint public constant MAX_LOCKING_PERIOD = 1827 days; // max 5 years

    // BK Next 4 Ok
    mapping(address => bool) public whitelist;
    mapping(address => uint) public whitelistLimit;
    mapping(address => uint) public whitelistThreshold;
    mapping(address => uint) public whitelistLockDate;

    // BK Ok
    mapping(address => bool) public blacklist;

    // BK Next 2 Ok - Events
    event Whitelisted(address indexed account, uint limit, uint threshold, uint term);
    event Blacklisted(address indexed account);

    // BK Next 2 Ok - Overridden in VaryonToken
    function processWhitelisting(address _account) internal;
    function processBlacklisting(address _account) internal;


    // BK Ok - Only admin can execute
    function addToWhitelist(address _account) public onlyAdmin {
        // BK Ok
        pWhitelist(_account, 0, 0, 0);
    }
    
    // BK Ok - Only admin can execute
    function addToWhitelistParams(address _account, uint _limit, uint _threshold, uint _term) public onlyAdmin {
        // BK Ok
        pWhitelist(_account, _limit, _threshold, _term);
    }

    // BK Ok - Only admin can execute
    function addToWhitelistMultiple(address[] _accounts) public onlyAdmin {
        // BK Ok
        for (uint i = 0; i < _accounts.length; i++) {
            // BK Ok
            pWhitelist(_accounts[i], 0, 0, 0);
        }
    }

    // BK Ok - Only admin can execute
    function addToWhitelistParamsMultiple(address[] _accounts, uint[] _limits, uint[] _thresholds, uint[] _terms) public onlyAdmin {
        // BK Next 3 Ok
        require(_accounts.length == _limits.length);
        require(_accounts.length == _thresholds.length);
        require(_accounts.length == _terms.length);
        // BK Ok
        for (uint i = 0; i < _accounts.length; i++) {
            // BK Ok
            pWhitelist(_accounts[i], _limits[i], _thresholds[i], _terms[i]);
        }
    }

    // BK Ok - Private
    function pWhitelist(address _account, uint _limit, uint _threshold, uint _term) private {
        // BK Next 2 Ok
        require(!whitelist[_account], "account is already whitelisted");
        require(!blacklist[_account], "account is blacklisted");

        // whitelisting parameter checks
        // BK Ok
        if (_threshold > 0 ) require(_threshold > _limit, "threshold not above limit");
        // BK Ok
        if (_term > 0) {
            // BK Ok
            require(_term > atNow(), "the locking period cannot be in the past");
            // BK Ok
            require(_term < atNow() + MAX_LOCKING_PERIOD, "the locking period cannot exceed 5 years");
        }

        // add to whitelist
        // BK Next 4 Ok
        whitelist[_account] = true;
        whitelistLimit[_account] = _limit;
        whitelistThreshold[_account] = _threshold;
        whitelistLockDate[_account] = _term;
        // BK Ok - Log event
        emit Whitelisted(_account, _limit, _threshold, _term);

        // actions linked to whitelisting
        // BK Ok
        processWhitelisting(_account);
    }


    // BK Ok - Only admin can execute
    function addToBlacklist(address _account) public onlyAdmin {
        // BK Ok
        pBlacklist(_account);
    }

    // BK Ok - Only admin can execute
    function addToBlacklistMultiple(address[] _accounts) public onlyAdmin {
        // BK Ok
        for (uint i = 0; i < _accounts.length; i++) {
            // BK Ok
            pBlacklist(_accounts[i]);
        }
    }

    // BK Ok - Private function
    function pBlacklist(address _account) private {
        // BK Next 2 Ok
        require(!whitelist[_account], "account is whitelisted");
        require(!blacklist[_account], "account is already blacklisted");

        // add to blacklist
        // BK Ok
        blacklist[_account] = true;
        // BK Ok - Log event
        emit Blacklisted(_account);

        // actions linked to blacklisting
        // BK Ok
        processBlacklisting(_account);
    }

}


// ----------------------------------------------------------------------------
//
// Varyon ICO dates
//
// ----------------------------------------------------------------------------

// BK Ok
contract VaryonIcoDates is Owned, Utils {    

    // BK Ok - crowdsale.dateIcoPresale=1526392800 Tue, 15 May 2018 14:00:00 UTC Wed, 16 May 2018 00:00:00 AEST
    uint public dateIcoPresale  = 1526392800; // 15-MAY-2018 14:00 UTC
    // BK Ok - crowdsale.dateIcoMain=1527861600 Fri, 01 Jun 2018 14:00:00 UTC Sat, 02 Jun 2018 00:00:00 AEST
    uint public dateIcoMain     = 1527861600; // 01-JUN-2018 14:00 UTC
    // BK Ok - crowdsale.dateIcoEnd=1530367200 Sat, 30 Jun 2018 14:00:00 UTC Sun, 01 Jul 2018 00:00:00 AEST
    uint public dateIcoEnd      = 1530367200; // 30-JUN-2018 14:00 UTC
    // BK Ok - crowdsale.dateIcoDeadline=1533045600 Tue, 31 Jul 2018 14:00:00 UTC Wed, 01 Aug 2018 00:00:00 AEST
    uint public dateIcoDeadline = 1533045600; // 31-JUL-2018 14:00 UTC

    // BK Ok - crowdsale.DATE_LIMIT=1538316000 Sun, 30 Sep 2018 14:00:00 UTC Mon, 01 Oct 2018 00:00:00 AEST
    uint public constant DATE_LIMIT = 1538316000; // 30-SEP-2018 14:00 UTC

    // BK Ok
    event IcoDateUpdated(uint8 id, uint unixts);

    // BK Ok - Constructor
    constructor() public {
        // BK Ok
        require(atNow() < dateIcoPresale);
        // BK Ok
        checkDateOrder();
    }

    // BK Ok - Internal view function
    function checkDateOrder() internal view {
        // BK Next 4 Ok
        require(dateIcoPresale < dateIcoMain);
        require(dateIcoMain < dateIcoEnd);
        require(dateIcoEnd < dateIcoDeadline);
        require(dateIcoDeadline < DATE_LIMIT);
    }

    // BK Ok - Only owner can execute
    function setDateIcoPresale(uint _unixts) public onlyOwner {
        // BK Ok
        require(atNow() < _unixts && atNow() < dateIcoPresale);
        // BK Ok
        dateIcoPresale = _unixts;
        // BK Ok
        checkDateOrder();
        // BK Ok - Log event
        emit IcoDateUpdated(1, _unixts);
    }

    // BK Ok - Only owner can execute
    function setDateIcoMain(uint _unixts) public onlyOwner {
        // BK Ok
        require(atNow() < _unixts && atNow() < dateIcoMain);
        // BK Ok
        dateIcoMain = _unixts;
        // BK Ok
        checkDateOrder();
        // BK Ok - Log event
        emit IcoDateUpdated(2, _unixts);
    }

    // BK Ok - Only owner can execute
    function setDateIcoEnd(uint _unixts) public onlyOwner {
        // BK Ok
        require(atNow() < _unixts && atNow() < dateIcoEnd);
        // BK Ok
        dateIcoEnd = _unixts;
        // BK Ok
        checkDateOrder();
        // BK Ok - Log event
        emit IcoDateUpdated(3, _unixts);
    }

    // BK Ok - Only owner can execute
    function setDateIcoDeadline(uint _unixts) public onlyOwner {
        // BK Ok
        require(atNow() < _unixts && atNow() < dateIcoDeadline);
        // BK Ok
        dateIcoDeadline = _unixts;
        // BK Ok
        checkDateOrder();
        // BK Ok - Log event
        emit IcoDateUpdated(4, _unixts);
    }

}


// ----------------------------------------------------------------------------
//
// VAR public token sale
//
// ----------------------------------------------------------------------------

// BK Ok
contract VaryonToken is ERC20Token, Wallet, LockSlots, WBList, VaryonIcoDates {

    // Utility variable

    // BK Ok
    uint constant E18 = 10**18;

    // Basic token data

    // BK Next 3 Ok
    string public constant name = "Varyon Token";
    string public constant symbol = "VAR";
    uint8 public constant decimals = 18;

    // Crowdsale parameters : token price, supply, caps and bonus

    // BK Ok
    uint public constant TOKENS_PER_ETH = 10000; // test value, will be changed before deployment

    // BK Ok
    uint public constant TOKEN_TOTAL_SUPPLY = 1000000000 * E18; // VAR 1,000,000,000

    // BK Next 3 Ok
    uint public constant TOKEN_THRESHOLD   =  4000 * TOKENS_PER_ETH * E18; // ETH  4,000 = VAR  59,000,000
    uint public constant TOKEN_PRESALE_CAP =  4400 * TOKENS_PER_ETH * E18; // ETH  4,400 = VAR  64,000,000
    uint public constant TOKEN_ICO_CAP     = 24200 * TOKENS_PER_ETH * E18; // ETH 24,200 = VAR 356,950,000

    // BK Ok
    uint public constant BONUS = 15;

    // BK Ok
    uint public constant MAX_BONUS_TOKENS = TOKEN_PRESALE_CAP * BONUS / 100; // 9,735,000 tokens

    // Crowdsale parameters : minimum purchase amounts expressed in tokens        

    // BK Next 2 Ok
    uint public constant MIN_PURCHASE_PRESALE = 40 * TOKENS_PER_ETH * E18; // ETH 40 = VAR 590,000
    uint public constant MIN_PURCHASE_MAIN    =  1 * TOKENS_PER_ETH * E18; // ETH  1 = VAR  14,750

    // Crowdsale parameters : minimum contribution in ether

    // BK Ok
    uint public constant MINIMUM_ETH_CONTRIBUTION = 0.01 ether;

    // Tokens from off-chain contributions (no eth returns for these tokens)

    // BK Ok
    mapping(address => uint) public balancesOffline;

    // Tokens - pending

    // BK Next 2 Ok
    mapping(address => uint) public balancesPending;
    mapping(address => uint) public balancesPendingOffline;

    // BK Ok
    uint public tokensIcoPending;

    // Tokens - issued

    // mapping(address => uint) balances; // in ERC20Token
    // BK Ok
    mapping(address => uint) public balancesMinted;

    // uint public tokensIssuedTotal = 0; // in ERC20Token
    // tokensIssuedTotal = tokensIcoIssued + tokensIcoBonus + tokensMinted 

    // BK Next 5 Ok
    uint public tokensIcoIssued; // = tokensIcoCrowd + tokensIcoOffline 
    uint public tokensIcoCrowd;
    uint public tokensIcoOffline;
    uint public tokensIcoBonus;
    uint public tokensMinted;

    // BK Ok
    mapping(address => uint) public balancesBonus;

    // Ether - tokens pending

    // BK Ok
    mapping(address => uint) public ethPending;
    // BK Ok
    uint public totalEthPending;

    // Ether - tokens issued

    // BK Ok
    mapping(address => uint) public ethContributed;
    // BK Ok
    uint public totalEthContributed;

    // Keep track of refunds in case of failed ICO

    // BK Ok
    mapping(address => bool) public refundClaimed;

    // Events ---------------------------

    // BK Next 9 Ok - Events
    event TokensMinted(address indexed account, uint tokens, uint term);
    event RegisterOfflineContribution(address indexed account, uint tokens, uint tokensBonus);
    event RegisterOfflinePending(address indexed account, uint tokens);
    event RegisterContribution(address indexed account, uint tokens, uint tokensBonus, uint ethContributed, uint ethReturned);
    event RegisterPending(address indexed account, uint tokens, uint ethContributed, uint ethReturned);
    event WhitelistingEvent(address indexed account, uint tokens, uint tokensBonus, uint tokensReturned, uint ethContributed, uint ethReturned);
    event OfflineTokenReturn(address indexed account, uint tokensReturned);
    event RevertPending(address indexed account, uint tokensCancelled, uint ethReturned, uint tokensIcoPending, uint totalEthPending);
    event RefundFailedIco(address indexed account, uint ethReturned);

    // Basic Functions ----------------------------

    // BK Ok
    constructor() public {}

    // BK Ok - Any account can send ETH and can contribute depending on whitelisting etc
    function () public payable {
        // BK Ok
        buyTokens();
    }

    // Information Functions --------------------------------

    // BK Ok - View function
    function tradeable() public view returns (bool) {
        // BK Ok
        if (thresholdReached() && atNow() > dateIcoEnd) return true;
        // BK Ok
        return false;
    }

    // BK Ok - View function
    function thresholdReached() public view returns (bool) {
        // BK Ok
        if (tokensIcoIssued >= TOKEN_THRESHOLD) return true;
        // BK Ok
        return false;
    }

    // BK Ok - View function
    function availableToMint() public view returns (uint available) {
        // BK Ok
        if (atNow() <= dateIcoEnd) {
            // BK Ok
            available = TOKEN_TOTAL_SUPPLY.sub(TOKEN_ICO_CAP).sub(MAX_BONUS_TOKENS).sub(tokensMinted);
        // BK Ok
        } else if (atNow() <= dateIcoDeadline) {
            // BK Ok
            available = TOKEN_TOTAL_SUPPLY.sub(tokensIssuedTotal).sub(tokensIcoPending);
        // BK Ok
        } else {
            // BK Ok
            available = TOKEN_TOTAL_SUPPLY.sub(tokensIssuedTotal);
        }
    }

    // BK Ok - View function
    function tokensAvailableIco() public view returns (uint) {
        // BK Ok
        if (atNow() <= dateIcoMain) {
            // BK Ok
            return TOKEN_PRESALE_CAP.sub(tokensIcoIssued).sub(tokensIcoPending);
        // BK Ok
        } else {
            // BK Ok
            return TOKEN_ICO_CAP.sub(tokensIcoIssued).sub(tokensIcoPending);
        }
    }

    // BK Ok - Private view function
    function minimumInvestment() private view returns (uint) {
        // BK Ok
        if (atNow() <= dateIcoMain) return MIN_PURCHASE_PRESALE;
        // BK Ok
        return MIN_PURCHASE_MAIN;
    }

    // BK Ok - Pure function
    function ethToTokens(uint _eth) public pure returns (uint tokens) {
        // BK Ok
        tokens = _eth.mul(TOKENS_PER_ETH);
    }

    // BK Ok - Pure function
    function tokensToEth(uint _tokens) public pure returns (uint eth) {
        // BK Ok
        eth = _tokens / TOKENS_PER_ETH;
    }

    // BK Ok - Private view function
    function getBonus(uint _tokens) private view returns (uint) {
        // BK Ok
        if (atNow() <= dateIcoMain) return _tokens.mul(BONUS)/100;
        // BK Ok
        return 0;
    }

    // Minting of tokens by owner ---------------------------
    
    // Minting of unrestricted tokens

    // BK Ok - Only owner can execute
    function mintTokens(address _account, uint _tokens) public onlyOwner {
        // BK Ok
        pMintTokens(_account, _tokens);
    }

    // BK Ok - Only owner can execute
    function mintTokensMultiple(address[] _accounts, uint[] _tokens) public onlyOwner {
        // BK Ok
        require(_accounts.length == _tokens.length);
        // BK Ok
        for (uint i = 0; i < _accounts.length; i++) {
            // BK Ok
            pMintTokens(_accounts[i], _tokens[i]);
        }
    }

    // BK Ok - Private
    function pMintTokens(address _account, uint _tokens) private {
        // checks
        // BK Next 3 Ok
        require(_account != 0x0);
        require(_tokens > 0);
        require(_tokens <= availableToMint(), "not enough tokens available to mint");

        // update
        // BK Ok
        balances[_account] = balances[_account].add(_tokens);
        // BK Ok
        balancesMinted[_account] = balancesMinted[_account].add(_tokens);
        // BK Ok
        tokensMinted = tokensMinted.add(_tokens);
        // BK Ok
        tokensIssuedTotal = tokensIssuedTotal.add(_tokens);

        // log event
        // BK Next 2 Ok - Log events
        emit Transfer(0x0, _account, _tokens);
        emit TokensMinted(_account, _tokens, 0);
    }

    // Minting of locked tokens

    // BK Ok - Only owner can execute
    function mintTokensLocked(address _account, uint _tokens, uint _term) public onlyOwner {
        // BK Ok
        pMintTokensLocked(_account, _tokens, _term);
    }

    // BK Ok - Only owner can execute
    function mintTokensLockedMultiple(address[] _accounts, uint[] _tokens, uint[] _terms) public onlyOwner {
        // BK Ok
        require(_accounts.length == _tokens.length);
        // BK Ok
        require(_accounts.length == _terms.length);
        // BK Ok
        for (uint i = 0; i < _accounts.length; i++) {
            // BK Ok
            pMintTokensLocked(_accounts[i], _tokens[i], _terms[i]);
        }
    }

    // BK Ok - Private function
    function pMintTokensLocked(address _account, uint _tokens, uint _term) private {
        // checks
        // BK Next 3 Ok
        require(_account != 0x0);
        require(_tokens > 0);
        require(_tokens <= availableToMint(), "not enough tokens available to mint");

        // term has to be in the future
        // BK Ok
        require(_term > atNow(), "lock term must be in the future");

        // register locked tokens (will throw if no slot is found)
        // BK Ok
        registerLockedTokens(_account, _tokens, _term);

        // update
        // BK Ok
        balances[_account] = balances[_account].add(_tokens);
        // BK Ok
        balancesMinted[_account] = balancesMinted[_account].add(_tokens);
        // BK Ok
        tokensMinted = tokensMinted.add(_tokens);
        // BK Ok
        tokensIssuedTotal = tokensIssuedTotal.add(_tokens);

        // log event
        // BK Next 2 Ok - Log events
        emit Transfer(0x0, _account, _tokens);
        emit TokensMinted(_account, _tokens, _term);
    }

    // Offline contributions --------------------------------

    // BK Ok - Only admin can execute
    function buyOffline(address _account, uint _tokens) public onlyAdmin {
        // BK Ok
        require(!blacklist[_account]);
        // BK Ok
        require(atNow() <= dateIcoEnd);
        // BK Ok
        require(_tokens <= tokensAvailableIco());

        // buy tokens
        // BK Ok
        if (whitelist[_account]) {
            // BK Ok
            buyOfflineWhitelist(_account, _tokens);
        // BK Ok
        } else {
            // BK Ok
            buyOfflinePending(_account, _tokens);
        }
    }

    // BK Ok - Private function only called by buyOffline(...)
    function buyOfflineWhitelist(address _account, uint _tokens) private {

        // adjust based on limit and threshold, update total offline contributions
        // BK Next 2 Ok
        uint tokens;
        uint tokens_bonus;
        // BK Ok
        (tokens, tokens_bonus) = processTokenIssue(_account, _tokens);
        // BK Ok
        balancesOffline[_account] = balancesOffline[_account].add(tokens);
        // BK Ok
        tokensIcoOffline = tokensIcoOffline.add(tokens);

        // throw if no tokens can be issued
        // BK Ok
        require(tokens > 0, "no tokens can be issued");
        
        // log
        // BK Next 2 Ok - Log events
        emit Transfer(0x0, _account, tokens.add(tokens_bonus));
        emit RegisterOfflineContribution(_account, tokens, tokens_bonus);    
    }

    // BK Ok - Private function only called by buyOffline(...)
    function buyOfflinePending(address _account, uint _tokens) private {
        // BK Next 3 Ok
        balancesPending[_account] = balancesPending[_account].add(_tokens);
        balancesPendingOffline[_account] = balancesPendingOffline[_account].add(_tokens);
        tokensIcoPending = tokensIcoPending.add(_tokens);
        // BK Ok
        emit RegisterOfflinePending(_account, _tokens);
    }

    // Crowdsale ETH contributions --------------------------

    // BK Ok - Private. Only called by fallback function
    function buyTokens() private {

        // checks
        // BK Ok
        require(atNow() > dateIcoPresale && atNow() <= dateIcoEnd, "outside of ICO period");
        // BK Ok
        require(msg.value >= MINIMUM_ETH_CONTRIBUTION, "fail minimum contribution");
        // BK Ok
        require(!blacklist[msg.sender], "blacklisted sending address");
        // BK Ok
        require(tokensAvailableIco() > 0, "no more tokens available");
        
        // buy tokens
        // BK Ok
        if (whitelist[msg.sender]) {
            // BK Ok
            buyTokensWhitelist();
        // BK Ok
        } else {
            // BK Ok
            buyTokensPending();
        }

    }

    // contributions from pending (non-whitelisted) addresses

    // BK Ok - Private function
    function buyTokensPending() private {
        
        // the maximum number of tokens is a function of ether sent
        // the actual maximum depends on tokens available
        // BK Ok
        uint tokens_max = ethToTokens(msg.value);
        // BK Ok
        uint tokens = tokens_max;
        // BK Ok
        if (tokens_max > tokensAvailableIco()) {
            // BK Ok
            tokens = tokensAvailableIco();
        }

        // check minimum purchase amount
        // BK Ok
        uint tokens_total = balancesPending[msg.sender].add(tokens);
        // BK Ok
        require(tokens_total >= minimumInvestment(), "minimum purchase amount");

        // eth returned, if any
        // BK Ok
        uint eth_contributed = msg.value;
        // BK Ok
        uint eth_returned = 0;
        // BK Ok
        if (tokens < tokens_max) {
            // BK Next 2 Ok
            eth_contributed = tokensToEth(tokens);
            eth_returned = msg.value.sub(eth_contributed);
        }

        // tokens
        // BK Ok
        balancesPending[msg.sender] = balancesPending[msg.sender].add(tokens);
        // BK Ok
        tokensIcoPending = tokensIcoPending.add(tokens);
        // eth
        // BK Ok
        ethPending[msg.sender] = ethPending[msg.sender].add(eth_contributed);
        // BK Ok
        totalEthPending = totalEthPending.add(eth_contributed);
        // return any unused ether
        // BK Ok
        if (eth_returned > 0) msg.sender.transfer(eth_returned);
        // log
        // BK Ok - Log event
        emit RegisterPending(msg.sender, tokens, eth_contributed, eth_returned);
    }

    // contributions from whitelisted addresses

    // BK Ok - Private function
    function buyTokensWhitelist() private {

        // to process as contributions:
        // BK Next 3 Ok
        uint tokens;
        uint tokens_bonus;
        uint eth_to_contribute;

        // to return:
        // BK Ok
        uint eth_to_return;
        
        // helper variable
        // BK Ok
        uint tokens_max;

        // the maximum number of tokens is a function of ether sent
        // the actual maximum depends on tokens available
        // BK Ok
        tokens_max = ethToTokens(msg.value);
        // BK Ok
        tokens = tokens_max;
        // BK Ok
        if (tokens_max > tokensAvailableIco()) {
            // BK Ok
            tokens = tokensAvailableIco();
        }

        // adjust based on limit and threshold, update total crowd contribution
        // BK Ok
        (tokens, tokens_bonus) = processTokenIssue(msg.sender, tokens);
        // BK Ok
        tokensIcoCrowd = tokensIcoCrowd.add(tokens);

        // throw if no tokens can be allocated, or if below min purchase amount
        // BK Ok
        require(tokens > 0, "no tokens can be issued");
        // BK Ok
        require(balances[msg.sender].sub(balancesBonus[msg.sender]) >= minimumInvestment(), "minimum purchase amount");

        // register eth contribution and return any unused ether if necessary
        // BK Next 2 Ok
        eth_to_contribute = msg.value;
        eth_to_return = 0;
        // BK Ok
        if (tokens < tokens_max) {
            // BK Next 2 Ok
            eth_to_contribute = tokensToEth(tokens);
            eth_to_return = msg.value.sub(eth_to_contribute);
        }
        // BK Ok
        ethContributed[msg.sender] = ethContributed[msg.sender].add(eth_to_contribute);
        // BK Ok
        totalEthContributed = totalEthContributed.add(eth_to_contribute);
        // BK Ok
        if (eth_to_return > 0) { msg.sender.transfer(eth_to_return); }

        // send ether to wallet if threshold reached
        // BK Ok
        sendEtherToWallet();

        // log
        // BK Next 2 Ok - Log event
        emit Transfer(0x0, msg.sender, tokens.add(tokens_bonus));
        emit RegisterContribution(msg.sender, tokens, tokens_bonus, eth_to_contribute, eth_to_return);
    }

    // whitelisting of an address

    // BK Ok - Internal function
    function processWhitelisting(address _account) internal {
        // BK Ok
        require(atNow() <= dateIcoDeadline);
        // BK Ok
        if (balancesPending[_account] == 0) return; 

        // to process as contributions:
        // BK Next 3 Ok
        uint tokens;
        uint tokens_bonus;
        uint eth_to_contribute;

        // to return:
        // BK Next 2 Ok
        uint tokens_to_return;
        uint eth_to_return;

        // helper variable
        // BK Ok
        uint tokens_max;

        // the maximum number of tokens equals pending tokens for the account
        // the actual maximum depends on tokens available
        // BK Ok
        tokens_max = balancesPending[_account];
        // BK Ok
        tokens = tokens_max;
        // BK Ok
        if (tokens_max > tokensAvailableIco()) {
            // BK Ok
            tokens = tokensAvailableIco();
        }

        // adjust based on limit and threshold, update total crowd contribution
        // BK Ok
        (tokens, tokens_bonus) = processTokenIssue(_account, tokens);

        // split tokens to be issued between online and offline for better accounting
        // (pending tokens that cannot be issued are tekan from the online portion first)
        // BK Ok
        if (tokens >= balancesPendingOffline[_account]) {
            // BK Ok
            balancesOffline[_account] = balancesOffline[_account];
            // BK Ok
            tokensIcoOffline = tokensIcoOffline.add(balancesPendingOffline[_account]);
            // BK Ok
            tokensIcoCrowd = tokensIcoCrowd.add(tokens).sub(balancesPendingOffline[_account]);
        // BK Ok
        } else {
            // BK Ok
            balancesOffline[_account] = balancesOffline[_account].add(tokens);
            // BK Ok
            tokensIcoOffline = tokensIcoOffline.add(tokens);
            // BK Ok - Log event
            emit OfflineTokenReturn(_account, balancesPendingOffline[_account].sub(tokens));
        }

        // tokens to return
        // BK Ok
        tokens_to_return = tokens_max.sub(tokens);

        // ether to return (there may be an "offline" portion)
        // BK Ok
        if (tokens_to_return > 0) {
            // BK Ok
            eth_to_return = tokensToEth(tokens_to_return);
            // BK Ok
            if (eth_to_return > ethPending[_account]) { eth_to_return = ethPending[_account]; }
        }
        // BK Ok
        eth_to_contribute = ethPending[_account].sub(eth_to_return);

        // process tokens pending
        // BK Next 3 Ok
        balancesPending[_account] = 0;
        balancesPendingOffline[_account] = 0;
        tokensIcoPending = tokensIcoPending.sub(tokens_max);

        // process eth pending
        // BK Next 2 Ok
        totalEthPending = totalEthPending.sub(ethPending[_account]);
        ethPending[_account] = 0;

        // process eth issued
        // BK Next 2 Ok
        ethContributed[_account] = eth_to_contribute;
        totalEthContributed = totalEthContributed.add(eth_to_contribute);

        // return any unused ether
        // BK Ok
        if (eth_to_return > 0) { _account.transfer(eth_to_return); }

        // send ether to wallet if threshold reached
        // BK Ok
        sendEtherToWallet();

        // log
        // BK Next 2 Ok - Log event
        emit Transfer(0x0, _account, tokens.add(tokens_bonus));
        emit WhitelistingEvent(_account, tokens, tokens_bonus, tokens_to_return, eth_to_contribute, eth_to_return);
    }

    // Send ether to wallet if threshold reached

    // BK Ok - Private function, called by buyTokensWhitelist() and processWhitelisting()
    function sendEtherToWallet() private {
        // BK Ok
        address thisAddress = this;
        // BK Ok
        if (thresholdReached() && thisAddress.balance > totalEthPending) {
            // BK Ok
            wallet.transfer(thisAddress.balance.sub(totalEthPending));
        }
    }

    // Adjust tokens that can be issued, based on limit and threshold, and update balances

    // BK Ok - Called by buyOfflineWhitelist(...), buyTokensWhitelist(...) and processWhitelisting(...)
    function processTokenIssue(address _account, uint _tokens_to_add) private returns (uint tokens, uint tokens_bonus) {

        // BK Ok
        tokens = _tokens_to_add;
        // BK Ok
        uint balance = balances[_account].sub(balancesBonus[_account]).sub(balancesMinted[_account]);
        // BK Ok
        uint balance_exp = balance.add(tokens);
        // BK Ok
        uint limit = whitelistLimit[_account];
        // BK Ok
        uint threshold = whitelistThreshold[_account];

        // if limit and/or threshold are > 0, adjustments may be necessary

        // BK Ok
        if ((limit > 0 && threshold == 0) || (limit > 0 && threshold > 0 && balance_exp < threshold)) {
            // BK Ok
            if (balance >= limit) {
                // BK Ok
                tokens = 0;
            // BK Ok
            } else if (tokens > limit.sub(balance)) {
                // BK Ok
                tokens = limit.sub(balance);
            }            
        // BK Ok
        } else if (limit == 0 && threshold > 0) {
            // BK Ok
            if (balance_exp < threshold) tokens = 0;
        }

        // update balances and lock tokens if necessary

        // BK Ok
        if (tokens > 0) {
            // bonus tokens
            // BK Next 2 Ok
            tokens_bonus = getBonus(tokens);
            uint tokens_issued = tokens.add(tokens_bonus);
            
            // update balances and totals
            // BK Next 5 Ok
            balances[_account] = balances[_account].add(tokens_issued);
            balancesBonus[_account] = balancesBonus[_account].add(tokens_bonus);
            tokensIssuedTotal = tokensIssuedTotal.add(tokens_issued);
            tokensIcoIssued = tokensIcoIssued.add(tokens);
            tokensIcoBonus = tokensIcoBonus.add(tokens_bonus);

            // token locking
            // BK Ok
            uint tokens_crowdsale = balances[_account].sub(balancesMinted[_account]);
            // BK Ok
            if (threshold > 0 && tokens_crowdsale >= threshold) {
                // BK Ok
                setIcoLock(_account, whitelistLockDate[_account], tokens_crowdsale);
            }
        }
    }

    // Cancel or Reclaim pending contributions ------------

    // blacklisting results in returning pending contributions

    // BK Ok - Internal function
    function processBlacklisting(address _account) internal {
        // BK Ok
        require(atNow() <= dateIcoDeadline);
        // BK Ok
        pRevertPending(_account);
    }

    // Admin can cancel pending contributions anytime

    // BK Ok - Only admin can execute
    function cancelPending(address _account) public onlyAdmin {
        // BK Ok
        pRevertPending(_account);
    }

    // BK Ok - Only admin can execute
    function cancelPendingMultiple(address[] _accounts) public onlyAdmin {
        // BK Ok
        for (uint i = 0; i < _accounts.length; i++) {
            // BK Ok
            pRevertPending(_accounts[i]);
        }
    }

    // Contributor reclaims pending contribution after deadline (successful ICO)

    // BK Ok
    function reclaimPending() public {
        // BK Ok
        require(thresholdReached() && atNow() > dateIcoDeadline);
        // BK Ok
        pRevertPending(msg.sender);
    }

    // private revert function for pending

    // BK Ok - Private function
    function pRevertPending(address _account) private {
        // nothing to do if there are no pending tokens
        // BK Ok
        if (balancesPending[_account] == 0) return;

        // tokens
        // BK Next 4 Ok
        uint tokens_to_cancel = balancesPending[_account];
        balancesPending[_account] = 0;
        balancesPendingOffline[_account] = 0;
        tokensIcoPending = tokensIcoPending.sub(tokens_to_cancel);

        //eth
        // BK Next 4 Ok
        uint eth_to_return = ethPending[_account];
        ethPending[_account] = 0;
        totalEthPending = totalEthPending.sub(eth_to_return);
        if (eth_to_return > 0) { _account.transfer(eth_to_return); }

        // log
        // BK Ok - Log event
        emit RevertPending(_account, tokens_to_cancel, eth_to_return, tokensIcoPending, totalEthPending);
    }

    // Refunds in case of failed ICO ----------------------

    // BK Ok - Any account can reclaim their own ETH
    function reclaimEth() public {
        // BK Ok
        pReclaimEth(msg.sender);
    }

    // BK Ok - Only the admin can execute the reclaim ETH function on behalf of another account
    function reclaimEthAdmin(address _account) public onlyAdmin {
        // BK Ok
        pReclaimEth(_account);
    }

    // BK Ok - Only the admin can execute the reclaim ETH function on behalf of multiple account
    function reclaimEthAdminMultiple(address[] _accounts) public onlyAdmin {
        // BK Ok
        for (uint i = 0; i < _accounts.length; i++) {
            // BK Ok
            pReclaimEth(_accounts[i]);
        }
    }

    // BK Ok - Private function
    function pReclaimEth(address _account) private {
        // BK Next 3 Ok
        require(!thresholdReached() && atNow() > dateIcoDeadline, "too early");
        require(ethPending[_account] > 0 || ethContributed[_account] > 0, "nothing to return");
        require(!refundClaimed[_account], "refund already claimed");

        // return eth (no balances are modified)
        // BK Ok
        uint eth_to_return = ethPending[_account].add(ethContributed[_account]);
        // BK Ok
        refundClaimed[_account] = true;
        // BK Ok
        if (eth_to_return > 0) { _account.transfer(eth_to_return); }
        // BK Ok - Log event
        emit RefundFailedIco(_account, eth_to_return);
    }

    // ERC20 functions ------------------------------------

    // Transfer out any accidentally sent ERC20 tokens

    // BK Ok - Only the owner can execute to transfer any ERC20 tokens owned by this sale/token contract
    function transferAnyERC20Token(address tokenAddress, uint amount) public onlyOwner returns (bool success) {
        // BK Ok
        return ERC20Interface(tokenAddress).transfer(owner, amount);
    }

    // Override "transfer"

    // BK Ok - Any account can transfer their own tokens if threshold reached and after the crowdsale ends
    function transfer(address _to, uint _amount) public returns (bool success) {
        // BK Ok
        require(tradeable());
        // BK Ok
        require(_amount <= unlockedTokensInternal(msg.sender));
        // BK Ok
        return super.transfer(_to, _amount);
    }

    // Override "transferFrom"

    // BK Ok - Any account can transfer `from` account's tokens if threshold reached and after the crowdsale ends, and `from` account has approve(...)-d the spending
    function transferFrom(address _from, address _to, uint _amount) public returns (bool success) {
        // BK Ok
        require(tradeable());
        // BK Ok
        require(_amount <= unlockedTokensInternal(_from));
        // BK Ok 
        return super.transferFrom(_from, _to, _amount);
    }

    // Multiple token transfers from one address to save gas

    // BK Ok - Any account can transfer their own tokens to multiple destination account
    function transferMultiple(address[] _addresses, uint[] _amounts) external {
        // BK Ok
        require(tradeable());
        // BK Ok
        require(_addresses.length <= 100);
        // BK Ok
        require(_addresses.length == _amounts.length);

        // check token amounts
        uint tokens_to_transfer = 0;
        // BK Ok
        for (uint i = 0; i < _addresses.length; i++) {
            // BK Ok
            tokens_to_transfer = tokens_to_transfer.add(_amounts[i]);
        }
        // BK Ok
        require(tokens_to_transfer <= unlockedTokensInternal(msg.sender));

        // do the transfers
        // BK Ok
        for (i = 0; i < _addresses.length; i++) {
            // BK Ok
            super.transfer(_addresses[i], _amounts[i]);
        }
    }

}
```
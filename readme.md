# Kipu Bank - Smart Contract

Smart contract for a decentralized banking system developed in Solidity.

## 📋 Overview

Kipu Bank is a smart contract that allows users to deposit and withdraw Ether with configurable limits. The contract implements protections against reentrancy and manages transaction and deposit limits.

## 🛠️ Features

### Main Features
- **Deposit**: Users can deposit Ether into the contract
- **Withdraw**: Users can withdraw their available balance
- **Transaction Limits**: Configurable limit per individual transaction
- **Total Deposit Limit**: Configurable limit for the contract's total balance
- **Reentrancy Protection**: `nonReentrant` modifier to prevent attacks
- **Counters**: Tracks deposits and withdrawals

### Read Functions
- `get_owner()`: Returns the contract owner's address
- `get_balance()`: Returns the caller's balance
- `get_deposit_limit()`: Returns the total deposit limit
- `get_transaction_limit()`: Returns the transaction limit
- `get_counter_deposit()`: Returns the total number of deposits
- `get_counter_withdraw()`: Returns the total number of withdrawals

## 🔧 How It Works

### Constructor

```solidity
constructor(uint256 _deposit_limit, uint256 _transaction_limit)
```

Sets the contract limits:
- `_deposit_limit`: Maximum total Ether the contract can store (in wei)
- `_transaction_limit`: Maximum limit per individual deposit (in wei)

**Note**: Values are multiplied by `1e18` in the constructor, so pass values in Ether units.

### deposit() Function

```solidity
function deposit() external payable AmountNotZero(msg.value)
    nonReentrant
    MaxTransactionLimitVerify
    MaxDepositLimitVerify
```

Allows users to deposit Ether into the contract.

**Validations**:
- Value must be greater than zero
- Value cannot exceed the transaction limit
- Total contract balance cannot exceed the deposit limit
- Reentrancy protection

**Emits event**: `Deposit(address indexed addr, uint256 amount)`

### withdraw() Function

```solidity
function withdraw(uint256 _amount) public
    nonReentrant
    AddressNotZeroVerify(msg.sender)
    AmountNotZero(_amount)
    BalanceCheck(_amount)
```

Allows users to withdraw their balance.

**Validations**:
- Caller address cannot be zero
- Amount must be greater than zero
- User must have sufficient balance
- Reentrancy protection

**Emits event**: `Withdraw(address indexed addr, uint256 amount)`

## 🔒 Security Modifiers

### nonReentrant
Protects against reentrancy attacks using a boolean `locked` variable.

### AmountNotZero
Ensures values are not zero.

### MaxTransactionLimitVerify
Validates that the transaction value does not exceed the configured limit.

### MaxDepositLimitVerify
Validates that the total contract balance does not exceed the deposit limit.

### AddressNotZeroVerify
Validates that an address is not the zero address.

### BalanceCheck
Checks if the user has sufficient balance for withdrawal.

## ⚠️ Custom Errors

- `NotZeroValue()`: Thrown when a zero value is sent
- `TransactionLimitReached()`: Transaction limit exceeded
- `DepositLimitReached()`: Total deposit limit exceeded
- `NotAuthorized()`: Reentrancy attempt detected
- `InsufficientBalance()`: Insufficient balance for withdrawal
- `AddressNotZero()`: Zero address detected

## 📊 Events

### Deposit
```solidity
event Deposit(address indexed addr, uint256 amount);
```
Emitted when a deposit is made.

### Withdraw
```solidity
event Withdraw(address indexed addr, uint256 amount);
```
Emitted when a withdrawal is made.

# Flash Loan Arbitrage Executor

A high-performance, flat-structured Flash Loan integration using Aave V3. This repository provides a professional template for executing risk-free (minus gas) arbitrage across decentralized exchanges.

## Features
* **Aave V3 Integration:** Optimized for the latest "Pool" contract standards.
* **Atomic Execution:** Entire logic (borrow, trade, repay) happens in one transaction.
* **Slippage Protection:** Built-in checks to revert the transaction if the arbitrage is no longer profitable.
* **Flat Architecture:** No complex directory nesting; direct access to logic and configuration.

## Workflow
1. **Request:** Call `requestFlashLoan` with the asset and amount.
2. **Execute:** Aave transfers funds to this contract and calls `executeOperation`.
3. **Arbitrage:** Inside `executeOperation`, logic swaps Asset A for Asset B on DEX 1, then back to Asset A on DEX 2.
4. **Repay:** The contract automatically returns the loan plus the premium to Aave.

## Requirements
* Access to an RPC node (Mainnet, Polygon, or Arbitrum recommended).
* Aave V3 Pool addresses for your specific network.

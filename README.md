# 🏦 DeFi Stablecoin Protocol

> A professional, production-ready decentralized stablecoin system built with Solidity and Foundry

[![Foundry](https://img.shields.io/badge/Foundry-v0.2.0-FF6B01?logo=ethereum)](https://getfoundry.sh/)
[![Solidity](https://img.shields.io/badge/Solidity-^0.8.19-363636?logo=solidity)](https://soliditylang.org/)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Tests](https://img.shields.io/badge/Tests-Passing-brightgreen)](https://github.com/Cyfrin/foundry-defi-stablecoin-cu/actions)

## 📖 Overview

A sophisticated decentralized stablecoin protocol that enables users to mint a USD-pegged stablecoin (DSC) by over-collateralizing with approved assets like WETH and WBTC. This implementation includes advanced features such as liquidation mechanisms, price oracle integration, and comprehensive test coverage.

### 🎯 Key Features

- **💵 Multi-Collateral Support**: Backed by WETH and WBTC with extensible architecture
- **🛡️ Over-Collateralization**: Minimum 150% collateral ratio for system safety
- **⚡ Automated Liquidations**: Protects protocol solvency via efficient liquidation engine
- **🔗 Oracle Integration**: Secure price feeds via Chainlink oracles
- **📊 Health Factor Monitoring**: Real-time position health tracking
- **🎯 Zero Interest Borrowing**: No recurring interest fees on minted DSC

## 🏗️ System Architecture

### Core Contracts

| Contract | Description | File |
|----------|-------------|------|
| **DecentralizedStableCoin** | ERC20 stablecoin implementation with mint/burn controls | [`DecentralizedStableCoin.sol`](src/DecentralizedStableCoin.sol) |
| **DSCEngine** | Core protocol engine handling collateral, minting, and liquidation | [`DSCEngine.sol`](src/DSCEngine.sol) |
| **OracleLib** | Safe price feed interactions with staleness checks | [`OracleLib.sol`](src/libraries/OracleLib.sol) |

### Key Mechanisms

```
User Flow:
1. Deposit Collateral (WETH/WBTC) → 2. Mint DSC → 3. Maintain Health Factor → 4. Burn DSC to Redeem

Liquidation Flow:
Health Factor < 1 → Liquidators can repay debt → Receive collateral at discount
```

## 🚀 Quick Start

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation) (version 0.2.0 or later)
- [Node.js](https://nodejs.org/) (v16 or later)
- Git

### Installation & Setup

```bash
# Clone repository
git clone https://github.com/BELALZEDAN/Decentralized-StableCoin.git
cd Decentralized-StableCoin

# Install dependencies
forge install

# Build contracts
forge build
```

### Testing

```bash
# Run all tests
forge test

# Run with verbose output
forge test -vvv

# Run specific test contract
forge test --match-contract DSCEngineTest

# Run gas snapshots
forge snapshot
```

### Deployment

```bash
# Deploy to local Anvil network
make deploy

# Deploy to Sepolia testnet
make deploy ARGS="--network sepolia"

# Verify on Etherscan
forge script script/DeployDSC.s.sol:DeployDSC --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## 📁 Project Structure

```
foundry-defi-stablecoin/
├── src/                          # Source contracts
│   ├── DecentralizedStableCoin.sol
│   ├── DSCEngine.sol
│   └── libraries/
│       └── OracleLib.sol
├── script/                       # Deployment scripts
│   └── DeployDSC.s.sol
├── test/                         # Comprehensive test suite
│   ├── DSCEngine.t.sol
│   └── mocks/
│       ├── MockV3Aggregator.sol
│       └── MockWETH.sol
├── lib/                          # Dependencies
├── .github/                      # CI/CD workflows
├── Makefile                      # Development tasks
└── foundry.toml                  # Foundry configuration
```

## 🔧 Development

### Available Commands

```bash
# Build & Test
make build    # Compile contracts
make test     # Run test suite
make coverage # Generate coverage report
make snapshot # Create gas snapshots

# Code Quality
make format   # Format code with forge fmt
make lint     # Lint code (if configured)

# Local Development
make anvil    # Start local Anvil instance
make deploy   # Deploy to local network

# Deployment
make deploy ARGS="--network sepolia"  # Deploy to testnet
```

### Local Development Setup

1. **Start Local Node**:
   ```bash
   make anvil
   ```

2. **Deploy Contracts**:
   ```bash
   make deploy
   ```

3. **Run Tests**:
   ```bash
   make test
   ```

## 🧪 Testing Strategy

Our comprehensive test suite ensures protocol security and reliability:

### Test Categories

- **✅ Unit Tests**: Individual component testing
- **✅ Integration Tests**: Contract interaction testing
- **✅ Fuzz Tests**: Edge case discovery via random inputs
- **✅ Invariant Tests**: System property validation
- **✅ Fork Tests**: Mainnet state integration testing

### Key Test Scenarios

```solidity
// Example test structure
contract DSCEngineTest is Test {
    function test_DepositCollateralAndMintDSC() public;
    function test_RevertsIfMintedDSCBreaksHealthFactor() public;
    function test_LiquidatesWhenHealthFactorBelowOne() public;
    function test_PriceFeedRevertsShouldRevert() public;
}
```

Run specific test suites:
```bash
forge test --match-test test_DepositCollateral
forge test --match-test test_Liquidation
```

## 📊 Protocol Specifications

### Collateral Parameters

| Parameter | Value | Description |
|-----------|-------|-------------|
| **Minimum Collateral Ratio** | 150% | Minimum value of collateral to mint DSC |
| **Liquidation Threshold** | 100% | Health factor level triggering liquidation |
| **Liquidation Bonus** | 10% | Incentive for liquidators |
| **Supported Assets** | WETH, WBTC | Initial collateral tokens |

### Health Factor Calculation

```
Health Factor = (Total Collateral Value × Liquidation Threshold) / Total DSC Minted
```

### Price Feed Configuration

- **WETH/USD**: Chainlink Price Feed
- **WBTC/USD**: Chainlink Price Feed  
- **Staleness Threshold**: 3 hours

## 🔒 Security Considerations

### Audited Dependencies
- OpenZeppelin Contracts (v4.8.3)
- Chainlink Price Feeds
- Solidity 0.8.19 with built-in overflow protection

### Security Features
- Reentrancy protection on all state-changing functions
- Price feed staleness checks
- Minimum health factor enforcement
- Comprehensive event emission for off-chain monitoring

## 🌐 Deployment

### Network Configuration

```bash
# Environment Setup
cp .env.example .env
# Add your keys:
# SEPOLIA_RPC_URL=https://...
# PRIVATE_KEY=0x...
# ETHERSCAN_API_KEY=...

# Deploy to networks
make deploy ARGS="--network sepolia"    # Sepolia testnet
make deploy ARGS="--network mainnet"    # Mainnet (use with caution)
```

### Verification

```bash
forge script script/DeployDSC.s.sol:DeployDSC \
  --rpc-url $SEPOLIA_RPC_URL \
  --private-key $PRIVATE_KEY \
  --broadcast \
  --verify \
  -vvvv
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](.github/CONTRIBUTING.md) for details.

### Development Workflow

1. **Fork** the repository
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit changes**: `git commit -m 'feat: add amazing feature'`
4. **Push to branch**: `git push origin feature/amazing-feature`
5. **Open a Pull Request**

### Code Standards

- Follow Solidity style guide
- Write comprehensive tests for new features
- Update documentation accordingly
- Ensure all tests pass before submitting PR

## 📚 Documentation

- [Technical Specification](docs/SPECIFICATION.md)
- [API Reference](docs/API.md)
- [Deployment Guide](docs/DEPLOYMENT.md)
- [Security Audit](docs/SECURITY.md)

## 🐛 Troubleshooting

Common issues and solutions:

**Issue**: `Error: Failed to deploy contract`
**Solution**: Ensure sufficient gas and valid RPC URL

**Issue**: `Error: Price feed stale`
**Solution**: Check Chainlink price feed address and network

**Issue**: `Error: Insufficient collateral`
**Solution**: Verify collateral ratio meets minimum 150%

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [Cyfrin](https://www.cyfrin.io/) for the original implementation
- [Chainlink](https://chain.link/) for price oracle infrastructure
- [OpenZeppelin](https://openzeppelin.com/) for secure contract libraries

---

<div align="center">

**Built with 🔥 by the DeFi community**

*For educational purposes. Always audit code before production use.*

</div>
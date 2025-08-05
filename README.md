# 🪙 MySelfToken (MST)

A simple, fixed-supply ERC20 token written in Solidity without using OpenZeppelin or any third-party libraries. Built and tested using Foundry and deployed to the Arbitrum Sepolia testnet.

---

## ✨ Features

- ✅ Fixed total supply (no mint/burn functions)  
- ✅ Written entirely from scratch (no external libraries)  
- ✅ Fully tested using [Foundry](https://book.getfoundry.sh/)  
- ✅ 100% test coverage on the core contract  
- ✅ Deployment script using Foundry Scripts  
- ✅ Token successfully imported into MetaMask after deployment  

---

## 📄 Contract Details

- **Name:** MySelfToken  
- **Symbol:** MST  
- **Decimals:** 18  
- **Total Supply:** 10,000,000 MST  
- **Standard:** ERC20 (custom implementation)

---

## 🧱 Project Structure

```
├── src/
│   └── MySelfTokenERC20.sol           # ERC20 contract
├── script/
│   └── DeployMySelfTokenERC20.s.sol   # Deployment script
├── test/
│   └── MySelfTokenERC20Test.t.sol     # Unit tests
├── foundry.toml
└── README.md
```

---

## ⚒️ Setup & Installation

1. **Clone the repo:**
   ```bash
   git clone https://github.com/VinayVig7/Self-Project-ERC20-Token
.git
   cd MySelfToken
   ```

2. **Install Foundry (if not already):**
   ```bash
   curl -L https://foundry.paradigm.xyz | bash
   foundryup
   ```

## 🚀 Deploying to Arbitrum Sepolia

Update your `.env` file or use environment variables for private key and RPC:

```bash
forge script script/DeployMySelfTokenERC20.s.sol \
    --rpc-url $ARBITRUM_SEPOLIA_RPC \
    --private-key $PRIVATE_KEY \
    --broadcast \
    --verify
```

---

## 🧪 Running Tests

```bash
forge test
```

To check coverage:
```bash
forge coverage
```


## 👛 Importing into MetaMask

After deploying, you can add the token to MetaMask manually using:

- Contract address: `0x1CDA6b5aec32158c775c6034D07F128918dc6286`
- Token symbol: `MST`
- Decimals: `18`

---

## 🧠 Learned in This Project

- Writing a complete ERC20 token from scratch  
- How `startBroadcast()` differs from `prank()` in Foundry  
- Using Foundry's scripting for real network deployment  
- Managing contract ownership and testing with multiple users  
- Understanding how Forge coverage works (scripts excluded)

---

## 🧾 License

This project is licensed under the MIT License.

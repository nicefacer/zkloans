# Quick Start - Deploying zkLoans to NEAR Testnet

## Prerequisites
- Node.js and npm installed
- NEAR CLI installed (`npm install -g near-cli`)
- A NEAR testnet account

## Deploy Steps

### 1. Build the Contract
```bash
npm run build:contract
```

This will compile the Rust smart contract to WASM.

### 2. Deploy to Testnet
```bash
npm run deploy
```

This will:
- Build the contract (if not already built)
- Deploy to a new testnet dev account
- Display the contract account ID

### 3. Test the Contract

After deployment, you can test the contract methods:

#### Initialize (if needed)
```bash
near call <CONTRACT_ID> new --accountId <YOUR_ACCOUNT>
```

#### Get your loan status
```bash
near view <CONTRACT_ID> get_status --accountId <YOUR_ACCOUNT>
```

#### Submit a ZK proof for loan verification
```bash
near call <CONTRACT_ID> verify '{"proof_str": "<PROOF_JSON>", "public_inputs_str": "<INPUTS_JSON>"}' --accountId <YOUR_ACCOUNT>
```

#### Get all loans
```bash
near view <CONTRACT_ID> get_loans
```

#### Evict an account
```bash
near call <CONTRACT_ID> evict '{"account_id": "<ACCOUNT>"}' --accountId <YOUR_ACCOUNT>
```

## Running the Frontend

Once deployed, update the frontend configuration with your contract ID:

1. Edit `frontend/near-config.js` with your contract ID
2. Run the frontend:
```bash
npm start
```

## Testing

### Run Unit Tests
```bash
npm run test:unit
```

### Run Integration Tests
```bash
npm run test:integration
```

## Troubleshooting

### Contract call errors
- Make sure you've initialized the contract with `new`
- Check that you're using the correct account ID
- Verify the NEAR account has enough balance for gas

### Build errors
- Ensure you have the latest Rust toolchain: `rustup update`
- Make sure rust-src is installed: `rustup component add rust-src`
- Try cleaning and rebuilding: `cd contract && cargo clean && cd .. && npm run build:contract`

### PATH issues on Windows
- The build script automatically handles PATH configuration
- If you need to build manually, use: 
  ```powershell
  $env:PATH = "C:\Users\onech\.rustup\toolchains\stable-x86_64-pc-windows-msvc\bin;$env:PATH"
  cd contract
  cargo build --target wasm32-unknown-unknown --release
  ```

## Contract Size

- WASM file size: ~328 KB
- Location: `contract/target/wasm32-unknown-unknown/release/zkloans.wasm`

## Next Steps

1. Generate ZK proofs using the prover service
2. Test proof verification on testnet
3. Connect the frontend to your deployed contract
4. Test the complete loan application flow with ZK proofs

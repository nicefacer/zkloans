# ZKLoans Contract - Deployment Fixes

## Issues Fixed

### 1. **Rust Toolchain Conflict**
**Problem:** Two Rust installations were present - one from rustup and one standalone installation. The standalone version at `C:\Program Files\Rust stable MSVC 1.91` was taking precedence and didn't have proper WASM compilation support.

**Solution:** Modified build scripts to explicitly use the rustup-managed toolchain by prepending its bin directory to PATH:
```
C:\Users\onech\.rustup\toolchains\stable-x86_64-pc-windows-msvc\bin
```

### 2. **Missing rust-src Component**
**Problem:** WASM compilation failed with "can't find crate for `core`" error.

**Solution:** Installed the rust-src component:
```powershell
rustup component add rust-src
```

### 3. **Removed thiserror Dependency**
**Problem:** `thiserror` crate doesn't work well in WASM/no_std environments and was causing issues.

**Solution:**
- Removed `thiserror = "1.0"` from Cargo.toml
- Replaced `#[derive(Error)]` with manual `Display` and `std::error::Error` trait implementations for `VerifierError`

### 4. **Missing ContractState Trait Implementation**
**Problem:** Contract compilation failed with "the trait bound `Contract: ContractState` is not satisfied".

**Solution:** Added manual empty trait implementation:
```rust
impl near_sdk::state::ContractState for Contract {}
```

This is required when using `#[near_bindgen]` on both the struct and impl block.

### 5. **Multiple #[near_bindgen] impl Blocks**
**Problem:** The contract had `#[near_bindgen]` on an impl block in both `lib.rs` and `views.rs`, which caused conflicts.

**Solution:**
- Removed the `#[near_bindgen]` attribute from the impl block in `views.rs`
- Moved the `get_loans()` method from `views.rs` into the main impl block in `lib.rs`
- Kept `views.rs` only for type definitions (the `LoanStatus` struct)

### 6. **Test Code Issues**
**Problem:** Tests were using `Contract::default()` which conflicts with `PanicOnDefault`, and had type inference issues.

**Solution:**
- Replaced all `Contract::default()` calls with `Contract::new()` in tests
- Added type annotation `.parse::<AccountId>()` where needed
- Fixed iterator mapping to clone values: `.iter().map(|(k, v)| (k.clone(), *v)).collect()`

### 7. **Test Execution Configuration**
**Problem:** NEAR SDK 5.20.1 requires special feature flags for running tests.

**Solution:** Updated test command to include the `unit-testing` feature:
```bash
cargo test --features near-sdk/unit-testing
```

## Changes Made to Files

### contract/src/lib.rs
- Added `PanicOnDefault` import back
- Added `impl near_sdk::state::ContractState for Contract {}`
- Moved `get_loans()` method from views.rs
- Fixed all test code to use `Contract::new()` instead of `Contract::default()`
- Fixed test type annotations

### contract/src/views.rs
- Removed `#[near_bindgen] impl Contract` block
- Now only contains the `LoanStatus` struct definition

### contract/src/verifier.rs
- Removed `thiserror` import
- Added manual `Display` implementation for `VerifierError`
- Added `std::error::Error` trait implementation

### contract/Cargo.toml
- Removed `thiserror = "1.0"` dependency

### package.json
- Updated `build:contract` script to use PowerShell build script
- Updated `test:unit` script to use correct PATH and feature flags

### New file: build-contract.ps1
- Created PowerShell build script that sets correct PATH to rustup toolchain
- Provides clear build success/failure messages

## How to Build and Deploy

### Build the contract:
```bash
npm run build:contract
```

### Run tests:
```bash
npm run test:unit
```

### Deploy to testnet:
```bash
npm run deploy
```

### Build from contract directory directly:
```powershell
# From zkloans/contract directory:
$env:PATH = "C:\Users\onech\.rustup\toolchains\stable-x86_64-pc-windows-msvc\bin;$env:PATH"
cargo build --target wasm32-unknown-unknown --release
```

## Verification

All 17 unit tests now pass successfully:
- ✓ Contract compilation succeeds
- ✓ WASM output generated at `contract/target/wasm32-unknown-unknown/release/zkloans.wasm`
- ✓ All unit tests pass (17/17)
- ✓ Contract is ready for testnet deployment

## Next Steps

The contract is now fixed and ready for deployment. You can:
1. Deploy to testnet using `npm run deploy`
2. Test contract methods through NEAR CLI or frontend
3. Verify ZK-SNARK proof verification works correctly on testnet

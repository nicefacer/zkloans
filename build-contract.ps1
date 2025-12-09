# Build script for NEAR contract
# This ensures the rustup-managed Rust toolchain is used

$ErrorActionPreference = "Stop"

# Set PATH to use rustup-managed toolchain
$env:PATH = "C:\Users\onech\.rustup\toolchains\stable-x86_64-pc-windows-msvc\bin;$env:PATH"

# Navigate to contract directory
Set-Location contract

# Build the contract
Write-Host "Building NEAR contract..." -ForegroundColor Green
cargo build --target wasm32-unknown-unknown --release

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Contract built successfully!" -ForegroundColor Green
    Write-Host "  Output: contract/target/wasm32-unknown-unknown/release/zkloans.wasm" -ForegroundColor Cyan
} else {
    Write-Host "✗ Build failed" -ForegroundColor Red
    exit 1
}

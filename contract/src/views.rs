use near_sdk::serde::Serialize;

use crate::*;

#[derive(BorshDeserialize, BorshSerialize, Serialize)]
#[serde(crate = "near_sdk::serde")]
pub struct LoanStatus {
    pub account_id: AccountId,
    pub approved: bool,
}

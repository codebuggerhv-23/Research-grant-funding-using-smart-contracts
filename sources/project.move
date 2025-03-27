module MyModule::GrantFunding {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    struct Grant has store, key {
        total_funds: u64,
        required_funds: u64,
    }

    public fun create_grant(owner: &signer, required_funds: u64) {
        let grant = Grant {
            total_funds: 0,
            required_funds,
        };
        move_to(owner, grant);
    }

    public fun fund_grant(donor: &signer, grant_owner: address, amount: u64) acquires Grant {
        let grant = borrow_global_mut<Grant>(grant_owner);
        let donation = coin::withdraw<AptosCoin>(donor, amount);
        coin::deposit<AptosCoin>(grant_owner, donation);
        grant.total_funds = grant.total_funds + amount;
    }
}

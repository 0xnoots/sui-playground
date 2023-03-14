module openrails::noot {
    use sui::coin::{Self, TreasuryCap};
    use sui::transfer;
    use sui::tx_context::{Self, TxContext};

    /// Name of the coin
    struct TRUSTED_COIN has drop {}

    /// Register the trusted currency to acquire its `TreasuryCap`. Because
    /// this is a module initializer, it ensures the currency only gets
    /// registered once.
    fun init(witness: TRUSTED_COIN, ctx: &mut TxContext) {
        // Get a treasury cap for the coin and give it to the transaction
        // sender
        let treasury_cap = coin::create_currency<TRUSTED_COIN>(witness, ctx);
        transfer::transfer(treasury_cap, tx_context::sender(ctx))
    }

    public entry fun mint(treasury_cap: &mut TreasuryCap<TRUSTED_COIN>, amount: u64, ctx: &mut TxContext) {
        let coin = coin::mint<TRUSTED_COIN>(treasury_cap, amount, ctx);
        transfer::transfer(coin, tx_context::sender(ctx));
    }

    public entry fun transfer(treasury_cap: TreasuryCap<TRUSTED_COIN>, recipient: address) {
        transfer::transfer(treasury_cap, recipient);
    }
}
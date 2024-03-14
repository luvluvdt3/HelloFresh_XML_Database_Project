package fr.univcotedazur.hellofresh.model;

public enum PriceType {
    _NORMAL_PRICE_TYPE("normal", 11.49),
    _PRIME_PRICE_TYPE("prime", 13.99),
    _LUXURY_PRICE_TYPE("luxury", 15.99);

    private final String type;
    private final double value;

    PriceType(String type, double value) {
        this.type = type;
        this.value = value;
    }

    public String getType() {
        return type;
    }

    public double getValue() {
        return value;
    }
}

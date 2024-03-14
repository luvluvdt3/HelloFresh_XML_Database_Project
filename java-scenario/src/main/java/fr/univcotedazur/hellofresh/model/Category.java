package fr.univcotedazur.hellofresh.model;

public enum Category {
    _MOST_RECENT_CATEGORY("Most Recent", "particular"),
    _HALL_OF_FAME_CATEGORY("Hall of Fame", "particular"),
    _KID_FRIENDLY_CATEGORY("Kid-Friendly", "particular"),
    _QUICK_MEALS_FOR_BUSY_NIGHTS_CATEGORY("Quick Meals for Busy Nights", "particular"),
    _AMERICAN_CATEGORY("American", "culture"),
    _ITALIAN_CATEGORY("Italian", "culture"),
    _ASIAN_CATEGORY("Asian", "culture"),
    _MEDITERRANEAN_CATEGORY("Mediterranean", "culture"),
    _MEXICAN_CATEGORY("Mexican", "culture"),
    _KOREAN_CATEGORY("Korean", "culture"),
    _INDIAN_CATEGORY("Indian", "culture"),
    _LATIN_AMERICAN_CATEGORY("Latin American", "culture"),
    _CHINESE_CATEGORY("Chinese", "culture"),
    _SPANISH_CATEGORY("Spanish", "culture"),
    _JAPANESE_CATEGORY("Japanese", "culture"),
    _THAI_CATEGORY("Thai", "culture"),
    _FRENCH_CATEGORY("French", "culture"),
    _AFRICAN_CATEGORY("African", "culture"),
    _MIDDLE_EASTERN_CATEGORY("Middle Eastern", "culture"),
    _VIETNAMESE_CATEGORY("Vietnamese", "culture"),
    _TACO_CATEGORY("Taco", "dish"),
    _BURGER_CATEGORY("Burger", "dish"),
    _PASTAS_CATEGORY("Pastas", "dish"),
    _BOWL_CATEGORY("Bowl", "dish"),
    _FLATBREAD_CATEGORY("Flatbread", "dish"),
    _STIR_FRY_CATEGORY("Stir-Fry", "dish"),
    _MEATBALL_CATEGORY("Meatball", "dish"),
    _RISOTTO_CATEGORY("Risotto", "dish"),
    _SOUP_CATEGORY("Soup", "dish"),
    _QUESADILLA_CATEGORY("Quesadilla", "dish"),
    _STEAK_CATEGORY("Steak", "dish"),
    _MEAT_VEGGIE_CATEGORY("Meat & Veggie", "plan"),
    _VEGGIE_CATEGORY("Veggie", "plan"),
    _FAMILY_FRIENDLY_CATEGORY("Family Friendly", "plan"),
    _FIT_WHOLESOME_CATEGORY("Fit & Wholesome", "plan"),
    _QUICK_EASY_CATEGORY("Quick & Easy", "plan"),
    _PESCATARIAN_CATEGORY("Pescatarian", "plan");

    private final String category;
    private final String type;

    Category(String category, String type) {
        this.category = category;
        this.type = type;
    }

    public String getCategory() {
        return category;
    }

    public String getType() {
        return type;
    }
}

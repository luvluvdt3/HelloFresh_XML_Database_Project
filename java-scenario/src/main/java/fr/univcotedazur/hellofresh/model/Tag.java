package fr.univcotedazur.hellofresh.model;

public enum Tag {
    _GLUTEN_FREE_TAG("Gluten-free"),
    _PROTEIN_SMART_TAG("Protein Smart"),
    _EASY_PREP_TAG("Easy Prep"),
    _QUICK_TAG("Quick"),
    _CALORIE_SMART_TAG("Calorie Smart"),
    _VEGGIE_TAG("Veggie"),
    _SEASONAL_TAG("Seasonal"),
    _VEGETARIAN_TAG("Vegetarian"),
    _NEW_TAG("New"),
    _MULTI_PORTION_TAG("Multi-Portion"),
    _CARB_SMART_TAG("Carb Smart");

    private final String name;

    Tag(String name) {
        this.name = name;
    }

    public String getName() {
        return name;
    }
}

package fr.univcotedazur.hellofresh.model;

import java.io.Serializable;

public enum Nutrition implements Serializable {
    _ENERGYKJ("energy","kJ"),
    _CALORIES("calories","kcal"),
    _FAT("fat","g"),
    _SATURATED_FAT("saturated fat","g"),
    _CARBOHYDRATE("carbohydrate","g"),
    _SUGAR("sugar","g"),
    _DIETARY_FIBER("dietary fiber","g"),
    _PROTEIN("protein","g"),
    _CHOLESTEROL("cholesterol","g"),
    _SODIUM("sodium","g");

    private final String unit;
    private final String name;

    Nutrition(String name, String unit) {
        this.name = name;
        this.unit = unit;
    }

    public String getUnit() {
        return unit;
    }

    public String getName() {
        return name;
    }
}

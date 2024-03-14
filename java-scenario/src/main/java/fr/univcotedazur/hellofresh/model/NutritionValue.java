package fr.univcotedazur.hellofresh.model;

import java.io.Serializable;
import java.util.Objects;

public record NutritionValue(double value, Nutrition nutrition) implements Serializable, Comparable<NutritionValue> {

    @Override
    public String toString() {
        return nutrition.getName().toLowerCase() + " = " + value + " " + nutrition.getUnit();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        NutritionValue that = (NutritionValue) o;
        return Double.compare(value, that.value) == 0 && nutrition == that.nutrition;
    }

    @Override
    public int hashCode() {
        return Objects.hash(nutrition, value);
    }

    @Override
    public int compareTo(NutritionValue o) {
        return Double.compare(this.value, o.value);
    }
}

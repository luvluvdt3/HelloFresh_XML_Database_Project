package fr.univcotedazur.hellofresh.model;

import java.io.Serializable;
import java.util.Set;

public class DietParsingModel implements Serializable {

    public static final int MEASUREMENT_ERROR_PERCENT = 5;
    private Set<NutritionValue> diet;

    public DietParsingModel(Set<NutritionValue> diet) {
        this.diet = diet;
    }

    public DietParsingModel() {
    }

    public Set<NutritionValue> getDiet() {
        return diet;
    }

    public void setDiet(Set<NutritionValue> diet) {
        this.diet = diet;
    }

    public boolean isBalanced(Set<NutritionValue> nutritions) {
        for (NutritionValue nutrition : diet) {
            for (NutritionValue nutritionValue : nutritions) {
                if (nutrition.nutrition() == nutritionValue.nutrition()) {
                    if (Math.abs(nutrition.value() - nutritionValue.value()) > nutrition.value() * MEASUREMENT_ERROR_PERCENT / 100) {
                        return false;
                    }
                }
            }
        }
        return true;
    }
}

package fr.univcotedazur.hellofresh.model;

import java.util.Set;

public class Meal {
    private final String id;
    private final String name;
    private final String description;
    private final String headline;
    private final String imageSrc;
    private final Set<Tag> tags;
    private final Set<Category> categories;
    private final PriceType priceType;
    private final Set<NutritionValue> nutritionalValues;

    private final double averageMark;
    private final int numberOfVoices;

    public Meal(String id, String name, String description, String headline, String imageSrc, Set<Tag> tags, Set<Category> categories, PriceType priceType, Set<NutritionValue> nutritionalValues, double averageMark, int numberOfVoices) {
        this.id = id;
        this.name = name;
        this.description = description;
        this.headline = headline;
        this.imageSrc = imageSrc;
        this.tags = tags;
        this.categories = categories;
        this.priceType = priceType;
        this.nutritionalValues = nutritionalValues;

        this.averageMark = averageMark;
        this.numberOfVoices = numberOfVoices;
    }

    public String getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public String getDescription() {
        return description;
    }

    public String getHeadline() {
        return headline;
    }

    public String getImageSrc() {
        return imageSrc;
    }

    public Set<Tag> getTags() {
        return tags;
    }

    public Set<Category> getCategories() {
        return categories;
    }

    public PriceType getPriceType() {
        return priceType;
    }

    public Set<NutritionValue> getNutritionalValues() {
        return nutritionalValues;
    }

    public double getAverageMark() {
        return averageMark;
    }

    public int getNumberOfVoices() {
        return numberOfVoices;
    }

    @Override
    public String toString() {
        StringBuilder builder = new StringBuilder("Meal: {\n");
        builder.append("\tid: ").append(id).append("\n");
        builder.append("\tname: ").append(name).append("\n");
        builder.append("\tdescription: ").append(description).append("\n");
        builder.append("\theadline: ").append(headline).append("\n");
        builder.append("\timageSrc: ").append(imageSrc).append("\n");
        if(!tags.isEmpty()) {
            builder.append("\ttags: {\n");
            for (Tag tag : tags) {
                builder.append("\t\t").append(tag.getName()).append("\n");
            }
            builder.append("\t}\n");
        }
        if(!categories.isEmpty()) {
            builder.append("\tcategories: {\n");
            for (Category category : categories) {
                builder.append("\t\t").append(category.getCategory()).append("; plan = ").append(category.getType()).append(";\n");
            }
            builder.append("\t}\n");
        }
        builder.append("\tpriceType: ").append(priceType.getType()).append(" = ").append(priceType.getValue()).append("\n");
        builder.append("\tnutritionalValues: {\n");
        for (NutritionValue nutritionValue : nutritionalValues) {
            builder.append("\t\t").append(nutritionValue).append("\n");
        }
        builder.append("\t}\n").append("\taverageMark: ").append(averageMark).append("\n");
        builder.append("\tnumberOfVoices: ").append(numberOfVoices).append("\n");
        builder.append("}");
        return builder.toString();
    }
}

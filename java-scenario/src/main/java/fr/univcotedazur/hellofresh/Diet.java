package fr.univcotedazur.hellofresh;

import fr.univcotedazur.hellofresh.model.*;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;
import com.fasterxml.jackson.databind.ObjectMapper;


import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class Diet {
    public static void main(String[] args) {
        String filename = args.length < 1 ? "../hello_fresh.xml" : args[0];
        String dietFile = args.length < 2 ? "diet.json" : args[1];
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            DocumentBuilder builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
            DietParsingModel diet = objectMapper.readValue(new File(dietFile), DietParsingModel.class);

            Document doc = builder.parse(new File(filename));
            doc.getDocumentElement().normalize();
            var mealsList = doc.getElementsByTagName("meals_list").item(0);
            var feedbacksList = doc.getElementsByTagName("feedbacks_list").item(0);

            Map<String, Mark> mealIdMark = new HashMap<>();

            NodeList feedbacks = feedbacksList.getChildNodes();

            for (int i = 0; i < feedbacks.getLength(); i++) {
                Node feedback = feedbacks.item(i);
                if (feedback.getNodeType() == Node.ELEMENT_NODE) {
                    String mealId = feedback.getAttributes().getNamedItem("meal_id").getNodeValue();
                    int liked = Integer.parseInt(feedback.getChildNodes().item(1).getAttributes().getNamedItem("value").getNodeValue());
                    mealIdMark.put(mealId, mealIdMark.getOrDefault(mealId, new Mark(liked, 1)).addFeedback(liked));
                }
            }

            var sortedMeals = mealIdMark.entrySet().stream()
                    .sorted((e1, e2) -> e2.getValue().compareTo(e1.getValue()))
                    .collect(Collectors.toCollection(LinkedHashSet::new));


            List<Meal> bestMeals = sortedMeals.stream()
                    .map(e -> {
                        NodeList meals = mealsList.getChildNodes();
                        for (int i = 0; i < meals.getLength(); i++) {
                            Node meal = meals.item(i);
                            if (meal.getNodeType() == Node.ELEMENT_NODE) {
                                if (meal.getAttributes().getNamedItem("id").getNodeValue().equals(e.getKey())) {
                                    int index = 5;
                                    Set<Tag> tags = meal.getChildNodes().item(index).getNodeName().equals("tags") ? getTags(meal.getChildNodes().item(index).getChildNodes()) : new HashSet<>();
                                    index += tags.isEmpty() ? 4 : 6;
                                    Set<Category> categories = meal.getChildNodes().item(index).getNodeName().equals("categories") ? getCategories(meal.getChildNodes().item(index).getChildNodes()) : new HashSet<>();
                                    index += categories.isEmpty() ? 0 : 2;
                                    return new Meal(
                                            meal.getAttributes().getNamedItem("id").getNodeValue(),
                                            meal.getAttributes().getNamedItem("name").getNodeValue(),
                                            meal.getAttributes().getNamedItem("description").getNodeValue(),
                                            meal.getChildNodes().item(1).getTextContent(),
                                            meal.getChildNodes().item(3).getAttributes().getNamedItem("src").getTextContent(),
                                            tags,
                                            categories,
                                            getPriceType(meal.getChildNodes().item(index)),
                                            getNutritionValues(meal.getChildNodes().item((index + 2)).getChildNodes()),
                                            e.getValue().getAverageMark(),
                                            e.getValue().getNumberFeedbacks());
                                }
                            }
                        }
                        return null;
                    })
                    .toList();

            for (int i = 0; i < bestMeals.size(); i++) {
                for (int j = i + 1; j < bestMeals.size(); j++) {
                    Meal meal1 = bestMeals.get(i);
                    Meal meal2 = bestMeals.get(j);
                    if (diet.isBalanced(sumOfNutritionalValue(meal1, meal2))) {
                        saveToFile("Diet : {\n");
                        saveToFile(meal1.toString());
                        saveToFile(meal2.toString());
                        saveToFile("}\n");
                        System.out.println("Diet found: {");
                        System.out.println("\t" + meal1);
                        System.out.println("\t" + meal2);
                        System.out.println("}");
                    }
                }
            }

        } catch (ParserConfigurationException | IOException | SAXException e) {
            e.printStackTrace();
        }
    }

    public static Set<NutritionValue> getNutritionValues(NodeList nutritionalValues) {
        return IntStream.range(0, nutritionalValues.getLength())
                .mapToObj(nutritionalValues::item)
                .filter(nutritionalComponent -> nutritionalComponent.getNodeType() == Node.ELEMENT_NODE)
                .map(nutritionalComponent -> new NutritionValue(
                        Double.parseDouble(nutritionalComponent.getAttributes().getNamedItem("value").getNodeValue()),
                        Nutrition.valueOf(nutritionalComponent.getAttributes().getNamedItem("idref").getNodeValue().toUpperCase())))
                .collect(Collectors.toSet());
    }

    public static PriceType getPriceType(Node priceType) {
        return PriceType.valueOf(priceType.getAttributes().getNamedItem("idref").getTextContent().toUpperCase());
    }

    public static Set<Category> getCategories(NodeList categories) {
        return IntStream.range(0, categories.getLength())
                .mapToObj(categories::item)
                .filter(category -> category.getNodeType() == Node.ELEMENT_NODE)
                .map(category -> Category.valueOf(category.getAttributes().getNamedItem("idref").getTextContent().toUpperCase()))
                .collect(Collectors.toSet());
    }

    public static Set<Tag> getTags(NodeList tags) {
        return IntStream.range(0, tags.getLength())
                .mapToObj(tags::item)
                .filter(tag -> tag.getNodeType() == Node.ELEMENT_NODE)
                .map(tag -> Tag.valueOf(tag.getAttributes().getNamedItem("idref").getTextContent().toUpperCase()))
                .collect(Collectors.toSet());
    }

    private static void saveToFile(String content) {
        try (PrintWriter writer = new PrintWriter(new FileWriter("../scenario6.txt", true))) {
            writer.println(content);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static Set<NutritionValue> sumOfNutritionalValue(Meal ... meal) {
        Set<NutritionValue> sum = new HashSet<>();
        for (Meal m : meal) {
            for (NutritionValue nutritionValue : m.getNutritionalValues()) {
                NutritionValue nutrition = sum.stream().filter(n -> n.nutrition() == nutritionValue.nutrition()).findFirst().orElse(null);
                if (nutrition == null) {
                    sum.add(nutritionValue);
                } else {
                    sum.remove(nutrition);
                    sum.add(new NutritionValue(nutrition.value() + nutritionValue.value(), nutrition.nutrition()));
                }
            }
        }
        return sum;
    }
}

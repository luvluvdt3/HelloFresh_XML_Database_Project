<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:output method="text"/>
    <xsl:strip-space elements="*"/>

    <xsl:key name="priceTypeKey" match="price_type" use="@id"/>
    <xsl:key name="ingredientKey" match="ingredient" use="@id"/>
    <xsl:key name="difficultyKey" match="difficulty" use="@id"/>
    <xsl:key name="nutritionComponentKey" match="nutritional_component" use="@id"/>

<xsl:template match="/">{
    "$schema": "./hello_fresh_schema.json",
    "meals": [<xsl:apply-templates select="//meals_list/meal[price_type_ref/@idref = '_normal_price_type']"/>
    ]
}
</xsl:template>

<xsl:template match="meal">
        {
            "id": "<xsl:value-of select="@id"/>",
            "name": "<xsl:value-of select="@name"/>",
            "description": "<xsl:value-of select="@description"/>",
            "headline": "<xsl:value-of select="headline"/>",
            "image": "<xsl:value-of select="image/@src"/>",
            "recipe": {
                "total_time": {
                    "value": <xsl:value-of select="recipe/total_time/time_amount/@value"/>,
                    "units": "<xsl:value-of select="recipe/total_time/time_amount/@unit"/>"
                },
                <xsl:if test="recipe/prep_time">"prep_time": {
                    "value": <xsl:value-of select="recipe/prep_time/time_amount/@value"/>,
                    "units": "<xsl:value-of select="recipe/prep_time/time_amount/@unit"/>"
                },</xsl:if>
                "difficulty": "<xsl:apply-templates select="recipe/difficulty_ref"/>",
                "ingredients": [<xsl:apply-templates select="recipe/ingredients/ingredient_ref"/>],
                "steps": [<xsl:apply-templates select="recipe/steps/step"/>
                ]
            },
            "price": "<xsl:value-of select="price_type_ref/@idref"/>",
            "utensils": [<xsl:apply-templates select="utensils/utensil_ref"/>
            ],
            "categories": [<xsl:apply-templates select="categories/category_ref"/>
            ],
            "nutritional_values": {<xsl:apply-templates select="nutritional_values/nutritional_component_ref"/>
            }
        }<xsl:if test="position() != last()">,</xsl:if>
</xsl:template>

<xsl:template match="ingredient_ref">
                    {
                        "type": "<xsl:value-of select="@type"/>",<xsl:if test="not(@type = 'at_home')">
                        "amount": {
                            "value": <xsl:value-of select="amount/@value"/>,
                            "units": "<xsl:value-of select="amount/@unit"/>"
                        },</xsl:if>
                        "ingredient": {
                            "name": "<xsl:value-of select="key('ingredientKey', @idref)/@name"/>",
                            "image": "<xsl:value-of select="key('ingredientKey', @idref)/image/@src"/>"
                        }
                    }<xsl:if test="position() != last()">,</xsl:if>
</xsl:template>

<xsl:template match="difficulty_ref">
    <xsl:value-of select="key('difficultyKey', @idref)/@level"/>
</xsl:template>

<xsl:template match="step">
                    {
                        "index": <xsl:value-of select="index"/>,
                        "instructions": [<xsl:apply-templates select="instructions"/>
                        ],
                        "image": "<xsl:value-of select="image/@src"/>"
                    }<xsl:if test="position() != last()">,</xsl:if>
</xsl:template>

<xsl:template match="instructions">
                            {
                                "guide": "<xsl:value-of select="instruction/guide"/>"<xsl:if test="instruction/tip">,
                                "tip": "<xsl:value-of select="instruction/tip"/>"
                                </xsl:if>
                            }<xsl:if test="position() != last()">,</xsl:if>
</xsl:template>

<xsl:template match="utensil_ref">
                "<xsl:value-of select="@idref"/>"<xsl:if test="position() != last()">,</xsl:if>
</xsl:template>

<xsl:template match="category_ref">
                "<xsl:value-of select="@idref"/>"<xsl:if test="position() != last()">,</xsl:if>
</xsl:template>

<xsl:template match="nutritional_component_ref">
                "<xsl:value-of select="translate(key('nutritionComponentKey', @idref), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz')"/>": <xsl:value-of select="@value"/><xsl:if test="position() != last()">,</xsl:if>
</xsl:template>

</xsl:stylesheet>

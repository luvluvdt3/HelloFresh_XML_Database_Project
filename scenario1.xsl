<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    <xsl:key name="difficultyKey" match="difficulty" use="@id"/>
    <xsl:key name="ingredientKey" match="ingredient" use="@id"/>
    <xsl:key name="allergenKey" match="allergen" use="@id"/>
    <xsl:key name="utensilKey" match="utensil" use="@id"/>
    <xsl:key name="tagKey" match="tag" use="@id"/>
    <xsl:key name="nutritionalComponentKey" match="nutritional_component" use="@id"/>

    <xsl:template match="/">
        <html lang="en">
            <head>
                <link rel="stylesheet" type="text/css" href="./style/scenario1.css"/>
                <title>Our Recipes</title>
            </head>
            <body>
                <main>
                    <h1>Our Recipes</h1>
                    <hr/>
                    <ul class="card-list">
                        <xsl:apply-templates select="//meal"/>
                    </ul>
                </main>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="meal">
        <li onclick="window.location.href='#{@id}'" class="meal_card">
            <article>
                <h1><xsl:value-of select="@name"/></h1>
                <p class="meal_card_headline"><xsl:if test="headline"><xsl:value-of select="headline"/></xsl:if></p>
                <section>
                    <img src="{image/@src}" alt="{image/@alt}" />
                    <div class="content_card">
                        <a class="view-recipe" href="#{@id}">View Recipe</a>
                        <p><xsl:value-of select="@description"/></p>
                    </div>
                </section>
            </article>
        </li>


        <div id="{@id}" class="overlay">
            <div class="popup">
                <div class="close-container">
                    <a href="#" class="close-overlay">x</a>
                </div>
                <div class="content">
                    <div class="content_content">
                        <img src="{image/@src}" alt="{image/@alt}" />
                        <h1><xsl:value-of select="@name"/></h1>
                        <h3><xsl:if test="headline"><xsl:value-of select="headline"/></xsl:if></h3>
                        <hr/>
                        <div class="float-container">
                            <div class="float-child left-child">
                                <h3><xsl:value-of select="headline"/></h3>
                                <p><xsl:value-of select="@description"/></p>
                                <xsl:if test="tags">
                                    <xsl:apply-templates select="tags"/>
                                </xsl:if>
                            </div>
                            <div class="float-child right-child">
                                <div class="section_container">
                                    <p><strong>Total Time: </strong> <xsl:value-of select="concat(recipe/total_time/time_amount/@value, ' ', recipe/total_time/time_amount/@unit)"/></p>
                                    <xsl:if test="recipe/prep_time/time_amount/@value"><p><strong>Preparation Time: </strong> <xsl:value-of select="concat(recipe/total_time/time_amount/@value, ' ', recipe/total_time/time_amount/@unit)"/></p></xsl:if>
                                    <p><strong>Difficulty: </strong><xsl:call-template name="getDifficulty"><xsl:with-param name="id" select="recipe/difficulty_ref/@idref"/></xsl:call-template></p>
                                </div>
                            </div>
                        </div>
                        <div class="float-container">
                            <div class="float-child left-child">
                                <div class="section_container">
                                    <h1>Ingredients</h1>
                                    <ul class="ingredients-list">
                                        <xsl:apply-templates select="recipe/ingredients/ingredient_ref[@type = 'in_box']"/>
                                    </ul>
                                    <hr/>
                                    <h2>Not included in your delivery</h2>
                                    <ul class="ingredients-list">
                                        <xsl:apply-templates select="recipe/ingredients/ingredient_ref[@type = 'at_home']"/>
                                    </ul>
                                </div>
                            </div>
                            <div class="float-child right-child">
                                <div class="section_container">
                                    <xsl:apply-templates select="nutritional_values"/>
                                </div>
                                <br/>
                                <div class="section_container">
                                    <h1>Utensils</h1>
                                    <xsl:apply-templates select="utensils"/>
                                </div>
                            </div>
                        </div>
                        <div class="section_container">
                            <h1>Instructions</h1>
                            <ol>
                                <xsl:apply-templates select="recipe/steps/step"/>
                            </ol>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="utensils">
        <ul>
            <xsl:apply-templates select="utensil_ref"/>
        </ul>
    </xsl:template>

    <xsl:template match="utensil_ref">
        <li><xsl:value-of select="key('utensilKey', @idref)"/></li>
    </xsl:template>

    <xsl:template name="getDifficulty">
        <xsl:param name="id"/>
        <xsl:value-of select="key('difficultyKey', $id)"/>
    </xsl:template>

    <xsl:template match="ingredient_ref">
        <li class="ingredient-item">
            <div class="ingredient-details">
                <div class="ingredient-image">
                    <xsl:if test="key('ingredientKey', @idref)/image/@src">
                        <img src="{key('ingredientKey', @idref)/image/@src}" alt="{key('ingredientKey', @idref)/image/@alt}" />
                    </xsl:if>
                </div>
                <div class="ingredient-info">
                    <xsl:if test="(amount)">
                        <p class="ingredient-amount">
                            <xsl:value-of select="concat(amount/@value, ' ', amount/@unit)"/>
                        </p>
                    </xsl:if>
                    <p class="ingredient-name">
                        <xsl:value-of select="key('ingredientKey', @idref)/@name"/>
                    </p>
                    <xsl:if test="key('ingredientKey', @idref)/allergens/allergen_ref">
                        <p class="ingredient-allergens">(Contains <xsl:apply-templates select="key('ingredientKey', @idref)/allergens/allergen_ref"/>)</p>
                    </xsl:if>
                </div>
            </div>
        </li>

    </xsl:template>

    <xsl:template match="allergen_ref">
        <strong><xsl:value-of select="key('allergenKey', @idref)"/><xsl:if test="position() != last()">, </xsl:if></strong>
    </xsl:template>



    <xsl:template match="step">
        <li>
            <div class="step-content">
                <div class="float-container">
                    <div class="float-child right-child">
                        <img class="step-image" src="{image/@src}" alt="{image/@alt}" />
                    </div>
                    <div class="float-child left-child">
                        <div class="step-index">
                            <xsl:value-of select="index"/>
                        </div>
                        <div class="step-description">
                            <p>
                                <xsl:value-of select="instructions/instruction/guide"/>
                            </p>
                            <xsl:if test="instructions/instruction/tip">
                                <i>TIP: <xsl:value-of select="instructions/instruction/tip"/></i>
                            </xsl:if>
                        </div>
                        <xsl:if test="instructions/tip">
                            <p>
                                <strong>Tip: <xsl:value-of select="instructions/tip"/></strong>
                            </p>
                        </xsl:if>
                    </div>
                </div>
            </div>
        </li>
        <xsl:if test="position() != last()">
            <hr/>
        </xsl:if>
    </xsl:template>


    <xsl:template match="nutritional_values">
        <h1><strong>Nutritional Values:</strong></h1>
        <h3>/ per Serving</h3>
        <div class="nutritional-values">
            <xsl:apply-templates select="nutritional_component_ref"/>
        </div>
    </xsl:template>

    <xsl:template match="nutritional_component_ref">
        <p><strong><xsl:value-of select="key('nutritionalComponentKey', @idref)"/>: </strong><xsl:value-of select="@value"/> <xsl:value-of select="key('nutritionalComponentKey', @idref)/@unit"/></p>
    </xsl:template>

    <xsl:template match="tags">
        <span><strong>Tags: </strong><xsl:apply-templates select="tag_ref"/></span>
    </xsl:template>

    <xsl:template match="tag_ref">
        <xsl:value-of select="key('tagKey', @idref)"/><xsl:if test="position() != last()">, </xsl:if>
    </xsl:template>

</xsl:stylesheet>

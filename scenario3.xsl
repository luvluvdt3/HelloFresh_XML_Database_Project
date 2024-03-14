<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    <xsl:key name="categoryKey" match="category" use="@id"/>

    <xsl:template match="/">
        <html lang="en">
            <head>
                <link rel="stylesheet" type="text/css" href="./style/scenario3.css"/>
                <title>Our Recipe Categories</title>
                <script>
                    function showMeals(categoryId) {
                        var mealsDiv = document.getElementById(categoryId);
                        if (mealsDiv.style.display === 'none') {
                            mealsDiv.style.display = 'block';
                        }
                        else {
                            mealsDiv.style.display = 'none';
                        }
                    }
                </script>
            </head>
            <body>
                <main>
                    <h1>Our Recipe Categories</h1>
                    <hr/>
                    <ul class="card-list">
                        <xsl:for-each select="//category[not(@type = preceding-sibling::category/@type)]">
                            <xsl:sort select="@type"/>
                            <li class="category">
                                <xsl:variable name="currentType" select="@type"/>
                                <h2>
                                    <xsl:value-of select="concat(translate(substring($currentType, 1, 1), 'abcdefghijklmnopqrstuvwxyz', 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'), substring($currentType, 2))"/>
                                </h2>
                                <hr/>
                                <!-- Display category values within the current type -->
                                <xsl:apply-templates select="//category[@type = $currentType]">
                                    <xsl:sort select="."/>
                                </xsl:apply-templates>
                            </li>
                        </xsl:for-each>
                    </ul>
                </main>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="category">
        <div class="tag" onclick="showMeals('{@id}')">
            <strong>
                <xsl:text> </xsl:text>
                <xsl:value-of select="."/>
            </strong>
        </div>

        <div id="{@id}" style="display:none;">
            <xsl:variable name="categoryMeals" select="//meal[categories/category_ref/@idref = current()/@id]"/>
            <xsl:choose>
                <xsl:when test="$categoryMeals">
                    <xsl:apply-templates select="$categoryMeals">
                        <xsl:sort select="@name"/>
                    </xsl:apply-templates>
                </xsl:when>
                <xsl:otherwise>
                    <div>Oops! Nothing here yet.</div>
                </xsl:otherwise>
            </xsl:choose>
        </div>
    </xsl:template>

    <xsl:template match="meal">
        <div onclick="event.preventDefault(); window.open('scenario1.html#{@id}', '_blank');" class="meal_card">
            <article>
                <h1><xsl:value-of select="@name"/></h1>
                <xsl:if test="headline"><p class="meal_card_headline"><xsl:value-of select="headline"/></p></xsl:if>
                <section>
                    <img src="{image/@src}" alt="{image/@alt}" />
                    <div class="content_card">
                        <a class="view-recipe" href="#{@id}">View Recipe</a>
                        <p><xsl:value-of select="@description"/></p>
                    </div>
                </section>
            </article>
        </div>
    </xsl:template>

</xsl:stylesheet>

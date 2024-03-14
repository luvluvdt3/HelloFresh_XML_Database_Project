<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>
    <xsl:key name="categoryKey" match="category" use="@id"/>
    <xsl:key name="priceTypeKey" match="price_type" use="@id"/>
    <xsl:key name="tagKey" match="tag" use="@id"/>
    <xsl:key name="mealKey" match="meal" use="@id"/>
    <xsl:key name="favoriteKey" match="favorite" use="@meal_id"/>

    <xsl:template match="/">
        <html lang="en">
            <head>
                <link rel="stylesheet" type="text/css" href="./style/scenario2.css"/>
                <title>Our Weekly Menus</title>
            </head>
            <body>
                <main>
                    <h1>Our Weekly Menus</h1>
                    <hr/>
                    <ul class="card-list">
                        <xsl:apply-templates select="//weekly_menu"/>
                    </ul>
                </main>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="weekly_menu">
        <li>
            <button onclick="window.location.href='#{@id}'">Menu from <xsl:value-of select="week/@start_date"/> to <xsl:value-of select="week/@end_date"/></button>
        </li>
        <div id="{@id}" class="overlay">
            <hr/>
            <h2><i>Menu from <xsl:value-of select="week/@start_date"/> to <xsl:value-of select="week/@end_date"/></i></h2>
            <ul class="card-list">
                <xsl:apply-templates select="meal_ref_list"/>
            </ul>
        </div>
    </xsl:template>


    <xsl:template match="meal_ref_list">
        <xsl:apply-templates select="meal_ref"/>
    </xsl:template>

    <xsl:template match="meal_ref">

        <li id="{@idref}" onclick="event.preventDefault(); window.open('scenario1.html#{@idref}', '_blank');" class="meal_card">
            <article>
                <h1><xsl:value-of select="key('mealKey', @idref)/@name"/></h1>
                <p class="meal_card_headline"><xsl:if test="key('mealKey', @idref)/headline"><xsl:value-of select="key('mealKey', @idref)/headline"/></xsl:if></p>

                <div class="meal-info">
                    <div class="container">
                        <p class="total-time">
                            <strong>Total Time: </strong>
                            <xsl:value-of select="concat(key('mealKey', @idref)/recipe/total_time/time_amount/@value, ' ', key('mealKey', @idref)/recipe/total_time/time_amount/@unit)"/>
                        </p>
                        <xsl:apply-templates select="key('mealKey', @idref)/price_type_ref"/>
                        <span class="favorite">
                            <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" width="24" height="24">
                                <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                            </svg>
                            <span class="favorite_num">
                                <xsl:call-template name="countFavorites">
                                    <xsl:with-param name="mealId" select="@idref"/>
                                </xsl:call-template>
                            </span>
                        </span>
                    </div>

                    <xsl:if test="key('mealKey', @idref)/categories">
                        <xsl:apply-templates select="key('mealKey', @idref)/categories"/>
                    </xsl:if>

                    <xsl:if test="key('mealKey', @idref)/tags">
                        <xsl:apply-templates select="key('mealKey', @idref)/tags"/>
                    </xsl:if>
                </div>

                <section>
                    <img src="{key('mealKey', @idref)/image/@src}" alt="{key('mealKey', @idref)/image/@alt}" />
                    <div class="content_card">
                        <a class="view-recipe" href="scenario1.html#{@idref}">View Recipe</a>
                        <p><xsl:value-of select="key('mealKey', @idref)/@description"/></p>
                    </div>
                </section>
            </article>
        </li>
    </xsl:template>

    <xsl:template match="categories">
        <p class="tag_line categories"><strong>Categories:</strong><xsl:apply-templates select="category_ref"/></p>
    </xsl:template>

    <xsl:template match="category_ref">
        <span class="tag"><xsl:value-of select="key('categoryKey', @idref)"/></span>
    </xsl:template>


    <xsl:template match="price_type_ref">
        <xsl:variable name="normalPrice" select="number(key('priceTypeKey', '_normal_price_type')/money_amount/@value)"/>
        <xsl:variable name="currentPrice" select="number(key('priceTypeKey', @idref)/money_amount/@value)"/>
        <xsl:variable name="priceDifference" select="$currentPrice - $normalPrice"/>
        <p>
            <xsl:if test="$priceDifference != 0">
                <span class="price_plus">+<xsl:value-of select="$priceDifference"/><xsl:value-of select="key('priceTypeKey', '_normal_price_type')/money_amount/@currency"/>/per serving</span>
            </xsl:if>
        </p>
    </xsl:template>

    <xsl:template match="tags">
        <p class="tag_line"><strong>Tags: </strong> <xsl:apply-templates select="tag_ref"/></p>
    </xsl:template>

    <xsl:template match="tag_ref">
        <span class="tag"><xsl:value-of select="key('tagKey', @idref)"/></span>
    </xsl:template>

    <xsl:template name="countFavorites">
        <xsl:param name="mealId"/>
        <xsl:variable name="favorites" select="key('favoriteKey', $mealId)"/>
        <xsl:value-of select="count($favorites)"/>
    </xsl:template>

</xsl:stylesheet>

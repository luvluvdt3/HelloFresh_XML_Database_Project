<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="xml" indent="yes"/>

    <xsl:key name="mealKey" match="meal" use="@id"/>
    <xsl:key name="userKey" match="user" use="@id"/>
    <xsl:key name="addressKey" match="user_address" use="@id"/>
    <xsl:key name="deliveryKey" match="delivery" use="@id"/>

    <xsl:template match="/">
        <result>
            <xsl:apply-templates select="//command[starts-with(command_date, '2024-02-28')]"/>
        </result>
    </xsl:template>

    <xsl:template match="command">
        <command>
            <xsl:copy-of select="@*"/>
            <user_ref>
                <xsl:attribute name="idref">
                    <xsl:value-of select="user_ref/@idref"/>
                </xsl:attribute>
                <xsl:apply-templates select="key('userKey', user_ref/@idref)"/>
            </user_ref>
            <meal_ref_list>
                <xsl:apply-templates select="meal_ref_list/meal_ref"/>
            </meal_ref_list>
            <serving_number><xsl:value-of select="serving_number"/></serving_number>
            <total_price>
                <money_amount>
                    <xsl:attribute name="value">
                        <xsl:value-of select="total_price/money_amount/@value"/>
                    </xsl:attribute>
                    <xsl:attribute name="currency">
                        <xsl:value-of select="total_price/money_amount/@currency"/>
                    </xsl:attribute>
                </money_amount>
            </total_price>
            <discount><xsl:value-of select="discount"/></discount>
            <final_total>
                <money_amount>
                    <xsl:attribute name="value">
                        <xsl:value-of select="final_total/money_amount/@value"/>
                    </xsl:attribute>
                    <xsl:attribute name="currency">
                        <xsl:value-of select="final_total/money_amount/@currency"/>
                    </xsl:attribute>
                </money_amount>
            </final_total>
            <delivery>
                <xsl:apply-templates select="key('deliveryKey', delivery_ref/@idref)"/>
            </delivery>
            <command_date><xsl:value-of select="command_date"/></command_date>
        </command>
    </xsl:template>

    <xsl:template match="meal_ref">
        <meal_ref>
            <xsl:attribute name="idref">
                <xsl:value-of select="@idref"/>
            </xsl:attribute>
            <xsl:apply-templates select="key('mealKey', @idref)"/>
        </meal_ref>
    </xsl:template>

    <xsl:template match="delivery">
        <xsl:copy-of select="*"/>
    </xsl:template>

    <xsl:template match="user">
        <user>
            <xsl:copy-of select="@*"/>
            <user_address>
                <xsl:apply-templates select="user_address"/>
            </user_address>
        </user>
    </xsl:template>

    <xsl:template match="user_address">
        <user_address>
            <xsl:copy-of select="@*"/>
            <address_ref>
                <xsl:attribute name="idref">
                    <xsl:value-of select="@id"/>
                </xsl:attribute>
                <xsl:apply-templates select="address"/>
            </address_ref>
        </user_address>
    </xsl:template>

    <xsl:template match="address">
        <xsl:copy-of select="@*"/>
    </xsl:template>

    <xsl:template match="meal">
        <meal>
            <xsl:copy-of select="@*"/>
            <headline><xsl:value-of select="headline"/></headline>
        </meal>
    </xsl:template>
</xsl:stylesheet>

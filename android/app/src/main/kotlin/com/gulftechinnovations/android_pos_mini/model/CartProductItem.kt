package com.gulftechinnovations.android_pos_mini.model

data class CartProductItem(
    val noOfItemsOrdered:Float,
    val note:String? = null,
    val cartProductName:String,
    val cartProductLocalName:String?,
    val product:Product?
)

package com.gulftechinnovations.android_pos_mini.model

data class Invoice(
    val title:String,
    val cartProductItems:List<CartProductItem>,
    val total:Float,
    val invoiceNo:String
)

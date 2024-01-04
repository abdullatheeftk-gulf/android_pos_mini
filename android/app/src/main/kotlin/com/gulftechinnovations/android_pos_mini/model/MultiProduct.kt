package com.gulftechinnovations.android_pos_mini.model

data class MultiProduct(
    var multiProductId:Int = 0,
    val parentProductId:Int,
    val multiProductName:String,
    val multiProductLocalName:String? = null,
    val multiProductImage:String?=null,
    val info:String? = null
)
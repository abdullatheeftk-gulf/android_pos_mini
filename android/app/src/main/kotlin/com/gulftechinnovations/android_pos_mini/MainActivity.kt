package com.gulftechinnovations.android_pos_mini

import android.content.Context
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import android.text.Layout
import android.text.StaticLayout
import android.text.TextPaint
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.FileOutputStream
import java.io.IOException
import java.util.Date

class MainActivity: FlutterActivity() {
    private val channelName = "text2image"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channelName).setMethodCallHandler { call, result ->
            if (call.method=="convertTextToImage"){
                val args = call.arguments as HashMap<*, *>
                val textTwoConvert = args["text"].toString()
                val byteArray = saveTextToImage(text = textTwoConvert, context = this)

                result.success(byteArray)

            }
        }

    }

    private fun saveTextToImage(text: String, textWidth: Int = 400, context: Context) : ByteArray {
        val textPaint = TextPaint(Paint.ANTI_ALIAS_FLAG or Paint.LINEAR_TEXT_FLAG)
        textPaint.style = Paint.Style.FILL
        textPaint.color = Color.BLACK
        textPaint.textAlign = Paint.Align.LEFT
        textPaint.textSize = 28f
        textPaint.typeface = Typeface.create("sans-serif", Typeface.NORMAL)


        val mTextLayout =
            StaticLayout(text, textPaint, textWidth, Layout.Alignment.ALIGN_CENTER, 1f, 0f, false)


        val bitmap = Bitmap.createBitmap(textWidth,mTextLayout.height, Bitmap.Config.RGB_565)
        val canvas = Canvas(bitmap)

        val paint = Paint(Paint.ANTI_ALIAS_FLAG or Paint.LINEAR_TEXT_FLAG)
        paint.style = Paint.Style.FILL
        paint.color = Color.WHITE
        canvas.drawPaint(paint)

        canvas.save()
        canvas.translate(0f,0f)

        mTextLayout.draw(canvas)
        canvas.restore()

        /*try {
            saveBitmap(bitmap = bitmap, context = context)
        }catch (e:Exception){
            e.printStackTrace()

        }*/

        val byteArrayOutputStream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG,80,byteArrayOutputStream)
        return  byteArrayOutputStream.toByteArray()


    }


    @Throws(IOException::class)
    fun saveBitmap(bitmap: Bitmap, context: Context){
        val fileOutputStream: FileOutputStream =
            context.openFileOutput("test${Date().time}.png", Context.MODE_PRIVATE)
        bitmap.compress(Bitmap.CompressFormat.PNG, 80, fileOutputStream)
        fileOutputStream.close()

    }
}

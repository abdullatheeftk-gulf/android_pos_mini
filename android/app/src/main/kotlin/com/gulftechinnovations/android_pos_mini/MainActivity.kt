package com.gulftechinnovations.android_pos_mini

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Typeface
import android.text.Layout
import android.text.StaticLayout
import android.text.TextPaint
import android.widget.Toast
import com.google.gson.Gson
import com.gulftechinnovations.android_pos_mini.model.Invoice
import com.gulftechinnovations.android_pos_mini.model.SampleProduct
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import net.posprinter.IDeviceConnection
import net.posprinter.IPOSListener
import net.posprinter.POSConnect
import net.posprinter.POSConst
import net.posprinter.POSPrinter
import net.posprinter.posprinterface.IStatusCallback


class MainActivity : FlutterActivity(), IPOSListener, EventChannel.StreamHandler, IStatusCallback {

    private val methodChannelName = "XPrint_method_channel"
    private val eventChannelName = "XPrint_event_channel"

    private lateinit var xPrinterConnectEventChannel: EventChannel
    private var eventSink: EventChannel.EventSink? = null
    private lateinit var methodChannel: MethodChannel


    private var curConnect: IDeviceConnection? = null


    private var usbName = ""
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {

        POSConnect.init(this)


        xPrinterConnectEventChannel =
            EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventChannelName)



        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodChannelName)

        xPrinterConnectEventChannel.setStreamHandler(this)

        methodChannel.setMethodCallHandler { call, result ->

            if (call.method == "getUsbAddress") {
                //xPrinterConnectEventChannel.setStreamHandler(this)
                try {
                    val usbNames = POSConnect.getUsbDevices(this)

                    if (usbNames.isNotEmpty()) {
                        val name = usbNames[0]
                        result.success(name)
                        usbName = name

                    } else {
                        result.success("No usb printers connected")
                    }
                } catch (e: Exception) {
                    Toast.makeText(this, "${e.message}", Toast.LENGTH_LONG).show()
                }

            }

            if (call.method == "usbConnect") {
                // xPrinterConnectEventChannel.setStreamHandler(this)
                try {
                    curConnect?.close()
                    curConnect = POSConnect.createDevice(POSConnect.DEVICE_TYPE_USB)
                    curConnect?.connect(usbName, this)
                    //result.success(true)
                    //eventSink?.success(UsbPrinterStatus.UsbConnected.name)
                } catch (e: Exception) {
                    result.success(false)
                    Toast.makeText(this, "${e.printStackTrace()}", Toast.LENGTH_LONG).show()
                }
            }

            if (call.method == "testTextPrint") {
                try {
                    val args = call.arguments as HashMap<*, *>
                    val message = args["textToPrint"].toString()

                    if (curConnect != null) {
                        val printer = POSPrinter(curConnect)

                        printer.isConnect(this)

                        printer
                            .printString("$message\n")
                            .printText(
                                "printText Demo\n",
                                POSConst.ALIGNMENT_CENTER,
                                POSConst.FNT_BOLD or POSConst.FNT_UNDERLINE,
                                POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                            )
                            .printText(
                                "printText Demo\n",
                                POSConst.ALIGNMENT_RIGHT,
                                POSConst.FNT_DEFAULT,
                                POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                            )
                            .feedDot(10)
                            .feedLine(1)
                            .cutHalfAndFeed(2)

                        //Toast.makeText(this, "Printed", Toast.LENGTH_SHORT).show()
                        // result.success("Printed")
                        eventSink?.success(UsbPrinterStatus.UsbPrintSuccess.name)

                    } else {
                        result.success("Not connected")
                        eventSink?.success(UsbPrinterStatus.UsbPrintFailed.name)
                        Toast.makeText(this, "Not connected", Toast.LENGTH_LONG).show()
                    }

                } catch (e: Exception) {
                    Toast.makeText(this, "${e.stackTrace}", Toast.LENGTH_LONG).show()

                }
            }

            if (call.method == "testArabicTextPrint") {
                try {
                    val args = call.arguments as HashMap<*, *>
                    val message = args["textToPrint"].toString()

                    val textBitmap = convertTextToImage(text = message)

                    if (curConnect != null) {
                        val printer = POSPrinter(curConnect)


                        /*for (i in 1..10) {
                            printer.printText(
                                "printText Demo\n",
                                POSConst.ALIGNMENT_CENTER,
                                POSConst.FNT_BOLD or POSConst.FNT_UNDERLINE,
                                POSConst.TXT_2WIDTH or POSConst.TXT_2HEIGHT
                            )
                        }*/

                        printer.printBitmap(textBitmap, POSConst.ALIGNMENT_RIGHT, 384)
                        printer.feedDot(2)
                            .feedLine(4)
                            .cutHalfAndFeed(2)


                        //Toast.makeText(this, "Printed", Toast.LENGTH_SHORT).show()
                        //result.success("Printed")
                        eventSink?.success(UsbPrinterStatus.UsbPrintSuccess.name)

                    } else {
                        result.success("Not connected")
                        eventSink?.success(UsbPrinterStatus.UsbPrintFailed.name)
                        Toast.makeText(this, "Not connected", Toast.LENGTH_LONG).show()
                    }

                } catch (e: Exception) {
                    Toast.makeText(this, "${e.message}", Toast.LENGTH_LONG).show()

                }
            }

            if (call.method == "printEscPosFullTicket") {
                val gson = Gson()
                try {
                    val sampleProductListJson = call.arguments as List<*>
                    val sampleProductList = sampleProductListJson.map { json ->
                        gson.fromJson(json.toString(), SampleProduct::class.java)
                    }

                    if (curConnect == null) throw Exception("Printer is not connected")

                    val printer = POSPrinter(curConnect)


                    printer.printText(
                        "UniposPro\n\n",
                        POSConst.ALIGNMENT_CENTER,
                        POSConst.FNT_BOLD,
                        POSConst.TXT_2WIDTH or POSConst.TXT_2HEIGHT
                    )

                    /*val table = PTable(arrayOf("QTY", "Price", "Total"), arrayOf(10, 14, 16))
                    printer.printTable(table)*/
                    printer.printText(
                        "Qty        Price        Total",
                        POSConst.ALIGNMENT_LEFT,
                        POSConst.FNT_DEFAULT or POSConst.FNT_UNDERLINE,
                        POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT,
                    )

                    printer.printText(
                        "\n\n",
                        POSConst.ALIGNMENT_CENTER,
                        POSConst.FNT_FONTB or POSConst.FNT_UNDERLINE,
                        POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT,
                    )

                    printer.setLineSpacing(1)


                    //printer.feedDot(1)
                    var i = 0
                    sampleProductList.forEach { product ->
                        i++
                        val textBitmap = convertTextToImage(text = product.localName)

                        val total = product.qty * product.price

                        printer.printText(
                            "$i, ${product.name}\n",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_BOLD,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                        )
                        printer.printBitmap(textBitmap, POSConst.ALIGNMENT_RIGHT, 384)
                        printer.printText(
                            "\n",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_BOLD,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                        )

                        /* printer.printText(
                             "${product.qty}",
                             POSConst.ALIGNMENT_LEFT,
                             POSConst.FNT_DEFAULT,
                             POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                         )
                         printer.printText(
                             "${product.price}",
                             POSConst.ALIGNMENT_CENTER,
                             POSConst.FNT_DEFAULT,
                             POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                         )
                         printer.printText(
                             "$total",
                             POSConst.ALIGNMENT_RIGHT,
                             POSConst.FNT_DEFAULT,
                             POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                         )*/

                        printer.printText(
                            "${product.qty}         ${product.price}          $total",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_DEFAULT,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT,
                        )
                        printer.printText(
                            "\n",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_BOLD,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                        )
                        printer.printText(
                            "-------------------------------------------",
                            POSConst.ALIGNMENT_CENTER,
                            POSConst.FNT_FONTB,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT,
                        )



                        printer.feedDot(1)


                    }
                    // New line
                    try {

                        val logo = BitmapFactory.decodeResource(resources, R.drawable.logo)
                        printer.printBitmap(logo, POSConst.ALIGNMENT_CENTER, 384)
                        printer.printText(
                            "\n",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_BOLD,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                        )
                    } catch (e: Exception) {
                        Toast.makeText(this, "${e.message}", Toast.LENGTH_LONG).show()

                    }

                    try {
                        printer.printQRCode("https://translate.google.com/")
                        printer.printText(
                            "\n",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_BOLD,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                        )
                    } catch (e: Exception) {
                        Toast.makeText(this, "${e.message}", Toast.LENGTH_LONG).show()
                    }

                    printer
                        .feedDot(2)
                        .feedLine(4)
                        .cutHalfAndFeed(1)
                    eventSink?.success(UsbPrinterStatus.UsbPrintSuccess.name)


                } catch (e: Exception) {
                    Toast.makeText(this, "${e.message}", Toast.LENGTH_LONG).show()

                }
            }

            if (call.method == "printInvoice") {
                val gson = Gson()
                try {
                    val invoiceJson = call.arguments as String
                    val invoice = gson.fromJson(invoiceJson, Invoice::class.java)

                    val cartProductItems = invoice.cartProductItems
                    val invoiceNo = invoice.invoiceNo
                    val total = invoice.total
                    val title = invoice.title

                    if (curConnect == null) throw Exception("Printer is not connected")

                    val printer = POSPrinter(curConnect)



                    printer.printText(
                        "$title\n\n",
                        POSConst.ALIGNMENT_CENTER,
                        POSConst.FNT_BOLD,
                        POSConst.TXT_2WIDTH or POSConst.TXT_2HEIGHT
                    )


                    try {
                        printer.printText(
                            "-------------------------------------\n",
                            POSConst.ALIGNMENT_CENTER,
                            POSConst.FNT_FONTB,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT,
                        )
                    } catch (e: Exception) {
                        Toast.makeText(this, e.message, Toast.LENGTH_SHORT).show()
                    }

                    printer.printText(
                        "Invoice No: $invoiceNo\n",
                        POSConst.ALIGNMENT_CENTER,
                        POSConst.FNT_BOLD,
                        POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT,
                    )

                    try {
                        printer.printText(
                            "-------------------------------------\n",
                            POSConst.ALIGNMENT_CENTER,
                            POSConst.FNT_FONTB,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT,
                        )
                    } catch (e: Exception) {
                        Toast.makeText(this, e.message, Toast.LENGTH_SHORT).show()
                    }





                    printer.printText(
                        "Qty        Price        Total",
                        POSConst.ALIGNMENT_LEFT,
                        POSConst.FNT_DEFAULT or POSConst.FNT_UNDERLINE,
                        POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT,
                    )

                    printer.printText(
                        "\n\n",
                        POSConst.ALIGNMENT_CENTER,
                        POSConst.FNT_FONTB or POSConst.FNT_UNDERLINE,
                        POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT,
                    )

                    //printer.setLineSpacing(1)


                    //printer.feedDot(1)


                    var i = 0
                    var net = 0f
                    cartProductItems.forEach { cartProductItem ->
                        i++
                        val qty = cartProductItem.noOfItemsOrdered
                        val price = cartProductItem.product?.productPrice ?: 0f
                        val itemTotal = qty * price

                        net += itemTotal

                        val productName = cartProductItem.cartProductName
                        val productLocalName = cartProductItem.cartProductLocalName

                        val arabicTextBitmap: Bitmap? =
                            if (productLocalName == null) {
                                null
                            } else {
                                convertTextToImage(text = productLocalName)
                            }

                        // Name printing
                        printer.printText(
                            "$i, $productName\n",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_BOLD,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                        )
                        // Arabic Text Printing
                        arabicTextBitmap?.let {
                            printer.printBitmap(arabicTextBitmap, POSConst.ALIGNMENT_RIGHT, 384)
                        }
                        // New line
                        printer.printText(
                            "\n",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_BOLD,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                        )

                        printer.printText(
                            "$qty         $price          $itemTotal",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_DEFAULT,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT,
                        )
                        printer.printText(
                            "\n",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_BOLD,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                        )
                        try {
                            printer.printText(
                                "-------------------------------------\n",
                                POSConst.ALIGNMENT_CENTER,
                                POSConst.FNT_FONTB,
                                POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT,
                            )
                        } catch (e: Exception) {
                            Toast.makeText(this, e.message, Toast.LENGTH_SHORT).show()
                        }

                    }
                    // For loop finished

                    try {
                        printer.printText(
                            "\n",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_BOLD,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                        )
                        printer.printText(
                            "Total:- $total",
                            POSConst.ALIGNMENT_RIGHT,
                            POSConst.FNT_BOLD,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                        )
                        printer.printText(
                            "\n",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_BOLD,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                        )
                    } catch (e: Exception) {
                        Toast.makeText(this, e.message, Toast.LENGTH_SHORT).show()
                    }


                    try {

                        val logo = BitmapFactory.decodeResource(resources, R.drawable.logo)
                        printer.printBitmap(logo, POSConst.ALIGNMENT_CENTER, 384)
                        printer.printText(
                            "\n",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_BOLD,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                        )
                    } catch (e: Exception) {
                        Toast.makeText(this, "${e.message}", Toast.LENGTH_LONG).show()
                    }

                    try {
                        printer.printQRCode("https://translate.google.com/")
                        printer.printText(
                            "\n",
                            POSConst.ALIGNMENT_LEFT,
                            POSConst.FNT_BOLD,
                            POSConst.TXT_1WIDTH or POSConst.TXT_1HEIGHT
                        )
                    } catch (e: Exception) {
                        Toast.makeText(this, "${e.message}", Toast.LENGTH_LONG).show()
                    }

                    printer
                        .feedDot(2)
                        .feedLine(4)
                        .cutHalfAndFeed(1)

                    Toast.makeText(this, "Printed Invoice :$invoiceNo", Toast.LENGTH_SHORT).show()

                    eventSink?.success(UsbPrinterStatus.UsbPrintSuccess.name)


                } catch (e: Exception) {
                    Toast.makeText(this, "${e.message}", Toast.LENGTH_LONG).show()

                }
            }


        }

    }

    override fun onStatus(code: Int, message: String?) {
        when (code) {
            POSConnect.CONNECT_SUCCESS -> {
                eventSink?.success(UsbPrinterStatus.UsbConnected.name)
                Toast.makeText(context, "Connected", Toast.LENGTH_SHORT).show()
            }

            POSConnect.CONNECT_FAIL -> {
                eventSink?.success(UsbPrinterStatus.UsbDisconnected.name)
                Toast.makeText(context, "Connection Failed", Toast.LENGTH_SHORT).show()
            }

            POSConnect.CONNECT_INTERRUPT -> {
                eventSink?.success(UsbPrinterStatus.UsbDisconnected.name)
                Toast.makeText(context, "Connection interrupted", Toast.LENGTH_SHORT).show()
            }

            POSConnect.SEND_FAIL -> {
                eventSink?.success(UsbPrinterStatus.UsbPrintFailed.name)
                Toast.makeText(context, "Data send failed", Toast.LENGTH_SHORT).show()
            }

            POSConnect.USB_DETACHED -> {
                eventSink?.success(UsbPrinterStatus.UsbDisconnected.name)
                eventSink?.success(UsbPrinterStatus.UsbDetached.name)
                Toast.makeText(context, "Usb detached", Toast.LENGTH_SHORT).show()
            }

            POSConnect.USB_ATTACHED -> {
                eventSink?.success(UsbPrinterStatus.UsbAvailable.name)
                Toast.makeText(context, "Usb Attached", Toast.LENGTH_SHORT).show()
            }
        }
    }

    override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
        eventSink = events
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }


    private fun convertTextToImage(text: String, textWidth: Int = 384): Bitmap {
        val textPaint = TextPaint(Paint.ANTI_ALIAS_FLAG or Paint.LINEAR_TEXT_FLAG)
        textPaint.style = Paint.Style.FILL
        textPaint.color = Color.BLACK
        textPaint.textAlign = Paint.Align.LEFT
        textPaint.textSize = 32f
        textPaint.typeface = Typeface.create("sans-serif", Typeface.NORMAL)


        val mTextLayout =
            StaticLayout(text, textPaint, textWidth, Layout.Alignment.ALIGN_CENTER, 1f, 0f, false)


        val bitmap = Bitmap.createBitmap(textWidth, mTextLayout.height, Bitmap.Config.RGB_565)
        val canvas = Canvas(bitmap)

        val paint = Paint(Paint.ANTI_ALIAS_FLAG or Paint.LINEAR_TEXT_FLAG)
        paint.style = Paint.Style.FILL
        paint.color = Color.WHITE
        canvas.drawPaint(paint)

        canvas.save()
        canvas.translate(0f, 0f)

        mTextLayout.draw(canvas)
        canvas.restore()

        return bitmap


    }

    override fun receive(status: Int) {

    }
}



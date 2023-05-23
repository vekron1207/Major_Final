package com.example.authenti_kator20.util

import android.annotation.SuppressLint
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.widget.Toast
import androidx.camera.core.ImageAnalysis
import androidx.camera.core.ImageProxy
import androidx.core.content.ContextCompat.startActivity
import androidx.fragment.app.FragmentManager
import com.example.authenti_kator20.view.ShowDialouge
import com.google.mlkit.vision.barcode.Barcode
import com.google.mlkit.vision.barcode.BarcodeScannerOptions
import com.google.mlkit.vision.barcode.BarcodeScanning
import com.google.mlkit.vision.common.InputImage

class ImageAnalyzer(
    private val context: Context, private val fragmentManger: FragmentManager
) : ImageAnalysis.Analyzer {
    private var showDialog = ShowDialouge()

    override fun analyze(images: ImageProxy) {
        scanBarCode(images)
    }

    @SuppressLint("UnsafeOptInUsageError")
    private fun scanBarCode(images: ImageProxy) {
        images.image?.let { image ->
            val inputImage = InputImage.fromMediaImage(
                image, images.imageInfo.rotationDegrees
            )
            val scanner = BarcodeScanning.getClient(
                BarcodeScannerOptions.Builder()
                    .setBarcodeFormats(
                        Barcode.FORMAT_EAN_13,
                        Barcode.FORMAT_EAN_8,
                        Barcode.FORMAT_UPC_A,
                        Barcode.FORMAT_UPC_E,
                        Barcode.FORMAT_CODE_128,
                        Barcode.FORMAT_QR_CODE
                    )
                    .build()
            )
            scanner.process(inputImage).addOnCompleteListener {
                images.close()
                if (it.isSuccessful) {
                    readBarCode(it.result as List<Barcode>)
                } else {
                    it.exception?.printStackTrace()
                }
            }
        }
    }


    private fun readBarCode(barcode: List<Barcode>) {
        for (barcodes in barcode) {
            when (barcodes.valueType) {
                Barcode.TYPE_URL -> {
                    if (!showDialog.isAdded) {
                        showDialog.show(fragmentManger, "")
                        showDialog.updateUrl(barcodes.url?.url.toString())
                    }
                }
                Barcode.TYPE_PHONE -> {
                    val intent = Intent(Intent.ACTION_DIAL)
                    intent.data = Uri.parse("tel:${barcodes.rawValue}")
                    context.startActivity(intent)
                }
                Barcode.TYPE_EMAIL -> {
                    val intent = Intent(Intent.ACTION_SENDTO)
                    intent.data = Uri.parse("mailto:${barcodes.email?.address}")
                    context.startActivity(intent)
                }
                Barcode.TYPE_TEXT -> {
                    val text = barcodes.rawValue ?: ""
                    val toast = Toast.makeText(context, text, Toast.LENGTH_SHORT)
                    toast.show()
                    // Add code to copy text to clipboard
                    val clipboard = context.getSystemService(Context.CLIPBOARD_SERVICE) as ClipboardManager
                    val clip = ClipData.newPlainText("QR Code Text", text)
                    clipboard.setPrimaryClip(clip)
                }
            }
        }
    }
}

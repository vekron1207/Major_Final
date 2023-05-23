package com.example.authenti_kator20

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Button
import android.widget.Toast
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import com.example.authenti_kator20.databinding.ActivityHaveNotKeyBinding
import com.example.authenti_kator20.view.ScannerActivity

class HaveNotKeyActivity : AppCompatActivity() {

    private lateinit var binding: ActivityHaveNotKeyBinding
    private lateinit var btnScanner: Button
    private val REQUEST_CAMERA_PERMISSION = 101

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityHaveNotKeyBinding.inflate(layoutInflater)
        setContentView(binding.root)

        if (ContextCompat.checkSelfPermission(
                this@HaveNotKeyActivity, Manifest.permission.CAMERA
            ) != PackageManager.PERMISSION_GRANTED
        ) {
            askCameraPermission()
        } else {
            setUpControllers()
        }
        binding.haveKeyAlreadyTitle.setOnClickListener {
            startActivity(Intent(this, HaveKeyActivity::class.java))
        }
    }

    private fun askCameraPermission() {
        ActivityCompat.requestPermissions(
            this@HaveNotKeyActivity,
            arrayOf(Manifest.permission.CAMERA),
            REQUEST_CAMERA_PERMISSION
        )
    }

    private fun setUpControllers() {
        btnScanner = findViewById(R.id.btn_scan)
        btnScanner.setOnClickListener {
            startActivity(Intent(this, ScannerActivity::class.java))
        }
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == REQUEST_CAMERA_PERMISSION && grantResults.isNotEmpty()) {
            if (grantResults[0] == PackageManager.PERMISSION_GRANTED) {
                setUpControllers()
            } else {
                Toast.makeText(
                    this@HaveNotKeyActivity,
                    "Permission Denied",
                    Toast.LENGTH_SHORT
                ).show()
            }
        }
    }
}
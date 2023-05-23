package com.example.authenti_kator20

import android.annotation.SuppressLint
import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.widget.Toast
import com.example.authenti_kator20.databinding.ActivityHaveKeyBinding
import com.google.firebase.auth.FirebaseAuth
import com.google.firebase.database.DataSnapshot
import com.google.firebase.database.DatabaseError
import com.google.firebase.database.DatabaseReference
import com.google.firebase.database.FirebaseDatabase
import com.google.firebase.database.ServerValue
import com.google.firebase.database.ValueEventListener
import com.jakewharton.rxbinding2.widget.RxTextView
import java.util.*
import java.text.SimpleDateFormat
import java.util.Date

@SuppressLint("CheckResult")
class HaveKeyActivity : AppCompatActivity() {

    private lateinit var binding: ActivityHaveKeyBinding
    private lateinit var databaseRef: DatabaseReference

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityHaveKeyBinding.inflate(layoutInflater)
        databaseRef = FirebaseDatabase.getInstance("https://authenti-kator2-default-rtdb.firebaseio.com/").getReference("Nike_DB")
        setContentView(binding.root)

        // Serial Key Validation
        val serialKeyStream = RxTextView.textChanges(binding.etSerialKey)
            .skipInitialValue()
            .map { serialKey ->
                serialKey.isEmpty()
            }
        serialKeyStream.subscribe {
            showTextMinimalAlert(it, "Serial Key")
        }

        binding.tvHaveKey.setOnClickListener {
            startActivity(Intent(this, HaveNotKeyActivity::class.java))
        }

        binding.authenticateBtn.setOnClickListener {
            val serialNumber = binding.etSerialKey.text.toString().trim().toInt()
            val currentUser = FirebaseAuth.getInstance().currentUser?.uid
            databaseRef.orderByChild("serial_number").equalTo(serialNumber.toDouble()).addListenerForSingleValueEvent(object : ValueEventListener {
                override fun onDataChange(snapshot: DataSnapshot) {
                    if (snapshot.exists()) {
                        Log.d("HavekeyActivity", "Data from database: $snapshot")
                        snapshot.children.forEach { productSnapshot ->
                            val isAuthenticated = productSnapshot.child("isAuthenticated").value as Boolean
                            val productType = productSnapshot.child("product_type").value as String
                            val authenticatedBy = productSnapshot.child("authenticated_by").value as? String
                            val authenticatedAt = productSnapshot.child("authenticated_at").value as? Long
                            if (isAuthenticated && authenticatedBy == currentUser) {
                                // Product already authenticated by the current user
                                Toast.makeText(this@HaveKeyActivity, "Product is real", Toast.LENGTH_SHORT).show()
                            } else if (isAuthenticated && authenticatedBy != currentUser) {
                                // Product already authenticated by another user
                                val dateFormat = SimpleDateFormat("dd/MM/yyyy", Locale.US)
                                val activatedDate = if (authenticatedAt != null) dateFormat.format(Date(authenticatedAt)) else "Unknown"
                                Toast.makeText(this@HaveKeyActivity, "Product is already activated on $activatedDate", Toast.LENGTH_SHORT).show()
                            } else {
                                // Product not yet authenticated
                                databaseRef.child(productSnapshot.key!!).apply {
                                    child("isAuthenticated").setValue(true)
                                    child("authenticated_by").setValue(currentUser)
                                    child("authenticated_at").setValue(ServerValue.TIMESTAMP)
                                }
                                Toast.makeText(this@HaveKeyActivity, "Authentic $productType", Toast.LENGTH_SHORT).show()
                            }
                        }
                    } else {
                        Toast.makeText(this@HaveKeyActivity, "Fake product", Toast.LENGTH_SHORT).show()
                    }
                }
                override fun onCancelled(error: DatabaseError) {
                    Log.e("HavekeyActivity", "Error:${error.message} ")
                }
            })
        }
    }

    private fun showTextMinimalAlert(isNotValid: Boolean, fieldName: String) {
        if (fieldName == "Serial Key") {
            val regex = "\\d+".toRegex()
            val serialKey = binding.etSerialKey.text.toString()
            val isValid = serialKey.matches(regex)
            binding.etSerialKey.error = if (!isValid) {
                "Invalid $fieldName, please enter only numbers."
            } else if (isNotValid) {
                "$fieldName cannot be empty"
            } else {
                null
            }
        }
    }
}

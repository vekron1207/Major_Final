package com.example.authenti_kator20

import android.content.Intent
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.widget.Toast
import com.example.authenti_kator20.databinding.ActivityHomeBinding
import com.example.authenti_kator20.databinding.ActivityRegisterBinding
import com.google.firebase.auth.FirebaseAuth

class HomeActivity : AppCompatActivity() {

    private lateinit var binding: ActivityHomeBinding
    private lateinit var auth: FirebaseAuth

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        binding = ActivityHomeBinding.inflate(layoutInflater)
        setContentView(binding.root)
//  Auth
        auth = FirebaseAuth.getInstance()

        binding.btnLogout.setOnClickListener {
            auth.signOut()
            Intent(this, LoginActivity::class.java).also {
                it.flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK
                startActivity(it)
                Toast.makeText(this, "Logout Successful", Toast.LENGTH_SHORT).show()
            }
        }

        binding.homeHaveKey.setOnClickListener {
            startActivity(Intent(this, HaveKeyActivity::class.java))
        }

        binding.homeHaveNotKey.setOnClickListener {
            startActivity(Intent(this, HaveNotKeyActivity::class.java))
        }
    }
}
package com.noteapplication.android

import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import com.noteapplication.android.ui.game.GameFragment

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        if (savedInstanceState == null) {
            supportFragmentManager.beginTransaction()
                .replace(R.id.main_container, GameFragment.newInstance())
                .commitNow()
        }
    }
}

package com.noteapplication

class Greeting {
    fun greeting(): String {
        return "Hello, ${Platform().platform.reversed()}"
    }
}
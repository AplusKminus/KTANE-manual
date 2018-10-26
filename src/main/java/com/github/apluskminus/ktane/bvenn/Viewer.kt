package com.github.apluskminus.ktane.bvenn

import javafx.application.Application
import javafx.stage.Stage

class Viewer : Application() {

    override fun start(primaryStage: Stage) {
        primaryStage.scene = FormulaPainter(200.0, 3.0).x()
        primaryStage.show()
    }

    companion object {

        @JvmStatic
        fun main(args: Array<String>) {
            launch(Viewer::class.java)
        }
    }
}
package com.github.apluskminus.ktane.bvenn

import com.github.apluskminus.ktane.util.powerSet
import javafx.scene.Group
import javafx.scene.Scene
import javafx.scene.paint.Color
import javafx.scene.shape.Circle
import javafx.scene.shape.Shape
import java.lang.IllegalArgumentException
import java.util.*

class FormulaPainter(val canvasSize: Double, val strokeWidth: Double) {

    private val radius = 0.25 * canvasSize
    private val noneRadius = 0.3 * radius
    private val gray : Color = Color.rgb(180,174,163)
    private val red : Color = Color.rgb(222, 138, 116)
    private val green : Color = Color.rgb(160, 175, 132)

    fun x(): Scene {
        val root = Group()
        val scene = Scene(root, canvasSize, canvasSize, Color.LIGHTGRAY)

        val circleA = createOutline(ABC.A)
        val circleB = createOutline(ABC.B)
        val circleC = createOutline(ABC.C)

        val intersections = ABC.values().toList().powerSet()
        for (subSet in intersections) {
            val shape = createIntersection(subSet)
            shape.fill = if (Random().nextDouble() < 0.5) green else red
            root.children.add(shape)
        }

        val noneOutline = Circle(noneRadius)
        noneOutline.fill = Color.BLACK
        val noneInner = Circle(noneRadius - strokeWidth)
        noneOutline.centerX = canvasSize - 2 * noneRadius
        noneOutline.centerY = 2 * noneRadius
        noneInner.centerX = noneOutline.centerX
        noneInner.centerY = noneOutline.centerY

        root.children.add(Shape.subtract(noneOutline, noneInner))

        root.children.add(circleA)
        root.children.add(circleB)
        root.children.add(circleC)
        return scene
    }

    private fun createOutline(abc: ABC): Shape {
        val circle = createCircle(abc, radius)
        val inner = Circle(radius - strokeWidth)
        inner.centerX = circle.centerX
        inner.centerY = circle.centerY
        circle.fill = Color.BLACK
        return Shape.subtract(circle, inner)
    }

    private fun createCircle(abc: ABC, radius: Double): Circle {
        val circle = Circle(radius)
        val center = canvasSize / 2.0
        circle.centerX = abc.getCenterX(center, radius)
        circle.centerY = abc.getCenterY(center, radius)
        circle.fill = Color.BLACK
        return circle
    }

    private fun createIntersection(abcs: Set<ABC>): Shape {
        if (abcs.isEmpty()) {
            val circle = Circle(noneRadius - strokeWidth)
            circle.centerX = canvasSize - 2 * noneRadius
            circle.centerY = 2 * noneRadius
            return circle
        }
        val circles = mapOf(
                ABC.A to createCircle(ABC.A, radius),
                ABC.B to createCircle(ABC.B, radius),
                ABC.C to createCircle(ABC.C, radius))
        circles.values.forEach { it.radius = radius - strokeWidth }
        when {
            abcs.size == 3 -> return Shape.intersect(Shape.intersect(circles[ABC.A], circles[ABC.B]), circles[ABC.C])
            abcs.size == 2 && ABC.A !in abcs -> return Shape.subtract(Shape.intersect(circles[ABC.B], circles[ABC.C]), circles[ABC.A])
            abcs.size == 2 && ABC.B !in abcs -> return Shape.subtract(Shape.intersect(circles[ABC.A], circles[ABC.C]), circles[ABC.B])
            abcs.size == 2 && ABC.C !in abcs -> return Shape.subtract(Shape.intersect(circles[ABC.A], circles[ABC.B]), circles[ABC.C])
            abcs.size == 1 && ABC.A in abcs -> return Shape.subtract(Shape.subtract(circles[ABC.A], circles[ABC.B]), circles[ABC.C])
            abcs.size == 1 && ABC.B in abcs -> return Shape.subtract(Shape.subtract(circles[ABC.B], circles[ABC.A]), circles[ABC.C])
            abcs.size == 1 && ABC.C in abcs -> return Shape.subtract(Shape.subtract(circles[ABC.C], circles[ABC.B]), circles[ABC.A])
        }
        throw IllegalArgumentException("Unknown subset: $abcs")
    }

    companion object {
        private fun heightOfEquilateralTriangle(sideLength: Double): Double {
            return Math.sqrt(3.0) / 2.0 * sideLength
        }
    }

    enum class ABC {
        A, B, C;

        fun getCenterX(base: Double, radius: Double): Double {
            return when (this) {
                A -> base
                B -> base - radius / 2.0
                C -> base + radius / 2.0
            }
        }

        fun getCenterY(base: Double, radius: Double): Double {
            return when (this) {
                A -> base - heightOfEquilateralTriangle(radius) / 3.0 * 2.0
                B, C -> base + heightOfEquilateralTriangle(radius) / 3.0
            }
        }
    }
}
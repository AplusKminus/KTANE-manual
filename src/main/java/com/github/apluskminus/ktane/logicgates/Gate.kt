package com.github.apluskminus.ktane.logicgates

import org.logicng.formulas.Formula
import org.logicng.formulas.FormulaFactory
import java.lang.IllegalArgumentException

enum class Gate(val offset: Int, val applyFormula: (Formula, Formula) -> Formula, val compute: (Boolean, Boolean) -> Boolean) {

    AND(1, {x, y
        -> formulaFactory.and(x, y)},
            Boolean::and),
    OR(2, {x, y
        -> formulaFactory.or(x, y)},
            Boolean::or),
    XOR(3, {x, y
        -> formulaFactory.or(formulaFactory.and(x.negate(), y),formulaFactory.and(x, y.negate()))},
            Boolean::xor),
    NAND(4, {x, y
        -> formulaFactory.and(x, y).negate()},
            {a, b -> a.and(b).not()}),
    NOR(5, {x, y
        -> formulaFactory.or(x, y).negate()},
            {a, b -> a.or(b).not()}),
    XNOR(6, {x, y
        -> formulaFactory.or(formulaFactory.and(x.negate(), y),formulaFactory.and(x, y.negate())).negate()},
            {a, b -> a.xor(b).not()});

    fun add(other: Gate): Gate {
        return byOffset(this.offset + other.offset)
    }

    override fun toString(): String {
        return String.format("%4s", super.toString())
    }

    companion object {
        val formulaFactory = FormulaFactory()
        fun byOffset(offset: Int): Gate {
            return when((offset - 1) % 6 + 1) {
                1 -> AND
                2 -> OR
                3 -> XOR
                4 -> NAND
                5 -> NOR
                6 -> XNOR
                else -> throw IllegalArgumentException("Can't happen")
            }
        }
    }
}
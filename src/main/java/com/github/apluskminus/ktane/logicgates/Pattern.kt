package com.github.apluskminus.ktane.logicgates

import com.github.apluskminus.ktane.logicgates.Gate.Companion.formulaFactory
import org.logicng.formulas.Formula
import org.logicng.transformations.dnf.DNFFactorization
import org.logicng.transformations.qmc.QuineMcCluskeyAlgorithm
import kotlin.coroutines.experimental.buildSequence

class Pattern(stub: List<Gate>) {
    val size: Int = 7

    val gates: List<Gate>
    val start: List<Gate>

    val unsimplified: Formula
    val solution: Formula
    val truthDensity: Double

    init {
        if (!isValid(stub) || stub.size < 4) {
            throw IllegalArgumentException("Bad pattern: $stub")
        }
        gates = complete(stub)
        this.start = gates.subList(0, 4)
        val w = formulaFactory.variable("w")
        val x = formulaFactory.variable("x")
        val y = formulaFactory.variable("y")
        val z = formulaFactory.variable("z")
        unsimplified = gates[6].applyFormula(gates[4].applyFormula(w, x), gates[5].applyFormula(y, z)).transform(DNFFactorization())
        solution = QuineMcCluskeyAlgorithm.compute(unsimplified)
        val trueFalse = listOf(true, false)
        var truthCount = 0
        for (w in trueFalse) {
            for (x in trueFalse) {
                for (y in trueFalse) {
                    for (z in trueFalse) {
                        if (gates[6].compute(gates[4].compute(w, x), gates[5].compute(y, z))) {
                            truthCount++
                        }
                    }
                }
            }
        }
        truthDensity = truthCount / 16.0
    }

    operator fun get(i: Int): Gate {
        return gates[i]
    }


    private fun complete(stub: List<Gate>): List<Gate> {
        assert(stub.size >= 4)
        var pattern = stub
        while (pattern.size < size) {
            val baseOffset = (pattern.size - 4) * 2
            val newGate = calculateGate(pattern[baseOffset], pattern[baseOffset + 1], pattern)
            pattern = pattern.plus(newGate)
        }
        return pattern
    }

    private fun calculateGate(gateX: Gate, gateY: Gate, stub: List<Gate>): Gate {
        var gate = gateX.add(gateY)
        while (true) {
            if (isValid(stub.plus(gate))) {
                return gate
            }
            gate = gate.add(Gate.AND)
        }
    }

    fun printCSV(): String = "${gates[0].name},${gates[1].name},${gates[2].name},${gates[3].name},$solution"

    override fun toString(): String = "${String.format("%04.2f", truthDensity)} ${start}: ${solution}"

    companion object {
        private fun isValid(pattern: List<Gate>): Boolean = pattern.distinct().size >= pattern.size - 1

        val csvHeader = "GateA, GateB, GateC, GateD, Solution;"

        fun allPatterns() = buildSequence {
            for (a in 1..6) {
                for (b in 1..6) {
                    for (c in 1..6) {
                        for (d in 1..6) {
                            val stub = listOf(a, b, c, d).map(Gate.Companion::byOffset)
                            if (isValid(stub)) {
                                yield(Pattern(stub))
                            }
                        }
                    }
                }
            }
        }

        fun sorted(patterns: List<Pattern>): List<Pattern> {
            val retVal: MutableList<Pattern> = mutableListOf()
            for (a in Gate.values()) {
                for (b in Gate.values()) {
                    for (c in Gate.values()) {
                        val sortedByD = sortByGateD(patterns.filter { it[0] == a && it[1] == b && it[2] == c }.sortedBy { it[3].offset })
                        retVal.addAll(sortedByD)
                    }
                }
            }
            return retVal
        }

        private fun sortByGateD(patterns: List<Pattern>): List<Pattern> {
            val split: Map<Formula, List<Pattern>> = patterns.groupBy(Pattern::solution)
            // no duplicate formulas
            if (split.values.all { it.size == 1 }) {
                return patterns
            }
            // all duplicates are consecutive
            if (split.values.filter { it.size > 1 }.map { it.map { it[3].offset } }.all(::allConsecutive)) {
                return patterns
            }
            return split.values.sortedBy { it.minBy { it[3].offset }!![3].offset }.flatMap { it.sortedBy { it[3].offset } }
        }
    }
}
package com.github.apluskminus.ktane.logicgates

import java.util.Comparator

fun main(args: Array<String>) {
    val patterns = Pattern.allPatterns().toList()

    var bestOrder: List<Int> = listOf()
    var bestSort = patterns
    var bestScore = 0

    for (order in permute(listOf(0,1,2,3))) {
        val sorted = patterns.sortedWith(createComparator(order))
        val marker = 'a'
        val pair = markPatterns(sorted, marker)
        val newScore = pair.second - marker
        //println("Order: $order, score: $newScore")
        if (newScore > bestScore) {
            bestScore = newScore
            bestSort = sorted
            bestOrder = order
        }
    }
    //println(bestSort.joinToString("\n"))
    //println(bestOrder)
    val customSort = Pattern.sorted(patterns)
    println(customSort.map { it.printCSV() }.joinToString("\n"))

    /*val sorted = patterns.sortedWith(createComparator(listOf()))
    val marker = 'a'
    val pair = markPatterns(sorted, marker)
    val marked = pair.first
    println(pair.second - marker)
    println(marked.joinToString("\n"))
    println(marked.count { it.startsWith(" ").not() })*/
}

fun <T> permute(input: List<T>): List<List<T>> {
    if (input.size == 1) return listOf(input)
    val perms = mutableListOf<List<T>>()
    val toInsert = input[0]
    for (perm in permute(input.drop(1))) {
        for (i in 0..perm.size) {
            val newPerm = perm.toMutableList()
            newPerm.add(i, toInsert)
            perms.add(newPerm)
        }
    }
    return perms
}

fun markPatterns(sorted: List<Pattern>, marker: Char): Pair<List<String>, Char> {
    var dirty = false
    var marker1 = marker
    val list = sorted.map { it.toString() }.foldRight(emptyList<String>()) { pattern, acc ->
        if (acc.isNotEmpty()) {
            val previous = acc.last()
            if (previous.substring(previous.lastIndexOf(':') + 1).equals(pattern.substring(pattern.lastIndexOf(':') + 1))) {
                if (dirty) {
                    marker1++
                    dirty = false
                }
                acc.dropLast(1).plus("$marker1${previous.substring(1)}").plus("$marker1 $pattern")
            } else {
                dirty = true
                acc.plus("  $pattern")
            }

        } else {
            dirty = true
            acc.plus("  $pattern")
        }
    }
    return Pair(list, marker1)
}

fun createComparator(order: List<Int>): Comparator<Pattern> {
    return Comparator.comparing { pattern: Pattern -> pattern.gates[order[0]].offset }
            .thenComparing { pattern: Pattern -> pattern.gates[order[1]].offset }
            .thenComparing { pattern: Pattern -> pattern.gates[order[2]].offset }
            .thenComparing { pattern: Pattern -> pattern.gates[order[3]].offset }
}
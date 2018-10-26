package com.github.apluskminus.ktane.logicgates

fun allConsecutive(numbers: Collection<Int>): Boolean {
    if (numbers.isEmpty()) {
        return true
    }
    if (numbers.distinct().size < numbers.size) {
        return false
    }
    return (numbers.max()!!.minus(numbers.min()!!)) == numbers.size - 1
}
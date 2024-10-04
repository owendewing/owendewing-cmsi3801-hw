import java.io.BufferedReader
import java.io.FileReader
import java.io.IOException

fun change(amount: Long): Map<Int, Long> {
    require(amount >= 0) { "Amount cannot be negative" }

    val counts = mutableMapOf<Int, Long>()
    var remaining = amount
    for (denomination in listOf(25, 10, 5, 1)) {
        counts[denomination] = remaining / denomination
        remaining %= denomination
    }
    return counts
}

fun firstThenLowerCase(strings: List<String>, predicate: (String) -> Boolean): String? {
    return strings.firstOrNull(predicate)?.lowercase()
}

data class Say(val phrase: String) {
    fun and(nextPhrase: String): Say {
        return Say("$phrase $nextPhrase")
    }
}

fun say(phrase: String = ""): Say {
    return Say(phrase)
}

@Throws(IOException::class)
fun meaningfulLineCount(filename: String): Long {
    return BufferedReader(FileReader(filename)).use { reader ->
        reader.lines()
            .filter { line -> line.isNotBlank() && !line.trimStart().startsWith("#") }
            .count()
    }
}

data class Quaternion(val a: Double, val b: Double, val c: Double, val d: Double) {
    companion object {
        val ZERO = Quaternion(0.0, 0.0, 0.0, 0.0)
        val I = Quaternion(0.0, 1.0, 0.0, 0.0)
        val J = Quaternion(0.0, 0.0, 1.0, 0.0)
        val K = Quaternion(0.0, 0.0, 0.0, 1.0)
    }

    operator fun plus(other: Quaternion): Quaternion {
        return Quaternion(a + other.a, b + other.b, c + other.c, d + other.d)
    }

    operator fun times(other: Quaternion): Quaternion {
        return Quaternion(
            a * other.a - b * other.b - c * other.c - d * other.d,
            a * other.b + b * other.a + c * other.d - d * other.c,
            a * other.c - b * other.d + c * other.a + d * other.b,
            a * other.d + b * other.c - c * other.b + d * other.a
        )
    }

    fun coefficients(): List<Double> {
        return listOf(a, b, c, d)
    }

    fun conjugate(): Quaternion {
        return Quaternion(a, -b, -c, -d)
    }

    override fun toString(): String {
        val components = mutableListOf<String>()

        if (a != 0.0) components.add(a.toString())

        if (b != 0.0) {
            if (components.isNotEmpty() && b > 0) {
                components.add("+")
            }
            components.add(if (b == 1.0) "i" else if (b == -1.0) "-i" else "${b}i")
        }

        if (c != 0.0) {
            if (components.isNotEmpty() && c > 0) {
                components.add("+")
            }
            components.add(if (c == 1.0) "j" else if (c == -1.0) "-j" else "${c}j")
        }

        if (d != 0.0) {
            if (components.isNotEmpty() && d > 0) {
                components.add("+")
            }
            components.add(if (d == 1.0) "k" else if (d == -1.0) "-k" else "${d}k")
        }

        return if (components.isEmpty()) "0" else components.joinToString("")
    }
}


sealed interface BinarySearchTree {
    fun size(): Int
    fun contains(value: String): Boolean
    fun insert(value: String): BinarySearchTree

    data class Node(
        private val value: String,
        private val left: BinarySearchTree,
        private val right: BinarySearchTree
    ) : BinarySearchTree {
        private val nodeSize = 1 + left.size() + right.size()

        override fun size(): Int = nodeSize

        override fun contains(value: String): Boolean {
            return when {
                this.value == value -> true
                value < this.value -> left.contains(value)
                else -> right.contains(value)
            }
        }

        override fun insert(value: String): BinarySearchTree {
            return when {
                value < this.value -> Node(this.value, left.insert(value), right)
                value > this.value -> Node(this.value, left, right.insert(value))
                else -> this
            }
        }

        override fun toString(): String {
            val leftStr = left.toString()
            val rightStr = right.toString()

            return when {
                leftStr == "()" && rightStr == "()" -> "($value)"
                rightStr == "()" -> "($leftStr$value)"
                leftStr == "()" -> "($value$rightStr)"
                else -> "($leftStr$value$rightStr)"
            }
        }
    }

    object Empty : BinarySearchTree {
        override fun size(): Int = 0
        override fun contains(value: String): Boolean = false
        override fun insert(value: String): BinarySearchTree = Node(value, this, this)
        override fun toString(): String = "()"
    }
}
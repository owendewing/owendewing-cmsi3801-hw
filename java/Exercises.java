import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Optional;
import java.util.function.Predicate;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

public class Exercises {
    static Map<Integer, Long> change(long amount) {
        if (amount < 0) {
            throw new IllegalArgumentException("Amount cannot be negative");
        }
        var counts = new HashMap<Integer, Long>();
        for (var denomination : List.of(25, 10, 5, 1)) {
            counts.put(denomination, amount / denomination);
            amount %= denomination;
        }
        return counts;
    }

    public static Optional<String> firstThenLowerCase(List<String> strings, Predicate<String> predicate) {
        return strings.stream()
                .filter(predicate)
                .findFirst()
                .map(String::toLowerCase);
    }

    static record Sayer(String phrase) {
        Sayer and(String word) {
            return new Sayer(phrase == null ? word : phrase + " " + word);
        };
    }

    public static Sayer say() {
        return new Sayer("");
    }

    public static Sayer say(String word) {
        return new Sayer(word);
    }

    public static int meaningfulLineCount(String filename) throws IOException {
        try (var reader = new BufferedReader(new FileReader(filename))) {
            return (int) reader.lines()
                    .filter(line -> !line.trim().isEmpty() && !line.trim().startsWith("#"))
                    .count();
        }
    }
}

record Quaternion(double a, double b, double c, double d) {

    public static final Quaternion ZERO = new Quaternion(0, 0, 0, 0);
    public static final Quaternion I = new Quaternion(0, 1, 0, 0);
    public static final Quaternion J = new Quaternion(0, 0, 1, 0);
    public static final Quaternion K = new Quaternion(0, 0, 0, 1);

    public Quaternion {
        if (Double.isNaN(a) || Double.isNaN(b) || Double.isNaN(c) || Double.isNaN(d)) {
            throw new IllegalArgumentException("Coefficients cannot be NaN");
        }
    }

    public Quaternion plus(Quaternion other) {
        return new Quaternion(
                this.a + other.a,
                this.b + other.b,
                this.c + other.c,
                this.d + other.d);
    }

    public Quaternion times(Quaternion other) {
        return new Quaternion(
                this.a * other.a - this.b * other.b - this.c * other.c - this.d * other.d,
                this.a * other.b + this.b * other.a + this.c * other.d - this.d * other.c,
                this.a * other.c - this.b * other.d + this.c * other.a + this.d * other.b,
                this.a * other.d + this.b * other.c - this.c * other.b + this.d * other.a);
    }

    public List<Double> coefficients() {
        return List.of(a, b, c, d);
    }

    public Quaternion conjugate() {
        return new Quaternion(a, -b, -c, -d);
    }

    @Override
    public String toString() {
        List<String> components = new ArrayList<>();

        if (a != 0)
            components.add(String.valueOf(a));

        if (b != 0) {
            if (!components.isEmpty() && b > 0) {
                components.add("+");
            }
            components.add(b == 1 ? "i" : b == -1 ? "-i" : b + "i");
        }

        if (c != 0) {
            if (!components.isEmpty() && c > 0) {
                components.add("+");
            }
            components.add(c == 1 ? "j" : c == -1 ? "-j" : c + "j");
        }

        if (d != 0) {
            if (!components.isEmpty() && d > 0) {
                components.add("+");
            }
            components.add(d == 1 ? "k" : d == -1 ? "-k" : d + "k");
        }

        return components.isEmpty() ? "0" : String.join("", components);
    }

}

sealed interface BinarySearchTree permits Node, Empty {
    int size();

    boolean contains(String value);

    BinarySearchTree insert(String value);
}

final class Node implements BinarySearchTree {
    private final String value;
    private final BinarySearchTree left;
    private final BinarySearchTree right;
    private final int size;

    Node(String value, BinarySearchTree left, BinarySearchTree right) {
        this.value = value;
        this.left = left;
        this.right = right;
        this.size = 1 + left.size() + right.size();
    }

    @Override
    public int size() {
        return size;
    }

    @Override
    public boolean contains(String value) {
        if (this.value.equals(value)) {
            return true;
        } else if (value.compareTo(this.value) < 0) {
            return left.contains(value);
        } else {
            return right.contains(value);
        }
    }

    @Override
    public BinarySearchTree insert(String value) {
        if (value.compareTo(this.value) < 0) {
            return new Node(this.value, left.insert(value), right);
        } else {
            return new Node(this.value, left, right.insert(value));
        }
    }

    @Override
    public String toString() {
        String leftStr = left.toString();
        String rightStr = right.toString();

        if (left instanceof Empty && right instanceof Empty) {
            return "(" + value + ")";
        } else if (right instanceof Empty) {
            return "(" + leftStr + value + ")";
        } else if (left instanceof Empty) {
            return "(" + value + rightStr + ")";
        } else {
            return "(" + leftStr + value + rightStr + ")";
        }
    }
}

final class Empty implements BinarySearchTree {
    public Empty() {

    }

    @Override
    public int size() {
        return 0;
    }

    @Override
    public boolean contains(String value) {
        return false;
    }

    @Override
    public BinarySearchTree insert(String value) {
        return new Node(value, this, this);
    }

    @Override
    public String toString() {
        return "()";
    }

}

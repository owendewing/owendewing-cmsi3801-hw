import Foundation

struct NegativeAmountError: Error {}
struct NoSuchFileError: Error {}

func change(_ amount: Int) -> Result<[Int: Int], NegativeAmountError> {
    if amount < 0 {
        return .failure(NegativeAmountError())
    }

    var (counts, remaining) = ([Int: Int](), amount)
    for denomination in [25, 10, 5, 1] {
        (counts[denomination], remaining) =
            remaining.quotientAndRemainder(dividingBy: denomination)
    }
    return .success(counts)
}

func firstThenLowerCase(of strings: [String], satisfying predicate: (String) -> Bool) -> String? {
    return strings.first(where: predicate)?.lowercased()
}

struct Sayer {
    let phrase: String?

    func and(_ word: String) -> Sayer {
        if phrase == nil {
            return Sayer(phrase: word)
        }
        return Sayer(phrase: phrase! + " " + word)
    }
}

func say(_ word: String = "") -> Sayer {
    return Sayer(phrase: word)
}

func meaningfulLineCount(_ filename: String) async -> Result<Int, Error> {
    do {
        let fileContent = try await String(contentsOfFile: filename)
        let lines = fileContent.split(separator: "\n")

        let count = lines.filter { line in
            !line.trimmingCharacters(in: .whitespaces).isEmpty && !line.trimmingCharacters(in: .whitespaces).hasPrefix("#")
        }.count

        return .success(count)

    } catch {
        return .failure(error)
    }
}

struct Quaternion: CustomStringConvertible, Equatable {
    let a: Double
    let b: Double
    let c: Double
    let d: Double

    static let ZERO = Quaternion(a: 0, b: 0, c: 0, d: 0)
    static let I = Quaternion(a: 0, b: 1, c: 0, d: 0)
    static let J = Quaternion(a: 0, b: 0, c: 1, d: 0)
    static let K = Quaternion(a: 0, b: 0, c: 0, d: 1)

    init(a: Double = 0, b: Double = 0, c: Double = 0, d: Double = 0) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
    }

    static func + (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        return Quaternion(a: lhs.a + rhs.a, b: lhs.b + rhs.b, c: lhs.c + rhs.c, d: lhs.d + rhs.d)
    }

    static func * (lhs: Quaternion, rhs: Quaternion) -> Quaternion {
        let a = lhs.a * rhs.a - lhs.b * rhs.b - lhs.c * rhs.c - lhs.d * rhs.d
        let b = lhs.a * rhs.b + lhs.b * rhs.a + lhs.c * rhs.d - lhs.d * rhs.c
        let c = lhs.a * rhs.c - lhs.b * rhs.d + lhs.c * rhs.a + lhs.d * rhs.b
        let d = lhs.a * rhs.d + lhs.b * rhs.c - lhs.c * rhs.b + lhs.d * rhs.a
        return Quaternion(a: a, b: b, c: c, d: d)
    }

    var coefficients: [Double] {
        return [a, b, c, d]
    }

    var conjugate: Quaternion {
        return Quaternion(a: a, b: -b, c: -c, d: -d)
    }

    var description: String {
        var components: [String] = []

        if a != 0 {
            components.append("\(a)")
        }

        if b != 0 {
            let part = (b == 1 ? "i" : (b == -1 ? "-i" : "\(b)i"))
            if b > 0 && !components.isEmpty {
                components.append("+\(part)")
            } else {
                components.append(part)
            }
        }

        if c != 0 {
            let part = (c == 1 ? "j" : (c == -1 ? "-j" : "\(c)j"))
            if c > 0 && !components.isEmpty {
                components.append("+\(part)")
            } else {
                components.append(part)
            }
        }

        if d != 0 {
            let part = (d == 1 ? "k" : (d == -1 ? "-k" : "\(d)k"))
            if d > 0 && !components.isEmpty {
                components.append("+\(part)")
            } else {
                components.append(part)
            }
        }

        return components.isEmpty ? "0" : components.joined()
    }
}

indirect enum BinarySearchTree: CustomStringConvertible, Equatable {
    case node(left: BinarySearchTree, value: String, right: BinarySearchTree)
    case empty

    var size: Int {
        switch self {
        case .empty:
            return 0
        case let .node(left, _, right):
            return 1 + left.size + right.size
        }
    }

    func contains(_ value: String) -> Bool {
        switch self {
        case .empty:
            return false
        case let .node(left, nodeValue, right):
            if nodeValue == value {
                return true
            } else if value < nodeValue {
                return left.contains(value)
            } else {
                return right.contains(value)
            }
        }
    }

    func insert(_ value: String) -> BinarySearchTree {
        switch self {
        case .empty:
            return .node(left: .empty, value: value, right: .empty)
        case let .node(left, nodeValue, right):
            if value < nodeValue {
                return .node(left: left.insert(value), value: nodeValue, right: right)
            } else if value > nodeValue {
                return .node(left: left, value: nodeValue, right: right.insert(value))
            } else {
                return self
            }
        }
    }

    var description: String {
        switch self {
        case let .node(left, nodeValue, right):
            let leftDesc = left == .empty ? "" : left.description
            let rightDesc = right == .empty ? "" : right.description
            return "(\(leftDesc)\(nodeValue)\(rightDesc))"
        case .empty:
            return "()"
        }
    }
}

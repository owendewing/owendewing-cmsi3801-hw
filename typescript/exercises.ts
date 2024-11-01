import { open } from "node:fs/promises"

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let counts: Map<bigint, bigint> = new Map()
  let remaining = amount
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination)
    remaining %= denomination
  }
  return counts
}

export function firstThenApply<T, U>(a: T[], predicate: (item: T) => boolean, f: (item: T) => U): U | undefined {
  const found = a.find(predicate);
  return found !== undefined ? f(found) : undefined;
}

export function* powersGenerator(base: bigint): Generator<bigint> {
  let power = 1n;
  for (let i = 0; ; i++) {
    yield power;
    power *= base;
  }
}

export async function meaningfulLineCount(filename: string): Promise<number> {
  let count = 0;
  const file = await open(filename, "r");
  for await (const line of file.readLines()) {
    const trimmed = line.trim();
    if (trimmed && !trimmed.startsWith("#")) {
      count++;
    }
  }
  return count;
}

interface Sphere {
  kind: "Sphere";
  radius: number;
}

interface Box {
  kind: "Box";
  width: number;
  length: number;
  depth: number;
}

export type Shape = Sphere | Box;

export function surfaceArea(shape: Shape): number {
  if (shape.kind === "Sphere") {
    return 4 * Math.PI * shape.radius * shape.radius;
  }
  if (shape.kind === "Box") {
    return (
    (2 * shape.width * shape.length) +
    (2 * shape.length * shape.depth) +
    (2 * shape.width * shape.depth)
    );
  }
  return 0;
}

export function volume(shape: Shape): number {
  if (shape.kind === "Sphere") {
    return (4 / 3) * Math.PI * shape.radius * shape.radius * shape.radius;
  }
  if (shape.kind === "Box") {
    return shape.width * shape.length * shape.depth;
  }
  return 0;
}

export interface BinarySearchTree<T> {
  size(): number;
  insert(value: T): BinarySearchTree<T>;
  contains(value: T): boolean;
  inorder(): Iterable<T>;
  toString(): string;
}

class Node<T> implements BinarySearchTree<T> {
  constructor(
    private value: T,
    private left: BinarySearchTree<T> = new Empty<T>(),
    private right: BinarySearchTree<T> = new Empty<T>()
  ) {}

  size(): number {
    return 1 + this.left.size() + this.right.size();
  }

  insert(value: T): BinarySearchTree<T> {
    if (value < this.value) {
      return new Node(this.value, this.left.insert(value), this.right);
    }
    else if (value > this.value) {
      return new Node(this.value, this.left, this.right.insert(value))
    }
    return this;
  }

  contains(value: T): boolean {
      if (value < this.value) {
        return this.left.contains(value);
      } else if (value > this.value) {
        return this.right.contains(value);
      }
      return true;
  }

  *inorder(): Iterable<T> {
    yield* this.left.inorder();
    yield this.value
    yield* this.right.inorder();
  }

  toString(): string {
    const leftString = this.left.toString();
    const rightString = this.right.toString();
    if (leftString === "()" && rightString === "()") {
      return `(${this.value})`;
    }
    if (rightString === "()") {
      return `(${leftString}${this.value})`;
    }
    if (leftString === "()") {
      return `(${this.value}${rightString})`;
    }
    return `(${leftString}${this.value}${rightString})`;
  }
}

export class Empty<T> implements BinarySearchTree<T> {
  size(): number {
    return 0;
  }
  insert(value: T): BinarySearchTree<T> {
    return new Node(value);
  }
  contains(value: T): boolean {
    return false;
  }
  *inorder(): Iterable<T> {
    return;
  }
  toString(): string {
    return "()";
  }
}

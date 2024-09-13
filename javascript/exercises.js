import { open } from "node:fs/promises"

export function change(amount) {
  if (!Number.isInteger(amount)) {
    throw new TypeError("Amount must be an integer")
  }
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let [counts, remaining] = [{}, amount]
  for (const denomination of [25, 10, 5, 1]) {
    counts[denomination] = Math.floor(remaining / denomination)
    remaining %= denomination
  }
  return counts
}

export function firstThenLowerCase(array, predicate) {
    for (let i = 0; i < array.length; i++) {
      if (predicate?.(array[i])) {
        return array[i]?.toLowerCase();
      }
    }
    return undefined;
  }

export function* powersGenerator({ofBase, upTo}){
  for (let i = 0; i <= upTo; i++){
    const power = Math.pow(ofBase,i)
    if (power > upTo) {
      return;
    }
    yield power;
  }
  return undefined;
}

export function say(word) {
  if (word === undefined) {
    return ""
  }
  return function(nextWord) {
    if (nextWord === undefined) {
      return word;
    }
    return say(word + " " + nextWord);
  };
}

export async function meaningfulLineCount(fileName) {
  let file;
  let lineNumber = 0;
  try {
    file = await open(fileName, "r");
    for await (const line of file.readLines()) {
      const singleLine = line.toString().trim();
      if (singleLine !== "" && !singleLine.startsWith("#")) {
        lineNumber++;
      }
    }
  } catch(error) {
    console.log("No such file");
    throw error;
  }
    finally {
    await file.close();
  }
  return lineNumber;
}


export class Quaternion{
  constructor(a,b,c,d) {
    Object.assign(this, {a,b,c,d});
    Object.freeze(this);
  }

  toString() {
    const total = [];
    if(this.a !== 0 || !(this.b || this.c || this.d)){
      total.push(this.a.toString());
    }
    if (this.b !== 0) {
      total.push((this.b < 0 ? this.b.toString() : `+${this.b}`) + "i");
    }
    if (this.c !== 0) {
      total.push((this.c < 0 ? this.c.toString() : `+${this.c}`) + "j");
    }
    if (this.d !== 0) {
      total.push((this.d < 0 ? this.d.toString() : `+${this.d}`) + "k");
    }
    let result = total.length ? total.join('') : '0';
    if (result.startsWith('+')) {
      result = result.substring(1);
    }
    const onesInResult = ["1i", "1j", "1k", "-1i", "-1j", "-1k"];
    for (let term of onesInResult) {
      result = result.replace(term, term.slice(-1));
    }
    return result;
  }

  plus(q) {
    return new Quaternion(
      this.a + q.a,
      this.b + q.b,
      this.c + q.c,
      this.d + q.d
    );
  }

  times(q) {
    const a = this.a * q.a - this.b * q.b - this.c * q.c - this.d * q.d;
    const b = this.a * q.b + this.b * q.a + this.c * q.d - this.d * q.c;
    const c = this.a * q.c - this.b * q.d + this.c * q.a + this.d * q.b;
    const d = this.a * q.d + this.b * q.c - this.c * q.b + this.d * q.a;
    return new Quaternion(a, b, c, d);
  }

  get conjugate() {
    return new Quaternion(
      this.a,
      this.b * -1,
      this.c * -1,
      this.d * -1
    );
  }

  get coefficients() {
    return [this.a, this.b, this.c, this.d];
  }
}

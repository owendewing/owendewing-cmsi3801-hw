from dataclasses import dataclass
from collections.abc import Callable
from typing import Callable, List, Optional, Generator

def change(amount: int) -> dict[int, int]:
    if not isinstance(amount, int):
        raise TypeError('Amount must be an integer')
    if amount < 0:
        raise ValueError('Amount cannot be negative')
    counts, remaining = {}, amount
    for denomination in (25, 10, 5, 1):
        counts[denomination], remaining = divmod(remaining, denomination)
    return counts


def first_then_lower_case(array: List[str], predicate: Callable[[str], bool]) -> Optional[str]:
    for i in array:
        if predicate(i):
            return i.lower()
    return None

def powers_generator(*, base: int, limit: int) -> Generator[int, None, None]:
    num = 0
    while True:
        power = base ** num
        if power > limit:
            break
        yield power
        num +=1

def say(word: Optional[str] = None) -> Callable[[Optional[str]],str]:
    if word is None:
        return ""
    def next(next_word: Optional[str] = None) -> str:
        if next_word is None:
            return word
        return say(word + " " + next_word)
    return next


def meaningful_line_count(filename: str) -> int:
    line_number = 0
    try:
        with open(filename, 'r', encoding='utf-8') as file:
            for line in file:
                stripped_line = line.strip()
                if stripped_line != "" and not stripped_line.startswith("#"):
                    line_number += 1
    except FileNotFoundError:
        raise FileNotFoundError(f"No such file: '{filename}'")
    return line_number

@dataclass(frozen=True)
class Quaternion:
    a: float
    b: float
    c: float
    d: float

    def __add__(self, q):
        return Quaternion(self.a + q.a, self.b + q.b, self.c + q.c, self.d + q.d)

    def __mul__(self, q):
        return Quaternion(
            self.a * q.a - self.b * q.b - self.c * q.c - self.d * q.d,
            self.a * q.b + self.b * q.a + self.c * q.d - self.d * q.c,
            self.a * q.c - self.b * q.d + self.c * q.a + self.d * q.b,
            self.a * q.d + self.b * q.c - self.c * q.b + self.d * q.a
        )

    def __eq__(self, q):
        return self.a == q.a and self.b == q.b and self.c == q.c and self.d == q.d

    def __str__(self):
        total = []
        if self.a != 0 or not any([self.b, self.c, self.d]):
            total.append(f"{self.a}")
        if self.b != 0:
            if self.b < 0:
                total.append(f"{self.b}i")
            else:
                total.append(f"+{self.b}i")
        if self.c != 0:
            if self.c < 0:
                total.append(f"{self.c}j")
            else:
                total.append(f"+{self.c}j")
        if self.d != 0:
            if self.d < 0:
                total.append(f"{self.d}k")
            else:
                total.append(f"+{self.d}k")
        result = ''.join(total) if total else '0'
        if result.startswith('+'):
            result = result[1:]
        ones_in_result = ["1i","1j","1k","-1i","-1j","-1k","1.0i","1.0j","1.0k","-1.0i","-1.0j","-1.0k"]
        for term in ones_in_result:
            result = result.replace(term, term[-1])
        return result

    @property
    def coefficients(self):
        return (self.a, self.b, self.c, self.d)

    @property
    def conjugate(self):
        return Quaternion(self.a, self.b * -1, self.c * -1, self.d * -1)

from magma.bitutils import int2seq, seq2int
import silica
from counter import Counter

@silica.coroutine
def ROM(init):
    memory = init
    O = memory[0]
    while True:
        addr = yield O
        O = memory[addr.as_int()]


if __name__ == "__main__":
    counter = Counter(2)  # 2-bit counter
    rom = ROM([int2seq(x) for x in [0xDE, 0xAD, 0xBE, 0xEF]])
    for i in range(8):
        print(f"{seq2int(rom.send(counter.O)):x}")
        next(counter)

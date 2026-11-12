# bend2

A port of [Bend 2](https://github.com/bendlang/bend) to
[Substrate](https://github.com/substrate-lang/substrate): its dependently typed
language as s-expressions, with its type checker and part of its Base library.
Bend 2 is licensed under Apache-2.0, and so is this port.

    substrate test -A                # the tests
    bench/compile/run.sh [N] [RUNS]  # checking and compiling a generated module of N proofs (3200), with GNU time

The bench runs the substrate command, and SUBSTRATE=path/to/substrate/bin/substrate
runs it with a checkout instead.

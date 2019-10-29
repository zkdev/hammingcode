% Copyright DonkeyCo

implement main
    open core

clauses
    run() :-
        console::init(),
        stdio::write("The following Bitstring is being encoded: 0110001 \n"),
        encode([0, 1, 1, 0, 0, 0, 1], Result),
        stdio::write("Encoded Bit Sequence: "),
        stdio::write(Result),
        !.
    run().

    encode([], []).
    encode(Bitstring, Result) :-
        iterate_paritybits(Bitstring, 0, Paritybits),
        concatBits(1, 0, Bitstring, Paritybits, Result).

    iterate_paritybits(_, 4, []).
    iterate_paritybits(Bitstring, Counter, Result) :-
        Counter < 4,
        Counter2 = Counter + 1,
        calculate_paritybit(Bitstring, Counter, 1, Bit),
        iterate_paritybits(Bitstring, Counter2, Restbits),
        Result = [Bit | Restbits].

    calculate_paritybit([], _, _, 0).
    calculate_paritybit([Value], Paritypos, Counter, Paritybit) :-
        parity_positions(Paritypos, Counter, Value, NV),
        Paritybit = NV.
    calculate_paritybit([Value | Rest], Paritypos, Counter, Paritybit) :-
        parity_positions(Paritypos, Counter, Value, NV),
        Counter2 = Counter + 1,
        calculate_paritybit(Rest, Paritypos, Counter2, Tempbit),
        ParitybitNonMod = NV + Tempbit,
        Paritybit = ParitybitNonMod mod 2.

    concatBits(_, _, [], [], []).
    concatBits(Counter, PCounter, Bitstring, [P1 | PRest], Encoded) :-
        Counter < 16,
        pow(2, PCounter, 0, Power),
        Counter = Power,
        Counter2 = Counter + 1,
        PCounter2 = PCounter + 1,
        concatBits(Counter2, PCounter2, Bitstring, PRest, EncRest),
        Encoded = [P1 | EncRest].
    concatBits(Counter, PCounter, [B1 | Rest], Parity, Encoded) :-
        Counter < 16,
        pow(2, PCounter, 0, Power),
        Counter <> Power,
        Counter2 = Counter + 1,
        concatBits(Counter2, PCounter, Rest, Parity, EncRest),
        Encoded = [B1 | EncRest].

    pow(_, 0, _, 1).
    pow(Base, 1, _, Base).
    pow(Base, N, 0, Result) :-
        pow(Base, N, 1, Result2),
        Result = Base * Result2.
    pow(Base, N, C, Result) :-
        C < N,
        C2 = C + 1,
        pow(Base, N, C2, Result2),
        Result = Base * Result2.
    pow(_, N, C, Result) :-
        C >= N,
        Result = 1.

/* Summands for Parity Bit 1*/
    parity_positions(0, 1, V, V).
    parity_positions(0, 2, V, V).
    parity_positions(0, 4, V, V).
    parity_positions(0, 5, V, V).
    parity_positions(0, 7, V, V).
    parity_positions(0, X, _, V) :-
        X <> 1,
        X <> 2,
        X <> 4,
        X <> 5,
        X <> 7,
        V = 0.

/* Summands for Parity Bit 2 */
    parity_positions(1, 1, V, V).
    parity_positions(1, 3, V, V).
    parity_positions(1, 4, V, V).
    parity_positions(1, 6, V, V).
    parity_positions(1, 7, V, V).
    parity_positions(1, X, _, V) :-
        X <> 1,
        X <> 3,
        X <> 4,
        X <> 6,
        V = 0.

/* Summands for Parity Bit 3 */
    parity_positions(2, 2, V, V).
    parity_positions(2, 3, V, V).
    parity_positions(2, 4, V, V).
    parity_positions(2, X, _, V) :-
        X <> 2,
        X <> 3,
        X <> 4,
        V = 0.

/* Summands for Parity Bit 4 */
    parity_positions(3, 5, V, V).
    parity_positions(3, 6, V, V).
    parity_positions(3, 7, V, V).
    parity_positions(3, X, _, V) :-
        X <> 5,
        X <> 6,
        X <> 7,
        V = 0.

end implement main

goal
    mainExe::run(main::run).

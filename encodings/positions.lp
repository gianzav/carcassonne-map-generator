% row and col are theory atoms that represent the position of each tile
rows(72). cols(72).
&diff{row(T)} >= 1 :- tile(T).
&diff{row(T)} <= R :- rows(R), tile(T).
&diff{col(T)} >= 1 :- tile(T).
&diff{col(T)} <= C :- cols(C), tile(T).
:- tile(T), tile(T'), T < T', &diff{row(T)} = row(T'), &diff{col(T)} = col(T').
:- aboveof(T,T'), not &diff{row(T')} = row(T) + 1, not &diff{col(T')} = col(T).
:- belowof(T,T'), not &diff{row(T')} = row(T) - 1, not &diff{col(T')} = col(T).
:- leftof(T,T'), not &diff{col(T')} = col(T) + 1, not &diff{row(T')} = row(T).
:- rightof(T,T'), not &diff{col(T')} = col(T) - 1, not &diff{row(T')} = row(T).

tile(T) :- tile(T,_,_,_,_).
num_tiles(N) :- N = #count{T : tile(T)}.

%% 1. Rotation symmetry of a single tile: tiles whose rotated edge tuples coincide
%%    (e.g. all-equal edges, or 180°-symmetric tiles) keep only the smallest rotation.
rt(T,0,  (A,B,C,D)) :- tile(T,A,B,C,D).
rt(T,90, (D,A,B,C)) :- tile(T,A,B,C,D).
rt(T,180,(C,D,A,B)) :- tile(T,A,B,C,D).
rt(T,270,(B,C,D,A)) :- tile(T,A,B,C,D).
% generate possible rotation only if such rotation doesn't yield the original tile
not_rotate(T,R) :- rt(T,R,S), rt(T,R',S), R' < R, R > 0.
{rotate(T,R)} :- rt(T,R,S), not not_rotate(T,R).
:- tile(T), rotate(T,R), rotate(T,R'), R < R'.
:- rotate(T,R), rt(T,R,S), rt(T,R',S), R' < R.

down(T,D) :- tile(T, D, _, _, _), rotate(T,0).
left(T,L) :- tile(T, _, L, _, _), rotate(T,0).
up(T,U)   :- tile(T, _, _, U, _), rotate(T,0).
right(T,R):- tile(T, _, _, _, R), rotate(T,0).

down(T,D) :- tile(T, _, _, _, D), rotate(T,90).
left(T,L) :- tile(T, L, _, _, _), rotate(T,90).
up(T,U)   :- tile(T, _, U, _, _), rotate(T,90).
right(T,R):- tile(T, _, _, R, _), rotate(T,90).

down(T,D) :- tile(T, _, _, D, _), rotate(T,180).
left(T,L) :- tile(T, _, _, _, L), rotate(T,180).
up(T,U)   :- tile(T, U, _, _, _), rotate(T,180).
right(T,R):- tile(T, _, R, _, _), rotate(T,180).

down(T,D) :- tile(T, _, _, _, D), rotate(T,270).
left(T,L) :- tile(T, L, _, _, _), rotate(T,270).
up(T,U)   :- tile(T, _, U, _, _), rotate(T,270).
right(T,R):- tile(T, _, _, R, _), rotate(T,270).

step(1..N) :- num_tiles(N).

place(1,T) :- T = #min{X : tile(X)}.
place(N,T) :- pos(_,N,T,_).

{pos(leftof ,N,T',T)} :- place(N-1,T), tile(T), step(N-1), step(N), right(T',X), left(T,X), not place(N-1,T').
{pos(rightof,N,T',T)} :- place(N-1,T), tile(T), step(N-1), step(N), left(T',X), right(T,X), not place(N-1,T').
{pos(aboveof,N,T',T)} :- place(N-1,T), tile(T), step(N-1), step(N), down(T',X),    up(T,X), not place(N-1,T').
{pos(belowof,N,T',T)} :- place(N-1,T), tile(T), step(N-1), step(N), up(T',X), down(T,X), not place(N-1,T').

place(N,T) :- place(N-1,T), step(N-1), step(N).
:- tile(T), not place(N,T), num_tiles(N).

:- pos(X,N,T1,T), pos(X,N,T2,T), T1 < T2.

#show pos/4.

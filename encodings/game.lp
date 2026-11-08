%% 1. Rotation symmetry of a single tile: tiles whose rotated edge tuples coincide
%%    (e.g. all-equal edges, or 180°-symmetric tiles) keep only the smallest rotation.
rt(T,0,  (A,B,C,D)) :- tile(T,A,B,C,D).
rt(T,90, (D,A,B,C)) :- tile(T,A,B,C,D).
rt(T,180,(C,D,A,B)) :- tile(T,A,B,C,D).
rt(T,270,(B,C,D,A)) :- tile(T,A,B,C,D).
% generate possible rotation only if such rotation doesn't yield the original tile
rotate(1,0).
not_rotate(T,R) :- rt(T,R,S), rt(T,R',S), R' < R, R > 0, T > 1.
1 {rotate(T,R) : rt(T,R,_), not not_rotate(T,R)} 1 :- tile(T), T > 1.

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

down(T,D) :- tile(T, _, D, _, _), rotate(T,270).
left(T,L) :- tile(T, _, _, L, _), rotate(T,270).
up(T,U)   :- tile(T, _, _, _, U), rotate(T,270).
right(T,R):- tile(T, R, _, _, _), rotate(T,270).

tile(T) :- tile(T,_,_,_,_).

{place(aboveof,T,T')} :- down(T,X), up(T',X), T != T'.
{place(leftof,T,T')}  :- right(T,X), left(T',X), T != T'.
{place(belowof,T,T')} :- up(T,X), down(T',X), T != T'.
{place(rightof,T,T')} :- left(T,X), right(T',X), T != T'.

:- not place(belowof,T',T), place(aboveof,T,T'), T < T'.
:- not place(leftof,T',T), place(rightof,T,T'), T < T'.
:- not place(rightof,T',T), place(leftof,T,T'), T < T'.
:- not place(aboveof,T',T), place(belowof,T,T'), T < T'.

%% :- place(rightof,T2,T1), place(belowof,T5,T2), place(leftof,T4,T5), not place(aboveof,T1,T4),
%% 	 T1 != T2, T5 != T2, T4 != T5, T1 != T4, T1 != T5, T2 != T4.
%% :- place(leftof,T2,T3), place(belowof,T5,T2), place(leftof,T5,T6), not place(aboveof,T3,T6),
%% 	 T2 != T3, T5 != T2, T5 != T6, T3 != T6, T2 != T6, T3 != T5.

%% % closes the top edge (A left of B), given left, bottom and right edges
%% :- place(aboveof,A,C), place(leftof,C,D), place(belowof,D,B), not place(leftof,A,B),
%% 	 A != B, A != C, A != D, B != C, B != D, C != D.
%% % closes the bottom edge (C left of D), given top, left and right edges
%% :- place(leftof,A,B), place(aboveof,A,C), place(aboveof,B,D), not place(leftof,C,D),
%% 	 A != B, A != C, A != D, B != C, B != D, C != D.

:- place(aboveof,T,T'), down(T,X), not up(T',X), T != T'.
:- place(belowof,T,T'), up(T,X), not down(T',X), T != T'.
:- place(leftof,T,T'), right(T,X), not left(T',X), T != T'.
:- place(rightof,T,T'), left(T,X), not right(T',X), T != T'.
:- place(X,T,T1), place(X,T,T2), T1 < T2.
:- place(X,T1,T), place(X,T2,T), T1 < T2.

:- place(aboveof,T,T1), place(belowof,T2,T), T1 < T2.
:- place(rightof,T,T1), place(leftof,T2,T), T1 < T2.

__edge(X,Y) :- place(_,X,Y), X != Y.
__reach(M) :- M = #min{X : tile(X)}.
__reach(V) :- __reach(U), __edge(U,V).
:- tile(T), not __reach(T).

cities(N) :- A = #count{T,T' : place(aboveof,T,T'), down(T,c), up(T',c)},
             B = #count{T,T' : place(leftof,T,T'), right(T,c), left(T',c)},
             N = A+B.

pos(1,0,0).
pos(T',R,C+1) :- pos(T,R,C), place(leftof,T,T').
pos(T',R,C-1) :- pos(T,R,C), place(rightof,T,T').
pos(T',R+1,C) :- pos(T,R,C), place(aboveof,T,T').
pos(T',R-1,C) :- pos(T,R,C), place(belowof,T,T').
:- pos(T,R,C), pos(T',R,C), T < T'.
:- pos(T,R,C), pos(T,R',C'), (R,C) < (R',C').
:- pos(T,R,C), pos(T',R+1,C), down(T,A), up(T',B), A != B.
:- pos(T,R,C), pos(T',R,C+1), right(T,A), left(T',B), A != B.

%% 2. Interchangeable tiles: identical tiles get ordered lexicographically by (x,y).
same(T,T') :- tile(T,A,B,C,D), tile(T',A,B,C,D), T < T'.
:- same(T,T'), pos(T,R,C), pos(T',R',C'), (R',C') < (R,C).

#show cities/1.

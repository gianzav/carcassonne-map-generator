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





tile(T) :- tile(T,_,_,_,_).

rows(72).
cols(72).

:- tile(T), #count{X : down(T,X)} != 1.
:- tile(T), #count{X : up(T,X)} != 1.
:- tile(T), #count{X : left(T,X)} != 1.
:- tile(T), #count{X : right(T,X)} != 1.

&diff{x(T)} >= 1 :- tile(T).
&diff{x(T)} <= C :- tile(T), cols(C).
&diff{y(T)} >= 1 :- tile(T).
&diff{y(T)} <= R :- tile(T), rows(R).

:- tile(T), tile(T'), T < T', &diff{x(T)} = x(T'), &diff{y(T)} = y(T').
% T left of T'
:- &diff{x(T')} = x(T) + 1, &diff{y(T')} = y(T), right(T,X), not left(T',X), tile(T), tile(T'), T != T'.
:- &diff{x(T')} = x(T) + 1, &diff{y(T')} = y(T), left(T',X), not right(T,X), tile(T), tile(T'), T != T'.
% T above of T'
:- &diff{x(T')} = x(T), &diff{y(T')} = y(T) + 1, down(T,X), not up(T',X), tile(T), tile(T'), T != T'.
:- &diff{x(T')} = x(T), &diff{y(T')} = y(T) + 1, up(T',X), not down(T,X), tile(T), tile(T'), T != T'.

edge(T,T') :- tile(T), tile(T'), &diff{x(T')} = x(T) + 1, &diff{y(T')} = y(T), T != T'.
edge(T,T') :- tile(T), tile(T'), &diff{x(T')} = x(T), &diff{y(T')} = y(T) + 1, T != T'.

reach(T) :- T = #min{X : tile(X)}.
reach(Y) :- reach(X), edge(X,Y).
:- tile(T), not reach(T).


%% 2. Interchangeable tiles: identical tiles get ordered lexicographically by (x,y).
same(T,T') :- tile(T,A,B,C,D), tile(T',A,B,C,D), T < T'.
%same(T,T') :- up(T,U), up(T',U), left(T,L), left(T',L), right(T,R), right(T',R), down(T,D), down(T',D), T < T'.
:- same(T,T'), &diff{ x(T') - x(T) } <= -1.
:- same(T,T'), &diff{ x(T') - x(T) } <= 0, &diff{ y(T') - y(T) } <= -1.

leftof(T,T') :- tile(T), tile(T'), T != T', &diff{x(T)} = x(T')-1, &diff{y(T)} = y(T').
rightof(T,T') :- tile(T), tile(T'), T != T', &diff{x(T)} = x(T')+1, &diff{y(T)} = y(T').
aboveof(T,T') :- tile(T), tile(T'), T != T', &diff{x(T)} = x(T'), &diff{y(T)} = y(T')-1.
belowof(T,T') :- tile(T), tile(T'), T != T', &diff{x(T)} = x(T'), &diff{y(T)} = y(T')+1.

:- tile(T), #count{T' : leftof(T,T')} > 1.
:- tile(T), #count{T' : rightof(T,T')} > 1.
:- tile(T), #count{T' : belowof(T,T')} > 1.
:- tile(T), #count{T' : aboveof(T,T')} > 1.

% Set rotation of first tile to cut some symmetric solutions
%rotate(1,0).

% it is impossible to have open cities
:- up(T,c), not belowof(T,_).
:- down(T,c), not aboveof(T,_).
:- left(T,c), not rightof(T,_).
:- right(T,c), not leftf(T,_).

#show.

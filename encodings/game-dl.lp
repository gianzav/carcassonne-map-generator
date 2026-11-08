#const w = 10. % window
rows(w).
cols(w).

{pick(T,A,B,C,D)} :- tile(T,A,B,C,D), A = c.
{pick(T,A,B,C,D)} :- tile(T,A,B,C,D), B = c.
{pick(T,A,B,C,D)} :- tile(T,A,B,C,D), C = c.
{pick(T,A,B,C,D)} :- tile(T,A,B,C,D), D = c.

pick(T) :- pick(T,_,_,_,_).
 
%% 1. Rotation symmetry of a single pick: picks whose rotated edge tuples coincide
%%    (e.g. all-equal edges, or 180°-symmetric picks) keep only the smallest rotation.
rt(T,0,  (A,B,C,D)) :- pick(T,A,B,C,D).
rt(T,90, (D,A,B,C)) :- pick(T,A,B,C,D).
rt(T,180,(C,D,A,B)) :- pick(T,A,B,C,D).
rt(T,270,(B,C,D,A)) :- pick(T,A,B,C,D).
% generate possible rotation only if such rotation doesn't yield the original pick
not_rotate(T,R) :- rt(T,R,S), rt(T,R',S), R' < R, R > 0.
{rotate(T,R)} :- rt(T,R,S), not not_rotate(T,R).
:- pick(T), rotate(T,R), rotate(T,R'), R < R'.
:- rotate(T,R), rt(T,R,S), rt(T,R',S), R' < R.

down(T,D) :- pick(T, D, _, _, _), rotate(T,0).
left(T,L) :- pick(T, _, L, _, _), rotate(T,0).
up(T,U)   :- pick(T, _, _, U, _), rotate(T,0).
right(T,R):- pick(T, _, _, _, R), rotate(T,0).

down(T,D) :- pick(T, _, _, _, D), rotate(T,90).
left(T,L) :- pick(T, L, _, _, _), rotate(T,90).
up(T,U)   :- pick(T, _, U, _, _), rotate(T,90).
right(T,R):- pick(T, _, _, R, _), rotate(T,90).

down(T,D) :- pick(T, _, _, D, _), rotate(T,180).
left(T,L) :- pick(T, _, _, _, L), rotate(T,180).
up(T,U)   :- pick(T, U, _, _, _), rotate(T,180).
right(T,R):- pick(T, _, R, _, _), rotate(T,180).

down(T,D) :- pick(T, _, _, _, D), rotate(T,270).
left(T,L) :- pick(T, L, _, _, _), rotate(T,270).
up(T,U)   :- pick(T, _, U, _, _), rotate(T,270).
right(T,R):- pick(T, _, _, R, _), rotate(T,270).



:- pick(T), #count{X : down(T,X)} != 1.
:- pick(T), #count{X : up(T,X)} != 1.
:- pick(T), #count{X : left(T,X)} != 1.
:- pick(T), #count{X : right(T,X)} != 1.

&diff{x(T)} >= 1 :- pick(T).
&diff{x(T)} <= C :- pick(T), cols(C).
&diff{y(T)} >= 1 :- pick(T).
&diff{y(T)} <= R :- pick(T), rows(R).

:- pick(T), pick(T'), T < T', &diff{x(T)} = x(T'), &diff{y(T)} = y(T').
% T left of T'
:- &diff{x(T')} = x(T) + 1, &diff{y(T')} = y(T), right(T,X), not left(T',X), pick(T), pick(T'), T != T'.
:- &diff{x(T')} = x(T) + 1, &diff{y(T')} = y(T), left(T',X), not right(T,X), pick(T), pick(T'), T != T'.
% T above of T'
:- &diff{x(T')} = x(T), &diff{y(T')} = y(T) + 1, down(T,X), not up(T',X), pick(T), pick(T'), T != T'.
:- &diff{x(T')} = x(T), &diff{y(T')} = y(T) + 1, up(T',X), not down(T,X), pick(T), pick(T'), T != T'.

edge(T,T') :- pick(T), pick(T'), &diff{x(T')} = x(T) + 1, &diff{y(T')} = y(T), T != T'.
edge(T,T') :- pick(T), pick(T'), &diff{x(T')} = x(T), &diff{y(T')} = y(T) + 1, T != T'.
edge(X,Y) :- edge(Y,X).

reach(T) :- T = #min{X : pick(X)}.
reach(Y) :- reach(X), edge(X,Y).
:- pick(T), not reach(T).


%% 2. Interchangeable picks: identical picks get ordered lexicographically by (x,y).
same(T,T') :- pick(T,A,B,C,D), pick(T',A,B,C,D), T < T'.
%same(T,T') :- rotate(T,R), rotate(T',R'), T < T', rt(T,R,X), rt(T',R',X).
:- same(T,T'), &diff{ x(T') - x(T) } <= -1.
:- same(T,T'), &diff{ x(T') - x(T) } <= 0, &diff{ y(T') - y(T) } <= -1.


%% cities_used(N1+N2+N3+N4) :- N1 = #count{T : pick(T,c,_,_,_)},
%% 														N2 = #count{T : pick(T,_,c,_,_)},
%% 														N3 = #count{T : pick(T,_,_,c,_)},
%% 														N4 = #count{T : pick(T,_,_,_,c)}.
%% total_cities(N1+N2+N3+N4) :- N1 = #count{T : tile(T,c,_,_,_)},
%% 														 N2 = #count{T : tile(T,_,c,_,_)},
%% 														 N3 = #count{T : tile(T,_,_,c,_)},
%% 														 N4 = #count{T : tile(T,_,_,_,c)}.
%% :- cities_used(N), total_cities(M), N < M/2.
%% #maximize{N : cities_used(N)}.

#show.

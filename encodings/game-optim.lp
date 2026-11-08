#const w = 10.
rows(w).
cols(w).

tiles(N,(D,L,U,R)) :- tiles(N,edges(D,L,U,R), _).
tile(Tile) :- tiles(_,Tile).

_tile_conn(T, (D,L,U,R), (A,B,C,D)) :- tile(T,D,L,U,R), tile_conn(T,A,B,C,D).
tiles_conn(N, X, Y) :- _tile_conn(_,X,Y), N = #count{T : _tile_conn(T,X,Y)}.

{place(Tile,(1..R,1..C))} = N :- tiles(N,Tile), rows(R), cols(C).

%% fix rotation and position of first tile
%% place(T,(R/2,C/2)) :- rows(R), cols(C), T = #min{X : tile(X)}. 
%% rotated(T,(R/2,C/2)) :- rows(R), cols(C), T = #min{X : tile(X)}. 

%% 1. Rotation symmetry of a single pick: picks whose rotated edge tuples coincide
%%    (e.g. all-equal edges, or 180°-symmetric picks) keep only the smallest rotation.
rt((A,B,C,D), 0,  (A,B,C,D)) :- tile((A,B,C,D)).
rt((A,B,C,D), 90, (D,A,B,C)) :- tile((A,B,C,D)).
rt((A,B,C,D), 180,(C,D,A,B)) :- tile((A,B,C,D)).
rt((A,B,C,D), 270,(B,C,D,A)) :- tile((A,B,C,D)).
% generate possible rotation only if such rotation doesn't yield the original pick
not_rotate(T,R) :- rt(T,R,S), rt(T,R',S), R' < R, R > 0.
1{rotated(S,Pos) : rt(T,R,S), not not_rotate(T,R)}1 :- place(T,Pos).

:- place(T,Pos), place(T',Pos), T < T'.
% T left of T'
:- rotated((_,_,_,X),(R,C)), rotated((_,X',_,_),(R,C+1)), X != X'.
% T above of T'
:- rotated((X,_,_,_),(R,C)), rotated((_,_,X',_),(R+1,C)), X != X'.

edge((R,C),(R,C')) :- place(_,(R,C)), place(_,(R,C')), C' = C+1.
edge((R,C),(R',C)) :- place(_,(R,C)), place(_,(R',C)), R' = R+1.
edge(X,Y) :- edge(Y,X).

reach(Y) :- Y = #min{X : place(_,X)}.
reach(Y) :- reach(X), edge(X,Y).
:- place(_,T), not reach(T).


city_edge((R,C),(R,C')) :- rotated((_,_,_,c),(R,C)), rotated((_,c,_,_),(R,C')), C' = C+1.
city_edge((R,C),(R',C)) :- rotated((c,_,_,_),(R,C)), rotated((_,_,c,_),(R',C)), R' = R+1.
city_edge(X,Y) :- city_edge(Y,X).

city_reach(Y) :- Y = #min{X : city_edge(X,_)}.
city_reach(Y) :- city_reach(X), city_edge(X,Y).
city_reached(N) :- N = #count{X : city_reach(X)}.

% all tiles with a city must be in a closed city
:- rotated((c,_,_,_),(R,C)), not rotated((_,_,c,_),(R+1,C)).
:- rotated((_,c,_,_),(R,C)), not rotated((_,_,_,c),(R,C-1)).
:- rotated((_,_,c,_),(R,C)), not rotated((c,_,_,_),(R-1,C)).
%% :- rotated((_,_,_,c),(R,C)), not rotated((_,c,_,_),(R,C+1)).


#maximize{X : city_reached(X)}.

#show.
#show rotated/2.


%%% Symmetry breaking by Claude %%%

%% rotation / reflection symmetry breaking (lex-leader on the orientation counts of one tile class)
%% ov(S) :- rt(T,R,S), not not_rotate(T,R).

%% % image of an oriented tile (D,L,U,R) under the symmetries of the square
%% tr(r90,  (D,L,U,R), (R,D,L,U)) :- ov((D,L,U,R)).
%% tr(r180, (D,L,U,R), (U,R,D,L)) :- ov((D,L,U,R)).
%% tr(r270, (D,L,U,R), (L,U,R,D)) :- ov((D,L,U,R)).
%% tr(mh,   (D,L,U,R), (D,R,U,L)) :- ov((D,L,U,R)).
%% tr(mv,   (D,L,U,R), (U,L,D,R)) :- ov((D,L,U,R)).
%% tr(d1,   (D,L,U,R), (R,U,L,D)) :- ov((D,L,U,R)).
%% tr(d2,   (D,L,U,R), (L,D,R,U)) :- ov((D,L,U,R)).

%% % rotation classes and how many tiles each contains
%% rotsym(r90;r180;r270).
%% rtr(S,S) :- ov(S).
%% rtr(S,S0) :- tr(G,S,S0), rotsym(G).
%% cl(S,K) :- ov(S), K = #min{S0 : rtr(S,S0)}.
%% ccount(K,M) :- cl(_,K), M = #sum{N,T : tiles(N,T), cl(T,K)}.

%% % reflections are board symmetries only if the tile set is mirror-closed
%% mirror_bad :- ov(S), tr(mh,S,S'), not ov(S').
%% mirror_bad :- ov(S), tr(mh,S,S'), cl(S,K), cl(S',K'), ccount(K,M), ccount(K',M'), M != M'.
%% sym(r90;r180;r270).
%% sym(mh;mv;d1;d2) :- not mirror_bad.

%% % reference class: 4 distinct rotations (so rotating changes the counts), odd size if possible
%% four(K) :- cl(_,K), #count{S : cl(S,K)} = 4.
%% hasodd :- four(K), ccount(K,M), M \ 2 = 1.
%% cand(K) :- four(K), ccount(K,M), M \ 2 = 1.
%% cand(K) :- four(K), not hasodd.
%% star(K) :- cand(K), K = #min{K' : cand(K')}.
%% inV(S) :- star(K), cl(S,K).
%% inV(S') :- star(K), cl(S,K), tr(mh,S,S'), not mirror_bad.

%% idx(S,I) :- inV(S), I = #count{S' : inV(S'), S' < S}.
%% cnt(S,N) :- inV(S), cl(S,K), ccount(K,M), N = 0..M, N = #count{P : rotated(S,P)}.
%% gcnt(G,S',N) :- sym(G), tr(G,S,S'), cnt(S,N).
%% differ(G,I) :- gcnt(G,S,N'), cnt(S,N), idx(S,I), N != N'.
%% firstdiff(G,I) :- differ(G,I), I = #min{J : differ(G,J)}.
%% :- firstdiff(G,I), idx(S,I), cnt(S,N), gcnt(G,S,N'), N < N'.

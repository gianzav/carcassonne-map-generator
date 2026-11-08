tile(T) :- tile(T,_,_,_,_).
n(N) :- N = #count{T : tile(T)}.
#const w = 0.   % window side; 0 = number of tiles (complete)
win(W) :- n(N), w = 0, W = N.
win(w) :- w != 0.

{pick(T,A,B,C,D)} :- tile(T,A,B,C,D), A = c.
{pick(T,A,B,C,D)} :- tile(T,A,B,C,D), B = c.
{pick(T,A,B,C,D)} :- tile(T,A,B,C,D), C = c.
{pick(T,A,B,C,D)} :- tile(T,A,B,C,D), D = c.
pick(T) :- pick(T,_,_,_,_).

rt(T,0,  (A,B,C,D)) :- pick(T,A,B,C,D).
rt(T,90, (D,A,B,C)) :- pick(T,A,B,C,D).
rt(T,180,(C,D,A,B)) :- pick(T,A,B,C,D).
rt(T,270,(B,C,D,A)) :- pick(T,A,B,C,D).
cls(T,K) :- pick(T), K = #min{S : rt(T,_,S)}.
cnt(K,C) :- cls(_,K), C = #count{T : cls(T,K)}.
% a class with a single tile keeps one fixed orientation (breaks global rotation)
os(S,K) :- cls(T,K), rt(T,_,S), cnt(K,C), C > 1.
os(S,K) :- cnt(K,1), cls(T,K), rt(T,0,S).

p(1..W) :- win(W).
{ cell(X,Y,S) : os(S,_) } 1 :- p(X), p(Y).
occ(X,Y) :- cell(X,Y,_).
:- cnt(K,C), #count{X,Y : cell(X,Y,S), os(S,K)} != C.

% each shared edge has a single colour
hc(X,Y,R)   :- cell(X,Y,(_,_,_,R)).
hc(X-1,Y,L) :- cell(X,Y,(_,L,_,_)).
vc(X,Y,D)   :- cell(X,Y,(D,_,_,_)).
vc(X,Y-1,U) :- cell(X,Y,(_,_,U,_)).
:- hc(X,Y,C), hc(X,Y,C'), C < C', p(X), p(Y).
:- vc(X,Y,C), vc(X,Y,C'), C < C', p(X), p(Y).

% translation: touch first column and first row
c1 :- occ(1,_).
r1 :- occ(_,1).
:- not c1.
:- not r1.

% connectivity (undirected) from a canonical root
root(1,Y) :- occ(1,Y), Y = #min{Y' : occ(1,Y')}.
reach(X,Y) :- root(X,Y).
reach(X',Y') :- reach(X,Y), occ(X',Y'), |X-X'| + |Y-Y'| = 1.
:- occ(X,Y), not reach(X,Y).

% map back to tile ids: k-th cell (in (x,y) order) of a class gets the k-th id of the class
rk(K,T,J+1) :- cls(T,K), J = #count{T' : cls(T',K), T' < T}.
cr(X,Y,K,J+1) :- cell(X,Y,S), os(S,K), J = #count{X',Y' : cell(X',Y',S'), os(S',K), (X',Y') < (X,Y)}.
at(T,X,Y) :- cr(X,Y,K,I), rk(K,T,I).
rotate(T,R) :- at(T,X,Y), cell(X,Y,S), rt(T,R,S), R = #min{R' : rt(T,R',S)}.


% maximize the number of continuous city edges

%% city(M+N) :- N = #count{X,Y : hc(X,Y,c)}, M = #count{X,Y : vc(X,Y,c)}.
%% #maximize{N : city(N)}.

#show at/3.
#show rotate/2.

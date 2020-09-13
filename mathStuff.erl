-module(mathStuff).
-export([perimeter/1]).
-import(math,[ pow/2, pi/0, sqrt/1]).

perimeter({square, Side}) -> pow(Side, 2);
perimeter({circle, Radius}) -> pi() * pow(Radius, 2);
perimeter({triangle, A,B,C}) -> S = (A + B + C)/2,
                                sqrt(S * (S - A) * (S - B) * (S - C)).



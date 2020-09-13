-module(lists1).
-export([min/1, max/1, min_max/1]).


min([H|[]]) -> H;
min([H|T]) -> Min = min(T),
              case Min > H of
                true -> H;
                false -> Min
              end.

max([H|T]) -> max_2(T, H).
max_2([H|T], X) when H > X -> max_2(T, H);
max_2([H|T], X) when H < X -> max_2(T, X);
max_2([], X) -> X.

min_max(X) -> {min(X), max(X)}.

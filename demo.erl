-module(demo).
-export([double/1, triple/1, even/1, odd/1, all_even/1, sum/1,
        average/1]).

double(X) ->
        times(X, 2).

triple(X) ->
        times(X, 3).


times(X, N) ->
        X * N.

even(X) when X rem 2 == 0 -> true;
even(_) -> false.

odd(X) -> not(even(X)).

all_even([H|T]) ->
        case odd(H) of
            true -> false;
            false -> all_even(T)
        end;
all_even(_) -> true.

sum([H|T]) -> H + sum(T);
sum([]) -> 0.

average(X) -> average(X, 0, 0).
average([H|T], Length, Sum) ->
    average(T, Length + 1, Sum + H);
average([], Length, Sum) ->
    Sum / Length.

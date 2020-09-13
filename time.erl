-module(time).
-export([swedish_date/0, swedish_date/1]).


%swedish_date() -> {Y,M,D} = date(),
%                  [_,_|Yi] = integer_to_list(Y),
%                  Yi ++ integer_to_list(M) ++ integer_to_list(D).
%

swedish_date() -> swedish_date(date()).
swedish_date({Y, M, D}) -> 
                    lists:flatten(io_lib:format("~-2..0w~2..0w~2..0w", [Y rem 100, M, D])).

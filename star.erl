-module(star).
-export([star/2, parentGo/2, childLoop/1]).

star(M, N) -> spawn(star, parentGo, [M,N]).


parentGo(M,N) -> Children = childGo(M, N),
                 parentLoop(Children, M).

parentLoop(_, 0) -> true;
parentLoop(Children, M) -> parentSendAll(Children),
                           parentRcvAll(Children),
                           parentLoop(Children, M-1).

parentSendAll([]) -> true;
parentSendAll([H|T]) -> H ! {self(), message},
                      parentSendAll(T).

parentRcvAll([]) -> io:format("~n",[]), true;
parentRcvAll([H|T]) -> receive
                        {H, Reply} ->
                            io:format("Rcvd:~w From:~w",[Reply,H]),
                            parentRcvAll(T)
                      end.


childGo(_,0) -> [];
childGo(M, N) -> Pid = spawn(star, childLoop, [M]),
                [Pid | childGo(M,N-1)].

childLoop(0) -> true;
childLoop(M) -> receive
                  {From, _} ->
                         From ! {self(), reply},
                         %io:format("~w:", [self()]),
                         childLoop(M-1)
                end.

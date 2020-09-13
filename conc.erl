-module(conc).
-export([pair/1, parentGo/1, childLoop/1]).

pair(M) -> spawn(conc, parentGo, [M]).


parentGo(M) -> Child = spawn(conc, childLoop, [M]),
              parentLoop(Child, M).

parentLoop(_, 0) -> true;
parentLoop(Child, M) -> Msg = message,
                        Child ! {self(), Msg},
                        receive
                            Reply ->
                                io:format("MsgReply: ~w~n", [Reply]),
                                parentLoop(Child, M-1)
                        end.

childLoop(0) -> true;
childLoop(M) -> receive
                    {From, message} ->
                      From ! reply,
                      childLoop(M-1)
                end.

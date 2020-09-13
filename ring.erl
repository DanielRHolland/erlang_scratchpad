-module(ring).
-export([ring/2, parentGo/2, childGo/3]).

ring(M, N) -> spawn(ring, parentGo, [M,N]).


parentGo(M,N) -> Child = spawn(ring, childGo, [M,N-1, self()]),
              parentLoop(Child, M).

parentLoop(_, 0) -> true;
parentLoop(Child, M) -> Child ! message,
                        receive
                            Reply ->
                                io:format("MsgRcvdByParent: ~w~n", [Reply]),
                                parentLoop(Child, M-1)
                        end.

childGo(M, 0, P) -> childLoop(P, M);
childGo(M, N, P) -> Next = spawn(ring, childGo, [M,N-1,P]),
                    childLoop(Next, M).

childLoop(_,0) -> true;
childLoop(Next,M) -> receive
                          Msg ->
                              Next ! Msg,
                              io:format("~w:", [self()]),
                              childLoop(Next, M-1)
                     end.

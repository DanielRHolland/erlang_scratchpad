-module(ms).
-export([start/1,to_slave/2, master_go/1, master_loop/1, slave_loop/0]).

start(N) -> Pid = spawn(ms,master_go,[N]),
            register(master, Pid),
            Pid.

master_go(N) ->  Slaves = slaves_go(N),
                 process_flag(trap_exit, true),
                 ms:master_loop(Slaves).


slaves_go(N) -> [{X, spawn_link(ms, slave_loop, [])} || X <- lists:seq(1, N)].

slave_loop() -> receive
                    die -> io:fwrite("killing ~w ~n", [self()]),
                           exit(dead);
                    Msg -> io:format("P~w Rcvd:~w~n",[self(), Msg]),
                             ms:slave_loop()
                end.

master_loop(Slaves) -> receive
                         {relay, {N, Msg}} ->
                                io:fwrite("relay ~w to ~w ~n", [Msg, N]),
                                case lists:keyfind(N, 1, Slaves) of
                                      false ->  io:format("Failed to find: ~w~n",[N]),
                                                    lookupfailure;
                                      {_,Pid} -> Pid ! Msg
                                end,
                                ms:master_loop(Slaves);
                         {'EXIT', FailedPid, Why} ->
                                io:fwrite("P~w failed, Reason: ~w~n", [FailedPid, Why]),
                                {Key, FailedPid} = lists:keyfind(FailedPid, 2, Slaves),
                                NewPid = spawn_link(ms, slave_loop, []),
                                NewList = lists:keyreplace(Key, 1, Slaves, {Key, NewPid}),
                                io:fwrite("New process ~w taking over #~w~n", [NewPid, Key]),
                                ms:master_loop(NewList)
                       end.


to_slave(Message, N) -> master ! {relay, {N, Message}}.


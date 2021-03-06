-module(bowling_kata_test).

-include_lib("eunit/include/eunit.hrl").


start() ->
    {ok, PID} = bowling_game:new(),
    PID.

stop(PID) ->
    bowling_game:stop(PID).

rolls_without_bonuses_test_() ->
    {foreach,
        fun start/0,
        fun stop/1,
        [
            fun(PID) -> ?_assertEqual(0, do_rolls(lists:duplicate(20, 0), PID)) end,
            fun(PID) -> ?_assertEqual(20, do_rolls(lists:duplicate(20, 1), PID)) end,
            fun(PID) -> ?_assertEqual(7, do_rolls([3, 4], PID)) end,
            fun(PID) -> ?_assertEqual(15, do_rolls([5, 1, 2, 7], PID)) end,
            fun(PID) -> ?_assertEqual(24, do_rolls([3, 5, 4, 0, 6, 6], PID)) end
        ]
    }.

rolls_with_spares_test_() ->
    {foreach,
        fun start/0,
        fun stop/1,
        [
            fun(PID) -> ?_assertEqual(12, do_rolls([7, 3, 1], PID)) end,
            fun(PID) -> ?_assertEqual(33, do_rolls([7, 3, 4, 5, 1, 9], PID)) end,
            fun(PID) -> ?_assertEqual(31, do_rolls([7, 3, 1, 9, 4, 2], PID)) end,
            fun(PID) -> ?_assertEqual(39, do_rolls([2, 8, 4, 6, 5, 5], PID)) end
        ]
    }.

rolls_with_strikes_test_() ->
    {foreach,
        fun start/0,
        fun stop/1,
        [
            fun(PID) -> ?_assertEqual(28, do_rolls([10, 4, 5], PID)) end,
            fun(PID) -> ?_assertEqual(50, do_rolls([10, 10, 6, 1], PID)) end,
            fun(PID) -> ?_assertEqual(78, do_rolls([10, 10, 10, 4, 3], PID)) end,
            fun(PID) -> ?_assertEqual(52, do_rolls([10, 0, 7, 10, 5, 4], PID)) end
        ]
    }.

rolls_with_strikes_and_spares_test_() ->
    {foreach,
        fun start/0,
        fun stop/1,
        [
            fun(PID) -> ?_assertEqual(67, do_rolls([10, 10, 6, 4, 3, 5], PID)) end,
            fun(PID) -> ?_assertEqual(84, do_rolls([10, 6, 4, 10, 9, 1, 7, 0], PID)) end
        ]
    }.

do_rolls(Rolls, PID) ->
    lists:foldl(fun(KnockedPins, _Points) -> bowling_game:roll(PID, KnockedPins) end, 0, Rolls).

%%%----------------------------------------------------------------------
%%%
%%% @copyright erl-redis 2010
%%%
%%% @author litao cheng <litaocheng@gmail.com>
%%% @doc redis connection supervisor
%%% @end
%%%
%%%----------------------------------------------------------------------
-module(redis_conn_sup).
-author('litaocheng@gmail.com').
-vsn('0.1').
-include("redis_internal.hrl").

-behaviour(supervisor).

-export([start_link/0]).
-export([connect/5]).
-export([init/1]).


%% @doc the application start callback
-spec start_link() -> 
    {'ok', pid()} | 'ignore' | {'error', any()}.
start_link() ->
    ?INFO2("start the supervisor", []),
    supervisor:start_link({local, ?CONN_SUP}, ?MODULE, []).

%% @doc start an new redis_client process connect the specify redis server
connect(Host, Port, Index, Timeout, Passwd) ->
    supervisor:start_child(?CONN_SUP, [{Host, Port}, Index, Timeout, Passwd]).

%% @doc the connection supervisor callback
init([]) -> 
    ?DEBUG2("init supervisor", []),
    Stragegy = {simple_one_for_one, 10, 10},
    Client = {undefined, {redis_client, start_link, []},
                permanent, 1000, worker, [redis_client]},

    {ok, {Stragegy, [Client]}}.

%%
%% internal API
%%

-module(lucas_test_websocket).

-behaviour(boss_service_handler).

-record(state,{users}).

-export([init/0,
        handle_incoming/5,
        handle_join/4,
        handle_close/4,
        handle_info/2,
        terminate/2]).

init() ->
   io:format("begining ~n"),
   {ok, #state{users=dict:new()}} .

handle_join(_ServiceName, WebSocket, SessionId, State) ->
    #state{users=Users} = State,
    {reply, ok, #state{users=dict:store(WebSocket,SessionId,Users)}}.

handle_close(_ServiceName, WebSocketId, _SessionId, State) ->
    #state{users=Users} = State,
    {reply, ok, #state{users=dict:erase(WebSocketId,Users)}}.

handle_incoming(_ServiceName, WebSocketId, _SessionId, Message, State) ->
    #state{users=Users} = State,
    Fun = fun(X) when is_pid(X)-> X ! {text, Message}  end,
    All = dict:fetch_keys(Users),
    [Fun(E) || E <- All, E /= WebSocketId],
    {noreply, State}.

handle_info(ping, State) ->
    error_logger:info_msg("pong:~p~n",[now()]),
    {noreply, State};
handle_info(state, State) ->
    #state{users=Users} = State,
    All = dict:fetch_keys(Users),
    error_logger:info_msg("state:~p~n", [All]),
    {noreply, State};
handle_info(_Info, State) ->
    {noreply, State}.

terminate(_Reason, _State) ->
    ok.

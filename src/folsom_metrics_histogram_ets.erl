%%%
%%% Copyright 2011, Boundary
%%%
%%% Licensed under the Apache License, Version 2.0 (the "License");
%%% you may not use this file except in compliance with the License.
%%% You may obtain a copy of the License at
%%%
%%%     http://www.apache.org/licenses/LICENSE-2.0
%%%
%%% Unless required by applicable law or agreed to in writing, software
%%% distributed under the License is distributed on an "AS IS" BASIS,
%%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%% See the License for the specific language governing permissions and
%%% limitations under the License.
%%%


%%%-------------------------------------------------------------------
%%% File:      folsom_metrics_histogram_ets.erl
%%% @author    joe williams <j@boundary.com>
%%% @doc
%%% this module creates ets tables for histograms as to be the parent
%%% process for those histograms so the apps using folsom dont have to
%%% @end
%%%------------------------------------------------------------------

-module(folsom_metrics_histogram_ets).

-behaviour(gen_server).

%% API
-export([start_link/0, new/2]).

%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).

-define(SERVER, ?MODULE).

-record(state, {}).

%%%===================================================================
%%% API
%%%===================================================================

-doc """
Starts the server

### Spec
start_link() -> {ok, Pid} | ignore | {error, Error}
""".
start_link() ->
    gen_server:start_link({local, ?SERVER}, ?MODULE, [], []).

%%%===================================================================
%%% gen_server callbacks
%%%===================================================================

-doc """
Initializes the server

### Spec
init(Args) -> {ok, State} |
{ok, State, Timeout} |
ignore |
{stop, Reason}
""".
%% -doc hidden. https://github.com/erlang/otp/issues/9672
init([]) ->
    {ok, #state{}}.

-doc """
Handling call messages

### Spec
handle_call(Request, From, State) ->
{reply, Reply, State} |
{reply, Reply, State, Timeout} |
{noreply, State} |
{noreply, State, Timeout} |
{stop, Reason, Reply, State} |
{stop, Reason, State}
""".
%% -doc hidden. https://github.com/erlang/otp/issues/9672
handle_call({new, {Table, Opts}}, _From, State) ->
    Reply = ets:new(Table, Opts),
    {reply, Reply, State}.

-doc """
Handling cast messages

### Spec
handle_cast(Msg, State) -> {noreply, State} |
{noreply, State, Timeout} |
{stop, Reason, State}
""".
%% -doc hidden. https://github.com/erlang/otp/issues/9672
handle_cast(_Msg, State) ->
    {noreply, State}.

%%--------------------------------------------------------------------
%% @private
%% @doc
%% Handling all non call/cast messages
%%
%% @spec handle_info(Info, State) -> {noreply, State} |
%%                                   {noreply, State, Timeout} |
%%                                   {stop, Reason, State}
%% @end
%%--------------------------------------------------------------------
handle_info(_Info, State) ->
    {noreply, State}.

-doc """
This function is called by a gen_server when it is about to
terminate. It should be the opposite of Module:init/1 and do any
necessary cleaning up. When it returns, the gen_server terminates
with Reason. The return value is ignored.

### Spec
terminate(Reason, State) -> void()
""".
%% -doc hidden. https://github.com/erlang/otp/issues/9672
terminate(_Reason, _State) ->
    ok.

-doc """
Convert process state when code is changed

### Spec
code_change(OldVsn, State, Extra) -> {ok, NewState}
""".
%% -doc hidden. https://github.com/erlang/otp/issues/9672
code_change(_OldVsn, State, _Extra) ->
    {ok, State}.

%%%===================================================================
%%% Internal functions
%%%===================================================================

new(Table, Opts) ->
    gen_server:call(?SERVER, {new, {Table, Opts}}).

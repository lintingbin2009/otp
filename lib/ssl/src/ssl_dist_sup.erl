%%
%% %CopyrightBegin%
%%
%% Copyright Ericsson AB 2011-2017. All Rights Reserved.
%%
%% Licensed under the Apache License, Version 2.0 (the "License");
%% you may not use this file except in compliance with the License.
%% You may obtain a copy of the License at
%%
%%     http://www.apache.org/licenses/LICENSE-2.0
%%
%% Unless required by applicable law or agreed to in writing, software
%% distributed under the License is distributed on an "AS IS" BASIS,
%% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%% See the License for the specific language governing permissions and
%% limitations under the License.
%%
%% %CopyrightEnd%
%%

%%

-module(ssl_dist_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callback
-export([init/1]).

%%%=========================================================================
%%%  API
%%%=========================================================================

-spec start_link() -> {ok, pid()} | ignore | {error, term()}.
			
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%%%=========================================================================
%%%  Supervisor callback
%%%=========================================================================

init([]) ->    
    AdminSup = ssl_admin_child_spec(),
    ConnectionSup = ssl_connection_sup(),
    {ok, {{one_for_all, 10, 3600}, [AdminSup, ConnectionSup]}}.

%%--------------------------------------------------------------------
%%% Internal functions
%%--------------------------------------------------------------------
ssl_admin_child_spec() ->
    Name = ssl_dist_admin_sup,  
    StartFunc = {ssl_dist_admin_sup, start_link , []},
    Restart = permanent, 
    Shutdown = 4000,
    Modules = [ssl_admin_sup],
    Type = supervisor,
    {Name, StartFunc, Restart, Shutdown, Type, Modules}.

ssl_connection_sup() ->
    Name = ssl_dist_connection_sup,
    StartFunc = {ssl_dist_connection_sup, start_link, []},
    Restart = permanent,
    Shutdown = 4000,
    Modules = [ssl_connection_sup],
    Type = supervisor,
    {Name, StartFunc, Restart, Shutdown, Type, Modules}.

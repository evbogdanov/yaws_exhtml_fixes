-module(yaws_exhtml_fixes_app).

-behaviour(application).

-export([
  % app callbacks
  start/2,
  stop/1
]).

-define(  SERVER_ID, "yaws_exhtml_fixes_server").
-define(SERVER_NAME, "localhost").
-define(N_ACCEPTORS, 10).
-define(       PORT, 1234).
-define(       HOST, {127,0,0,1}).
-define(     LOGDIR, code:lib_dir(yaws_exhtml_fixes) ++ "/log").
-define(    DOCROOT, code:lib_dir(yaws_exhtml_fixes) ++ "/www").

%%%=============================================================================
%%% app callbacks
%%%=============================================================================

start(_StartType, _StartArgs) ->
  ok = start_yaws(),
  yaws_exhtml_fixes_sup:start_link().

stop(_State) ->
  ok.

%%%=============================================================================
%%% embedded yaws
%%%=============================================================================

start_yaws() ->
  ServerConf = [
    {servername, ?SERVER_NAME},
    {listen, ?HOST},
    {port, ?PORT},
    {flags, [
      {auth_log, false},
      {access_log, false}
    ]},
    {docroot, ?DOCROOT}
  ],
  GlobalConf = [
    {id, ?SERVER_ID},
    {logdir, ?LOGDIR},
    {acceptor_pool_size, ?N_ACCEPTORS},
    {cache_refresh_secs, 0}
  ],
  yaws:start_embedded(?DOCROOT, ServerConf, GlobalConf, ?SERVER_ID).

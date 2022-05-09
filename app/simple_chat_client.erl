-module(simple_chat_client).
-compile([export_all]).

user(Name) ->
	
    spawn(fun() -> user_init(Name) end).

user_init(Name) ->
    user_loop(Name).

user_loop(Name) ->
	 
	%% Mby user need register
	%%register(list_to_atom(string:lowercase(Name)),self()),
    receive
	subscribe ->
		register(list_to_atom(string:lowercase(Name)),self()),
		io:format("Proces spawned ~p~n",[self()]),
	    io:format("User: ~p subscribe.~n",[Name]),
		server_chat ! {self(), subscribe},
	    user_loop(Name);
	unsubscribe ->
		io:format("Logged out!!!!!~n"),
		server_chat ! {self(),unsubscribe},
		user_loop(Name);
	{Msg,message} ->
	
		
		server_chat ! {Msg,message},
		user_loop(Name);
	{Msg,from_server} ->
		io:format("Message: ~p~n",[Msg]),
		user_loop(Name);
	logg_out ->
	    io:format("LoggOut. ~n")
		
    end.
	

	
subscribe(Name)->
	spawn(fun()-> login(Name) end).

login(Name) ->
	A = user(Name),
	A ! subscribe.

unsubscribe(Name) ->
	PID = list_to_atom(string:lowercase(Name)),
	PID ! unsubscribe.

send(Name,Msg) ->
	PID = list_to_atom(string:lowercase(Name)),
	PID ! {Msg,message}.
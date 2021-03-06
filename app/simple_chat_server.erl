-module(simple_chat_server).
-compile([export_all]).

start() ->
	Server = spawn(simple_chat_server,server_loop,[[]]),
	register(server_chat,Server).

server_loop(ListOfUser) ->
	receive
		{Pid, subscribe} ->
			io:format("Server detected user login!!!!!~n"),
			server_loop([Pid | ListOfUser]);
		{Pid, unsubscribe} ->
			io:format("Logged out!!!!!~n"),
			Pid ! logg_out,
			server_loop(lists:delete(Pid,ListOfUser));
			
		{Message,message} ->
			lists:foreach(fun(PiD) -> PiD ! {Message, from_server} end,ListOfUser),
			server_loop(ListOfUser);
			
		stop ->
			io:format("Server is stopped~n")
		
    end.
stop() ->
	server_chat ! stop.
	
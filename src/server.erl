-module(server).

-export([start/0, stop/0, loop/1]).

-include("../includes/routing.hrl").

-define(HTTP_OPTS, [
            {loop, {?MODULE, loop}},
            {port, 2904},
            {name, http_2904}
            ]).

start() ->
  {ok, Http} = mochiweb_http:start(?HTTP_OPTS),
  Http.

stop() ->
  mochiweb_http:stop(http_2904).

loop(Req) ->
  respond(Req:get(path), lists:sort(Req:parse_qs()), Req).
  
respond("/route", [{"from", From}, {"to", To}], Req) ->
  try requests:route(list_to_atom(From), list_to_atom(To)) of
    #route{path=Path, distance=Distance, time=Time} ->
      Coords = nodes_to_coords(Path),
      Res = {struct, [{route, Coords}, {distance, Distance}, {time, Time}]},
      Json = mochijson2:encode(Res),
      Req:ok({"text/plain;charset=utf-8", Json})
  catch
    _:X -> io:format("~p~n", [X])
  end;
  
respond("/route_description", [{"from", From}, {"to", To}], Req) ->
  try requests:route_description(list_to_atom(From), list_to_atom(To)) of
    Description ->
      FormattedDescription = [{struct, [{location, node_to_coords(NodeID)}, Distance, {walk, encode(Walk)}, {direction, encode(Direction)}]} ||
        [{node, NodeID}, Distance, _Angle, {walk, Walk}, {direction, Direction}] <- Description],
      NewFDesc = {struct, [{description, FormattedDescription}]},
      Json = mochijson2:encode(NewFDesc),
      Req:ok({"text/plain;charset=utf-8", Json})
  catch
    _:X -> io:format("~p~n", [X])
  end;
  
respond("/map", _Params, Req) ->
  Req:serve_file("ui.html", filename:absname("../www"));
  
respond(Path, _Params, Req) ->
  FileName = lists:nthtail(1, Path),
  Req:serve_file(FileName, filename:absname("../www")).

node_to_coords(Node) ->
  {Lat, Lon} = geodata:nodeid_to_coords(Node),
  {struct, [{node, Node}, {lat, Lat}, {lon, Lon}]}.

nodes_to_coords(Path) ->
  [{struct, [{node, Node}, {lat, Lat}, {lon, Lon}]} || {Node, {Lat, Lon}} <- lists:zip(Path, geodata:nodes_to_coords(Path))].
  
encode(String) ->
  unicode:characters_to_binary(io_lib:format("~ts", [String])).
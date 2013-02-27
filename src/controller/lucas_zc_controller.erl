-module(lucas_zc_controller, [Req]).

-compile(export_all).

aiyo('GET', []) ->
    {output, "sala"}.

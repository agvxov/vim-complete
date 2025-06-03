# Completion Protocol
> Super-simple protocol for completion servers

Line based. UNIX line endings are used.

    <prefix> [argument] \n

## Prefixes

    +----+    +---+
    | CS |    | E |
    +----+    +---+
      -         <
      >         ?
                =
      
### <
Called a "Bump".
Signals that the completion resource has changed.
Editor side.
Expects no respones.
Takes no argument.

### ?
Called a "Query".
Hints what words could be relevant to return.
Editor side.
Expects no respones.
Takes an argument, which is a filter to use.

### =
Called a "Poll".
Requests the completion words to be returned.
Editor side.
Expects a respones.
Takes no argument.

### -
Called a "Pass".
Signals that the completion words are not ready yet.
Completion-server side.
Expects no respones.
Takes no argument.

### >
Called a "Push".
Returns the relevant completion words.
Ideal response to a "Poll".
Completion-server side.
Expects no respones.
The argument is a whitespace separated list of words.

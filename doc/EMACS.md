Using the APL Package Manager inside Emacs
==========================================

*I no longer support Emacs integration. Patches are welcomed."

Elias Mårtenson has written a very nice `gnu-apl-mode` to edit APL
code and interact with GNU APL from within Emacs.

When run from inside Emacs, the APL Package Manager makes Emacs
(client-mode only) available as an editor for the `]pkg locate` and
`]pkg edit` commands.

In order to take advantage of this, you must be running an Emacs
server. I recommend adding the following to your `.emacs` or
`.emacs.d/init.el` file:

```
;; Start Emacs server.
(require 'server)
(unless (server-running-p)
  (server-start))
```

This will automatically initialize an Emacs server (only if needed)
when you start Emacs.

Please refer to Elias' documentation for configuration of
`gnu-apl-mode`.

Interaction with APL
--------------------

Note that when you initiate (using `]pkg locate` or `]pkg edit`) an
editing session with Emacs from within the APL Package Manager, you
must end that session in order to return control to the package
manager. Emacs should tell you how to do this in the message area,
like this:

```
When done with a buffer, type C-x #
```

Until you tell Emacs that you are done editing (or viewing) the
buffer, APL will wait with the message:

```
 Exit editor to continue 
_
```

The cursor (represented here by `_`) will be at the left margin on the
following line.

When you type `C-x #`, the APL session will show:

```
 Exit editor to continue 
 Waiting for Emacs... 
      _
```

Note that the cursor (shown as `_`) is now indented six spaces to
indicate that APL is ready for new input.

References
----------

1. [gnu-apl-mode](https://github.com/lokedhs)

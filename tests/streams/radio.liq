#!../../src/liquidsoap ../../libs/pervasives.liq

# Basic radio test

%include "test.liq"

mic = sine()
bed = mksafe(playlist("~/Music"))

radio = add([mic, bed])

output.dummy(fallible=true, radio)

def on_done () =
  test.pass()
  shutdown()
end

thread.run(delay=1., on_done)

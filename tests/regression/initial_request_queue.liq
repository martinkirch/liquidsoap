def f() =
  r = request.create("../media/@wav[stereo].wav")
  s = request.queue(queue=[r])
  s.on_track(synchronous=true, fun (_) -> test.pass())
  output.dummy(fallible=true, s)
end

test.check(f)

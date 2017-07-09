use "net"

actor Main
  new create(env: Env) =>
    try
      let cm = ConnectionManager(env.out)
      TCPListener(env.root as AmbientAuth, Listener(env.out, cm))
    else
      env.out.print("unable to use the network")
    end


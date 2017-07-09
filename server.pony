use "net"

class Listener is TCPListenNotify
  let _out: OutStream
  var _host: String = ""
  var _port: String = ""
  let _cm: ConnectionManager tag 

  new iso create(out: OutStream, cm: ConnectionManager tag) =>
    _out = out
    _cm = cm

  fun ref listening(listen: TCPListener ref) =>
    try
      (_host, _port) = listen.local_address().name()
      _out.print("listening on " + _host + ":" + _port)
    else
      _out.print("couldn't get local address")
      listen.close()
    end

  fun ref not_listening(listen: TCPListener ref) =>
    _out.print("couldn't listen")
    listen.close()

  fun ref connected(listen: TCPListener ref): TCPConnectionNotify iso^ =>
    Server(_out, _cm)

class Server is TCPConnectionNotify
  let _out: OutStream
  let _cm: ConnectionManager tag

  new iso create(out: OutStream, cm: ConnectionManager tag) =>
    _out = out
    _cm = cm 

  fun ref accepted(conn: TCPConnection ref) =>
    _out.print("connection accepted")
    _cm.accepted(conn)

  fun ref received(conn: TCPConnection ref, data: Array[U8] iso,
    times: USize): Bool =>       
    let cmd = String.from_iso_array(consume data)
    cmd.rstrip()
    _cm.cmdreceived(conn, consume cmd)    
    true

  fun ref closed(conn: TCPConnection ref) =>
    _out.print("server closed")
    _cm.closed(conn)

  fun ref connect_failed(conn: TCPConnection ref) =>
    _out.print("connect failed")
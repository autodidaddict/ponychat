use "net"
use "collections"

actor ConnectionManager
  let _out: OutStream 
  let _players: MapIs[TCPConnection, Player]  
  
  new create(out: OutStream) =>
    _players = MapIs[TCPConnection, Player]

    _out = out 
    _out.print("connection manager created")

  be accepted(conn: TCPConnection tag) =>
    _out.print("[CM] Connection accepted.")
    let p = Player(this, conn)
    _players(conn) = p
    
    _out.print(_players.size().string() + " players online.")    

  be closed(conn: TCPConnection tag) =>
    try      
      _players.remove(conn)      
    end
    _out.print("[CM] Connection closed.")

  be cmdreceived(conn: TCPConnection, cmd: String) =>
    _out.print("[CM] received command text.")
    try 
        _players(conn).parsecommand(cmd)        
    end 

  be broadcast(msg: String) =>
    _bcast(msg)

  fun _bcast(msg: String) =>
    for player in _players.values() do
        player.tell(msg)
    end

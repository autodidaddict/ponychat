use "net"

actor Player
    let _conn: TCPConnection tag 
    let _cm: ConnectionManager tag 
    var _pname: (String | None) = None 

    new create(cm: ConnectionManager tag, conn: TCPConnection tag) =>
        _cm = cm 
        _conn = conn 

    be tell(msg: String) =>
        _conn.write(msg) 
    
    be parsecommand(cmd: String) =>
        if _pname is None then
            _pname = cmd
            _conn.write("You've chosen a name.\n")                 
            _cm.broadcast(_name() + " has logged in.\n")    
        else 
            _conn.write("[Debug] You typed " + cmd + ".\n" )
            emitall("typed '" + cmd + "'\n")
        end 

    be emitall(text: String) =>
        _cm.broadcast(_name() + " " + text)
        
    fun _name(): String =>
        match _pname
        | let n: String => n
        else
            "Someone"
        end 

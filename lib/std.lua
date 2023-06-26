local std = {}

std.run = function(session,args,cmd)
    session:run(session.api.util.file.load.text(args[1]))
end

std['$'] = function(session,args,cmd)
    local lcmd = 'os.execute("' .. session.api.util.string.replace(cmd, "%$")  .. '")'
    print(lcmd)
    assert(session.api.util.load(lcmd))()
    session:run()
end

std['>'] = function(_session,args,cmd)
    session = _session
    cmd = _session.api.util.string.replace(cmd, ">", '')
    assert(_session.api.util.load(cmd))()
    session = nil
end

std.clear = function(s,a)
    os.execute(s.api.util.unix("clear","clr"))
end

std.pause = function(session,args)
    session:run()
end

std.exit = function(session,args)
    session.exit = true
end

std.terminate = function(session,args)
    os.exit()
end

std.echo = function(session,args) --unblocked
    for i, v in ipairs(args) do
        io.write(v .. ' ')
    end
    io.write('\n')
end

std.help = function(session,args)
    io.write("\27[32mAvaliable commands:\27[0m ")
    for k, v in pairs(session.cmd) do
        io.write(k .. ', ') 
    end
    io.write('\n')
end

return std

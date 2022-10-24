-- https://libreddit.kavin.rocks/r/awesomewm/comments/h07f5y/does_awesome_support_window_swallowing/
-- Thanks u/niknah and u/nfjlanlsad

function is_terminal(c)
    return (c.class and c.class:match("Alacritty")) and true or false
end

function copy_size(c, parent_client)
    if not c or not parent_client then
        return
    end
    if not c.valid or not parent_client.valid then
        return
    end
    c.x=parent_client.x;
    c.y=parent_client.y;
    c.width=parent_client.width;
    c.height=parent_client.height;
end
function check_resize_client(c)
    if(c.child_resize) then
        copy_size(c.child_resize, c)
    end
end

client.connect_signal("property::size", check_resize_client)
client.connect_signal("property::position", check_resize_client)

client.connect_signal("manage", function(c) 
    if is_terminal(c) then return end

    local parent_client=awful.client.focus.history.get(c.screen, 1)
    if c.pid then
        awful.spawn.easy_async('bash '..awesomedir..'/window_swallow/helper.sh gppid '..c.pid, function(gppid)
            if gppid then
                awful.spawn.easy_async('bash '..awesomedir..'/window_swallow/helper.sh ppid '..c.pid, function(ppid)
                    if parent_client and parent_client.pid and ppid and (gppid:find('^' .. parent_client.pid) or ppid:find('^' .. parent_client.pid)) and is_terminal(parent_client) then
                        parent_client.child_resize = c
                        

                        parent_client.force_minimalize = true
                        parent_client.minimized = true

                        c:connect_signal("unmanage", function() 
                            parent_client.minimized = false 
                            parent_client.force_minimalize = false
                        end)

                        copy_size(c, parent_client)
                    end
                end)
            end
        end)
    end
end)

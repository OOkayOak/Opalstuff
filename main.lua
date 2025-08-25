-- loader
OPAL = SMODS.current_mod
local mod_path = SMODS.current_mod.path

function OPAL.load_files(path)
    local files = NFS.getDirectoryItems(mod_path..path)
    for _, filename in ipairs(files) do
        file_path = path.."/"..filename
        local dir_success, dir_files = pcall(NFS.getDirectoryItems, file_path)
        if dir_success and not(filename:match(".lua$")) then -- this is a directory
            sendTraceMessage('Loading directory '..filename, 'Opalstuff')
            OPAL.load_files(file_path)
        end
        if filename:match(".lua$") then --this is a lua file
            sendTraceMessage('Loading file '..filename..' in directory '..path, 'Opalstuff')
            assert(SMODS.load_file(file_path))()
        end
    end
end

OPAL.load_files('src')
require 'image'
require 'xlua'

local folder = {'./f','./g','./q','./s','./w'}
local eachnum
local gtruth = {}

for i = 1, #folder do
    if (folder[i] == './q') then 
        eachnum = 1000
    else
        eachnum = 6000
    end
    
    local f = assert(io.open(folder[i]..'.txt'))
    for j = 1, eachnum do
        xlua.progress(j, eachnum)
        local line = f:read("*line")
        table.insert(gtruth, folder[i]..string.split(line,' ')[1])
    end
    io.close(f)
end
print(gtruth)

local totalnum = #gtruth
local shuffle = torch.randperm(totalnum)

local IMG = torch.Tensor(totalnum, 3, 48, 48):zero()
local LABEL = torch.Tensor(totalnum, 1):zero()

for i = 1, totalnum do
    xlua.progress(i, totalnum)
    local img = image.load(gtruth[shuffle[i]])
    IMG[i] = image.scale(img, 48, 48)
end

-- Save
local data_final = {}
data_final['data'] = IMG
data_final['label'] = LABEL
torch.save('./light.t7', data_final)


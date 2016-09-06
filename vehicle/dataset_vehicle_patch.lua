require 'image'
require 'xlua'
--draw = require 'draw'
local gtruth = {}
local gtfolder = './posGt'
local imfolder = './pos/'
local patchfolder = './small_patch/'


for fname in paths.iterfiles(gtfolder) do
    
    local f = assert(io.open(gtfolder..'/'..fname, 'r'))
    local tmpgtruth = {}
    table.insert(tmpgtruth, string.split(fname,'txt')[1]..'jpg')
    local flag = false

    while(1) do
        local line = f:read("*line")
        if (line == nil) then
            break
        end
        
        -- Get ground truth
        if (string.find(line, 'car') ~= nil) then
            flag = true
            local gtmp = string.split(line, ' ')
            table.insert(tmpgtruth, {tonumber(gtmp[2]), tonumber(gtmp[3]), 
                                     tonumber(gtmp[4]), tonumber(gtmp[5])})
        end        
    end 
    io.close(f)
    if flag then table.insert(gtruth, tmpgtruth) end
    
    print(fname)
end

print(gtruth)

local idx = 1
for i = 1, #gtruth do
    xlua.progress(i, #gtruth)
    local tmp = gtruth[i]
    local img = image.load(imfolder..tmp[1])
    local h,w = img:size(2),img:size(3)

    for j = 2, #tmp do
        local top = math.max(tmp[j][2], 1)
        local left = math.max(tmp[j][1], 1)
        local bottom = math.min(top+tmp[j][4]-1, h)
        local right = math.min(left+tmp[j][3]-1, w)
        local patch = img[{ {},{top,bottom},{left,right} }]
        image.save(patchfolder..idx..'.jpg', patch)
        idx = idx + 1
    end
    
    if (math.fmod(i, 1000) == 0) then collectgarbage() end
end

require 'image'
require 'xlua'
torch.setdefaulttensortype('torch.FloatTensor')

local imfolder = './small_patch/' 
local totalnum, trainnum, testnum = 29835, 15000, 14835
--local shuffle = torch.randperm(total)

local IMG = torch.Tensor(totalnum, 3, 48, 48):zero()
local LABEL = torch.Tensor(totalnum, 1):zero()

for i = 1, totalnum do
    xlua.progress(i, totalnum)
    local img = image.load(imfolder..i..'.jpg')
    IMG[i] = image.scale(img, 48, 48)
end

-- Save
local data_final = {}
data_final['data'] = IMG
data_final['label'] = LABEL
torch.save('./vehicle.t7', data_final)


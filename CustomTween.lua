local TweenService = game:GetService("TweenService")

local customTween = {}
local customTweenPrototype = {}
local customTweenPrivate = {}

function customTween.new(tweenTime, elements)
    local self = {}
    local private = {}
    
    self.tweenFinished = Instance.new("BindableEvent")
    self.onTweenFinished = self.tweenFinished.Event
    
    private.tweens = {}
    private.elements = elements
    private.tweenInfo = TweenInfo.new(tweenTime, Enum.EasingStyle.Linear)
    
    for _, element in elements do
        local goal = {Transparency = 1}
        if element:IsA("ImageLabel") then
            goal = {ImageTransparency = 1}
        elseif element:IsA("TextLabel") then
            goal = {TextTransparency = 1}
        end
        
        local tween = TweenService:Create(element, private.tweenInfo, goal)
        
        table.insert(private.tweens, tween)
    end
    
    customTweenPrivate[self] = private
    
    return setmetatable(self, customTweenPrototype)
end

function customTweenPrototype:play()
    local private = customTweenPrivate[self]
    
    for _, tween in private.tweens do
        task.spawn(function()
            tween:Play()
            tween.Completed:Connect(function()
                self.tweenFinished:Fire()
            end)
        end)
    end
end

function customTweenPrototype:destroy()
    self.tweenFinished:Destroy()
    self = nil
end

customTweenPrototype.__index = customTweenPrototype

return customTween

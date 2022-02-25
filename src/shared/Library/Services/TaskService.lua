local class = {}
class.__index = class
-- IMPORTS
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
-- STARTS


-- VARIABLES
local _content = {}


-- Gets task by its id.
-- @param _id Task id.
-- @return Task. (NULLABLE)
function class.getById(_id : ObjectValue)
    -- Object nil checks.
    assert(_id ~= nil, "Task id cannot be null")
    return _content[_id]
end

-- Creates a delayed task.
-- @param delay Delay(seconds) to run. (OPTIONAL = NIL)
-- @return Task.
function class.createDelayed(_delay : number, _consumer : ObjectValue)
    return class.create(_delay, nil, _consumer)
end

-- Creates a repeating task.
-- @param every Runs every declared time(seconds). (OPTIONAL = NIL)
-- @return Task.
function class.createRepeating(_every : number, _consumer : ObjectValue)
    return class.create(nil, _every, _consumer)
end

-- Creates a task.
-- @param delay Delay(seconds) to run. (OPTIONAL = NIL)
-- @param every Runs every declared time(seconds). (OPTIONAL = NIL)
-- @return Task.
function class.create(_delay : number, _every : number, _consumer : ObjectValue)
    -- Object nil checks.
    assert(_consumer ~= nil, "Task consumer cannot be null")
    assert(_delay ~= nil or _every ~= nil, "Task must have delay or every, both cannot be null")

    if _delay and _delay <= 0 then error("Task delay must be higher than 0") end
    if _every and _every <= 0 then error("Task every must be higher than 0") end

    -- Creates a task object.
    local _task = {
        ["id"] = HttpService:GenerateGUID(false),

        ["delay"] = _delay,
        ["every"] = _every,

        ["consumer"] = _consumer,
        ["error_consumer"] = nil,
        ["complete_consumer"] = nil,
        ["cancel_consumer"] = nil,

        ["running"] = false,
        ["completed"] = false,
        ["heartbeat"] = nil,

        ["elapsed_time"] = 0,
        ["previous_time"] = 0,

        ["timer"] = 0,
        ["timer_turn"] = 0
    }

    _content[_task.id] = _task

    -- Sets metatable and returns it.
    return setmetatable(_task, class)
end

-- Gets task metadata.
-- @return Metadata.
function class:getMetadata()
    if not self.metadata then
        self.metadata = require(script.Parent.Parent:WaitForChild("Templates"):WaitForChild("Metadata")).new()
    end
    return self.metadata
end

-- Gets task id.
-- @return Task id. (UUID)
function class:getId()
    return self.id
end

-- Gets task delay.
-- @return Task delay. (NUMBER)
function class:getDelay()
    return self.delay
end

-- Gets task every.
-- @return Task every. (NUMBER)
function class:getEvery()
    return self.every
end

-- Gets elapsed time.
-- @return Elapsed time.
function class:getElapsedTime()
	return self.elapsed_time
end

-- Gets previous time.
-- @return Previous time.
function class:getPreviousTime()
	return self.previous_time
end

-- Gets timer time.
-- @return Timer time.
function class:getTimerTime()
	return self.timer
end

-- Gets timer turn
-- @return Timer turn.
function class:getTimerTurn()
	return self.timer_turn
end

-- Gets if task is running or not.
-- @return If task is running or not.
function class:isRunning()
	return self.running
end

-- Be triggered when task throws error.
--
-- Exceptions:
-- * Will not be triggered if it is cancelled.
-- * Will not be triggered if it cancelled due to completion.
--
-- @param _consumer Consumer(function) to call when task throws error.
-- @return Task. (BUILDER)
function class:onError(_consumer : ObjectValue)
    -- Object nil checks.
    assert(_consumer ~= nil, "Task(" .. self.id .. ")'s error consumer cannot be null")
    self.error_consumer = _consumer
    return self
end

-- Be triggered when task is completed.
--
-- Exceptions:
-- * Will not be triggered if it is cancelled.
-- * Will not be triggered if it cancelled due to error.
--
-- @param _consumer Consumer(function) to call when task gets error.
-- @return Task. (BUILDER)
function class:onComplete(_consumer : ObjectValue)
    -- Object nil checks.
    assert(_consumer ~= nil, "Task(" .. self.id .. ")'s complete consumer cannot be null")
    self.complete_consumer = _consumer
    return self
end

-- Be triggered when task is cancelled.
--
-- Exceptions:
-- * Will trigger even getting error and completed.
-- * Will trigger after task completion even not using 'cancel' method.
--
-- @param _consumer Consumer(function) to call when task is cancelled.
-- @return Task. (BUILDER)
function class:onCancel(_consumer : ObjectValue)
    -- Object nil checks.
    assert(_consumer ~= nil, "Task(" .. self.id .. ")'s cancel consumer cannot be null")
    self.cancel_consumer = _consumer
    return self
end

-- Runs task.
-- @return Task. (BUILDER)
function class:run()
    -- Exception handling.
    if self.running then error("Tried running task(" .. self.id .. ") even it is already running") end
    if self.completed then error("Tried running task(" .. self.id .. ") even it is completed") end

    self.running = true

    -- Handles task heartbeat.
    self.heartbeat = RunService.Heartbeat:Connect(function(delta)
		-- Increases timers.
		self.elapsed_time += delta
		self.previous_time = delta
		
		-- If delay is set and not passed yet, no need to continue.
		if self.delay ~= nil and self.delay >= self.elapsed_time then return end
		
		-- If every is not nil.
		if self.every ~= nil then
			-- Increases timer.
			self.timer += delta

			-- If ever is set and not passed yet, no need to continue.
			if self.every > self.timer then return end

			-- Resets timer.
			self.timer = self.timer - self.every
			self.timer_turn += 1
		end

        -- Calls consumer.
        local _success, _status = pcall(self.consumer, self)

        -- Handles errors.
        if not _success then
            -- Cancels task.
            self:cancel()

            -- If there is a error consumer, runs it.
            if self.error_consumer ~= nil then 
                self.error_consumer(self, _status)
                return
            end
            
            error("Couldn't run task(" .. self.id .. ")! -> " .. _status)
            return
        end

		-- If there is no "every", stops the run service.
		if self.every == nil then
            -- Cancels task since it is completed.
            self:cancel()

            -- If there is a complete consumer, runs it.
            if self.complete_consumer ~= nil then self.complete_consumer(self) end
        end
    end)

    return self
end

-- Cancels running task.
function class:cancel()
	-- If task is not running, no need to continue.
    if not self.running then error("Tried stopping task(" .. self.id .. ") even it is not running") end

    _content[self.id] = nil

	self.running = false
    if self.metadata then self.metadata:reset() end
	self.heartbeat:Disconnect()

    -- If there is a cancel consumer, runs it.
    if self.cancel_consumer ~= nil then self.cancel_consumer(self) end
end


-- ENDS
return class
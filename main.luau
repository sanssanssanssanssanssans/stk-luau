type Node = {
	data: any,
	next: Node?
}

type Stack = {
	top: Node?,
	push: (self: Stack, data: any) -> (),
	pop: (self: Stack) -> (any?),
	peek: (self: Stack) -> (any?),
	isEmpty: (self: Stack) -> (boolean),
	display: (self: Stack) -> (),
	sort: (self: Stack, reverse: boolean) -> (),
	partition: (self: Stack, low: number, high: number, reverse: boolean) -> number
}

local StackImpl = {}
StackImpl.__index = StackImpl

function StackImpl.new(top: Node?): Stack
	return setmetatable({ top = top }, StackImpl) :: Stack
end

function StackImpl.push(self: Stack, data: any)
	local newNode: Node = { data = data, next = self.top }
	self.top = newNode
end

function StackImpl.pop(self: Stack): any?
	if self.top == nil then
		error("Stack Underflow")
	end

	local temp = self.top
	self.top = self.top.next
	return temp.data
end

function StackImpl.peek(self: Stack): any?
	if self.top == nil then
		error("Stack is empty")
	end
	return self.top.data
end

function StackImpl.isEmpty(self: Stack): boolean
	return self.top == nil
end

function StackImpl.display(self: Stack)
	local buffer = {}
	if self.top == nil then
		table.insert(buffer, "Stack is empty")
		print(table.concat(buffer, "\n"))
		return
	end

	local temp = self.top
	while temp do
		table.insert(buffer, tostring(temp.data))
		if temp.next then
			table.insert(buffer, " -> ")
		end
		temp = temp.next
	end
	print(table.concat(buffer, ""))
end

function StackImpl.partition(self: Stack, low: number, high: number, reverse: boolean): number
	local arr = {}
	local temp = self.top
	local idx = 1

	while temp do
		table.insert(arr, temp.data)
		temp = temp.next
	end

	local pivot = arr[high]
	local i = low - 1

	for j = low, high - 1 do
		if arr[j] ~= nil and pivot ~= nil then
			if (reverse and arr[j] > pivot) or (not reverse and arr[j] < pivot) then
				i = i + 1
				arr[i], arr[j] = arr[j], arr[i]
			end
		end
	end

	if arr[high] ~= nil then
		arr[i + 1], arr[high] = arr[high], arr[i + 1]
	end

	self.top = nil
	for i = #arr, 1, -1 do
		self:push(arr[i])
	end

	return i + 1
end

local function quickSort(arr, low, high, reverse)
	if low < high then
		local pi = StackImpl:partition(low, high, reverse)
		quickSort(arr, low, pi - 1, reverse)
		quickSort(arr, pi + 1, high, reverse)
	end
end

function StackImpl.sort(self: Stack, reverse: boolean)
	local arr = {}
	local temp = self.top
	local idx = 1
	while temp do
		table.insert(arr, temp.data)
		temp = temp.next
	end

	quickSort(arr, 1, #arr, reverse)

	self.top = nil
	for i = #arr, 1, -1 do
		self:push(arr[i])
	end
end
return StackImpl

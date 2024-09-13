function change(amount)
  if math.type(amount) ~= "integer" then
    error("Amount must be an integer")
  end
  if amount < 0 then
    error("Amount cannot be negative")
  end
  local counts, remaining = {}, amount
  for _, denomination in ipairs({25, 10, 5, 1}) do
    counts[denomination] = remaining // denomination
    remaining = remaining % denomination
  end
  return counts
end

function first_then_lower_case(array, predicate)
  for index,value in ipairs(array) do 
    if predicate(array[index]) == true then
      return string.lower(value);
    end
  end
  return nil;
end

function powers_generator(base, limit)
  return coroutine.create(function()
    local num = 0
    while true do
      local power = base^num
      if power > limit then
        return
      end
      coroutine.yield(power)
      num = num + 1
    end
  end)
end

function say(word)
  if word == nil then
    return ""
  end
  return function(next_word)
    if next_word == nil then
      return word
    else
      return say(word .. " " .. next_word)
    end
  end
end

function meaningful_line_count(filename)
  line_number = 0
  file = io.open(filename, 'r')
  if file == nil then
  error("No such file")
  end
  for line in file:lines() do
    local trimmed_line = line:match("^%s*(.-)%s*$")
    if trimmed_line ~= "" and not trimmed_line:match("^#") then
      line_number = line_number + 1
    end
  end
  file:close()
  return line_number
end

Quaternion = (function (class)
  class.new = function(a,b,c,d)
    return setmetatable({a = a, b = b, c = c, d = d}, {
      __index = {
        coefficients = function(self)
          return {self.a, self.b, self.c, self.d}
        end,
        conjugate = function(self)
          return class.new(self.a, self.b * -1, self.c * -1,self.d* -1)
        end
      },
      __tostring = function(self)
        local total = {}
        if self.a ~= 0 or (self.b == 0 and self.c == 0 and self.d == 0) then
          table.insert(total, tostring(self.a))
        end
        if self.b ~= 0 then
          if self.b == 1 then
            table.insert(total, (#total > 0 and "+i" or "i"))
          elseif self.b == -1 then
            table.insert(total, (#total > 0 and "-i" or "-i"))
          else
            table.insert(total, (#total > 0 and (self.b > 0 and "+" or "") .. tostring(self.b) .. "i" or tostring(self.b) .. "i"))
          end
        end
        if self.c ~= 0 then
          if self.c == 1 then
            table.insert(total, (#total > 0 and "+j" or "j"))
          elseif self.c == -1 then
            table.insert(total, (#total > 0 and "-j" or "-j"))
          else
            table.insert(total, (#total > 0 and (self.c > 0 and "+" or "") .. tostring(self.c) .. "j" or tostring(self.c) .. "j"))
          end
        end
        if self.d ~= 0 then
          if self.d == 1 then
            table.insert(total, (#total > 0 and "+k" or "k"))
          elseif self.d == -1 then
            table.insert(total, (#total > 0 and "-k" or "-k"))
          else
            table.insert(total, (#total > 0 and (self.d > 0 and "+" or "") .. tostring(self.d) .. "k" or tostring(self.d) .. "k"))
          end
        end
        local result = table.concat(total)
        if result:sub(1, 1) == "+" then
          result = result:sub(2)
        end
        return result ~= "" and result or "0"
      end,
      __add = function(self, q)
        return class.new(self.a + q.a, self.b + q.b, self.c + q.c, self.d + q.d)
      end,
      __mul = function(self, q)
        return class.new(
          self.a * q.a - self.b * q.b - self.c * q.c - self.d * q.d,
          self.a * q.b + self.b * q.a + self.c * q.d - self.d * q.c,
          self.a * q.c - self.b * q.d + self.c * q.a + self.d * q.b,
          self.a * q.d + self.b * q.c - self.c * q.b + self.d * q.a
        )
      end,
      __eq = function(self, q)
        return self.a == q.a and self.b == q.b and self.c == q.c and self.d == q.d
      end
    })
  end

  return class
end)({})
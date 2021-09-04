--- Functional Programming module.
-- Collection of functions and operators to help programming in a functional way.
-- @module utils.fp
-- @alias M
-- @author soywod <clement.douin@posteo.net>

local M = {}

--- Implementation of the functions composition.
-- @tparam {function,...} {...} array of functions to compose from right to left
-- @treturn function the composed function
function M.compose(...)
  local args = {...}
  return function(x)
    if #args == 0 then
      return x
    else
      local f = table.remove(args, #args)
      return M.compose(unpack(args))(f(x))
    end
  end
end

--- Implementation of the `map` operator.
-- @tparam function fn a functor
-- @tparam table iter an iterable
-- @treturn table the new iterable
function M.map(fn, iter)
  local output = {}
  for key in pairs(iter) do
    output[key] = fn(key, iter[key], iter)
  end
  return output
end

return M

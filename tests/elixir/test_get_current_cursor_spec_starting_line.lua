local T = MiniTest.new_set()
local eq = MiniTest.expect.equality

local Elixir = require('spec_runner.langs.elixir')
local with_buffer = require('tests.helpers').with_buffer

T['describe blocks'] = MiniTest.new_set()

T['describe blocks']['finds the enclosing describe block'] = function()
  with_buffer({
    'defmodule ExampleTest do',
    '  describe "calculator" do',
    '    test "adds numbers" do',
    '      assert 1 + 1 == 2',
    '    end',
    '  end',
    'end',
  }, { 4, 6 }, function()
    eq(Elixir:get_current_cursor_spec_starting_line(), 2)
  end)
end

T['it blocks'] = MiniTest.new_set()

T['it blocks']['finds the enclosing it block'] = function()
  with_buffer({
    'defmodule ExampleTest do',
    '  describe "calculator" do',
    '    it "adds numbers" do',
    '      assert 1 + 1 == 2',
    '    end',
    '  end',
    'end',
  }, { 4, 6 }, function()
    eq(Elixir:get_current_cursor_spec_starting_line(), 3)
  end)
end

T['fallback'] = MiniTest.new_set()

T['fallback']['returns line one when no spec block is found'] = function()
  with_buffer({
    'defmodule ExampleTest do',
    '  setup do',
    '    :ok',
    '  end',
    'end',
  }, { 3, 4 }, function()
    eq(Elixir:get_current_cursor_spec_starting_line(), 1)
  end)
end

return T

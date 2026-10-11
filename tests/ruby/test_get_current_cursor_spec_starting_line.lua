local T = MiniTest.new_set()
local eq = MiniTest.expect.equality

local Ruby = require('spec_runner.langs.ruby')
local with_buffer = require('tests.helpers').with_buffer

T['describe blocks'] = MiniTest.new_set()

T['describe blocks']['finds the enclosing describe block'] = function()
  with_buffer({
    "RSpec.describe User do",
    "  describe '#name' do",
    "    it 'returns the name' do",
    "      expect(subject.name).to eq('Alice')",
    "    end",
    "  end",
    "end",
  }, { 4, 8 }, function()
    eq(Ruby:get_current_cursor_spec_starting_line(), 3)
  end)
end

T['context blocks'] = MiniTest.new_set()

T['context blocks']['finds the enclosing context block'] = function()
  with_buffer({
    "RSpec.describe User do",
    "  describe '#name' do",
    "    context 'when present' do",
    "      it 'returns the name' do",
    "        expect(subject.name).to eq('Alice')",
    "      end",
    "    end",
    "  end",
    "end",
  }, { 5, 10 }, function()
    eq(Ruby:get_current_cursor_spec_starting_line(), 4)
  end)
end

T['it blocks'] = MiniTest.new_set()

T['it blocks']['finds the enclosing it block'] = function()
  with_buffer({
    "RSpec.describe User do",
    "  it 'returns the name' do",
    "    expect(subject.name).to eq('Alice')",
    "  end",
    "end",
  }, { 3, 6 }, function()
    eq(Ruby:get_current_cursor_spec_starting_line(), 2)
  end)
end

T['fallback'] = MiniTest.new_set()

T['fallback']['returns line one when no spec block is found'] = function()
  with_buffer({
    "def helper",
    "  42",
    "end",
  }, { 2, 2 }, function()
    eq(Ruby:get_current_cursor_spec_starting_line(), 1)
  end)
end

return T

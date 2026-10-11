local T = MiniTest.new_set()
local eq = MiniTest.expect.equality

local Dart = require('spec_runner.langs.dart')
local with_buffer = require('tests.helpers').with_buffer

T['test blocks'] = MiniTest.new_set()

T['test blocks']['returns the test name'] = function()
  with_buffer({
    'void main() {',
    '  test("adds numbers", () {',
    '    expect(1 + 1, 2);',
    '  });',
    '}',
  }, { 3, 4 }, function()
    eq(Dart:get_current_cursor_spec_starting_line(), ' --name "adds numbers"')
  end)
end

T['test blocks']['supports single-quoted raw strings'] = function()
  with_buffer({
    'void main() {',
    "  test(r'raw string test', () {",
    '    expect(true, isTrue);',
    '  });',
    '}',
  }, { 3, 4 }, function()
    eq(Dart:get_current_cursor_spec_starting_line(), " --name 'raw string test'")
  end)
end

T['test blocks']['returns the widget test name'] = function()
  with_buffer({
    'void main() {',
    '  testWidgets("renders correctly", (tester) async {',
    '    await tester.pumpWidget(const MyWidget());',
    '  });',
    '}',
  }, { 3, 4 }, function()
    eq(Dart:get_current_cursor_spec_starting_line(), ' --name "renders correctly"')
  end)
end

T['group blocks'] = MiniTest.new_set()

T['group blocks']['returns the nearest group name when outside a test'] = function()
  with_buffer({
    'void main() {',
    '  group("calculator", () {',
    '    test("adds numbers", () {',
    '      expect(1 + 1, 2);',
    '    });',
    '  });',
    '}',
  }, { 6, 2 }, function()
    eq(Dart:get_current_cursor_spec_starting_line(), ' --name "calculator"')
  end)
end

T['fallback'] = MiniTest.new_set()

T['fallback']['returns an empty string when no test block is found'] = function()
  with_buffer({
    'void main() {',
    '  final value = 42;',
    '  print(value);',
    '}',
  }, { 3, 2 }, function()
    eq(Dart:get_current_cursor_spec_starting_line(), '')
  end)
end

T['fallback']['returns an empty string when the cursor is inside main'] = function()
  with_buffer({
    'void main() {',
    '  test("example", () {',
    '    expect(true, isTrue);',
    '  });',
    '}',
  }, { 5, 0 }, function()
    eq(Dart:get_current_cursor_spec_starting_line(), '')
  end)
end

return T

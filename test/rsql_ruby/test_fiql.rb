gem 'minitest'
require 'minitest/autorun'
require 'rsql_ruby'

module TestRsqlRuby; end

class TestRsqlRuby::TestFiql < Minitest::Test
  def test_basic_expressions
    parser = RsqlRuby::Parser.new

    {
      "a=eq=b": { type: :CONSTRAINT, selector: 'a', comparison: '=eq=', argument: 'b' },
      "a=custom=b": { type: :CONSTRAINT, selector: 'a', comparison: '=custom=', argument: 'b' },
      "a==b": { type: :CONSTRAINT, selector: 'a', comparison: '==', argument: 'b' },
      "a==2018-09-01T12:14:28Z": { type: :CONSTRAINT, selector: 'a', comparison: '==', argument: '2018-09-01T12:14:28Z' },
      "a!=b": { type: :CONSTRAINT, selector: 'a', comparison: '!=', argument: 'b' },
      "field=op=(item0,item1,item2)": { type: :CONSTRAINT, selector: 'field', comparison: '=op=', argument: ['item0', 'item1', 'item2'] },
    }.each do |key, output|
      assert_equal(parser.parse(key.to_s), output)
    end
  end

  def test_combinations
    {
      "a=eq=b;c=ne=d" => {
        type: :COMBINATION,
        operator: :AND,
        lhs: { type: :CONSTRAINT, selector: 'a', comparison: '=eq=', argument: 'b' },
        rhs: { type: :CONSTRAINT, selector: 'c', comparison: '=ne=', argument: 'd' },
      },
      "a=eq=b;c=ne=d;e=gt=f" => {
        type: :COMBINATION,
        operator: :AND,
        lhs: { type: :CONSTRAINT, selector: 'a', comparison: '=eq=', argument: 'b' },
        rhs: {
          type: :COMBINATION,
          operator: :AND,
          lhs: { type: :CONSTRAINT, selector: 'c', comparison: '=ne=', argument: 'd' },
          rhs: { type: :CONSTRAINT, selector: 'e', comparison: '=gt=', argument: 'f' }
        }
      },
      "a=eq=b,c=ne=d" => {
        type: :COMBINATION,
        operator: :OR,
        lhs: { type: :CONSTRAINT, selector: 'a', comparison: '=eq=', argument: 'b' },
        rhs: { type: :CONSTRAINT, selector: 'c', comparison: '=ne=', argument: 'd' },
      },
      "a=eq=b,c=ne=d,e=gt=(f,g,c)" => {
        type: :COMBINATION,
        operator: :OR,
        lhs: { type: :CONSTRAINT, selector: 'a', comparison: '=eq=', argument: 'b' },
        rhs: {
          type: :COMBINATION,
          operator: :OR,
          lhs: { type: :CONSTRAINT, selector: 'c', comparison: '=ne=', argument: 'd' },
          rhs: { type: :CONSTRAINT, selector: 'e', comparison: '=gt=', argument: ['f', 'g', 'c'] }
        }
      },
      "a=eq=b;c=ne=d,e=gt=f" => { # OR BEFORE AND
        type: :COMBINATION,
        operator: :OR,
        lhs: {
          type: :COMBINATION,
          operator: :AND,
          lhs: { type: :CONSTRAINT, selector: 'a', comparison: '=eq=', argument: 'b' },
          rhs: { type: :CONSTRAINT, selector: 'c', comparison: '=ne=', argument: 'd' }
        },
        rhs: { type: :CONSTRAINT, selector: 'e', comparison: '=gt=', argument: 'f' },
      },
      'a=eq=b;(c=ne=d,e=gt=f)' => { # GROUPING
        type: :COMBINATION,
        operator: :AND,
        lhs: { type: :CONSTRAINT, selector: 'a', comparison: '=eq=', argument: 'b' },
        rhs: {
          type: :COMBINATION,
          operator: :OR,
          lhs: { type: :CONSTRAINT, selector: 'c', comparison: '=ne=', argument: 'd' },
          rhs: { type: :CONSTRAINT, selector: 'e', comparison: '=gt=', argument: 'f' }
        }
      }
    }.each do |key, output|
      assert_equal(RsqlRuby.parse(key.to_s), output)
    end
  end

end
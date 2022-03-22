# frozen_string_literal: true

require_relative "rspec_structure_matcher/version"

require_relative "structure"

include Structure::Type::Methods

RSpec::Matchers.define :match_structure do |structure|
  match do |json|
    @key = 'root'
    begin
      explore_structure(structure, json)
    rescue Structure::Type::SizeError => e
      @message = e.message
      false
    rescue Structure::Type::MatchError => e
      @message = e.message
      false
    end
  end

  def size_fail(structure, json)
    raise Structure::Type::SizeError,
          "Wrong size at #{@key}: #{json.size} != #{structure.size}"
  end

  def structure_fail(structure, json)
    raise Structure::Type::MatchError,
          "Structure:\n#{structure.pretty_inspect}\nGiven:\n#{json.pretty_inspect}"
  end

  def explore_structure(struc, json)
    # example: 1 ~= Integer
    if struc.is_a? Class
      structure_fail(struc, json) unless json.is_a?(struc)
      # example: "foobar" ~= /f[o]+bar/
    elsif struc.is_a?(Regexp) && json.is_a?(String)
      structure_fail(struc, json) unless json.match?(struc)
      # example: [1, 2, 3] ~= a_list_of(Integer)
    elsif struc.is_a? Structure::Type::Array
      struc.matches?(json) { |j, s| explore_structure(j, s) }
      # example: 1 ~= one_of(Integer, String)
    elsif struc.is_a? Structure::Type::Single
      struc.matches?(json) { |j, s| explore_structure(j, s) }
      # example: {a: b, c: d} ~= {a: Integer, b: String}
    elsif json.is_a?(Hash)
      structure_fail(struc, json) unless struc.is_a? Hash
      struc = struc.with_indifferent_access
      json = json.with_indifferent_access
      struc.all? do |k, v|
        @key = k
        structure_fail(struc, json) unless json.key?(k)
        explore_structure(v, json[k])
      end
      # example: [1, 2, 3] ~= [1, 2, 3]
    elsif json.is_a?(Array)
      structure_fail(struc, json) unless struc.is_a? Array
      size_fail(struc, json) if struc.size != json.size
      return struc.zip(json).all? do |s, j|
        @key = s
        explore_structure(s, j)
      end
      # example: 3 ~= 3
    else
      structure_fail(struc, json) unless json == struc
    end
    true
  end

  failure_message do |json|
    "#{json.pretty_inspect}\ndoes not match structure\n#{structure.pretty_inspect}\n\n#{@message}"
  end

  failure_message_when_negated do |json|
    "#{json.pretty_inspect}\nis matching structure\n#{structure.pretty_inspect}"
  end
end

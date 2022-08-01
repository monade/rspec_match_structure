# frozen_string_literal: true

RSpec.describe RspecMatchStructure do
  it "matches the empty object" do
    expect do
      expect({}).to match_structure({})
    end.not_to raise_error
  end

  it "matches an object agains a schema with classes" do
    expect do
      expect({ id: "33", type: "ciaone" })
        .to match_structure({
                              id: String,
                              type: String
                            })
    end.not_to raise_error
  end

  it "matches an object agains a schema with classes and literals" do
    expect do
      expect({ id: "33", type: "hello" })
        .to match_structure({
                              id: String,
                              type: "hello"
                            })
    end.not_to raise_error
  end

  it "does not match string against number" do
    expect do
      expect(
        {
          id: 123,
          type: "aType"
        }
      ).to match_structure(
        {
          id: String
        }
      )
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "matches a list of schemas defined with classes" do
    expect do
      expect([
               {
                 id: 123,
                 type: "aType"
               },
               {
                 id: 555,
                 type: "anotherType"
               }
             ]).to match_structure(
               a_list_of({
                           id: Integer,
                           type: String
                         })
             )
    end.not_to raise_error
  end

  it "does not match a list of structure any structure is not matching" do
    expect do
      expect([
               {
                 id: 123,
                 type: "aType"
               },
               {
                 id: 555,
                 type: "anotherType"
               }
             ]).to match_structure(
               a_list_of({
                           id: String,
                           type: String
                         })
             )
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "matches a list against a schema with a fixed count" do
    expect do
      expect([
               {
                 id: 123,
                 type: "aType"
               },
               {
                 id: 555,
                 type: "anotherType"
               }
             ]).to match_structure(
               a_list_of({
                           id: Integer,
                           type: String
                         }).with(2).elements
             )
    end.not_to raise_error
  end

  it "matches a list with at least one schema as defined" do
    expect do
      expect([
               {
                 id: 123,
                 type: "aType"
               },
               {
                 id: 555,
                 type: "anotherType"
               }
             ]).to match_structure(
               a_list_with({
                             type: "anotherType"
                           })
             )
    end.not_to raise_error
  end

  it "does not match a list not containing a struct as defined" do
    expect do
      expect([
               {
                 id: 123,
                 type: "aType"
               },
               {
                 id: 333,
                 type: "aType"
               },
               {
                 id: 555,
                 type: "anotherType"
               }
             ]).to match_structure(
               a_list_with({
                             id: "thirdType"
                           })
             )
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "does not match a list not containing directly a struct as defined" do
    expect do
      expect([
               {
                 id: 123,
                 type: "aType"
               },
               {
                 id: 333,
                 type: "aType"
               },
               {
                 id: 555,
                 type: "anotherType",
                 relationships: [
                   {
                     id: 666,
                     type: "aThirdType"
                   }
                 ]
               }
             ]).to match_structure(
               a_list_with({ id: String, type: "aThirdType" })
             )
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "matches a list containing at least one struct as defined specifying an exact count" do
    expect do
      expect([
               {
                 id: 123,
                 type: "aType"
               },
               {
                 id: 333,
                 type: "aType"
               },
               {
                 id: 555,
                 type: "anotherType"
               }
             ]).to match_structure(
               a_list_with({
                             type: "aType"
                           }).exactly(2).times
             )
    end.not_to raise_error
  end

  it "matches a list with some elements matching the struct as defined specifying a range count" do
    expect do
      expect([
               {
                 id: 123,
                 type: "aType"
               },
               {
                 id: 333,
                 type: "aType"
               },
               {
                 id: 555,
                 type: "anotherType"
               }
             ]).to match_structure(
               a_list_with({
                             type: "aType"
                           }).between(2, 3)
             )
    end.not_to raise_error
  end

  it "does not match a list containing at least one struct as defined when count is outside a range" do
    expect do
      expect([
               {
                 id: 123,
                 type: "aType"
               },
               {
                 id: 333,
                 type: "aType"
               },
               {
                 id: 555,
                 type: "anotherType"
               }
             ]).to match_structure(
               a_list_with({
                             type: "aType"
                           }).between(3, 5)
             )
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "matches a list of generic types" do
    expect do
      expect([
               {
                 id: 123,
                 type: "aType"
               },
               {
                 id: 555,
                 type: "anotherType"
               }
             ]).to match_structure(
               a_list_of(Hash)
             )
    end.not_to raise_error
  end

  it "matches list literals" do
    expect do
      expect([
               1, 2, 3
             ]).to match_structure(
              [1, 2, 3]
             )
    end.not_to raise_error
  end
  it "does not match list literals if not identical" do
    expect do
      expect([
               1, 2, 3
             ]).to match_structure(
              [1, 2]
             )
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "does not match a list when size is not matching" do
    expect do
      expect([
               1, 2, 3
             ]).to match_structure(
                     a_list_of(Integer).with(2).elements
             )
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end
  it "does not match a list when size is not satisfying a minimum condition" do
    expect do
      expect([
               1, 2, 3
             ]).to match_structure(
                     a_list_of(Integer).with(10).elements_at_least
             )
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "matches a list when size is satisfying a minimum condition" do
    expect do
      expect([
               1, 2, 3
             ]).to match_structure(
                     a_list_of(Integer).with(1).elements_at_least
                   )
    end.not_to raise_error
  end


  it "does match a list when size is satisfying a maximum condition" do
    expect do
      expect([
               1, 2, 3
             ]).to match_structure(
                     a_list_of(Integer).with(10).elements_at_most
                   )
    end.not_to raise_error
  end

  it "does not match a list when size is exceeding a maximum condition" do
    expect do
      expect([
               1, 2, 3
             ]).to match_structure(
                     a_list_of(Integer).with(1).elements_at_most
                   )
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "does match a string against a regexp" do
    expect do
      expect("abc").to match_structure(
        /abc/
      )
    end.not_to raise_error
  end


  it "does not match a string against a not matching regexp" do
    expect do
      expect("abc").to match_structure(
                         /bcd/
                       )
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

  it "match a list against a schema defined as a list of one of some classes" do
    expect do
      expect([
               1, 2, 3
             ]).to match_structure(
                     a_list_of(one_of(Integer, String))
             )
    end.not_to raise_error
  end

  it "matches a literal agains many possibile classes" do
    expect do
      expect(1).to match_structure(
                     one_of(Integer, String)
             )
    end.not_to raise_error
  end

  it "does not match one of" do
    expect do
      expect(nil).to match_structure(
                     one_of(Integer, String)
             )
    end.to raise_error(RSpec::Expectations::ExpectationNotMetError)
  end

end

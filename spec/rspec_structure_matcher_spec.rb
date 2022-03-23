# frozen_string_literal: true

RSpec.describe RspecStructureMatcher do
  it "matches the empty object" do
    expect do
      expect({}).to match_structure({})
    end.not_to raise_error
  end

  it "matches generic object" do
    expect do
      expect({ id: "33", type: "ciaone" })
        .to match_structure({
                              id: String,
                              type: String
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

  it "matches a list of structures" do
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

  it "matches a list size" do
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

  it "matches a list with at least one struct as defined" do
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

  it "matches a list containing at least one struct as defined specifying a count" do
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
end

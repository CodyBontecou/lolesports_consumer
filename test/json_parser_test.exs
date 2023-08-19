defmodule JSONParserTest do
  use ExUnit.Case

  describe "decode_nested/1" do
    test "successfully decodes nested JSON" do
      json = """
      {
        "nested": {
          "data": "hello"
        }
      }
      """

      expected = %{"nested" => %{"data" => "hello"}}
      actual = JSONParser.decode_nested(json)

      assert actual === expected
    end

    test "returns error tuple on failed JSON decoding" do
      json = """
      {,
        "nested": {
          "data": "hello"
        }
      },
      """

      expected = {:error, "Error decoding JSON"}
      actual = JSONParser.decode_nested(json)

      assert actual === expected
    end

    test "unknown JSON structure" do
      json = 1234

      expected = {:error, "Unknown JSON structure"}
      actual = JSONParser.decode_nested(json)

      assert actual === expected
    end
  end
end

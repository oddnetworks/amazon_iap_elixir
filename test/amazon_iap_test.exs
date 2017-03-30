defmodule AmazonIAPTest do
  use ExUnit.Case, async: true
  
  import :meck
  alias AmazonIAP

  setup do
    new :hackney
    on_exit fn -> unload() end
    :ok
  end

  test "verify_receipt/3" do
    response = %{
      "purchaseDate" => 12345,
      "receiptID" => "r_1",
      "productID" => "p_1",
      "parentProductID" => "p_p_1",
      "productType" => "p_t_1",
      "cancelDate" => nil,
      "quantity" => 1,
      "betaProduct" => false,
      "testTransaction" => false
    }

    expect(
      :hackney, 
      :request, 
      [
        {
          [:get, "https://appstore-sdk.amazon.com/version/1.0/verifyReceiptId/developer/s_1/user/u_1/receiptId/r_1", [{"accept", "application/json"}], "", []],
          {:ok, 200, [], :client}
        }
      ])
    expect(:hackney, :body, 1, {:ok, Poison.encode!(response)})

    assert AmazonIAP.verify_receipt("s_1", "u_1", "r_1") ==
      {:ok, %HTTPoison.Response{
          status_code: 200,
          body: response
        }
      }

    assert validate :hackney
  end

  test "verify_receipt/4" do
    response = %{
      "purchaseDate" => 12345,
      "receiptID" => "r_1",
      "productID" => "p_1",
      "parentProductID" => "p_p_1",
      "productType" => "p_t_1",
      "cancelDate" => nil,
      "quantity" => 1,
      "betaProduct" => false,
      "testTransaction" => false
    }

    expect(
      :hackney, 
      :request, 
      [
        {
          [:get, "http://example.com/amazon-test/verifyReceiptId/developer/s_1/user/u_1/receiptId/r_1", [{"accept", "application/json"}], "", []],
          {:ok, 200, [], :client}
        }
      ])
    expect(:hackney, :body, 1, {:ok, Poison.encode!(response)})

    assert AmazonIAP.verify_receipt("http://example.com/amazon-test", "s_1", "u_1", "r_1") ==
      {:ok, %HTTPoison.Response{
          status_code: 200,
          body: response
        }
      }

    assert validate :hackney
  end
end

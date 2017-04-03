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
    purchase = %AmazonIAP.Purchase{
      item_type: :subscription,
      start_date: DateTime.from_unix!(1490964684, :microsecond),
      end_date: DateTime.from_unix!(1490964684, :microsecond),
      sku: "SKU999",
      purchase_token: "p_1"
    }

    response = %{
      "itemType" => "SUBSCRIPTION",
      "startDate" => 1490964684,
      "endDate" => 1490964684,
      "sku" => "SKU999",
      "purchaseToken" => "p_1"
    }

    expect(
      :hackney, 
      :request, 
      [
        {
          [:get, "https://appstore-sdk.amazon.com/version/2.0/verify/developer/d_1/user/u_1/purchaseToken/p_t_1", [{"accept", "application/json"}], "", []],
          {:ok, 200, [], :client}
        }
      ])
    expect(:hackney, :body, 1, {:ok, Poison.encode!(response)})

    assert {:ok, purchase} == AmazonIAP.verify_receipt("d_1", "u_1", "p_t_1")

    assert validate :hackney
  end

  test "verify_receipt/4" do
    purchase = %AmazonIAP.Purchase{
      item_type: :subscription,
      start_date: DateTime.from_unix!(1490964684, :microsecond),
      end_date: DateTime.from_unix!(1490964684, :microsecond),
      sku: "SKU999",
      purchase_token: "p_1"
    }

    response = %{
      "itemType" => "SUBSCRIPTION",
      "startDate" => 1490964684,
      "endDate" => 1490964684,
      "sku" => "SKU999",
      "purchaseToken" => "p_1"
    }

    expect(
      :hackney, 
      :request, 
      [
        {
          [:get, "http://example.com/amazon-test/verify/developer/d_1/user/u_1/purchaseToken/p_t_1", [{"accept", "application/json"}], "", []],
          {:ok, 200, [], :client}
        }
      ])
    expect(:hackney, :body, 1, {:ok, Poison.encode!(response)})

    assert {:ok, purchase} == AmazonIAP.verify_receipt("http://example.com/amazon-test", "d_1", "u_1", "p_t_1")

    assert validate :hackney
  end

  test "error is returned from amazon" do
    expect(
      :hackney, 
      :request, 
      [
        {
          [:get, "http://example.com/amazon-test/verify/developer/d_1/user/u_1/purchaseToken/p_t_1", [{"accept", "application/json"}], "", []],
          {:ok, 498, [], :client}
        }
      ])
    expect(:hackney, :body, 1, {:ok, ""})

    assert {:error, "Invalid Purchase Token."} == AmazonIAP.verify_receipt("http://example.com/amazon-test", "d_1", "u_1", "p_t_1")

    assert validate :hackney
  end
end

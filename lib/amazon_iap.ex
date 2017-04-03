defmodule AmazonIAP do
  @moduledoc """
  Documentation for AmazonIAP.
  """

  alias AmazonIAP.Client

  @production_endpoint "https://appstore-sdk.amazon.com/version/2.0"

  defmodule Purchase do
    defstruct(item_type: nil,
              start_date: nil,
              end_date: nil,
              sku: nil,
              purchase_token: nil)
  end

  @doc """
  Verifies a receipt with Amazon

  Args:
    * `developer_secret`- Your app's shared secret
    * `user_id` - The Amazon customer of your app
    * `purchase_token` - The receipt ID of the purchase
  """
  @spec verify_receipt(String.t, String.t, String.t) :: HTTPoison.Response
  def verify_receipt(developer_secret, user_id, purchase_token), do: do_verify_receipt(@production_endpoint, developer_secret, user_id, purchase_token)

  @doc """
  Verifies a receipt with Amazon

  Args:
    * `endpoint` - Custom testing server instance
    * `developer_secret`- Your app's shared secret
    * `user_id` - The Amazon customer of your app
    * `purchase_token` - The receipt ID of the purchase
  """
  @spec verify_receipt(String.t, String.t, String.t, String.t) :: HTTPoison.Response
  def verify_receipt(endpoint, developer_secret, user_id, purchase_token), do: do_verify_receipt(endpoint, developer_secret, user_id, purchase_token)

  defp do_verify_receipt(endpoint, developer_secret, user_id, purchase_token) do
    case Client.get("#{endpoint}/verify/developer/#{developer_secret}/user/#{user_id}/purchaseToken/#{purchase_token}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, %Purchase{
                                item_type: body["itemType"] |> String.downcase |> String.to_atom,
                                start_date: DateTime.from_unix!(body["startDate"], :microsecond),
                                end_date: DateTime.from_unix!(body["endDate"], :microsecond),
                                sku: body["sku"],
                                purchase_token: body["purchaseToken"]
                              }}
      {:error, error} -> {:error, error.reason}
    end
  end
end

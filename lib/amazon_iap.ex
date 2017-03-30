defmodule AmazonIAP do
  @moduledoc """
  Documentation for AmazonIAP.
  """

  alias AmazonIAP.Client

  @production_endpoint "https://appstore-sdk.amazon.com/version/1.0"

  @doc """
  Verifies a receipt with Amazon

  Args:
    * `developer_secret`- Your app's shared secret
    * `user_id` - The Amazon customer of your app
    * `receipt_id` - The receipt ID of the purchase
  """
  @spec verify_receipt(String.t, String.t, String.t) :: HTTPoison.Response
  def verify_receipt(developer_secret, user_id, receipt_id), do: do_verify_receipt(@production_endpoint, developer_secret, user_id, receipt_id)

  @doc """
  Verifies a receipt with Amazon

  Args:
    * `endpoint` - Custom testing server instance
    * `developer_secret`- Your app's shared secret
    * `user_id` - The Amazon customer of your app
    * `receipt_id` - The receipt ID of the purchase
  """
  @spec verify_receipt(String.t, String.t, String.t, String.t) :: HTTPoison.Response
  def verify_receipt(endpoint, developer_secret, user_id, receipt_id), do: do_verify_receipt(endpoint, developer_secret, user_id, receipt_id)

  defp do_verify_receipt(endpoint, developer_secret, user_id, receipt_id) do
    Client.get("#{endpoint}/verifyReceiptId/developer/#{developer_secret}/user/#{user_id}/receiptId/#{receipt_id}")
  end
end

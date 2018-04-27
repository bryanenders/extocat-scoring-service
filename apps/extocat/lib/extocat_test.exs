defmodule ExtocatTest do
  use ExUnit.Case, async: true

  doctest Extocat

  test "unable to reach GitHub" do
    assert {:error, :timeout} === Extocat.fetch_score("timeout-lord")
  end

  test "a missing user" do
    assert {:error, :not_found} === Extocat.fetch_score("the-name-of-the-doctor")
  end

  test "a user without any events" do
    assert {:ok, 0} === Extocat.fetch_score("peter-cushing")
  end

  test "a user with a PushEvent" do
    assert {:ok, 5} === Extocat.fetch_score("david-tennant")
  end

  test "a user with a PullRequestReviewCommentEvent" do
    assert {:ok, 4} === Extocat.fetch_score("tom-baker")
  end

  test "a user with a WatchEvent" do
    assert {:ok, 3} === Extocat.fetch_score("peter-capaldi")
  end

  test "a user with a CreateEvent" do
    assert {:ok, 2} === Extocat.fetch_score("jon-pertwee")
  end

  test "a user with an unrecognized event" do
    assert {:ok, 1} === Extocat.fetch_score("matt-smith")
  end

  test "a user with a mix of events" do
    assert {:ok, 21} === Extocat.fetch_score("jodie-whittaker")
  end
end

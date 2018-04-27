# Extocat Scoring Service

![](https://octodex.github.com/images/labtocat.png "The Labtocat by @JohnCreek")

## About

In this project we will be computing “scorecards” for GitHub users based on a stream of events and providing one or more routes to surface this data.

Events and their importance (represented by a score) are presented here:

| Event Type                    | Points |
| :---------------------------- | -----: |
| PushEvent                     |      5 |
| PullRequestReviewCommentEvent |      4 |
| WatchEvent                    |      3 |
| CreateEvent                   |      2 |
| Every other event             |      1 |

## Usage

To start the server:

  1. Install dependencies with `mix deps.get`

  2. Start service with `mix run --no-halt`

Now you can hit `http://localhost:4000/:username`, where `:username` is a GitHub username.

## Testing & Analysis

This project is tested and configured to support static analysis by both [Dialyzer](http://erlang.org/doc/man/dialyzer.html) and [Credo](https://github.com/rrrene/credo).

To run tests: `mix test`

To run Dialyzer: `mix dialyzer`

To run Credo: `mix credo`

To run Dialyzer, Credo, and tests anytime a file is changed: `mix test.watch`

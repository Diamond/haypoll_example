// Import the Socket calls from phoenix.js
import { Socket } from "deps/phoenix/web/static/js/phoenix"

class LivePoller {
  constructor() {
    // If the element we're expecting doesn't exist on the page,
    // just exit out of the whole thing
    if (!$("#poll-id").length) { return }
    // Set up our channel for Polls
    this.pollChannel = this._setupPollChannel()
    // Set up each of the voting buttons
    this._setupVoteButtons(this.pollChannel)
    // And setup our graph
    this._setupGraph()
  }
  _createSocket() {
    // Open up a new websocket connection
    let socket = new Socket("/socket")
    // And then connect to it
    socket.connect()
    // When we successfully open the connection, log out to the console that
    // we succeeded.
    socket.onOpen(() => console.log("Connected"))
    // And return out the socket
    return socket
  }
  _setupPollChannel() {
    // Call our createSocket() function above and store the created socket
    let socket = this._createSocket()
    // And grab the id of the poll we're subscribing to
    let pollId = $("#poll-id").val()
    // Next, specify that we want to join a polls channel of the polls: with the poll id.
    // Remember our code in PollChannel.ex that looked like: "polls:" <> poll_id
    let pollChannel = socket.channel("polls:" + pollId)
    // Set up a handler for when the channel receives a new_vote message
    pollChannel.on("new_vote", vote => {
      // Update the voted item's display
      this._updateDisplay(vote.entry_id)
      // And update the graph, since we have new data
      this._updateGraph()
    })
    // Set up a handler for when the channel receives a close message
    pollChannel.on("close", status => {
      if (status.closed) {
        $("a.vote").addClass("hidden")
        $("#poll-closed").text("true")
      } else {
        $("a.vote").removeClass("hidden")
        $("#poll-closed").text("false")
      }
    })
    // Finally, join the channel we created. On success, let the console know that we joined.
    // On failure, tell us why it errored out.
    pollChannel
      .join()
      .receive("ok", resp => { console.log("Joined") })
      .receive("error", reason => { console.log("Error: ", reason) })
    // Finally, return the whole channel we've created; we'll need that to push
    // messages out later.
    return pollChannel
  }
  _updateDisplay(entryId) {
    // Iterate over each entry
    $.each($("li.entry"), (index, li) => {
      // If the entry ids match, update the number of votes for that element
      if (entryId == li.data("entry-id")) {
        // Get the number of current votes, parse it as an integer, and add one
        let newVotes = +(li.find(".votes").text()) + 1
        // And update the display for that entry
        this._updateEntry(li, newVotes)
      }
    })
  }
  _updateEntry(li, newVotes) {
    // Find the .votes span and update it to whatever the new votes value is
    li.find(".votes").text(newVotes)
  }
  _setupVoteButtons(pollChannel) {
    // Set up our default click handler for votes
    $(".vote").on("click", event => {
      event.preventDefault()
      // Find the containing list item
      let li = $(event.currentTarget).parents("li")
      // Grab the entry id for what the user voted on
      let entryId = li.data("entry-id")
      // And then push a new_vote message with the entry id onto the channel
      pollChannel.push("new_vote", { entry_id: entryId })
    })
  }
  _setupGraph() {
    // Load the visualiztion library and corechart packages
    google.load("visualization", "1", { packages: ["corechart"] })
    // And setup a callback for when the load completes
    google.setOnLoadCallback(() => {
      // Create a new pie chart; we can't use jquery for this
      this.chart = new google.visualization.PieChart(document.getElementById("my-chart"))
      // And update the graph from the new data
      this._updateGraph()
    })
  }
  _updateGraph() {
    // Grab the current state of data for the graph
    let data = this._getGraphData()
    // Convert the data into a Google Charts appropriate format
    var convertedData = google.visualization.arrayToDataTable(data)
    // And draw the graph, and we'll make it 3d and fancy
    this.chart.draw(convertedData, { title: "Poll", is3D: true })
  }
  _getGraphData() {
    // Set up our legend
    var data = [["Choice", "Votes"]]
    // And iterate over each list item
    $.each($("li.entry"), (index, li) => {
      // Grab the title
      let title = $(li).find(".title").text()
      // And grab the integer version of the number of votes
      let votes = +($(li).find(".votes").text())
      // And push the result onto our array
      data.push([title, votes])
    })
    // And return our finished array of data out
    return data
  }
}

export { LivePoller }

export var Poll = {
  load() {
    // Set up the "Add Entry" button on the page
    this.setupAddEntry()
    // And set up the "Remove Entry" buttons on the page
    this.setupRemoveEntry()
  },
  setupAddEntry() {
    // When add entry is clicked, clone the top entry
    $("#add-entry").on("click", this.cloneEntry)
  },
  setupRemoveEntry() {
    // When remove entry is clicked, remove the appropriate row
    $("#entries").on("click", "a.remove-entry", this.removeEntry)
  },
  removeEntry(event) {
    // Find the target, find its parent row, and remove the whole thing
    $(event.currentTarget).parents(".entry").remove()
  },
  cloneEntry() {
    // Clone the top entry
    var newEntry = $("#entries .entry:first").clone()
    // Reset its value to blank
    newEntry.find("input[type=text]").val("")
    // And then throw it into the entry list
    newEntry.appendTo("#entries")
    // And then focus that text entry
    newEntry.find("input[type=text]").focus()
  }
}

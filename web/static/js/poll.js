export class Poll {
  constructor() {
    // Set up the "Add Entry" button on the page
    this._setupAddEntry()
    // And set up the "Remove Entry" buttons on the page
    this._setupRemoveEntry()
  }
  _setupAddEntry() {
    // When add entry is clicked, clone the top entry
    $("#add-entry").on("click", this._cloneEntry)
  }
  _setupRemoveEntry() {
    // When remove entry is clicked, remove the appropriate row
    $("#entries").on("click", "a.remove-entry", this._removeEntry)
  }
  _removeEntry(event) {
    // Find the target, find its parent row, and remove the whole thing
    $(event.currentTarget).parents(".entry").remove()
  }
  _cloneEntry() {
    // Clone the top entry
    let newEntry = $("#entries .entry:first").clone()
    // Reset its value to blank
    newEntry.find("input[type=text]").val("")
    // And then throw it into the entry list
    newEntry.appendTo("#entries")
    // And then focus that text entry
    newEntry.find("input[type=text]").focus()
  }
}

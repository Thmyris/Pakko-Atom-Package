PakkoView = require './pakko-view'
{CompositeDisposable} = require 'atom'

module.exports = Pakko =
  pakkoView: null
  pakkoDecoration: null
  subscriptions: null

  activate: (state) ->
    @pakkoView = new PakkoView(state.pakkoViewState)
    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'pakko:slide': => @slide()

    atom.workspace.observeTextEditors (editor) ->
      editor.observeCursors (cursor) ->
        cursor.onDidChangePosition (event) ->
          if event.cursor.isInsideWord({ wordRegex: "[pP][aA][kK][kK][oO]" })
            Pakko.pakkoDecoration = editor.decorateMarker(event.cursor.getMarker(), {type: 'overlay', class: 'my-line-class', item:Pakko.pakkoView})
          else
            Pakko.pakkoDecoration.destroy() if Pakko.pakkoDecoration

  deactivate: ->
    @pakkoDecoration.destroy()
    @subscriptions.dispose()
    @pakkoView.destroy()

  serialize: ->
    pakkoViewState: @pakkoView.serialize()

  slide: ->
    console.log 'weee'

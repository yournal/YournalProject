module.exports.schema = ($mongoose) ->
  new $mongoose.Schema(
    title:
      type: String,
      required: true
    description:
      type: String,
      required: true
  )

module.exports.model = ($connection, JournalSchema) ->
  $connection.model('Journal', JournalSchema)

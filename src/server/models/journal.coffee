exports.schema = {}
exports.model = {}

exports.schema.JournalSchema = ($mongoose) ->
  new $mongoose.Schema(
    title:
      type: String,
      required: true
    description:
      type: String,
      required: true
  )

exports.model.JournalModel = ($connection, JournalSchema) ->
  $connection.model('Journal', JournalSchema)

exports.schema = {}
exports.model = {}

exports.schema.JournalSchema = ($mongoose) ->
  new $mongoose.Schema(
    title:
      type: String,
      required: true,
      default: 'Demonstration Journal'
    description:
      type: String,
      required: true,
      default: 'This is a description.'
  )

exports.model.JournalModel = ($connection, JournalSchema) ->
  $connection.model('Journal', JournalSchema)

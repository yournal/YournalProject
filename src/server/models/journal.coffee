exports.JournalSchema = ($mongoose) ->
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

exports.JournalModel = ($connection, JournalSchema) ->
  $connection.model('Journal', JournalSchema)

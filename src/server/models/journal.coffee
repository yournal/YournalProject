module.exports.schema = ($mongoose, YearSchema) ->
  new $mongoose.Schema(
    title:
      type: String,
      required: true
    description:
      type: String,
      required: true
    years:
      type: [YearSchema]
  )

module.exports.model = ($connection, JournalSchema) ->
  $connection.model('Journal', JournalSchema)

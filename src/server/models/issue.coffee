module.exports.schema = ($mongoose, SectionSchema) ->
  new $mongoose.Schema(
    number:
      type: Number,
      required: true
    sections:
      type: [SectionSchema]
      required: true
  )

module.exports.model = ($connection, IssueSchema) ->
  $connection.model('Issue', IssueSchema)

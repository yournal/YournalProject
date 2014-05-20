module.exports.schema = ($mongoose, ArticleSchema) ->
  new $mongoose.Schema(
    title:
      type: String,
      required: true
    abbreviation:
      type: String,
      required: true
    policyStatement:
      type: String
      required: true
    articles:
      type: [ArticleSchema]
  )

module.exports.model = ($connection, SectionSchema) ->
  $connection.model('Section', SectionSchema)

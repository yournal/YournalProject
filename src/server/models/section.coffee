exports.schema = {}
exports.model = {}

exports.schema.SectionSchema = ($mongoose, ArticleSchema) ->
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

exports.model.SectionModel = ($connection, SectionSchema) ->
  $connection.model('Section', SectionSchema)

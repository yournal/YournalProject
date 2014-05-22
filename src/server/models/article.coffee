exports.schema = {}
exports.model = {}

exports.schema.ArticleSchema = ($mongoose) ->
  new $mongoose.Schema(
    title:
      type: String,
      required: true
    authors:
      type: [String]
      required: true
    keywords:
      type: [String]
    abstract:
      type: String
      required: true
    content:
      type: String
      required: true
  )

exports.model.ArticleModel = ($connection, ArticleSchema) ->
  $connection.model('Article', ArticleSchema)

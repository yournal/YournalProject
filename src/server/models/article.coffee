module.exports.schema = ($mongoose) ->
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

module.exports.model = ($connection, ArticleSchema) ->
  $connection.model('Article', ArticleSchema)

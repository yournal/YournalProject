module.exports.schema = function($mongoose) {
  return new $mongoose.Schema({
    title: {
      type: String,
      required: true
    },
    authors: {
      type: [String],
      required: true
    },
    keywords: {
      type: [String],
      required: true
    },
    abstract: {
      type: String,
      required: true
    },
    content: {
      type: String,
      required: true
    }
  });
};

module.exports.model = function($connection, ArticleSchema) {
  return $connection.model('Article', ArticleSchema);
};

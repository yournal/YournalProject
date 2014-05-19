module.exports.schema = function($mongoose, ArticleSchema) {
  return new $mongoose.Schema({
    title: {
      type: String,
      required: true
    },
    abbreviation: {
      type: String,
      required: true
    },
    policyStatement: {
      type: String,
      required: true
    },
    articles: {
      type: [ArticleSchema],
      required: true
    }
  });
};

module.exports.model = function($connection, SectionSchema) {
  return $connection.model('Section', SectionSchema);
};

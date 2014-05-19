module.exports.schema = function($mongoose, SectionSchema) {
  return new $mongoose.Schema({
    number: {
      type: Number,
      required: true
    },
    sections: {
      type: [SectionSchema],
      required: true
    }
  });
};

module.exports.model = function($connection, IssueSchema) {
  return $connection.model('Issue', IssueSchema);
};

module.exports.schema = function($mongoose, YearSchema) {
  return new $mongoose.Schema({
    title: {
      type: String,
      required: true
    },
    description: {
      type: String,
      required: true
    },
    years: {
      type: [YearSchema],
      required: true
    }
  });
};

module.exports.model = function($connection, JournalSchema) {
  return $connection.model('Journal', JournalSchema);
};

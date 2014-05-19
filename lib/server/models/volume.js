module.exports.schema = function($mongoose, IssueSchema) {
  return new $mongoose.Schema({
    number: {
      type: Number,
      required: true
    },
    issues: {
      type: [IssueSchema],
      required: true
    }
  });
};

module.exports.model = function($connection, VolumeSchema) {
  return $connection.model('Volume', VolumeSchema);
};

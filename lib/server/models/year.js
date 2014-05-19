module.exports.schema = function($mongoose, VolumeSchema) {
  return new $mongoose.Schema({
    number: {
      type: Number,
      required: true
    },
    volumes: {
      type: [VolumeSchema],
      required: true
    }
  });
};

module.exports.model = function($connection, YearSchema) {
  return $connection.model('Year', YearSchema);
};

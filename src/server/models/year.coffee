module.exports.schema = ($mongoose, VolumeSchema) ->
  new $mongoose.Schema(
    number:
      type: Number,
      required: true
    volumes:
      type: [VolumeSchema]
      required: true
  )

module.exports.model = ($connection, YearSchema) ->
  $connection.model('Year', YearSchema)

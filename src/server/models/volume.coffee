module.exports.schema = ($mongoose, IssueSchema) ->
  new $mongoose.Schema(
    number:
      type: Number,
      required: true
    issues:
      type: [IssueSchema]
  )

module.exports.model = ($connection, VolumeSchema) ->
  $connection.model('Volume', VolumeSchema)

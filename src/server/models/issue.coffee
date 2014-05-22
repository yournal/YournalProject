exports.schema = {}
exports.model = {}

exports.schema.IssueSchema = ($mongoose, SectionSchema) ->
  IssueSchema = new $mongoose.Schema(
    year:
      type: Number,
      required: true
    volume:
      type: Number,
      required: true
    number:
      type: Number,
      required: true
    sections:
      type: [SectionSchema]
  )

  IssueSchema.index
    year: 1
    volume: 1
    number: 1
  ,
    unique: true

  return IssueSchema

exports.model.IssueModel = ($connection, IssueSchema) ->
  $connection.model('Issue', IssueSchema)
